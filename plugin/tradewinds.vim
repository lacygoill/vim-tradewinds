if exists('g:loaded_tradewinds')
    finish
endif
let g:loaded_tradewinds = 1

com -bar -nargs=1 TradewindsMove call tradewinds#softmove(<q-args>)

" these plug  mappings are useful  to make  the commands repeatable  without the
" `C-w` prefix, via our submode api
nno <c-w>gh <plug>(tradewinds-h)
nno <c-w>gj <plug>(tradewinds-j)
nno <c-w>gk <plug>(tradewinds-k)
nno <c-w>gl <plug>(tradewinds-l)

nno <plug>(tradewinds-h) <cmd>TradewindsMove h<cr>
nno <plug>(tradewinds-j) <cmd>TradewindsMove j<cr>
nno <plug>(tradewinds-k) <cmd>TradewindsMove k<cr>
nno <plug>(tradewinds-l) <cmd>TradewindsMove l<cr>
