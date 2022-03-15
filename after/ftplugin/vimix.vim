" Author: Nova Senco
" Last Change: 10 March 2022

nnoremap <buffer> <localleader>S :execute 'Vimix!' expand('%:h')..'/colors/'<cr>:update<bar>exe 'colo' expand('%:t:r')<cr>

