" デフォルトで開くファイラー他、機能をUniteで使用できるようにする
let g:FastProject_UseUnite = 1

" サブ機能設定
" let g:FastProject_SubLoad = ['bookmark', 'download', 'memo', 'todo'] 
let g:FastProject_SubLoad = ['bookmark', 'download', 'memo', 'todo'] 

" サブ機能の開くウィンドウサイズ
let g:FastProject_MemoWindowSize = 50
let g:FastProject_BookmarkWindowSize = 50
let g:FastProject_DownloadWindowSize = 50
let g:FastProject_ToDoWindowSize = 50
let g:FastProject_TemplateWindowSize = 15
let g:FastProject_ListWindowSize = 15
let g:FastProject_ConfigWindowSize = 15

" Vim起動時にサブ機能を開く
let g:FastProject_PreOpenList = 0
let g:FastProject_PreOpenMemo = 0
let g:FastProject_PreOpenToDo = 0

" デフォルトでcdするディレクトリを指定
" let g:FastProject_PreCD = ''
let g:FastProject_PreCD = $HOME.'/works'

" 現在カーソルの位置を記憶
let g:FastProject_AutoCursorLastChange = 1

" プロジェクトのルートディレクトリを検索する際のループ回数
" プロジェクトの階層が深い場合は変更する必要があるかも
let g:FastProject_CDLoop = 5

" ファイルを開くたびに自動でプロジェクトのルートへcd
let g:FastProject_AutoCDRoot = 0

" 画像フォルダ名
let g:FastProject_DefaultIMGDir = 'img'
" JavaScriptフォルダ名
let g:FastProject_DefaultJSDir = 'js'
" sassのフォルダ名
let g:FastProject_DefaultSASSDir = 'scss'
" cssのフォルダ名
let g:FastProject_DefaultCSSDir = 'css'

" sassを保存した場合、自動でコンパイル(compass対応)
let g:FastProject_AutoSassCompile = 1

" 拡張子を登録すれば、プロジェクトにMakefileが存在する場合、
" 自動でmakeコマンドを実行
" let g:FastProject_AutoMake = []
let g:FastProject_AutoMake = ['js', 'php']

" 終了時のvimの状態を保存（プラグインによるバグが発生する可能性有り）
let g:FastProject_SaveVimStatus = 0

