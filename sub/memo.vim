"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_PreOpenMemo")
    let g:FastProject_PreOpenMemo = 0
endif
if !exists("g:FastProject_DefaultMemo")
    let g:FastProject_DefaultMemo = '~FastProject-MEMO~'
endif
if !exists("g:FastProject_MemoWindowSize")
    let g:FastProject_MemoWindowSize = 50
endif

let s:FastProject_DefaultMemo = g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
if !filereadable(s:FastProject_DefaultMemo)
    call system('echo -e "# Memo" > '.s:FastProject_DefaultMemo)
endif

function! s:FPMemo()
    exec "botright ".g:FastProject_MemoWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultMemo
endfunction

command! FPMemo call s:FPMemo()

function! s:FPSetBufMapMemo()
    nnoremap <buffer><silent> b :FPBrowse<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultMemo.' call <SID>FPSetBufMapMemo()'

if g:FastProject_PreOpenMemo == 1
    FPMemo
endif
