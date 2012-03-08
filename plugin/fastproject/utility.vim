"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:FastProject_AbsPathComment")
    let g:FastProject_AbsPathComment = 1
endif

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

function! FPPathAbs()
    " TODO
    let orgdir = getcwd()
    let base = getline('.')
    let end = 0
    let ret = ''
    while end != 1
        let line = matchlist(base, '\v(.{-})(src|href)(\=")([^/][^\":]+)(")(.*)')
        if line != []
            let root = FPRootPath()
            exec 'cd '.root
            let root = getcwd().'/'
            exec 'cd '.orgdir

            if root != ''
                let dir = expand('%:p:h')
                let fullpath = dir.'/'.line[4]
                let isfile = 0
                let file_name = ''
                if !isdirectory(fullpath)
                    let isfile = 1
                    let temp = ''
                    let sf = split(fullpath, '\/')
                    for e in sf
                        echo temp.'/'.e
                        if isdirectory(temp.'/'.e)
                            let temp = temp.'/'.e
                        else
                            let fullpath = temp.'/'
                            break
                        endif
                    endfor
                    let file_name = e
                endif

                exec 'cd '.fullpath
                let fullpath = getcwd().'/'
                exec 'cd '.orgdir

                if isfile == 1
                    let fullpath = fullpath.file_name
                endif

                let spath = matchlist(fullpath, '\v('.root.')(.*)')
                if spath != []
                    let fullpath = '/'.spath[2]
                endif

                let ret = ret.line[1].line[2].line[3].fullpath.line[5]
                let base = line[6]
            endif
        else
            let ret = ret.base
            let end = 1
        endif
    endwhile
    if g:FastProject_AbsPathComment == 1
        silent normal ^i/* 
        silent normal $a */
        silent normal o
    endif
    call setline('.', ret)
endfunction

