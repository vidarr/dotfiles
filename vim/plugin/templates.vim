" My first attempt at a  template system
" Simple templates plugin
" Author Michael J. Beer
"
" Its very very basic:
" Its all file extension based:
" If a new file file.EXTENSION is added,
" the template underneath $HOME/.vim/templates/template.EXTENSION is loaded
" and certain variables replaced, e.g. '%%YEAR%%' by the current year.
"
" Currently new templates must be registered herein by adding a new
" autocmd line at the bottom of this file.
"
" The variables to replace are defined in NewFileFromTemplate function in the
" list regexes

" Function that performs the template insertion & replacement
"
function! NewFileFromTemplate(template)

    let regexes = [["YEAR", strftime("%Y")], ["DATE", strftime("%Y-%m-%d")], ["FILENAME_BASE", toupper(expand("%:t:r"))], ["FILENAME", expand("%")]]

    execute "0r " . a:template

    let start_point = 0
    let l = 1
    for line in getline(1, '$')
        let new_line = line
        if (start_point == 0) && (line =~ '%%START_POINT%%')
            let start_point = l
        endif
        for regex in regexes
            let new_line = substitute(new_line, "%%" . regex[0] . "%%", regex[1], "g")
        endfor
        call setline(l, new_line)
        let l = l + 1
    endfor

    if start_point != 0
        call setline(start_point, "")
        call cursor(start_point, 0)
    endif



endfunction

" Template registrations
if has("autocmd")
    augroup templates
        autocmd BufNewFile *.sh :call NewFileFromTemplate("$HOME/.vim/templates/template.sh")
        autocmd BufNewFile *.rs :call NewFileFromTemplate("$HOME/.vim/templates/template.rs")
        autocmd BufNewFile *.c  :call NewFileFromTemplate("$HOME/.vim/templates/template.c")
        autocmd BufNewFile *.h  :call NewFileFromTemplate("$HOME/.vim/templates/template.h")
        autocmd BufNewFile *.py  :call NewFileFromTemplate("$HOME/.vim/templates/template.py")
    augroup END
endif
