" Interface {{{1
fu tradewinds#softmove(dir) abort "{{{2
    if len(a:dir) != 1 || stridx('hjkl', a:dir) < 0
        return
    endif

    " if there is only one window just cause a beep
    if winnr('$') == 1
        exe 'wincmd '..toupper(a:dir)
        return
    endif

    " `s:softmove()` invokes `win_splitmove()` which has not been ported to Nvim yet
    call s:softmove{has('nvim') ? '_nvim' : ''}(a:dir)
endfu
"}}}1
" Core {{{1
fu s:softmove(dir) abort "{{{2
    let pos = win_screenpos(0)
    let target = winnr(a:dir)

    " hard HJKL movements can be used here
    if target == 0 || target == winnr()
        exe 'wincmd '..toupper(a:dir)
        return
    endif

    let targetid = win_getid(target)
    let targetpos = win_screenpos(target)

    " Try to place the new window in the natural position:{{{
    "
    " - if the current window is at least as big as the target then
    "   compare the cursor position and the midpoint of the target window
    "
    " - if the current window is smaller than the target
    "   then compare the midpoints of the current and target windows
    "}}}
    if a:dir is# 'h' || a:dir is# 'l'
        if pos[0] +
        \ (winheight(0) >= winheight(target)
        \   ? winline()-1 : winheight(0) / 2)
        \ <= targetpos[0] + winheight(target) / 2
            let modifiers = {'rightbelow': 0}
        else
            let modifiers = {'rightbelow': 1}
        endif
    else
        if pos[1] +
        \ (winwidth(0) >= winwidth(target)
        \   ? wincol()-1 : winwidth(0) / 2)
        \ <= targetpos[1] + winwidth(target) / 2
            let modifiers = {'rightbelow': 0, 'vertical': 1}
        else
            let modifiers = {'rightbelow': 1, 'vertical': 1}
        endif
    endif

    call win_splitmove(winnr(), target, modifiers)
endfu

fu s:softmove_nvim(dir) abort "{{{2
    " TODO: Delete this function once Nvim supports `win_splitmove()`.
    let bufnr = bufnr('')
    let winid = win_getid(winnr())
    let lastwinid = win_getid(winnr('#'))

    let vars = w:   " this is a reference!
    let view = winsaveview()
    let opts = getwinvar(0, '&')
    let save_stl = &statusline

    let pos = win_screenpos(0)

    " get window in target direction instead of using
    " wincmd because sizes might change when splitting
    let target = winnr(a:dir)

    " hard HJKL movements can be used here
    if target == 0 || target == winnr()
        exe 'wincmd '..toupper(a:dir)
        return
    endif

    let targetid = win_getid(target)
    let targetpos = win_screenpos(target)
    let modifiers = ''

    " try to place the new window in the natural position
    " - if the current window is at least as big as the target then
    "   compare the cursor position and the midpoint of the target window
    " - if the current window is smaller than the target
    "   then compare the midpoints of the current and target windows
    if a:dir is# 'h' || a:dir is# 'l'
        if pos[0] +
        \ (winheight(0) >= winheight(target)
        \   ? winline()-1 : winheight(0) / 2)
        \ <= targetpos[0] + winheight(target) / 2
            let modifiers = 'leftabove'
        else
            let modifiers = 'rightbelow'
        endif
    else
        if pos[1] +
        \ (winwidth(0) >= winwidth(target)
        \   ? wincol()-1 : winwidth(0) / 2)
        \ <= targetpos[1] + winwidth(target) / 2
            let modifiers = 'leftabove vertical'
        else
            let modifiers = 'rightbelow vertical'
        endif
    endif

    " go to the target window
    call win_gotoid(targetid)

    " ..and make the split (and edit existing buffer)
    if !empty(bufname(bufnr))
        sil exe modifiers 'split #'..bufnr
    else
        let save_swb = &switchbuf
        set switchbuf=
        sil exe modifiers 'sbuffer '..bufnr
        let &switchbuf = save_swb
    endif

    " restore window variables
    call extend(w:, vars)

    " now close the old window
    exe win_id2win(winid)..'wincmd c'
    let winid = win_getid(winnr())

    " restore window options
    " but not statusline because it causes more trouble than it's worth
    for [o, v] in items(opts)
        if getwinvar(0, '&'..o) isnot# v && o isnot# 'statusline'
            call setwinvar(0, '&'..o, v)
        endif
    endfor

    " restore view
    call winrestview(view)

    " try to fix the prior window CTRL-W p
    if lastwinid > 0
        call win_gotoid(lastwinid)
        call win_gotoid(winid)
    endif
endfu

