"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_AutoCursorLastChange")
    let g:FastProject_AutoCursorLastChange = 1
endif
if !exists("g:FastProject_PreOpenList")
    let g:FastProject_PreOpenList = 0
endif
if !exists("g:FastProject_UseUnite")
    " let g:FastProject_UseUnite = 0
    let g:FastProject_UseUnite = 1
endif
if !exists("g:FastProject_DefaultConfigDir")
    let g:FastProject_DefaultConfigDir = $HOME.'/.vimfastproject/'
endif
if !exists("g:FastProject_DefaultConfigFile")
    let g:FastProject_DefaultConfigFile = '.vfp'
endif
if !exists("g:FastProject_DefaultConfigFileTemplate")
    let g:FastProject_DefaultConfigFileTemplate = '.vfp.template'
endif
if !exists("g:FastProject_DefaultList")
    let g:FastProject_DefaultList = '~FastProject-List~'
endif
if !exists("g:FastProject_TemplateWindowSize")
    let g:FastProject_TemplateWindowSize = 15
endif
if !exists("g:FastProject_ListWindowSize")
    let g:FastProject_ListWindowSize = 15
endif

" config
let s:FastProject_DefaultConfig = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
let s:FastProject_DefaultList = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
if !isdirectory(g:FastProject_DefaultConfigDir)
    call mkdir(g:FastProject_DefaultConfigDir)
endif
if !filereadable(s:FastProject_DefaultConfig)
    call system('echo -e "# Select Template\nAtsushiM/test-template\n" > '.s:FastProject_DefaultConfig)
endif
if !filereadable(s:FastProject_DefaultList)
    call system('echo -e "# Project List" > '.s:FastProject_DefaultList)
endif

function! s:FPGetGit(repo)
    let i = matchlist(a:repo, '\v(.*)/(.*)')[2]
    echo 'Start GetGit:'
    call system('git clone git://github.com/'.a:repo.'.git')
    call system('mv -f '.i.'/* ./')
    call system('rm -rf '.i)
    echo 'GetGit Done!'
endfunction

function! s:FPWget()
    let url = getline('.')
    echo url
    let cmd = 'wget '.url
    call system(cmd)
    echo cmd
endfunction

function! s:FPInit()
    echo "FastProject:"

    cd %:p:h
    let repo = getline('.')
    call <SID>FPGetGit(repo)

    if g:FastProject_UseUnite == 0
        e .
    else
        exec 'Unite -input='.expand('%:p:h').'/ file'
    endif

    echo "ALL Done!"
endfunction

function! s:FPTemplateEdit()
    exec "topleft ".g:FastProject_TemplateWindowSize."sp ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
endfunction
function! s:FPList()
    let file = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
    exec "topleft ".g:FastProject_ListWindowSize."sp ".file
    silent sort u
    w
endfunction

function! s:FastProject(...)
    if a:0 != 0
        exec 'cd '.a:000[0]
    endif

    call <SID>FPAdd()
    exec 'e '.g:FastProject_DefaultConfigFile
endfunction
function! s:FPAdd()
    cd %:p:h
    if !filereadable(g:FastProject_DefaultConfigFile)
        let cmd = 'cp '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate.' '.g:FastProject_DefaultConfigFile
        call system(cmd)
        echo cmd
        let path = matchlist(system('pwd'), '\v(.*)\n')[1]
        call system('echo -e "'.path.'" >> '.s:FastProject_DefaultList)
    else
        echo 'Project file already exists.'
    endif
endfunction
function! s:FPProjectFileDelete()
    let path = getline('.')
    let path = path.'/'.g:FastProject_DefaultConfigFile
    echo path
    call <SID>FPDelete(path)
endfunction
function! s:FPDelete(path)
    if filereadable(a:path)
        let cmd = 'rm -rf '.a:path
        call system(cmd)
        echo cmd
    else
        echo 'No Project File.'
    endif
endfunction

function! s:FPOpen()
    let path = getline('.')
    q
    exec 'cd '.path
    if g:FastProject_UseUnite == 0
        e .
    else
        exec 'Unite -input='.path.'/ file'
    endif
    exec 'echo "Project Open:'.path.'"'
    call <SID>FPAdd()
endfunction

function! s:FPBrowseURI()
  let uri = escape(matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*'), '#')
  if uri != ""
    call system("! open " . uri)
  else
    echo "No URI found in line."
  endif
endfunction

command! -nargs=* FP call s:FastProject(<f-args>)
command! FPAdd call s:FPAdd()
command! FPInit call s:FPInit()
command! FPTemplateEdit call s:FPTemplateEdit()
command! FPList call s:FPList()
command! FPOpen call s:FPOpen()
command! FPBrowse call s:FPBrowseURI()
command! FPWget call s:FPWget()
command! FPProjectFileDelete call s:FPProjectFileDelete()

function! s:FPSetBufMapProjectFile()
    set cursorline
    nnoremap <buffer><silent> e :FPInit<CR>
    nnoremap <buffer><silent> <CR> :FPInit<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultConfigFile.' call <SID>FPSetBufMapProjectFile()'

function! s:FPSetBufMapProjectTemplateFile()
    set cursorline
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultConfigFileTemplate.' call <SID>FPSetBufMapProjectTemplateFile()'

function! s:FPSetBufMapProjectList()
    set cursorline
    nnoremap <buffer><silent> e :FPOpen<CR>
    nnoremap <buffer><silent> <CR> :FPOpen<CR>
    nnoremap <buffer><silent> q :bw %<CR>
    nnoremap <buffer><silent> dd :FPProjectFileDelete<CR>dd
endfunction
exec 'au BufRead '.g:FastProject_DefaultList.' call <SID>FPSetBufMapProjectList()'

" cursor move last change
if g:FastProject_AutoCursorLastChange == 1
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

if g:FastProject_PreOpenList == 1
    FPList
endif
