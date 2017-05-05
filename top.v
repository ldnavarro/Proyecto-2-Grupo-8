`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2017 15:36:59
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input clr,
    output WR,RD,CS,A_D,
    output [4:0] estado
      
    );
    
    wire [4:0] state;
    wire eRAM,eRCLK,cont_es;
     
     FSM2 maq_est(
         .clk(clk),
         .clr(clr),
         .envioRAM(eRAM),
         .envioRCLK(eRCLK),
         .estado(state),
         .cont_es(cont_es)
         );
         
     
    control2 CRTC(
        .clk(clk),
        .clr(clr),
        .eRAM(eRAM),
        .eRCLK(eRCLK),
        .estado(state),
        .cont_es(cont_es),
        .WR(WR),
        .RD(RD),
        .CS(CS),
        .A_D(A_D)
        );
        
        assign estado=state;
endmodule
