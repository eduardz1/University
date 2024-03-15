= Robot Vacuum Cleaner

Since several years robotic vacuum cleaners (RVC) are available. An RVC is capable of cleaning the floors of a house in autonomous mode. 

An #underline[RVC system] is composed of the robot itself and a charging station. The charging station is connected to an electric socket in the house, and allows charging 
the battery on board of the robot.

The robot itself is composed of mechanical and electric parts, a computer, and sensors. One infrared sensor in the frontal part recognizes obstacles, another 
infrared sensor always on the frontal part recognizes gaps (like a downhill staircase). A sensor on the battery reads the charge of the battery. The computer 
collects data from the sensors and controls the movement of four wheels. Another sensor on one of the wheels computes direction and distance traveled by 
the robot.

Finally on top of the robot there are three switches: on-off, start, learn. 

The learn button starts a procedure that allows the robot to map the space in the house. With a certain algorithm the robot moves in all directions, until it finds 
obstacles or gaps, and builds an internal map of this space. By definition the robot cannot move beyond obstacles, like walls or closed doors, and beyond gaps 
taller than 1cm. 

The starting point of the learn procedure must be the charging station. When the map is built the robot returns to the charging station and stops. 

The start button starts a cleaning procedure. The robot, starting from the charging station, covers and cleans all the space in the house, as mapped in the ‘learn’ 
procedure.

In all cases when the charge of the battery is below a certain threshold, the robot returns to the charging station. When recharged, the robot completes the 
mission, then returns to the charging station and stops

== Business Model

== Stakeholders

== Context Diagram and Interfaces

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt,
  [*Actor*], [*Phyisical Interface*], [*Logical Interface*],
  [User],[],[],
  [Power Supply],[],[]
)

== Requirements

=== System

- Clean up a space autonomously
  - move covering the whole space
  - clean
  - avoid obstacles
  - recognize and avoid humans and pets

=== Non Functional

- Flat space
- Min 80 sqm to be cleaned
- No harm to humans and pets
- Cost < 300 €
- recharge in < 2 hours

= Robot

== Robot Design

- Infrared sensor for obstacles
- Infrared sensor for gaps
- Battery
- Sensor on the battery
- 4 wheels
- Electrical engine on 2 wheels
- Vacuum pump
- Switch to set pump on/off
- Computer and firmware

== Computer and firmware

// Context diagram with actors: ir sensor 1, ir sensor 2, battery sensor, actuator engine wheel 1, actuator engine wheel 2, actuator switch pump

== Functional Requirements
\

#box(
  height: 70pt,
  columns(2)[
    === Robot FR

    - Clean
    - Move covering the whole space
    - Avoid obstacles
    - Recognize and avoid humans and pets


    === Software FR

    - Set pump on/off
    - Manage energy
  ]
)



