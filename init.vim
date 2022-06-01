" Author: Nova Senco
" Last Change: 30 May 2022

" ensure good colorscheme loaded early
try
  colorscheme nokto
catch /^Vim\%((\a\+)\)\=:E185/
  silent! colorscheme nokto-init
endtry

