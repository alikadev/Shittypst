# Changes historic

## 0.3.0 (indev)

- Removed `crop` - not working well enouth
- Removed `sesac` - useless, use `cases(reversed: #true)` instead
- Moved private `_` to `tools.typ`
- Moved constants to `const.typ`
- Renamed `block` -> `blk` - conflict with stdlib
- Refractored args `#blk(title*)` into a dict
- Changed chapters default `resetHeading: false`
- More constants for colors
- Cleaned errors
- Reset `chapter` heading before itself
- Changed `resetHeadingTo(value)` -> `resetHeading()`

### To think about

- Change heading level system
- Extract some repeated code
- Move all "root" block into implementation for clean index
- Add `#code` block
- Integrate with _bob_

## Previously

### Common
- `chapter(breaking: true, resetHeading: true, name)`
- `block(
  title:       none,    ///< The title's text (none = remove)
  level:       none,    ///< The title's level
  titleColor:  _HDR_COL, ///< The title's color
  titleFill:   none, ///< The title's background color (default = stroke)
  titleRadius: _BDR_RAD, ///< The title's border radius
  fill:        _BLK_BKG, ///< The block's background color
  stroke:      _BDR_COL, ///< The block's border's color
  radius:      _BDR_RAD, ///< The block's border's radius
  content               ///< The content
)`
- `TODO(level: none, ..content)`
- `nt(level: none, ..content)`
- `thm(level: none, ..content)`
- `ex(level: none, ..content)`
- `def(level: none, ..content)`

### State management
- `setHeadingLevel(level)`
- `resetHeadingTo(value)`

### Utils
- `sesac(..arr, spacing: 6pt)`
- `crop(img, top:0cm, bottom:0cm, left:0cm, right:0cm)`

### Symbols
#let int = symbol(sym.integral)
#let arr = symbol(sym.arrow)
#let part = symbol(sym.partial)
#let inf = symbol(sym.infinity)
#let pm = symbol(sym.plus.minus)
#let mp = symbol(sym.minus.plus)
#let grad = symbol(sym.gradient)
#let eps = symbol(sym.epsilon)
#let bigg(expr, size: 100%) = $lr(#expr|, size: #size)$


