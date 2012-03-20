"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:FastProject_AutoSassCompile")
    let g:FastProject_AutoSassCompile = 0
endif
if !exists("g:FastProject_DefaultSASSDir")
    let g:FastProject_DefaultSASSDir = []
endif
if !exists("g:FastProject_DefaultCSSDir")
    let g:FastProject_DefaultCSSDir = []
endif

function! s:FPCompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction
function! s:FPSassCheck()
    let sass = ''
    for e in g:FastProject_DefaultSASSDir
        if isdirectory(e)
            let sass = e
            break
        endif
    endfor

    let css = ''
    for e in g:FastProject_DefaultCSSDir
        if isdirectory(e)
            let css = e
            break
        endif
    endfor
    if sass != '' && css != ''
        return [sass, css]
    endif
    return []
endfunction

function! s:FPCompassCreate()
    let cmd = 'compass create --sass-dir "'.g:FastProject_DefaultSASSDir.'" --css-dir "'.g:FastProject_DefaultCSSDir.'"'
    call system(cmd)
    echo cmd
endfunction

function! s:FPSassCompile()
    let dir = getcwd()
    silent call fpcd#CD()
    let check = <SID>FPCompassCheck()
    if check == 1
        let cmd = 'compass compile&'
        call system(cmd)
    else
        unlet check
        let check = <SID>FPSassCheck()
        if check != []
            let cmd = 'sass --update '.check[0].':'.check[1].'&'
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
