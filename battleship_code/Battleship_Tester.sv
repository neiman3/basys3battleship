`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2021 09:01:32 PM
// Design Name: 
// Module Name: Battleship_Tester
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


module Battleship_Tester(
    input clk,
    input dleft,
    input dright,
    input dup,
    input ddown,
    input dok,
    input rst,
    output logic [27:0] ships
    );
        
    parameter [3:0]
        upbtn = 4'b1000,
        downbtn = 4'b0100,
        leftbtn = 4'b0010,
        rightbtn = 4'b0001;
            
    logic [3:0] button_sel;
    logic [2:0] cp = 3'b0, np_up, np_down, np_left, np_right;
    logic [1:0] cs = 3'b0, ns_up, ns_down, ns_left, ns_right;
    
    Battleship_Cursor_Decoder decoder (.current_sector(cs), .current_position(cp), .ships(ships));
    
    logic refresh;
    
    logic notok;
        
//    always_ff @ (posedge refresh) begin
//        button_sel = {dup,ddown,dleft,dright};
//        if (button_sel == downbtn) begin
//            cp = np_up;
//            cs = ns_up;
//        end if (button_sel == upbtn) begin
////            cp = 5;
//            cp = np_down;
//            cs = ns_down;
//        end if (button_sel == leftbtn) begin
////            cs = 3;
//            cp = np_left;
//            cs = ns_left;
//        end if (button_sel == rightbtn) begin
////            cs = 0;
//            cp = np_right;
//            cs = ns_right;
//        end else begin end
//    end
    
        
    always_ff @ (posedge refresh) begin
        if (dleft) begin cs = ns_left; end
        else if (ddown) begin cp = np_up; end
        if (rst) begin cs = 2'd0; cp = 3'd0; end
    end
    
    always_comb begin
        // cp = 4'b0001 + 4'b0001
        // cp = 
        np_up = cp + 3'b001;
        ns_up = cs;
        np_down = cp - 3'b001;
        ns_down = cs;
        np_left = cp;
        ns_left = cs + 3'b001;
        np_right = cp;
        ns_right = cs - 3'b001;
//        case (cp)
//            0: begin
//                np_up = 3'd5;
//                ns_up = cs;
//                np_down = 3'd2;
//                ns_down = cs;
//                np_left = 3'd3;
//                ns_left = cs;
//                np_right = 3'd1;
//                ns_right = cs;
//            end
//            1: begin
//                np_up = 0;
//                ns_up = cs;
//                np_down = 3'd4;
//                ns_down = cs;
//                np_left = 3'd2;
//                ns_left = cs;
//                np_right = 3'd3;
//                ns_right = cs - 2'd1;
//            end
//            2: begin
//                np_up = 3'd0;
//                ns_up = cs;
//                np_down = 3'd5;
//                ns_down = cs;
//                np_left = 3'd3;
//                ns_left = cs;
//                np_right = 3'd1;
//                ns_right = cs;
//            end
//            3: begin
//                np_up = 3'd0;
//                ns_up = cs;
//                np_down = 3'd6;
//                ns_down = cs;
//                np_left = 3'd1;
//                ns_left = cs + 2'd1;
//                np_right = 3'd2;
//                ns_right = cs;
//            end
//            4: begin
//                np_up = 3'd2;
//                ns_up = cs;
//                np_down = 3'd5;
//                ns_down = cs;
//                np_left = 3'd5;
//                ns_left = cs;
//                np_right = 3'd6;
//                ns_right = cs - 2'd1;
//            end
//            5: begin
//                np_up = 3'd2;
//                ns_up = cs;
//                np_down = 3'd0;
//                ns_down = cs;
//                np_left = 3'd6;
//                ns_left = cs;
//                np_right = 3'd4;
//                ns_right = cs;
//            end
//            6: begin
//                np_up = 3'd3;
//                ns_up = cs;
//                np_down = 3'd5;
//                ns_down = cs;
//                np_left = 3'd4;
//                ns_left = cs + 2'd1;
//                np_right = 3'd5;
//                ns_right = cs;
//            end
//            default: begin
//                np_up = 3'd0;
//                ns_up = 2'd0;
//                np_down = 3'd0;
//                ns_down = 2'd0;
//                np_left = 3'd0;
//                ns_left = 2'd0;
//                np_right = 3'd0;
//                ns_right = 2'd0;
//            end
//        endcase
        
        refresh = ddown | dleft | dok;
        
    end
            
                
    
endmodule