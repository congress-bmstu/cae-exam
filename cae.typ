#import "notes.typ": notes

#show: notes.with(author: "Конгресс", title: "cae-exam")

// #show math.ZZ: it => text(fill: gradient.linear(dir: ttb, orange, black).sharp(2).repeat(20), size: 40pt)[$it$]

// #show "z": it => text(fill: gradient.linear(dir: ttb, orange, black).sharp(2).repeat(40), size: 40pt)[$it$]

#align(
  horizon + center,
  {
    set page(numbering: none)
    align(right, text(size: 26pt)[Каримов Суннат Бахтиярович #emoji.man])
    v(5fr)
    text(size: 26pt, weight: "bold")[Экзамен]
    v(1fr)
    text(size: 26pt, weight: "bold")[Программные технололгии разработки систем инженерного анализа\ ]
    text(size: 60pt)[#emoji.computer]
    v(8fr)
    align(center)[_Зимняя сессия 2025 - 2026_]
  },
)
#pagebreak()
#outline()
#pagebreak()

= Теория
#include "teor1.typ"
#include "teor2.typ"
#include "teor3.typ"
#include "teor4.typ"
#include "teor5.typ"
#include "teor6.typ"
#include "teor7.typ"
#include "teor8.typ"
#include "teor9.typ"
#include "teor10.typ"
#include "teor11.typ"
#include "teor12.typ"
#include "teor13.typ"
#include "teor14.typ"
#include "teor15.typ"
#include "teor16.typ"
#include "teor17.typ"
#include "teor18.typ"
#include "teor19.typ"
#include "teor20.typ"
#include "teor21.typ"
#include "teor22.typ"

#pagebreak()
= Практика
#include "prac1.typ"
#include "prac2.typ"
#include "prac3.typ"
#include "prac4.typ"
#include "prac5.typ"
#include "prac6.typ"
#include "prac7.typ"
#include "prac8.typ"
#include "prac9.typ"
#include "prac10.typ"
#include "prac11.typ"
#include "prac12.typ"
#include "prac13.typ"
#include "prac14.typ"
#include "prac15.typ"
#include "prac16.typ"
#include "prac17.typ"
#include "prac18.typ"
#include "prac19.typ"
#include "prac20.typ"
#include "prac21.typ"

