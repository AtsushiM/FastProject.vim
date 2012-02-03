"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  todo
"VERSION:  0.1
"LICENSE:  todo

function! s:FPGetGit(repo)
    let i = matchlist(a:repo, '\v(.*)/(.*)')[2]
    echo 'Start GetGit: '
    echo system('git clone git://github.com/'.a:repo.'.git')
    echo system('mv '.i.'/* ./')
    echo system('rm -rf '.i)
    echo 'GetGit Done!'
endfunction

function! s:FPCompassCreate()
    call system('compass create --sass-dir "scss" --css-dir "css"')
    echo 'Create Compass Files.'
endfunction
function! s:FPCompassStart()
    call system('compass watch scss/*&')
    echo 'Watch SCSS Files.'
endfunction

function! s:FPStart()
  echo "ProjectStart:"
  cd %:h

  let reg_save = @@

  " get template
  silent normal Y
  let git = @@
  " call <SID>FPGetGit(git)

  " compass create
  call <SID>FPCompassCreate()

  " compass start
  call <SID>FPCompassStart()

  let @@ = reg_save

  echo "ALL Done!"
endfunction

function! s:FPCreate()
    " todo
endfunction

command! FastProject call s:FPStart()
