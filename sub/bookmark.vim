"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:FastProject_DefaultBookmark")
    let g:FastProject_DefaultBookmark = '~FastProject-Bookmark~'
endif
if !exists("g:FastProject_BookmarkWindowSize")
    let g:FastProject_BookmarkWindowSize = 'topleft 50vs'
endif

let s:FastProject_DefaultBookmark = g:FastProject_DefaultConfigDir.g:FastProject_DefaultBookmark
if !filereadable(s:FastProject_DefaultBookmark)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultBookmark.' '.g:FastProject_DefaultConfigDir.g:FastProject_DefaultBookmark)
endif

function! s:FPBookmark()
    exec g:FastProject_BookmarkWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultBookmark
endfunction
command! FPBookmark call s:FPBookmark()

function! s:FPSetBufMapBookmark()
    set cursorline
    nnoremap <buffer><silent> e :FPBrowse<CR>
    nnoremap <buffer><silent> <CR> :FPBrowse<CR>
    nnoremap <buffer><silent> q :bw %<CR>:winc p<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultBookmark.' call <SID>FPSetBufMapBookmark()'
