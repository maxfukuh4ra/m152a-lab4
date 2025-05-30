# Traffic Light Controller

This project implements a traffic light controller system using Verilog HDL. The system is designed to control a traffic light with two operational modes: button-triggered and PIR sensor-triggered. The controller manages a complete traffic light cycle with specific timing for each light state.

## Project Structure

- `traffic_light.v`: Main Verilog module implementing the traffic light controller with button and PIR sensor modes
- `drafts/`: Directory containing development and test versions of the implementation

## Module Description

The traffic light controller is implemented in the `traffic_light` module with the following interface:

```verilog
module traffic_light(
    input wire clk,          // 100 MHz clock
    input wire start_btn,    // Button input
    input wire pir_sensor,   // PIR sensor input
    input wire MODE,         // Switch: 1 = button mode, 0 = PIR mode
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);
```

### Ports
- `clk`: 100 MHz clock input for timing control
- `start_btn`: Button input for manual triggering
- `pir_sensor`: PIR sensor input for motion detection
- `MODE`: Mode selection switch (1 = button mode, 0 = PIR mode)
- `red_light`: Output signal controlling the red light
- `yellow_light`: Output signal controlling the yellow light
- `green_light`: Output signal controlling the green light

## Implementation Details

The traffic light controller implements a complete traffic cycle with the following timing sequence:
- Green Light: 0-5 seconds
- Yellow Light: 5-8 seconds
- Red Light: 8-13 seconds

The system features two operational modes:
1. Button Mode (MODE = 1): The traffic light cycle starts when the button is pressed
2. PIR Mode (MODE = 0): The traffic light cycle starts when motion is detected by the PIR sensor

The controller includes:
- Edge detection for both button and PIR sensor inputs
- A 34-bit counter for precise timing control
- State management for cycle completion
- Default red light state when not in operation

## Timing Specifications

- Total Cycle Duration: 13 seconds
- Green Light Duration: 5 seconds
- Yellow Light Duration: 3 seconds
- Red Light Duration: 5 seconds

## Testing

To test the implementation:
1. Connect the module to a 100 MHz clock source
2. Connect the start button and PIR sensor to their respective input pins
3. Set the MODE switch to select between button and PIR operation
4. Connect the output signals to physical LEDs
5. Verify the timing sequence and mode switching functionality

## Requirements

- 100 MHz clock source
- Push button for manual triggering
- PIR motion sensor
- Mode selection switch
- Three LEDs (red, yellow, green) for traffic light display
- Verilog synthesis tool (e.g., Vivado, Quartus, or Icarus Verilog)
- FPGA development board with sufficient I/O pins

## Development Status

The current implementation includes:
- ✅ Complete traffic light cycle timing
- ✅ Dual-mode operation (button/PIR)
- ✅ Edge detection for inputs
- ✅ Cycle completion detection
- ✅ Default state handling

## Future Improvements

Potential enhancements could include:
- Multiple intersection coordination
- Pedestrian crossing functionality
- Emergency vehicle override
- Adjustable timing parameters
- Additional safety features
- Power-saving modes

## License

This project is open source and available for educational purposes.

## Author

Max Fukuhara: maxfuku04@g.ucla.edu
Lauren Stevens: laurenstevens257@gmail.com

## Contributing

Feel free to submit issues and enhancement requests!