return {
  "mistricky/codesnap.nvim",
  tag = "v2.0.5",
  opts = {
    show_line_number = true,
    snapshot_config = {
      themes_folders = {
        "~/.config/codesnap/themes",
      },
      theme = "vercel",
      window = {
        mac_window_bar = true,
        shadow = {
          radius = 20,
          color = "#00000040",
        },
        margin = {
          x = 82,
          y = 82,
        },
        border = {
          width = 1,
          color = "#ffffff30",
        },
        title_config = {
          color = "#ffffff",
          font_family = "Pacifico",
        },
      },
      code_config = {
        font_family = "CaskaydiaCove Nerd Font",
        breadcrumbs = {
          enable = false,
          separator = "/",
          color = "#80848b",
          font_family = "CaskaydiaCove Nerd Font",
        },
      },
      watermark = {
        content = "",
        font_family = "Pacifico",
        color = "#ffffff",
      },
      background = {
        start = {
          x = 0,
          y = 0,
        },
        ["end"] = {
          x = "max",
          y = "max",
        },
        stops = {
          {
            position = 0,
            color = "#0A0A0A",
          },
          {
            position = 0.94,
            color = "#000000",
          },
        },
      },
      line_number_color = "#D3D3D3",
    },
  },
}
