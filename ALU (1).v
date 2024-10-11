`timescale 1ns / 1ps

//`include "Addition_Subtraction.v"
//`include "Multiplication.v"
//`include "Division.v"

module ALU(input  [31:0] a_operand,
           input  [31:0] b_operand,
           input   [3:0] Operation,	
           output [31:0] ALU_Output,
           output Exception,Overflow,Underflow
          );

  wire [31:0] Add_Sub_A,Add_Sub_B,Mul_A,Mul_B,Div_A,Div_B;
  wire Add_Sub_Exception,Mul_Exception,Mul_Overflow,Mul_Underflow,Div_Exception;
  wire [31:0] Add_Sub_Output,Mul_Output,Div_Output;
  wire AddBar_Sub;

  //wire [31:0] Complement_output;
  assign {Add_Sub_A,Add_Sub_B,AddBar_Sub} = (Operation == 4'd10) ? {a_operand,b_operand,1'b0} : 64'dz;
  assign {Mul_A,Mul_B} = (Operation == 4'd1) ? {a_operand,b_operand} : 64'dz;
  assign {Div_A,Div_B} = (Operation == 4'd2) ? {a_operand,b_operand}	: 64'dz;
  assign {Add_Sub_A,Add_Sub_B,AddBar_Sub} = (Operation == 4'd3) ? {a_operand,b_operand,1'b1} : 64'dz;

  Addition_Subtraction AuI(Add_Sub_A,Add_Sub_B,AddBar_Sub,Add_Sub_Exception,Add_Sub_Output);
  Multiplication MuI(Mul_A,Mul_B,Mul_Exception,Mul_Overflow,Mul_Underflow,Mul_Output);
  Division DuI(Div_A,Div_B,Div_Exception,Div_Output);

  assign {Exception,Overflow,Underflow,ALU_Output} = (Operation == 4'd10) ?{Add_Sub_Exception,1'b0,1'b0,Add_Sub_Output}	: 35'dz;

  assign {Exception,Overflow,Underflow,ALU_Output} = (Operation == 4'd1) ? {Mul_Exception,Mul_Overflow,Mul_Underflow,Mul_Output}	: 35'dz;

  assign {Exception,Overflow,Underflow,ALU_Output} = (Operation == 4'd2) ? {Div_Exception,1'b0,1'b0,Div_Output}	: 35'dz;

  assign {Exception,Overflow,Underflow,ALU_Output} = (Operation == 4'd3) ? {Add_Sub_Exception,1'b0,1'b0,Add_Sub_Output}	: 35'dz;

endmodule
