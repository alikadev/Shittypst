#state("headingLevel").update(2)
#let _HDR_COL = white             ///< Default heading color
#let _BLK_BKG = gray.lighten(60%) ///< Default block fill color
#let _BDR_COL = gray.darken(60%)  ///< Default block border color
#let _BDR_RAD = 3pt               ///< Default block border radius

#let setHeadingLevel(level) = {
  assert(level != none, message: "The global level should be set")
  context state("headingLevel").update(level)
}

/// @return true if v is boolean
#let _isBool(v) = { v == true or v == false }

/// Used to draw a title with programmatically defined level
/// @param level The level of the heading (none = default)
/// @param color The color of the heading's text
/// @param title The text of the heading
#let _leveledHeader(level: none, color: _HDR_COL, title) = context {
  assert(color != none, message: "color should be set")
  assert(title != none, message: "title should be set")
  let lvl = if level != none {level} else {state("headingLevel").get()}
  text(
    fill: color,
         if lvl == 0 {text(weight:"semibold", size:12pt, title)}
    else if lvl == 1 [= #title]
    else if lvl == 2 [== #title]
    else if lvl == 3 [=== #title]
    else if lvl == 4 [==== #title]
    else if lvl == 5 [===== #title]
    else { panic("Unexpected log level") }
  )
}

/// Draws the block's title
#let _title(
  level: none,     ///< The level of the title
  radius: _BDR_RAD, ///< The radius of the header's border
  fill:  _BLK_BKG,  ///< The fill color of the title's background
  color: _HDR_COL,  ///< The color of the title's text
  title            ///< The text of the title (none -> remove)
) = {
  assert(radius != none, message: "radius should be defined");
  assert(fill   != none, message: "fill should be defined");
  assert(color  != none, message: "color should be defined");
  assert(title  != none, message: "title should be defined");

  box(
    inset: 1mm,
    radius: radius,
    fill: fill,
    _leveledHeader(level: level, color: color, title)
  )
}

/// Draws a chapter in a mathematical document
/// @param breaking     Adds a pagebreak() before the chapter
/// @param resetHeading Will reset the heading after the chapter
/// @param name         The name of the chapter
#let chapter(breaking: true, resetHeading: true, name) = {
  assert(_isBool(breaking), message: "breaking should by `true` or `false`")
  assert(_isBool(resetHeading), message: "resetHeading should by `true` or `false`")
  assert(name != none, message: "Title should be set")

  if breaking { pagebreak() }
  align(center)[ #text(24pt, weight: "bold")[#name] ]
  line(length:100%)
  if resetHeading == true {counter(heading).update(0)}
}

/// Draws a math-block
#let block(
  title:       none,    ///< The title's text (none = remove)
  level:       none,    ///< The title's level
  titleColor:  _HDR_COL, ///< The title's color
  titleFill:   none, ///< The title's background color (default = stroke)
  titleRadius: _BDR_RAD, ///< The title's border radius
  fill:        _BLK_BKG, ///< The block's background color
  stroke:      _BDR_COL, ///< The block's border's color
  radius:      _BDR_RAD, ///< The block's border's radius
  content               ///< The content
) = {
  if titleFill == none { titleFill = stroke }
  if title != none { v(0.5mm) }
  box(
    width: 100%,
    radius: radius,
    stroke: 1pt + stroke,
    fill: fill,
    box(width: 100%, inset: 2.5mm, [
      #if title != none { // Floaty title
        move(
          dy:-5mm,
          _title(
            level: level, 
            radius: titleRadius, 
            fill: titleFill, 
            color: titleColor,
            title
          )
        )
        v(-8mm) // Counter-interact the title's presence
      }
      #content
    ])
  )
}

/// Draws a TODO block
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let TODO(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected 1 or 2 positional argument like (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: none)
  // Draw the block
  let c = color.map.rainbow.map(it => it.lighten(70%))
  block(
    level: level,
    title: title,
    titleColor: gradient.linear(..c),
    fill: gradient.linear(..c),
    stroke: black,
    radius: 0pt,
    body
  )
}

/// Draws a note block
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let nt(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected 1 or 2 positional argument like (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Note:")
  // Draw the block
  block(
    level: level,
    title: title,
    body
  )
}

/// Draws a theorem block
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let thm(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected 1 or 2 positional argument like (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Thm:")
  // Draw the block
  block(
    level: level,
    title: title,
    titleColor: white,
    fill: gradient.radial(
      rgb("#eddfec").lighten(50%),
      rgb("#eddfec")
    ),
    stroke: rgb("#802080"),
    radius: 5pt,
    body
  )
}

/// Draws an example block
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let ex(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected 1 or 2 positional argument like (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Def:")
  // Draw the block
  block(
    level: level,
    title: title,
    titleColor: white,
    titleFill: rgb("#208020").darken(20%),
    fill: gradient.radial(
      rgb("#e3f5e1").lighten(50%),
      rgb("#e3f5e1")
    ),
    stroke: rgb("#008000"),
    radius: 0pt,
    body
  )
}

/// Draws a definition block
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let def(
  level: none,
  ..content
) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected 1 or 2 positional argument like (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Def:")
  // Draw the block
  block(
    level: level,
    title: title,
    titleColor: white,
    titleFill: rgb("#c00000").darken(20%),
    fill: gradient.radial(
      rgb("#ffe2e2").lighten(20%),
      rgb("#ffe2e2")
    ),
    stroke: rgb("#c00000"),
    radius: 5pt,
    body
  )
}

/// ===== SYMBOLS ===== ///
#let int = symbol(sym.integral)
#let arr = symbol(sym.arrow)
#let part = symbol(sym.partial)
#let inf = symbol(sym.infinity)
#let pm = symbol(sym.plus.minus)
#let mp = symbol(sym.minus.plus)
#let bigg(expr, size: 100%) = $lr(#expr|, size: #size)$

/// ===== TESTING ===== ///
#if false [
  #set heading(numbering: "1.1.1.")
  #page(margin: 1.5cm)[
    #chapter(breaking:false)[Basics]
    = This is the header's tests
    == Basics
    #nt("Hi")[#lorem(100)]
    #ex("Stupid calculus")[
      $
      (part V)/(part r)
      &= lim_(Delta r -> 0) (Delta_r V)/(Delta r)
      = lim_(Delta r -> 0) (V(r + Delta r, h) - V(r, h))/(Delta r)
      = lim_(Delta r -> 0) 2 pi r h + pi h Delta h
      = 2 pi r h \
      int_(-inf)^inf x dif x &= bigg(x/2)_(-inf)^inf = dots \
      &"The vertices" (pm 1, mp 1) "are the one of a square"
      $
    ]
    == Multi-columns
    #columns(2)[
      #thm(lorem(5))[#lorem(15)]
      #def(lorem(10))[#lorem(120)]

      #ex(lorem(40))[#lorem(100)]
    ]
    #chapter[Individual testing]
    #columns(3)[
      = nts
      #nt[
        $(partial f)/(partial x)$,
        Untitled nt
      ]
      #nt[
        $(partial f)/(partial x)$,
        Untitled nt
      ]
      #nt[
        $(partial f)/(partial x)$,
        Untitled nt
      ]
      #colbreak()
      #nt("Test")[
        $(partial f)/(partial x)$,
        Titled nt
      ]
      #nt("Test")[
        $(partial f)/(partial x)$,
        Titled nt
      ]
      #nt("Test")[
        $(partial f)/(partial x)$,
        Titled nt
      ]
      #colbreak()
      #nt("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled nt
      ]
      #nt("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled nt
      ]
      #nt("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled nt
      ]
    ]
    #columns(3)[
      = TODOs
      #TODO[
        $(partial f)/(partial x)$,
        Untitled TODO
      ]
      #TODO[
        $(partial f)/(partial x)$,
        Untitled TODO
      ]
      #TODO[
        $(partial f)/(partial x)$,
        Untitled TODO
      ]
      #colbreak()
      #TODO("Test")[
        $(partial f)/(partial x)$,
        Titled TODO
      ]
      #TODO("Test")[
        $(partial f)/(partial x)$,
        Titled TODO
      ]
      #TODO("Test")[
        $(partial f)/(partial x)$,
        Titled TODO
      ]
      #colbreak()
      #TODO("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled TODO
      ]
      #TODO("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled TODO
      ]
      #TODO("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled TODO
      ]
    ]
    #columns(2)[
      = defs
      #def("Test")[
        $(partial f)/(partial x)$,
        Titled def
      ]
      #def("Test")[
        $(partial f)/(partial x)$,
        Titled def
      ]
      #def("Test")[
        $(partial f)/(partial x)$,
        Titled def
      ]
      #colbreak()
      #def("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled def
      ]
      #def("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled def
      ]
      #def("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled def
      ]
    ]
    #columns(2)[
      = thms
      #thm("Test")[
        $(partial f)/(partial x)$,
        Titled thm
      ]
      #thm("Test")[
        $(partial f)/(partial x)$,
        Titled thm
      ]
      #thm("Test")[
        $(partial f)/(partial x)$,
        Titled thm
      ]
      #colbreak()
      #thm("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled thm
      ]
      #thm("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled thm
      ]
      #thm("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled thm
      ]
    ]
    #columns(2)[
      = exs
      #ex("Test")[
        $(partial f)/(partial x)$,
        Titled ex
      ]
      #ex("Test")[
        $(partial f)/(partial x)$,
        Titled ex
      ]
      #ex("Test")[
        $(partial f)/(partial x)$,
        Titled ex
      ]
      #colbreak()
      #ex("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled ex
      ]
      #ex("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled ex
      ]
      #ex("Other test", level: 3)[
        $(partial f)/(partial x)$,
        Releveled titled ex
      ]
    ]
    #chapter[State]
    #columns(3)[
      = Heading
      #def[Default][This is the default state of the heading level]
      #setHeadingLevel(0)
      #def[Lvl 0][Set to level 0]
      #ex[Again][Won't show any heading]
      #setHeadingLevel(1)
      #def[Lvl 1][Set to level 1]
      #ex[Again][Like ```typst = .. ```]
      #setHeadingLevel(2)
      #def[Lvl 2][Set to level 2]
      #ex[Again][Like ```typst == .. ```]
      #setHeadingLevel(3)
      #def[Lvl 3][Set to level 3]
      #ex[Again][Like ```typst === .. ```]
      #setHeadingLevel(4)
      #def[Lvl 4][Set to level 4]
      #ex[Again][Like ```typst ==== .. ```]
      #setHeadingLevel(5)
      #def[Lvl 5][Set to level 5]
      #def[Lvl 5][Set to level 5]
      #ex[Again][Like ```typst ===== .. ```]
    ]
  ]
]
