// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvSkill, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)


#cvSection("Skills")

#cvSkill(
  type: [Languages],
  info: [Italian #hBar() English #hBar() French],
)

#cvSkill(
  type: [Other Languages],
  info: [
    - Good experience with *C*, *Java*, *Python*, *Rust*, *SQL*, *Javascript*, *Typescript* and *Typst*
      - Worked a lot with `numpy`, `tensorflow`, `scikit-learn`, `matplotlib`, `numba`, `seaborn`, `scipy`
      - Worked with *Big Data* frameworks, in particular *Apache Spark* and *Hadoop*
      - Worked with *React*
    - Good knowledge of *Gradle*, *Makefile* and *Cargo* build tools, *Git* and *GitHub* workflow
    - Intermediate experience with *C++*, *R*, *Haskell* and *Agda*
    - Some experience with *ARM Assembly*, *InfluxQL*, *SPARQL*, *MQL*, *NoSQL* databases and *LaTeX*
      - Experience with NoSQL time series databases like *InfluxDB* as part of my bahelor thesis
      - Experience with *MongoDB*
  ],
)

#cvSkill(
  type: [Driving License],
  info: [B #hBar() AB],
)
