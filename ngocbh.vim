let g:airline_powerline_fonts = 1

set cindent

let g:tex_flavor = 'latex'

let g:pydocstring_formatter = 'google'

nmap <silent> <C-n> <Plug>(pydocstring)


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
