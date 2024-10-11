`timescale 1ns / 1ps

//`include "ALU.v"

 module WQI_MoD(
   input [31:0] Vn_PH,
   input [31:0] Vn_Ca,
   input [31:0] Vn_Mg,
   input [31:0] Vn_Ir,
   input [31:0] Vn_Fl,
   input [31:0] Vn_TB,
  
   output  Exception,
   output  Overflow,
   output  Underflow,    
   output [31:0] WQI
);
  
  // BIS STANDARDS
  
   reg [31:0] Sn_PH = 32'b01000001000010000000000000000000; // 8.5
   reg [31:0] Sn_Ca = 32'b01000010100101100000000000000000; //75
   reg [31:0] Sn_Mg = 32'b01000001111100000000000000000000; //30
   reg [31:0] Sn_Ir = 32'b00111110100110011001100110011010; //0.3
   reg [31:0] Sn_Fl_One = 32'b00111111100000000000000000000000; //1
   reg [31:0] Sn_TB = 32'b01000000101000000000000000000000; //5
   
   
  // IDEAL VALUE
  
   reg [31:0] SEV = 32'b01000000111000000000000000000000; //7
  //reg [31:0] V0_EC = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_TD = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_TH = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_Ca = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_Mg = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_Ir = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_Fl = 32'b00000000000000000000000000000000;
  //reg [31:0] V0_TB = 32'b00000000000000000000000000000000;
  
  
  // Calculation Qn_PH
  
   wire [31:0] Vn_PH_V0_PH_INT;
   wire [31:0] Sn_PH_S0_PH_INT;
  
   wire [31:0] Qn_PH_INT;
   wire [31:0] Qn_Ca_INT;
   wire [31:0] Qn_Mg_INT;
   wire [31:0] Qn_Ir_INT;
   wire [31:0] Qn_Fl_INT;
   wire [31:0] Qn_TB_INT;
   
   ALU DIFF1(Vn_PH, SEV, 4'b0011, Vn_PH_V0_PH_INT, Exception, Overflow, Underflow);
   ALU DIFF2(Sn_PH, SEV, 4'b0011, Sn_PH_S0_PH_INT, Exception, Overflow, Underflow);
   ALU DIV19(Vn_PH_V0_PH_INT, Sn_PH_S0_PH_INT, 4'b0010, Qn_PH_INT, Exception, Overflow, Underflow);
   
   ALU DIV23(Vn_Ca, Sn_Ca, 4'b0010, Qn_Ca_INT, Exception, Overflow, Underflow);
   ALU DIV24(Vn_Mg, Sn_Mg, 4'b0010, Qn_Mg_INT, Exception, Overflow, Underflow);
   ALU DIV25(Vn_Ir, Sn_Ir, 4'b0010, Qn_Ir_INT, Exception, Overflow, Underflow);
   ALU DIV26(Vn_Fl, Sn_Fl_One, 4'b0010, Qn_Fl_INT, Exception, Overflow, Underflow);
   ALU DIV27(Vn_TB, Sn_TB, 4'b0010, Qn_TB_INT, Exception, Overflow, Underflow);
  
   
   
   // CALCULATION OF WnQn
   wire [31:0] WnQn_PH;
   wire [31:0] WnQn_Ca;
   wire [31:0] WnQn_Mg;
   wire [31:0] WnQn_Ir;
   wire [31:0] WnQn_Fl;
   wire [31:0] WnQn_TB;
   
   //reg [19:0] Wn_SUM;
   reg [31:0] Wn_PH = 32'b01000000001000000100011111001110;//  2.50438267
   reg [31:0] Wn_Ca = 32'b00111110100100010101001000101100;//  0.28383004
   reg [31:0] Wn_Mg = 32'b00111111001101011010011010110111;//  0.70957509
   reg [31:0] Wn_Ir = 32'b01000010100011011110101000111111;// 70.95750897
   reg [31:0] Wn_Fl = 32'b01000001101010100100110001001011;// 21.28725269
   reg [31:0] Wn_TB = 32'b01000000100010000011110100001001;//  4.257450538

  
  
   ALU MUL10(Wn_PH, Qn_PH_INT, 4'b0001, WnQn_PH, Exception, Overflow, Underflow);
   ALU MUL14(Wn_Ca, Qn_Ca_INT, 4'b0001, WnQn_Ca, Exception, Overflow, Underflow);
   ALU MUL15(Wn_Mg, Qn_Mg_INT, 4'b0001, WnQn_Mg, Exception, Overflow, Underflow);
   ALU MUL16(Wn_Ir, Qn_Ir_INT, 4'b0001, WnQn_Ir, Exception, Overflow, Underflow);
   ALU MUL17(Wn_Fl, Qn_Fl_INT, 4'b0001, WnQn_Fl, Exception, Overflow, Underflow);
   ALU MUL18(Wn_TB, Qn_TB_INT, 4'b0001, WnQn_TB, Exception, Overflow, Underflow);
  
  //SUMMATION OF WnQn
   
   wire [31:0] Sum1;
   wire [31:0] Sum4;
   wire [31:0] Sum5;
   wire [31:0] Sum6;
   wire [31:0] Sum7;
  
  
   ALU SUM17(WnQn_PH, WnQn_Ca, 4'b1010, Sum1, Exception, Overflow, Underflow);
   ALU SUM20(Sum1, WnQn_Mg, 4'b1010, Sum4, Exception, Overflow, Underflow);
   ALU SUM21(Sum4, WnQn_Ir, 4'b1010, Sum5, Exception, Overflow, Underflow);
   ALU SUM22(Sum5, WnQn_Fl, 4'b1010, Sum6, Exception, Overflow, Underflow);
   ALU SUM23(Sum6, WnQn_TB, 4'b1010, Sum7, Exception, Overflow, Underflow);
  
  
  //CALCULATION OF WQI
   
   wire [31:0] WQI_F;  
   assign WQI = Sum7;

endmodule

