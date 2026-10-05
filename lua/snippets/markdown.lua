-- Latex-suite-inspired math snippets for markdown.
-- Inspired by https://github.com/artisticat1/obsidian-latex-suite

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta

-- Detect whether the cursor sits inside $...$ inline math or a $$...$$
-- display math block. This keeps math snippets available after expanding
-- `mk` or `dm`, while hiding them from normal prose.
local function in_mathzone()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)
  table.insert(lines, vim.api.nvim_get_current_line():sub(1, col))
  local text = table.concat(lines, '\n')
  local in_inline, in_display = false, false
  local idx, n = 1, #text

  while idx <= n do
    local c = text:sub(idx, idx)
    if c == '\\' then
      idx = idx + 2
    elseif text:sub(idx, idx + 1) == '$$' then
      if not in_inline then in_display = not in_display end
      idx = idx + 2
    elseif c == '$' then
      if not in_display then in_inline = not in_inline end
      idx = idx + 1
    else
      idx = idx + 1
    end
  end

  return in_inline or in_display
end

local function not_in_mathzone()
  return not in_mathzone()
end

-- Math autosnippet, plain text expansion.
-- wordTrig defaults to false (permissive); pass true for function-name triggers.
local function ma(trig, expansion, wordTrig)
  return s(
    { trig = trig, snippetType = 'autosnippet', wordTrig = wordTrig == true },
    t(expansion),
    { condition = in_mathzone, show_condition = in_mathzone }
  )
end

-- Math autosnippet that takes an explicit nodes list (for insert nodes / fmta).
local function mn(trig, nodes, wordTrig)
  return s(
    { trig = trig, snippetType = 'autosnippet', wordTrig = wordTrig == true },
    nodes,
    { condition = in_mathzone, show_condition = in_mathzone }
  )
end

-- Math autosnippet, word boundary required (function names like sin, cos).
local function mw(trig, expansion)
  return ma(trig, expansion, true)
end

local snippets = {}

local autosnippets = {
  s(
    { trig = 'mk', name = 'Inline math', dscr = 'Markdown inline math span', snippetType = 'autosnippet', hidden = true },
    fmta('$<>$<>', { i(1), i(0) })
  ),
  s(
    { trig = 'dm', name = 'Display math', dscr = 'Markdown display math block', snippetType = 'autosnippet', hidden = true },
    fmta('$$\n<>\n$$\n<>', { i(1), i(0) })
  ),
  s(
    { trig = '**', name = 'Bold', dscr = 'Markdown bold span', snippetType = 'autosnippet', wordTrig = false, hidden = true },
    fmta('**<>**<>', { i(1), i(0) }),
    { condition = not_in_mathzone, show_condition = not_in_mathzone }
  ),

  -- Greek lowercase
  ma('@a', '\\alpha'),
  ma('@b', '\\beta'),
  ma('@g', '\\gamma'),
  ma('@d', '\\delta'),
  ma('@e', '\\epsilon'),
  ma('@z', '\\zeta'),
  ma('@h', '\\eta'),
  ma('@t', '\\theta'),
  ma('@k', '\\kappa'),
  ma('@l', '\\lambda'),
  ma('@m', '\\mu'),
  ma('@n', '\\nu'),
  ma('@x', '\\xi'),
  ma('@p', '\\pi'),
  ma('@r', '\\rho'),
  ma('@s', '\\sigma'),
  ma('@u', '\\upsilon'),
  ma('@f', '\\phi'),
  ma('@vf', '\\varphi'),
  ma('@c', '\\chi'),
  ma('@y', '\\psi'),
  ma('@w', '\\omega'),
  ma('@ve', '\\varepsilon'),

  -- Greek uppercase
  ma('@G', '\\Gamma'),
  ma('@D', '\\Delta'),
  ma('@T', '\\Theta'),
  ma('@L', '\\Lambda'),
  ma('@X', '\\Xi'),
  ma('@P', '\\Pi'),
  ma('@S', '\\Sigma'),
  ma('@F', '\\Phi'),
  ma('@Y', '\\Psi'),
  ma('@W', '\\Omega'),

  -- Number sets
  ma('RR', '\\mathbb{R}'),
  ma('NN', '\\mathbb{N}'),
  ma('ZZ', '\\mathbb{Z}'),
  ma('QQ', '\\mathbb{Q}'),
  ma('CC', '\\mathbb{C}'),
  ma('FF', '\\mathbb{F}'),
  ma('PP', '\\mathbb{P}'),
  ma('EE', '\\mathbb{E}'),

  -- Operators / symbols
  ma('xx', '\\times'),
  ma('**', '\\cdot'),
  ma('->', '\\to'),
  ma('!>', '\\mapsto'),
  ma('=>', '\\implies'),
  ma('=<', '\\impliedby'),
  ma('iff', '\\iff'),
  ma('<->', '\\leftrightarrow'),
  ma('>=', '\\geq'),
  ma('<=', '\\leq'),
  ma('!=', '\\neq'),
  ma('~~', '\\sim'),
  ma('~=', '\\approx'),
  ma('-=', '\\equiv'),
  ma('inn', '\\in '),
  ma('notin', '\\notin '),
  ma('sub', '\\subset '),
  ma('sup', '\\supset '),
  ma('subs', '\\subseteq '),
  ma('sups', '\\supseteq '),
  ma('cup', '\\cup '),
  ma('cap', '\\cap '),
  ma('OO', '\\emptyset'),
  ma('inf', '\\infty'),
  ma('nabl', '\\nabla '),
  ma('del', '\\partial '),
  ma('AA', '\\forall '),
  ma('exi', '\\exists '),
  ma('ooo', '\\circ'),

  -- Powers / subscripts
  ma('sr', '^{2}'),
  ma('cb', '^{3}'),
  mn('td', fmta('^{<>}<>', { i(1), i(0) })),
  ma('invs', '^{-1}'),

  -- Roots / fractions
  mn('sq', fmta('\\sqrt{<>}<>', { i(1), i(0) })),
  mn('//', fmta('\\frac{<>}{<>}<>', { i(1), i(2), i(0) })),

  -- Big operators (word-bounded)
  mn('sum', fmta('\\sum_{<>}^{<>} <>', { i(1, 'i=1'), i(2, 'n'), i(0) }), true),
  mn('prod', fmta('\\prod_{<>}^{<>} <>', { i(1, 'i=1'), i(2, 'n'), i(0) }), true),
  mn('int', fmta('\\int_{<>}^{<>} <> \\, d<>', { i(1, '-\\infty'), i(2, '\\infty'), i(3), i(0, 'x') }), true),
  mn('lim', fmta('\\lim_{<> \\to <>} <>', { i(1, 'n'), i(2, '\\infty'), i(0) }), true),
  mn('ee', fmta('e^{<>}<>', { i(1), i(0) }), true),

  -- Trig / log (word-bounded)
  mw('sin', '\\sin'),
  mw('cos', '\\cos'),
  mw('tan', '\\tan'),
  mw('csc', '\\csc'),
  mw('sec', '\\sec'),
  mw('cot', '\\cot'),
  mw('arcsin', '\\arcsin'),
  mw('arccos', '\\arccos'),
  mw('arctan', '\\arctan'),
  mw('ln', '\\ln'),
  mw('log', '\\log'),
  mw('exp', '\\exp'),
  mw('det', '\\det'),
  mw('min', '\\min'),
  mw('max', '\\max'),

  -- Decorations
  mn('vec', fmta('\\vec{<>}<>', { i(1), i(0) }), true),
  mn('hat', fmta('\\hat{<>}<>', { i(1), i(0) }), true),
  mn('bar', fmta('\\bar{<>}<>', { i(1), i(0) }), true),
  mn('tilde', fmta('\\tilde{<>}<>', { i(1), i(0) }), true),

  -- Matrices
  mn('pmat', fmta('\\begin{pmatrix} <> \\end{pmatrix} <>', { i(1), i(0) }), true),
  mn('bmat', fmta('\\begin{bmatrix} <> \\end{bmatrix} <>', { i(1), i(0) }), true),
  mn('vmat', fmta('\\begin{vmatrix} <> \\end{vmatrix} <>', { i(1), i(0) }), true),

  -- Cases / aligned (use inside $$...$$)
  mn('cases', fmta('\\begin{cases} <> \\end{cases}', { i(1) }), true),
  mn('align', fmta('\\begin{aligned} <> \\end{aligned}', { i(1) }), true),
}

return snippets, autosnippets
