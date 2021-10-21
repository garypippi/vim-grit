function grit#grit(arg)
    call s:buf()
    call setline(1, s:execute(a:arg))
    call cursor(0, 0)
endfunction

function grit#tree()
    call append(line('.'), s:execute('tree ' . s:get_node(getline('.')))[1:])
endfunction

function s:buf()
    if bufexists('grit')
        call s:buf_goto(bufwinid('grit'))
    else
        call s:buf_open()
    end
endfunction

function s:buf_goto(id)
    if a:id isnot# -1
        call win_gotoid(a:id)
    else
        execute 'sbuffer grit'
    end
endfunction

function s:buf_open()
    execute 'new grit'
    set buftype=nofile
    nmap <silent> <buffer> <cr> :call grit#tree() <cr>
endfunction

function s:execute(arg)
    return split(system('grit ' . a:arg), '\n')
endfunctio

function s:get_node(arg)
    return matchstr(matchstr(a:arg, '([0-9]\+)'), '[0-9]\+')
endfunction
