"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_PreCD")
    let g:FastProject_PreCD = ''
    " let g:FastProject_PreCD = $HOME.'/works'
endif
if !exists("g:FastProject_CDLoop")
    let g:FastProject_CDLoop = 5
endif
if !exists("g:FastProject_AutoCDRoot")
    let g:FastProject_AutoCDRoot = 0
endif
if !exists("g:FastProject_DefaultIMGDir")
    let g:FastProject_DefaultIMGDir = 'img'
endif
if !exists("g:FastProject_DefaultJSDir")
    let g:FastProject_DefaultJSDir = 'js'
endif

function! s:FPRootPath()
    let i = 0
    let dir = expand('%:p:h').'/'
    while i < g:FastProject_CDLoop
        if !filereadable(dir.g:FastProject_DefaultConfigFile)
            let i = i + 1
            let dir = dir.'../'
        else
            exec 'silent cd '.dir
            break
        endif
    endwhile

    if i == g:FastProject_CDLoop
        return ''
    else
        return dir
    endif
endfunction

function! FPCD(...)
    let dir = <SID>FPRootPath()
    let root = dir
    if dir != '' && a:0 != 0
        let dir = dir.a:000[0]
    endif

    if root != ''
        exec 'silent cd '.dir
    endif

    pwd

    if root == ''
        return 0
    else
        return 1
    endif
    echo a:000[0]
endfunction

function! FPEdit(path)
    let root = <SID>FPRootPath()

    if root != ''
        let target = root.a:path
        if g:FastProject_UseUnite == 0
            exec 'e '.target
        else
            let path = getcwd()
            exec 'Unite -input='.path.'/'.a:path.'/ file'
        endif

        if isdirectory(target)
            exec 'silent cd '.target
        endif
    endif
endfunction

command! FPCD call FPCD()

command! FPEditRoot call FPEdit('.')
command! FPEditSASS call FPEdit(g:FastProject_DefaultSASSDir)
command! FPEditCSS call FPEdit(g:FastProject_DefaultCSSDir)
command! FPEditIMG call FPEdit(g:FastProject_DefaultIMGDir)
command! FPEditJS call FPEdit(g:FastProject_DefaultJSDir)

command! FPCDRoot call FPCD('.')
command! FPCDSASS call FPCD(g:FastProject_DefaultSASSDir)
command! FPCDCSS call FPCD(g:FastProject_DefaultCSSDir)
command! FPCDIMG call FPCD(g:FastProject_DefaultIMGDir)
command! FPCDJS call FPCD(g:FastProject_DefaultJSDir)

if g:FastProject_AutoCDRoot == 1
    au BufReadPost * exec FPCD() 
endif
