import com.intellij.execution.ExecutionManager
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.vfs.VirtualFileManager
import com.intellij.psi.PsiAnnotation
import com.intellij.psi.PsiElement
import com.intellij.psi.PsiFile
import com.intellij.psi.PsiMethod
import com.intellij.psi.PsiModifier
import com.intellij.psi.PsiModifierList
import com.intellij.psi.util.PsiTreeUtil
import com.intellij.util.net.NetUtils;
import com.intellij.execution.ExecutionTargetManager
import com.intellij.execution.ExecutorRegistry
import com.intellij.execution.ProgramRunnerUtil
import com.intellij.execution.RunManager
import com.intellij.execution.RunnerRegistry
import com.intellij.execution.configurations.ConfigurationType
import com.intellij.execution.configurations.GeneralCommandLine
import com.intellij.execution.configurations.RunConfiguration
import com.intellij.execution.console.RunIdeConsoleAction
import com.intellij.execution.executors.DefaultDebugExecutor
import com.intellij.execution.executors.DefaultRunExecutor
import com.intellij.execution.filters.ExceptionFilter
import com.intellij.execution.filters.TextConsoleBuilderFactory
import com.intellij.execution.process.DefaultJavaProcessHandler
import com.intellij.execution.process.KillableColoredProcessHandler
import com.intellij.execution.process.ProcessHandler
import com.intellij.execution.remote.RemoteConfigurationType
import com.intellij.execution.runners.ExecutionEnvironment
import com.intellij.execution.runners.ProgramRunner
import com.intellij.execution.ui.RunContentDescriptor
import com.intellij.ide.scratch.ScratchFileActions
import com.intellij.ide.scratch.ScratchFileService
import com.intellij.openapi.actionSystem.ActionManager
import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.actionSystem.DataContext
import com.intellij.openapi.actionSystem.DataKeys
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.editor.Caret
import com.intellij.openapi.editor.Document
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.editor.actionSystem.EditorAction
import com.intellij.openapi.editor.actionSystem.EditorActionHandler
import com.intellij.openapi.editor.event.DocumentEvent
import com.intellij.openapi.editor.event.DocumentListener
import com.intellij.openapi.keymap.KeymapManager
import com.intellij.openapi.keymap.impl.ActionProcessor
import com.intellij.openapi.project.Project
import com.intellij.openapi.project.ProjectManager
import com.intellij.openapi.vfs.LocalFileSystem
import com.intellij.openapi.wm.StatusBar
import com.intellij.openapi.wm.ToolWindow
import com.intellij.openapi.wm.ToolWindowAnchor
import com.intellij.openapi.wm.ToolWindowManager
import com.intellij.openapi.util.TextRange;
import com.intellij.psi.PsiClass
import com.intellij.psi.PsiDocumentManager
import com.intellij.psi.PsiJavaFile
import com.intellij.psi.PsiManager
import com.intellij.psi.search.FilenameIndex
import com.intellij.psi.search.GlobalSearchScope
import com.intellij.psi.search.PsiShortNamesCache
import com.intellij.tools.Tool
import com.intellij.tools.ToolsProvider
import com.intellij.xdebugger.settings.DebuggerConfigurableProvider
import com.intellij.openapi.util.io.StreamUtil;

import java.awt.*
import java.nio.channels.SocketChannel

action = { name, shortcut = null, perform = null ->
    println('Registering ' + name)
    km = KeymapManager.getInstance()
    ActionManager am = ActionManager.getInstance()
    am.unregisterAction(name)
    km.getActiveKeymap().removeAllActionShortcuts(name)

    if (perform == null) {
        return
    }

    am.registerAction(name, perform)
    if (shortcut != null) {
        km.getActiveKeymap().
                addShortcut(name, new com.intellij.openapi.actionSystem.KeyboardShortcut(
                        javax.swing.KeyStroke.getKeyStroke(shortcut), null))
    }
}

interface Command {

    void execute(DataContext dataContext);
}

class TmuxCommand implements Command {

    String cmd;

    TmuxCommand(String cmd) {
        this.cmd = cmd
    }

    @Override
    void execute(DataContext dataContext) {
        ApplicationManager.getApplication().saveAll()
        Fn.execInTmux(cmd)
    }
}

class BlazeDebugCommand implements Command {

    TmuxCommand cmd;

    BlazeDebugCommand(TmuxCommand cmd) {
        this.cmd = cmd
    }

    @Override
    void execute(DataContext dataContext) {
        cmd.execute(dataContext)
        Fn.startDebug(dataContext)
    }
}

class Fn {
    public static G3 = new File("/usr/local/google/home/joetoth/projects/f/google3")
    private static Map<String, String> blazePathCache = new HashMap<>();
    private static Map<String, String> blazeTestPathCache = new HashMap<>();
    private static Map<String, Long> blazeBuildCache = new HashMap<>();
    private static Command lastCommand;

    static def pool = { c -> application.executeOnPooledThread(c) }

    public static String getBlazeTarget(String relativeGoogle3Path) {
        def blazePath = blazePathCache.get(relativeGoogle3Path)
        if (blazePath == null) {
            blazePath = execCmd("blaze query $relativeGoogle3Path")
            blazePathCache.put(relativeGoogle3Path, blazePath)
        }
        return blazePath
    }

    public static String getBlazeTestPath(String relativeGoogle3Path) {
        def blazePath = blazeTestPathCache.get(relativeGoogle3Path)
        if (blazePath == null) {
            def buildLabel = execCmd("blaze query $relativeGoogle3Path")
            def pkg = buildLabel.substring(0, buildLabel.lastIndexOf(":"))
            blazePath = execCmd("blaze query kind('[java_,gwt_].*test',allpaths($pkg:all,$buildLabel))")
            blazeTestPathCache.put(relativeGoogle3Path, blazePath)
        }
        return blazePath
    }

    public static blazeBuild(String blazePath) {
        if (!blazeBuildCache.containsKey(blazePath)) {
            execInTmux("blaze build $blazePath")
            blazeBuildCache.put(blazePath, System.currentTimeMillis())
        }
    }

    public static String execCmd(String cmd) throws java.io.IOException {
        println(cmd)
        def r = Runtime.getRuntime().exec(cmd, null, G3)
        r.waitFor()
        def w = r.exitValue()
        if (w != 0) {
            def err = StreamUtil.readText(r.getErrorStream())
            println err
            return
        }
        def o = StreamUtil.readText(r.getInputStream())
        StringTokenizer st = new StringTokenizer(o, "\n", false)
        def p
        while (st.hasMoreTokens()) {
            p = st.nextToken()
        }
        return p
    }

    public static Command setLastCommand(Command c) {
        lastCommand = c;
        return c
    }

    public static void runLastCommand(DataContext dataContext) {
        lastCommand.execute(dataContext)
    }

    public static void execInTmux(String cmd) {
        cmd = cmd.replaceAll('"', '\\\\\"')
        println("TMUX:: " + cmd)
        def x = "tmux send-keys -t f:1 \"" + cmd + "\" Enter"
        def cc = new String[3]
        cc[0] = "/bin/bash"
        cc[1] = "-c"
        cc[2] = x
        Runtime.getRuntime().exec(cc);
    }

    static boolean polling = false;

    public static void startDebug(DataContext dataContext) {
        if (polling) return

        ApplicationManager.application.executeOnPooledThread ({
                polling = true;
                while (true) {
                    if (NetUtils.canConnectToSocket("localhost", 5005)) {
                        println("connected!")
                        break;
                    }
                    println("waiting...")
                    Thread.sleep(200)
                }
                polling = false;

                ApplicationManager.application.invokeLater(new Runnable() {

                    @Override
                    void run() {

                        def project = DataKeys.PROJECT.getData(dataContext)

                        for (def rc : RunManager.getInstance(project).
                                getConfigurationSettingsList(RemoteConfigurationType.instance)) {
                            println(rc.name)
                            if (rc.name == "5005") {
                                ProgramRunnerUtil.
                                        executeConfiguration(project, rc,
                                                DefaultDebugExecutor.debugExecutorInstance)
                            }
                        }
                    }
                })
        })
    }

    public static PsiClass findEnclosingClass(PsiElement e) {
        while ((e = e.parent) != null) {
            if (e instanceof PsiClass) {
                return e
            }
        }
    }

    public static String findSuiteSize(PsiModifierList list) {
        for (def m : list.children) {
            println(m.text)
            if (m instanceof PsiAnnotation) {
                def clsName = m.qualifiedName.substring(m.qualifiedName.lastIndexOf(".") + 1)
                if (clsName == "SmallTest" || clsName == "MediumTest" || clsName == "LargeTest") {
                    return clsName + "s"
                }
            }
        }
        return null
    }

    public static PsiClass findClass(PsiFile f) {
        for (def c : f.children) {
            if (c instanceof PsiClass) {
                return c
            }
        }

        throw new RuntimeException("Could not find class for: " + f)
    }

    public static boolean isJunit4(psiClass) {
        PsiModifierList psiModifierList = psiClass.getModifierList();
        PsiAnnotation[] annotations = psiModifierList.getAnnotations();
        for(def a : annotations) {
            if (a.name == "RunWith") {
                return true
            }
        }
        return false
    }

    public static String google3RelativeFilePath(DataContext dataContext) {
        def file = DataKeys.VIRTUAL_FILE.getData(dataContext)
        return file.canonicalPath.substring(file.canonicalPath.indexOf("google3") + 8)
    }

    public static String google3(DataContext dataContext) {
        def file = DataKeys.VIRTUAL_FILE.getData(dataContext);
        return file.canonicalPath.substring(0, file.canonicalPath.indexOf("google3") + 8)
    }
}

class WrapEditorAction extends EditorAction {

    WrapEditorAction(defaultHandler) {
        super(defaultHandler)
    }
}

class CopyClipboardSelectedFile extends EditorActionHandler {

    CopyClipboardSelectedFile() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        def file = Fn.google3RelativeFilePath(dataContext)
        println("Copied: " + file)
        def stringSelection = new java.awt.datatransfer.StringSelection(file);
        Toolkit.getDefaultToolkit().getSystemClipboard().setContents(stringSelection, null);
    }
}

class OpenWithCodeSearch extends EditorActionHandler {

    OpenWithCodeSearch() {
        super(false)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        def file = DataKeys.VIRTUAL_FILE.getData(dataContext);
        def cs = "google-chrome http://cs/" + file.name
        println(cs)
        new Runtime().exec(cs)
    }
}

class BlazeBuildSelectedFile extends EditorActionHandler {

    BlazeBuildSelectedFile() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        ApplicationManager.getApplication().saveAll();
        print("MOOOO")
        def file = Fn.google3RelativeFilePath(dataContext)
        def blazeTarget = Fn.getBlazeTarget(file)
        Fn.blazeBuild(blazeTarget)
    }
}

class BlazeTest extends EditorActionHandler {

    BlazeTest() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        ApplicationManager.getApplication().saveAll();
        def blazePath = Fn.google3RelativeFilePath(dataContext)
        blazePath = blazePath.replaceAll("java/", "javatests/")
        blazePath = blazePath.substring(0, blazePath.lastIndexOf("/"))
        Fn.setLastCommand(
                new TmuxCommand("blaze test $blazePath:all --test_output=streamed --test_strategy=local")).execute(dataContext)
    }
}


class BlazeDebug extends EditorActionHandler {

    BlazeDebug() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        ApplicationManager.getApplication().saveAll();

        def file = DataKeys.VIRTUAL_FILE.getData(dataContext);
        def psiFile = DataKeys.PSI_FILE.getData(dataContext)
        def relativeGoogle3Path = file.path.substring(file.canonicalPath.indexOf("google3") + 8)

        // TODO: if not javatests use a javatests path
        // blazePath = blazePath.replaceAll("java/", "javatests/")
        // blazePath = blazePath.substring(0, blazePath.lastIndexOf("/"))

        // If in javatests and inside method filter on that method
        def testFilter = ""
        if (relativeGoogle3Path.startsWith("javatests")) {
            def c = Fn.findClass(psiFile)
            def separator = Fn.isJunit4(c) ? "." : "#";
            for (PsiMethod m : c.methods) {
                if (m.textRange.contains(caret.leadSelectionOffset)) {
                    testFilter = "--test_filter='\"$c.qualifiedName$separator$m.name\"'"
                    break;
                }
            }
        }


        ApplicationManager.application.executeOnPooledThread({
            def blazePath = Fn.getBlazeTestPath(relativeGoogle3Path)
            blazePath = blazePath.substring(0, blazePath.indexOf(":")) + ":all"
            Fn.blazeBuild(blazePath)

            Command cmd = new Command() {

                @Override
                void execute(DataContext d) {
                    ApplicationManager.getApplication().saveAll()
                    def extraBlaze = "--experimental_persistent_javac --worker_max_instances=32 --experimental_use_local_machine_with_forge --strategy=javac=worker --genrule_strategy=local "
                    Fn.execInTmux("blaze test --java_debug $extraBlaze $testFilter $blazePath --test_output=streamed")
                    Fn.startDebug(d)
                }
            }
            ApplicationManager.application.invokeLater({
                Fn.setLastCommand(cmd).execute(dataContext)
            })
        })

    }
}

class Open extends EditorActionHandler {

    Open() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        def run = caret.getSelectedText()
        if (run == null) {
            run = editor.getDocument().getText(new TextRange(caret.getVisualLineStart(), caret.getVisualLineEnd()))
        }
        def stringSelection = new java.awt.datatransfer.StringSelection(run);
        Toolkit.getDefaultToolkit().getSystemClipboard().setContents(stringSelection, null);
        Fn.execInTmux("%paste")
    }
}

class OpenBlazeBuild extends EditorActionHandler {

    OpenBlazeBuild() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        def file = DataKeys.VIRTUAL_FILE.getData(dataContext);
        def project = DataKeys.PROJECT.getData(dataContext)
        def buildPath = file.path.substring(0, file.path.lastIndexOf("/")) + "/BUILD"
        def buildFile = VirtualFileManager.getInstance().findFileByUrl("file://" + buildPath)
        FileEditorManager.getInstance(project).openFile(buildFile, true)
    }
}

class LastCommand extends EditorActionHandler {

    LastCommand() {
        super(true)
    }

    @Override
    void doExecute(Editor editor, Caret caret, DataContext dataContext) {
        Fn.runLastCommand(dataContext)
    }
}

action("CurrentFileRelativeGoogle3PathCopyClipboard", shortcut = null,
        new WrapEditorAction(new CopyClipboardSelectedFile()))

action("OpenWithCodeSearch", shortcut = null,
        new WrapEditorAction(new OpenWithCodeSearch()))

action("BlazeDebug", shortcut = null,
        new WrapEditorAction(new BlazeDebug()))

action("OpenBlazeBuild", shortcut = null,
        new WrapEditorAction(new OpenBlazeBuild()))

action("BlazeBuildSelectedFile", shortcut = null,
        new WrapEditorAction(new BlazeBuildSelectedFile()))

action("BlazeTest", shortcut = null,
        new WrapEditorAction(new BlazeTest()))

action("LastCommand", shortcut = null,
        new WrapEditorAction(new LastCommand()))

action("SendKeys", shortcut = null,
        new WrapEditorAction(new Open()))
