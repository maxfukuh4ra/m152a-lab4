module traffic_light(
    input wire clk,         // 100 MHz clock
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);

  // Clock cycle counter
  reg [33:0] counter = 0;

  always @(posedge clk) begin
    // Count continuously, reset after 13 seconds
    if (counter >= 1_300_000_000) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end

    // Default all lights off
    red_light <= 0;
    yellow_light <= 0;
    green_light <= 0;

    // RED: 0 to 5 seconds
    if (counter < 500_000_000) begin
      red_light <= 1;

    // GREEN: 5 to 10 seconds
    end else if (counter < 1_000_000_000) begin
      green_light <= 1;

    // YELLOW: 10 to 13 seconds
    end else begin
      yellow_light <= 1;
    end
  end

endmodule
