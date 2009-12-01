
function! SaveMarksRegisters(ms, rs)
    "save marks into a dict
    let markD = {}
    let i = 0
    while i < strlen(a:ms)
        let markName = a:ms[i]
        let markD[markName] = getpos("'" . markName)
        let i = i + 1
    endwhile
    "save registers into a dict
    let regD = {}
    let i = 0
    while i < strlen(a:rs)
        let regName = a:rs[i]
        let regD[regName] = getreg(regName)
        let i = i + 1
    endwhile
    return [markD, regD]
endfunction

function! RestoreMarksRegisters(markRegDict)
    " restore marks
    let markD = a:markRegDict[0]
    for key in keys(markD)
        call setpos("'" . key, markD[key])
    endfor
    "restore registers
    let regD = a:markRegDict[1]
    for key in keys(regD)
        call setreg(regName, regD[key])
    endfor
endfunction

function! AddEnvironment(type,...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@
    
    let texenv = input("environment: ")    

    if a:0  "invoked from visual mode so we can use '< and '> marks.
       silent exe "norm! `<" . a:type . "`>\"zd"
    elseif a:type == 'line' || a:type == 'block'
       silent exe "norm! '[V']\"zd"
    else
        silent exe "norm! `[v`]\"zd"
    endif

    call setreg('"', "\\begin{" . texenv . "}\n")
    normal! ""P
    call setreg('"', "\\end{" . texenv . "}\n")
    normal! ""p
    normal! "zP

    let &selection = sel_save
    let @@ = reg_save
endfunction

function! ChangeEnvironment()
    let newtexenv = input("environment: ")    
    let lineNum=line(".")
    let line=getline(lineNum)
    while line !~ '\\begin{'
        let lineNum = lineNum - 1
        if lineNum == 0
            return
        endif
        let line=getline(lineNum)
    endwhile
    let oldtexenv = matchlist(line, '\\begin{\(.\{-}\)}')[1]
    let newline = substitute(line, '\\begin{' . oldtexenv .'}', '\\begin{'. newtexenv . '}', "")
    call setline(lineNum, newline)
    let line=getline(lineNum)
    while line !~ '\\end{' . oldtexenv . '}'
        let lineNum = lineNum + 1
        if lineNum > line('$')
            return
        endif
        let line=getline(lineNum)
    endwhile
    let newline = substitute(line, '\\end{' . oldtexenv .'}', '\\end{'. newtexenv . '}', "")
    call setline(lineNum, newline)
endfunction 

function! DeleteEnvironment()
    let save_cursor = getpos(".")
    let lineNum=line(".")
    let line=getline(lineNum)
    if line !~ '\\begin{'
        return
    endif
    let texenv = matchlist(line, '\\begin{\(.\{-}\)}')[1]
    call cursor(lineNum, 0)
    norm! dd
    let line=getline(lineNum)
    while line !~ '\\end{' . texenv . '}'
        let lineNum = lineNum + 1
        if lineNum > line('$')
            return
        endif
        let line=getline(lineNum)
    endwhile
    call cursor(lineNum, 0)
    norm! dd
    call setpos(".", save_cursor)
endfunction 

"add a latex macro (like \textbf) around the seleted text or the motion
function! AddMacro(type,...)
    let state = SaveMarksRegisters("w", "")
    let texmacro = input("macro: ")    
    " jump around and put in the text
    if a:0 
        execute "normal `<mw`>a}\<Esc>`wi\\" . texmacro . "{\<Esc>f{"
    elseif a:type == "line" 
        execute "normal `[^mw`]$a}\<Esc>`wi\\" . texmacro . "{\<Esc>f{"
    else
        execute "normal `[mw`]a}\<Esc>`wi\\" . texmacro . "{\<Esc>f{"
    endif
    call RestoreMarksRegisters(state)
endfunction




function! JumpToEnclosingBrace()
    let savePos = getpos(".")
    let depth = 1
    while depth > 0
        let line = search("[{}]", "bW")
        if line < 1
            call setpos(".", savePos)
            return 0
        endif
        let c = getline(".")[getpos(".")[2]-1]
        if c == "}"
            let depth = depth + 1
        elseif c == "{"
            let depth = depth - 1
        endif
    endwhile
    return 1
endfunction

function! DeleteMacro()
    let marksRegs = SaveMarksRegisters("yz", "")
    normal mz
    if !JumpToEnclosingBrace()
        return
        call RestoreMarksRegisters(marksRegs)
    endif
    "save mark in y, jump to matching close }, delete it, jump back to y,
    "delete from \ to {, then jump to original cursor position 
    execute 'normal F\myf{%x`ydf{`z'
    call RestoreMarksRegisters(marksRegs)
endfunction 

function! ChangeMacro()
    let marksRegs = SaveMarksRegisters("z", "")
    let texmacro = input("macro: ")    
    normal mz
    if !JumpToEnclosingBrace()
        return
    endif
    "now change the text from the \ to the { with the new tag text
    execute 'normal T\ct{' . texmacro . "\<Esc>`z"
    "now we need to find the matching close }
    call RestoreMarksRegisters(marksRegs)
endfunction 


nmap <silent> ;ae :set opfunc=AddEnvironment<CR>g@
vmap <silent> ;ae :<C-U>call AddEnvironment(visualmode(), 1)<CR>
nmap <silent> ;ce :call ChangeEnvironment()<CR>
nmap <silent> ;de :call DeleteEnvironment()<CR>
nmap <silent> ;am :set opfunc=AddMacro<CR>g@
vmap <silent> ;am :<C-U>call AddMacro(visualmode(), 1)<CR>
nmap <silent> ;cm :call ChangeMacro()<CR>
nmap <silent> ;dm :call DeleteMacro()<CR>


