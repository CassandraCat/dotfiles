local set_buffer_keymap = function(key, result)
  vim.api.nvim_buf_set_keymap(0, 'i', key, result, {noremap = true, silent = true})
end

vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true

set_buffer_keymap(',f', '<Esc>/<++><CR>:nohlsearch<CR>"_c4l')
set_buffer_keymap(',w', '<Esc>/ <++><CR>:nohlsearch<CR>"_c5l<CR>')
set_buffer_keymap(',n', '---<Enter><Enter>')
set_buffer_keymap(',b', '**** <++><Esc>F*hi')
set_buffer_keymap(',s', '~~~~ <++><Esc>F~hi')
set_buffer_keymap(',i', '** <++><Esc>F*i')
set_buffer_keymap(',d', '`` <++><Esc>F`i')
set_buffer_keymap(',c', '```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA')
set_buffer_keymap(',m', '- [ ] ')
set_buffer_keymap(',p', '![](<++>) <++><Esc>F[a')
set_buffer_keymap(',a', '[](<++>) <++><Esc>F[a')
set_buffer_keymap(',1', '# <Space><Enter><++><Esc>kA')
set_buffer_keymap(',2', '##<Space><Enter><++><Esc>kA')
set_buffer_keymap(',3', '###<Space><Enter><++><Esc>kA')
set_buffer_keymap(',4', '####<Space><Enter><++><Esc>kA')
set_buffer_keymap(',l', '--------<Enter>')
