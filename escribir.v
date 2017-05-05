`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2017 23:35:51
// Design Name: 
// Module Name: escribir
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


module FSM(
    input clk,
    input clr,
    output reg envioRAM,
    output reg envioRCLK,
    output [4:0] estado,
    output reg [2:0] RRCont,
    output reg cont_es
    

    );
    
  parameter S0=5'b00000, S1=5'b00001, S2=5'b00010, S3=5'b00011,
  S4=5'b00100, S5=5'b00101, S6=5'b00110, S7=5'b00111, S8=5'b01000,
  S9=5'b01001, S10=5'b01010, S11=5'b01011,S12=5'b01100,S13=5'b01101,
  S14=5'b01110,S15=5'b01111,S16=5'b10000,S17=5'b10001;
  
  reg [4:0] state, sig_state;
  reg rst,rst_t,rst_es,en,en_t,en_es,en_RRCont,rst_RRCont,ini,lect;
  reg [3:0]cont_t;
  reg [3:0] cont;
  
  always @(posedge clk,posedge clr)
  begin
  if (clr)
  begin
    state <= S0;
    cont<=0;
    cont_t<=0;
    cont_es<=0;
    RRCont<=0;
  end
  else
  begin
    state <= sig_state;
    if (rst)
         cont <= 0;
    if(rst_t)
         cont_t <= 0;
    if(rst_es)
         cont_es <= 0;
    if(rst_RRCont)
         RRCont<=0;
    if (en)
         cont <= cont+1;
    if(en_t)
         cont_t <= cont_t+1;
    if(en_es)
         cont_es <= cont_es+1;
    if(en_RRCont)
         RRCont<=RRCont+1;
  
  end
  end
  
  always @*
  begin
  case (state)
  //estados de inicialización
  S0:begin
    lect=0;
    envioRAM=0;
    envioRCLK=0;
    ini=1;
    en=0;
    en_t=0;
    en_RRCont=0;
    en_es=0;
    rst_t=1;
    rst_RRCont=1;
    rst=1;
    rst_es=1;
    sig_state<= S10;
    end
  S1:begin
    ini=1;
    lect=0;
    envioRAM=0;
    envioRCLK=0;
    rst_t=0;
    rst_RRCont=0;
    rst=0;
    rst_es=0;
    en=1;
    en_t=0;
    en_RRCont=0;
    en_es=0;
    if (cont==10)
        sig_state<=S17;
    else if (cont==13)
        sig_state<=S2;
    else
        sig_state<=S10;
    end
   S2:begin
    en=0;
    en_t=0;
    en_RRCont=0;
    en_es=0;
    ini=0;
    lect=0;
    envioRAM=0;
    envioRCLK=0;
    rst=1;
    rst_t=0;
    rst_RRCont=0;
    rst_es=0;
    sig_state<=S3;
    end
   //estados para enviar datos a RAM
   S3:begin
    rst=0;
    rst_t=0;
    rst_RRCont=0;
    rst_es=0;
    en_RRCont=1;
    en=0;
    en_t=0;
    en_es=0;
    envioRAM=1;
    envioRCLK=0;
    lect=0;
    sig_state<=S4;
   end
   S4:begin
   lect=0;
   en=0;
   en_t=0;
   en_RRCont=1;
   en_es=0;
   rst=0;
   rst_t=0;
   rst_RRCont=0;
   rst_es=0;
     if (RRCont==4) 
        sig_state<=S5;
     else
        sig_state<=S4;
   end
   S5:begin
    envioRAM=0;
    envioRCLK=0;
    lect=0;
    en_RRCont=0;
    rst_RRCont=1;
    rst=0;
    rst_t=1;
    rst_es=0;
    if (ini)
        sig_state<=S10;
    else
        sig_state<=S6;
   end
   //estados de lectura
   S6:begin
    rst_t=0;
    lect=1;
    envioRAM=0;
    envioRCLK=0;
    ini=0;
    rst=0;
    en=1;
    sig_state<=S10;
   end
   S7:begin
    en=0;
    rst=0;
    rst_t=0;
    en_t=1;
    if(cont_t==7)
        sig_state<=S8;
    else
        sig_state<=S7;
   end
   S8:begin
    rst=0;
    en=0;
    rst_t=0;
    en_t=1;
    if(cont_t==3)
    begin
        if(cont==9)
            sig_state<=S9;
        else
            sig_state<=S6;
    end
   else
    sig_state<=S8;
   end
   S9:begin
   rst=1;
   en=0;
   lect=0;
   sig_state<=S3;
   end
   //estados escribir
   S10:begin
    rst=0;
    en=0;
    rst_t=0;
    rst_es=0;
    sig_state<=S11;
   end
   S11:begin
    en_t=1;
    rst_t=0;
    if (cont_t==1) 
        sig_state<=S12;
    else
        sig_state<=S11;
   end
   S12:begin
    en_t=1;
    rst_t=0;
    if (cont_t==11)
        sig_state<=S13;
    else
        sig_state<=S12;
    end
   S13:begin
    en_t=1;
    rst_t=0;
    if(cont_t==14)
        sig_state<=S14;
    else
        sig_state<=S13;
   end
   S14:begin
    en_t=1;
    rst_t=0;
    if(cont_t==11)
        sig_state<=S15;
     else
        sig_state<=S14;
   end
   S15:begin
    en_es=1;
    en_t=0;
    rst_t=1;
    sig_state<=S16;
   end
   S16:begin
    rst_t=0;
    en_es=0;
    rst_es=0;
    if (lect==1)
        sig_state<=S7;
    else if (cont_es==1)
        sig_state<=S11;
    else
    begin
        if (ini==1)
            sig_state<=S1;
        else
            sig_state<=S17;
    end
    end
    //estado para enviar a reserved clk
    S17:begin
       en=0;
       rst_RRCont=0;
       en_RRCont=1;
       envioRCLK=1;
       sig_state<=S4;
      end
    default:begin
    sig_state<=S0;
    end
    endcase
    end 
    
  assign estado=state;
       
endmodule
