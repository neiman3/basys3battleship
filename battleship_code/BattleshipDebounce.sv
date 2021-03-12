`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2021 02:29:19 PM
// Design Name: 
// Module Name: BattleshipDebounce
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


module BattleshipDebounce(
    input clk,
    input in,
    output logic out
    );
    
    logic t1, t2, clk_100;
    
    clk_div_50 clk_div_50 (.clk(clk), .sclk(clk_100));
    
    always_ff @ (posedge clk_100) begin
        t2 = t1;
        t1 = in;
    end
    
    always_comb begin
        out = (t1&t2);
    end
    
endmodule
