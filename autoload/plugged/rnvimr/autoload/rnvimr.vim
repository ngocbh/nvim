let s:rnvimr_path = expand('<sfile>:h:h')
let s:confdir = s:rnvimr_path . '/ranger'
let s:default_ranger_cmd = 'ranger'
let s:default_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd',
            \ }

let g:rnvimr_action = get(g:, 'rnvimr_action', s:default_action)
let g:rnvimr_draw_border = get(g:, 'rnvimr_draw_border', 1)

" TODO rnvimr_picker_enable and rnvimr_bw_enable were deprecated.
let g:rnvimr_enable_picker = get(g:, 'rnvimr_enable_picker', 0)
            \ || get(g:, 'rnvimr_pick_enable', 0)
let g:rnvimr_enable_bw = get(g:, 'rnvimr_enable_bw', 0)
            \ || get(g:, 'rnvimr_bw_enable', 0)

let g:rnvimr_urc_path = get(g:, 'rnvimr_urc_path', '')
let g:rnvimr_vanilla = get(g:, 'rnvimr_vanilla', 0)

highlight default link RnvimrNormal NormalFloat
highlight default link RnvimrCurses Normal

function! s:redraw_win() abort
    let layout = rnvimr#layout#get_current_layout()
    call nvim_win_set_config(rnvimr#context#get_win_handle(), layout)
    " TODO
    " clear screen is not working inside VimResized event
    " add a timer to implement redraw is a dirty way, please fix
    call timer_start(0, {-> execute('mode')})
endfunction

function! s:reopen_win() abort
    let layout = rnvimr#layout#get_current_layout()
    call rnvimr#context#set_win_handle(
                \ nvim_open_win(rnvimr#context#get_buf_handle(), v:true, layout))
    startinsert
endfunction

function! s:on_exit(job_id, data, event) abort
    if a:data == 0
        bdelete!
    endif
    call rnvimr#context#set_buf_handle(-1)
    call rnvimr#rpc#reset()
endfunction

function! s:setup_winhl() abort
    let buf_hd = rnvimr#context#get_buf_handle()
    call setbufvar(buf_hd, 'normal_winhl', 'Normal:RnvimrNormal')
    call setbufvar(buf_hd, 'curses_winhl', 'Normal:RnvimrCurses')
    if g:rnvimr_draw_border
        let default_winhl = getbufvar(buf_hd, 'curses_winhl')
    else
        let default_winhl = getbufvar(buf_hd, 'normal_winhl')
    endif
    call setwinvar(rnvimr#context#get_win_handle(), '&winhighlight', default_winhl)
endfunction

function! s:create_ranger(cmd) abort
    let init_layout = rnvimr#layout#get_init_layout()
    call rnvimr#context#set_buf_handle(nvim_create_buf(v:false, v:true))
    call rnvimr#context#set_win_handle(
                \ nvim_open_win(rnvimr#context#get_buf_handle(), v:true, init_layout))
    call termopen(a:cmd, {'on_exit': function('s:on_exit')})
    setfiletype rnvimr
    call s:setup_winhl()
    startinsert
endfunction

function! rnvimr#resize(...) abort
    let win_hd = rnvimr#context#get_win_handle()
    if !nvim_win_is_valid(win_hd) ||
                \ nvim_get_current_win() != win_hd
        return
    endif
    let layout = call(function('rnvimr#layout#get_next_layout'), a:000)
    call nvim_win_set_config(win_hd, layout)
    startinsert
endfunction

function! rnvimr#toggle() abort
    echohl Error
    echo 'master branch is deprecated, go to https://github.com/kevinhwang91/rnvimr/issues/50 for detail'
    echohl
    let win_hd = rnvimr#context#get_win_handle()
    if rnvimr#context#get_buf_handle() != -1
        if win_hd != -1 && nvim_win_is_valid(win_hd)
            if nvim_get_current_win() == win_hd
                call nvim_win_close(win_hd, 0)
            else
                call nvim_set_current_win(win_hd)
                startinsert
            endif
        else
            call rnvimr#rpc#attach_file_once(expand('%:p'))
            call s:reopen_win()
        endif
    else
        call rnvimr#init()
    endif
endfunction

function! rnvimr#open(path) abort
    if rnvimr#context#get_buf_handle() != -1
        if filereadable(a:path) || isdirectory(a:path)
            call rnvimr#rpc#attach_file(a:path)
            call rnvimr#rpc#disable_attach_file()
        endif
        call rnvimr#toggle()
    else
        call rnvimr#init(a:path)
    endif
endfunction

function! rnvimr#init(...) abort
    let select_file = empty(a:000) ? expand('%:p') : a:1
    let confdir = shellescape(s:confdir)
    let attach_cmd = shellescape('AttachFile ' . line('w0') . ' ' . select_file)
    let ranger_cmd = get(g:, 'rnvimr_ranger_cmd', s:default_ranger_cmd)
    let cmd = ranger_cmd . ' --confdir=' . confdir . ' --cmd=' . attach_cmd
    call s:create_ranger(cmd)
    augroup RnvimrTerm
        autocmd!
        autocmd VimResized <buffer> call s:redraw_win()
        autocmd VimLeavePre * call rnvimr#rpc#destory()
        if get(g:, 'rnvimr_enable_bw', 0)
            autocmd TermEnter,WinEnter <buffer> call rnvimr#context#check_point()
            autocmd WinLeave <buffer> call rnvimr#context#buf_wipe()
        endif
    augroup END
endfunction
