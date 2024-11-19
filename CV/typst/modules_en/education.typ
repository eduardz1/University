// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvEntry, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Education")

#cvEntry(
  title: [Master in Computer Engineering with a specialist track in Artificial Intelligence and Data Analytics #hBar() AVG Grade 29.4  \ Master of Science in Informatics of Grenoble],
  society: [Polytechnic University of Turin #hBar() Grenoble INP - Ensimag, UGA],
  date: [2023 - TBD],
  location: [Italy #hBar() France],
  logo: image("../src/logos/polito.svg"),
  description: list(
    [
      / Experience Abroad: _Double Degree Program with Grenoble INP - Ensimag, UGA_.
    ],

    [
      / Other Experiences:

        - Participated in a Special project for the Computer Architecture course, the project consisted in studying the various *TinyML* techniques used to optimize *TensorFlow* models with the objective to run inference on a pre-trained model running on an *embedded device* (RISC-V, X-HEEP platform).
        - Currently working on a *Fault Injection System for Redundant Systems* written in *Rust* with the System and Device Programming professor.
    ],
  ),
)


#cvEntry(
  title: [Bachelors of Science in Computer Science #hBar() 110 cum laude],
  society: [University of Turin],
  date: [2020 - 2023],
  location: [Italy],
  logo: image("../src/logos/unito.svg"),
  description: list(
    [
      / Experience Abroad: _Erasmus exchange at the University of Oslo, Norway_. Here I followed an introductory course to the field of Artificial Intelligence and Machine Learning and did my internship at the informatics research lab, in the Formal Methods group.
    ],
    [ / Thesis: Design and Development of the Digital Twin of a Greenhouse

      In this thesis I talked about the concept of Digital Twin and its applications, about concepts related to the Semantic Web and introduced a novel programming language called *SMOL*, developed by researchers at the University of Oslo to help interfacing with Digital Twins.

      Then I talked about the project that was assigned to me and my colleagues to serve as a
      proof of concept for the language and build the basis for its usage on a larger scale.

      PDF: https://github.com/eduardz1/Bachelor-Thesis/blob/main/main.pdf

      Related paper presented at *SEAMS 2024*: https://conf.researchr.org/details/seams-2024/seams-2024-artifact-track/5/GreenhouseDT-An-Exemplar-for-Digital-Twins
    ],
    [/ Other Experiences:

        - Helped the professor as lab assistant for the course of *Operating Systems*
        - Helped with the organization and the lectures of a course on *Python* for High School students interested in Computer Science
    ],
  ),
)
