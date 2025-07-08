A light-sensing lamp that **does not contain** a light-sensing sensor!

It turns on when it's dark.

Parts: 1 Arduino UNO, 1 47Mohm, 1 220ohm, 1 red 5-pi LED

Connection: pin 2 - 47Mohm - pin 3 - LED cathode - LED anode - 220ohm - pin 4

## why it works?

LEDs are structurally similar to photodiodes. 

When a photodiode receives light, it passes more current, which causes a change in voltage. 

The lamp has two states: light detection mode and light output mode. 

Since the current change in the LED photodiode is very small, a very large resistance value must be used to detect this as voltage. 

To resolve the voltage noise caused by this, the lamp measures the voltage several times and determines the current output by referring to past output.
