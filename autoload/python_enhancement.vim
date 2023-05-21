" Vim Python Enhancement
"
"  - Access Python documentation
"  - Evaluate current line using Python
"  - Execute Python from a range within current file

scriptencoding utf-8

if !has('python3')
  echohl WarningMsg
  echomsg "[Python Enhancement] Python 3.x interface unavailable"
  echohl None
  finish
endif

let g:loaded_python_enhancement = 1

" the default location of pydoc is /usr/lib/pydoc.py
python3 << EOF
import sys
import vim
vim.command("let s:pydoc_path=\'" + sys.prefix + "/lib/pydoc.py\'")
EOF

function! s:ShowPyDocInPreview(what)
  " compose a tempfile path using the argument to the function
  let path = $TEMP . '/' . a:what . '.pydoc'
  let epath = shellescape(path)
  let epydoc_path = shellescape(s:pydoc_path)
  let ewhat = shellescape(a:what)
  " run pydoc on the argument, and redirect the output to the tempfile
  call system(epydoc_path . " " . ewhat . (stridx(&shellredir, '%s') == -1 ? (&shellredir.epath) : (substitute(&shellredir, '\V\C%s', '\=epath', ''))))
  " open the tempfile in the preview window
  execute "pedit" fnameescape(path)
endfunction

function! s:ShowPyDocInScratchBuf(what)
  let bufname = a:what . ".pydoc"
  " check if the buffer exists already
  if bufexists(bufname)
    let winnr = bufwinnr(bufname)
    if winnr != -1
      " if the buffer is already displayed, switch to that window
      execute winnr "wincmd w"
    else
      " otherwise open the buffer in a split window
      execute "sbuffer" bufname
    endif
  else
    " create a new buffer set the nofile buftype and don't display it ni the buffer list
    execute "split" fnameescape(bufname)
    setlocal buftype=nofile
    setlocal nobuflisted
    " read the output from pydoc
    execute "r !" . shellxescape(s:pydoc_path, 1) . " " . shellxescape(a:what, 1)
  endif
  " go to the first line of th document
  1
endfunction

function! python_enhancement#ShowPyDoc(what)
  if g:show_py_doc_in_preview == 1
    call s:ShowPyDocInPreview(a:what)
  else
    call s:ShowPyDocInScratchBuf(a:what)
  endif
endfunction
