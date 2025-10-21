function LoadProjectConfig(projectdir)

    let path=expand("%:p:h")
    let projectpath=split(path, a:projectdir)

    if len(projectpath) == 2

        let path=projectpath[0] . a:projectdir
        let projectfile=findfile("project.vim", path)
        echom "Path is " . path
        echom "Projectfile is " . projectfile
        if ! empty(projectfile)
            exec "source " . projectfile
        endif

    endif

endfunction

autocmd BufRead,BufNewFile */hcc-api-cpp/** call LoadProjectConfig("hcc-api-cpp")




