"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.1
"LICENSE:  MIT

if !exists("g:FastProject_DefaultDownload")
    let g:FastProject_DefaultDownload = '~FastProject-Download~'
endif
if !exists("g:FastProject_DownloadWindowSize")
    let g:FastProject_DownloadWindowSize = 50
endif

let s:FastProject_DefaultDownload = g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
if !filereadable(s:FastProject_DefaultDownload)
    call system('echo -e "# Project DownloadList" > '.s:FastProject_DefaultDownload)
endif

function! s:FPDownload()
    exec g:FastProject_DownloadWindowSize."vs ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
endfunction

command! FPDownload call s:FPDownload()

function! s:FPSetBufMapDownload()
    set cursorline
    nnoremap <buffer><silent> e :FPWget<CR>
    nnoremap <buffer><silent> <CR> :FPWget<CR>
    nnoremap <buffer><silent> q :bw %<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultDownload.' call <SID>FPSetBufMapDownload()'
