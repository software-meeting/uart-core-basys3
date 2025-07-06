# UART Core for Digilent Basys3
Exactly what it sounds like. Uses the inbuilt PIC24FJ128 to communicate via micro USB.

## Usage
In my experience the device typically shows up under `/dev/ttyUSB1`

1. Run `stty -a -F /dev/ttyUSB1` and check to ensure it is set to 9600 baud.
   If it isn't, run `stty -F /dev/ttyUSB1 9600`

2. Run `echo -n ...` to input your byte and they will display on the LEDs.
