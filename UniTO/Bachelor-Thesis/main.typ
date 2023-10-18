#import "utils/template.typ": *

#let dichiarazione_di_originalità = "Dichiaro di essere responsabile del contenuto dell’elaborato che presento al fine del conseguimento del titolo, di non avere plagiato in tutto o in parte il lavoro prodotto da altri e di aver citato le fonti originali in modo congruente alle normative vigenti in materia di plagio e di diritto d’autore. Sono inoltre consapevole che nel caso la mia dichiarazione risultasse mendace, potrei incorrere nelle sanzioni previste dalla legge e la mia ammissione alla prova finale potrebbe essere negata."

#let aknowlegements = "Special thanks to Chinmayi Bp for always being available to help us figure out the electronics and Gianluca Barmina and Marco Amato with whom I worked together on the project"

#show: project.with(
  title: "Design and Development of the Digital Twin of a Greenhouse",
  abstract: "We will see how digital twins can be used and applied in a range of scenarios, we'll introduce the language 'SMOL', created specifically for this purpose, and talk about the work of me and my collegues in the process of designing and implementing a digital twin of a greenhouse.",
  aknowlegements: aknowlegements,
  declaration-of-originality: dichiarazione_di_originalità,
  affiliation: (
    university: "Università degli Studi di Torino",
    department: "DIPARTIMENTO DI INFORMATICA",
    degree: "Corso di Laurea Triennale in Informatica"
  ),
  authors: (
    (role: "candidate", name: "Eduard Antonovic Occhipinti", id: "947847"),
    (role: "supervisor", name: "Prof. Ferruccio Damiani", id: ""),
    (role: "co-supervisors", name: "Prof. Einar Broch Johnsen\n\nRudolf Schlatte\n\nEduard Kamburjan", id: "")
  ),
  date: "Academic Year 2022/2023",
  logo: "../img/logo.svg",
  bibliography-file: "../works.yml"
)

#show link: underline

// TODO: check every link to avoid them pointing to one of our personal repositories

#include "chapters/introduction.typ"

#include "chapters/tools-and-technologies.typ"

#include "chapters/digital-twins.typ"

#include "chapters/overview-of-the-greenhouse.typ"

#include "chapters/raspberries-responsabilities-and-physical-setup.typ"

#include "chapters/smol.typ"

#include "chapters/semantic-lifting.typ"

#include "chapters/software-components.typ"

#include "chapters/conclusions.typ"
