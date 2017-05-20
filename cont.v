`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2017 16:13:05
// Design Name: 
// Module Name: cont
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


module cont(
    input clk,reset,up,dwn,rgt,lft,conf_h,conf_t,conf_f,f_h,
    output reg [7:0] o_seg_h, o_seg_t,o_min_h,o_min_t,o_hora_h,o_hora_t,o_mes,o_dia,o_ano

    );
    
    //localparam N_bits =24;//~4Hz
    
    reg [23:0] pulse_reg;
    reg [5:0]seg_h,seg_t,min_t,min_h,seg_h_sig,seg_t_sig,min_t_sig,min_h_sig;
    reg pulse,am_pm,am_pm_sig,am_pmt,am_pmt_sig;
    reg [4:0] hora_h,hora_t,hora_h_sig,hora_t_sig,dia,dia_sig;
    reg [3:0] mes,mes_sig;
    reg [6:0] ano,ano_sig;
    reg [1:0] cont_deco,cont_deco_sig;
    
    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            pulse_reg <= 0;
            pulse <= 0; 
        end
        else
        begin
        if (pulse_reg == 24'd12999999)
        begin
            pulse_reg <= 24'd0;
            pulse <= ~pulse;
        end
        else
                pulse_reg <= pulse_reg + 1'b1;
        end
    end 
    
    always @(posedge pulse,posedge reset)
    begin
    if (reset)
    begin
        seg_h<=6'b0;
        seg_t<=6'b0;
        min_h<=6'b0;
        min_t<=6'b0;
        hora_h<=5'b0;
        hora_t<=5'b0;
        dia<=5'b1;
        mes<=4'b1;
        ano<=7'b0;
        cont_deco<=2'b0;
        am_pm<=1'b0;
        am_pmt<=1'b0;
    end
    else
    begin 
        seg_h<=seg_h_sig;
        seg_t<=seg_t_sig;
        min_h<=min_h_sig;
        min_t<=min_t_sig;
        hora_h<=hora_h_sig;
        hora_t<=hora_t_sig;
        dia<=dia_sig;
        mes<=mes_sig;
        ano<=ano_sig;
        cont_deco<=cont_deco_sig;
        am_pm<=am_pm_sig;
        am_pmt<=am_pmt_sig;
    end
    end
        
    always @*
    begin
    if (lft)
    begin
        if(cont_deco==2'b10)
            cont_deco_sig<=2'b0;
        else
            cont_deco_sig<=cont_deco+1;
    end
    else if (rgt)
    begin
        if(cont_deco==2'b0)
                cont_deco_sig<=2'b10;
        else
                cont_deco_sig<=cont_deco-1;
    end
    else    
        cont_deco_sig<=cont_deco;
    end
        
        
     always @*
     begin
     case (cont_deco)
     2'b00:begin
            if (conf_f)
            begin
                if (up)
                begin
                    if (ano==7'd99)
                        ano_sig<= 7'd0;
                    else
                        ano_sig<= ano + 7'd1;
                end
                else if (dwn)
                begin
                    if (ano==7'd0)
                        ano_sig<= 7'd99;
                    else            
                        ano_sig<= ano - 7'd1;
                end
                else
                    ano_sig<=ano;
           end
            else if (conf_h)
            begin
                if (up)
                begin
                    if (seg_h==6'd59)
                        seg_h_sig<=6'd00;
                    else
                        seg_h_sig<=seg_h + 6'd1;
                end
                else if (dwn)
                begin
                    if (seg_h==6'd0)
                        seg_h_sig<=6'd59;
                    else
                        seg_h_sig<=seg_h - 6'd1;
                end
                else
                    seg_h_sig<=seg_h;
            end
            else if (conf_t)
            begin
            if (up)
            begin
                if (seg_t==6'd59)
                    seg_t_sig<=6'd00;
                else
                    seg_t_sig<=seg_t + 6'd1;
            end
            else if (dwn)
            begin
                if (seg_t==6'd0)
                    seg_t_sig<=6'd59;
                else
                    seg_t_sig<=seg_t - 6'd1;
            end
            else
                    seg_t_sig<=seg_t;
            end
            else
            begin    
                seg_h_sig<=seg_h;
                seg_t_sig<=seg_t;
                ano_sig<=ano;   
            end
        end
        2'b01:begin
        if (conf_f)
        begin
            if (up)
            begin
                if (mes==4'd12)
                    mes_sig<= 4'd1;
                else
                    mes_sig<= mes + 4'd1;
            end
            else if (dwn)
            begin
                if (mes==4'd1)
                    mes_sig<= 4'd12;
                else            
                    mes_sig<= mes - 4'd1;
            end
            else
                mes_sig<= mes;
       end
      else if (conf_h)
      begin
        if (up)
        begin
            if (min_h==6'd59)
                   min_h_sig<=6'd00;
            else
                  min_h_sig<=min_h + 6'd1;
        end
        else if (dwn)
        begin
           if (min_h==6'd0)
                  min_h_sig<=6'd59;
           else
                  min_h_sig<=min_h - 6'd1;
        end
        else
            min_h_sig<=min_h;
        end
        else if (conf_t)
        begin
            if (up)
            begin
                if (min_t==6'd59)
                       min_t_sig<=6'd00;
                else
                       min_t_sig<=min_t + 6'd1;
            end
            else if (dwn)
            begin
                if (min_t==6'd0)
                    min_t_sig<=6'd59;
                else
                    min_t_sig<=min_t - 6'd1;
            end
            else
                min_t_sig<=min_t;
         end
        else
        begin    
                   min_h_sig<=min_h;
                   min_t_sig<=min_t;
                   mes_sig<=mes;   
         end
        end
        2'b10:begin
                if (conf_f)
                begin
                    if (up)
                    begin
                        if (dia==5'd31)
                                    dia_sig<= 5'd1;
                        else
                                    dia_sig<= dia + 5'd1;
                    end
                    else if (dwn)
                    begin
                                if (dia==5'd1)
                                    dia_sig<= 5'd31;
                                else            
                                    dia_sig<= dia - 5'd1;
                    end
                    else
                            dia_sig<= dia;
                    
                end
                else if (conf_h)
                begin
                    if(f_h)
                    begin
                        if (up)
                        begin
                            if (hora_h==5'd12)
                            begin
                                                   hora_h_sig<=5'd1;
                                                   am_pm_sig=~am_pm;
                            end
                            else
                                                  hora_h_sig<=hora_h + 5'd1;
                        end
                        else if (dwn)
                        begin
                            if (hora_h==5'd1)
                            begin
                                                  hora_h_sig<=5'd12;
                                                  am_pm_sig=~am_pm;
                            end
                            else
                                                  hora_h_sig<=hora_h - 5'd1;
                        end
                        else                
                                                 hora_h_sig<=hora_h;
                    end
                    else
                    begin
                    am_pm_sig<=0;
                        if (up)
                        begin
                            if (hora_h==5'd23)
                                                hora_h_sig<=5'd0;
                            else
                                                hora_h_sig<=hora_h + 5'd1;
                        end
                        else if (dwn)
                        begin
                            if (hora_h==5'd0)
                                                 hora_h_sig<=5'd23;
                            else
                                                 hora_h_sig<=hora_h - 5'd1;
                        end
                       else
                                                    hora_h_sig<=hora_h;
                    end
               end
               else if (conf_t)
               begin
                if(f_h)
                begin
                    if (up)
                    begin
                        if (hora_t==5'd12)
                                     begin
                                        hora_t_sig<=5'd1;
                                        am_pmt_sig=~am_pmt;
                                     end
                        else
                                        hora_t_sig<=hora_t + 5'd1;
                    end
                    else if (dwn)
                    begin
                        if (hora_t==5'd1)
                        begin
                                         hora_t_sig<=5'd12;
                                         am_pmt_sig=~am_pmt;
                        end
                        else
                                         hora_t_sig<=hora_t - 5'd1;
                    end
                    else
                                        hora_t_sig<=hora_t;
                end
                else
                begin
                am_pmt_sig<=0;
                    if (up)
                    begin
                                 if (hora_t==5'd23)
                                        hora_t_sig<=5'd0;
                                 else
                                    hora_t_sig<=hora_t + 5'd1;
                    end
                    else if (dwn)
                    begin
                                     if (hora_t==5'd0)
                                                hora_t_sig<=5'd23;
                                     else
                                                hora_t_sig<=hora_t - 5'd1;
                    end
                    else
                                    hora_t_sig<=hora_t;
               end
             end
            else
            begin 
                                     hora_t_sig<=hora_t;
                                     hora_h_sig<=hora_h;
                                     dia_sig<= dia;
             end  
               
        end
        default: begin
                seg_h_sig<=seg_h;
                seg_t_sig<=seg_t;
                min_h_sig<=min_h;
                min_t_sig<=min_t;
                hora_h_sig<=hora_h;
                hora_t_sig<=hora_t;
                dia_sig<=dia;
                mes_sig<=mes;
                ano_sig<=ano;
                am_pm_sig<=am_pm;
                am_pmt<=am_pmt_sig;
        end
        endcase
        end
        
        always @*
        begin
        case (seg_h)
            6'd0: begin o_seg_h = 8'h0; end
            6'd1: begin o_seg_h = 8'h1; end
            6'd2: begin o_seg_h = 8'h2; end
            6'd3: begin o_seg_h = 8'h3; end
            6'd4: begin o_seg_h = 4'h4; end
            6'd5: begin o_seg_h = 4'h5; end
            6'd6: begin o_seg_h = 4'h6; end
            6'd7: begin o_seg_h = 4'h7; end
            6'd8: begin o_seg_h = 4'h8; end
            6'd9: begin o_seg_h = 4'h9; end
            
            6'd10: begin o_seg_h = 8'ha; end
            6'd11: begin o_seg_h = 8'hb; end
            6'd12: begin o_seg_h = 8'hc; end
            6'd13: begin o_seg_h = 8'hd; end
            6'd14: begin o_seg_h = 8'he; end
            6'd15: begin o_seg_h = 8'hf; end
            6'd16: begin o_seg_h = 8'h10; end
            6'd17: begin o_seg_h = 8'h11; end
            6'd18: begin o_seg_h = 8'h12; end
            6'd19: begin o_seg_h = 8'h13; end
            
            6'd20: begin o_seg_h = 8'h14; end
            6'd21: begin o_seg_h = 8'h15; end
            6'd22: begin o_seg_h = 8'h16; end
            6'd23: begin o_seg_h = 8'h17; end
            6'd24: begin o_seg_h= 8'h18; end
            6'd25: begin o_seg_h = 8'h19; end
            6'd26: begin o_seg_h= 8'h1a; end
            6'd27: begin o_seg_h= 8'h1b; end
            6'd28: begin o_seg_h= 8'h1c; end
            6'd29: begin o_seg_h= 8'h1d; end
           
            6'd30: begin o_seg_h = 8'h1e; end
            6'd31: begin o_seg_h= 8'h1f; end
            6'd32: begin o_seg_h= 8'h20; end
            6'd33: begin o_seg_h= 8'h21; end
            6'd34: begin o_seg_h= 8'h22; end
            6'd35: begin o_seg_h= 8'h23; end
            6'd36: begin o_seg_h= 8'h24; end
            6'd37: begin o_seg_h= 8'h25; end
            6'd38: begin o_seg_h= 8'h26; end
            6'd39: begin o_seg_h= 8'h27; end
           
            6'd40: begin o_seg_h = 8'h28; end
            6'd41: begin o_seg_h= 8'h29; end
            6'd42: begin o_seg_h= 8'h2a; end
            6'd43: begin o_seg_h= 8'h2b; end
            6'd44: begin o_seg_h= 8'h2c; end
            6'd45: begin o_seg_h= 8'h2d; end
            6'd46: begin o_seg_h= 8'h2e; end
            6'd47: begin o_seg_h= 8'h2f; end
            6'd48: begin o_seg_h= 8'h30; end
            6'd49: begin o_seg_h= 8'h31; end
           
            6'd50: begin o_seg_h= 8'h32; end
            6'd51: begin o_seg_h= 8'h33; end
            6'd52: begin o_seg_h= 8'h34; end
            6'd53: begin o_seg_h= 8'h35; end
            6'd54: begin o_seg_h= 8'h36; end
            6'd55: begin o_seg_h= 8'h37; end
            6'd56: begin o_seg_h= 8'h38; end
            6'd57: begin o_seg_h= 8'h39; end
            6'd58: begin o_seg_h= 8'h3a; end
            6'd59: begin o_seg_h= 8'h3b; end
            default:begin o_seg_h= 8'b0;end
        endcase
        
        case (seg_t)
                6'd0: begin o_seg_t = 8'h0; end
                6'd1: begin o_seg_t = 8'h1; end
                6'd2: begin o_seg_t = 8'h2; end
                6'd3: begin o_seg_t = 8'h3; end
                6'd4: begin o_seg_t = 4'h4; end
                6'd5: begin o_seg_t = 4'h5; end
                6'd6: begin o_seg_t = 4'h6; end
                6'd7: begin o_seg_t = 4'h7; end
                6'd8: begin o_seg_t = 4'h8; end
                6'd9: begin o_seg_t = 4'h9; end
               
                6'd10: begin o_seg_t = 8'ha; end
                6'd11: begin o_seg_t = 8'hb; end
                6'd12: begin o_seg_t = 8'hc; end
                6'd13: begin o_seg_t = 8'hd; end
                6'd14: begin o_seg_t = 8'he; end
                6'd15: begin o_seg_t = 8'hf; end
                6'd16: begin o_seg_t = 8'h10; end
                6'd17: begin o_seg_t = 8'h11; end
                6'd18: begin o_seg_t = 8'h12; end
                6'd19: begin o_seg_t = 8'h13; end
               
                6'd20: begin o_seg_t = 8'h14; end
                6'd21: begin o_seg_t = 8'h15; end
                6'd22: begin o_seg_t = 8'h16; end
                6'd23: begin o_seg_t = 8'h17; end
                6'd24: begin o_seg_t= 8'h18; end
                6'd25: begin o_seg_t = 8'h19; end
                6'd26: begin o_seg_t= 8'h1a; end
                6'd27: begin o_seg_t= 8'h1b; end
                6'd28: begin o_seg_t= 8'h1c; end
                6'd29: begin o_seg_t= 8'h1d; end
              
                6'd30: begin o_seg_t = 8'h1e; end
                6'd31: begin o_seg_t= 8'h1f; end
                6'd32: begin o_seg_t= 8'h20; end
                6'd33: begin o_seg_t= 8'h21; end
                6'd34: begin o_seg_t= 8'h22; end
                6'd35: begin o_seg_t= 8'h23; end
                6'd36: begin o_seg_t= 8'h24; end
                6'd37: begin o_seg_t= 8'h25; end
                6'd38: begin o_seg_t= 8'h26; end
                6'd39: begin o_seg_t= 8'h27; end
              
                6'd40: begin o_seg_t = 8'h28; end
                6'd41: begin o_seg_t= 8'h29; end
                6'd42: begin o_seg_t= 8'h2a; end
                6'd43: begin o_seg_t= 8'h2b; end
                6'd44: begin o_seg_t= 8'h2c; end
                6'd45: begin o_seg_t= 8'h2d; end
                6'd46: begin o_seg_t= 8'h2e; end
                6'd47: begin o_seg_t= 8'h2f; end
                6'd48: begin o_seg_t= 8'h30; end
                6'd49: begin o_seg_t= 8'h31; end
              
                6'd50: begin o_seg_t= 8'h32; end
                6'd51: begin o_seg_t= 8'h33; end
                6'd52: begin o_seg_t= 8'h34; end
                6'd53: begin o_seg_t= 8'h35; end
                6'd54: begin o_seg_t= 8'h36; end
                6'd55: begin o_seg_t= 8'h37; end
                6'd56: begin o_seg_t= 8'h38; end
                6'd57: begin o_seg_t= 8'h39; end
                6'd58: begin o_seg_t= 8'h3a; end
                6'd59: begin o_seg_t= 8'h3b; end
                default:begin o_seg_t= 8'b0;end
        endcase
                case (min_t)
                6'd0: begin o_min_t = 8'h0; end
                6'd1: begin o_min_t = 8'h1; end
                6'd2: begin o_min_t = 8'h2; end
                6'd3: begin o_min_t = 8'h3; end
                6'd4: begin o_min_t = 4'h4; end
                6'd5: begin o_min_t = 4'h5; end
                6'd6: begin o_min_t = 4'h6; end
                6'd7: begin o_min_t = 4'h7; end
                6'd8: begin o_min_t = 4'h8; end
                6'd9: begin o_min_t = 4'h9; end
               
                6'd10: begin o_min_t = 8'ha; end
                6'd11: begin o_min_t = 8'hb; end
                6'd12: begin o_min_t = 8'hc; end
                6'd13: begin o_min_t = 8'hd; end
                6'd14: begin o_min_t = 8'he; end
                6'd15: begin o_min_t = 8'hf; end
                6'd16: begin o_min_t = 8'h10; end
                6'd17: begin o_min_t = 8'h11; end
                6'd18: begin o_min_t = 8'h12; end
                6'd19: begin o_min_t = 8'h13; end
               
                6'd20: begin o_min_t = 8'h14; end
                6'd21: begin o_min_t = 8'h15; end
                6'd22: begin o_min_t = 8'h16; end
                6'd23: begin o_min_t = 8'h17; end
                6'd24: begin o_min_t= 8'h18; end
                6'd25: begin o_min_t = 8'h19; end
                6'd26: begin o_min_t= 8'h1a; end
                6'd27: begin o_min_t= 8'h1b; end
                6'd28: begin o_min_t= 8'h1c; end
                6'd29: begin o_min_t= 8'h1d; end
              
                6'd30: begin o_min_t = 8'h1e; end
                6'd31: begin o_min_t= 8'h1f; end
                6'd32: begin o_min_t= 8'h20; end
                6'd33: begin o_min_t= 8'h21; end
                6'd34: begin o_min_t= 8'h22; end
                6'd35: begin o_min_t= 8'h23; end
                6'd36: begin o_min_t= 8'h24; end
                6'd37: begin o_min_t= 8'h25; end
                6'd38: begin o_min_t= 8'h26; end
                6'd39: begin o_min_t= 8'h27; end
              
                6'd40: begin o_min_t = 8'h28; end
                6'd41: begin o_min_t= 8'h29; end
                6'd42: begin o_min_t= 8'h2a; end
                6'd43: begin o_min_t= 8'h2b; end
                6'd44: begin o_min_t= 8'h2c; end
                6'd45: begin o_min_t= 8'h2d; end
                6'd46: begin o_min_t= 8'h2e; end
                6'd47: begin o_min_t= 8'h2f; end
                6'd48: begin o_min_t= 8'h30; end
                6'd49: begin o_min_t= 8'h31; end
              
                6'd50: begin o_min_t= 8'h32; end
                6'd51: begin o_min_t= 8'h33; end
                6'd52: begin o_min_t= 8'h34; end
                6'd53: begin o_min_t= 8'h35; end
                6'd54: begin o_min_t= 8'h36; end
                6'd55: begin o_min_t= 8'h37; end
                6'd56: begin o_min_t= 8'h38; end
                6'd57: begin o_min_t= 8'h39; end
                6'd58: begin o_min_t= 8'h3a; end
                6'd59: begin o_min_t= 8'h3b; end
                default:begin o_min_t= 8'b0;end
                endcase
                                
        case (min_h)
                6'd0: begin o_min_h = 8'h0; end
                6'd1: begin o_min_h = 8'h1; end
                6'd2: begin o_min_h = 8'h2; end
                6'd3: begin o_min_h = 8'h3; end
                6'd4: begin o_min_h = 4'h4; end
                6'd5: begin o_min_h = 4'h5; end
                6'd6: begin o_min_h = 4'h6; end
                6'd7: begin o_min_h = 4'h7; end
                6'd8: begin o_min_h = 4'h8; end
                6'd9: begin o_min_h = 4'h9; end
               
                6'd10: begin o_min_h = 8'ha; end
                6'd11: begin o_min_h = 8'hb; end
                6'd12: begin o_min_h = 8'hc; end
                6'd13: begin o_min_h = 8'hd; end
                6'd14: begin o_min_h = 8'he; end
                6'd15: begin o_min_h = 8'hf; end
                6'd16: begin o_min_h = 8'h10; end
                6'd17: begin o_min_h = 8'h11; end
                6'd18: begin o_min_h = 8'h12; end
                6'd19: begin o_min_h = 8'h13; end
               
                6'd20: begin o_min_h = 8'h14; end
                6'd21: begin o_min_h = 8'h15; end
                6'd22: begin o_min_h = 8'h16; end
                6'd23: begin o_min_h = 8'h17; end
                6'd24: begin o_min_h= 8'h18; end
                6'd25: begin o_min_h = 8'h19; end
                6'd26: begin o_min_h= 8'h1a; end
                6'd27: begin o_min_h= 8'h1b; end
                6'd28: begin o_min_h= 8'h1c; end
                6'd29: begin o_min_h= 8'h1d; end
              
                6'd30: begin o_min_h = 8'h1e; end
                6'd31: begin o_min_h= 8'h1f; end
                6'd32: begin o_min_h= 8'h20; end
                6'd33: begin o_min_h= 8'h21; end
                6'd34: begin o_min_h= 8'h22; end
                6'd35: begin o_min_h= 8'h23; end
                6'd36: begin o_min_h= 8'h24; end
                6'd37: begin o_min_h= 8'h25; end
                6'd38: begin o_min_h= 8'h26; end
                6'd39: begin o_min_h= 8'h27; end
              
                6'd40: begin o_min_h = 8'h28; end
                6'd41: begin o_min_h= 8'h29; end
                6'd42: begin o_min_h= 8'h2a; end
                6'd43: begin o_min_h= 8'h2b; end
                6'd44: begin o_min_h= 8'h2c; end
                6'd45: begin o_min_h= 8'h2d; end
                6'd46: begin o_min_h= 8'h2e; end
                6'd47: begin o_min_h= 8'h2f; end
                6'd48: begin o_min_h= 8'h30; end
                6'd49: begin o_min_h= 8'h31; end
             
                6'd50: begin o_min_h= 8'h32; end
                6'd51: begin o_min_h= 8'h33; end
                6'd52: begin o_min_h= 8'h34; end
                6'd53: begin o_min_h= 8'h35; end
                6'd54: begin o_min_h= 8'h36; end
                6'd55: begin o_min_h= 8'h37; end
                6'd56: begin o_min_h= 8'h38; end
                6'd57: begin o_min_h= 8'h39; end
                6'd58: begin o_min_h= 8'h3a; end
                6'd59: begin o_min_h= 8'h3b; end
                default:begin o_min_h= 8'b0;end
                endcase
                
         case(hora_h)
                 5'd0: begin o_hora_h = 8'h0; end
                 5'd1: begin 
                 if(f_h)
                 begin
                    if(am_pm)
                        o_hora_h = 8'h81;
                    else
                        o_hora_h = 8'h1;
                 end      
                 else
                     o_hora_h = 8'h1;
                 end
                 5'd2: begin 
                 if(f_h)
                 begin
                    if(am_pm)
                      o_hora_h = 8'h82;
                    else
                      o_hora_h = 8'h2; 
                 end
                 else
                    o_hora_h = 8'h2;
                 end
                 5'd3: begin 
                 if(f_h)
                 begin 
                    if(am_pm)
                        o_hora_h = 8'h83;
                    else
                        o_hora_h = 8'h3;
                 end
                 else
                       o_hora_h = 8'h3;
                 end
                 5'd4: begin
                 if(f_h)
                 begin 
                        if(am_pm)
                          o_hora_h = 8'h84;
                        else
                          o_hora_h = 8'h4; 
                 end
                 else
                             o_hora_h = 8'h4;
                 end
                 5'd5: begin  
                 if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h85;
                         else
                            o_hora_h = 8'h5;
                 end
                 else
                           o_hora_h = 8'h5;
                 end
                 5'd6: begin    
                 if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h86;
                         else
                            o_hora_h = 8'h6;
                 end
                 else
                           o_hora_h = 8'h6;
                 end
                 5'd7: begin      
                 if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h87;
                         else
                            o_hora_h = 8'h7;
                 end
                 else
                           o_hora_h = 8'h7;
                 end                 
                 5'd8: begin
                if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h88;
                         else
                            o_hora_h = 8'h8;
                 end
                 else
                           o_hora_h = 8'h8;
                 end
                 5'd9: begin 
                 if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h89;
                         else
                            o_hora_h = 8'h9;
                 end
                 else
                           o_hora_h = 8'h9;
                 end
                 5'd10: begin 
                 if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h8a;
                         else
                            o_hora_h = 8'ha;
                 end
                 else
                           o_hora_h = 8'ha;
                 end
                 5'd11: begin
                 if(f_h)
                 begin
                         if(am_pm)
                            o_hora_h = 8'h8b;
                         else
                            o_hora_h = 8'hb;
                 end
                 else
                           o_hora_h = 8'hb;
                 end
                 5'd12: begin 
                 if(f_h)
                 begin
                 if(am_pm)
                            o_hora_h = 8'h8c;
                 else
                            o_hora_h = 8'hc;
                 end
                 else
                           o_hora_h = 8'hc;
                 end
                 5'd13: begin o_hora_h = 8'hd; end
                 5'd14: begin o_hora_h = 8'he; end
                 5'd15: begin o_hora_h = 8'hf; end
                 5'd16: begin o_hora_h = 8'h10; end
                 5'd17: begin o_hora_h = 8'h11; end
                 5'd18: begin o_hora_h = 8'h12; end
                 5'd19: begin o_hora_h = 8'h13; end
                 5'd20: begin o_hora_h = 8'h14; end
                 5'd21: begin o_hora_h = 8'h15; end
                 5'd22: begin o_hora_h = 8'h16; end
                 5'd23: begin o_hora_h = 8'h17; end
                 default:begin o_hora_h = 8'h0; end
                 endcase
        
                 case(hora_t)
                         5'd0: begin o_hora_t = 8'h0; end
                         5'd1: begin 
                         if(f_h)
                         begin
                            if(am_pm)
                                o_hora_t = 8'h81;
                            else
                                o_hora_t = 8'h1;
                         end      
                         else
                             o_hora_t = 8'h1;
                         end
                         6'd2: begin 
                         if(f_h)
                         begin
                            if(am_pm)
                              o_hora_t = 8'h82;
                            else
                              o_hora_t = 8'h2; 
                         end
                         else
                            o_hora_t= 8'h2;
                         end
                         5'd3: begin 
                         if(f_h)
                         begin 
                            if(am_pm)
                                o_hora_t = 8'h83;
                            else
                                o_hora_t = 8'h3;
                         end
                         else
                               o_hora_t = 8'h3;
                         end
                         5'd4: begin
                         if(f_h)
                         begin 
                                if(am_pm)
                                  o_hora_t = 8'h84;
                                else
                                  o_hora_t = 8'h4; 
                         end
                         else
                                     o_hora_t = 8'h4;
                         end
                         5'd5: begin  
                         if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t= 8'h85;
                                 else
                                    o_hora_t = 8'h5;
                         end
                         else
                                   o_hora_t = 8'h5;
                         end
                         5'd6: begin    
                         if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t = 8'h86;
                                 else
                                    o_hora_t = 8'h6;
                         end
                         else
                                   o_hora_t = 8'h6;
                         end
                         5'd7: begin      
                         if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t = 8'h87;
                                 else
                                    o_hora_t = 8'h7;
                         end
                         else
                                   o_hora_t= 8'h7;
                         end                 
                         5'd8: begin
                        if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t = 8'h88;
                                 else
                                    o_hora_t = 8'h8;
                         end
                         else
                                   o_hora_t= 8'h8;
                         end
                         5'd9: begin 
                         if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t = 8'h89;
                                 else
                                    o_hora_t = 8'h9;
                         end
                         else
                                   o_hora_t= 8'h9;
                         end
                         5'd10: begin 
                         if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t = 8'h8a;
                                 else
                                    o_hora_t = 8'ha;
                         end
                         else
                                   o_hora_t= 8'ha;
                         end
                         5'd11: begin
                         if(f_h)
                         begin
                                 if(am_pm)
                                    o_hora_t = 8'h8b;
                                 else
                                    o_hora_t = 8'hb;
                         end
                         else
                                   o_hora_t= 8'hb;
                         end
                         5'd12: begin 
                         if(f_h)
                         begin
                         if(am_pm)
                                    o_hora_t = 8'h8c;
                         else
                                    o_hora_t = 8'hc;
                         end
                         else
                                   o_hora_t= 8'hc;
                         end
                         5'd13: begin o_hora_t = 8'hd; end
                         5'd14: begin o_hora_t = 8'he; end
                         5'd15: begin o_hora_t = 8'hf; end
                         5'd16: begin o_hora_t = 8'h10; end
                         5'd17: begin o_hora_t = 8'h11; end
                         5'd18: begin o_hora_t = 8'h12; end
                         5'd19: begin o_hora_t = 8'h13; end
                         5'd20: begin o_hora_t = 8'h14; end
                         5'd21: begin o_hora_t = 8'h15; end
                         5'd22: begin o_hora_t = 8'h16; end
                         5'd23: begin o_hora_t = 8'h17; end
                         default:begin o_hora_t = 8'h0; end
                         endcase
                
                case(mes)
                        4'd1: begin o_mes = 8'h1; end
                        4'd2: begin o_mes = 8'h2; end
                        4'd3: begin o_mes = 8'h3; end
                        4'd4: begin o_mes = 4'h4; end
                        4'd5: begin o_mes = 4'h5; end
                        4'd6: begin o_mes = 4'h6; end
                        4'd7: begin o_mes = 4'h7; end
                        4'd8: begin o_mes = 4'h8; end
                        4'd9: begin o_mes = 4'h9; end
                        4'd10: begin o_mes = 8'ha; end
                        4'd11: begin o_mes = 8'hb; end
                        4'd12: begin o_mes = 8'hc; end
                        default:begin o_mes = 8'h0; end
                endcase
                
                case (dia)
                       5'd1: begin o_dia = 8'h1; end
                       5'd2: begin o_dia = 8'h2; end
                       5'd3: begin o_dia = 8'h3; end
                       5'd4: begin o_dia = 4'h4; end
                       5'd5: begin o_dia = 4'h5; end
                       5'd6: begin o_dia = 4'h6; end
                       5'd7: begin o_dia = 4'h7; end
                       5'd8: begin o_dia = 4'h8; end
                       5'd9: begin o_dia = 4'h9; end
                       5'd10: begin o_dia = 8'ha; end
                       5'd11: begin o_dia = 8'hb; end
                       5'd12: begin o_dia = 8'hc; end
                       5'd13: begin o_dia = 8'hd; end
                       5'd14: begin o_dia = 8'he; end
                       5'd15: begin o_dia = 8'hf; end
                       5'd16: begin o_dia = 8'h10; end
                       5'd17: begin o_dia = 8'h11; end
                       5'd18: begin o_dia = 8'h12; end
                       5'd19: begin o_dia = 8'h13; end
                       5'd20: begin o_dia = 8'h14; end
                       5'd21: begin o_dia = 8'h15; end
                       5'd22: begin o_dia = 8'h16; end
                       5'd23: begin o_dia = 8'h17; end
                       5'd24: begin o_dia= 8'h18; end
                       5'd25: begin o_dia = 8'h19; end
                       5'd26: begin o_dia= 8'h1a; end
                       5'd27: begin o_dia= 8'h1b; end
                       5'd28: begin o_dia= 8'h1c; end
                       5'd29: begin o_dia= 8'h1d; end
                       5'd30: begin o_dia = 8'h1e; end
                       5'd31: begin o_dia= 8'h1f; end
                       default:begin    o_dia= 8'h0; end
                endcase
        case(ano)
        7'd0: begin o_ano = 8'h0; end
        7'd1: begin o_ano = 8'h1; end
        7'd2: begin o_ano = 8'h2; end
        7'd3: begin o_ano = 8'h3; end
        7'd4: begin o_ano = 4'h4; end
        7'd5: begin o_ano = 4'h5; end
        7'd6: begin o_ano = 4'h6; end
        7'd7: begin o_ano = 4'h7; end
        7'd8: begin o_ano = 4'h8; end
        7'd9: begin o_ano = 4'h9; end
        7'd10: begin o_ano = 8'ha; end
        7'd11: begin o_ano = 8'hb; end
        7'd12: begin o_ano = 8'hc; end
        7'd13: begin o_ano = 8'hd; end
        7'd14: begin o_ano = 8'he; end
        7'd15: begin o_ano = 8'hf; end
        7'd16: begin o_ano = 8'h10; end
        7'd17: begin o_ano = 8'h11; end
        7'd18: begin o_ano = 8'h12; end
        7'd19: begin o_ano = 8'h13; end
        7'd20: begin o_ano = 8'h14; end
        7'd21: begin o_ano = 8'h15; end
        7'd22: begin o_ano = 8'h16; end
        7'd23: begin o_ano = 8'h17; end
        7'd24: begin o_ano= 8'h18; end
        7'd25: begin o_ano = 8'h19; end
        7'd26: begin o_ano= 8'h1a; end
        7'd27: begin o_ano= 8'h1b; end
        7'd28: begin o_ano= 8'h1c; end
        7'd29: begin o_ano= 8'h1d; end
        7'd30: begin o_ano = 8'h1e; end
        7'd31: begin o_ano= 8'h1f; end
        7'd32: begin o_ano= 8'h20; end
        7'd33: begin o_ano= 8'h21; end
        7'd34: begin o_ano= 8'h22; end
        7'd35: begin o_ano= 8'h23; end
        7'd36: begin o_ano= 8'h24; end
        7'd37: begin o_ano= 8'h25; end
        7'd38: begin o_ano= 8'h26; end
        7'd39: begin o_ano= 8'h27; end
        7'd40: begin o_ano = 8'h28; end
        7'd41: begin o_ano= 8'h29; end
        7'd42: begin o_ano= 8'h2a; end
        7'd43: begin o_ano= 8'h2b; end
        7'd44: begin o_ano= 8'h2c; end
        7'd45: begin o_ano= 8'h2d; end
        7'd46: begin o_ano= 8'h2e; end
        7'd47: begin o_ano= 8'h2f; end
        7'd48: begin o_ano= 8'h30; end
        7'd49: begin o_ano= 8'h31; end
        7'd50: begin o_ano= 8'h32; end
        7'd51: begin o_ano= 8'h33; end
        7'd52: begin o_ano= 8'h34; end
        7'd53: begin o_ano= 8'h35; end
        7'd54: begin o_ano= 8'h36; end
        7'd55: begin o_ano= 8'h37; end
        7'd56: begin o_ano= 8'h38; end
        7'd57: begin o_ano= 8'h39; end
        7'd58: begin o_ano= 8'h3a; end
        7'd59: begin o_ano= 8'h3b; end
        7'd60: begin o_ano= 8'h3c; end
        7'd61: begin o_ano= 8'h3d; end
        7'd62: begin o_ano= 8'h3e; end
        7'd63: begin o_ano= 8'h3f; end
        7'd64: begin o_ano= 8'h40; end
        7'd65: begin o_ano= 8'h41; end
        7'd66: begin o_ano= 8'h42; end
        7'd67: begin o_ano= 8'h43; end
        7'd68: begin o_ano= 8'h44; end
        7'd69: begin o_ano= 8'h45; end
        7'd70: begin o_ano= 8'h46; end
        7'd71: begin o_ano= 8'h47; end
        7'd72: begin o_ano= 8'h48; end
        7'd73: begin o_ano= 8'h49; end
        7'd74: begin o_ano= 8'h4a; end
        7'd75: begin o_ano= 8'h4b; end
        7'd76: begin o_ano= 8'h4c; end
        7'd77: begin o_ano= 8'h4d; end
        7'd78: begin o_ano= 8'h4e; end
        7'd79: begin o_ano= 8'h4f; end
        7'd80: begin o_ano= 8'h50; end
        7'd81: begin o_ano= 8'h51; end
        7'd82: begin o_ano= 8'h52; end
        7'd83: begin o_ano= 8'h53; end
        7'd84: begin o_ano= 8'h54; end
        7'd85: begin o_ano= 8'h55; end
        7'd86: begin o_ano= 8'h56; end
        7'd87: begin o_ano= 8'h57; end
        7'd88: begin o_ano= 8'h58; end
        7'd89: begin o_ano= 8'h59; end
        7'd90: begin o_ano= 8'h5a; end
        7'd91: begin o_ano= 8'h5b; end
        7'd92: begin o_ano= 8'h5c; end
        7'd93: begin o_ano= 8'h5d; end
        7'd94: begin o_ano= 8'h5e; end
        7'd95: begin o_ano= 8'h5f; end
        7'd96: begin o_ano= 8'h60; end
        7'd97: begin o_ano= 8'h61; end
        7'd98: begin o_ano= 8'h62; end
        7'd99: begin o_ano= 8'h63; end
        default:begin o_ano= 8'b0;end
        endcase
                end
endmodule
