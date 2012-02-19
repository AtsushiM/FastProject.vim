"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let g:utilitytest = 1
function! s:FPGetGit(repo)
    let i = matchlist(a:repo, '\v(.*)/(.*)')[2]
    echo 'Start GetGit:'
    call system('git clone git://github.com/'.a:repo.'.git')
    call system('mv -f '.i.'/* ./')
    call system('rm -rf '.i)
    echo 'GetGit Done!'
endfunction

function! s:FPBrowseURI()
  let uri = escape(matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*'), '#')
  if uri != ""
    call system("! open " . uri)
  else
    echo "No URI found in line."
  endif
endfunction

function! s:FPDelete(path)
    if filereadable(a:path)
        let cmd = 'rm -rf '.a:path
        call system(cmd)
        echo cmd
    else
        echo 'No File: '.a:path
    endif
endfunction

command! FPBrowse call s:FPBrowseURI()