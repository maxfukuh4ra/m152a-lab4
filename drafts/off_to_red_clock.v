module traffic_light(
    input wire clk,         // 100 MHz clock
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);

  // 500 million clock cycles = 5 seconds @ 100 MHz
  reg [32:0] counter = 0;

  always @(posedge clk) begin
    // Default: all lights off
    red_light <= 0;
    yellow_light <= 0;
    green_light <= 0;

    if (counter < 500_000_000) begin
      counter <= counter + 1;
    end else begin
      red_light <= 1;  // Turn red on after 5 seconds
    end
  end

endmodule

