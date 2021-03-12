`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2021 06:46:27 PM
// Design Name: 
// Module Name: Battleship_ShipAdder
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


module Battleship_ShipAdder(
    input [27:0] ship1,
    input [27:0] ship2,
    input [27:0] ship3,
    output logic [27:0] shipout
    );
    
    always_comb begin
        shipout[0]  = ship1[0]  | ship2[0]  | ship3[0];
        shipout[1]  = ship1[1]  | ship2[1]  | ship3[1];
        shipout[2]  = ship1[2]  | ship2[2]  | ship3[2];
        shipout[3]  = ship1[3]  | ship2[3]  | ship3[3];
        shipout[4]  = ship1[4]  | ship2[4]  | ship3[4];
        shipout[5]  = ship1[5]  | ship2[5]  | ship3[5];
        shipout[6]  = ship1[6]  | ship2[6]  | ship3[6];
        shipout[7]  = ship1[7]  | ship2[7]  | ship3[7];
        shipout[8]  = ship1[8]  | ship2[8]  | ship3[8];
        shipout[9]  = ship1[9]  | ship2[9]  | ship3[9];
        shipout[10] = ship1[10] | ship2[10] | ship3[10];
        shipout[11] = ship1[11] | ship2[11] | ship3[11];
        shipout[12] = ship1[12] | ship2[12] | ship3[12];
        shipout[13] = ship1[13] | ship2[13] | ship3[13];
        shipout[14] = ship1[14] | ship2[14] | ship3[14];
        shipout[15] = ship1[15] | ship2[15] | ship3[15];
        shipout[16] = ship1[16] | ship2[16] | ship3[16];
        shipout[17] = ship1[17] | ship2[17] | ship3[17];
        shipout[18] = ship1[18] | ship2[18] | ship3[18];
        shipout[19] = ship1[19] | ship2[19] | ship3[19];
        shipout[20] = ship1[20] | ship2[20] | ship3[20];
        shipout[21] = ship1[21] | ship2[21] | ship3[21];
        shipout[22] = ship1[22] | ship2[22] | ship3[22];
        shipout[23] = ship1[23] | ship2[23] | ship3[23];
        shipout[24] = ship1[24] | ship2[24] | ship3[24];
        shipout[25] = ship1[25] | ship2[25] | ship3[25];
        shipout[26] = ship1[26] | ship2[26] | ship3[26];
        shipout[27] = ship1[27] | ship2[27] | ship3[27];
    end
    
endmodule

//Torpedo Mod with hit bits
module Torpedo(input logic [27:0] playerInitial, input logic [27:0] torpedo, output logic [27:0] playerFinal, output logic [0:0] hit);
//Note playerFinal can be sent directly to the display driver to show the positions of the player. 
logic [27:0] buffer;
assign buffer = (playerInitial)&(~torpedo);
always_comb
   begin
     if (playerInitial == buffer)  //Miss. Still needs code to indicate there was a miss
        begin
           playerFinal = playerInitial;
           hit = 1'b0;
        end   
     else 
        begin
           playerFinal = buffer;     //Hit condition. Still needs code to adjust scores and also maybe some visual effects.
           hit = 1'b1;
        end   
   end
endmodule

module TorpedoMod(input logic [27:0] playerInitial, input logic [27:0] torpedo, output logic [27:0] playerFinal);
//Note playerFinal can be sent directly to the display driver to show the positions of the player. 
logic [27:0] buffer;
assign buffer = (playerInitial)&(~torpedo);
always_comb
   begin
     if (playerInitial == buffer)  //Miss. Still needs code to indicate there was a miss
        playerFinal = playerInitial;
     else 
        playerFinal = buffer;     //Hit condition. Still needs code to adjust scores and also maybe some visual effects.
   end
endmodule

module Battleship_ShipSinker(
    input [27:0] ships,
    input [27:0] torps,
    output logic [27:0] shipout
    );
    
    always_comb begin
        shipout[0]  = ships[0]  & ~torps[0];
        shipout[1]  = ships[1]  & ~torps[1];
        shipout[2]  = ships[2]  & ~torps[2];
        shipout[3]  = ships[3]  & ~torps[3];
        shipout[4]  = ships[4]  & ~torps[4];
        shipout[5]  = ships[5]  & ~torps[5];
        shipout[6]  = ships[6]  & ~torps[6];
        shipout[7]  = ships[7]  & ~torps[7];
        shipout[8]  = ships[8]  & ~torps[8];
        shipout[9]  = ships[9]  & ~torps[9];
        shipout[10] = ships[10] & ~torps[10];
        shipout[11] = ships[11] & ~torps[11];
        shipout[12] = ships[12] & ~torps[12];
        shipout[13] = ships[13] & ~torps[13];
        shipout[14] = ships[14] & ~torps[14];
        shipout[15] = ships[15] & ~torps[15];
        shipout[16] = ships[16] & ~torps[16];
        shipout[17] = ships[17] & ~torps[17];
        shipout[18] = ships[18] & ~torps[18];
        shipout[19] = ships[19] & ~torps[19];
        shipout[20] = ships[20] & ~torps[20];
        shipout[21] = ships[21] & ~torps[21];
        shipout[22] = ships[22] & ~torps[22];
        shipout[23] = ships[23] & ~torps[23];
        shipout[24] = ships[24] & ~torps[24];
        shipout[25] = ships[25] & ~torps[25];
        shipout[26] = ships[26] & ~torps[26];
        shipout[27] = ships[27] & ~torps[27];
    end
    
endmodule

module Battleship_ShipCounter(
    input [27:0] ships,
    output logic [1:0] count
    );
    
    always_comb begin
        count = ships[27] + 
        ships[26] + 
        ships[25] + 
        ships[25] + 
        ships[24] + 
        ships[23] + 
        ships[22] + 
        ships[21] + 
        ships[20] + 
        ships[19] + 
        ships[18] + 
        ships[17] + 
        ships[16] + 
        ships[15] + 
        ships[14] + 
        ships[13] + 
        ships[12] + 
        ships[11] + 
        ships[10] + 
        ships[9] + 
        ships[8] + 
        ships[7] + 
        ships[6] + 
        ships[5] + 
        ships[4] + 
        ships[3] + 
        ships[2] + 
        ships[1] + 
        ships[0];
    end
    
endmodule
