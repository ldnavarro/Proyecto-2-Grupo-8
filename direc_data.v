`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.05.2017 23:11:18
// Design Name: 
// Module Name: direc_data
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


module direc_data(
    input [4:0] estado,
    input [3:0] cont,
    input ini,lect,clr,clk,
    input [7:0] d_t_s,d_t_m,d_t_h,d_h_h,d_h_m,d_h_s,d_f_a,d_f_m,d_f_d,
    input conf_t,conf_h,conf_f,
    input if_h,cont_es,
    output reg [7:0] a_d
       
    );
    
    reg [7:0] adr_sig,data_sig,adr, data,f_h;
    
    always @(posedge clk,posedge clr)
    begin
    if (clr)
    begin
        adr<=8'b0;
        data<=8'b0;
    end
    else
    begin
        adr<=adr_sig;
        data<=data_sig;
    end
    end
    
    
    always @*
    case (estado)
    5'b01100:begin 
    case (cont)
        4'b0000:begin
            if (ini)
            begin
                adr_sig<=8'h02;
                data_sig<=8'h10;
            end
            else
            begin
                adr_sig<=adr;
                data_sig<=data;
            end
            end
        4'b0001:begin
            if (ini)
            begin
                adr_sig<=8'h02;
                data_sig<=8'h00;
            end
            else if(lect)
            begin
                adr_sig<=8'h21;
                data_sig<=data;
           end
           else
           begin 
           if (conf_t)
           begin
                adr_sig<=8'h41;
                data_sig<=d_t_s;
           end
           else if (conf_h)
           begin 
               adr_sig<=8'h21;
               data_sig<=d_h_s;
           end
           else if (conf_f)
           begin
               adr_sig<=8'h24;
               data_sig<=d_f_d;
           end
           else
           begin
                adr_sig<=adr;
                data_sig<=data;
           end     
           end
           end
        4'b0010:begin
            if (ini)
            begin   
                adr_sig<=8'h20;
                data_sig<=8'h00;
            end
            else if(lect)
            begin
                adr_sig<=8'h22;
                data_sig<=data;
            end
            else 
            begin
            if (conf_t)
            begin
                adr_sig<=8'h42;
                data_sig<=d_t_m;
            end
            else if (conf_h)
            begin 
                adr_sig<=8'h22;
                data_sig<=d_h_m;
            end
            else if (conf_f)
            begin
                adr_sig<=8'h25;
                data_sig<=d_f_m;
            end   
            else
                       begin
                            adr_sig<=adr;
                            data_sig<=data;
                       end    
            end
            end             
    4'b0011:begin
        if (ini)
        begin
            adr_sig<=8'h21;
            data_sig<=8'h00;
        end
        else if (lect)
        begin
            adr_sig<=8'h23;
            data_sig<=data;  
        end
        else
        begin   
        if (conf_t)
        begin
            adr_sig<=8'h43;
            data_sig<=d_t_h;
        end
        else if (conf_h)
        begin 
            adr_sig<=8'h23;
            data_sig<=d_h_h;
        end
        else if (conf_f)
        begin
            adr_sig<=8'h26;
            data_sig<=d_f_a;
        end  
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end     
        end
        end               
    4'b0100:begin
        if (ini)
        begin
            adr_sig<=8'h22;
            data_sig<=8'h00;
        end
        else if (lect)
        begin
            adr_sig<=8'h24;
            data_sig<=data;
        end
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end  
        end
     4'b0101:begin
        if (ini)
        begin
            adr_sig<=8'h23;
            data_sig<=8'hc;
        end
        else if (lect)
        begin
            adr_sig<=8'h25;
            data_sig<=data;
        end
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end  
        end
     4'b0110:begin
        if (ini)
        begin
            adr_sig<=8'h24;
            data_sig<=8'h1;    
        end
        else if (lect)
        begin
            adr_sig<=8'h26;
            data_sig<=data;
        end
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end  
        end 
     4'b0111:begin
        if (ini)
        begin
            adr_sig<=8'h25;
            data_sig<=8'h4;    
        end
        else if (lect)
        begin
            adr_sig<=8'h41;
            data_sig<=data;
        end
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end  
        end 
     4'b1000:begin
        if (ini)
        begin
            adr_sig<=8'h26;
            data_sig<=8'h11;    
        end
        else if (lect)
        begin
            adr_sig<=8'h42;
            data_sig<=data;
        end
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end  
        end
     4'b1001:begin
        if (ini)
        begin
            adr_sig<=8'h27;
            data_sig<=8'h01;    
        end
        else if (lect)
        begin
            adr_sig<=8'h43;
            data_sig<=data;
        end
        else
                   begin
                        adr_sig<=adr;
                        data_sig<=data;
                   end  
        end
     4'b1010:begin  
        adr_sig<=8'h28;
        data_sig<=8'h00; 
     end
     4'b1011:begin
        adr_sig<=8'h10;
        data_sig<=8'hd2;
     end 
     4'b1100:begin
        adr_sig<=8'h00;
        data_sig<=8'h00;
     end  
     4'b1101:begin
        adr_sig<=8'h00;
        data_sig<=f_h;
     end     
     default:begin
        adr_sig<=adr;
        data_sig<=data;
        end 
    endcase
    end
   5'b10011:begin
     adr_sig<=8'hf0;
     data_sig<=data;
   end
   default:begin
     adr_sig<=adr;
     data_sig<=data;
   end
   endcase
   
      always @*
      if (if_h)
          f_h = 8'h10;
      else
          f_h = 8'h00;
      
            
     always @*
     if (cont_es)
        a_d=data;
     else
        a_d=adr;
                
    
    
endmodule
