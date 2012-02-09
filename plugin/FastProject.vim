"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  todo

if !exists("g:FastProject_CDLoop")
    let g:FastProject_CDLoop = 5
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
if !exists("g:FastProject_DefaultConfigFile")
    let g:FastProject_DefaultConfigFile = '.vfp'
endif
if !exists("g:FastProject_DefaultConfigFileTemplate")
    let g:FastProject_DefaultConfigFileTemplate = '.vfp.template'
endif
if !exists("g:FastProject_DefaultDownload")
    let g:FastProject_DefaultDownload = '.FastProject-DownloadList'
endif
if !exists("g:FastProject_DefaultList")
    let g:FastProject_DefaultList = '.FastProject-List'
endif
if !exists("g:FastProject_DefaultList")
    let g:FastProject_DefaultList = '.FastProject-List'
endif
if !exists("g:FastProject_DefaultMemo")
    let g:FastProject_DefaultMemo = '.FastProject-MEMO'
endif
if !exists("g:FastProject_DefaultBookmark")
    let g:FastProject_DefaultBookmark = '.FastProject-Bookmark'
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
if !exists("g:FastProject_BookmarkWindowSize")
    let g:FastProject_BookmarkWindowSize = 50
endif

" config
let s:FastProject_DefaultConfig = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
let s:FastProject_DefaultList = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
let s:FastProject_DefaultDownload = g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
let s:FastProject_DefaultMemo = g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
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
if !filereadable(s:FastProject_DefaultBookmark)
    call system('echo -e "# Bookmark" > '.s:FastProject_DefaultBookmark)
endif

exec 'autocmd BufNewFile .vfp 0r '.s:FastProject_DefaultConfig


function! s:FPGetGit(repo)
    let i = matchlist(a:repo, '\v(.*)/(.*)')[2]
    echo 'Start GetGit:'
    call system('git clone git://github.com/'.a:repo.'.git')
    call system('mv -f '.i.'/* ./')
    call system('rm -rf '.i)
    echo 'GetGit Done!'
endfunction

function! s:FPWget()
    let url = <SID>FPLineRead()
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
    call FPCD()
    let check = <SID>FPCompassCheck()
    if check == 1
        let cmd = 'compass compile'
        call system(cmd)
        echo cmd
    else
        let check = <SID>FPSassCheck()
        if check == 1
            let cmd = 'sass '.g:FastProject_DefaultSASSDir.':'.g:FastProject_DefaultCSSDir.'&'
            call system(cmd)
            echo cmd
        endif
    endif
endfunction 
autocmd BufWritePost .scss call <SID>FPSassCompile()
autocmd BufWritePost .sass call <SID>FPSassCompile()

function! s:FPInit()
    echo "FastProject:"

    cd %:h
    let repo = <SID>FPLineRead()
    call <SID>FPGetGit(repo)

    call system('echo -e "# '.repo.'" > '.g:FastProject_DefaultConfigFile)
    echo 'overwrite ConfigFile'

    if g:FastProject_SASSWatchStart == 1
        call <SID>FPSassStart()
    endif

    e .

    echo "ALL Done!"
endfunction

function! FPCD(...)
    cd %:h

    let i = 0
    let dir = './'
    while i < g:FastProject_CDLoop
        if !filereadable(dir.g:FastProject_DefaultConfigFile)
            let i = i + 1
            let dir = dir.'../'
        else
            exec 'cd '.dir
            break
        endif
    endwhile

    if a:0 != 0
        let dir = a:000[0]
        exec 'cd '.dir
    endif

    pwd

    if i == g:FastProject_CDLoop
        return 0
    else
        return 1
    endif
endfunction

function! FPEdit(path)
    if FPCD() == 1
        exec 'e '.a:path
    endif
endfunction

function! s:FPTemplateEdit()
    exec g:FastProject_TemplateWindowSize."sp ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
endfunction
function! s:FPList()
    exec g:FastProject_ListWindowSize."sp ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
endfunction
function! s:FPMemo()
    exec g:FastProject_MemoWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
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

    call <SID>FPPoint()
    exec 'e '.g:FastProject_DefaultConfigFile
endfunction
function! s:FPPoint()
    if !isdirectory(g:FastProject_DefaultConfigFile)
        let cmd = 'cp '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate.' '.g:FastProject_DefaultConfigFile
        call system(cmd)
        echo cmd
        let path = matchlist(system('pwd'), '\v(.*)\n')[1]
        call system('echo -e "'.path.'" >> '.s:FastProject_DefaultList)
    else
        echo 'Project file already exists.'
    endif
endfunction

function! s:FPOpen()
    let path = <SID>FPLineRead()
    q
    exec 'cd '.path
    e .
    exec 'echo "Project Open:'.path.'"'
endfunction

function! s:FPBrowseURI()
  let uri = escape(matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*'), '#')
  if uri != ""
    call system("! open " . uri)
  else
    echo "No URI found in line."
  endif
endfunction

function! s:FPLineRead()
    let reg = @@

    silent normal _vg_y
    let line = @@
    let @@ = reg

    return line
endfunction

command! -nargs=* FP call s:FastProject(<f-args>)
command! FPPoint call s:FPPoint()
command! FPInit call s:FPInit()
command! FPCD call FPCD()
command! FPTemplateEdit call s:FPTemplateEdit()
command! FPList call s:FPList()
command! FPOpen call s:FPOpen()
command! FPBrowse call s:FPBrowseURI()
command! FPWget call s:FPWget()

command! FPRoot call FPEdit('.')
command! FPSASS call FPEdit(g:FastProject_DefaultSASSDir)
command! FPCSS call FPEdit(g:FastProject_DefaultCSSDir)
command! FPIMG call FPEdit(g:FastProject_DefaultIMGDir)
command! FPJS call FPEdit(g:FastProject_DefaultJSDir)

command! FPCompassCreate call s:FPCompassCreate()
command! FPSassCompile call s:FPSassCompile()

command! FPDownload call s:FPDownload()
command! FPMemo call s:FPMemo()
command! FPBookmark call s:FPBookmark()

function! s:FPSetBufMapProjectFile()
    nnoremap <buffer> e :FPInit<CR>
    nnoremap <buffer> <CR> :FPInit<CR>
    nnoremap <buffer> q :q<CR>
endfunction
exec 'autocmd BufRead '.g:FastProject_DefaultConfigFile.' call <SID>FPSetBufMapProjectFile()'

function! s:FPSetBufMapProjectTemplateFile()
    nnoremap <buffer> q :q<CR>
endfunction
exec 'autocmd BufRead '.g:FastProject_DefaultConfigFileTemplate.' call <SID>FPSetBufMapProjectTemplateFile()'

function! s:FPSetBufMapProjectList()
    nnoremap <buffer> e :FPOpen<CR>
    nnoremap <buffer> <CR> :FPOpen<CR>
    nnoremap <buffer> q :q<CR>
endfunction
exec 'autocmd BufRead '.g:FastProject_DefaultList.' call <SID>FPSetBufMapProjectList()'

function! s:FPSetBufMapMemo()
    nnoremap <buffer> q :q<CR>
endfunction
exec 'autocmd BufRead '.g:FastProject_DefaultMemo.' call <SID>FPSetBufMapMemo()'

function! s:FPSetBufMapBookmark()
    nnoremap <buffer> e :FPBrowse<CR>
    nnoremap <buffer> <CR> :FPBrowse<CR>
    nnoremap <buffer> q :q<CR>
endfunction
exec 'autocmd BufRead '.g:FastProject_DefaultBookmark.' call <SID>FPSetBufMapBookmark()'

function! s:FPSetBufMapDownload()
    nnoremap <buffer> e :FPWget<CR>
    nnoremap <buffer> <CR> :FPWget<CR>
    nnoremap <buffer> q :q<CR>
endfunction
exec 'autocmd BufRead '.g:FastProject_DefaultDownload.' call <SID>FPSetBufMapDownload()'
