"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:FastProject_MemoNo = 0
let s:FastProject_MemoOpen = 0

if !exists("g:FastProject_DefaultMemo")
    let g:FastProject_DefaultMemo = '~FastProject-MEMO~'
endif
if !exists("g:FastProject_MemoWindowSize")
    let g:FastProject_MemoWindowSize = 'topleft 50vs'
endif

let s:FastProject_DefaultMemo = g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
if !filereadable(s:FastProject_DefaultMemo)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultMemo.' '.s:FastProject_DefaultMemo)
endif

function! s:FPMemo()
    if s:FastProject_MemoOpen == 0
        exec g:FastProject_MemoWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
        let s:FastProject_MemoOpen = 1
        let s:FastProject_MemoNo = bufnr('%')
    else
        let s:FastProject_MemoOpen = 0
        exec 'bw '.s:FastProject_MemoNo
    endif
endfunction

command! FPMemo call s:FPMemo()

function! s:FPSetBufMapMemo()
    nnoremap <buffer><silent> b :FPBrowse<CR>
    nnoremap <buffer><silent> q :bw %<CR>:winc p<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultMemo.' call <SID>FPSetBufMapMemo()'
