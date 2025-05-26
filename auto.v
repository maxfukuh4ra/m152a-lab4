module traffic_light(
  input  wire       clk,         // 100 MHz FPGA clock
  input  wire       rst_n,       // active-low reset: 0 means reset, 1 means normal operations
  input  wire       start_btn,   // push-button to start/stop cycle
  output reg        red_light,   // drives red LED
  output reg        yellow_light,// drives yellow LED
  output reg        green_light  // drives green LED
);

  // clock divider: produce a 1 Hz “tick” from 100 MHz
  reg [26:0] clk_count;
  wire       tick;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      clk_count <= 0;
    else if (clk_count == 100_000_000 - 1)
      clk_count <= 0;
    else
      clk_count <= clk_count + 1;
  end
  assign tick = (clk_count == 100_000_000 - 1);



  // simple edge detection on the start button → toggle “running”
  reg        start_btn_prev;
  reg        running; // 0 means paused on red, 1 means cycle is active
  wire       start_edge = start_btn && !start_btn_prev; // goes high for exactly one clock 
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      start_btn_prev <= 0;
      running        <= 0;
    end else begin
      start_btn_prev <= start_btn;
      if (start_edge)
        running <= ~running;
    end
  end



  // FSM state encoding and a seconds-counter
  typedef enum reg [1:0] { S_RED=2'b00, S_GREEN=2'b01, S_YELLOW=2'b10 } state_t;
  state_t state, next_state;
  reg [3:0] sec_count;  // counts from 0 up; small enough for 5 s



  // state register + timing logic
  always @(posedge clk or negedge rst_n) begin
    // reset or initiliaze to red
    if (!rst_n) begin
      state     <= S_RED;
      sec_count <= 0;

    // if cycle is running and there is a tick, change state
    end else if (running && tick) begin
      // on each 1 Hz tick: if in different state -> reset timer
      //                    if in same state -> increment timer
      // update state
      if (state != next_state)
        sec_count <= 0;
      else
        sec_count <= sec_count + 1;
      state <= next_state;
    
    // if cycle is not runing: override back to red and reset
    end else if (!running) begin
      // paused: force RED and reset timer
      state     <= S_RED;
      sec_count <= 0;
    end
  end



  // next-state logic
  always @(*) begin
    next_state = state;
    case (state)
      S_RED:    if (sec_count >= 5) next_state = S_GREEN;
      S_GREEN:  if (sec_count >= 5) next_state = S_YELLOW;
      S_YELLOW: if (sec_count >= 3) next_state = S_RED;
    endcase
  end



  // output decoding
  always @(*) begin
    {red_light, yellow_light, green_light} = 3'b000;
    case (state)
      S_RED:    red_light    = 1;
      S_GREEN:  green_light  = 1;
      S_YELLOW: yellow_light = 1;
    endcase
  end



endmodule