local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- GoTo code navigation.
keymap('n', 'gd', '<Plug>(coc-definition)', opts)
keymap('n', 'gy', '<Plug>(coc-type-definition)', opts)
keymap('n', 'gi', '<Plug>(coc-implementation)', opts)
keymap('n', 'gr', '<Plug>(coc-references)', opts)

-- Use K to show documentation in preview window.
vim.api.nvim_set_keymap('n', 'K', '', {
    silent = true,
    noremap = true,
    callback = function ()
        local filetype = vim.bo.filetype
        if filetype == 'vim' or filetype == 'help' then
            vim.cmd('h ' .. vim.fn.expand('<cword>'))
        else
            vim.fn.CocAction('doHover')
        end
    end
})
