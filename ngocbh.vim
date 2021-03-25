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