"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

" source ~/.vim/vimrc_secret.vim

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
if !exists("g:FastProject_AutoCursorLastChange")
    let g:FastProject_AutoCursorLastChange = 1
endif
if !exists("g:FastProject_AutoSassCompile")
    let g:FastProject_AutoSassCompile = 1
endif
if !exists("g:FastProject_AutoMake")
    let g:FastProject_AutoMake = []
    " let g:FastProject_AutoMake = [ 'js' ]
endif
if !exists("g:FastProject_PreOpenList")
    let g:FastProject_PreOpenList = 0
endif
if !exists("g:FastProject_PreOpenToDo")
    let g:FastProject_PreOpenToDo = 0
endif
if !exists("g:FastProject_PreOpenMemo")
    let g:FastProject_PreOpenMemo = 0
endif
if !exists("g:FastProject_UseUnite")
    " let g:FastProject_UseUnite = 0
    let g:FastProject_UseUnite = 1
endif
if !exists("g:FastProject_SASSWatchStart")
    let g:FastProject_SASSWatchStart = 1
endif
if !exists("g:FastProject_DefaultSASSDir")
    let g:FastProject_DefaultSASSDir = 'scss'
endif
if !exists("g:FastProject_DefaultCSSDir")
    let g:FastProject_DefaultCSSDir = 'css'
endif
if !exists("g:FastProject_DefaultIMGDir")
    let g:FastProject_DefaultIMGDir = 'img'
endif
if !exists("g:FastProject_DefaultJSDir")
    let g:FastProject_DefaultJSDir = 'js'
endif
if !exists("g:FastProject_DefaultConfigDir")
    let g:FastProject_DefaultConfigDir = $HOME.'/.vimfastproject/'
endif
if !exists("g:FastProject_DefaultTempDir")
    let g:FastProject_DefaultTempDir = g:FastProject_DefaultConfigDir.'temp/'
endif
if !exists("g:FastProject_DefaultConfigFile")
    let g:FastProject_DefaultConfigFile = '.vfp'
endif
if !exists("g:FastProject_DefaultConfigFileTemplate")
    let g:FastProject_DefaultConfigFileTemplate = '.vfp.template'
endif
if !exists("g:FastProject_DefaultDownload")
    let g:FastProject_DefaultDownload = '~FastProject-Download~'
endif
if !exists("g:FastProject_DefaultList")
    let g:FastProject_DefaultList = '~FastProject-List~'
endif
if !exists("g:FastProject_DefaultMemo")
    let g:FastProject_DefaultMemo = '~FastProject-MEMO~'
endif
if !exists("g:FastProject_DefaultToDo")
    let g:FastProject_DefaultToDo = '~FastProject-ToDo~'
endif
if !exists("g:FastProject_DefaultBookmark")
    let g:FastProject_DefaultBookmark = '~FastProject-Bookmark~'
endif
if !exists("g:FastProject_TemplateWindowSize")
    let g:FastProject_TemplateWindowSize = 15
endif
if !exists("g:FastProject_ListWindowSize")
    let g:FastProject_ListWindowSize = 15
endif
if !exists("g:FastProject_DownloadWindowSize")
    let g:FastProject_DownloadWindowSize = 50
endif
if !exists("g:FastProject_MemoWindowSize")
    let g:FastProject_MemoWindowSize = 50
endif
if !exists("g:FastProject_ToDoWindowSize")
    let g:FastProject_ToDoWindowSize = 50
endif
if !exists("g:FastProject_BookmarkWindowSize")
    let g:FastProject_BookmarkWindowSize = 50
endif
if !exists("g:FastProject_SaveVimStatus")
    let g:FastProject_SaveVimStatus = 0
endif

" config
let s:FastProject_DefaultConfig = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
let s:FastProject_DefaultList = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
let s:FastProject_DefaultDownload = g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
let s:FastProject_DefaultMemo = g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
let s:FastProject_DefaultToDo = g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
let s:FastProject_DefaultBookmark = g:FastProject_DefaultConfigDir.g:FastProject_DefaultBookmark
if !isdirectory(g:FastProject_DefaultConfigDir)
    call mkdir(g:FastProject_DefaultConfigDir)
endif
if !filereadable(s:FastProject_DefaultConfig)
    call system('echo -e "# Select Template\nAtsushiM/test-template\n" > '.s:FastProject_DefaultConfig)
endif
if !filereadable(s:FastProject_DefaultList)
    call system('echo -e "# Project List" > '.s:FastProject_DefaultList)
endif
if !filereadable(s:FastProject_DefaultDownload)
    call system('echo -e "# Project DownloadList" > '.s:FastProject_DefaultDownload)
endif
if !filereadable(s:FastProject_DefaultMemo)
    call system('echo -e "# Memo" > '.s:FastProject_DefaultMemo)
endif
if !filereadable(s:FastProject_DefaultToDo)
    call system('echo -e "# ToDo" > '.s:FastProject_DefaultToDo)
endif
if !filereadable(s:FastProject_DefaultBookmark)
    call system('echo -e "# Bookmark" > '.s:FastProject_DefaultBookmark)
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

function! s:FPCompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction
function! s:FPSassCheck()
    if isdirectory(g:FastProject_DefaultSASSDir) && isdirectory(g:FastProject_DefaultCSSDir)
        return 1
    endif
    return 0
endfunction
function! s:FPCompassCreate()
    let cmd = 'compass create --sass-dir "'.g:FastProject_DefaultSASSDir.'" --css-dir "'.g:FastProject_DefaultCSSDir.'"'
    call system(cmd)
    echo cmd
endfunction

function! s:FPSassCompile()
    let dir = getcwd()
    silent call FPCD()
    let check = <SID>FPCompassCheck()
    if check == 1
        let cmd = 'compass compile&'
        call system(cmd)
    else
        let check = <SID>FPSassCheck()
        if check == 1
            let cmd = 'sass '.g:FastProject_DefaultSASSDir.':'.g:FastProject_DefaultCSSDir.'&'
            call system(cmd)
        endif
    endif
    exec 'silent cd '.dir
endfunction 

function! s:FPMakeFileCheck()
    if filereadable(s:FastProject_DefaultList)
        return 1
    endif
    return 0
endfunction
function! s:FPMake()
    let dir = getcwd()
    silent call FPCD()

    let check = <SID>FPMakeFileCheck()
    if check == 1
        let cmd = 'make&'
        call system(cmd)
    endif

    exec 'silent cd '.dir
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
endfunction

function! FPEdit(path)
    if FPCD() == 1
        if g:FastProject_UseUnite == 0
            exec 'e '.a:path
        else
            let path = matchlist(system('pwd'), '\v(.*)\n')[1]
            exec 'Unite -input='.path.'/'.a:path.'/ file'
        endif
    endif
endfunction

function! s:FPTemplateEdit()
    exec "topleft ".g:FastProject_TemplateWindowSize."sp ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
endfunction
function! s:FPList()
    let file = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
    exec "topleft ".g:FastProject_ListWindowSize."sp ".file
    silent 2,%sort u
    sort u
    w
endfunction
function! s:FPMemo()
    exec "botright ".g:FastProject_MemoWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
endfunction
function! s:FPToDo()
    exec "topleft ".g:FastProject_ToDoWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
endfunction
function! s:FPCheckToDoStatus()
    let todo = getline('.')
    let i = matchlist(todo, '\v^([-~/])\s(.*)')
    let flg = 0
    if i != []
        let st = i[1]
        if st != '-' && st && '~' && st != '/'
            let flg = 1
        endif
    else
        let flg = 1
    endif

    if flg == 1
        let st = ''
        silent normal ^i- 
    endif

    silent normal ^ll

    return st
endfunction
function! s:FPChangeToDoStatus()
    let st = <SID>FPCheckToDoStatus()

    if st == '-'
        let st = '~'
    elseif st == '~'
        let st = '/'
    else
        let st = '-'
    endif

    exec 'silent normal ^xxi'.st.' '
    silent normal ^ll
    silen w
endfunction
function! s:FPToDoRemove()
    let file = g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
    let todo = readfile(file)
    let ret = ''
    for e in todo
        let i = matchlist(e, '\v^(/)(.*)')
        if i == [] && e != ''
            let ret = ret.e.'\n'
        endif
    endfor

    call system('echo -e "'.ret.'" > '.file)
endfunction
function! s:FPDownload()
    exec g:FastProject_DownloadWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
endfunction
function! s:FPBookmark()
    exec g:FastProject_BookmarkWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultBookmark
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

" function! s:FPLineRead()
"     let reg = @@
" 
"     silent normal _vg_y
"     let line = @@
"     let @@ = reg
" 
"     return line
" endfunction

command! -nargs=* FP call s:FastProject(<f-args>)
command! FPAdd call s:FPAdd()
command! FPInit call s:FPInit()
command! FPCD call FPCD()
command! FPTemplateEdit call s:FPTemplateEdit()
command! FPList call s:FPList()
command! FPOpen call s:FPOpen()
command! FPBrowse call s:FPBrowseURI()
command! FPWget call s:FPWget()
command! FPProjectFileDelete call s:FPProjectFileDelete()

command! FPRoot call FPEdit('.')
command! FPSASS call FPEdit(g:FastProject_DefaultSASSDir)
command! FPCSS call FPEdit(g:FastProject_DefaultCSSDir)
command! FPIMG call FPEdit(g:FastProject_DefaultIMGDir)
command! FPJS call FPEdit(g:FastProject_DefaultJSDir)

command! FPCompassCreate call s:FPCompassCreate()
command! FPSassCompile call s:FPSassCompile()
command! FPMake call s:FPMake()

command! FPDownload call s:FPDownload()
command! FPMemo call s:FPMemo()
command! FPToDo call s:FPToDo()
command! FPCheckToDoStatus call s:FPCheckToDoStatus()
command! FPChangeToDoStatus call s:FPChangeToDoStatus()
command! FPToDoRemove call s:FPToDoRemove()
command! FPBookmark call s:FPBookmark()

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

function! s:FPSetBufMapMemo()
    nnoremap <buffer><silent> b :FPBrowse<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultMemo.' call <SID>FPSetBufMapMemo()'

function! s:FPSetBufMapToDo()
    set cursorline
    " vertical res 50
    inoremap <buffer><silent> <CR> <Esc>o- 
    inoremap <buffer><silent> <Esc> <Esc>:FPCheckToDoStatus<CR>
    nnoremap <buffer><silent> o o<Esc>:FPCheckToDoStatus<CR>a
    nnoremap <buffer><silent> O O<Esc>:FPCheckToDoStatus<CR>a
    nnoremap <buffer><silent> <Space> :FPChangeToDoStatus<CR>
    nnoremap <buffer><silent> <Tab> :FPChangeToDoStatus<CR>
    nnoremap <buffer><silent> <C-C> :FPChangeToDoStatus<CR>
    nnoremap <buffer><silent> q :bw %<CR>:FPToDoRemove<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultToDo.' call <SID>FPSetBufMapToDo()'

function! s:FPSetBufMapBookmark()
    set cursorline
    nnoremap <buffer><silent> e :FPBrowse<CR>
    nnoremap <buffer><silent> <CR> :FPBrowse<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultBookmark.' call <SID>FPSetBufMapBookmark()'

function! s:FPSetBufMapDownload()
    set cursorline
    nnoremap <buffer><silent> e :FPWget<CR>
    nnoremap <buffer><silent> <CR> :FPWget<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultDownload.' call <SID>FPSetBufMapDownload()'

let s:FPSavePointPath = g:FastProject_DefaultConfigDir.'save_status'
set sessionoptions=blank,curdir,buffers,folds,help,globals,slash,tahpages,winsize,localoptions
function! s:FPSaveWindow(file)
    let options = [
    \ 'set columns=' . &columns,
    \ 'set lines=' . &lines,
    \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
    \ ]
    call writefile(options, a:file)
endfunction

function! s:FPSavePoint(dir)
    if !isdirectory(a:dir)
        call mkdir(a:dir)
    endif
    
    if !filereadable(a:dir.'/vimwinpos.vim') || filewritable(a:dir.'/vimwinpos.vim')
        if has("gui")
            call s:FPSaveWindow(a:dir.'/vimwinpos.vim')
        endif
    endif

    if !filereadable(a:dir.'/session.vim') || filewritable(a:dir.'/session.vim')
        execute "mksession! ".a:dir."/session.vim"
    endif

    if !filereadable(a:dir.'/viminfo.vim') || filewritable(a:dir.'/viminfo.vim')
        execute "wviminfo!  ".a:dir."/viminfo.vim"
    endif
endfunction

function! s:FPLoadPoint(dir)
    if filereadable(a:dir."/vimwinpos.vim") && has("gui")
        execute "source ".a:dir."/vimwinpos.vim"
    endif

    if filereadable(a:dir."/session.vim")
        execute "source ".a:dir."/session.vim"
    endif

    if filereadable(a:dir."/viminfo.vim")
        execute "rviminfo ".a:dir."/viminfo.vim"
    endif
endfunction

if g:FastProject_SaveVimStatus == 1
    command! FPSavePoint :call s:FPSavePoint(s:FPSavePointPath)
    command! FPLoadPoint :call s:FPLoadPoint(s:FPSavePointPath)

    augroup SavePoint
        autocmd!
        autocmd VimLeavePre * FPSavePoint

        autocmd CursorHold * FPSavePoint
        autocmd VimEnter * FPLoadPoint
    augroup END
endif

if g:FastProject_AutoCDRoot == 1
    au BufReadPost * exec FPCD() 
endif
" cursor move last change
if g:FastProject_AutoCursorLastChange == 1
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
" sass auto compile
if g:FastProject_AutoSassCompile == 1
    au BufWritePost *.scss call <SID>FPSassCompile()
    au BufWritePost *.sass call <SID>FPSassCompile()
endif
" auto make
if g:FastProject_AutoMake != []
    for e in g:FastProject_AutoMake
        exec 'au BufWritePost *.'.e.' call <SID>FPMake()'
    endfor
endif

if g:FastProject_PreCD != ''
    exec 'cd '.g:FastProject_PreCD
endif

if g:FastProject_PreOpenList == 1
    FPList
endif
if g:FastProject_PreOpenToDo == 1
    FPToDo
endif
if g:FastProject_PreOpenMemo == 1
    FPMemo
endif
