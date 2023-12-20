= Homework 3

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

$pi_("BId", "SUM"("Cost") -> "TotCost", "SUM"("NumHours") -> "TotHours")(
  sigma_("SUM"("Cost") >= 1000)(
    gamma_("CS.BId")(
      (
        sigma_("Date" >= "1/1/2022" and "Date" <= "21/12/2022")(\
          "CLEANING-SERVICES"
        )
          join_("BId")
        sigma_("City" = "'Turin'")(
          sigma_("BuildingType" = "'Office'")(
            "BUILDING"
          )
        )
      )
        join.r_("SId")
      (\
        sigma_("COUNT(*)" >= 1)(
          gamma_("OS.SId")(
            sigma_("Region" = "'Piedmont'" or "Region" = "Liguria")(
              "CLEANING-COMPANY"
            )
              join_("CId")\
            (
              sigma_("Category" = "'IndoorCleaning'")(
                "SERVICES"
              )
                join_("SId")
              "OFFERED-SERVICE"
            )
          )
        )
      )
    )
  )
)
$

== GROUP BY Anticipation

None of the `GROUP BY` operations can be anticipated

=== Inner QUERY

Cannot be anticipated

=== Outer QUERY

== Execution Plan

== Join Orders

