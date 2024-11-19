#import "@preview/brilliant-cv:2.0.2": cvSection, cvHonor
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvHonor = cvHonor.with(metadata: metadata)


#cvSection("Certificates")

#cvHonor(
  date: [2023],
  title: [IELTS Academic 8.0],
  issuer: [British Council],
)

#cvHonor(
  date: [2024],
  title: [Semaine Intensive de Français B1],
  issuer: [Centre Universitaire d’Etudes Françaises de
    l’Université Grenoble Alpes],
)

#cvHonor(
  date: [2024],
  title: [Winning team in the 120th anniversary of HKN international hackaton],
)
