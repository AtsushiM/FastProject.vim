"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let g:FastProject_PluginDir = expand('<sfile>:p:h:h').'/'
let g:FastProject_TemplateDir = g:FastProject_PluginDir.'template/'
let g:FastProject_SubDir = g:FastProject_PluginDir.'sub/'
let g:FastProject_TemplateBeforePath = ''

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

if !exists('g:_FPOpen')
    function g:_FPOpen(path)
        if g:FastProject_UseUnite == 0
            e .
        else
            exec 'Unite -input='.a:path.'/ file'
        endif
    endfunction
endif

command! -nargs=* FP call fp#FastProject(<f-args>)
command! FPAdd call fp#Add()
command! FPInit call fp#Init()
command! FPTemplate call fp#Template()
command! FPList call fp#List()
command! FPConfig call fp#Config()
command! FPOpen call fp#Open()
command! FPProjectFileDelete call fp#ProjectFileDelete()

exec 'au BufRead '.g:FastProject_DefaultConfigFileTemplate.' call fp#SetBufMapProjectTemplateFile()'
exec 'au BufWinLeave '.g:FastProject_DefaultConfigFileTemplate.' call fp#TemplateClose()'
exec 'au BufReadPre '.g:FastProject_DefaultConfigFileTemplate.' let g:FastProject_TemplateBeforePath = getcwd()'
exec 'au BufRead '.g:FastProject_DefaultList.' call fp#SetBufMapProjectList()'
exec 'au BufWinLeave '.g:FastProject_DefaultList.' call fp#ListClose()'
exec 'au BufRead '.g:FastProject_DefaultConfig.' call fp#SetBufMapConfig()'
exec 'au BufWinLeave '.g:FastProject_DefaultConfig.' call fp#ConfigClose()'

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
