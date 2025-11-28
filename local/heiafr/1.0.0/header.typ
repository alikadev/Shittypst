#let frontpage(
  course: "Nom du cours",
  title: "Titre du document",
  semester: "automne",
  years: "2025-26",
  authors: none,
  fill: "#3c0f0c"
) = {
  // Background
  box(
    width: 100%, 
    height: 100%, 
    radius: 2%,
    fill: gradient.linear(
      rgb(fill).darken(0%).desaturate(40%),
      rgb(fill).lighten(20%),
      angle: -60deg,
    ),
    // Content
    box(inset: 10mm, [
      #set text(fill: gray.lighten(80%))
      #text(size: 32pt, weight: "bold", [#course])
      #v(-6mm)
      #text(size: 28pt, style: "italic", [Semestre d'#semester #years])
      #v(20mm)
      #text(size: 25pt, weight: "bold", [#title])
      #v(20mm)
      #for author in authors [
        #h(5mm)
        #text(size: 20pt, weight: "bold", 
        [#author.first_name #author.last_name])
        #v(1mm)
      ]
    ])
  )
  // HEIA-FR common bullshit
  place(right + bottom, image("graph_w2.svg", width: 90%))

  place(left + bottom, dx: 6mm, dy: -6mm, image("logo_heiafr_white.svg", height: 12mm))
  place(right + bottom, dx: -6mm, dy: -6mm, image("HESSO.svg", height: 9mm))
}

