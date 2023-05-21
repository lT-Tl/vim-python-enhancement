" Vim Python Enhancement
"
"  - Access Python documentation
"  - Evaluate current line using Python
"  - Execute Python from a range within current file

scriptencoding utf-8

if &cp || (exists('g:loaded_python_enhancement') && g:loaded_python_enhancement)
  finish
endif

if v:version < 800
  echohl WarningMsg
  echomsg "[Python Enhancement] Vim version requires at least 8.0"
  echohl None
  finish
endif

if !has('python3')
  echohl WarningMsg
  echomsg "[Python Enhancement] Python 3.x interface unavailable"
  echohl None
  finish
endif

" options
" if g:show_py_doc_in_preview = 1, show help in the preview window, otherwise show in the scratch buffer.
let g:show_py_doc_in_preview = 1

" Commands
command! -nargs=1 Pyh call python_enhancement#ShowPyDoc(<f-args>)

" Key mapping for commands
nnoremap <buffer> K :<C-u>let save_isk = &iskeyword \|
  \ set iskeyword+=. \|
  \ execute "Pyh " . expand("<cword>") \|
  \ let &iskeyword = save_isk<CR>
