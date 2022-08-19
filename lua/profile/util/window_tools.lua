local winpick = require 'winpick'

local M = {}

---Move to a window determined by user prompt
function M.move_to ()
  local winid = winpick.select()
  if winid then
    vim.api.nvim_set_current_win(winid)
  end
end

---Swaps positions of the current window and one provided by user prompt.
---On completion the cursor can either be kept in the current window or moved
---to the swap target picked by the user.
---
---@param swap_cursor boolean If true sets the picked window to current window
function M.transpose (swap_cursor)
  local cur_win = vim.fn.win_getid()
  local swap_win = require'winpick'.select()
  if swap_win and cur_win ~= swap_win then
    vim.cmd 'split'
    local temp_win = vim.fn.win_getid()
    vim.fn.win_splitmove(cur_win, swap_win)
    vim.fn.win_splitmove(swap_win, temp_win)
    vim.api.nvim_win_close(temp_win, false)
    if swap_cursor then
      vim.api.nvim_set_current_win(swap_win)
    else
      vim.api.nvim_set_current_win(cur_win)
    end
  end
end

return M
