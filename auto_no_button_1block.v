module traffic_light_auto(
  input  wire       clk,          // 100 MHz
  input  wire       rst_n,        // active-low reset
  output reg        red_light,
  output reg        yellow_light,
  output reg        green_light
);

  // State encoding
  localparam S_RED    = 2'b00,
             S_GREEN  = 2'b01,
             S_YELLOW = 2'b10;

  // Internal registers
  reg [26:0] clk_count;   // divides 100 MHz → 1 Hz
  reg [1:0]  state;       // current state
  reg [3:0]  sec_count;   // counts seconds in each state

  // Everything in one synchronous block
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset all registers
      clk_count   <= 0;
      state       <= S_RED;
      sec_count   <= 0;
      red_light   <= 1;
      yellow_light<= 0;
      green_light <= 0;
    end else begin
      // 1 Hz tick generator
      if (clk_count == 100_000_000-1) begin
        clk_count <= 0;

        // state-timer update on each tick
        case (state)
          S_RED: begin
            if (sec_count == 5) begin
              state     <= S_GREEN;
              sec_count <= 0;
            end else
              sec_count <= sec_count + 1;
          end
          S_GREEN: begin
            if (sec_count == 5) begin
              state     <= S_YELLOW;
              sec_count <= 0;
            end else
              sec_count <= sec_count + 1;
          end
          S_YELLOW: begin
            if (sec_count == 3) begin
              state     <= S_RED;
              sec_count <= 0;
            end else
              sec_count <= sec_count + 1;
          end
          default: begin
            state     <= S_RED;
            sec_count <= 0;
          end
        endcase

      end else begin
        // keep counting toward next tick
        clk_count <= clk_count + 1;
      end

      // Moore-style output decoding (registered)
      case (state)
        S_RED:    {red_light, yellow_light, green_light} <= 3'b100;
        S_GREEN:  {red_light, yellow_light, green_light} <= 3'b001;
        S_YELLOW: {red_light, yellow_light, green_light} <= 3'b010;
        default:  {red_light, yellow_light, green_light} <= 3'b000;
      endcase
    end
  end

endmodule
