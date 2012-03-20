"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:FastProject_CDLoop")
    let g:FastProject_CDLoop = 5
endif
if !exists("g:FastProject_AutoCDRoot")
    let g:FastProject_AutoCDRoot = 0
endif
if !exists("g:FastProject_DefaultIMGDir")
    let g:FastProject_DefaultIMGDir = ['img', 'imgs', 'image', 'images']
endif
if !exists("g:FastProject_DefaultJSDir")
    let g:FastProject_DefaultJSDir = ['js', 'javascript', 'javascripts']
endif

command! -nargs=* FPCD call fpcd#CD(<f-args>)
command! -nargs=? FPEdit call fpcd#Edit(<f-args>)

if g:FastProject_AutoCDRoot == 1
    au BufReadPost * exec fpcd#CD() 
endif
