local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter", 
		build = ":TSUpdate",
		opts = {
			indent = { enable = true },
			highlight = { enable = true },
			ensure_installed = {
				"c",
				"php",
				"rust",
				"lua"
			}
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end
	},
	{"neoclide/coc.nvim", branch = "release"},
	{
	  "folke/tokyonight.nvim",
	  lazy = false,
	  priority = 1000,
	  opts = {},
	},
    	{
	    'nvim-telescope/telescope.nvim', tag = '0.1.5',
	    dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{"m4xshen/autoclose.nvim"},
	{
		"numToStr/Comment.nvim",
		lazy = false
	},
	{
	  "NeogitOrg/neogit",
	  dependencies = {
	    "nvim-lua/plenary.nvim",         -- required
	    "sindrets/diffview.nvim",        -- optional - Diff integration

	    -- Only one of these is needed, not both.
	    "nvim-telescope/telescope.nvim", -- optional
	  },
	  config = true
	},
	{
		"mfussenegger/nvim-dap"
	},
	{"lewis6991/gitsigns.nvim"},
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {"nvim-tree/nvim-web-devicons"}
	},
	{
		"gennaro-tedesco/nvim-jqx",
		ft = { "json" }
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false,
		version = "*",
		config = function()
			require('neorg').setup{
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.qol.todo_items"] = {},
					["core.keybinds"] = {
						config = {
							hook = function(keybinds)
								keybinds.remap_event("norg", "n", "<Leader>td", "core.qol.todo_items.todo.task_done")
								keybinds.remap_event("norg", "n", "<Leader>tu", "core.qol.todo_items.todo.task_undone")
								keybinds.remap_event("norg", "n", "<Leader>ti", "core.qol.todo_items.todo.task_important")
								keybinds.remap_event("norg", "n", "<Leader>tc", "core.qol.todo_items.todo.task_cycle")
							end
						}
					}
				}
			}
		end
	}
})

local autocl = require("autoclose")
local commentplg = require('Comment')
local neogit = require('neogit')
local gitsigns = require('gitsigns')
local tokyonight = require('tokyonight')
local dap = require("dap")

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

tokyonight.setup({
  on_highlights = function(hl, c)
    local prompt = "#2d3149"
    hl.TelescopeNormal = {
      bg = c.bg_dark,
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopePromptNormal = {
      bg = prompt,
    }
    hl.TelescopePromptBorder = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePromptTitle = {
      bg = prompt,
      fg = prompt,
    }
    hl.TelescopePreviewTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
    hl.TelescopeResultsTitle = {
      bg = c.bg_dark,
      fg = c.bg_dark,
    }
  end,
})

neogit.setup {}

gitsigns.setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

autocl.setup()

commentplg.setup()

vim.g.mapleader = ' '

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false
vim.o.laststatus = 2

vim.cmd[[colorscheme tokyonight-night]]

vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#51587a', bold=false })
vim.api.nvim_set_hl(0, 'LineNr', { fg='#c0caf5', bold=false })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#51587a', bold=false })

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
local keyset = vim.keymap.set

keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fc', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gd', "<Plug>(coc-definition)", {})

vim.keymap.set('n', '<leader>tt', ':TSToggle highlight<enter>')
