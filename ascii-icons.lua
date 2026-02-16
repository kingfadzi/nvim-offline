-- ASCII/Unicode icon replacements for environments without Nerd Fonts
return {
  -- Disable icon plugins
  { "nvim-tree/nvim-web-devicons", enabled = false },
  { "echasnovski/mini.icons", enabled = false },

  -- Override all LazyVim icons with ASCII equivalents
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

  -- Override lualine to not use icon separators
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
}
