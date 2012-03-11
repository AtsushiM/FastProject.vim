"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:FastProject_ToDoNo = 0
let s:FastProject_ToDoOpen = 0

if !exists("g:FastProject_DefaultToDo")
    let g:FastProject_DefaultToDo = '~FastProject-ToDo~'
endif
if !exists("g:FastProject_ToDoWindowSize")
    let g:FastProject_ToDoWindowSize = 'topleft 50vs'
endif

" config
let s:FastProject_DefaultToDo = g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
if !filereadable(s:FastProject_DefaultToDo)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultToDo.' '.s:FastProject_DefaultToDo)
endif

function! s:FPToDoOpen()
    exec g:FastProject_ToDoWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
    let s:FastProject_ToDoOpen = 1
    let s:FastProject_ToDoNo = bufnr('%')
endfunction
function! s:FPToDoClose()
    let s:FastProject_ToDoOpen = 0
    FPToDoSort
    exec 'bw '.s:FastProject_ToDoNo
    winc p
endfunction

function! s:FPToDo()
    if s:FastProject_ToDoOpen == 0
        call s:FPToDoOpen()
    else
        call s:FPToDoClose()
    endif
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
function! FPToDoSort()
    let file = g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
    let todo = readfile(file)
    let ret_normal = ''
    let ret_action = ''
    let ret_end = ''
    for e in todo
        let i = matchlist(e, '\v^(.)\s(.*)')
        if i != []
            if i[1] == '-'
                let ret_normal = ret_normal.e.'\n'
            elseif i[1] == '~'
                let ret_action = ret_action.e.'\n'
            else
                let ret_end = ret_end.e.'\n'
            endif
        endif
    endfor

    " join
    let ret = ret_action.ret_normal.ret_end

    call system('echo -e "'.ret.'" > '.file)
endfunction

command! FPToDo call s:FPToDo()
command! FPCheckToDoStatus call s:FPCheckToDoStatus()
command! FPChangeToDoStatus call s:FPChangeToDoStatus()
command! FPToDoSort call FPToDoSort()
command! FPToDoRemove call s:FPToDoRemove()

function! s:FPSetBufMapToDo()
    set cursorline
    inoremap <buffer><silent> <CR> <Esc>o- 
    inoremap <buffer><silent> <Esc> <Esc>:FPCheckToDoStatus<CR>
    nnoremap <buffer><silent> o o<Esc>:FPCheckToDoStatus<CR>a
    nnoremap <buffer><silent> O O<Esc>:FPCheckToDoStatus<CR>a
    nnoremap <buffer><silent> <Space> :FPChangeToDoStatus<CR>
    nnoremap <buffer><silent> <Tab> :FPChangeToDoStatus<CR>
    nnoremap <buffer><silent> <C-C> :FPChangeToDoStatus<CR>
    nnoremap <buffer><silent> q :call <SID>FPToDoClose()<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultToDo.' call <SID>FPSetBufMapToDo()'
exec 'au BufRead '.g:FastProject_DefaultToDo.' set filetype=fptodo'

function! s:FPVimLeaveToDo()
    FPToDoRemove
    FPToDoSort
endfunction
exec 'au VimLeave '.g:FastProject_DefaultToDo.' call <SID>FPVimLeaveToDo()'

function! s:FPBufLeaveToDo()
    call s:FPToDoClose()
endfunction
exec 'au BufLeave '.g:FastProject_DefaultToDo.' call <SID>FPBufLeaveToDo()'
