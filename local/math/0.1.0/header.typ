#let chapter(breaking: true, name) = {
  [
    #if breaking [
      #pagebreak()
    ]
    #align(center)[#text(24pt, weight: "bold")[#name]]
    #counter(heading).update(0) // Reset heading's numbering
    #line(length:100%)
  ]
}

#let block(
  title: "Title's name",
  titleColor: white,
  titleFill: none,
  titleRadius: 3pt,
  width: 100%,
  fill: gray.lighten(50%),
  stroke: gray.darken(50%),
  radius: 5pt,
  content
) = {
  if titleFill == none { titleFill = stroke }
  v(2mm)
  box(
    width: width,
    radius: radius,
    stroke: 1pt + stroke,
    fill: fill,
    box(width: 100%, inset: 2.5mm, [
      #move(
        dy:-5mm,
        box(
          inset: 1mm,
          radius: titleRadius,
          fill: titleFill,
          [
            #text(
              weight:600,
              titleColor
            )[== #title]
          ]
        )
      )
      #v(-8mm)
      #content
    ])
  )
}

#let TODO(title: none, content) = {
  let c = color.map.rainbow.map(it => it.lighten(70%))
  block(
    title: if title == none {"! To do !"} else {"! "+title+" !"},
    titleColor: gradient.linear(..c),
    fill: gradient.linear(..c),
    stroke: black,
    radius: 0pt,
    content
  )
}

#let nt(title: none, content) = {
  block(
    title: if title == none {"Note:"} else {title},
    content
  )
}

#let thm(
  title: none,
  width: 100%,
  content
) = {
  block(
    title: "Theorem: " + title,
    titleColor: white,
    width: width,
    fill: gradient.radial(
      rgb("#fad9f7").lighten(50%),
      rgb("#fad9f7")
    ),
    stroke: rgb("#800080"),
    radius: 5pt,
    content
  )
}

#let ex(
  title: "Title",
  width: 100%,
  content
) = {
  block(
    title: "Exercice: " + title,
    titleColor: white,
    titleFill: rgb("#008000").darken(20%),
    width: width,
    fill: gradient.radial(
      rgb("#ccf5c9").lighten(40%),
      rgb("#ccf5c9").lighten(20%)
    ),
    stroke: rgb("#008000"),
    radius: 0pt,
    content
  )
}

#let def(
  title: "Title",
  width: 100%,
  content
) = {
  block(
    title: title,
    titleColor: white,
    titleFill: rgb("#c00000").darken(20%),
    width: width,
    fill: gradient.radial(
      rgb("#ffe2e2").lighten(20%),
      rgb("#ffe2e2")
    ),
    stroke: rgb("#c00000"),
    radius: 5pt,
    content
  )
}

/// ===== TESTING ===== ///
#if true [
  #page(margin: 1.5cm)[
    #chapter[My chapteri]
    = This is the header's tests
    == Basics
    #block(title: "Hi")[#lorem(100)]
    #ex(title:"Partial derivative example")[
      $
      (partial V)/(partial r)
      &= lim_(Delta r -> 0) (Delta_r V)/(Delta r)
      = lim_(Delta r -> 0) (V(r + Delta r, h) - V(r, h))/(Delta r)
      = lim_(Delta r -> 0) 2 pi r h + pi h Delta h
      = 2 pi r h \
      (partial V)/(partial h)
      &= lim_(Delta h -> 0) (Delta_h V)/(Delta h)
      = lim_(Delta h -> 0) pi r^2
      = \pi r^2
      $
      Hi friends!
      $
      (partial z)/(partial x_i)
      = (partial f)/(partial x_i)
      = lim_(Delta x_i -> 0) (Delta_(x_i) f)/(Delta x_i),
      " "lr((partial z)/(partial x_i) |, size: #100%)_((1,2)) = ...
      $
    ]
    == Multi-columns
    #columns(2)[
      #thm(title:lorem(5))[#lorem(15)]
      #def(title:lorem(10))[#lorem(120)]

      #ex(title:lorem(40))[#lorem(100)]
    ]
    == Big boys
    #def(title:lorem(5))[#lorem(250)]
    #def(title:lorem(5))[
      #lorem(500)
    ]
    = Starting to have some fun
    #def(title: "Your mom is so black")[
      #ex(title: "What am I doing rn?")[
        This is the inner content
      ]
      This is the outer content
      #ex(title: "What am I doing rn?")[
        This is the inner outer content
        #thm(title: "What am I doing rn?")[
          This is the inner inner content
        ]
        #nt(title: "So")[This is something I guess]
      ]
    ]
  ]
]
