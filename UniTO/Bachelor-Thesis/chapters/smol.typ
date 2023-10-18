#import "../utils/common.typ": *

= SMOL <smol-heading>

SMOL (Semantic Micro Object Language) is an imperative, object-oriented language with integrated semantic state access. It can be used served as a framework for creating digital twins. The interpreter can be used to examine the state of the system with SPARQL, SHACL and OWL queries. 

#_content(
  [
    == Co-Simulation <co-simulation>
    SMOL uses _Functional Mock-Up Objects_ (FMOs) as a programming layer to encapsulate simulators compliant with the #link("https://fmi-standard.org")[FMI standard] into object oriented structures @smol

    The project is in its early stages of developement, during our internship one of our objectives was to demonstrate the capabilities of the language and help with its developement by being the first users.
  ]
)