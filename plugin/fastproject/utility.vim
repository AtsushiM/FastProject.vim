"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

command! FPBrowse call fputility#BrowseURI()
command! -nargs=* -range FPPathAbs <line1>,<line2>call fputility#PathAbs(<f-args>)
command! -nargs=? FPCustomCmds call fputility#CustomCmds(<f-args>)
