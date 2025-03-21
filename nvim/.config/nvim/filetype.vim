if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.gotmpl set filetype=gotmpl
  au! BufRead,BufNewFile *.go.tmpl set filetype=gotmpl
augroup END

