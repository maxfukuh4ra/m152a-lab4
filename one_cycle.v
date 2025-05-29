module traffic_light(
    input wire clk,          // 100 MHz clock
    input wire start_btn,    // Active-high button
    output reg red_light,
    output reg yellow_light,
    output reg green_light
);

  // State encoding
  typedef enum logic [1:0] {
    IDLE  = 2'b00, // waiting at red
    GREEN = 2'b01,
    YELLOW = 2'b10
  } state_t;

  state_t state = IDLE;
  reg [33:0] counter = 0;

  // Button press detection
  reg prev_btn = 0;
  wire btn_rising_edge = start_btn & ~prev_btn;

  always @(posedge clk) begin
    prev_btn <= start_btn;

    case (state)
      // ----------------------
      IDLE: begin
        red_light <= 1;
        green_light <= 0;
        yellow_light <= 0;

        if (btn_rising_edge) begin
          state <= GREEN;
          counter <= 0;
        end
      end

      // ----------------------
      GREEN: begin
        red_light <= 0;
        green_light <= 1;
        yellow_light <= 0;

        if (counter >= 500_000_000) begin // 5 seconds
          state <= YELLOW;
          counter <= 0;
        end else begin
          counter <= counter + 1;
        end
      end

      // ----------------------
      YELLOW: begin
        red_light <= 0;
        green_light <= 0;
        yellow_light <= 1;

        if (counter >= 300_000_000) begin // 3 seconds
          state <= IDLE;
          counter <= 0;
        end else begin
          counter <= counter + 1;
        end
      end

    endcase
  end

endmodule
