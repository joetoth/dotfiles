import neovim
import os


@neovim.plugin
class Main(object):
    def __init__(self, vim):
        self.vim = vim

    @neovim.function('DoItPython')
    def doItPython(self, args):
        print('moo3')
        self.vim.command('echo "hello from DoItPython"')

nvim = neovim.attach('socket', path=os.environ['NVIM_LISTEN_ADDRESS'])
print(nvim.current.tabpage.number)

m = Main(nvim)
m.doItPython([])
print('moo3')

