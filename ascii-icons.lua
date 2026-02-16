-- ASCII/Unicode icon replacements for environments without Nerd Fonts.
-- Overrides LazyVim core + every plugin that hardcodes Nerd Font glyphs.
return {
  -- Disable icon plugins entirely
  { "nvim-tree/nvim-web-devicons", enabled = false },
  { "echasnovski/mini.icons", enabled = false },
  { "nvim-mini/mini.icons", enabled = false },

  -- =====================================================================
  -- LazyVim core icons
  -- =====================================================================
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        misc = {
          dots = "...",
        },
        ft = {
          octo = "GH",
          gh = "GH",
          ["markdown.gh"] = "MD",
        },
        dap = {
          Stopped             = { ">>", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint          = "B ",
          BreakpointCondition = "B?",
          BreakpointRejected  = { "B!", "DiagnosticError" },
          LogPoint            = ".>",
        },
        diagnostics = {
          Error = "E ",
          Warn  = "W ",
          Hint  = "H ",
          Info  = "I ",
        },
        git = {
          added    = "+ ",
          modified = "~ ",
          removed  = "- ",
        },
        kinds = {
          Array         = "[] ",
          Boolean       = "b ",
          Class         = "cls ",
          Codeium       = "AI ",
          Color         = "clr ",
          Control       = "ctl ",
          Collapsed     = "> ",
          Constant      = "const ",
          Constructor   = "ctor ",
          Copilot       = "AI ",
          Enum          = "enum ",
          EnumMember    = "em ",
          Event         = "ev ",
          Field         = "fld ",
          File          = "file ",
          Folder        = "dir ",
          Function      = "fn ",
          Interface     = "ifc ",
          Key           = "key ",
          Keyword       = "kw ",
          Method        = "mth ",
          Module        = "mod ",
          Namespace     = "ns ",
          Null          = "null ",
          Number        = "# ",
          Object        = "{} ",
          Operator      = "op ",
          Package       = "pkg ",
          Property      = "prop ",
          Reference     = "ref ",
          Snippet       = "snip ",
          String        = "str ",
          Struct        = "struct ",
          Supermaven    = "AI ",
          TabNine       = "AI ",
          Text          = "txt ",
          TypeParameter = "T ",
          Unit          = "unit ",
          Value         = "val ",
          Variable      = "var ",
        },
      },
    },
  },

  -- =====================================================================
  -- lualine (statusline)
  -- =====================================================================
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        section_separators = "",
        component_separators = "|",
      },
    },
  },

  -- =====================================================================
  -- neo-tree (file explorer)
  -- =====================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      default_component_configs = {
        indent = {
          expander_collapsed = ">",
          expander_expanded  = "v",
        },
        icon = {
          folder_closed = "[+]",
          folder_open   = "[-]",
          folder_empty  = "[ ]",
          folder_empty_open = "[ ]",
          default       = " ",
        },
        git_status = {
          symbols = {
            added     = "+",
            deleted   = "x",
            modified  = "~",
            renamed   = "r",
            untracked = "?",
            ignored   = ".",
            unstaged  = "u",
            staged    = "s",
            conflict  = "!",
          },
        },
      },
      document_symbols = {
        kinds = {
          Unknown       = { icon = "?",   hl = "" },
          Root          = { icon = "/",   hl = "NeoTreeRootName" },
          File          = { icon = "f",   hl = "Tag" },
          Module        = { icon = "mod", hl = "Exception" },
          Namespace     = { icon = "ns",  hl = "Include" },
          Package       = { icon = "pkg", hl = "Label" },
          Class         = { icon = "cls", hl = "Include" },
          Method        = { icon = "mth", hl = "Function" },
          Property      = { icon = "p",   hl = "@property" },
          Field         = { icon = "fld", hl = "@field" },
          Constructor   = { icon = "ctr", hl = "@constructor" },
          Enum          = { icon = "enm", hl = "@number" },
          Interface     = { icon = "ifc", hl = "Type" },
          Function      = { icon = "fn",  hl = "Function" },
          Variable      = { icon = "var", hl = "@variable" },
          Constant      = { icon = "C",   hl = "Constant" },
          String        = { icon = "str", hl = "String" },
          Number        = { icon = "#",   hl = "Number" },
          Boolean       = { icon = "b",   hl = "Boolean" },
          Array         = { icon = "[]",  hl = "Type" },
          Object        = { icon = "{}",  hl = "Type" },
          Key           = { icon = "key", hl = "" },
          Null          = { icon = "nil", hl = "Constant" },
          EnumMember    = { icon = "em",  hl = "Number" },
          Struct        = { icon = "st",  hl = "Type" },
          Event         = { icon = "ev",  hl = "Constant" },
          Operator      = { icon = "op",  hl = "Operator" },
          TypeParameter = { icon = "T",   hl = "Type" },
        },
      },
    },
  },

  -- =====================================================================
  -- bufferline (tab bar)
  -- =====================================================================
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        buffer_close_icon = "x",
        modified_icon = "*",
        close_icon = "x",
        left_trunc_marker = "<",
        right_trunc_marker = ">",
        indicator = { icon = "|", style = "icon" },
        separator_style = { "|", "|" },
        show_buffer_icons = false,
      },
    },
  },

  -- =====================================================================
  -- which-key
  -- =====================================================================
  {
    "folke/which-key.nvim",
    opts = {
      icons = {
        mappings = false,
        breadcrumb = ">",
        separator = "-",
        group = "+",
      },
    },
  },

  -- =====================================================================
  -- noice.nvim (command line / notifications)
  -- =====================================================================
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        format = {
          cmdline    = { icon = ":" },
          search_down = { icon = "/" },
          search_up  = { icon = "?" },
          filter     = { icon = "$" },
          lua        = { icon = "lua" },
          help       = { icon = "help" },
          calculator = { icon = "=" },
          input      = { icon = ">" },
        },
      },
    },
  },

  -- =====================================================================
  -- trouble.nvim (diagnostics list)
  -- =====================================================================
  {
    "folke/trouble.nvim",
    opts = {
      icons = {
        indent = {
          top           = "| ",
          middle        = "|-",
          last          = "`-",
          fold_open     = "v ",
          fold_closed   = "> ",
          ws            = "  ",
        },
        folder_closed = "[+] ",
        folder_open   = "[-] ",
        kinds = {
          Array         = "[] ",
          Boolean       = "b ",
          Class         = "cls ",
          Constant      = "C ",
          Constructor   = "ctr ",
          Enum          = "enm ",
          EnumMember    = "em ",
          Event         = "ev ",
          Field         = "fld ",
          File          = "f ",
          Function      = "fn ",
          Interface     = "ifc ",
          Key           = "key ",
          Method        = "mth ",
          Module        = "mod ",
          Namespace     = "ns ",
          Null          = "nil ",
          Number        = "# ",
          Object        = "{} ",
          Operator      = "op ",
          Package       = "pkg ",
          Property      = "p ",
          String        = "str ",
          Struct        = "st ",
          TypeParameter = "T ",
          Variable      = "var ",
        },
      },
    },
  },

  -- =====================================================================
  -- snacks.nvim (dashboard + picker)
  -- =====================================================================
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        icons = {
          files = {
            enabled = false,
          },
          git = {
            enabled   = true,
            commit    = "c ",
            staged    = "s",
            added     = "+",
            deleted   = "x",
            ignored   = ".",
            modified  = "~",
            renamed   = "r",
            unmerged  = "!",
            untracked = "?",
          },
          diagnostics = {
            Error = "E ",
            Warn  = "W ",
            Hint  = "H ",
            Info  = "I ",
          },
          lsp = {
            unavailable = "-",
            enabled     = "+",
            disabled    = ".",
            attached    = "*",
          },
          kinds = {
            Array         = "[] ",
            Boolean       = "b ",
            Class         = "cls ",
            Color         = "clr ",
            Constant      = "C ",
            Constructor   = "ctr ",
            Copilot       = "AI ",
            Enum          = "enm ",
            EnumMember    = "em ",
            Event         = "ev ",
            Field         = "fld ",
            File          = "f ",
            Folder        = "dir ",
            Function      = "fn ",
            Interface     = "ifc ",
            Key           = "key ",
            Keyword       = "kw ",
            Method        = "mth ",
            Module        = "mod ",
            Namespace     = "ns ",
            Null          = "nil ",
            Number        = "# ",
            Object        = "{} ",
            Operator      = "op ",
            Package       = "pkg ",
            Property      = "p ",
            Reference     = "ref ",
            Snippet       = "snp ",
            String        = "str ",
            Struct        = "st ",
            Text          = "txt ",
            TypeParameter = "T ",
            Unit          = "u ",
            Unknown       = "? ",
            Value         = "val ",
            Variable      = "var ",
          },
        },
      },
      dashboard = {
        preset = {
          keys = {
            { icon = " f", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " n", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " g", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " r", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " c", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " s", key = "s", desc = "Restore Session", section = "session" },
            { icon = " L", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " q", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },

  -- =====================================================================
  -- fzf-lua
  -- =====================================================================
  {
    "ibhagwan/fzf-lua",
    opts = {
      file_icon_padding = "",
      defaults = {
        file_icons = false,
        git_icons = false,
      },
    },
  },
}
