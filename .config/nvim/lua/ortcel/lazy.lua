local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                disable_italics = true,
                highlight_groups = {
                    ["@type.qualifier"] = { fg = "pine", },
                    ["@storageclass"] = { fg = "pine", },
                    ["@keyword.operator"] = { fg = "pine", },
                    ["@punctuation"] = { fg = "subtle", },
                    ["@field"] = { fg = "rose", },
                    ["@property"] = { fg = "rose", },
                    ["@parameter"] = { fg = "text", },
                    ["@boolean"] = { fg = "gold", },
                    ["@type.builtin"] = { fg = "love", },
                    ["@constant.builtin"] = { fg = "love", },
                    ["@variable.builtin"] = { fg = "love", },
                },
            })

            vim.cmd('colorscheme rose-pine')
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.1",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
            vim.keymap.set("n", "<C-p>", builtin.git_files, {})
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "rust", "c", "lua", "vim", "help" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    {
        "nvim-treesitter/playground",
        build = ":TSInstall query",
    },

    {
        "theprimeagen/harpoon",
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>a", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

            vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
        end,
    },

    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },

    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        end,
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lua" },

            { "L3MON4D3/LuaSnip" },

            { "simrat39/rust-tools.nvim" },
        },
        keys = {
            { "<leader>kd", "<cmd>LspZeroFormat<cr>" },
        },
        config = function()
            local lsp = require("lsp-zero")

            lsp.preset("recommended")
            lsp.skip_server_setup({ "rust_analyzer" })
            lsp.nvim_workspace()
            lsp.setup()

            local rust_tools = require("rust-tools")

            rust_tools.setup({
                server = {
                    on_attach = function(_, buffer)
                        local opts = { buffer = buffer }

                        -- lsp-zero defaults
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "<Ctrl-k>", vim.lsp.buf.signature_help, opts)
                        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
                        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
                        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

                        -- ortcel
                        vim.keymap.set("n", "<leader>kd", vim.lsp.buf.format, opts)
                    end,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
                tools = {
                    inlay_hints = {
                        auto = false,
                    },
                },
            })
        end,
        lazy = false,
    },
})
