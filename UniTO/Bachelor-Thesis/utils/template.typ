#let project(
  title: "",
  abstract: [],
  aknowlegements: none,
  declaration-of-originality: none,
  affiliation: (),
  authors: (),
  date: none,
  logo: none,
  paper-size: "us-letter",
  bibliography-file: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set text(font: "New Computer Modern", lang: "en", size: 11pt)
  show outline.entry.where(level: 1): strong

  set page(
    paper: paper-size,
    // The margins depend on the paper size.
    margin: if paper-size == "a4" {
      (x: 41.5pt, top: 80.51pt, bottom: 89.51pt)
    } else {
      (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      )
    }
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure raw text/code blocks
  show raw.where(block: true): set text(size: 0.8em)
  show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
  )
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Configure lists and enumerations.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt, marker: ([•], [--]))

  // Configure headings.
  set heading(numbering: "1.a.I")
  show heading.where(
    level: 1
  ): it => block(width: 100%, height: 8%)[
    #set align(center)
    #set text(1.2em, weight: "bold")
    #smallcaps(it.body)
  ]
  show heading.where(
  level: 2
  ): it => block(width: 100%)[
    #set align(center)
    #set text(1.1em, weight: "bold")
    #smallcaps(it.body)
  ]
  show heading.where(
  level: 3
  ): it => block(width: 100%)[
    #set align(left)
    #set text(1em, weight: "bold")
    #smallcaps(it.body)
  ]

  // Affiliation
  align(center)[
    #grid(
      columns: auto,
      align(center)[
        #set text(1.45em, weight: "bold")
        #affiliation.university \
        #set text(12pt, weight: "regular")
        #affiliation.department \
        #affiliation.degree
      ]
    )
  ]

  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  v(1.6fr)
  if logo != none {
    align(center, image(logo, width: 50%))
  }
  v(9.6fr)

  text(1.1em, date)
  v(1.2em, weak: true)
  text(2em, weight: 700, title)


  // Author information.
  pad(
    top: 0.7em,
    right: 20%,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start)[
        #author.role \
        *#author.name* \
        #author.id
      ]),
    ),
  )

  v(2.4fr)
  pagebreak()

  // Aknowlegements
  v(1fr)

  set align(center)
  heading(level: 2, numbering: none, outlined: false, "Aknowlegements")
  aknowlegements
  v(0.2fr)

  set align(left)
  text(smallcaps[Declaration of Originality])
  linebreak()
  set text(style: "italic")
  text("\"" + declaration-of-originality + "\"")
  set text(style: "normal")
  v(0.5fr)

  // Abstract
  set align(center)
  heading(level: 2, numbering: none, "Abstract")
  abstract

  v(1.618fr)
  pagebreak()

  // Table of contents.
  outline(depth: 3, indent: true)
  pagebreak()

  // Main body
  set par(justify: true, first-line-indent: 1em)
  set align(left)
  body
  
  pagebreak()

  // Bibliography
  if bibliography-file != none {
    show bibliography: set text(0.9em)
    bibliography(bibliography-file, title: "References", style: "ieee")
  }
}