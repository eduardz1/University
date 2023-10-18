#import "../utils/common.typ": *

= Introduction 
// TODO: find a synonim of project

The following project was realized as an internship project during my Erasmus semester abroad in Oslo, Norway. The project was realized in collaboration with the #link("https://www.uio.no/")[University of Oslo] and the #link("https://sirius-labs.no/")[Sirius Research Center].

The project consists in the creation of a digital twin of a greenhouse and the optimization of the environmental conditions for maximum growth. Using SMOL we can predict when to water the plants and how much water to use.

#_content(
  [
    == Learning Outcome
    - Understanding the concept of digital twins
    - Learning the syntax and semantics of SMOL
    - Learning the basics of the FMI standard
    - Learning basic electronics to connect sensors and actuators to a Raspberry Pi

    By modelling a small scale model of a digital twin we were able to build the basis for the analysis of a larger scale problem. Other than the competences listed above, it was also important being able to work in team by dividing tasks and efficiently managing the codebases of the various subprojects (by setting up build tools and CI pipelines in the best way possible, for example).

    Electronic prototyping was also a big part of the project. We had to learn how to connect sensors and actuators to a Raspberry Pi (which required the use of breadboards, analog-to-digital converters and relays for some of them) and how to translate the signal in a way that could be used as data.

    == Results

    A functioning prototype was built with the potential to be easily scaled both in terms of size and complexity. Adding new shelves with new plants is as easy as adding a new component to the model and connecting the sensors and actuators to the Raspberry Pi. The model is easily exentable to add new components and functionalities such as actuators for the control of the temperature and the humidity or separate pumps dedicated to the dosage of fertilizer. Sensors are also easily added (a PH sensor would prove useful for certain plants) both in terms of the asset model and in terms of code, each sensor/actuator is represented as a class and they are all being read indipendently from each other. 
  ]
)