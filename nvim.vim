set mouse=
set tabstop=4 shiftwidth=4 softtabstop=0 smarttab expandtab

noremap <SPACE> <Nop>
let mapleader=" "
if exists('g:vscode')
    " slurp/barf (s)
    nnoremap <leader>ksk <Cmd>call VSCodeNotify('paredit.slurpSexpForward')<CR>
    nnoremap <leader>ksl <Cmd>call VSCodeNotify('paredit.barfSexpForward')<CR>
    nnoremap <leader>ksj <Cmd>call VSCodeNotify('paredit.slurpSexpBackward')<CR>
    nnoremap <leader>ksh <Cmd>call VSCodeNotify('paredit.barfSexpBackward')<CR>

    " wrap (w)
    nnoremap <leader>kw( <Cmd>call VSCodeNotify('paredit.wrapAroundParens')<CR>
    nnoremap <leader>kw{ <Cmd>call VSCodeNotify('paredit.wrapAroundCurly')<CR>
    nnoremap <leader>kw[ <Cmd>call VSCodeNotify('paredit.wrapAroundSquare')<CR>
    nnoremap <leader>kw" <Cmd>call VSCodeNotify('paredit.wrapAroundQuote')<CR>

    "rewrap (ww)
    nnoremap <leader>kww( <Cmd>call VSCodeNotify('paredit.rewrapParens')<CR>
    nnoremap <leader>kww{ <Cmd>call VSCodeNotify('paredit.rewrapCurly')<CR>
    nnoremap <leader>kww[ <Cmd>call VSCodeNotify('paredit.rewrapSquare')<CR>
    nnoremap <leader>kww" <Cmd>call VSCodeNotify('paredit.rewrapQuote')<CR>
    
    "kill & variants (k)
    nnoremap <leader>kkl <Cmd>call VSCodeNotify('paredit.killListForward')<CR>
    nnoremap <leader>kkk <Cmd>call VSCodeNotify('paredit.killSexpForward')<CR>
    nnoremap <leader>kkj <Cmd>call VSCodeNotify('paredit.killSexpBackward')<CR>
    nnoremap <leader>kkh <Cmd>call VSCodeNotify('paredit.killListBackward')<CR>
    
    nnoremap <leader>kks <Cmd>call VSCodeNotify('paredit.spliceSexp')<CR>
    nnoremap <leader>kkr <Cmd>call VSCodeNotify('paredit.raiseSexp')<CR>

    nnoremap <leader>kt <Cmd>call VSCodeNotify('paredit.transpose')<CR>

    nnoremap <leader><leader> <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>

    nnoremap <leader>fs <Cmd>call VSCodeNotify('saveAll')<CR>
    nnoremap <leader>rr <Cmd>call VSCodeNotify('editor.action.rename')<CR>
endif
