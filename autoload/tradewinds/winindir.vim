fu s:WinRect(winnr) abort
    let pos = win_screenpos(a:winnr)
    return { 'top': pos[0],
    \ 'left': pos[1],
    \ 'bottom': pos[0] + winheight(a:winnr) - 1,
    \ 'right': pos[1] + winwidth(a:winnr) - 1,
    \}
endfu

fu s:Between(a, b, x) abort
    return a:a <= a:x && a:x <= a:b
endfu

fu s:WinIsInDir(winnr, dir) abort
    if a:winnr == winnr()
        return 0
    endif

    let this = s:WinRect(0)
    let other = s:WinRect(a:winnr)
    let curpos = [this.top + winline() - 1,
    \ this.left + wincol() - 1]

    let touches = 0
    let cursor = 0

    if a:dir ==# 'k'
        let touches = this.top == other.bottom + 2
        " extend one down for vertical separator
        let cursor = s:Between(other.left, other.right + 1, curpos[1])
    elseif a:dir ==# 'j'
        let touches = this.bottom == other.top - 2
        let cursor = s:Between(other.left, other.right, curpos[1])
    elseif a:dir ==# 'h'
        let touches = this.left == other.right + 2
        let cursor = s:Between(other.top, other.bottom, curpos[0])
    elseif a:dir ==# 'l'
        let touches = this.right == other.left - 2
        " extend one down for statusline
        let cursor = s:Between(other.top, other.bottom + 1, curpos[0])
    endif

    return touches && cursor
endfu

fu tradewinds#winindir#get(dir) abort
    let w = filter(range(1,winnr('$')), 's:WinIsInDir(v:val, a:dir)')
    return len(w) ? w[0] : 0
endfu

