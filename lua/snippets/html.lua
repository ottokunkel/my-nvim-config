local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local rep = require('luasnip.extras').rep
local fmt = require('luasnip.extras.fmt').fmt

local snippets = {
  s(
    { trig = 'html5', name = 'HTML5 document', dscr = 'HTML5 page skeleton' },
    fmt(
      [[
      <!doctype html>
      <html lang="{}">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>{}</title>
          {}
        </head>
        <body>
          {}
        </body>
      </html>]],
      { i(1, 'en'), i(2, 'Document'), i(3), i(0) }
    )
  ),

  s(
    { trig = 'script:module', name = 'Module script', dscr = 'JavaScript module script tag' },
    fmt('<script type="module" src="{}"></script>', { i(1, './main.js') })
  ),

  s(
    { trig = 'link:css', name = 'Stylesheet link', dscr = 'CSS stylesheet link tag' },
    fmt('<link rel="stylesheet" href="{}">', { i(1, './styles.css') })
  ),

  s(
    { trig = 'meta:desc', name = 'Meta description', dscr = 'Meta description tag' },
    fmt('<meta name="description" content="{}">', { i(1) })
  ),

  s(
    { trig = 'a', name = 'Anchor', dscr = 'Anchor link' },
    fmt('<a href="{}">{}</a>', { i(1, '#'), i(0, 'link') })
  ),

  s(
    { trig = 'img', name = 'Image', dscr = 'Image tag with alt text' },
    fmt('<img src="{}" alt="{}">', { i(1), i(2) })
  ),

  s(
    { trig = 'button', name = 'Button', dscr = 'Button element' },
    fmt('<button type="{}">{}</button>', {
      c(1, { t('button'), t('submit'), t('reset') }),
      i(0, 'Button'),
    })
  ),

  s(
    { trig = 'input', name = 'Input', dscr = 'Labeled input field' },
    fmt(
      [[
      <label for="{}">{}</label>
      <input id="{}" name="{}" type="{}">]],
      {
        i(1, 'field'),
        i(2, 'Field'),
        rep(1),
        rep(1),
        c(5, { t('text'), t('email'), t('password'), t('number'), t('search'), t('tel'), t('url') }),
      }
    )
  ),

  s(
    { trig = 'form', name = 'Form', dscr = 'Basic form element' },
    fmt(
      [[
      <form action="{}" method="{}">
        {}
      </form>]],
      { i(1, '#'), c(2, { t('post'), t('get') }), i(0) }
    )
  ),

  s(
    { trig = 'section', name = 'Section', dscr = 'Section with heading' },
    fmt(
      [[
      <section>
        <h{}>{}</h{}>
        {}
      </section>]],
      { c(1, { t('2'), t('1'), t('3') }), i(2, 'Heading'), rep(1), i(0) }
    )
  ),

  s(
    { trig = 'card', name = 'Article card', dscr = 'Article/card structure' },
    fmt(
      [[
      <article class="{}">
        <h{}>{}</h{}>
        <p>{}</p>
      </article>]],
      { i(1, 'card'), c(2, { t('2'), t('3') }), i(3, 'Title'), rep(2), i(0) }
    )
  ),

  s(
    { trig = 'ul', name = 'Unordered list', dscr = 'Unordered list with items' },
    fmt(
      [[
      <ul>
        <li>{}</li>
        <li>{}</li>
        <li>{}</li>
      </ul>]],
      { i(1), i(2), i(0) }
    )
  ),

  s(
    { trig = 'table', name = 'Table', dscr = 'Accessible table scaffold' },
    fmt(
      [[
      <table>
        <caption>{}</caption>
        <thead>
          <tr>
            <th scope="col">{}</th>
            <th scope="col">{}</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>{}</td>
            <td>{}</td>
          </tr>
        </tbody>
      </table>]],
      { i(1, 'Caption'), i(2, 'Column'), i(3, 'Column'), i(4), i(0) }
    )
  ),

  s(
    { trig = 'details', name = 'Details', dscr = 'Details disclosure element' },
    fmt(
      [[
      <details>
        <summary>{}</summary>
        {}
      </details>]],
      { i(1, 'Summary'), i(0) }
    )
  ),
}

return snippets
