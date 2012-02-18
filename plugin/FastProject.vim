"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

let g:FastProject_PluginDir = expand('<sfile>:p:h:h').'/'
let g:FastProject_TemplateDir = g:FastProject_PluginDir.'template/'
let g:FastProject_SubDir = g:FastProject_PluginDir.'sub/'

if !exists("g:FastProject_UseUnite")
    let g:FastProject_UseUnite = 0
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
if !exists("g:FastProject_DefaultConfig")
    let g:FastProject_DefaultConfig = '~config.vim'
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
    let g:FastProject_SubLoad = ['make', 'sass', 'save_status', 'bookmark', 'download', 'memo', 'todo'] 
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

" config
let s:FastProject_DefaultConfig = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfig
if !filereadable(s:FastProject_DefaultConfig)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultConfig.' '.s:FastProject_DefaultConfig)
endif
exec 'source '.s:FastProject_DefaultConfig


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
    exec g:FastProject_TemplateWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
endfunction
function! s:FPList()
    let file = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
    exec g:FastProject_ListWindowSize.' '.file
    silent sort u
    w
endfunction

function! s:FPConfig()
    let file = g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfig
    exec g:FastProject_ConfigWindowSize.' '.file
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
        echo 'No File: '.a:path
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
command! FPConfig call s:FPConfig()
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

function! s:FPSetBufMapConfig()
    nnoremap <buffer><silent> q :source %<CR>:exec 'source '.g:FastProject_PluginDir.'plugin/FastProject.vim'<CR>:bw %<CR>
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
