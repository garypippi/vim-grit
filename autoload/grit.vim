let s:tree = {}

function grit#grit(arg)
    call s:buf()
    call setline(1, s:execute(a:arg))
    call cursor(0, 0)
endfunction

function grit#tree()
    let id = s:id(getline('.'))
    if has_key(s:tree, id)
        let k = 0
        if line('.') < line('$') - len(s:tree[id])
            let k = 1
        end
        execute (line('.') + 1) . ',' . (line('.') + len(s:tree[id])) . 'delete'
        call remove(s:tree, id)
        if k
            normal k
        end
    else
        let s:tree[id] = s:execute('tree ' . id)[1:]
        if len(s:tree[id]) > 0
            call append(line('.'), s:tree[id])
        else
            call remove(s:tree, id)
        end
    end
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

function s:id(arg)
    return matchstr(matchstr(a:arg, '([0-9]\+)'), '[0-9]\+')
endfunction
