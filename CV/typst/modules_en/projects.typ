// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Projects & Associations")

#cvEntry(
  title: [Member of the Area Tutoring],
  society: [IEEE - HKN Honor Society],
  logo: image("../src/logos/hkn.svg"),
  date: [2023 - Present],
  location: [Turin, Italy],
  description: list(),
)
