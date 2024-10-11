`timescale 1ns / 1ps

module TOP_LED(
  input CLK_TOP,
  input RESET_TOP,
  input [31:0] Vn_PH_TOP,
  input [31:0] Vn_Ca_TOP,
  input [31:0] Vn_Mg_TOP,
  input [31:0] Vn_Ir_TOP,
  input [31:0] Vn_Fl_TOP,
  input [31:0] Vn_TB_TOP,
  
  output [31:0] WQI_F_TOP,
  output  [7:0] DUTY_TOP,
  output        LED_TOP
);

  // PWM Output Pin of LED of FPGA/SoC Developement Board
  wire PWM_OUT_TOP;
  
  //wire [7:0] DIGITAL_FREQ_TOP;
  wire [31:0] WQI_TOP;
  
  // Digital Output Frequency 
  wire [7:0] OUT_DIG_WQI_TOP;

  wire [7:0] PTR_WQI_FUZZY_TOP;
  wire [7:0] PTR_INPUT_FUZZY_SET_ID_TOP;

  //Input FUZZY SETS
  wire [7:0] PTR_negBIG_TOP;
  wire [7:0] PTR_negMEDIUM_TOP;
  wire [7:0] PTR_negSMALL_TOP;
  wire [7:0] PTR_ZERO_TOP;
  wire [7:0] PTR_posSMALL_TOP;
  wire [7:0] PTR_posMEDIUM_TOP;
  wire [7:0] PTR_posBIG_TOP;
  
  // Defining Fuzzy Set ID in Rulebase
  wire [7:0] OUTPUT_FUZZY_SET_ID_TOP;
  
  // Duty Cycle 
  wire [7:0] PWM_DUTY_CYCLE_WQI_TOP;
  
  // This is Defined for the Overflow and Underflow Flag That is Happenning Inside ALU.
  wire Exception_TOP;
  wire Overflow_TOP;
  wire Underflow_TOP;


  // 1. MODULE to Digitize the BCD Value That is Received From The ADC
  
  WQI_MoD WQI_MoD(.Vn_PH(Vn_PH_TOP),
                  .Vn_Ca(Vn_Ca_TOP),
                  .Vn_Mg(Vn_Mg_TOP),
                  .Vn_Ir(Vn_Ir_TOP),
                  .Vn_Fl(Vn_Fl_TOP),
                  .Vn_TB(Vn_TB_TOP),
                  .Exception(Exception_TOP),
                  .Overflow(Overflow_TOP),
                  .Underflow(Underflow_TOP),
                  .WQI(WQI_TOP)
                 );

  // 2. MODULE to Fuzzify The Input Frequency

  FUZZIFICATION FUZZIFICATION(.CLK(CLK_TOP),
                              .WQI_CRISP(WQI_TOP),
                              .PTR_WQI_FUZZY(PTR_WQI_FUZZY_TOP),
                              .PTR_INPUT_FUZZY_SET_ID(PTR_INPUT_FUZZY_SET_ID_TOP),
                              .PTR_negBIG(PTR_negBIG_TOP),
                              .PTR_negMEDIUM(PTR_negMEDIUM_TOP),
                              .PTR_negSMALL(PTR_negSMALL_TOP),
                              .PTR_ZERO(PTR_ZERO_TOP),
                              .PTR_posSMALL(PTR_posSMALL_TOP),
                              .PTR_posMEDIUM(PTR_posMEDIUM_TOP),
                              .PTR_posBIG(PTR_posBIG_TOP)
                             );

  // 3. RULEBASE MODULE to Infer The Output Membership Function Based On The Input Membership Function

  RULEBASE RULEBASE(.CLK(CLK_TOP),
                    .INPUT_FUZZY_SET_ID(PTR_INPUT_FUZZY_SET_ID_TOP),
                    .OUTPUT_FUZZY_SET_ID(OUTPUT_FUZZY_SET_ID_TOP)
                   );

  // 4. DEFUZZIFICATION MODULE to Defuzzify The Fuzzy Values Into a Crisp Output

  DEFUZZIFICATION DEFUZZIFICATION(.CLK(CLK_TOP),
                                  .OUTPUT_FUZZY_SET_ID(OUTPUT_FUZZY_SET_ID_TOP),
                                  .WQI_PWM_DUTY(PWM_DUTY_CYCLE_WQI_TOP)
                                 );
  // 5. Module Dedicated to PWM Duty Cycle Generation
  PWM_DUTY_MOD PWM_DUTY_MOD(.CLK(CLK_TOP),
                            .RESET(RESET_TOP),
                            .PWM_DUTY_ONE(PWM_DUTY_CYCLE_WQI_TOP),
                            .PWM_OUT(PWM_OUT_TOP)
                            );
  
  assign DUTY_TOP = PWM_DUTY_CYCLE_WQI_TOP;
  assign LED_TOP = PWM_OUT_TOP;
  assign WQI_F_TOP = WQI_TOP;
  
endmodule


//`timescale 1ns / 1ps

////`include "TOP_S.v"

//module TOP_MoD_TB;
  
//  reg [31:0] Vn_PH;
//  reg [31:0] Vn_Ca;
//  reg [31:0] Vn_Mg;
//  reg [31:0] Vn_Ir;
//  reg [31:0] Vn_Fl;
//  reg [31:0] Vn_TB;
  
//  reg reset;
    
//  wire [31:0] WQI;
//  wire  [7:0] DUTY;
//  wire        LED;
  
//  reg clk;
  

//  TOP_LED DUT(.CLK_TOP(clk),
//              .RESET_TOP(reset),
//              .Vn_PH_TOP(Vn_PH),
//              .Vn_Ca_TOP(Vn_Ca), 
//              .Vn_Mg_TOP(Vn_Mg), 
//              .Vn_Ir_TOP(Vn_Ir), 
//              .Vn_Fl_TOP(Vn_Fl), 
//              .Vn_TB_TOP(Vn_TB),
//              .WQI_F_TOP(WQI),
//              .DUTY_TOP(DUTY),
//              .LED_TOP(LED)
//             );
//// Generate Clock Signal With a Period of 10 Time Units
  
//  always begin
//    #5 clk = ~clk;
//  end

  
//  initial begin
//    clk = 0;
     
//    reset = 0; 
//    #5;
//    reset = 1;  
//    #5;
//   reset = 0;
//   #5;
//   reset = 1;
    
//   // Test 1: 
//     #1000
//      Vn_PH = 32'h40fc_cccd;
//      Vn_Ca = 32'h425e_70a4;
//      Vn_Mg = 32'h40cf_5c29;
//      Vn_Ir = 32'h3d4c_cccd;
//      Vn_Fl = 32'h3ca3_d70a;
//      Vn_TB = 32'h3fa6_6666; 
////       4173_E
//     $display ("WQI -> %h, DUTY = %b, LED = %b", WQI, DUTY,LED);
      
//     #10000
//      Vn_PH = 32'h40fc_cccd;
//      Vn_Ca = 32'h425e_70a4;
//      Vn_Mg = 32'h40cf_5c29;
//      Vn_Ir = 32'h3d4c_cccd;
//      Vn_Fl = 32'h3ca3_d70a;
//      Vn_TB = 32'h3fa6_6666; 
////       4173_E
//     $display ("WQI -> %h, DUTY = %b, LED = %b", WQI, DUTY, LED);
      
//     #10000; 
//      Vn_PH = 32'h4116_6666;
//      Vn_Ca = 32'h4234_3333;
//      Vn_Mg = 32'h4184_0000;
//      Vn_Ir = 32'h3ec2_8f5c;
//      Vn_Fl = 32'h3d75_c28f;
//      Vn_TB = 32'h401e_b852;  
//     $display ("WQI -> %h, DUTY = %b, LED = %b", WQI, DUTY, LED);
////     42c3a
//      #10000; 
//      Vn_PH = 32'h4116_6666;
//      Vn_Ca = 32'h4234_3333;
//      Vn_Mg = 32'h4184_0000;
//      Vn_Ir = 32'h3ec2_8f5c;
//      Vn_Fl = 32'h3d75_c28f;
//      Vn_TB = 32'h401e_b852;  
//     $display ("WQI -> %h, DUTY = %b, LED = %b", WQI, DUTY, LED);
////     42c3a
//     #10000;
//      Vn_PH = 32'h40fc_cccd;
//      Vn_Ca = 32'h41e1_5c29;
//      Vn_Mg = 32'h41ae_a3d7;
//      Vn_Ir = 32'h3de1_47ae;
//      Vn_Fl = 32'h3f00_0000;
//      Vn_TB = 32'h4084_cccd;
//     $display ("WQI -> %h, DUTY = %b, LED = %b", WQI, DUTY, LED);
////     42294      
//      #10000;
//      Vn_PH = 32'h40fc_cccd;
//      Vn_Ca = 32'h41e1_5c29;
//      Vn_Mg = 32'h41ae_a3d7;
//      Vn_Ir = 32'h3de1_47ae;
//      Vn_Fl = 32'h3f00_0000;
//      Vn_TB = 32'h4084_cccd;
//     $display ("WQI -> %h, DUTY = %b, LED = %b", WQI, DUTY, LED);
//      #10000;
//     $finish;
//   end  
//endmodule
