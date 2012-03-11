"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let g:FastProject_PluginDir = expand('<sfile>:p:h:h').'/'
let g:FastProject_TemplateDir = g:FastProject_PluginDir.'template/'
let g:FastProject_SubDir = g:FastProject_PluginDir.'sub/'
let g:FastProject_TemplateBeforePath = ''

let s:FastProject_TemplateNo = 0
let s:FastProject_TemplateOpen = 0
let s:FastProject_ConfigNo = 0
let s:FastProject_ConfigOpen = 0
let s:FastProject_ListNo = 0
let s:FastProject_ListOpen = 0

if !exists("g:FastProject_DefaultConfigDir")
    let g:FastProject_DefaultConfigDir = $HOME.'/.vimfastproject/'
endif
if !exists("g:FastProject_DefaultConfigFile")
    let g:FastProject_DefaultConfigFile = '.vimfastproject'
endif
if !exists("g:FastProject_DefaultConfigFileTemplate")
    let g:FastProject_DefaultConfigFileTemplate = '~FastProject-Template~'
endif
if !exists("g:FastProject_DefaultList")
    let g:FastProject_DefaultList = '~FastProject-List~'
endif
if !exists("g:FastProject_DefaultConfig")
    let g:FastProject_DefaultConfig = '~config.vim'
endif

" config
let s:FastProject_DefaultConfig = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfig
if !filereadable(s:FastProject_DefaultConfig)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultConfig.' '.s:FastProject_DefaultConfig)
endif
exec 'source '.s:FastProject_DefaultConfig

if !exists("g:FastProject_UseUnite")
    let g:FastProject_UseUnite = 0
endif
if !exists("g:FastProject_TemplateWindowSize")
    let g:FastProject_TemplateWindowSize = 'topleft 15sp'
endif
if !exists("g:FastProject_ListWindowSize")
    let g:FastProject_ListWindowSize = 'topleft 15sp'
endif
if !exists("g:FastProject_ConfigWindowSize")
    let g:FastProject_ConfigWindowSize = 'topleft vs'
endif
if !exists("g:FastProject_SubLoad")
    let g:FastProject_SubLoad = ['make', 'sass', 'bookmark', 'download', 'memo', 'todo'] 
endif

" config
let s:FastProject_DefaulTemplate = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
let s:FastProject_DefaultList = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
if !isdirectory(g:FastProject_DefaultConfigDir)
    call mkdir(g:FastProject_DefaultConfigDir)
endif
if !filereadable(s:FastProject_DefaulTemplate)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultConfigFileTemplate.' '.s:FastProject_DefaulTemplate)
endif

if !filereadable(s:FastProject_DefaultList)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultList.' '.s:FastProject_DefaultList)
endif

" sub include
if g:FastProject_SubLoad != []
    for e in g:FastProject_SubLoad
        exec 'source '.g:FastProject_SubDir.e.'.vim'
    endfor
endif

function! s:FPTemplateOpen()
    exec g:FastProject_TemplateWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
    let s:FastProject_TemplateOpen = 1
    let s:FastProject_TemplateNo = bufnr('%')
endfunction
function! s:FPTemplateClose()
    let s:FastProject_TemplateOpen = 0
    exec 'bw '.s:FastProject_TemplateNo
    winc p
endfunction
function! s:FPTemplate()
    if s:FastProject_TemplateOpen == 0
        call s:FPTemplateOpen()
    else
        call s:FPTemplateClose()
    endif
endfunction

function! s:FPConfigOpen()
    exec g:FastProject_ConfigWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfig
    let s:FastProject_ConfigOpen = 1
    let s:FastProject_ConfigNo = bufnr('%')
endfunction
function! s:FPConfigClose()
    let s:FastProject_ConfigOpen = 0
    exec 'bw '.s:FastProject_ConfigNo
    winc p
endfunction
function! s:FPConfig()
    if s:FastProject_ConfigOpen == 0
        call s:FPConfigOpen()
    else
        call s:FPConfigClose()
    endif
endfunction

function! s:FPListOpen()
    exec g:FastProject_ListWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
    silent sort u
    w
    let s:FastProject_ListOpen = 1
    let s:FastProject_ListNo = bufnr('%')
endfunction
function! s:FPListClose()
    let s:FastProject_ListOpen = 0
    exec 'bw '.s:FastProject_ListNo
    winc p
endfunction
function! s:FPList()
    if s:FastProject_ListOpen == 0
        call s:FPListOpen()
    else
        call s:FPListClose()
    endif
endfunction

function! s:FPAddCore()
    if !filereadable(g:FastProject_DefaultConfigFile)
        let cmd = 'cp '.g:FastProject_TemplateDir.g:FastProject_DefaultConfigFile.' '.g:FastProject_DefaultConfigFile
        call system(cmd)
        echo cmd
        let path = matchlist(system('pwd'), '\v(.*)\n')[1]
        call system('echo -e "'.path.'" >> '.s:FastProject_DefaultList)
    else
        echo 'Project file already exists.'
    endif
endfunction

function! s:FPAdd()
    cd %:p:h
    call <SID>FPAddCore()
endfunction

function! s:FPInit()
    if g:FastProject_TemplateBeforePath != ''
        echo "FastProject:"

        exec 'cd '.g:FastProject_TemplateBeforePath

        let repo = getline('.')
        call FPGetGit(repo)

        call <SID>FPAddCore()

        bw %

        if g:FastProject_UseUnite == 0
            exec 'e '.g:FastProject_TemplateBeforePath
        else
            exec 'Unite -input='.g:FastProject_TemplateBeforePath.'/ file'
        endif

        echo "ALL Done!"
    else
        echo 'No before path.'
    endif
endfunction

function! s:FPOpen()
    let path = getline('.')
    q
    exec 'cd '.path
    call g:_FPOpen(path)
    exec 'echo "Project Open:'.path.'"'
    silent call <SID>FPAddCore()
endfunction

if !exists('g:_FPOpen')
    function g:_FPOpen(path)
        if g:FastProject_UseUnite == 0
            e .
        else
            exec 'Unite -input='.a:path.'/ file'
        endif
    endfunction
endif

function! s:FastProject(...)
    if a:0 != 0
        if !isdirectory(a:000[0])
            call mkdir(a:000[0])
        endif
        exec 'cd '.a:000[0]
    endif

    FPTemplate
endfunction

function! s:FPProjectFileDelete()
    let path = getline('.')
    let path = path.'/'.g:FastProject_DefaultConfigFile
    echo path
    call FPDelete(path)
endfunction

command! -nargs=* FP call s:FastProject(<f-args>)
command! FPAdd call s:FPAdd()
command! FPInit call s:FPInit()
command! FPTemplate call s:FPTemplate()
command! FPList call s:FPList()
command! FPConfig call s:FPConfig()
command! FPOpen call s:FPOpen()
command! FPProjectFileDelete call s:FPProjectFileDelete()

function! s:FPSetBufMapProjectTemplateFile()
    set cursorline
    nnoremap <buffer><silent> e :FPInit<CR>
    nnoremap <buffer><silent> <CR> :FPInit<CR>
    nnoremap <buffer><silent> q :call <SID>FPTemplateClose()<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultConfigFileTemplate.' call <SID>FPSetBufMapProjectTemplateFile()'
exec 'au BufReadPre '.g:FastProject_DefaultConfigFileTemplate.' let g:FastProject_TemplateBeforePath = getcwd()'
function! s:FPBufLeaveTemplate()
    call s:FPTemplateClose()
endfunction
exec 'au BufLeave '.g:FastProject_DefaultConfigFileTemplate.' call <SID>FPBufLeaveTemplate()'

function! s:FPBufLeaveConfig()
    call s:FPConfigClose()
endfunction
exec 'au BufLeave '.g:FastProject_DefaultConfig.' call <SID>FPBufLeaveConfig()'

function! s:FPBufLeaveList()
    call s:FPListClose()
endfunction
exec 'au BufLeave '.g:FastProject_DefaultList.' call <SID>FPBufLeaveList()'

function! s:FPSetBufMapProjectList()
    set cursorline
    nnoremap <buffer><silent> e :FPOpen<CR>
    nnoremap <buffer><silent> <CR> :FPOpen<CR>
    nnoremap <buffer><silent> q :bw %<CR>:winc p<CR>
    nnoremap <buffer><silent> dd :FPProjectFileDelete<CR>dd
endfunction
exec 'au BufRead '.g:FastProject_DefaultList.' call <SID>FPSetBufMapProjectList()'

function! s:FPSetBufMapConfig()
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultConfig.' call <SID>FPSetBufMapConfig()'

if g:FastProject_UseUnite == 1
    let s:unite_source = {
    \   'name': 'fastproject',
    \ }
    function! s:unite_source.gather_candidates(args, context)
      let lines = readfile(g:FastProject_DefaultConfigDir.g:FastProject_DefaultList)
      return map(lines, '{
      \   "word": v:val,
      \   "source": "fastproject",
      \   "kind": "command",
      \   "action__command": "cd ".v:val."|Unite -input=".v:val."/ file",
      \ }')
    endfunction
    call unite#define_source(s:unite_source)
    unlet s:unite_source
endif
