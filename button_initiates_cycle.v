module traffic_light(
    input wire clk,          // 100 MHz clock
    input wire start_btn,    // Start button from .xdc
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);

  reg [33:0] counter = 0;
  reg started = 0;

  always @(posedge clk) begin
    // If not started, wait for button press
    if (!started) begin
      red_light <= 0;
      yellow_light <= 0;
      green_light <= 0;

      if (start_btn) begin
        started <= 1;  // Start when button is pressed
        counter <= 0;  // Reset counter at the start
      end
    end else begin
      // Cycle forever once started
      if (counter >= 1_300_000_000) begin
        counter <= 0;
      end else begin
        counter <= counter + 1;
      end

      // Default all lights off
      red_light <= 0;
      yellow_light <= 0;
      green_light <= 0;

      // RED: 0–5s
      if (counter < 500_000_000) begin
        red_light <= 1;

      // GREEN: 5–10s
      end else if (counter < 1_000_000_000) begin
        green_light <= 1;

      // YELLOW: 10–13s
      end else begin
        yellow_light <= 1;
      end
    end
  end

endmodule
