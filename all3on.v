module top(
  output wire green_light,
  output wire yellow_light,
  output wire red_light
);
  assign red_light = 1'b1;       // tie the pin high
  assign yellow_light = 1'b1;
  assign red_light = 1'b1;
  
endmodule