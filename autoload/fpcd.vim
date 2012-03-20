"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

function! fpcd#RootPath()
    let i = 0
    let org = expand('%:p:h')
    let dir = org.'/'
    while i < g:FastProject_CDLoop
        if !filereadable(dir.g:FastProject_DefaultConfigFile)
            let i = i + 1
            let dir = dir.'../'
        else
            exec 'silent cd '.dir
            let dir = getcwd()
            exec 'silent cd '.org
            break
        endif
    endwhile

    if i == g:FastProject_CDLoop
        return ''
    else
        return dir
    endif
endfunction

function! fpcd#CD(...)
    let dir = fpcd#RootPath()
    exec 'cd '.dir

    if dir == ''
        return 0
    else
        if a:0 != 0
            for e in a:000[0]
                if isdirectory(dir.'/'.e)
                    let dir = dir.'/'.e
                    break
                endif
            endfor
        endif

        exec 'cd '.dir
        pwd
        return 1
    endif
endfunction

function! fpcd#Edit(path)
    let root = fpcd#RootPath()

    if root != ''
        exec 'cd '.root

        if type(a:path) != 3
            let path = [a:path]
        else
            let path = a:path
        endif

        for e in path
            if e != ''
                let target = root.'/'.e
            else
                let target = root
            endif

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
