#import "../utils/common.typ": *

= Tools and Technologies

The following is a general oveview of the tools and technologies used in the project.

#_content(
  [
    == InfluxDB

    #link("https://www.influxdata.com/products/influxdb-overview/")[InfluxDB] is a powerful open-source time-series database that is used to store the data collected by the _data collectors_. It is designed to handle high volume and high frequency time-stamped data. Being a NoSQL database, it is schemaless and it allows for a flexible data model.
    
    It serves as the main data storage for the greenhouse.

    It's organized in _buckets_ that are used to store the _measurements_. Each _measurement_ is composed of:

    - _measurement name_
    - _tag set_
      - Used as keys to index the data
    - _field set_
      - Used to store the actual data
    - _timestamp_

    For example the following query will return the last moisture measurement, given a measurement range of 30 days, from the bucket of name `greenhouse`:

    ```SQL
    from(bucket: "greenhouse")
      |> range(start: -30d)
      |> filter(fn: (r) => r["_measurement"] == "ast:pot")
      |> filter(fn: (r) => r["_field"] == "moisture")
      |> filter(fn: (r) => r["plant_id"] == %1)
      |> keep(columns: ["_value"])
      |> last()
    ```

    Chronograf is included in the InfluxDB 2.0 package, it is the tool that we chose to visualize the data stored in the database and to create dashboards.
    
    // TODO: use a screenshot from the project instead of a generic one
    #figure(
      image("../img/chronograf.png"),
      caption: [
        An example of the visualization tools offered by the Chronograf Dashboard
      ]
    )

    == Developing a library to interface with the sensors

    When working with the Raspberry Pi 4 the obvious choice for a programming language is Python, it is the most widely used language for the Raspberry Pi and it has a lot of support and libraries available.

    The goal was to make it extremely modular to be able to add new sensors and actuators with ease.

    // TODO: add code snippets, continue writing stuff

    == OWL

    #link("https://www.w3.org/TR/owl-ref/")[OWL] is a knowledge representation language that is used to describe the #link(<asset-model>)[`asset model`] of the greenhouse. It is used to create a formal description of the greenhouse's physical structure and the relationships between the different components.
    
    // TODO: check if it is enough of an example, exaplain it in more datail, check if syntax highlighting works as expected, if not open an issue and/or try to open a PR yourself
    The following code example models a class 'Basilicum' and links information about the ideal moisture in the asset model:
    
    ```javascript
###  http://www.semanticweb.org/gianl/ontologies/2023/1/sirius-greenhouse#Basilicum
ast:Basilicum rdf:type owl:Class ;
  rdfs:subClassOf ast:Plant ,
    [ rdf:type owl:Restriction ;
        owl:onProperty ast:hasIdealMoisture ;
          owl:hasValue "70.0"
    ] .
    ```

    == SMOL Language
    
    `SMOL` is an OO programming language in its early developement stages, it allows us to:
    - Interact with the `InfluxDB` and read data from the database, directly without the need of a third party libraries
    - Read and query the knowledge graph, mapping the data to objects in the heap
    - Map the program state to a knowledge graph by means of semantic lifting, the program state can be then queried to extract information about the state of the system
    - Represent and run simulation and interact with `modelica`
    
    It will be treated in more details in its dedicated section.

  ]
)

