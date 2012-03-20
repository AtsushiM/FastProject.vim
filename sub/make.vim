"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
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
    silent call fpcd#CD()

    let check = <SID>FPMakeFileCheck()
    if check == 1
        let cmd = 'make&'
        silent call system(cmd)
    endif
    exec 'silent cd '.dir
endfunction

command! FPMake call s:FPMake()

" auto make
if g:FastProject_AutoMake != []
    for e in g:FastProject_AutoMake
        exec 'au BufWritePost *.'.e.' call <SID>FPMake()'
    endfor
endif
