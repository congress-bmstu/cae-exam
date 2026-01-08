#import "@preview/thmbox:0.1.1": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.8": *
#let notes(
  title: "",
  author: "",
  doc,
) = {
  // установка метаданных документа
  set document(
    title: title,
    author: author,
  )
  // параметры страницы (поля, размер, нумерация страниц)
  set page(
    paper: "a4",
    margin: (
      left: 10mm,
      right: 10mm,
      top: 10mm,
      bottom: 10mm,
    ),
    numbering: "1",
  )
  // шрифт
  set text(
    font: "New Computer Modern",
    size: 14pt,
    lang: "ru",
    region: "RU",
    // weight: "thin",
  )
  // абзацы
  set par(
    first-line-indent: (amount: 1.25cm, all: true), // абзацный отступ
    leading: 0.75em, // межстрочный интервал (1.5em/2)
    justify: true, // выравнивание по ширине
    linebreaks: "optimized",
    spacing: 0.75em, // интервал между параграфами
  )
  // нумерация разделов
  set heading(
    numbering: "1.1",
    outlined: true,
    supplement: [Раздел], // слово используемое при ссылке
    hanging-indent: -12.5mm,
  )
  // колхозный фикс (добавление отсупа разделам и первому абзацу внутри них)
  show heading: it => {
    let sizes = (
      "1": 18pt,
      "2": 14pt,
      "3": 14pt,
    )
    pad(left: 1.25cm, text(size: sizes.at(str(it.level)), weight: "bold", it))
    par(spacing: 0.75em)[#text(
      size: 0mm,
    )[#h(0.0em)]] // когда https://github.com/typst/typst/pull/5768 войдет в релиз, убрать это
  }
  // обнуление счетчиком рисунков таблиц и уравнений в каждой главе
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }
  // нумерация уравнений
  // set math.equation(numbering: "(1)")
  // формат лейблов у уравнений
  set math.equation(numbering: num => "(" + (str(counter(heading).get().at(0)) + "." + str(num)) + ")")
  // автоматическое добавление номера уравнениям при ссылке на них
  // show math.equation: it => {
  //   if it.block and not it.has("label") [
  //     #counter(math.equation).update(v => v - 1)
  //     #math.equation(it.body, block: true, numbering: none)
  //   ] else {
  //     it
  //   }
  // }
  // нумерация и подпись к рисункам
  set figure(
    // placement: auto,
    supplement: [Рисунок], // слово используемое при ссылке
    numbering: num => str(counter(heading).get().at(0)) + "." + str(num), // нумерация внутри раздела
  )
  // Убирает точку. Было "Рисунок 1.1. Подпись" Стало: "Рисунок 1.1 Подпись"
  set figure.caption(separator: " ")
  show figure.caption: it => {
    set par(leading: 0.5em)
    it
  }
  // Подпись к таблицам
  show figure.where(kind: table): set figure(supplement: [Таблица])
  // Возможность figure пересекать границу страницы и быть перенесенной на следующую (для длинных теорем)
  show figure: set block(breakable: true)

  // оглавление
  set outline(
    title: none,
    indent: auto, // автоматические табуляции
  )
  set outline.entry(
    fill: repeat([.], gap: 5pt), // многоточие после пунктов
  )
  // подпись СОДЕРЖАНИЕ посередине
  show outline: it => {
    text(
      weight: "bold",
      [
        #align(center, text(size: 20pt)[СОДЕРЖАНИЕ])
        #align(right, [c.])
      ],
    )
    it
  }
  // для заголовков первого уровня жирный шрифт
  show outline.entry.where(level: 1): it => {
    // set text(font: heading-font, size: info-size)
    v(1em, weak: false)
    link(
      it.element.location(),
      text(
        weight: "bold",
        size: 16pt,
        {
          h(-1.25cm)
          it.body() + " "
          text(weight: "light", box(width: 1fr, repeat([.], gap: 5pt)))
          " " + it.page()
        },
      ),
    )
  }

  // пункты в ненумерованных списоках
  set list(
    tight: false,
    // marker: ([---], [---], [---]),
    spacing: 1em,
    indent: 0.55cm,
  )
  set enum(indent: 0.55cm)
  show list: it => {
    // v(0.5em)
    it
    v(0.5em)
  }
  // если пункт списка на несколько строк, то он будет весь выровнен по абзацному отступу, это фикс
  // теперь первая строка с отсупом, остальное нормально (ну собственно так и должно быть)
  // show list.item: it => {
  //   par(hanging-indent: -1.25cm, it)
  // }

  // библиография
  set bibliography(
    style: "gost-r-705-2008-numeric",
    title: "СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ",
  )
  // чтобы ссылки отображались как (число)
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.
      link(
        el.location(),
        numbering(
          el.numbering,
          ..counter(eq).at(el.location()),
        ),
      )
    } else {
      // Other references as usual.
      it
    }
  }

  ////////// НАЧАЛО ДОКУМЕНТА //////////
  show: thmbox-init() // инициализация плагина с окружениями
  show: codly-init.with() // инициализация плагина с красивыми блоками кода
  codly(languages: codly-languages)
  doc
}
// центрированная глава
#let centerchapter(text) = {
  context counter(heading).update(counter(heading).get().at(0) + 1)
  align(center)[#heading(numbering: none, text)]
}
// возможность вставлять пдфку
#import "@preview/muchpdf:0.1.0": muchpdf
#let includepdf(pdf_file, ..args) = {
  muchpdf(read(pdf_file, encoding: none), ..args)
}

// всевозможные окружения
#let thmbox = thmbox.with(
  sans-fonts: "New Computer Modern",
  title-fonts: "New Computer Modern",
)
#let todo(
  fill: yellow.lighten(80%),
  variant: "TODO",
  color: red,
  ..args,
) = thmbox(fill: fill, variant: variant, color: color, ..args)

#let dark-red = rgb("#C5283D")
#let mint = rgb("3eb489")
#let aqua = rgb("#3fa1d2")
#let dark-blue = rgb("#11388d")
#let purple = rgb("#66118d")
#let purple2 = rgb("#6d50b4")
#let pink = rgb("#c34dd1")
#let womit = rgb("#264a3e")

#let theorem(..args) = thmbox(
  variant: "Теорема",
  color: dark-red,
  ..args,
)
#let theorem_(..args) = thmbox(
  variant: "Теорема",
  color: dark-red,
  numbering: none,
  ..args,
)
#let THEOREM(..args) = thmbox(
  variant: "Теорема",
  color: dark-red,
  fill: dark-red.lighten(85%),
  ..args,
)
#let THEOREM_(..args) = thmbox(
  variant: "Теорема",
  color: dark-red,
  fill: dark-red.lighten(85%),
  numbering: none,
  ..args,
)

#let proposition(..args) = thmbox(
  variant: "Предложение",
  color: mint,
  ..args,
)
#let proposition_(..args) = thmbox(
  variant: "Предложение",
  color: mint,
  numbering: none,
  ..args,
)
#let PROPOSITION(..args) = thmbox(
  variant: "Предложение",
  color: mint,
  fill: mint.lighten(85%),
  ..args,
)
#let PROPOSITION_(..args) = thmbox(
  variant: "Предложение",
  color: mint,
  fill: mint.lighten(85%),
  numbering: none,
  ..args,
)

#let lemma(..args) = thmbox(
  variant: "Лемма",
  color: green,
  ..args,
)
#let lemma_(..args) = thmbox(
  variant: "Лемма",
  color: green,
  numbering: none,
  ..args,
)
#let LEMMA(..args) = thmbox(
  variant: "Лемма",
  color: green,
  fill: green.lighten(85%),
  ..args,
)
#let LEMMA_(..args) = thmbox(
  variant: "Лемма",
  color: green,
  fill: green.lighten(85%),
  numbering: none,
  ..args,
)

#let corollary(..args) = thmbox(
  variant: "Следствие",
  color: aqua,
  ..args,
)
#let corollary_(..args) = thmbox(
  variant: "Следствие",
  color: aqua,
  numbering: none,
  ..args,
)
#let COROLLARY(..args) = thmbox(
  variant: "Следствие",
  color: aqua,
  fill: aqua.lighten(85%),
  ..args,
)
#let COROLLARY_(..args) = thmbox(
  variant: "Следствие",
  color: aqua,
  fill: aqua.lighten(85%),
  numbering: none,
  ..args,
)

#let definition(..args) = thmbox(
  variant: "Определение",
  color: blue,
  ..args,
)
#let definition_(..args) = thmbox(
  variant: "Определение",
  color: blue,
  numbering: none,
  ..args,
)
#let DEFINITION(..args) = thmbox(
  variant: "Определение",
  color: blue,
  fill: blue.lighten(85%),
  ..args,
)
#let DEFINITION_(..args) = thmbox(
  variant: "Определение",
  color: blue,
  fill: blue.lighten(85%),
  numbering: none,
  ..args,
)

#let example(..args) = thmbox(
  variant: "Пример",
  color: purple2,
  ..args,
)
#let example_(..args) = thmbox(
  variant: "Пример",
  color: purple2,
  numbering: none,
  ..args,
)
#let EXAMPLE(..args) = thmbox(
  variant: "Пример",
  color: purple2,
  fill: purple2.lighten(85%),
  ..args,
)
#let EXAMPLE_(..args) = thmbox(
  variant: "Пример",
  color: purple2,
  fill: purple2.lighten(85%),
  numbering: none,
  ..args,
)

#let remark(..args) = thmbox(
  variant: "Замечание",
  color: dark-blue,
  ..args,
)
#let remark_(..args) = thmbox(
  variant: "Замечание",
  color: dark-blue,
  numbering: none,
  ..args,
)
#let REMARK(..args) = thmbox(
  variant: "Замечание",
  color: dark-blue,
  fill: dark-blue.lighten(85%),
  ..args,
)
#let REMARK_(..args) = thmbox(
  variant: "Замечание",
  color: dark-blue,
  fill: dark-blue.lighten(85%),
  numbering: none,
  ..args,
)

#let note(..args) = thmbox(
  variant: "Заметка",
  color: womit,
  ..args,
)
#let note_(..args) = thmbox(
  variant: "Заметка",
  color: womit,
  numbering: none,
  ..args,
)
#let NOTE(..args) = thmbox(
  variant: "Заметка",
  color: womit,
  fill: womit.lighten(85%),
  ..args,
)
#let NOTE_(..args) = thmbox(
  variant: "Заметка",
  color: womit,
  fill: womit.lighten(85%),
  numbering: none,
  ..args,
)

#let algo(..args) = thmbox(
  variant: [`Алгоритм`],
  color: mint.darken(25%),
  ..args,
)
#let algo_(..args) = thmbox(
  variant: [`Алгоритм`],
  color: mint,
  numbering: none,
  ..args,
)
#let ALGO(..args) = thmbox(
  variant: [`Алгоритм`],
  color: mint.darken(25%),
  fill: mint.darken(25%).lighten(85%),
  ..args,
)
#let ALGO_(..args) = thmbox(
  variant: [`Алгоритм`],
  color: mint,
  numbering: none,
  ..args,
)

#let claim(..args) = thmbox(
  variant: "Утверждение",
  color: orange,
  ..args,
)
#let claim_(..args) = thmbox(
  variant: "Утверждение",
  color: orange,
  numbering: none,
  ..args,
)
#let CLAIM(..args) = thmbox(
  variant: "Утверждение",
  color: orange,
  fill: orange.lighten(85%),
  ..args,
)
#let CLAIM_(..args) = thmbox(
  variant: "Утверждение",
  color: orange,
  fill: orange.lighten(85%),
  numbering: none,
  ..args,
)

#let question(..args) = thmbox(
  variant: "Вопрос",
  color: purple,
  ..args,
)
#let question_(..args) = thmbox(
  variant: "Вопрос",
  color: purple,
  numbering: none,
  ..args,
)
#let QUESTION(..args) = thmbox(
  variant: "Вопрос",
  color: purple,
  fill: purple.lighten(85%),
  ..args,
)
#let QUESTION_(..args) = thmbox(
  variant: "Вопрос",
  color: purple,
  fill: purple.lighten(85%),
  numbering: none,
  ..args,
)

#let axiom(..args) = thmbox(
  variant: "Аксиома",
  color: pink,
  ..args,
)
#let axiom_(..args) = thmbox(
  variant: "Аксиома",
  color: pink,
  numbering: none,
  ..args,
)
#let AXIOM(..args) = thmbox(
  variant: "Аксиома",
  color: pink,
  fill: pink.lighten(85%),
  ..args,
)
#let AXIOM_(..args) = thmbox(
  variant: "Аксиома",
  color: pink,
  fill: pink.lighten(85%),
  numbering: none,
  ..args,
)
#let proof = proof.with(title: "Доказательство")
