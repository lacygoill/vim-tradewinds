vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

# Interface {{{1
def tradewinds#softmove(dir: string) #{{{2
    if len(dir) != 1 || stridx('hjkl', dir) < 0
        return
    endif

    # if there is only one window just cause a beep
    if winnr('$') == 1
        exe 'wincmd ' .. toupper(dir)
        return
    endif

    Softmove(dir)
enddef
#}}}1
# Core {{{1
def Softmove(dir: string) #{{{2
    var pos: list<number> = win_screenpos(0)
    var target: number = winnr(dir)

    # hard HJKL movements can be used here
    if target == 0 || target == winnr()
        exe 'wincmd ' .. toupper(dir)
        return
    endif

    var targetid: number = win_getid(target)
    var targetpos: list<number> = win_screenpos(target)

    # Try to place the new window in the natural position:{{{
    #
    # - if the current window is at least as big as the target then
    #   compare the cursor position and the midpoint of the target window
    #
    # - if the current window is smaller than the target
    #   then compare the midpoints of the current and target windows
    #}}}
    var modifiers: dict<bool>
    if dir == 'h' || dir == 'l'
        if pos[0] + (
            winheight(0) >= winheight(target)
          ? winline() - 1
          : winheight(0) / 2
          ) <= targetpos[0] + winheight(target) / 2
            modifiers = {rightbelow: false}
        else
            modifiers = {rightbelow: true}
        endif
    else
        if pos[1] + (
            winwidth(0) >= winwidth(target)
          ? wincol() - 1
          : winwidth(0) / 2
          ) <= targetpos[1] + winwidth(target) / 2
            modifiers = {rightbelow: false, vertical: true}
        else
            modifiers = {rightbelow: true, vertical: true}
        endif
    endif

    winnr()->win_splitmove(target, modifiers)
enddef

