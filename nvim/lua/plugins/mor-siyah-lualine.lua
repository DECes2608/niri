return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local c = {
      bg      = "#120e16", -- karanlık mor-siyah
      bg2     = "#2a1b3d", -- orta mor-siyah
      fg      = "#e0dbed", -- açık lavanta
      fg2     = "#9283a8", -- soluk mor-gri
      purple1 = "#a855f7", -- canlı mor (normal mod)
      purple2 = "#c792ea", -- parlak lavanta (visual mod)
      purple3 = "#8b5cf6", -- koyu parlak mor (command mod)
      magenta = "#e879f9", -- pembe-mor (insert mod)
    }

    local dagzirvesi = {
      normal = {
        a = { fg = c.bg, bg = c.purple1, gui = "bold" },
        b = { fg = c.fg, bg = c.bg2 },
        c = { fg = c.fg2, bg = "NONE" },
      },
      insert = {
        a = { fg = c.bg, bg = c.magenta, gui = "bold" },
        b = { fg = c.fg, bg = c.bg2 },
        c = { fg = c.fg2, bg = "NONE" },
      },
      visual = {
        a = { fg = c.bg, bg = c.purple2, gui = "bold" },
        b = { fg = c.fg, bg = c.bg2 },
        c = { fg = c.fg2, bg = "NONE" },
      },
      replace = {
        a = { fg = c.bg, bg = "#f43f5e", gui = "bold" },
        b = { fg = c.fg, bg = c.bg2 },
        c = { fg = c.fg2, bg = "NONE" },
      },
      command = {
        a = { fg = c.bg, bg = c.purple3, gui = "bold" },
        b = { fg = c.fg, bg = c.bg2 },
        c = { fg = c.fg2, bg = "NONE" },
      },
      inactive = {
        a = { fg = c.fg2, bg = c.bg2 },
        b = { fg = c.fg2, bg = c.bg2 },
        c = { fg = c.fg2, bg = "NONE" },
      },
    }

    opts.options = {
      theme                = dagzirvesi,
      component_separators = { left = "│", right = "│" },
      section_separators   = { left = "", right = "" },
      globalstatus         = true,
    }

    opts.sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    }

    return opts
  end,
}
