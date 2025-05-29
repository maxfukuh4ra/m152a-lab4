module traffic_light(
    input wire clk,          // 100 MHz clock
    input wire start_btn,    // Button input
    input wire pir_sensor,   // PIR sensor input
    input wire MODE,         // Switch: 1 = button mode, 0 = PIR mode
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);

  reg [33:0] counter = 0;
  reg started = 0;
  reg cycle_completed = 0;

  // Previous states for edge detection
  reg prev_btn = 0;
  reg prev_pir = 0;

  wire btn_rising_edge = start_btn & ~prev_btn;
  wire pir_rising_edge = pir_sensor & ~prev_pir;

  // Determine whether to start based on mode
  wire trigger = (MODE) ? btn_rising_edge : pir_rising_edge;

  always @(posedge clk) begin
    // Save previous states for edge detection
    prev_btn <= start_btn;
    prev_pir <= pir_sensor;

    if (!started || cycle_completed) begin
      red_light <= 1;
      yellow_light <= 0;
      green_light <= 0;

      if (trigger) begin
        started <= 1;
        cycle_completed <= 0;
        counter <= 0;
      end
    end else begin
      // Run one cycle
      if (counter >= 1_300_000_000) begin
        counter <= 0;
        cycle_completed <= 1;
      end else begin
        counter <= counter + 1;
      end

      // Default all lights off
      red_light <= 0;
      yellow_light <= 0;
      green_light <= 0;

      // GREEN: 0–5s
      if (counter < 500_000_000) begin
        green_light <= 1;

      // YELLOW: 5–8s
      end else if (counter < 800_000_000) begin
        yellow_light <= 1;

      // RED: 8–13s
      end else begin
        red_light <= 1;
      end
    end
  end

endmodule
