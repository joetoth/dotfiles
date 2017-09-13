import neovim
import os

@neovim.plugin
class Main(object):
    def __init__(self, vim):
        self.vim = vim
        self.termid = None

    @neovim.function('SendToTerm')
    def sendToTerm(self, args):
      if not self.termid:
        print('moo3')
        self.vim.command('echo "hello from sennnd"')
        # TODO: if more than one term on current windows show selector to send to
        for b in self.vim.buffers:
          print(b.name)

    @neovim.function('DoItPython')
    def doItPython(self, args):
      print(self.vim.current.range)

    @neovim.command('GetFullPath')
    def getFullPath(self):
      return self.vim.funcs.expand('%:p') 

def toggleable_buffer(nvim, buf_id, create_new_fn, **kwargs):
  orientation = kwargs.get('orientation', 'vertical split')
  win_nr = nvim.funcs.bufwinnr(buf_id)
  if win_nr == -1:
    if nvim.funcs.bufname(buf_id) == "":
      create_new_fn()
    else:
      nvim.command('{} | b {}'.format(orientation, buf_id))
  else:
    nvim.command('{} wincmd w | q | stopinsert'.format(win_nr))

#toggleable_buffer(nvim, "id", lambda:nvim.eval("split term://top")) 



