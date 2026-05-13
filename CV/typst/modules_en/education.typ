// Imports
#import "@preview/brilliant-cv:2.0.2": cvEntry, cvSection, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Education")

#cvEntry(
  title: [Master in Computer Engineering with a specialist track in Artificial Intelligence and Data Analytics #hBar() AVG Grade 29.29  \ Master of Science in Informatics of Grenoble #hBar() graduated],
  society: [Polytechnic University of Turin #hBar() Grenoble INP - Ensimag, UGA],
  date: [2023 - 2026],
  location: [Italy #hBar() France],
  logo: image("../src/logos/polito.svg"),
  description: list(
    [
      / Experience Abroad: _Double Degree Program with Grenoble INP - Ensimag, UGA_.
    ],
    [
      / Thesis: Performance Analysis and CUDA Acceleration of the Open Source Software “HAWEN”

      In this work, we present improvements on the free and open-source software
      HAWEN, used to solve the wave problem in the frequency domain. The software can
      be used to both model the propagation of waves and solve the inverse problem, which
      consists in the reconstruction of the characteristics of the media in which the waves
      propagated. HAWEN relies on a discretization technique known as “Hybridizable
      Discontinuous Galerkin” (HDG) which makes heavy usage of operations on dense
      matrices. In this work, we will focus on improving the performance of the code by
      ensuring that these operations are executed efficiently. We will analyze the current
      state of libraries and compilers for the Fortran language. In particular, we will work
      with NVIDIA’s NVHPC Toolkit and explore effective strategies for parallelization
      on GPUs whilst maintaining the current combination of MPI and OpenMP paral
      lelism. Another part will concern introducing a recently released GPU accelerated
      sparse solver, cuDSS, as alternative to the current one, MUMPS, to address the
      global linear system of HDG.

      PDF: https://github.com/eduardz1/Master-Thesis/releases/download/v1.0/main.pdf
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
    [
      / Thesis: Design and Development of the Digital Twin of a Greenhouse

      In this thesis I talked about the concept of Digital Twin and its applications, about concepts related to the Semantic Web and introduced a novel programming language called *SMOL*, developed by researchers at the University of Oslo to help interfacing with Digital Twins.

      Then I talked about the project that was assigned to me and my colleagues to serve as a
      proof of concept for the language and build the basis for its usage on a larger scale.

      PDF: https://github.com/eduardz1/Bachelor-Thesis/blob/main/main.pdf

      Related paper presented at *SEAMS 2024*: https://conf.researchr.org/details/seams-2024/seams-2024-artifact-track/5/GreenhouseDT-An-Exemplar-for-Digital-Twins
    ],
    [
      / Other Experiences:

        - Helped the professor as lab assistant for the course of *Operating Systems*
        - Helped with the organization and the lectures of a course on *Python* for High School students interested in Computer Science
    ],
  ),
)
