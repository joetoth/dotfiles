package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

func main() {
	G3 := "/usr/local/google/home/joetoth/projects/xfp/google3/"
	f, err := os.OpenFile("/usr/local/google/home/joetoth/openjt.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		fmt.Println("file open", err)
	}
	defer f.Close()
	log.SetOutput(f)

	log.Println("This is a test log entry")

	stats, err := os.Stdin.Stat()
	if err != nil {
		log.Println("file.Stat()", err)
		return
	}

	if stats.Size() < 0 {
		log.Println("Nothing on STDIN")
		return
	}

	b, err := ioutil.ReadAll(os.Stdin)
	in := string(b)

	URL := regexp.MustCompile("(https?:\\/\\/)+([a-z\\.]{1,6})([\\/\\w \\.-]*)*\\/?")

	log.Println("Processing:" + in)
	var c *exec.Cmd
	if URL.MatchString(in) {
		found := URL.FindAllString(in, -1)
		c = exec.Command("google-chrome", "--new-window", found[0])
	}

	// javatests/com/z/t/pub/api/gwt/backend/BackendModuleTest.java:16: error: cannot find symbol
	// ERROR: /usr/local/z/home/joetoth/projects/xfp/z3/javatests/com/z/t/pub/api/gwt/backend/BUILD:64:1: no such target '//java/com/z/t/pub/api/gwt/backend:BackendModule': target 'BackendModule' not declared in package 'java/com/z/t/pub/api/gwt/backend' defined by /usr/local/z/home/joetoth/projects/xfp/z3/java/com/z/t/pub/api/gwt/backend/BUILD and referenced by '//javatests/com/z/t/pub/api/gwt/backend:backend-module-test'.
	// at com.z.t.pub.api.stubby.client.ClientModule$RpcStubParametersProvider.<init>(ClientModule.java:54)
	// at com.z.net.ggg.runtime.inject.gggServiceModule.bindBlockingClient(gggServiceModule.java:142) (via modules: com.z.inject.util.Modules$OverrideModule -> com.z.t.pub.api.gwt.backend.BindingsModule -> com.z.t.pub.api.gwt.backend.BackendModule -> com.z.net.ggg.runtim e.inject.gggServiceModule$Builder$1)

	if c == nil {
		STACKTRACE := regexp.MustCompile(`(?sm).*?((?:java|javatests).*\.java)(?::(\d*))?.*`)
		if STACKTRACE.MatchString(in) {
			found := STACKTRACE.FindStringSubmatch(in)
			file := strings.TrimSpace(found[1])
			log.Println("FILE=" + file)

			if len(found) == 3 {
				line := strings.TrimSpace(found[2])
				log.Println("LINE=" + line)
				c = exec.Command("idea", G3+file, "--line", line)
			} else {
				c = exec.Command("idea", G3+file)
			}

		}
	}

	log.Println(c)
	e := c.Start()
	if e != nil {
		log.Fatal(err)
		return
	}
	e = c.Wait()
	if e != nil {
		log.Fatal(err)
		return
	}
	co, _ := c.CombinedOutput()
	log.Println(string(co))
}
