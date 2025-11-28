# Shittypst

## Typst libraries for myself

These are just some typst libraries that I created/edited for my personal use.

Feel free to use/fork them

## Quick start

Clone this library in your `TYPST_PACKAGE_PATH` directory. If it isn't defined
yet, you can add `export TYPST_PACKAGE_PATH=<my/path>` in your `.*shrc`.

After that, everything should be set up. Your `TYPST_PACKAGE_PATH` should look
like this:

```
.
└── local
    ├── heiafr
    │   └── 1.0.0
    │       └── ...
    └── math
        ├── 0.1.0
        │   └── ...
        └── ...
```

Once this has been set up, you can use `import` it in your `.typ` documents

Example:

```typ
#import "@local/math:0.1.0":*

#set heading(numbering: "1.1.1.")
#set page(
  paper: "a4",
  margin: (x: 1cm, y: 1cm),
)
// ...

#chapter("Mathématiques numériques")
= Méthodes de recherches de zeros de fct. non linéaires
== 1 et plusieurs variables
#ex(title:[$f(x) = 3x + sin(x) - e^x$])[
  //...
]
```

## Content

### Local math

The `local/math/` is a template based on a _LaTeX_ template that I used.
I tried recreating it in _Typst_ and modified it for my own tastes. I don't
remember the author's name, but the library is **REALLY** different now and no
code has been copied. I could try to find the author back if needed.

At the end of the file, you have a `/// ===== TESTING ===== ///` section that I
use to test the library while developing it. You can read it to understand how
to use the library or changing the `#if false` to `#if true` to enable
test document generation

### Local heiafr

The `local/heiafr/` is a slight modification of the common _HEIA-FR_ template
that a teacher gave us. You probably won't needing it.

