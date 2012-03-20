"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:FastProject_BookmarkNo = 0
let s:FastProject_BookmarkOpen = 0

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

function! s:FPBookmarkOpen()
    exec g:FastProject_BookmarkWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultBookmark
    let s:FastProject_BookmarkOpen = 1
    let s:FastProject_BookmarkNo = bufnr('%')
endfunction
function! s:FPBookmarkClose()
    let s:FastProject_BookmarkOpen = 0
    exec 'bw '.s:FastProject_BookmarkNo
    winc p
endfunction

function! s:FPBookmark()
    if s:FastProject_BookmarkOpen == 0
        call s:FPBookmarkOpen()
    else
        call s:FPBookmarkClose()
    endif
endfunction
command! FPBookmark call s:FPBookmark()

function! s:FPSetBufMapBookmark()
    set cursorline
    nnoremap <buffer><silent> e :FPBrowse<CR>
    nnoremap <buffer><silent> <CR> :FPBrowse<CR>
    nnoremap <buffer><silent> q :call <SID>FPBookmarkClose()<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultBookmark.' call <SID>FPSetBufMapBookmark()'
exec 'au BufWinLeave '.g:FastProject_DefaultBookmark.' call <SID>FPBookmarkClose()'
