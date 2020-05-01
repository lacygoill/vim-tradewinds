if exists('g:loaded_tradewinds')
    finish
endif
let g:loaded_tradewinds = 1

com -nargs=1 TradewindsMove call tradewinds#softmove(<q-args>)

nno <silent> <plug>(tradewinds-h) :<c-u>TradewindsMove h<cr>
nno <silent> <plug>(tradewinds-j) :<c-u>TradewindsMove j<cr>
nno <silent> <plug>(tradewinds-k) :<c-u>TradewindsMove k<cr>
nno <silent> <plug>(tradewinds-l) :<c-u>TradewindsMove l<cr>

exe 'tno <silent> <plug>(tradewinds-h) '..&l:twk..':<c-u>TradewindsMove h<cr>'
exe 'tno <silent> <plug>(tradewinds-j) '..&l:twk..':<c-u>TradewindsMove j<cr>'
exe 'tno <silent> <plug>(tradewinds-k) '..&l:twk..':<c-u>TradewindsMove k<cr>'
exe 'tno <silent> <plug>(tradewinds-l) '..&l:twk..':<c-u>TradewindsMove l<cr>'

if !get(g:, 'tradewinds_no_maps', 0)
    fu s:map(mode, lhs, rhs, ...) abort
        if !hasmapto(a:rhs, a:mode)
        \ && ((a:0 > 0) || (maparg(a:lhs, a:mode) ==# ''))
            sil exe a:mode..'map <silent> ' a:lhs a:rhs
        endif
    endfu

    let s:pfx = get(g:, 'tradewinds_prefix', '<c-w>g')
    call s:map('n', s:pfx..'h', '<plug>(tradewinds-h)')
    call s:map('n', s:pfx..'j', '<plug>(tradewinds-j)')
    call s:map('n', s:pfx..'k', '<plug>(tradewinds-k)')
    call s:map('n', s:pfx..'l', '<plug>(tradewinds-l)')
    unlet s:pfx
endif

