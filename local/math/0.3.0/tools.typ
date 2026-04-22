/// Author: Elvin Kuci
/// Date: 22 apr 2026
/// Descr:
/// Tools for the main typst document

#import "./const.typ":*

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
         if lvl == 0 {text(weight:"semibold", size:8pt, title)}
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

