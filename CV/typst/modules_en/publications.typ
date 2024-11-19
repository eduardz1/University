// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvPublication
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)


#cvSection("Publications")

#cvPublication(
  bib: bibliography("../src/publications.bib"),
  refStyle: "apa",
)
