" Author: Nova Senco
" Last Change: 09 May 2021

let s:folddash = '●'

function! fold#text()
  let cms = &commentstring =~ '%s' ? '\%('.escape(split(&commentstring, '%s')[0], '~$^*[]\.').'\)\?' : ''
  let dash = tr(v:folddashes, '-', get(g:, 'folddash', s:folddash))
  let line = substitute(getline(v:foldstart), '^\s\{-}\zs\t', repeat(' ', &tabstop), 'g')
  let line = substitute(line, escape(split(&foldmarker, ',')[0], '~$^*[]\.')..'\d*\s*', '', '')
  return substitute(line, '^\s*'.cms.'\s*', dash.' ', '')
endfunction

