if exists('g:global_vimrc')
    finish
endif
let g:global_vimrc = 1

set expandtab tabstop=4 autoindent shiftwidth=4 softtabstop=4

set list
set listchars=tab:»·
"		testing the tab character 
set cursorline
set number "show line numbers
set vb "visual bell
set gdefault "assume the /g global flag on all :s substitutions

"I *HATE* the omnicompletion keybindings... Here is my fix
"when menu is shown, j moves down, j moves up, esc escapes 
"out without selecting anything, and to start omnicomplete
"use ctrl-space. the downside? you can't type j or k when
"omnicompletion menu is up... I'll live with it!
inoremap <silent> j <C-r>=Jmap()<CR>
inoremap <silent> k <C-r>=Kmap()<CR>
inoremap <silent> <Esc> <C-r>=ESCmap()<cr>
inoremap <silent> <C-Space> <C-X><C-O>
inoremap <silent> <cr> <C-r>=ENTERmap()<cr>
inoremap <C-T> <esc><C-w><C-z>a

function! ENTERmap()
    if pumvisible()
        "accept and close the preview window (if it exists)
        return "\<C-y>\<esc>:pc\<cr>a"
    else
        return "\<cr>"
    endif
endfunction

function! ESCmap()
    if pumvisible()
        "cancel and close the preview window (if it exists)
        return "\<C-e>\<esc>:pc\<cr>a"
    else
        return "\<Esc>"
    endif
endfunction

function! Jmap()
    if pumvisible()
        return "\<C-n>"
    else
        return "j"
    endif
endfunction

function! Kmap()
    if pumvisible()
        return "\<C-p>"
    else
        return "k"
    endif
endfunction

"type tt in command mode to toggle the tag list
"cnoremap tt :TlistToggle 


let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

hi MBENormal guifg=RoyalBlue4
hi MBEChanged guifg=OrangeRed4
hi MBEVisibleNormal guifg=RoyalBlue1 guibg=gray61
hi MBEVisibleChanged guifg=OrangeRed1 guibg=gray61

let g:tex_flavor='latex'
let g:Tex_ViewRule_pdf='skim'

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

noremap <space> :


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


if filereadable(".vimrc")
        source .vimrc
endif
