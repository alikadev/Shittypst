/// Author: Elvin Kuci
/// Date: 22 apr 2026
/// Descr:
/// Constants of the template

#let _HDR_COL = white             ///< Default heading color
#let _BLK_BKG = gray.lighten(60%) ///< Default block fill color
#let _BDR_COL = gray.darken(60%)  ///< Default block border color
#let _BDR_RAD = 3pt               ///< Default block border radius

#let _DEF_COL = rgb("#ffe2e2")
#let _DEF_FILL = gradient.radial( _DEF_COL.lighten(20%), _DEF_COL )
#let _DEF_STROKE = rgb("#c00000")
#let _DEF_HDR_FILL = _DEF_STROKE.darken(20%)
#let _DEF_RAD = 5pt

#let _EX_COL = rgb("#e3f5e1")
#let _EX_FILL = gradient.radial( _EX_COL.lighten(50%), _EX_COL )
#let _EX_STROKE = rgb("#008000")
#let _EX_HDR_FILL = rgb("#208020").darken(20%)
#let _EX_RAD = 0pt

#let _THM_COL = rgb("#eddfec")
#let _THM_FILL = gradient.radial( _THM_COL.lighten(50%), _THM_COL )
#let _THM_STROKE = rgb("#802080")
#let _THM_HDR_FILL = white
#let _THM_RAD = 5pt

#let _TODO_COL = color.map.rainbow.map(it => it.lighten(70%))
#let _TODO_FILL = gradient.linear(.._TODO_COL)
#let _TODO_STROKE = black
#let _TODO_RAD = 0pt

#let _CHAP_TXT = 24pt

