"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:FastProject_DownloadNo = 0
let s:FastProject_DownloadOpen = 0

let s:FastProject_DownloadBeforePath = ''

if !exists("g:FastProject_DefaultDownload")
    let g:FastProject_DefaultDownload = '~FastProject-Download~'
endif
if !exists("g:FastProject_DownloadWindowSize")
    let g:FastProject_DownloadWindowSize = 'topleft 50vs'
endif

let s:FastProject_DefaultDownload = g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
if !filereadable(s:FastProject_DefaultDownload)
    call system('cp '.g:FastProject_TemplateDir.g:FastProject_DefaultDownload.' '.s:FastProject_DefaultDownload)
endif

function! s:FPWget()
    let uri = FPURICheck(getline("."))
    if uri != ""
        if s:FastProject_DownloadBeforePath != ''
            exec 'cd '.s:FastProject_DownloadBeforePath
        endif
        let cmd = 'wget '.uri
        call system(cmd)
        echo cmd
    else
        echo "No URI found in line."
    endif
endfunction

function! s:FPDownloadOpen()
    exec g:FastProject_DownloadWindowSize." ".g:FastProject_DefaultConfigDir.g:FastProject_DefaultDownload
    let s:FastProject_DownloadOpen = 1
    let s:FastProject_DownloadNo = bufnr('%')
endfunction
function! s:FPDownloadClose()
    let s:FastProject_DownloadOpen = 0
    exec 'bw '.s:FastProject_DownloadNo
    winc p
endfunction

function! s:FPDownload()
    if s:FastProject_DownloadOpen == 0
        call s:FPDownloadOpen()
    else
        call s:FPDownloadClose()
    endif
endfunction

command! FPWget call s:FPWget()
command! FPDownload call s:FPDownload()

function! s:FPSetBufMapDownload()
    set cursorline
    nnoremap <buffer><silent> e :FPWget<CR>
    nnoremap <buffer><silent> <CR> :FPWget<CR>
    nnoremap <buffer><silent> q :bw %<CR>:winc p<CR>
endfunction
exec 'au BufRead '.g:FastProject_DefaultDownload.' call <SID>FPSetBufMapDownload()'
exec 'au BufReadPre '.g:FastProject_DefaultDownload.' let s:FastProject_DownloadBeforePath = getcwd()'
exec 'au BufWinLeave '.g:FastProject_DefaultDownload.' call <SID>FPDownloadClose()'
