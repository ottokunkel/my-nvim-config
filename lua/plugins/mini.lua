return {
  'nvim-mini/mini.nvim',
  config = function()
    require('mini.ai').setup {
      mappings = {
        around_next = 'aa',
        inside_next = 'ii',
      },
      n_lines = 500,
    }

    local surround = require 'mini.surround'
    local function component_surrounding()
      local component = surround.user_input 'Component/tag'
      if component == nil then return nil end

      component = vim.trim(component)
      local component_name = component:match '^([%w_%.:%-]+)'
      if component_name == nil then
        vim.notify('Component/tag name is required', vim.log.levels.WARN)
        return nil
      end

      return { left = '<' .. component .. '>', right = '</' .. component_name .. '>' }
    end

    surround.setup {
      custom_surroundings = {
        c = {
          input = { '<([%w_%.:%-]+)[^<>]*>.-</%1>', '^<.->().*()</[^/]->$' },
          output = component_surrounding,
        },
      },
      respect_selection_type = true,
    }

    vim.keymap.set('x', '<leader>cw', 'sac', { remap = true, desc = 'Wrap selection in component' })
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = 'Surround selection' })

    require('mini.pairs').setup()

    local animate = require 'mini.animate'
    local fast_timing = animate.gen_timing.linear { duration = 120, unit = 'total' }

    animate.setup {
      cursor = {
        enable = true,
        timing = fast_timing,
        path = animate.gen_path.line { max_output_steps = 120 },
      },
      scroll = {
        -- Follow trackpad events directly, including fast swipes and momentum.
        enable = false,
      },
      resize = {
        enable = true,
        timing = fast_timing,
      },
      open = {
        enable = true,
        timing = fast_timing,
      },
      close = {
        enable = true,
        timing = fast_timing,
      },
    }
  end,
}
