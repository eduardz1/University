#import "../utils/common.typ": *

= Overview of the Greenhouse

The specific greenhouse we're working on has the following characteristics:
- It is divided in two shelves
- Each shelf is composed by two groups of plants
- Each group of plants is watered by a single water pump
- Each group of plants is composed by two plants
- Each plant is associated with a pot

#_content(
  [
    == Assets - Sensors
    The following sensors are used to monitor the environmental conditions of the greenhouse and the plants:

    / Greenhouse:
    - 1 webcam used to measure the light level, can be replaced with a light sensor that would also provide an accurate lux measurement
    / Shelves:
    - 1 `DHT22` sensor used to measure the temperature and humidity
    / Pots:
    - 1 capacitive soil moisture sensor used to measure the moisture of the soil
    / Plants:
    - 1 `Raspberry Pi Camera Module v2 NoIR` used to take pictures of the plants and measure their growth by calculating the `NDVI`
  ]
)
