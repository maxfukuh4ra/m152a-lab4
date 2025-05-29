module traffic_light(
    input wire clk,          // 100 MHz clock
    input wire start_btn,    // Start button from .xdc
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);

  reg [33:0] counter = 0;
  reg started = 0;
  reg cycle_completed = 0;  // New register to track cycle completion

  always @(posedge clk) begin
    // If not started or cycle completed, wait for button press
    if (!started || cycle_completed) begin
      red_light <= 1;  // Keep red light on while waiting
      yellow_light <= 0;
      green_light <= 0;

      if (start_btn) begin
        started <= 1;  // Start when button is pressed
        cycle_completed <= 0;  // Reset cycle completion flag
        counter <= 0;  // Reset counter at the start
      end
    end else begin
      // Run one cycle
      if (counter >= 1_300_000_000) begin
        counter <= 0;
        cycle_completed <= 1;  // Mark cycle as completed
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
