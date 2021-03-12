`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2021 11:04:58 PM
// Design Name: 
// Module Name: Battleship_Cursor
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


module Battleship_Cursor_old(
    input clk,
    input up,
    input down,
    input left,
    input right,
    output logic [27:0] ships
    );
        
    parameter [2:0]
        BtnWait = 3'd0, // button is not pressed. waiting for user
        BtnPress = 3'd1, // button initially pressed
        BtnDebounce = 3'd2, // waiting some time
        BtnActive = 3'd3, // button is still being held by the user
        BtnAction = 3'd4, // perrform the button's action
        BtnCooldown = 3'd5; // wait a while to negate any error
        
    parameter [1:0]
        upbtn = 2'd0,
        downbtn = 2'd1,
        leftbtn = 2'd2,
        rightbtn = 2'd3;
        
    logic [2:0] ps = 0;
    logic [2:0] ns;
    logic clk_100;
    logic [7:0] button_timing_counter = 0;
    logic [7:0] button_timing_counter_next = 0;
    parameter [7:0] button_timing_limit = 8'd127;
    logic [1:0] current_button = 0, next_button = 0;
    logic [1:0] current_sector = 0, next_sector = 0;
    logic [2:0] current_position = 0, next_position = 0;

    Battleship_Cursor_Decoder decoder (.current_sector(current_sector), .current_position(current_position), .ships(ships));
    clk_div_100 clk_div_100 (.clk(clk), .sclk(clk_100));

    always_ff @ (posedge clk_100) begin
        ps = ns;
        current_button = next_button;
        current_position = next_position;
        current_sector = next_sector;
        button_timing_counter = button_timing_counter_next;
    end
    
    always_comb begin
        case (ps)
        
            BtnWait:
            begin
                button_timing_counter_next = 0;
                case ({up,down,left,right})
                4'b1000: begin
                    next_button = upbtn;
                    ns = BtnDebounce;
                end
                4'b0100: begin
                    next_button = downbtn;
                    ns = BtnDebounce;
                end
                4'b0010: begin
                    next_button = leftbtn;
                    ns = BtnDebounce;
                end
                4'b0001: begin
                    next_button = rightbtn;
                    ns = BtnDebounce;
                end
                default: begin
                    ns = BtnWait;
                end
                endcase
            end
            
            BtnDebounce: begin
                if (up|down|left|right) begin
                    button_timing_counter_next = button_timing_counter + 1;
                    ns = BtnDebounce; end
                else begin ns = BtnWait; end
                
                if (button_timing_counter >= button_timing_limit) begin
                    button_timing_counter_next = 0;
                    ns = BtnActive;
                end
            end
            
            BtnActive: begin
                if (up|down|left|right) begin ns = BtnActive; end
                else begin ns = BtnAction; end
            end
                
            
            BtnAction: begin
                case (current_button)
                    downbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 0; end
                            3'd5: begin next_position = 0; end
                            3'd4: begin next_position = 0; end
                            3'd3: begin next_position = 6; end
                            3'd2: begin next_position = 5; end
                            3'd1: begin next_position = 4; end
                            3'd0: begin next_position = 2; end
                            default: begin next_position = 0; end
                        endcase end
                    upbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 3; end
                            3'd5: begin next_position = 2; end
                            3'd4: begin next_position = 1; end
                            3'd3: begin next_position = 0; end
                            3'd2: begin next_position = 0; end
                            3'd1: begin next_position = 0; end
                            3'd0: begin next_position = 5; end
                            default: begin next_position = 0; end
                        endcase end
                        
                    leftbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 4; next_sector = current_sector + 1; end
                            3'd5: begin next_position = 6; end
                            3'd4: begin next_position = 5; end
                            3'd3: begin next_position = 1; next_sector = current_sector + 1; end
                            3'd2: begin next_position = 3; end
                            3'd1: begin next_position = 2; end
                            3'd0: begin next_position = 3; end
                            default: begin next_position = 0; end
                        endcase
                    end
                        
                    rightbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 5; end
                            3'd5: begin next_position = 4; end
                            3'd4: begin next_position = 6;  next_sector = current_sector - 1; end
                            3'd3: begin next_position = 2; end
                            3'd2: begin next_position = 1; end
                            3'd1: begin next_position = 2;  next_sector = current_sector - 1; end
                            3'd0: begin next_position = 1; end
                            default: begin next_position = 0; end
                        endcase
                    end
                endcase
                ns = BtnCooldown;
            end
            
            BtnCooldown: begin
                if (button_timing_counter == button_timing_limit) begin
                    button_timing_counter_next = 0;
                    ns = BtnWait; end
                else begin
                    button_timing_counter_next = button_timing_counter + 1;
                    ns = BtnCooldown;
                    end
            end
                        
            
//            BtnPress:
//            begin
//                if (up|down|left|right) begin ns = BtnPress; end
//                else begin ns = BtnWait; end
//                if (up|down|left|right) begin
//                    ns=BtnPress;
//                    if (button_timing_counter < button_timing_limit) begin
//                        button_timing_counter_next = button_timing_counter + 1;
//                    end
//                end else begin
//                    if (button_timing_counter < button_timing_limit) begin
//                        ns = Btn
//                    ns = BtnWait;
//                end
//                case (current_button)
//                    upbtn:
//                    begin
//                        if(up) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                    downbtn:
//                    begin
//                        if(down) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                    leftbtn:
//                    begin
//                        if(left) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                    rightbtn:
//                    begin
//                        if(right) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                endcase
//            end
        endcase
                
    end
    
endmodule

module Battleship_Cursor(
    input clk,
    input up,
    input down,
    input left,
    input right,
    output logic [27:0] ships
    );
        
    parameter [2:0]
        BtnWait = 3'd0, // button is not pressed. waiting for user
        BtnHold = 3'd1, // button still pressed
        BtnAction = 3'd4; // perrform the button's action
        
    parameter [1:0]
        upbtn = 3'd0,
        downbtn = 3'd1,
        leftbtn = 3'd2,
        rightbtn = 3'd3;
        
    logic [2:0] ps = 0;
    logic [2:0] ns = 0;
    logic clk_100;
    logic [1:0] current_button = 0, next_button = 0;
    logic [1:0] current_sector = 0, next_sector = 0;
    logic [2:0] current_position = 0, next_position = 0;

    Battleship_Cursor_Decoder decoder (.current_sector(current_sector), .current_position(current_position), .ships(ships));
    clk_div_50 clk_div_50 (.clk(clk), .sclk(clk_100));

    always_ff @ (posedge clk_100) begin
        ps = ns;
        current_button = next_button;
        current_position = next_position;
        current_sector = next_sector;
    end
    
    always_comb begin
        case (ps)
        
            BtnWait:
            begin
                case ({up,down,left,right})
                4'b1000: begin
                    next_button = upbtn;
                    ns = BtnAction;
                end
                4'b0100: begin
                    next_button = downbtn;
                    ns = BtnAction;
                end
                4'b0010: begin
                    next_button = leftbtn;
                    ns = BtnAction;
                end
                4'b0001: begin
                    next_button = rightbtn;
                    ns = BtnAction;
                end
                default: begin
                    ns = BtnWait;
                end
                endcase
            end
                
            
            BtnAction: begin
                case (current_button)
                    downbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 0; end
                            3'd5: begin next_position = 0; end
                            3'd4: begin next_position = 0; end
                            3'd3: begin next_position = 6; end
                            3'd2: begin next_position = 5; end
                            3'd1: begin next_position = 4; end
                            3'd0: begin next_position = 2; end
                            default: begin next_position = 0; end
                        endcase end
                    upbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 3; end
                            3'd5: begin next_position = 2; end
                            3'd4: begin next_position = 1; end
                            3'd3: begin next_position = 0; end
                            3'd2: begin next_position = 0; end
                            3'd1: begin next_position = 0; end
                            3'd0: begin next_position = 5; end
                            default: begin next_position = 0; end
                        endcase end
                    leftbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 4; next_sector = current_sector + 1; end
                            3'd5: begin next_position = 6; end
                            3'd4: begin next_position = 5; end
                            3'd3: begin next_position = 1; next_sector = current_sector + 1; end
                            3'd2: begin next_position = 3; end
                            3'd1: begin next_position = 2; end
                            3'd0: begin next_position = 3; end
                            default: begin next_position = 0; end
                        endcase
                    end
                    rightbtn: begin
                        case ({current_position})
                            3'd6: begin next_position = 5; end
                            3'd5: begin next_position = 4; end
                            3'd4: begin next_position = 6;  next_sector = current_sector - 1; end
                            3'd3: begin next_position = 2; end
                            3'd2: begin next_position = 1; end
                            3'd1: begin next_position = 2;  next_sector = current_sector - 1; end
                            3'd0: begin next_position = 1; end
                            default: begin next_position = 0; end
                        endcase
                    end
                endcase
                ns = BtnHold;
            end
            
//            BtnAction: begin
//                case (current_button)
//                    downbtn: begin
//                    if (current_position == 0) begin next_position = 6; end else begin
//                        next_position = current_position - 1; end end
                        
//                    upbtn: begin
//                    if (current_position == 6) begin next_position = 0; end else begin
//                        next_position = current_position + 1; end end
                        
//                    leftbtn: begin
//                        next_sector = current_sector - 1;
//                    end
                        
//                    rightbtn: begin
//                        next_sector = current_sector + 1;
//                    end
//                endcase
//                ns = BtnHold;
//            end
            
            BtnHold: begin
                if (up|down|left|right) begin
                    ns = BtnHold;
                end else begin
                    ns = BtnWait;
                end
            end
               
            
//            BtnPress:
//            begin
//                if (up|down|left|right) begin ns = BtnPress; end
//                else begin ns = BtnWait; end
//                if (up|down|left|right) begin
//                    ns=BtnPress;
//                    if (button_timing_counter < button_timing_limit) begin
//                        button_timing_counter_next = button_timing_counter + 1;
//                    end
//                end else begin
//                    if (button_timing_counter < button_timing_limit) begin
//                        ns = Btn
//                    ns = BtnWait;
//                end
//                case (current_button)
//                    upbtn:
//                    begin
//                        if(up) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                    downbtn:
//                    begin
//                        if(down) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                    leftbtn:
//                    begin
//                        if(left) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                    rightbtn:
//                    begin
//                        if(right) begin
//                            ns = BtnPress;
//                        end else begin
//                            ns = BtnWait;
//                        end
//                    end
//                endcase
//            end
        endcase
                
    end
    
endmodule

module Battleship_Cursor_Decoder(
    input [1:0] current_sector,
    input [2:0] current_position,
    output logic [27:0] ships
    );
    
    logic [6:0] current_span;
    
    always_comb begin
        case (current_position)
        
            3'b000: begin
                current_span = 7'b0000001;
            end
            3'b001: begin
                current_span = 7'b0000010;
            end
            3'b010: begin
                current_span = 7'b0000100;
            end
            3'b011: begin
                current_span = 7'b0001000;
            end
            3'b100: begin
                current_span = 7'b0010000;
            end
            3'b101: begin
                current_span = 7'b0100000;
            end
            3'b110: begin
                current_span = 7'b1000000;
            end
            default: begin
                current_span = 7'b0001000;
            end
            
        endcase
        
        case (current_sector)
            
            2'b11: begin
                ships = {current_span,21'b0};
            end
            2'b10: begin
                ships = {7'b0,current_span,14'b0};
            end
            2'b01: begin
                ships = {14'b0,current_span,7'b0};
            end
            2'b00: begin
                ships = {21'b0,current_span};
            end
            
        endcase
    end
    
endmodule
    
