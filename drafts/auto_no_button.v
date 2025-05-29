module traffic_light_auto(
  input  wire       clk,          // 100 MHz
  input  wire       rst_n,        // active-low reset
  output reg        red_light,
  output reg        yellow_light,
  output reg        green_light
);

  // 1) 1 Hz tick generator
  reg [26:0] clk_count;
  wire       tick;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      clk_count <= 0;
    else if (clk_count == 100_000_000-1)
      clk_count <= 0;
    else
      clk_count <= clk_count + 1;
  end
  assign tick = (clk_count == 100_000_000-1);

  // 2) State encoding
  localparam S_RED    = 2'b00,
             S_GREEN  = 2'b01,
             S_YELLOW = 2'b10;

  reg [1:0] state, next_state;
  reg [3:0] sec_count;

  // 3) State register + timing
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state     <= S_RED;
      sec_count <= 0;
    end else if (tick) begin
      // reset timer on state change, else count up
      if (state != next_state)
        sec_count <= 0;
      else
        sec_count <= sec_count + 1;
      state <= next_state;
    end
  end

  // 4) Next-state logic
  always @(*) begin
    next_state = state;
    case (state)
      S_RED:    if (sec_count >= 5) next_state = S_GREEN;
      S_GREEN:  if (sec_count >= 5) next_state = S_YELLOW;
      S_YELLOW: if (sec_count >= 3) next_state = S_RED;
    endcase
  end

  // 5) Output decoding
  always @(*) begin
    {red_light, yellow_light, green_light} = 3'b000;
    case (state)
      S_RED:    red_light    = 1;
      S_GREEN:  green_light  = 1;
      S_YELLOW: yellow_light = 1;
    endcase
  end

endmodule