#import "../utils/common.typ": *

= Raspberry Responsabilities and Physical Setup

In our greenhouse we use a total of 4 Raspberry Pi 4 but in theory only one is strictly necessary.
The responsibility that each pc has is as follows:

- a #link(<controller-setup>)[_Controller_]
- an #link(<actuator-setup>)[_Actuator_]
- a #link(<router-setup>)[Router]
- a #link(<host-setup>)[Host]

We will refer to the _Controller_ also as _Data Collector_ because its responsability is to collect data using sensors attached to the board and send the measurements to the time series database.

In case one wants to repllicate our setup, one can use whichever computer they want as the host, these pharagraphs will assume the host computer runs a Debian based linux distribution but any OS should work with minimal changes.

The _Controller_ and _Actuator_ can be run on the same raspberry with minimal changes.

A more in depth guide to exactly replicate our setup was published #link("https://www.github.com/N-essuno/greenhouse_twin_project/physical-setup")[here] 

// / The Server: The host runs an `InfluxDB` instance that holds the data retried from the clients (_data collectors_) and a `Java` program that periodically runs the #link(<smol-twinning-program>)[`SMOL Twinning program`] which is responsible for creating the digital twin and running the FMI simulators.

// / The Router: The Raspberry was configured with `hostapd` and `dnsmasq` to act as a router and provide a wireless network for the clients to connect to. The local network is used to access the client via `SSH` and to send data to the server via `HTTP` requests.

#_content(
  [
    == OS Choice

    We used the, at the time, latest distribution of `Raspberry Pi OS 64bit`. Any compatible operating system will work in practice, but it's necessary to use a 64 bit distribution at least for the host computer. It is also recommended to have a desktop environment on the host computer for a simpler data analysis.

    We used and recommend using the #link("https://www.raspberrypi.com/software")[Raspberry Pi Imager] to mount the OS image on the micro-sd card.

    == Host Setup <host-setup>

    The only thing that is necessary to install and configure on the host computer is an instance of InfluxDB. One also needs to clone the repository containing the #link("https://www.github.com/N-essuno/smol-scheduler")[SMOL scheduler].

    == Router Setup <router-setup>

    We used a separate Raspberry Pi 4 as a router but that's not striclty necessary, one could simply use an off-the-shelf router for this purpose or give to the host also the responsability of being the wireless access point. For our purpose we used `hostapd` and `dnsmasq` but it can also be done via GUI on Raspberry Pi OS very easily, nonetheless in the guide aforementioned we provide a step by step tutorial.

    == Controller Setup <controller-setup>

    The datapoints from the sensors that it needs to manage are the following:

    - #link(<dht22>)[Temperature]
    - #link(<dht22>)[Humidity]
    - #link(<moisture>)[Moisture]
    - #link(<light-level>)[Light Level]
    - #link(<ndvi>)[NDVI]

    For the temperature and moisture we used a `DHT22` sensor, being very common results in a very good software support.

    === DHT22 <dht22>

    The following schematics mirror what we did the connect the sensor to the board

    #image("../img/dht22-schematics.jpeg")

    We used the #link("https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py")[circuitpython] libraries, which provide a more modern implementation compared to the standard adafruit libraries.

    The following is a minimal script that illustrates how we read the data from the sensor.

    ```python
import time
import board
import adafruit_dht

# Initialize the dht device
# Pass the GPIO pin it's connected to as arugument
dhtDevice = adafruit_dht.DHT22(board.D4)

try:
  temperature_c = dhtDevice.temperature
  humidity = dhtDevice.humidity

  # Print the values to the console
  print(
    "Temp: {:.1f} C    Humidity: {}% ".format(
      temperature_c, humidity
    )
  )

except RuntimeError as error:
  # Errors happen fairly often
  # DHT's are hard to read
  print(error.args[0])
except Exception as error:
  dhtDevice.exit()
  raise error

dhtDevice.exit()
    ```

    === Moisture <moisture>

    We used a generic moisture capacitive soil moisture sensor, to convert the analogue signal we need to use an analog-to-digital converter. For our purpose we used the `MCP3008` ADC which features eight channels, thus making it possible to exend our setup with a decent number of other sensors (for example a PH-meter or a LUX-meter). The following schematics illustrate how we connected the ADC to the board and the moisture sensor to the adc.

    #image("../img/mcp3008-moisture-schematics.jpeg")

    We used `SpiDev` as the library to communicate with the ADC, the following class aids in the readout of the connected sensor:

    // TODO: understand all the bitwise fuckery

    ```python
from spidev import SpiDev


class MCP3008:
  """
  Uses the SPI protocol to communicate
  with the Raspberry Pi.
  """

  def __init__(self, bus=0, device=0) -> None:
    self.bus, self.device = bus, device
    self.spi = SpiDev()
    self.open()

    # The default value of 125MHz is not sustainable
    # on a Raspberry Pi
    self.spi.max_speed_hz = 1000000  # 1MHz

  def open(self):
    self.spi.open(self.bus, self.device)
    self.spi.max_speed_hz = 1000000  # 1MHz

  def read(self, channel=0) -> float:
    adc = self.spi.xfer2([
      1, # speed in hertz
      (8 + channel) << 4, # delay in micro seconds
      0 # bits per word
    ])

    data = ((adc[1] & 3) << 8) + adc[2]
    return data / 1023.0 * 3.3

  def close(self):
    self.spi.close()

    ```

    A minimal example of how one would go about reading from an ADC is the following:

    ```python
from MCP3008 import MCP3008

adc = MCP3008()
value = adc.read(channel = 0)
print("Applied voltage: %.2f" % value)
    ```

    === Light Level <light-level>

    The unavailability of a LUX-meter meant we had to get creative and use a webcam to approximate the light level readings. This means that the data is only meaningful when compared to the first measurement. We used the library opencv to interface with the USB webcam beacuse it is better supported compared to picamera2.

    An minimal example of the scripts we used is the following:

    ```python
import cv2

from time import sleep

cap = cv2.VideoCapture(0)

sleep(2) #lets webcam adjust its exposure

# Turn off automatic exposure compensation, 
# this means that the measurements are only
# significant when compared to the first one, 
# to get proper lux reading one should use a
# proper light sensor
cap.set(cv2.CAP_PROP_AUTO_EXPOSURE, 0)

while True:
    ret, frame = cap.read()
    grey = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    avg_light_level = cv2.mean(grey)[0]
    print(avg_light_level)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    sleep(1)

cap.release()
cv2.destroyAllWindows()
    ```

    === NDVI <ndvi>

    #_block(
      [
        #underline("What is it?")

        Landsat Normalized Difference Vegetation Index (NDVI) is used to quantify vegetation greenness and is useful in understanding vegetation density and assessing changes in plant health.
        NDVI is calculated as a ratio between the red (R) and near infrared (NIR) values in traditional fashion: @ndvidef

        $ ("NIR" - "R") / ("NIR" + "R") $
      ]
    )

    To better understand how healthy our plants were we decided to use an infrared camera to quantify the NDVI. In our small scale application the data were not too helpful because of the color noise surrounding the plants but it will work very well if used on a camera mounted on top of the plants and focussed in an area large enough that the image is filled with only vegetation.

    Connecting the camera is very straight forward given that we used the `Raspberry Pi NoIR` module.

    The following is an extract of the class we use to calculate the index:

    ```python
import cv2
import numpy as np
from picamera2 import Picamera2


class NDVI:
  def __init__(
    self, format: str = "RGB888"
  ) -> None:
    """Initializes the camera, a config can be passed 
       as a dictionary

    Args:
      config (str, optional): refer to 
      https://datasheets.raspberrypi.com/camera/picamera2-manual.pdf
      for all possible values, the default is RGB888
      which is mapped to an array of pixels [B,G,R].
      Defaults to "RGB888".

      transform (libcamera.Transform, optional): 
      useful to flip the camera if needed.
      Defaults to Transform(vflip=True).
    """

    self.camera = Picamera2()
    self.camera.still_configuration.main.format = (
      format
    )
    self.camera.configure("still")
    self.camera.start()

  def contrast_stretch(self, image):
    """Increases contrast of image to facilitate 
       NDVI calculation
    """

    # Find the top 5% and bottom 5% of pixel values
    in_min = np.percentile(image, 5)
    in_max = np.percentile(image, 95)

    # Defines minimum and maximum brightness values
    out_min = 0
    out_max = 255

    out = image - in_min
    out *= (out_min - out_max) / (
      in_min - in_max
    )
    out += in_min

    return out

  def calculate_ndvi(self, image):
    b, g, r = cv2.split(image)
    bottom = r.astype(float) + b.astype(float)
    bottom[
      bottom == 0
    ] = 0.01  # Make sure we don't divide by zero!
    ndvi = (r.astype(float) - b) / bottom

    return ndvi

  def read(self):
    return np.mean(
      self.calculate_ndvi(
        self.contrast_stretch(
          self.camera.capture_array()
        )
      )
    )

  def stop(self):
    self.camera.stop()
    self.camera.close()
    ```

    == Actuator Setup <actuator-setup>

    In general to connect actuators (like pumps, light switches or fans) we can relay on a relay. To connect the relay we can refer to the following schematics:

    #image("../img/relay-pump-schematics.jpeg")

    In our project we just conneted one pump but it's trivial to extend the project to multiple pumps (for example we plan to add one dedicated to pumping fertilized water) or other devices. An example of the code used to interact with the pump is the following:


```python
import RPi.GPIO as GPIO
from time import sleep


def pump_water(sec, pump_pin):
    print(
      "Pumping water for {} seconds..."
      .format(sec)
    )

    # set GPIO mode and set up the pump pin
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(pump_pin, GPIO.OUT)

    try:
        # turn the pump off for 0.25 seconds
        GPIO.output(pump_pin, GPIO.LOW)
        sleep(0.25)

        # turn the pump on for the given time
        GPIO.output(pump_pin, GPIO.HIGH)
        sleep(sec)

        # turn the pump off
        GPIO.cleanup()

        print("Done pumping water.")

    except KeyboardInterrupt:
        # stop pump when ctrl-c is pressed
        GPIO.cleanup()
```

    == Putting it all Together

    // FIXME: why is it rotated!!!?!?!?!?
    #figure(
      image("../img/greenhouse.jpeg"),
      caption: [
        the bottom shelf of our greenhouse, not in the picture the router, host and lights
      ]
    )
  ]
)