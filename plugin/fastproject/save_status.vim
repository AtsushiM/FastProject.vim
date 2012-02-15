"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_SaveVimStatus")
    let g:FastProject_SaveVimStatus = 0
endif

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
