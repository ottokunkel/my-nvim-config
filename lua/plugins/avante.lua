return {
  'yetone/avante.nvim',
  build = vim.fn.has('win32') ~= 0
      and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
    or 'make',
  event = 'VeryLazy',
  version = false,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- ACP provider: spawns `codex-acp`, which authenticates via the ChatGPT
    -- login in ~/.codex/auth.json. Leave OPENAI_API_KEY unset or it bills the
    -- API account instead of the subscription.
    provider = 'codex',
    instructions_file = 'avante.md',
    selector = {
      provider = 'telescope',
    },
    providers = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = 'google/gemini-3.5-flash',
        timeout = 30000,
        extra_request_body = {
          temperature = 0.4,
          max_tokens = 12000,
        },
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
    'HakonHarnes/img-clip.nvim',
    'Kaiser-Yang/blink-cmp-avante',
  },
}
