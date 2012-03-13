"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

function! FPPathCheck(path)
    return escape(a:path, ' ')
endfunction

function! FPGetGit(repo)
    let i = matchlist(a:repo, '\v(.*)/(.*)')[2]
    echo 'Start GetGit:'
    call system('git clone git://github.com/'.a:repo.'.git')
    call system('mv -f '.i.'/* ./')
    call system('rm -rf '.i)
    echo 'GetGit Done!'
endfunction

function! FPURICheck(uri)
  return escape(matchstr(a:uri, '[a-z]*:\/\/[^ >,;:]*'), '#')
endfunction

function! s:FPBrowseURI()
  let uri = FPURICheck(getline("."))
  if uri != ""
    call system("! open " . uri)
  else
    echo "No URI found in line."
  endif
endfunction
command! FPBrowse call s:FPBrowseURI()

function! FPDelete(path)
    if filereadable(a:path)
        let cmd = 'rm -rf '.a:path
        call system(cmd)
        echo cmd
    else
        echo 'No File: '.a:path
    endif
endfunction

function! FPPathAbs(...)
    let now = line('.')
    let col = col('.')
    let start = now
    let end = now
    let prefix = ''

    if a:0 != 0
        for e in a:000
            let eary = split(e,'=')
            if eary[0] == '-all'
                if eary[1] == '0'
                    let start = now
                    let end = now
                else
                    let start = 1
                    let end = line('w$')
                endif
            elseif eary[0] == '-start'
                let start = eary[1]
            elseif eary[0] == '-end'
                let end = eary[1]
            elseif eary[0] == '-prefix'
                exec 'let prefix = '."'".eary[1]."'"
            endif
        endfor
    endif
    exec ''.start.','.end.'call _FPPathAbs("'.prefix.'")'
    call cursor(now, col)
endfunction
function! _FPPathAbs(...)
    let orgdir = expand('%:p:h')
    let root = FPRootPath()
    let base = getline('.')
    let org = base
    let prefix = ''
    let end = 0
    let ret = ''

    if a:0 != 0
        let prefix = a:000[0]
    endif

    while end == 0
        let line = matchlist(base, '\v(.{-})(src|href)(\=")([^/#][^\":]+)(")(.*)')
        if line != []
            let orgary = split(orgdir, '/')
            let srcary = split (line[4], '/')
            let calary = deepcopy(srcary)
            for e in srcary
                if e == '..'
                    unlet orgary[-1]
                    unlet calary[0]
                elseif e == '.'
                    unlet calary[0]
                else
                    break
                endif
            endfor
            echo 
            let ret = ret.line[1].line[2].line[3].prefix.split('/'.join(orgary, '/').'/'.join(calary, '/'), root)[0].line[5]
            let base = line[6]
        else
            let ret = ret.base
            let end = 1
        endif
    endwhile

    if ret != org
        call setline('.', ret)
    endif
endfunction
command! -nargs=* FPPathAbs call FPPathAbs(<f-args>)
