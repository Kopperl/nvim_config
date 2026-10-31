-- ####################
-- # General Settings #
-- ####################


-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- indentation
vim.opt.tabstop = 4 -- tabs are 4 spaces	
vim.opt.softtabstop = 4 -- if we get files from someone else tabs are converted into 4 spaces
vim.opt.shiftwidth = 4 -- number of spaces for autoindent
vim.opt.expandtab = true -- if we press tab it gets converted to 4 spaces
vim.opt.smartindent = true -- automatically inserts one extra indentation in some cases

-- clipboard
vim.opt.clipboard = "unnamedplus" -- sync system clipboard

-- display and behaviour
vim.opt.wrap = false -- text can get out of screen
vim.opt.swapfile = false -- temporary file to recreate unsaved files
vim.opt.backup = false

vim.opt.hlsearch = false -- after searching a word and pressing enter the highlighting gets removed
vim.opt.incsearch = true -- in search mode directly jumps to the searched word

-- colors & ui
vim.opt.termguicolors = true -- enables 24 bit RGB in the terminal
vim.opt.showmode = false
vim.opt.scrolloff = 10 -- always have at least 8 lines over or under the cursor while scrolling
vim.opt.signcolumn = "yes" -- one column space for the lsp to show errors or warnings
vim.opt.updatetime = 1 -- set updatetime to 1 second for the lsp -> make it faster
vim.opt.colorcolumn = "80" -- rows have a width of 80 columns

-- #######################
-- # Paq Package Manager #
-- #######################

require "paq" {
	"savq/paq-nvim", -- enables automatic updating of the package manager paq

    "rose-pine/neovim",

	"nvim-lualine/lualine.nvim",

	"nvim-treesitter/nvim-treesitter",

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",

    "terrortylor/nvim-comment",
    "windwp/nvim-autopairs",
    "alvan/vim-closetag",

    "voldikss/vim-floaterm",

    "https://github.com/lukas-reineke/indent-blankline.nvim",

    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",

    "stevearc/oil.nvim",
}

-- #########
-- # Theme #
-- #########

require("rose-pine").setup{
    variant = "main", -- options: "main (dark), "moon" (darker), "dawn" (light)
    dark_variant = "main",
    disable_background = false,
    disable_float_background = true,
    disable_italics = true,
}

vim.cmd('colorscheme rose-pine')

require("lualine").setup{
    option = {
        theme = 'auto'
    }
}

-- ##############
-- # Treesitter # 
-- ##############

require("nvim-treesitter.configs").setup{
    ensure_installed = {
        "c", "cpp", "lua", "rust", "typescript", "tsx", "css", "html", "json", "ini", "toml", "sql", "java"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    }
}

-- #######
-- # Lsp #
-- #######

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("tinymist")
vim.lsp.enable("clangd")

vim.lsp.config("jdtls", {
    cmd = {
        "env",
        "JAVA_HOME=/usr/lib/jvm/java-25-openjdk",
        "PATH=/usr/lib/jvm/java-25-openjdk/bin:" .. vim.env.PATH,
        "jdtls",
    },
})
vim.lsp.enable("jdtls")
vim.lsp.enable("pyright")

-- #######
-- # Cmp #
-- #######

local cmp = require("cmp")

cmp.setup{
    mapping = cmp.mapping.preset.insert{
        ['<M-j>'] = cmp.mapping.select_next_item(),
        ['<M-k>'] = cmp.mapping.select_prev_item(), -- M stands for meta (alt - key)
        ['<TAB>'] = cmp.mapping.confirm{ select = true },
        ['<M-e>'] = cmp.mapping.abort(),
    }, 
    sources = cmp.config.sources(
        {{ name = "nvim_lsp" }},
        {{ name = "path"     }},
        {{ name = "buffer"   }}
    )
}

-- #####################
-- # Indentation lines #
-- #####################

require('ibl').setup{
    scope = {
        enabled = false
    }
}

-- ########################
-- # Comments & Autopairs #
-- ########################

require("nvim_comment").setup{}
require("nvim-autopairs").setup{}

-- ###################
-- # Telescope & Oil #
-- ###################

require("telescope").setup{
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".*build.*",
            "extern",
            "deps",
            "subprojects"
        }
    }
}

require("oil").setup{
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
            return name:match("%.o")
        end
    }
}

-- ############
-- # Keybinds #
-- ############

function map(mode, keys, cmd)
    vim.keymap.set(mode, keys, cmd)
end

-- Terminal 
map("n", "<C-p>", ":FloatermToggle<Cr>")
map("t", "<C-p>", "<C-\\><C-n>:FloatermToggle<Cr>")

-- File 
map("n", "<C-b>", ":Telescope find_files<Cr>")
map("n", "<C-n>", ":Telescope live_grep<Cr>")
map("n", "<C-m>", ":Oil<Cr>")

-- Comment
map("n", "<C-c>", ":CommentToggle<Cr>")
map("v", "<C-c>", ":CommentToggle<Cr>")

-- Move between splits (:vs for opening a vertical split, :sp for a opening a horizonatl split)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Lsp
map("n", " r", vim.lsp.buf.rename)
map("n", " a", vim.lsp.buf.code_action)
map("n", " f", vim.lsp.buf.format)
map("n", " d", vim.lsp.buf.definition)
map("n", " E", vim.diagnostic.open_float)

map("v", "K", ":m '<-2<CR>gv=gv") -- move line up(v)
map("v", "J", ":m '>+1<CR>gv=gv") -- move line down(v)
