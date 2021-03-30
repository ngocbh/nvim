let g:airline_powerline_fonts = 1

set cindent

let g:tex_flavor = 'latex'

let g:pydocstring_formatter = 'numpy'

nmap <silent> <C-_> <Plug>(pydocstring)


" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gd :call CocAction('jumpDefinition', 'tab drop') <CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <S-l> w
nnoremap <silent> <S-h> b
nnoremap <silent> <S-j> <S-l>
nnoremap <silent> <S-k> <S-h>

vnoremap <silent> <S-l> w
vnoremap <silent> <S-h> b
vnoremap <silent> <S-j> <S-l>
vnoremap <silent> <S-k> <S-h>

set number relativenumber


" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" move block up/down in visual and normal mode"
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv