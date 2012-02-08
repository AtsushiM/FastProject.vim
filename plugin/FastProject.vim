"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  todo
"VERSION:  0.1
"LICENSE:  todo

"gitやcompassがインストールされていない場合、エラーを表示させる
"SASSの生成をwatchから保存時実行に変更する

if !exists("g:FastProject_SASSWatchStartRubyKill")
    let g:FastProject_SASSWatchStartRubyKill = 1
endif
if !exists("g:FastProject_VimStartCD")
    " let g:FastProject_VimStartCD = $HOME
    let g:FastProject_VimStartCD = $HOME.'/works'
endif
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
if !exists("g:FastProject_DefaultList")
    let g:FastProject_DefaultList = '.vfplist'
endif

" cd
let $FastProject_VimStartCD = g:FastProject_VimStartCD
cd $FastProject_VimStartCD

" config
let $FastProject_DefaultConfigDir = g:FastProject_DefaultConfigDir
let $FastProject_DefaultConfig = $FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
let $FastProject_DefaultList = $FastProject_DefaultConfigDir.g:FastProject_DefaultList
if !isdirectory($FastProject_DefaultConfigDir)
    call mkdir($FastProject_DefaultConfigDir)
    call system('echo -e "# Select Template\nAtsushiM/test-template\n" > '.$FastProject_DefaultConfig)
    call system('echo -e "# Project List" > '.$FastProject_DefaultList)
endif

autocmd BufNewFile .vfp 0r $FastProject_DefaultConfig

function! s:FPGetGit(repo)
    let i = matchlist(a:repo, '\v(.*)/(.*)')[2]
    echo 'Start GetGit:'
    call system('git clone git://github.com/'.a:repo.'.git')
    call system('mv -f '.i.'/* ./')
    call system('rm -rf '.i)
    echo 'GetGit Done!'
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

function! s:FPRubyKill()
    if g:FastProject_SASSWatchStartRubyKill == 1
        let cmd = 'killall "ruby"'
        call system(cmd)
        echo cmd
    endif
endfunction

function! s:FPSassStart()
    let check = <SID>FPCompassCheck()

    if check == 1
        let cmd = 'compass watch &'
        call <SID>FPRubyKill()
        call system(cmd)
        echo cmd
    else
        let check = <SID>FPSassCheck()
        if check == 1
            let cmd = 'sass --watch '.g:FastProject_DefaultSASSDir.':'.g:FastProject_DefaultCSSDir.'&'
            call <SID>FPRubyKill()
            call system(cmd)
            echo cmd
        endif
    endif
endfunction 

function! s:FPSassStop()
    call <SID>FPRubyKill()
endfunction 

function! s:FPInit()
    echo "FastProject:"

    let reg = @@
    cd %:h

    silent normal _vg_y
    call <SID>FPGetGit(@@)

    call system('echo -e "# '.@@.'" > '.g:FastProject_DefaultConfigFile)
    echo 'overwrite ConfigFile'

    if g:FastProject_SASSWatchStart == 1
        call <SID>FPSassStart()
    endif
    let @@ = reg

    e .

    echo "ALL Done!"
endfunction

function! s:FPStart()
    if FPCD() == 1
        if g:FastProject_SASSWatchStart == 1
            call <SID>FPSassStart()
        endif
        echo "Project Start"
    endif
endfunction
function! s:FPStop()
    if FPCD() == 1
        call <SID>FPRubyKill()
        echo "Project Stop"
    endif
endfunction

function! FPCD(...)
    cd %:h

    let i = 0
    let $dir = './'
    while i < g:FastProject_CDLoop
        if !filereadable($dir.g:FastProject_DefaultConfigFile)
            let i = i + 1
            let $dir = $dir.'../'
        else
            cd $dir
            break
        endif
    endwhile

    if a:0 != 0
        let $dir = a:000[0]
        cd $dir
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
        let $path = a:path
        e $path
    endif
endfunction

function! s:FPTemplateEdit()
    let $conf = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
    sp $conf
endfunction
function! s:FPList()
    let $conf = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
    sp $conf
endfunction

function! s:FastProject(...)
    if a:0 != 0
        let $dir = a:000[0]
        cd $dir
    endif

    call <SID>FPPoint()
    e .vfp
endfunction
function! s:FPPoint()
    if !isdirectory(g:FastProject_DefaultConfigFile)
        let cmd = 'cp '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate.' '.g:FastProject_DefaultConfigFile
        call system(cmd)
        echo cmd
        let path = matchlist(system('pwd'), '\v(.*)\n')[1]
        call system('echo -e "'.path.'" >> '.$FastProject_DefaultList)
    else
        echo 'Project file already exists.'
    endif
endfunction

function! s:FPOpen()
    let reg = @@

    silent normal _vg_y
    let $path = @@

    q
    cd $path
    e .

    let @@ = reg

    echo "Project Open:".$path
endfunction

command! -nargs=* FP call s:FastProject(<f-args>)
command! FPPoint call s:FPPoint()
command! FPInit call s:FPInit()
command! FPCD call FPCD()
command! FPTemplateEdit call s:FPTemplateEdit()
command! FPList call s:FPList()
command! FPOpen call s:FPOpen()

command! FPRoot call FPEdit('.')
command! FPSASS call FPEdit(g:FastProject_DefaultSASSDir)
command! FPCSS call FPEdit(g:FastProject_DefaultCSSDir)
command! FPIMG call FPEdit(g:FastProject_DefaultIMGDir)
command! FPJS call FPEdit(g:FastProject_DefaultJSDir)

command! FPCompassCreate call s:FPCompassCreate()
command! FPSassStart call s:FPSassStart()
command! FPSassStop call s:FPSassStop()
command! FPStart call s:FPStart()
command! FPStop call s:FPStop()

