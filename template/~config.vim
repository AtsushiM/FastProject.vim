"" FastProject Config File ver 0.9
"" FastProject.vimへようこそ。
"" FastProjectはVimによる開発を高速化する目的で作成されたプラグインです。
"" このファイルの記述されている設定のコメントを外す、
"" または書き換えることによって柔軟な調整が可能です。

"" サンプルキーマップ
"" プロジェクト一覧
" nnoremap ;fl :FPList<CR>
"" 現在ディレクトリをプロジェクトに追加
" nnoremap ;fa :FPAdd<CR>
"" ToDo機能を開く
" nnoremap ;ft :FPToDo<CR>
"" メモ機能を開く
" nnoremap ;fm :FPMemo<CR>
"" ブックマークを開く
" nnoremap ;fb :FPBookmark<CR>
"" ダウンロード機能を開く
" nnoremap ;fd :FPDownload<CR>

"" ファイラーで開く
"" プロジェクトルート
" nnoremap ;fr :FPEditRoot<CR>
"" js
" nnoremap ;fj :FPEditJS<CR>
"" sass
" nnoremap ;fs :FPEditSASS<CR>
"" css
" nnoremap ;fc :FPEditCSS<CR>
"" img
" nnoremap ;fi :FPEditIMG<CR>

"" プロジェクトルートから見たパスへcd
"" プロジェクトルート
" nnoremap ;fcr :FPCDRoot<CR>
"" js
" nnoremap ;fcj :FPCDJS<CR>
"" sass
" nnoremap ;fcs :FPCDSASS<CR>
"" css
" nnoremap ;fcc :FPCDCSS<CR>
"" img
" nnoremap ;fci :FPCDIMG<CR>

"" Uniteでプロジェクト一覧を開く
" nnoremap <silent> ;up :<C-u>Unite fastproject<CR>

"" サブ機能設定
"" 使用しない機能は下記リストから削除することによって読み込まれません
" let g:FastProject_SubLoad = ['make', 'sass', 'bookmark', 'download', 'memo', 'todo'] 

"" デフォルトで開くファイラー他、機能をUniteで使用できるようにする
"" Uniteのsourceにfastprojectが追加され、
"" :Unite fastproject で登録したプロジェクトの一覧から検索が可能です
" let g:FastProject_UseUnite = 1

"" プラグインの各機能で使用するディレクトリ名です
"" リストの前の物ほど優先されます
"" 画像
"let g:FastProject_DefaultIMGDir = ['img', 'imgs', 'image', 'images']
"" JavaScript
"let g:FastProject_DefaultJSDir = ['js', 'javascript', 'javascripts']
"" sass
"let g:FastProject_DefaultSASSDir = ['sass', 'scss']
"" css
"let g:FastProject_DefaultCSSDir = ['css', 'stylesheet']

"" sass,scssを保存した場合、自動でコンパイル(compass対応)
"" プロジェクトルートにconfig.rbファイルが存在していればcompass compile,
"" ない場合でかつg:FastProject_DefaultSASSDirと g:FastProject_DefaultCSSDirの
"" ディレクトリが存在してれば sass --update を実行します
" let g:FastProject_AutoSassCompile = 1

"" 登録された拡張子を保存した場合でかつ、
"" プロジェクトルートにMakefileが存在する場合、
"" 自動でmakeコマンドを実行
" let g:FastProject_AutoMake = ['js','php']

"" 機能ウィンドウサイズ&位置
"" 'topleft ~sp' で 画面上、
"" 'topleft ~vs' で 画面左、
"" 'botright ~sp' で 画面下、
"" 'botright ~vs' で 画面右に
"" それぞれ ~ の大きさで機能のウィンドウを開きます
" let g:FastProject_MemoWindowSize = 'topleft 50vs'
" let g:FastProject_BookmarkWindowSize = 'topleft 50vs'
" let g:FastProject_DownloadWindowSize = 'topleft 50vs'
" let g:FastProject_ToDoWindowSize = 'topleft 50vs'
" let g:FastProject_TemplateWindowSize = 'topleft 15sp'
" let g:FastProject_ListWindowSize = 'topleft 15sp'
" let g:FastProject_ConfigWindowSize = 'topleft vs'

"" ファイルを開くたびに自動でプロジェクトのルートへcd
"" プロジェクトルートはプロジェクトファイル(.vimfastproject)の有無で判断
"" 現在ファイルからg:FastProjectCDLoop階層分まで親ディレクトリを再帰的に検索
" let g:FastProject_AutoCDRoot = 0

"" プロジェクトのルートディレクトリを検索する際のループ回数
" let g:FastProject_CDLoop = 5

"" プロジェクトリストからプロジェクトを開く際の動作を上書き
"" ※デフォルトではファイラーを開きます
"" 設定例
"" 左にサイズ80でjsフォルダのmain.js,
"" 右上にindex.html,右下にscss/screen.cssを開く
" function! g:_FPOpen(...)
"     80vs
"     e js/main.js
"     winc l
"     sp
"     e index.html
"     winc j
"     e scss/screen.scss
"     winc h
" endfunction

"" FastProjectの関数を利用した例
"" 開発用のディレクトリから本番用のディレクトリに
"" js,css,imgフォルダ内のファイルを移動する
"" 使用例
"" :FPCP
" function! s:FPCP()
"     let dir = getcwd()
"     FPCD
"     cd ../../
"     pwd
"     let cmd = 'cp -f preview/htdocs/css/* www/htdocs/css/|cp -f preview/htdocs/js/* www/htdocs/js/|cp -f preview/htdocs/img/* www/htdocs/img/'
"     echo cmd
"     call system(cmd)
"     exec 'cd '.dir
" endfunction
" command! FPCP call s:FPCP()
