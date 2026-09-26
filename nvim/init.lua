-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set('n', '<F5>', function()
  vim.cmd('write')

  local file = vim.fn.expand('%:p')
  local ft = vim.bo.filetype

  if ft ~= 'cpp' and ft ~= 'c' then
    vim.notify('Bu dosya C/C++ değil: ' .. ft, vim.log.levels.WARN)
    return
  end

  local output = vim.fn.expand('%:p:r')
  local compiler = (ft == 'cpp') and 'clang++ -std=c++20' or 'clang'

  local cmd = string.format(
    '%s -Wall -Wextra %s -o %s && %s',
    compiler,
    vim.fn.shellescape(file),
    vim.fn.shellescape(output),
    vim.fn.shellescape(output)
  )

  vim.cmd('botright split | resize 15 | terminal ' .. cmd)
  vim.cmd('startinsert')
end, { desc = 'C/C++ Derle ve Çalıştır' })

-- Visual modda Türkçe klavye için büyük I ataması
vim.keymap.set("x", "I", "I", { remap = false })
