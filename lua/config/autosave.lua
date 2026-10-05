local M = {}

local group = vim.api.nvim_create_augroup('autosave-toggle', { clear = true })

local function enabled()
  return vim.g.autosave_enabled == true or vim.g.autosave_enabled == 1
end

local function set_enabled(value)
  vim.g.autosave_enabled = value
  vim.notify('Autosave ' .. (value and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function save_buffer(buf)
  if not enabled() then return end
  if not vim.api.nvim_buf_is_loaded(buf) then return end
  if vim.bo[buf].buftype ~= '' then return end
  if not vim.bo[buf].modifiable or vim.bo[buf].readonly then return end
  if vim.api.nvim_buf_get_name(buf) == '' then return end
  if not vim.bo[buf].modified then return end

  vim.api.nvim_buf_call(buf, function()
    local ok, err = pcall(vim.cmd, 'silent update')
    if not ok then vim.notify('Autosave failed: ' .. err, vim.log.levels.WARN) end
  end)
end

function M.toggle()
  set_enabled(not enabled())
end

function M.enable()
  set_enabled(true)
end

function M.disable()
  set_enabled(false)
end

function M.status()
  vim.notify('Autosave is ' .. (enabled() and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

function M.setup()
  vim.g.autosave_enabled = enabled()

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'FocusLost' }, {
    desc = 'Autosave normal file buffers when enabled',
    group = group,
    callback = function(args) save_buffer(args.buf) end,
  })

  vim.api.nvim_create_user_command('AutoSaveToggle', M.toggle, { desc = 'Toggle autosave' })
  vim.api.nvim_create_user_command('AutoSaveEnable', M.enable, { desc = 'Enable autosave' })
  vim.api.nvim_create_user_command('AutoSaveDisable', M.disable, { desc = 'Disable autosave' })
  vim.api.nvim_create_user_command('AutoSaveStatus', M.status, { desc = 'Show autosave status' })
end

return M
