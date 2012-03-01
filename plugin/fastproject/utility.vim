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

function! FPPathAbs()
    " TODO
    let type = expand('%:e')
    echo type

    if type == 'html'
        let line = matchlist(getline('.'), '\v(src|href)="([^/][^\":]+)"')
        echo line
    elseif type == 'css'
    endif
endfunction

function! FPMinifierHTML()
    " remove return & indent
    let html = readfile(expand('%'))
    let ret = ''
    for e in html
        let i = matchlist(e, '\v^(\s*)(.*)')
        if i != []
            let ret = ret.i[2]
        endif
    endfor

    " remove space
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-})(\s+)(.*)')

        if i != []
            let min = min.i[1].' '
            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    " remove comment
    let end = 0
    let min = ''
    while end == 0
        let i = matchlist(ret, '\v(.{-})\<\!\-\-(.{-})\-\-\>(.*)')

        if i != []
            let min = min.i[1]

            let j = matchlist(i[2], '\v^(\[if)(.{-})(\[endif\])')

            if j != []
                let min = min.'<!--'.i[2].'-->'
            endif

            let ret = i[3]
        else
            let min = min.ret
            let end = 1
        endif
    endwhile
    let ret = min

    call system('echo -e "'.min.'" > '.expand('%:p:r').'.min.'.expand('%:e'))
endfunction
command! FPMinifierHTML call FPMinifierHTML()
