`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2021 04:51:57 PM
// Design Name: 
// Module Name: Battleship_Scroller4
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


module Battleship_Scroller4(
    input clk,
    input [27:0] screen1,
    input [27:0] screen2,
    input [27:0] screen3,
    input [27:0] screen4,
    output logic [27:0] ships
    );
    
    logic [1:0] ps, ns;
    
    logic clk_1;
    
    clk_div_1 clk_div_1 (.clk(clk), .sclk(clk_1));
    
    always_ff @ (posedge clk_1) begin
        ps = ns;
    end
    
    always_comb begin
        case (ps)
            0: begin ships = screen1; ns = 2'b1; end
            1: begin ships = screen2; ns = 2'd2; end
            2: begin ships = screen3; ns = 2'd3; end
            3: begin ships = screen4; ns = 2'd0; end
        endcase
    end
    
endmodule
