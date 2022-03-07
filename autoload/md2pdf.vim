" Author: Nova Senco
" Last Change: 12 October 2021

let s:default_pdf_viewer = 'zathura --fork %s'

let s:convert_job = 0
let s:recompile = 0

function! md2pdf#set_write(bang, on)
    let l:bn = bufnr(winnr())
    let l:flag = 'md2pdf_convert'
    if a:bang ==# '!'
        call setbufvar(l:bn, l:flag, ! getbufvar(l:bn, l:flag, 0))
    else
        call setbufvar(l:bn, l:flag, a:on)
    endif
    if getbufvar(l:bn, l:flag, 0)
        echohl String
        echon "\rmd2pdf ENABLED"
    else
        echohl WarningMsg
        echon "\rmd2pdf DISABLED"
    endif
    echohl NONE
endfunction

function! md2pdf#convert()
    if ! getbufvar(bufnr(winnr()), 'md2pdf_convert')
        return
    endif
    if s:convert_job > 0
        let s:recompile = 1
        return
    endif
    let s:convert_job = -1
    let l:path = expand('%:h')
    let l:in = fnameescape(l:path.'/'.expand('%:t'))
    let l:out = fnameescape(l:path.'/'.expand('%:t:r').'.pdf')

    let s:convert_job = jobstart(
    \   ['sh', '-c',
    \       'pandoc '.(expand('%:t') =~# 'README.md$' ? ' -s -f gfm -t html --template=GitHub.html5' : '--template=eisvogel.latex').(exists('b:pandoc_opts')?' ':'').get(b:, 'pandoc_opts', '').' '.l:in.' -o '.l:out.' </dev/null'
    \   ],
    \   {'on_exit': 'md2pdf#convert_exit'}
    \)
endfunction

function! md2pdf#convert_exit(job_id, exit_code, event_type)
    if a:exit_code !=# 0
        echohl ErrorMsg
        echon "\rpandoc failed to convert this file"
    else
        echohl String
        echon "\rpandoc successfully converted"
    endif
    let s:convert_job = 0
    if s:recompile
        echon ' ... recompiling '.s:recompile.' more time'.(s:recompile ==# 1 ? '' : 's')
        let s:recompile = 0
        call md2pdf#convert()
    else
        echon repeat(' ', 34)
    endif
    echohl NONE
endfunction

function! md2pdf#open_pdf()
    let l:out_pdf = expand('%:h').'/'.expand('%:t:r').'.pdf'
    if ! filereadable(l:out_pdf)
        echohl ErrorMsg
        echon "\rFile not readable: ".l:out_pdf
        echohl NONE
        return
    endif
    let l:cmd = substitute(get(g:, 'pdf_viewer', s:default_pdf_viewer), '%s', escape(fnameescape(l:out_pdf), '\'), 'g')
    echohl String
    echom '!'.l:cmd
    echohl NONE
    call system(l:cmd)
endfunction

function! md2pdf#temp_write()
    let l:bn = bufnr(winnr())
    let l:flag = 'md2pdf_convert'
    let l:b_md2pdf_convert = getbufvar(l:bn, l:flag, 0)
    call setbufvar(l:bn, l:flag, 1)
    call md2pdf#convert()
    call setbufvar(l:bn, l:flag, l:b_md2pdf_convert)
endfunction

