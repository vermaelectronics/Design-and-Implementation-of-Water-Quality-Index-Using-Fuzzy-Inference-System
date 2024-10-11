`timescale 1ns / 1ps

module RULEBASE(
  input        CLK,
  input  [7:0] INPUT_FUZZY_SET_ID, 
  output [7:0] OUTPUT_FUZZY_SET_ID
);
  
  // Local Parameters to Represent The Numbers For Readability
  localparam ONE_eBIT       =  8'b00000001;
  localparam TWO_eBIT       =  8'b00000010;
  localparam THREE_eBIT     =  8'b00000011;
  localparam FOUR_eBIT      =  8'b00000100;
  localparam FIVE_eBIT      =  8'b00000101;
  localparam SIX_eBIT       =  8'b00000110;
  localparam SEVEN_eBIT     =  8'b00000111;
       
  // Internal Registers to Handle the Input and Ouput Fuzzy Sets IDs 
  
  reg [7:0] INT_INPUT_ID;
  reg [7:0] INT_OUTPUT_ID;
  
  always@ (posedge CLK) 
    begin
      INT_INPUT_ID = INPUT_FUZZY_SET_ID;
      
      if (INT_INPUT_ID == ONE_eBIT) 
        begin 
          INT_OUTPUT_ID = SEVEN_eBIT;
        end 
      else if (INT_INPUT_ID == TWO_eBIT) 
        begin
          INT_OUTPUT_ID = SIX_eBIT;
        end 
      else if (INT_INPUT_ID == THREE_eBIT) 
        begin
          INT_OUTPUT_ID = FIVE_eBIT;
        end 
      else if (INT_INPUT_ID == FOUR_eBIT) 
        begin
          INT_OUTPUT_ID = FOUR_eBIT;
        end 
      else if (INT_INPUT_ID == FIVE_eBIT) 
        begin
          INT_OUTPUT_ID = THREE_eBIT;
        end 
      else if (INT_INPUT_ID == SIX_eBIT) 
        begin
          INT_OUTPUT_ID = TWO_eBIT;
        end 
      else if (INT_INPUT_ID == SEVEN_eBIT) 
        begin
          INT_OUTPUT_ID = ONE_eBIT;
        end 
    end 
  
  // Assigning The Value of The Internal Register to The Output 
  assign OUTPUT_FUZZY_SET_ID = INT_OUTPUT_ID;
    
endmodule