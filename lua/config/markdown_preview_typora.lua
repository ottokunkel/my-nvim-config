local M = {}

local function joinpath(...)
  if vim.fs and vim.fs.joinpath then
    return vim.fs.joinpath(...)
  end
  return table.concat({ ... }, '/'):gsub('/+', '/')
end

local function read_file(path, binary)
  local ok, lines = pcall(vim.fn.readfile, path, binary and 'b' or '')
  if not ok then
    return nil
  end
  return table.concat(lines, '\n')
end

local function write_file(path, content)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
  return vim.fn.writefile(vim.split(content, '\n', { plain = true }), path, 'b') == 0
end

local function base64_encode(data)
  if vim.base64 and vim.base64.encode then
    return vim.base64.encode(data)
  end

  local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return ((data:gsub('.', function(char)
    local byte = char:byte()
    local bits = ''
    for i = 8, 1, -1 do
      bits = bits .. (byte % 2 ^ i - byte % 2 ^ (i - 1) > 0 and '1' or '0')
    end
    return bits
  end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(bits)
    if #bits < 6 then
      return ''
    end
    local value = 0
    for i = 1, 6 do
      value = value + (bits:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
    end
    return alphabet:sub(value + 1, value + 1)
  end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

local function mime_type(path)
  local ext = path:match('%.([^.]+)$')
  ext = ext and ext:lower() or ''
  return ({
    gif = 'image/gif',
    jpeg = 'image/jpeg',
    jpg = 'image/jpeg',
    png = 'image/png',
    svg = 'image/svg+xml',
    ttf = 'font/ttf',
    woff = 'font/woff',
    woff2 = 'font/woff2',
  })[ext] or 'application/octet-stream'
end

local function is_external_url(url)
  return url:match('^data:')
    or url:match('^https?:')
    or url:match('^//')
    or url:match('^#')
    or url:match('^about:')
end

local function embed_one_url(base_dir, url)
  url = vim.trim(url)
  if is_external_url(url) then
    return 'url("' .. url .. '")'
  end

  local file_part = url:gsub('[?#].*$', '')
  local asset_path = file_part:sub(1, 1) == '/' and file_part or joinpath(base_dir, file_part)
  if vim.fn.filereadable(asset_path) ~= 1 then
    return 'url("' .. url .. '")'
  end

  local data = read_file(asset_path, true)
  if not data then
    return 'url("' .. url .. '")'
  end

  return ('url("data:%s;base64,%s")'):format(mime_type(asset_path), base64_encode(data))
end

local function embed_urls(css, base_dir)
  css = css:gsub("url%(%s*(['\"])(.-)%1%s*%)", function(_, url)
    return embed_one_url(base_dir, url)
  end)
  css = css:gsub("url%(%s*([^)'\"%s][^)]-)%s*%)", function(url)
    return embed_one_url(base_dir, url)
  end)
  return css
end

local function adapt_selectors(css)
  css = css:gsub('#write', '.markdown-body')
  css = css:gsub('%.typora%-export', 'body')
  css = css:gsub('pre%.md%-fences', 'pre')
  css = css:gsub('%.md%-fences([%s%.,:%[#>{+~])', 'pre%1')
  css = css:gsub('pre%.md%-meta%-block', 'pre')
  css = css:gsub('%.md%-meta%-block([%s%.,:%[#>{+~])', 'pre%1')
  return css
end

local function read_theme_css(path, seen)
  seen = seen or {}
  if seen[path] then
    return ''
  end
  seen[path] = true

  local css = read_file(path, false)
  if not css then
    return nil
  end

  local base_dir = vim.fn.fnamemodify(path, ':h')
  css = css:gsub('[^\n]*@include%-when%-export[^\n]*\n?', '')

  css = css:gsub("@import%s+url%(%s*(['\"]?)(.-)%1%s*%)%s*;", function(_, import_path)
    import_path = vim.trim(import_path)
    if is_external_url(import_path) then
      return ''
    end
    local import_file = import_path:sub(1, 1) == '/' and import_path or joinpath(base_dir, import_path)
    return read_theme_css(import_file, seen) or ''
  end)

  css = css:gsub("@import%s+(['\"])(.-)%1%s*;", function(_, import_path)
    import_path = vim.trim(import_path)
    if is_external_url(import_path) then
      return ''
    end
    local import_file = import_path:sub(1, 1) == '/' and import_path or joinpath(base_dir, import_path)
    return read_theme_css(import_file, seen) or ''
  end)

  css = embed_urls(css, base_dir)
  return adapt_selectors(css)
end

local defaults = [[
/* markdown-preview.nvim defaults before Typora theme rules */
html,
body,
#__next,
main {
  min-height: 100vh;
}

body {
  margin: 0;
}

.markdown-body {
  box-sizing: border-box;
  max-width: 860px;
  margin: 0 auto;
  padding: 40px 30px 100px;
}
]]

local bridge = [[

/* markdown-preview.nvim compatibility after Typora theme rules */
html,
body,
#__next,
main {
  min-height: 100vh;
}

body,
main {
  background: var(--bg-color, var(--bg, #fff)) !important;
  color: var(--text-color, var(--text, inherit)) !important;
}

#page-ctn {
  width: 100%;
  max-width: none !important;
  margin: 0 !important;
  color: inherit !important;
}

#page-header {
  display: none !important;
}

.markdown-body {
  box-sizing: border-box;
  min-height: 100vh;
  color: var(--text-color, var(--text, inherit));
}

.markdown-body > :first-child {
  margin-top: 0;
}

.markdown-body img {
  max-width: 100%;
  height: auto;
}

.markdown-body pre {
  overflow-x: auto;
}

.markdown-body pre code {
  white-space: pre;
}

.markdown-body code,
.markdown-body pre {
  font-family: var(--monospace, var(--font-code, "JetBrains Mono", "SF Mono", Menlo, Consolas, monospace));
}

.markdown-body .anchor {
  float: left;
  margin-left: -20px;
  padding-right: 4px;
  border: 0;
  opacity: 0;
}

.markdown-body h1:hover .anchor,
.markdown-body h2:hover .anchor,
.markdown-body h3:hover .anchor,
.markdown-body h4:hover .anchor,
.markdown-body h5:hover .anchor,
.markdown-body h6:hover .anchor {
  opacity: 0.55;
}

.markdown-body .contains-task-list {
  list-style: none;
}

.markdown-body input[type="checkbox"] {
  margin-right: 0.45em;
}

@media (max-width: 700px) {
  .markdown-body {
    max-width: 100% !important;
    padding-left: 18px !important;
    padding-right: 18px !important;
  }
}
]]

local highlight_css = [[
pre code.hljs {
  display: block;
  overflow-x: auto;
  padding: 0;
}

code.hljs {
  padding: 0;
}

.hljs {
  color: var(--text-color, var(--text, #383a42));
  background: transparent;
}

.hljs-comment,
.hljs-quote {
  color: var(--ef-gray-1, var(--control-text-color, #8a8f98));
  font-style: italic;
}

.hljs-keyword,
.hljs-doctag,
.hljs-formula {
  color: var(--ef-purple, #a626a4);
}

.hljs-section,
.hljs-name,
.hljs-selector-tag,
.hljs-deletion,
.hljs-subst {
  color: var(--ef-red, #e45649);
}

.hljs-literal,
.hljs-title,
.hljs-symbol,
.hljs-bullet,
.hljs-link,
.hljs-meta,
.hljs-selector-id {
  color: var(--ef-blue, var(--primary-color, #4078f2));
}

.hljs-string,
.hljs-regexp,
.hljs-addition,
.hljs-attribute,
.hljs-meta .hljs-string {
  color: var(--ef-green, #50a14f);
}

.hljs-attr,
.hljs-variable,
.hljs-template-variable,
.hljs-type,
.hljs-selector-class,
.hljs-selector-attr,
.hljs-selector-pseudo,
.hljs-number {
  color: var(--ef-orange, #986801);
}

.hljs-built_in,
.hljs-title.class_,
.hljs-class .hljs-title {
  color: var(--ef-yellow, #c18401);
}

.hljs-emphasis {
  font-style: italic;
}

.hljs-strong {
  font-weight: bold;
}

.hljs-link {
  text-decoration: underline;
}
]]

local function infer_mode(name)
  return (name:match('dark') or name:match('night') or name:match('nord')) and 'dark' or 'light'
end

local function normalize_theme_dirs(opts)
  local dirs = {}

  local function add(dir)
    if dir and dir ~= '' then
      table.insert(dirs, vim.fn.expand(dir))
    end
  end

  if opts.themes_dirs then
    if type(opts.themes_dirs) == 'string' then
      add(opts.themes_dirs)
    else
      for _, dir in ipairs(opts.themes_dirs) do
        add(dir)
      end
    end
  else
    add(opts.bundled_themes_dir)
    add(opts.themes_dir)
  end

  return dirs
end

local function discover_themes(themes_dirs)
  local themes = {}
  for _, themes_dir in ipairs(themes_dirs) do
    local files = vim.fn.glob(joinpath(themes_dir, '*.css'), false, true)
    table.sort(files)

    for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ':t:r')
      if not themes[name] then
        themes[name] = file
      end
    end
  end

  return themes
end

local function output_is_current(source, output)
  local output_time = vim.fn.getftime(output)
  return output_time > 0 and output_time >= vim.fn.getftime(source)
end

function M.names()
  local names = {}
  for name in pairs(M.generated or {}) do
    table.insert(names, name)
  end
  table.sort(names)
  return names
end

function M.generate_all()
  local opts = M.options or {}
  local themes_dirs = normalize_theme_dirs(opts)
  local generated_dir = opts.generated_dir

  vim.fn.mkdir(generated_dir, 'p')
  M.generated = {}

  for name, file in pairs(discover_themes(themes_dirs)) do
    local output = joinpath(generated_dir, name .. '.css')
    if output_is_current(file, output) then
      M.generated[name] = output
    else
      local ok, css = pcall(read_theme_css, file)
      if ok and css then
        if write_file(output, defaults .. css .. bridge) then
          M.generated[name] = output
        end
      else
        vim.schedule(function()
          vim.notify(('Could not generate markdown preview theme: %s'):format(name), vim.log.levels.WARN)
        end)
      end
    end
  end

  M.highlight_css = joinpath(generated_dir, 'highlight.css')
  write_file(M.highlight_css, highlight_css)
end

function M.set_theme(name, opts)
  opts = opts or {}
  if not M.generated or not M.generated[name] then
    M.generate_all()
  end

  if not M.generated[name] then
    vim.notify(('Unknown markdown preview theme: %s'):format(name), vim.log.levels.ERROR)
    return false
  end

  vim.g.markdown_preview_typora_theme = name
  vim.g.mkdp_markdown_css = M.generated[name]
  vim.g.mkdp_highlight_css = M.highlight_css
  vim.g.mkdp_theme = infer_mode(name)

  if not opts.silent then
    vim.notify(('Markdown preview theme: %s'):format(name))
  end

  if opts.refresh and vim.g.mkdp_clients_active == 1 and vim.fn.exists(':MarkdownPreviewStop') == 2 then
    pcall(vim.cmd, 'MarkdownPreviewStop')
    vim.defer_fn(function()
      if vim.bo.filetype == 'markdown' and vim.fn.exists(':MarkdownPreview') == 2 then
        pcall(vim.cmd, 'MarkdownPreview')
      end
    end, 150)
  end

  return true
end

function M.select_theme()
  local names = M.names()
  if #names == 0 then
    M.generate_all()
    names = M.names()
  end

  vim.ui.select(names, {
    prompt = 'Markdown preview theme',
  }, function(choice)
    if choice then
      M.set_theme(choice, { refresh = true })
    end
  end)
end

function M.setup(opts)
  M.options = vim.tbl_extend('force', {
    default_theme = vim.g.markdown_preview_typora_theme or vim.env.MARKDOWN_PREVIEW_TYPORA_THEME or 'nord',
    bundled_themes_dir = joinpath(vim.fn.stdpath('config'), 'themes', 'markdown-preview'),
    generated_dir = joinpath(vim.fn.stdpath('cache'), 'markdown-preview-typora'),
    themes_dir = vim.fn.expand('~/Library/Application Support/abnerworks.Typora/themes'),
  }, opts or {})

  M.generate_all()

  local default_theme = M.options.default_theme
  if not M.generated[default_theme] then
    default_theme = M.names()[1]
  end

  if default_theme then
    M.set_theme(default_theme, { silent = true })
  end

  pcall(vim.api.nvim_del_user_command, 'MarkdownPreviewTheme')
  vim.api.nvim_create_user_command('MarkdownPreviewTheme', function(command)
    if command.args == '' then
      M.select_theme()
    else
      M.set_theme(command.args, { refresh = true })
    end
  end, {
    complete = function()
      return M.names()
    end,
    desc = 'Select a Typora CSS theme for markdown-preview.nvim',
    nargs = '?',
  })
end

return M
