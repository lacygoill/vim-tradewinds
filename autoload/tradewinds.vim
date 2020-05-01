fu tradewinds#softmove(dir) abort
    if len(a:dir) != 1 || stridx('hjkl', a:dir) < 0
        return
    endif

    " if there is only one window just cause a beep
    if winnr('$') == 1
        exe 'wincmd' toupper(a:dir)
        return
    endif

    return s:newimpl(a:dir)
endfu

fu s:newimpl(dir) abort
    let pos = win_screenpos(0)
    let target = winnr(a:dir)

    " allow the user to cancel
    if exists('g:tradewinds#prepare')
        if call(g:tradewinds#prepare, [winnr(), target])
            return
        endif
    endif

    " hard HJKL movements can be used here
    if target == 0 || target == winnr()
        exe 'wincmd' toupper(a:dir)
        call s:AfterVoyage()
        return
    endif

    let targetid = win_getid(target)
    let targetpos = win_screenpos(target)

    " try to place the new window in the natural position
    " - if the current window is at least as big as the target then
    "   compare the cursor position and the midpoint of the target window
    " - if the current window is smaller than the target
    "   then compare the midpoints of the current and target windows
    if a:dir ==# 'h' || a:dir ==# 'l'
        if pos[0] +
        \ (winheight(0) >= winheight(target)
        \   ? winline()-1 : winheight(0) / 2)
        \ <= targetpos[0] + winheight(target) / 2
            let flags = { 'rightbelow': 0 }
        else
            let flags = { 'rightbelow': 1 }
        endif
    else
        if pos[1] +
        \ (winwidth(0) >= winwidth(target)
        \   ? wincol()-1 : winwidth(0) / 2)
        \ <= targetpos[1] + winwidth(target) / 2
            let flags = { 'rightbelow': 0, 'vertical': 1 }
        else
            let flags = { 'rightbelow': 1, 'vertical': 1 }
        endif
    endif

    call win_splitmove(winnr(), target, flags)

    call s:AfterVoyage()
endfu

fu s:AfterVoyage() abort
    if exists('#User#TradeWindsAfterVoyage')
        doautocmd <nomodeline> User TradeWindsAfterVoyage
    endif
endfu

