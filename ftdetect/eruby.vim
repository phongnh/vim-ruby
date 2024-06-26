" Vim ftdetect file
" Language: Embedded Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

augroup filetypedetect
  au! BufNewFile,BufRead *.erb call g:eruby#ftdetect#set_filetype()
  au! BufNewFile,BufRead *.rhtml setfiletype html.eruby
augroup END
