/// Author: Elvin Kuci
/// Date: 22 apr 2026
/// Descr:
/// Entry point, defines main functions

#import "./const.typ":*
#import "./tools.typ":*

/// ===== SYMBOLS ===== ///
#let int = symbol(sym.integral)
#let arr = symbol(sym.arrow)
#let part = symbol(sym.partial)
#let inf = symbol(sym.infinity)
#let pm = symbol(sym.plus.minus)
#let mp = symbol(sym.minus.plus)
#let grad = symbol(sym.gradient)
#let eps = symbol(sym.epsilon)
#let bigg(expr, size: 100%) = $lr(#expr|, size: #size)$

/// ===== STATE MGMT ===== ///

#state("headingLevel").update(2)

#let setHeadingLevel(level) = {
  assert(level != none, message: "The global level should be set")
  context state("headingLevel").update(level)
}

#let resetHeading() = { conter(heading).update(0) }

/// ===== BLOCKS THEMSELF===== ///

/// Draws a chapter in a mathematical document
/// @param breaking     Adds a pagebreak() before the chapter
/// @param resetHeading Will reset the heading after the chapter
/// @param name         The name of the chapter
#let chapter(breaking: true, resetHeading: false, name) = {
  assert(_isBool(breaking),     message: "breaking should boolean")
  assert(_isBool(resetHeading), message: "resetHeading should boolean")
  assert(name != none,          message: "name should be set")

  if breaking { pagebreak() }
  if resetHeading == true { resetHeading(0) }
  align(center)[ #text(_CHAP_TXT, weight: "bold")[#name] ]
  line(length:100%)
}

/// Draws a math-blk
/// @param level  Optional title level
/// @param title  Optional title structure, @see title_struct
/// @param fill   The block's background fill
/// @param stroke The border's color
/// @param radius The border's radius
///
/// @def title_struct: (content, color, fill, radius)
///                    if color  not set, using _HDR_COLOR
///                    if fill   not set, using stroke
///                    if radius not set, using BDR_RAD
#let blk(
  level:       none,
  title:       none,
  fill:        _BLK_BKG,
  stroke:      _BDR_COL,
  radius:      _BDR_RAD,
  content
) = {
  if title != none { v(2mm) }
  box(
    width: 100%,
    radius: radius,
    stroke: 1pt + stroke,
    fill: fill,
    box(width: 100%, inset: 2.5mm, [
      #if title.at("content") != none { // Floaty title
        move(
          dy:-5mm,
          _title(
            level: level,
            radius: title.at("radius", default: _BDR_RAD),
            fill: title.at("fill", default: stroke),
            color: title.at("color", default: _HDR_COL),
            title.at("content")
          )
        )
        v(-8mm) // Counter-interact the title's presence
      }
      #content
    ])
  )
}

/// Draws a TODO blk
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let TODO(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: none)
  // Draw the blk
  blk(
    level: level,
    title: (content: title, color: _TODO_FILL,),
    fill: _TODO_FILL,
    stroke: _TODO_STROKE,
    radius: _TODO_RAD,
    body
  )
}

/// Draws a note blk
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let nt(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  if (level == none) {level = 0}
  assert(
    content.len() > 0,
    message: "Expected (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Note:")
  // Draw the blk
  blk(
    level: level,
    title: (content: title,),
    body
  )
}

/// Draws a theorem blk
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let thm(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Thm:")
  // Draw the blk
  blk(
    level: level,
    title: (content: title, color: _THM_HDR_FILL,),
    fill: _THM_FILL,
    stroke: _THM_STROKE,
    radius: _THM_RAD,
    body
  )
}

/// Draws an example blk
/// @param level The level of the heading (optional)
/// @param content The arguments like (body) or (title, body)
#let ex(level: none, ..content) = {
  // Capture content
  content = content.pos().rev()
  assert(
    content.len() > 0,
    message: "Expected (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Ex:")
  // Draw the blk
  blk(
    level: level,
    title: (content: title, color: white, fill: _EX_HDR_FILL,),
    fill: _EX_FILL,
    stroke: _EX_STROKE,
    radius: _EX_RAD,
    body
  )
}

/// Draws a definition blk
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
    message: "Expected (body) or (title, body)"
  )
  let body = content.at(0)
  let title = content.at(1, default: "Def:")
  // Draw the blk
  blk(
    level: level,
    title: (content: title, color: white, fill: _DEF_HDR_FILL,),
    fill: _DEF_FILL,
    stroke: _DEF_STROKE,
    radius: _DEF_RAD,
    body
  )
}

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
