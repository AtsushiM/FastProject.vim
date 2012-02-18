"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:FastProject_CDLoop")
    let g:FastProject_CDLoop = 5
endif
if !exists("g:FastProject_AutoCDRoot")
    let g:FastProject_AutoCDRoot = 0
endif
if !exists("g:FastProject_DefaultIMGDir")
    let g:FastProject_DefaultIMGDir = ['img', 'imgs', 'image', 'images']
endif
if !exists("g:FastProject_DefaultJSDir")
    let g:FastProject_DefaultJSDir = ['js', 'javascript', 'javascripts']
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

    if dir == ''
        return 0
    else
        if a:0 != 0
            for e in a:000[0]
                if isdirectory(dir.e)
                    let dir = dir.e
                    break
                endif
            endfor
        endif

        exec 'cd '.dir
        pwd
        return 1
    endif
endfunction

function! FPEdit(path)
    let root = <SID>FPRootPath()

    if root != ''
        if type(a:path) != 3
            let path = [a:path]
        else
            let path = a:path
        endif

        for e in path
            let target = root.e

            if filereadable(target) || isdirectory(target)
                if g:FastProject_UseUnite == 0
                    exec 'e '.target
                else
                    exec 'Unite -input='.target.'/ file'
                endif

                break
            endif
        endfor
    endif
endfunction

command! -nargs=* FPCD call FPCD(<f-args>)

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
