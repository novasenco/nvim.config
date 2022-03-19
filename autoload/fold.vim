" Author: Nova Senco
" Last Change: 18 March 2022

let s:folddash = '●'

function! fold#text()
  return substitute(substitute(getline(v:foldstart),'\%(^\s*\)\@<=\t',repeat(' ',&tabstop),'g'),escape(split(&foldmarker,',')[0],'~$^*[]\.')..'\d*\s*',repeat(get(g:,'folddash',s:folddash),v:foldlevel),'')..' …'
endfunction

