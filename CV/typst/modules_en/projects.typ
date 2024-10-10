// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)

// #pagebreak()

#cvSection("Projects & Associations")

#cvEntry(
  title: [Member of the Area Tutoring],
  society: [IEEE - HKN Honor Society],
  logo: image("../src/logos/hkn.svg"),
  date: [2023 - Present],
  location: [Turin, Italy],
  description: "Member of the association at the Polytechnic University of Turin",
)

#cvEntry(
  title: [Special project for the course of "Computer Architecture" at the Polytechnic University of Turin],
  society: "TensorFlow Lite - based TinyML implementation in X-HEEP",
  date: "2024",
  location: "TensorFlow, TinyML, C, Python, RISC-V, X-HEEP, YOLO",
  description: [
    - https://github.com/eduardz1/University/blob/main/PoliTO/ASE/special_project/presentation/sp.pdf

    The project consists in studying the various TinyML techniques and optimizations useful to run inference on a pre-trained model on an embedded device. In particular I chose an object recognition model similar to YOLO
  ],
)

#cvEntry(
  title: [Project for the "System and Device Programming" course at the Polytechnic University of Turin],
  society: [SFIAR - Sistema di Fault Injection per Applicazioni Ridondate],
  date: [2024],
  location: "Rust, Procedural Macros, Fault Injection, Redundant Systems",
  description: [
    // TODO: fix link
    - https://github.com/ProgrammazioneDiSistema2024-IA-ZZ/Group-21

    The project consists in the implementation of a fault injection system for redundant systems in Rust.
    - Redundancy was implemented through variable duplicaiton in an automatic way through the use of Attribute-like procedural macros,
    - Injection of faults is done with a parallel thread and is also implemented as a procedural macro so that the user can inject the triplet (identifier, time, bit_to_flip) easily.
    - An analyzer library was written to benchmark the code
  ],
)

#cvEntry(
  title: [Project for the course in "Machine Learning and Pattern Recognition" at the Polytechnic University of Turin],
  society: "Fingerprint Spoofing Detection",
  date: [2024],
  location: "Python, Matplotlib, Scikit-learn, scipy, numpy, numba",
  description: [
    // TODO: fix link
    - https://github.com/eduardz1/MLPR-Project

    The project consists in the study and implementation of different classifiers in the detection of false fingerprints given a dataset of labelled data.
    - The project puts a lot of emphasis on the preprocessing of the data, with techniques such as PCA and LDA.
    - Classifiers used are
      - The binary gaussian classifier
      - The Gaussian Mixture Model classifier
      - The Logistic Regression classifier
      - The Support Vector Machine classifier
    - The project puts a lot of emphasis on the data visualization and the comparison of the different classifiers.
  ],
)

#cvEntry(
  title: [Web Application project at the Polytechnic University of Turin],
  society: "Meme Game",
  date: [2024],
  location: "Javascript, React, Node.js, Express, SQLite",
  description: [
    - https://github.com/eduardz1/Meme-Game
    The projetc consists in implementing a videogame inspired by the board game "What do You Meme?".
    - The game is developed as a single page application using React.
    - The application interacts with an HTTP API implemented in Node + Express.
    - The database is stored in a SQLite file.
    - The communication follows the "two servers" pattern, by properly configuring CORS
    - User authentication is implemented with Passport.js and session cookies
  ],
)

#cvEntry(
  society: "Quoridor LandTiger",
  title: [Project for the "Computer Architecture" course at the Polytechnic University of Turin],
  location: "C, ARM Assembly, Embedded Systems, LandTiger, Keil",
  date: "2024",
  description: [
    - https://github.com/eduardz1/quoridor-landtiger
    The project consists in a C implementation of the strategy game "Quoridor" with a simple AI.
    - The game is made to run on the LandTiger board
    - The repository is structured as a Keil `.uvprojx` project
  ],
)

#cvEntry(
  title: [Project for the "Software Engineering" course at the Polytechnic University of Turin],
  society: "EZElectronics",
  date: "2024",
  location: "Typescript, React, Node.js, Express, SQLite, Docker, Git, Gitlab CI/CD, Testing",
  description: [
    - https://git-softeng.polito.it/se-2023-24/group-eng-24/ezelectronics

    Software engineering that consists in all the backend phase of software engineering, from the requirements to the implementation and testing (both unit and integration).
  ],
)

#cvEntry(
  title: [Bachelor Thesis],
  society: "Design and Development of the Digital Twin of a Greenhouse",
  location: "SMOL, Semantic Web, Digital Twin, Python, SPARQL, RDF, Ontologies, InfluxDB",
  date: [2023],
  description: [
    - https://github.com/smolang/SemanticObjects
    - https://github.com/eduardz1/greenhouse-data-collector
    - https://github.com/eduardz1/smol_scheduler
    - https://github.com/eduardz1/greenhouse_twin_project
  ],
)

#cvEntry(
  title: [Project for the "Programming 3" course at the University of Turin],
  society: "JMail",
  date: "2023",
  location: "Java, Gradle, JavaFXML, MVC, JVM, Design Patterns",
  description: [
    - https://github.com/eduardz1/Jmail

    The project consists in realizing a simple email client in Java with a graphical interface using JavaFXML. The project is structured following the MVC pattern and uses Gradle as a build tool.
    - The project uses correctly the Observer/Observable pattern.
    - The server handles multiple clients at the same time and errors should be logged.
    - Client and server parallelize each activity that does not require sequential execution.
    - The application is distributed through the use of Java Sockets.
  ],
)

#cvEntry(
  title: [Software Engineering project at the University of Turin],
  society: "Cat & Ring",
  date: "2022",
  location: "Java, Gradle, Design Patterns, Software Engineering, DSD, UC, UML",
  description: [
    - https://github.com/eduardz1/Cat_e_Ring

    Project that focused on the software engineering part more than the implementation. We had to concetualize in detail the gloassary, design sequence diagrams and use case diagrams, starting from the requirements and description of the use case.
  ],
)

#cvEntry(
  title: [Database project at the University of Turin],
  society: "Home Booking",
  date: "2022",
  location: "SQL, ER Diagrams, Database Design",
  description: [
    -https://github.com/eduardz1/Home-Booking
  ],
)

#cvEntry(
  title: [Project for the Algorithms and Data Structures course at the University of Turin],
  society: "Laboratorio Algoritmi",
  date: "2022",
  location: "C, Git, Java, Gradle, Makefile, Design Patterns, Algorithms, Data Structures",
  description: [
    -https://github.com/eduardz1/Laboratorio-Algoritmi

    The project consists in the implementation of the following algorithms and data structures:
    - QuickSort & InsertSort
    - SkipList
    - MinHeap
    - Dijkstra's Shortest Path Algorithm
  ],
)

#cvEntry(
  title: [Project for the "Operating Systems" course at the University of Turin],
  society: "Simulazione Transazioni",
  date: [2022],
  location: "C, Linux",
  description: [
    - https://github.com/eduardz1/Simulazione-Transazioni

    The project consists in the implementation of a simil-blockchain system, the main process creates a number of user processes and node processes, the user send each other transactions and the nodes verify them and add them to the ledger. The ledger can be viewed as a text file that is generated at the end of the simulation. The project heavily makes use of shared memory in C.],
)

