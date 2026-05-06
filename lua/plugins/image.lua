return {
  '3rd/image.nvim',
  ft = { 'markdown' },
  cond = function()
    local term = vim.env.TERM or ''
    local supports_kitty_graphics = term:find('kitty') ~= nil
      or term:find('ghostty') ~= nil
      or vim.env.KITTY_WINDOW_ID ~= nil
      or vim.env.GHOSTTY_RESOURCES_DIR ~= nil
    if not supports_kitty_graphics then
      return false
    end

    if vim.env.TMUX then
      local passthrough = vim.fn.system { 'tmux', 'show', '-gv', 'allow-passthrough' }
      return vim.v.shell_error == 0 and passthrough:match('on') ~= nil
    end

    return true
  end,
  opts = {
    backend = 'kitty',
    processor = 'magick_cli',
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = 'popup',
        filetypes = { 'markdown' },
      },
    },
  },
}
