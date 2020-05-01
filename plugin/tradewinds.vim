if exists('g:loaded_tradewinds')
    finish
endif
let g:loaded_tradewinds = 1

com -nargs=1 TradewindsMove call tradewinds#softmove(<q-args>)

" these plug  mappings are useful  to make  the commands repeatable  without the
" `C-w` prefix, via our submode api
nno <c-w>gh <plug>(tradewinds-h)
nno <c-w>gj <plug>(tradewinds-j)
nno <c-w>gk <plug>(tradewinds-k)
nno <c-w>gl <plug>(tradewinds-l)

nno <silent> <plug>(tradewinds-h) :<c-u>TradewindsMove h<cr>
nno <silent> <plug>(tradewinds-j) :<c-u>TradewindsMove j<cr>
nno <silent> <plug>(tradewinds-k) :<c-u>TradewindsMove k<cr>
nno <silent> <plug>(tradewinds-l) :<c-u>TradewindsMove l<cr>
