" Author: Nova Senco
" Last Change: 10 March 2022

let s:urlRegex = '\v%(https?://)[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}>%([-a-zA-Z0-9()@:%_\+.~#?&//=*]*)'

function! maps#UrlSelect(forwards, count)
  execute "normal! \<c-bslash>\<c-N>"
  if !search(s:urlRegex, (a:forwards?'':'b')..'w')
    return
  endif
  for _ in range(2, a:count)
    call search(s:urlRegex, (a:forwards?'':'b')..'w')
  endfor
  normal! zvv
  call search(s:urlRegex, 'eW')
  normal! o
endfunction

function! url# V_gx()
  let [q, u] = [getreg('"'), getreg('_')]
  normal! y
  execute 'silent !xdg-open' '"'.escape(@", '\"$').'"'
  call setreg('"', q)
  call setreg('_', u)
endfunction

function! maps#GX(...)
  if a:0
    let url = a:1
  else
    let [q, u] = [getreg('"'), getreg('_')]
    normal! y
    let url = getreg('"')
    call setreg('"', q)
    call setreg('_', u)
  endif
  let cmd = input('command (!! for URL): ')
  if cmd =~ '!!'
    let cmd = substitute(cmd, '!!', url, 'g')
  else
    let cmd ..= ' '..url
  endif
  redraw
  echon cmd
  silent execute cmd
endfunction

