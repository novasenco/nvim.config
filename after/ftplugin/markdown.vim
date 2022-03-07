" Author: Nova Senco
" Last Change: 15 February 2022

setl concealcursor=

setlocal formatoptions+=2
setlocal formatoptions+=n

command! -buffer -bar -bang -nargs=0 PdfOpenOnWrite call md2pdf#set_write(<q-bang>, 1)
command! -buffer -bar -nargs=0 NoPdfOpenOnWrite call md2pdf#set_write('', 0)

command! -buffer -nargs=0 OpenPdf call md2pdf#open_pdf()
command! -buffer -bar -nargs=0 TmpPdfWrite call md2pdf#temp_write()
