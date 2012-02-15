scriptencoding utf-8
syntax match todoNormal '^-'
syntax match todoAction '^\~'
syntax match todoEnd '^\/'
highlight link todoNormal Constant
highlight link todoAction Title
highlight link todoEnd Type
