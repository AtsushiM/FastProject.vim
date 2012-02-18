"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

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

function! s:FPToDo()
    exec g:FastProject_ToDoWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultToDo
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

command! FPToDo call s:FPToDo()
command! FPCheckToDoStatus call s:FPCheckToDoStatus()
command! FPChangeToDoStatus call s:FPChangeToDoStatus()
command! FPToDoRemove call s:FPToDoRemove()

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
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultToDo.' call <SID>FPSetBufMapToDo()'
exec 'au BufRead '.g:FastProject_DefaultToDo.' set filetype=fptodo'
exec 'au VimLeave * FPToDoRemove'
