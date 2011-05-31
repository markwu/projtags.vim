let g:projtags_search_level   = 10
let g:projtags_ctags_file     = 'tags'
let g:projtags_cscope_file    = 'cscope.out'
let g:projtags_file_pattern   = '*'

function! SetProjTags()
    let parent          = 0
    let is_ctags_found  = 0
    let is_cscope_found = 0
    let is_root_folder  = 0
    let current_folder  = expand('%:p:h')
    while parent < g:projtags_search_level && !is_root_folder
        if current_folder == ''
            let is_root_folder = 1
        endif

        let ctags_file = current_folder . '/' . g:projtags_ctags_file
        if filereadable( ctags_file )
            execute 'setlocal tags+=' . ctags_file
            let is_ctags_found = 1
        endif

        let cscope_file = current_folder . '/' . g:projtags_cscope_file
        if filereadable( cscope_file )
            execute 'cscope add ' . cscope_file . ' ' . current_folder
            let is_cscope_found = 1
        endif

        if is_ctags_found && is_cscope_found
            let parent = g:projtags_search_level
        else
            let parent = parent+1
        endif

        let current_folder = substitute(current_folder, '/[^/]\+$', '', '')
    endwhile
endfunction

execute 'autocmd BufEnter ' . g:projtags_file_pattern . ' call SetProjTags()'
