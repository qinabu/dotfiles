local M = {}

function M.config()
        vim.cmd [[
                let g:gruvbit_transp_bg = v:true
                colorscheme gruvbit
                hi link LspReferenceText Visual
                hi link LspReferenceRead Visual
                hi link LspReferenceWrite Visual
		hi! clear VertSplit
        	hi Function cterm=bold gui=bold guifg=#83a598 ctermfg=109
                hi! link Special Tag
        ]];
end

return M
