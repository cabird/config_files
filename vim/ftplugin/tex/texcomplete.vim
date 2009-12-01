"currently this re-parses all the bibs or labels
"each time you try to autocomplete one of those.
"Should probably change that, but even on large projects,
"this doesn't seem to incur too much of an overhead
"for now...
function! TexComplete(findstart, base)
    if a:findstart
        let s:tag = ""
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] != '{'
            let start -= 1
        endwhile
        if start < 1
            return start
        endif
        let i = start-2
        while i > 0 && line[i] != '\'
            let s:tag = line[i] . s:tag
            let i-= 1
        endwhile
        if s:tag == "cite"
            call ParseBibs()
        elseif s:tag =~ "ref"
            call ParseLabels()
        endif
        return start
    else
        " find months matching with "a:base"
        let res = []
        if s:tag == "cite"
            call AddBibs(res, a:base)
        elseif s:tag =~ "ref"
            call AddLabels(res, a:base)
        endif
        return res
    endif
endfun

"look for files that match the glob pattern.
"this will go up one level in the tree before
"starting the depth first search IFF there is
"a file in the directory above that matches the
"glob pattern.  Thus, you can search for tex files
"from a subdirectory of the main paper directory
"(but don't have a .tex file in the directory above the
"main paper directory)
function! GetFiles(pat)
    "go up one directory and then down from there
    if len(glob("../" . a:pat)) > 0
        let files = globpath("..", "**/" . a:pat)
    else
        let files = globpath(".", "**/" . a:pat)
    endif
    return split(files, "\<nl>")
endfunction



let s:labelList = []


function! AddLabels(cl, base)
    let i = 0
    for labelD in s:labelList
        if strlen(a:base) == 0 || labelD.word =~ "^" . a:base
            call add(a:cl, labelD)
            let i += 1
        endif
    endfor
endfunction

function! ParseLabels()
    let g:labels = []
    for texfile in GetFiles("*.tex")
        let lines = readfile(texfile)
        let i = 0
        while i < len(lines)
            let line = lines[i]
            let labelMatch = matchlist(line, '\\label{\(.\{-}\)}')   
            if len(labelMatch) > 1 && len(labelMatch[1])
                let labelD = {}
                let labelD.word = labelMatch[1]
                "get a few lines of context around the label
                let j = max([0,i - 3])
                let context = ""
                while j <= i + 2 && j < len(lines)
                    let context .= lines[j] . "\n"
                    let j += 1
                endwhile
                let labelD.info = context
                let labelD.menu = texfile
                call add(s:labelList, labelD)
            endif
            let i += 1 
        endwhile
    endfor
endfunction


function! AddBibs(cl, base)
    let i = 0
    for bibD in s:biblist
        if strlen(a:base) == 0 || bibD.word =~ "^" . a:base
            call add(a:cl, bibD)
            let i += 1
        endif
    endfor
endfunction

let s:biblist = []

function! ParseBibs()
    let s:biblist = []
    for bibfile in GetFiles("*.bib")
        let entryText = ""
        let inEntry = 1
        for line in readfile(bibfile)
            if line[0] == "@"
                if inEntry
                    let entryD = ParseBibEntry(entryText)
                    if len(entryD)
                        call add(s:biblist, entryD)
                    endif
                endif
                let inEntry = 1
                let entryText = line
            else
                let entryText .= line . "\n"
            endif
        endfor
        let entryD = ParseBibEntry(entryText)
        if len(entryD)
            call add(s:biblist, entryD)
        endif
    endfor
endfunction

function! ParseBibEntry(entry)
    let bibD = {}
    let keymatch = matchlist(a:entry, '@\w*\s*{\s*\(\w*\)')
    if len(keymatch) < 2 || strlen(keymatch[1]) == 0
        return {}
    endif
    let bibD.word = keymatch[1]
    let bibD.info = matchlist(a:entry, '\s*\(.*}\)\s*')[1]
    let titleMatch = matchlist(a:entry, '\c\s\+Title\s*=\s*[{"]\(.\{-}\)["}]')   
    "first look for title, then look for booktitle
    if len(titleMatch) > 1 && strlen(titleMatch[1]) > 0
        let bibD.menu = titleMatch[1]
    else
        let titleMatch = matchlist(a:entry, '\c\s\+booktitle\s*=\s*[{"]\(.\{-}\)["}]')   
        if 0 && len(titleMatch) > 1 && strlen(titleMatch[1]) > 0
            let bibD.menu = titleMatch[1]
        endif
    endif
    return bibD
endfunction





setlocal omnifunc=TexComplete
