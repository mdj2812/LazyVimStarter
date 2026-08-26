return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local theme = require("config.theme")
    local transparency = require("config.transparency")
    if not theme.uses_matugen() or not transparency.lualine_enabled() then
      return opts
    end

    opts.options = opts.options or {}
    opts.options.theme = transparency.lualine_theme

    local time = opts.sections.lualine_z and opts.sections.lualine_z[1]
    if type(time) == "function" then
      opts.sections.lualine_z = {
        {
          time,
          color = transparency.lualine_component_color(),
        },
      }
    end

    for _, component in ipairs(opts.sections.lualine_c or {}) do
      if type(component) == "table" and component.color == nil then
        if component[1] == "filetype" or type(component[1]) == "function" then
          component.color = transparency.lualine_component_color()
        end
      end
    end

    for _, component in ipairs(opts.sections.lualine_x or {}) do
      if type(component) == "table" and component[1] == "diff" then
        component.diff_color = {
          added = transparency.lualine_component_color("GitSignsAdd"),
          modified = transparency.lualine_component_color("GitSignsChange"),
          removed = transparency.lualine_component_color("GitSignsDelete"),
        }
      end
    end

    return opts
  end,
}
