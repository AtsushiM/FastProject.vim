"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_AutoSassCompile")
    let g:FastProject_AutoSassCompile = 1
endif
if !exists("g:FastProject_DefaultSASSDir")
    let g:FastProject_DefaultSASSDir = ['sass', 'scss']
endif
if !exists("g:FastProject_DefaultCSSDir")
    let g:FastProject_DefaultCSSDir = ['css', 'stylesheet']
endif

function! s:FPCompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction
function! s:FPSassCheck()
    if isdirectory(g:FastProject_DefaultSASSDir) && isdirectory(g:FastProject_DefaultCSSDir)
        return 1
    endif
    return 0
endfunction

function! s:FPCompassCreate()
    let cmd = 'compass create --sass-dir "'.g:FastProject_DefaultSASSDir.'" --css-dir "'.g:FastProject_DefaultCSSDir.'"'
    call system(cmd)
    echo cmd
endfunction

function! s:FPSassCompile()
    let dir = getcwd()
    silent call FPCD()
    let check = <SID>FPCompassCheck()
    if check == 1
        let cmd = 'compass compile&'
        call system(cmd)
    else
        let check = <SID>FPSassCheck()
        if check == 1
            let cmd = 'sass --update '.g:FastProject_DefaultSASSDir.':'.g:FastProject_DefaultCSSDir.'&'
            call system(cmd)
        endif
    endif
    exec 'silent cd '.dir
endfunction 

command! FPCompassCreate call s:FPCompassCreate()
command! FPSassCompile call s:FPSassCompile()

" sass auto compile
if g:FastProject_AutoSassCompile == 1
    au BufWritePost *.scss call <SID>FPSassCompile()
    au BufWritePost *.sass call <SID>FPSassCompile()
endif
