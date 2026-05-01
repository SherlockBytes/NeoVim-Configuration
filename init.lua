-- ================================
-- Core settings
-- ================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI & Editing
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 2
vim.opt.termguicolors = true
vim.opt.visualbell = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indentation & Tabs
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.startofline = false

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:list", "full" }

-- Timeouts
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200

-- Buffers & files
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.lazyredraw = true

-- List / whitespace visualization
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-", nbsp = "+", eol = "$" }
vim.opt.showbreak = "↪ "

-- Column guide at 80
vim.opt.colorcolumn = "80"
vim.cmd("highlight ColorColumn ctermbg=red")


-- Highlight non-text/whitespace (note: 'Whitespace' HL group is used by :match below)
vim.cmd("highlight NonText ctermfg=Gray guifg=Gray")
vim.cmd("highlight Whitespace ctermfg=Gray guifg=Gray")
vim.cmd("match Whitespace /\\s\\+/")

-- ==================================
-- Backup / Swap / Undo (Windows-safe)
-- ==================================
-- Use $LOCALAPPDATA on Windows; adjust for Linux/macOS if you share this config cross-platform.
local data_root = vim.fn.expand("$LOCALAPPDATA")
if data_root == "" then
  -- Fallback to stdpath on non-Windows systems
  data_root = vim.fn.stdpath("data")
end

local tmp_dir  = data_root .. "/nvim/tmp"
local undo_dir = data_root .. "/nvim/undo"

-- Ensure directories exist
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end
ensure_dir(tmp_dir)
ensure_dir(undo_dir)

vim.opt.backupdir = tmp_dir
vim.opt.directory = tmp_dir
vim.opt.undodir = undo_dir
vim.opt.undofile = true

-- ================================
-- Keymaps
-- ================================
-- 'Y' to yank to end of line (mimic 'D'/'C' behavior)
vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- Setup lazy.nvim
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,          -- enables syntax highlighting
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
})
