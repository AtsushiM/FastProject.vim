"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

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
    exec g:FastProject_MemoWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
endfunction

command! FPMemo call s:FPMemo()

function! s:FPSetBufMapMemo()
    nnoremap <buffer><silent> b :FPBrowse<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultMemo.' call <SID>FPSetBufMapMemo()'
