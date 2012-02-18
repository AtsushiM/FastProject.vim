"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_AutoMake")
    let g:FastProject_AutoMake = []
endif

function! s:FPMakeFileCheck()
    if filereadable('Makefile')
        return 1
    endif
    return 0
endfunction
function! s:FPMake()
    let dir = getcwd()
    silent call FPCD()

    let check = <SID>FPMakeFileCheck()
    if check == 1
        let cmd = 'make&'
        call system(cmd)
        pwd
    endif
    exec 'silent cd '.dir
endfunction

command! FPMake call s:FPMake()

let g:FPLT = 11111
" auto make
if g:FastProject_AutoMake != []
    let g:FPLT = 2222
    for e in g:FastProject_AutoMake
        exec 'au BufWritePost *.'.e.' call <SID>FPMake()'
    endfor
endif
