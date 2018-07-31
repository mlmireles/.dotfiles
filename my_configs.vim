"
" FONT:
" https://github.com/adobe-fonts/source-code-pro
" Instalar la font normal, ya con eso se usara.
"
" TAGS:
" Para que los tags se actualicen automaticamente.
" https://github.com/xolox/vim-misc
" https://github.com/xolox/vim-easytags
"
" AUTOCOMPLETAR:
" https://github.com/Shougo/neocomplete.vim
"
" MOVIMIENTO_RAPIDO:
" https://github.com/easymotion/vim-easymotion
"
" Para usar:
" <leader><leader>(el comando)
" Ejemplo:  ,,w (busca al inicio de todas las palabras)
"           ,,fo (busca todas las o)
"
" JAVASCRIPT: 
" https://github.com/pangloss/vim-javascript.git
" https://github.com/jelera/vim-javascript-syntax
"
" FORMATEO_ALINIACION:
" https://github.com/godlygeek/tabular
"
" Par usar:
" :Tab /= (para alinear en base al signo =)
" :Tab/: (para alinear en base al signo :)
" :Tab /:\zs (para alinear en base al signo : pero colocandolo al final de la 
" primera palabra -> palabra:     textoalineando)
" 
" GIT:
" https://github.com/airblade/vim-gitgutter
"
" Indent Guides:
" git://github.com/nathanaelkane/vim-indent-guides.git
"
" Para togglearlas: <leader>ig
"
" AUTO INDENT PASTE:
" Para que al user p y P, lo que pegues tenga indentacion correcta
" https://github.com/sickill/vim-pasta
" 
" MATCHIT:
" Extiende la funcionalidad de %, para que tambien funcione con tags html, xml, etc.
" https://github.com/tmhedberg/matchit
"
" Para Hacer Surround:
" Normal mode
" -----------
" ds  - delete a surrounding
" cs  - change a surrounding
" ys  - add a surrounding
" yS  - add a surrounding and place the surrounded text on a new line + indent it
" yss - add a surrounding to the whole line

" Visual mode
" -----------
" s   - in visual mode, add a surrounding
" s   - in visual mode, add a surrounding but place text on new line + indent it

" Insert mode
" -----------
" <CTRL-s> - in insert mode, add a surrounding
" <CTRL-s><CTRL-s> - in insert mode, add a new line + surrounding + indent
" <CTRL-g>s - same as <CTRL-s>
" <CTRL-g>S - same as <CTRL-s><CTRL-s>
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""" HS
set background=dark

" Sin archivos de backup
set nobackup
set nowritebackup
set noswapfile
set nowrap

" Window resize via Alt + Shift + arrows
map <A-S-Left> <C-W>>
map <A-S-Right> <C-W><
map <A-S-Up> <C-W>+
map <A-S-Down> <C-W>-

" use ESC to remove search higlight
nnoremap <esc><esc> :noh<return><esc>

" Key mapping for windows navigationnwith TMUX
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif

set ff=unix

" Numeros relativos
set relativenumber
set number

" show command in the last line
set sc

" TypeScript
autocmd FileType ts setlocal shiftwidth=2 tabstop=2
autocmd BufNewFile,BufRead *.ts set shiftwidth=2 tabstop=2

">>>>>>>>>>>>>>>>>> HS

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>0 :tablast<cr>

" Cambia el working directory al dir del archivo que tenemos seleccionado
autocmd BufEnter * silent! lcd %:p:h

" Hace que los tags se busquen desde el dir del archivo seleccionado hasta el root
set tags=tags;


"------------------ brackets ----------------
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap {<CR> {<CR>}<Esc>ko
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf

function CloseBracket()
 if match(getline(line('.') + 1), '\s*}') < 0
 return "\<CR>}"
 else
 return "\<Esc>j0f}a"
 endif
endf

function QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf
"------------------ end brackets ------------


"****************** configure neocomplete **************************
" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3

" Easy Aligns
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Recommended key-mappings.
" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
  " return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  " return pumvisible() ? neocomplete#close_popup() : "\<CR>"
" endfunction
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Enable omni completion.
filetype plugin on
set omnifunc=syntaxcomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"" Define keyword.
" if !exists('g:neocomplete#keyword_patterns')
    " let g:neocomplete#keyword_patterns = {}
" endif
" let g:neocomplete#keyword_patterns['default'] = '\h\w*'

"""""""""""""" SYNTASTIC """"""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_enable_signs= 1
let g:syntastic_check_on_wq = 0
let g:syntastic_c_checkers = []
let g:syntastic_cpp_checkers = []
let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_html_checkers = ['tidy']

" C
let g:syntastic_c_config_file=".vim_syntax" 

""""""""""""""" Javascript syntax """""""""""""""
let g:javascript_enable_domhtmlcss = 1

"""""""""""""" GitGutter """"""""""""""""
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_enabled = 0
let g:gitgutter_signs = 1
let g:gitgutter_highlight_lines = 0

"""""""""""""" TAGBAR """"""""""""""""
map <leader>9 :TagbarToggle<CR>

"""""""""""""" SNIPPETS """"""""""""""""
" Comentarios:
inoremap $$ /*<space><space>*/<esc>hhi
inoremap $# /*<CR><CR>/<esc>kA<tab>
inoremap $% <esc>mcI//<esc>`c

" Pone ; al final de la linea sin mover el cursor de su lugar
inoremap ;; <esc>mcA;<esc>`c 


"""""""""""""" QUICK jumps """"""""""""""""
map <leader>a <leader><leader>s

    
"""""""""""""" ACK """"""""""""""""
let g:ack_default_options = " -s -H --nocolor --nogroup --column --smart-case --known-types --ignore-dir=build --ignore-dir=disassembly --ignore-dir=debug --ignore-dir=dist --ignore-dir=nbproject"

" Mapeamos el F1 para cerrar el archivo
map <F1> :q<CR>


" Funciones para Convertir de Hex <-> DEC
command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function! s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo printf('%x', a:arg + 0)
  endif
endfunction

command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')
function! s:Hex2dec(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V0x\x\+/\=submatch(0)+0/g'
    else
      let cmd = 's/0x\x\+/\=submatch(0)+0/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No hex number starting "0x" found'
    endtry
  else
    echo (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
  endif
endfunction

" Remapeamos el : a ; para tener mas facil acceso
map ; :

" Wildfire (seleccion)
let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it"]
nmap <leader>l <Plug>(wildfire-quick-select)

set colorcolumn=80

" YouCompleteME
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 0

" color_coded (para sintax highliting en c, c++, objC)
let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c']

"" Ultisnips
let g:UltiSnipsExpandTrigger= "<c-tab>"
let g:UltiSnipsListSnippets= "<c-s-tab>"

" Cierra el scratch automaticamente al elegir la opcion de YCM
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Splits mas naturales, abre el split a la derecha o abajo
set splitbelow
set splitright

" Para copiar y hacer append a un registro. Util para ir copiando varias cosas
" que no estan contiguas y luego pegarlas en una sola operacion (prototipos
" en c.)
"
" Esto lo hace mejor el plugin Repeatable Yank... con gy y gyy, la primera vez
" tienes que especificar el registro, asi que si creamos ese mapping ya que
" es util
map <leader>y "tgyy
xmap <leader>y "tgy
" noremap <leader>T "tyy
" noremap <leader>t "Tyy
" vnoremap <leader>T "ty
" vnoremap <leader>t "Ty

" lo mismo pero borrando (aqui si tenemos que definir el comando de pegar)
noremap <leader>R "rdd
noremap <leader>rd "Rdd
vmap <leader>R "rd
vmap <leader>rd "Rd
noremap <leader>rp "Rp
noremap <leader>rP "RP
vmap <leader>rp "Rp


" Para borrar y colocar lo borrado en el hoyo negro. Util para cuando no
" quieres perder la referencia de lo que yankeaste.
map <leader>d "_dd
xmap <leader>d "_d

" CtrlSF Para buscar en multoples archivos (require Ag o Ack)
"nmap     <C-k>f <Plug>CtrlSFPrompt
"vmap     <C-k>f <Plug>CtrlSFVwordPath
"vmap     <C-k>F <Plug>CtrlSFVwordExec
"nmap     <C-k>k <Plug>CtrlSFCwordPath
"nmap     <C-k>? <Plug>CtrlSFPwordPath
"nnoremap <C-k>o :CtrlSFOpen<CR>
"nnoremap <C-k>t :CtrlSFToggle<CR>
"inoremap <C-k>t <Esc>:CtrlSFToggle<CR>

" Para que Ctrls use el root de tu poryecto (donde esta el .git)
let g:ctrlsf_default_root = 'project'

" Para ignorar ciertos archivos con contrlp
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*.d,*.properties,nbproject     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|build|\_ext)$',
  \ 'file': '\v\.(exe|so|dll|o|d)$',
  \ }

let g:airline_powerline_fonts = 1 

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
