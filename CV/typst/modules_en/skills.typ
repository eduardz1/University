// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvSkill, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)


#cvSection("Skills")

#cvSkill(
  type: [Languages],
  info: [Italian #hBar() English #hBar() Russian],
)

#cvSkill(
  type: [Other Languages],
  info: [
    - Good experience with *C*, *Java*, *Python*, *Rust*, *SQL*, *Javascript*, *Typst*
      - Worked a lot with `numpy`, `tensorflow`, `scikit-learn`, `matplotlib`
    - Good knowledge of *Gradle*, *Makefile* and *Cargo* build tools
    - Intermediate experience with *C++*, *R*, *Haskell* and *Agda*
    - Have worked with *ARM Assembly*, *InfluxQL*, *SPARQL*, *MQL* and *LaTeX*
      - Experience with time series databases like *InfluxDB* as part of my bahelor thesis

  ],
)

#cvSkill(
  type: [Driving License],
  info: [B #hBar() AB],
)
