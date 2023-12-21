#set text(font: "New Computer Modern", size: 11pt, lang: "en")
#show math.equation: set block(spacing: 0.65em)
#show math.equation.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)
#show math.equation.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show raw.where(block: true): set text(size: 0.8em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show heading.where(
  level: 1
): it => block(width: 100%, height: 8%)[
  #set align(center)
  #set text(1.2em, weight: "bold")
  #smallcaps(it.body)
]
#show heading.where(
level: 2
): it => block(width: 100%)[
  #set align(center)
  #set text(1.1em, weight: "bold")
  #smallcaps(it.body)
]
#show heading.where(
level: 3
): it => block(width: 100%)[
  #set align(left)
  #set text(1em, weight: "bold")
  #smallcaps(it.body)
]

= Homework 3

Where not specified we assume a uniform distribution.

== SQL Query in Relational Algebra

// $pi_("BId", "SUM"("Cost") -> "TotCost", "SUM"("NumHours") -> "TotHours")($
// #pad(left: 1em, $sigma_("SUM"("Cost") >= 1000)($)
// #pad(left: 2em, $gamma_("CS.BId")($)
// #pad(left: 3em, $      ($)
// #pad(left: 4em, $        sigma_("Date" >= "1/1/2022" and "Date" <= "21/12/2022")($)
// #pad(left: 5em, $          "CLEANING-SERVICES"$)
// #pad(left: 4em, $        )$)
// #pad(left: 5em, $          join_("BId")$)
// #pad(left: 4em, $        sigma_("City" = "'Turin'")($)
// #pad(left: 5em, $          sigma_("BuildingType" = "'Office'")($)
// #pad(left: 6em, $            "BUILDING"$)
// #pad(left: 5em, $          )$)
// #pad(left: 4em, $        )$)
// #pad(left: 3em, $      )$)
// #pad(left: 2em, $        join.r_("SId")$)
// #pad(left: 3em, $      ($)
// #pad(left: 2em, $        sigma_("COUNT(*)" >= 1)($)
// #pad(left: 3em, $          gamma_("OS.SId")($)
// #pad(left: 4em, $            sigma_("Region" = "'Piedmont'" or "Region" = "Liguria")($)
// #pad(left: 5em, $              "CLEANING-COMPANY"$)
// #pad(left: 4em, $            )$)
// #pad(left: 5em, $              join_("CId")$)
// #pad(left: 4em, $            ($)
// #pad(left: 5em, $              sigma_("Category" = "'IndoorCleaning'")($)
// #pad(left: 6em, $                "SERVICES"$)
// #pad(left: 5em, $              )$)
// #pad(left: 6em, $                join_("SId")$)
// #pad(left: 5em, $              "OFFERED-SERVICE"$)
// #pad(left: 4em, $            )$)
// #pad(left: 3em, $          )$)
// #pad(left: 2em, $        )$)
// #pad(left: 1em, $      )$)
// #pad(left: 1em, $    )$)
// #pad(left: 1em, $  )$)
// #pad(left: 1em, $)$)

$
pi_("BId", "SUM"("Cost") -> "TotCost", "SUM"("NumHours") -> "TotHours")(
  sigma_("SUM"("Cost") >= 1000)(
    gamma_("CS.BId")(
      (\
        sigma_("Date" >= "1/1/2022" and "Date" <= "21/12/2022")(
          rho_("CS")("CLEANING-SERVICES")
        )
          join_("BId")\
        sigma_("City" = "'Turin'")(
          sigma_("BuildingType" != "'Office'")(
            rho_(B)("BUILDING")
          )
        )
      )
        join.r_("SId")
      (
        sigma_("COUNT(*)" >= 1)(
          gamma_("OS.SId")(\
            sigma_("Region" = "'Piedmont'" or "Region" = "Liguria")(
              rho_("CC")("CLEANING-COMPANY")
            )
              join_("CId")\
            (
              sigma_("Category" = "'IndoorCleaning'")(
                rho_(S)("SERVICES")
              )
                join_("SId")
              rho_("OS")("OFFERED-SERVICE")
            )
          )
        )
      )
    )
  )
)
$

#image("tree.jpeg")


== Join Orders

We can switch around the order of the two inner `JOIN` operation, however, given that they have the same *Reduction Factor*, this change would not affect overall perfomance. However changing the `JOIN` order from

$"CLEANING-COMPANY" join ("SERVICES" join "OFFERED-SERVICE")$

to

$("CLEANING-COMPANY" join "OFFFERED-SERVICE") join "SERVICES"$

enables us to anticipate the `GROUP BY`.

== `GROUP BY` Anticipation

None of the `GROUP BY` operations can be anticipated

=== Inner QUERY

Cannot be anticipated in the current configuration because the `OS.SId` attribute is not present in the `SERVICE` subtree and `CC.CId` is needed in the other subtree and would be discarded otherwise. However, changing the `JOIN` order enables us to ancipate it in the $"CLEANING-COMPANY" join "OFFFERED-SERVICE"$ subtree and reduce the cardinality of the intermediate result.

=== Outer QUERY

Anticipating this `GROUP BY` would result in the loss of information on attributes invlved in the `JOIN`.

== Increasing QUERY Perfomance

To increase QUERY perfomance we can use some indeces, the only attribute with a significant `Reduction Factor` is `BUILDING.City` so a _SECONDARY Hash index_ would prove useful here. A _SECONDARY B+Tree index_ on `CLEANING-SERVICE.Date` can be constructed for filtering thanks to the high caridinality of the table.

