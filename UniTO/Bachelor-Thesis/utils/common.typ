#let _block(text) = block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  text
)

#let _content(text) = {
  v(0.5cm)
  block(
    columns(2)[
      #text
    ]
  )
  pagebreak()
}