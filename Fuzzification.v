`timescale 1ns / 1ps


module FUZZIFICATION (
  input  CLK,
  input  [31:0] WQI_CRISP, 
  
  output [7:0] PTR_WQI_FUZZY,
  output [7:0] PTR_INPUT_FUZZY_SET_ID,
  output [7:0] PTR_negBIG, 
  output [7:0] PTR_negMEDIUM, 
  output [7:0] PTR_negSMALL, 
  output [7:0] PTR_ZERO, 
  output [7:0] PTR_posSMALL, 
  output [7:0] PTR_posMEDIUM, 
  output [7:0] PTR_posBIG 
);
    
  reg [7:0] INT_WQI_FUZZY;
  reg [7:0] INT_INPUT_FUZZY_SET_ID; 
  
  reg [7:0] INT_negBIG;
  reg [7:0] INT_negMEDIUM; 
  reg [7:0] INT_negSMALL; 
  reg [7:0] INT_ZERO; 
  reg [7:0] INT_posSMALL; 
  reg [7:0] INT_posMEDIUM; 
  reg [7:0] INT_posBIG;  
  
  parameter ZERO_e1BIT        = 32'b00000000000000000000000000000000; // 0
  parameter TEN_eBIT          = 32'b01000001001000000000000000000000; // 10
  parameter TWENTY_5_eBIT     = 32'b01000001110010000000000000000000; // 25
  parameter FIFTY_eBIT        = 32'b01000010010010000000000000000000; // 50
  parameter SEVENTY_5_eBIT    = 32'b01000010100101100000000000000000; // 75
  parameter HUNDRED_eBIT      = 32'b01000010110010000000000000000000; // 100
    
  parameter ZERO_eBIT      =  8'b00000000;
  parameter ONE_eBIT       =  8'b00000001;
  parameter TWO_eBIT       =  8'b00000010;
  parameter THREE_eBIT     =  8'b00000011;
  parameter FOUR_eBIT      =  8'b00000100;
  parameter FIVE1_eBIT     =  8'b00000101;
  parameter SIX_eBIT       =  8'b00000110;
  parameter SEVEN_eBIT     =  8'b00000111;
  
  // Internal Register to Hold The Crisp Value of Frequency
  reg [31:0] INT_WQI_CRISP;
  
  always@ (posedge CLK) 
    begin
      INT_WQI_CRISP <= WQI_CRISP;
      
      if (INT_WQI_CRISP < ZERO_e1BIT) 
        begin
          INT_negBIG <= ONE_eBIT; // Neg Gignatic
            
          // Identifying The Selected Fuzzy Set
          INT_INPUT_FUZZY_SET_ID <= ONE_eBIT; 
          
          // The Input to Rule Base is Calculated With MAX Rule, Direct Assignment Works As Only One Value Exists 
          INT_WQI_FUZZY <= INT_negBIG;

          /* Set everything else to zero */
          INT_negMEDIUM   <= 8'b00000000;
          INT_negSMALL    <= 8'b00000000;
          INT_ZERO        <= 8'b00000000;
          INT_posSMALL    <= 8'b00000000;
          INT_posMEDIUM   <= 8'b00000000;
          INT_posBIG      <= 8'b00000000; 
        end 
      
      else if ((INT_WQI_CRISP >= ZERO_e1BIT) && (INT_WQI_CRISP < TEN_eBIT)) 
        begin
          INT_negMEDIUM <= ONE_eBIT;     // 1 / 2 = 1 
          INT_INPUT_FUZZY_SET_ID <= TWO_eBIT;
          
          // Set Everything Else to Zero
          INT_negBIG      <= 8'b00000000;
          INT_negSMALL    <= 8'b00000000;
          INT_ZERO        <= 8'b00000000;
          INT_posSMALL    <= 8'b00000000;
          INT_posMEDIUM   <= 8'b00000000;
          INT_posBIG      <= 8'b00000000;
        end 
    
      else if ((INT_WQI_CRISP >= TEN_eBIT) && (INT_WQI_CRISP < TWENTY_5_eBIT)) 
        begin
          INT_negSMALL <= ONE_eBIT;        
              INT_WQI_FUZZY <= INT_negSMALL;
              INT_INPUT_FUZZY_SET_ID <= THREE_eBIT;
          
          // Set Everything Else to Zero 
          INT_negMEDIUM   <= 8'b00000000;
          INT_negBIG      <= 8'b00000000;
          INT_ZERO        <= 8'b00000000;
          INT_posSMALL    <= 8'b00000000;
          INT_posMEDIUM   <= 8'b00000000;
          INT_posBIG      <= 8'b00000000;      
        end
      
      else if ((INT_WQI_CRISP >= TWENTY_5_eBIT) && (INT_WQI_CRISP < FIFTY_eBIT)) 
        begin
          // int_negBig <= (six_ebit - int_freq_crisp) / two_ebit;
          //INT_negSMALL      <= ZERO_eBIT;  // (6 - 5) / 2 = 0.5 (45 Hz should be negative Big with 0 membership value) 
          // int_negMedium <= (int_freq_crisp - 4) / two_ebit;
          INT_ZERO <= ONE_eBIT;  // (5 - 4) / 2 = 0.5 (44 Hz should be negative medium with 1 membership value)
          INT_WQI_FUZZY          <= INT_ZERO;
          INT_INPUT_FUZZY_SET_ID <= FOUR_eBIT;
            
          
          // Set Everything Else to Zero 
          INT_negSMALL    <= 8'b00000000;
          INT_negBIG      <= 8'b00000000;
          INT_negMEDIUM   <= 8'b00000000;
          INT_posSMALL    <= 8'b00000000;
          INT_posMEDIUM   <= 8'b00000000;
          INT_posBIG      <= 8'b00000000; 
        end 
    
      else if ((INT_WQI_CRISP >= FIFTY_eBIT) && (INT_WQI_CRISP < SEVENTY_5_eBIT)) 
        begin
          INT_posSMALL <= ONE_eBIT;
          INT_WQI_FUZZY <= INT_posSMALL;
          INT_INPUT_FUZZY_SET_ID <= FIVE1_eBIT;

          // Set Everything Else to Zero 
          INT_negBIG      <= 8'b00000000;
          INT_negMEDIUM   <= 8'b00000000;
          INT_negSMALL    <= 8'b00000000;
          INT_posMEDIUM   <= 8'b00000000;
          INT_posBIG      <= 8'b00000000;
          INT_ZERO        <= 8'b00000000;    
        end 
      
      else if ((INT_WQI_CRISP >= SEVENTY_5_eBIT) && (INT_WQI_CRISP < HUNDRED_eBIT)) 
        begin 
          INT_posMEDIUM <= ONE_eBIT;   
          INT_WQI_FUZZY <= INT_posMEDIUM;
          INT_INPUT_FUZZY_SET_ID <= SIX_eBIT;
          
          // Set Everything Else to Zero 
          INT_negBIG      <= 8'b00000000;
          INT_negMEDIUM   <= 8'b00000000;
          INT_negSMALL    <= 8'b00000000;
          INT_ZERO        <= 8'b00000000;
          INT_posSMALL    <= 8'b00000000;
          INT_posBIG      <= 8'b00000000;
        end
    
      else if (INT_WQI_CRISP >= HUNDRED_eBIT) 
         begin
           INT_posBIG <= ONE_eBIT;    
           
           // Selecting The Maximum Value
           INT_WQI_FUZZY <= INT_posBIG;
           INT_INPUT_FUZZY_SET_ID <= SEVEN_eBIT; 
           
           // Set Everything Else to Zero
           INT_negBIG      <= 8'b00000000;
           INT_negMEDIUM   <= 8'b00000000;
           INT_negSMALL    <= 8'b00000000;
           INT_ZERO        <= 8'b00000000;
           INT_posSMALL    <= 8'b00000000;
           INT_posMEDIUM   <= 8'b00000000;
        end 
    end 
  
  assign PTR_WQI_FUZZY          = INT_WQI_FUZZY; 
  assign PTR_INPUT_FUZZY_SET_ID = INT_INPUT_FUZZY_SET_ID;
  
 
  assign PTR_negBIG             = INT_negBIG; 
  assign PTR_negMEDIUM          = INT_negMEDIUM; 
  assign PTR_negSMALL           = INT_negSMALL;
  assign PTR_ZERO               = INT_ZERO; 
  assign PTR_posSMALL           = INT_posSMALL; 
  assign PTR_posMEDIUM          = INT_posMEDIUM;
  assign PTR_posBIG             = INT_posBIG; 
 
endmodule
