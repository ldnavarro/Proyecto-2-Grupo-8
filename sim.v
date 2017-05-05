`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2017 01:30:03
// Design Name: 
// Module Name: sim
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


module sim(

    );
    reg clk,clr;
    wire ERAM,ERCLK;
    wire [4:0] estado;
    wire cont_es;
    wire [2:0] RRCont;
    
   FSM sim(
     .clk(clk),
     .clr(clr),
     .envioRAM(ERAM),
     .envioRCLK(ERCLK),
     .estado(estado),
     .RRCont(RRCont),
     .cont_es(cont_es)
             );
    always
    #5 clk = !clk;     
    
    initial
    begin
    clk=0;
    #10 clr=1;
    #10 clr=0;
    end
    
endmodule

