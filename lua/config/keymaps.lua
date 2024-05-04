-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("n", "-", "<cmd>Oil<cr>", { desc = "Oil (cwd)" })
map("n", "<C-o>", "<cmd>Oil --float<cr>", { desc = "Oil Floating (cwd)" })
