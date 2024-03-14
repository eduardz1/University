= EZGas

EZGas is an application to help drivers find gas at lowest prices.

Gas station owners can register their gas station with prices and eventually discounts. Users look for gas stations closest to them and with best prices and 
quality of service

== 0 - Business Model

// Options given by the professors are:
// 1 - crowdsourcing + ads or paid subscription
//     --> anyone can write prices of gas
// 2 - ministry of trasnport paws devlopment and maintains the app
//     --> only gas station owners MUST write prices
// 3 - consumer association pays (AAA, altroconsumo, ...)
//     --> onlyfellows of the association can write prices by paying a fee

The business model is based on advertisments and partnerships with the gas station owners that can pay a fee to make their result appear higher in the search and with a "verified" badge. The app is free to use for the users.

== 1 - Stakeholders

- *User*
  - User searching for the cheapest gas station
  - Gas station owner registering their gas station
- *Administrator*
  - Community moderator
  - Security manager
  - DB administrator
- *Buyer*
  - CEO of the proposed application (developed in house)
- *Others*
  - Google ads
  - Map service
  
== 2 - Context Diagram and Interfaces

#figure(image("imgs/EZGas.png"))

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt,
  [*Actor*], [*Phyisical Interface*], [*Logical Interface*],
  [User, Gas station owner],[GUI],[PC, smartphone],
  [Google ads],[API],[Internet],
  [Map service],[API],[Internet],
  [Community moderator],[GUI],[PC],
  [Security manager],[GUI, CLI],[PC],
  [DB administrator],[GUI, CLI],[PC]
)

== 3 - Functional Requirements
