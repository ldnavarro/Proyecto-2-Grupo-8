`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2017 16:03:28
// Design Name: 
// Module Name: control2
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


module control2(
    input clk,clr,
    input eRAM,
    input eRCLK,
    input [4:0] estado,
    input cont_es,
    output reg WR,
    output reg RD,
    output reg CS,
    output reg A_D
    );
    
reg sig_WR,sig_RD,sig_CS,sig_A_D;

always @(posedge clk,posedge clr)
begin
      if (clr)
      begin
        WR<=1;
        RD<=1;
        CS<=1;
        A_D<=1;
      end  
      else
      begin
        WR<=sig_WR;
        RD<=sig_RD;
        CS<=sig_CS;
        A_D<=sig_A_D;
      end
 end
       
        
always @*
begin
case (estado)
    5'b00000  : begin
        sig_CS<=1;
        sig_RD<=1;
        sig_WR<=1;
        sig_A_D<=1;
    end
    5'b00011  : begin
        sig_CS<=CS;
        sig_WR<=1;
        sig_RD<=1;
        sig_A_D<=A_D;
    end
    5'b00100 : begin
        sig_A_D<=0;
        sig_CS<=CS;
        sig_WR<=WR;
        sig_RD<=RD;
    end
    5'b10011:begin
        sig_A_D<=A_D;
        sig_CS<=CS;
        sig_WR<=WR;
        sig_RD<=RD;
    end
    5'b10100:begin
        sig_A_D<=1;
        sig_CS<=CS;
        sig_WR<=WR;
        sig_RD<=RD;
    end
    5'b10101:begin
    if (eRAM)
    begin
        sig_RD<=0;
        sig_CS<=CS;
        sig_WR<=WR;
        sig_A_D<=A_D;
    end
    else if (eRCLK)
    begin
        sig_WR<=0;
        sig_A_D<=A_D;
        sig_RD<=RD;
        sig_CS<=CS;
   end
   else
   begin
        sig_WR<=WR;
        sig_RD<=RD;
        sig_A_D<=A_D;
        sig_CS<=CS;
   end
   end
   5'b00101:begin
        sig_WR<=1;
        sig_RD<=1;
        sig_A_D<=A_D;
        sig_CS<=CS;
   end
   5'b00111 : begin
        sig_RD<=0;
        sig_CS<=0;
        sig_A_D<=A_D;
        sig_WR<=WR;
      end
      5'b01000 : begin
        sig_RD<=1;
        sig_CS<=1;
        sig_A_D<=A_D;
        sig_WR<=WR;
      end
      5'b01011 : begin
        if(cont_es)
        begin
            sig_A_D<=1;
            sig_CS<=CS;
            sig_WR<=WR;
            sig_RD<=RD;
        end
        else
        begin
            sig_A_D<=0;
            sig_CS<=CS;
            sig_WR<=WR;
            sig_RD<=RD;
      end      
      end
      5'b01100 : begin
        sig_CS<=0;
        sig_WR<=0;
        sig_A_D<=A_D;
        sig_RD<=RD;
      end
      5'b01101 : begin
        sig_CS<=1;
        sig_WR<=1;
        sig_RD<=RD;
        sig_A_D<=A_D;
      end
      5'b01110 : begin
        sig_A_D<=1;
        sig_CS<=CS;
        sig_WR<=WR;
        sig_RD<=RD;
      end
      5'b10001 : begin
        sig_WR<=1;
        sig_RD<=1;
        sig_CS<=CS;
        sig_A_D<=A_D;
      end
      default : begin
        sig_WR<=WR;
        sig_RD<=RD;
        sig_A_D<=A_D;
        sig_CS<=CS;
      end
      endcase
      end
        
  
 
endmodule
