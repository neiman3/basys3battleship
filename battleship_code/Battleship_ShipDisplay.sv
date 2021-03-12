`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2021 09:40:04 PM
// Design Name: 
// Module Name: Battleship_ShipDisplay
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


 module Battleship_ShipDisplay(
    input clk,
    input [27:0] ships,
    output logic [7:0] DisplayOutput,
    output logic [3:0] an
    );
    
    parameter [1:0]
        StA = 2'd0,
        StB = 2'd1,
        StC = 2'd2,
        StD = 2'd3;
    
    logic clk_100;
//    logic [6:0] ships_seg_1, ships_seg_2, ships_seg_3, ships_seg_4;
    logic [1:0] ps = 2'b0;
    logic [1:0] ns;
    
    logic [7:0] ships_buffer;
    
    clk_div_100 clk_div_100 (.clk(clk), .sclk(clk_100));
    
    always_ff @(posedge clk_100) begin
        
        ps = ns;
                
    end
    
    always_comb begin
//        ships_seg_1 = ships[27:21];
//        ships_seg_2 = ships[20:14];
//        ships_seg_3 = ships[13:7];
//        ships_seg_4 = ships[6:0];
        
        case (ps)
            
            StA:
            begin
                an = 4'b0111;
                ships_buffer = ships[27:21];
                ns = StB;
            end
            
            StB:
            begin
                ns = StC;
                ships_buffer = ships[20:14];
                an = 4'b1011;
            end
            
            StC:
            begin
                ns = StD;
                ships_buffer = ships[13:7];
                an = 4'b1101;
            end
            
            StD:
            begin
                ns = StA;
                ships_buffer = ships[6:0];
                an = 4'b1110;
            end
            
            
        endcase
        
        DisplayOutput = ~{ships_buffer[0],ships_buffer[1],ships_buffer[4],ships_buffer[5],ships_buffer[6],ships_buffer[3],ships_buffer[2],1'b0};

        
    end
    
    
endmodule
