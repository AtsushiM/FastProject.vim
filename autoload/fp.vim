"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:FastProject_TemplateNo = 0
let s:FastProject_TemplateOpen = 0
let s:FastProject_ConfigNo = 0
let s:FastProject_ConfigOpen = 0
let s:FastProject_ListNo = 0
let s:FastProject_ListOpen = 0
let s:FastProject_DefaultList = g:FastProject_DefaultConfigDir.g:FastProject_DefaultList

function! fp#TemplateOpen()
    exec g:FastProject_TemplateWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfigFileTemplate
    let s:FastProject_TemplateOpen = 1
    let s:FastProject_TemplateNo = bufnr('%')
endfunction
function! fp#TemplateClose()
    let s:FastProject_TemplateOpen = 0
    exec 'bw '.s:FastProject_TemplateNo
    winc p
endfunction
function! fp#Template()
    if s:FastProject_TemplateOpen == 0
        call fp#TemplateOpen()
    else
        call fp#TemplateClose()
    endif
endfunction

function! fp#ConfigOpen()
    exec g:FastProject_ConfigWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultConfig
    let s:FastProject_ConfigOpen = 1
    let s:FastProject_ConfigNo = bufnr('%')
endfunction
function! fp#ConfigClose()
    let s:FastProject_ConfigOpen = 0
    exec 'bw '.s:FastProject_ConfigNo
    winc p
endfunction
function! fp#Config()
    if s:FastProject_ConfigOpen == 0
        call fp#ConfigOpen()
    else
        call fp#ConfigClose()
    endif
endfunction

function! fp#ListOpen()
    exec g:FastProject_ListWindowSize.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultList
    silent sort u
    w
    let s:FastProject_ListOpen = 1
    let s:FastProject_ListNo = bufnr('%')
endfunction
function! fp#ListClose()
    let s:FastProject_ListOpen = 0
    exec 'bw '.s:FastProject_ListNo
    winc p
endfunction
function! fp#List()
    if s:FastProject_ListOpen == 0
        call fp#ListOpen()
    else
        call fp#ListClose()
    endif
endfunction

function! fp#AddCore()
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

function! fp#Add()
    cd %:p:h
    call fp#AddCore()
endfunction

function! fp#Init()
    if g:FastProject_TemplateBeforePath != ''
        echo "FastProject:"

        exec 'cd '.g:FastProject_TemplateBeforePath

        let repo = getline('.')
        call fputility#GetGit(repo)

        call fp#AddCore()

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

function! fp#Open()
    let path = getline('.')
    q
    exec 'cd '.path
    call g:_FPOpen(path)
    exec 'echo "Project Open:'.path.'"'
endfunction

function! fp#FastProject(...)
    if a:0 != 0
        if !isdirectory(a:000[0])
            call mkdir(a:000[0])
        endif
        exec 'cd '.a:000[0]
    endif

    FPTemplate
endfunction

function! fp#ProjectFileDelete()
    let path = getline('.')
    let path = path.'/'.g:FastProject_DefaultConfigFile
    echo path
    call fputility#Delete(path)
endfunction

function! fp#SetBufMapProjectTemplateFile()
    set cursorline
    nnoremap <buffer><silent> e :fp#Init<CR>
    nnoremap <buffer><silent> <CR> :fp#Init<CR>
    nnoremap <buffer><silent> q :call fp#TemplateClose()<CR>
endfunction

function! fp#SetBufMapProjectList()
    set cursorline
    nnoremap <buffer><silent> e :fp#Open<CR>
    nnoremap <buffer><silent> <CR> :fp#Open<CR>
    nnoremap <buffer><silent> q :call fp#ListClose()<CR>
    nnoremap <buffer><silent> dd :fp#ProjectFileDelete<CR>dd:w<CR>
endfunction

function! fp#SetBufMapConfig()
    nnoremap <buffer><silent> q :bw %<CR>
    nnoremap <buffer><silent> q :call fp#ConfigClose()<CR>
endfunction
