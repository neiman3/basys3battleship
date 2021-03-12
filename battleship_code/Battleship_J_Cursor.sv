`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jenna Mast
// 
// Create Date: 02/06/2021 05:25:53 PM
// Design Name: 
// Module Name: CPE 133 Final Project Board Setting file
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

module set(input logic [3:0] B, input logic [27:0] A, output logic [27:0] positions, output logic [3:0] an);


logic [6:0] buffer1 = 0000000;
logic [6:0] buffer2 = 0000000;
logic [6:0] buffer3 = 0000000;
logic [6:0] buffer4 = 0000000;

//logic [27:0] Player; //Was going to store buffer in Player1 and Player2 at some point if use two registers
//but we can also use one large register and a switch represented as a bit in that register to indicate the player.
    
parameter [3:0]
Case0 = 4'b0000,
Case1 = 4'b0001,
Case2 = 4'b0010,
Case3 = 4'b0100,
Case4 = 4'b1000;
         
always_comb
  begin

positions = 28'b0000000000000000000000000000;

 

case (B)
   default:
     begin
       positions = {buffer4, buffer3, buffer2, buffer1};
     end   
     
    Case1: 
     begin
       buffer1 = A;
       positions = {buffer4, buffer3, buffer2, buffer1};
     end  
   
    Case2:
      begin
        buffer2 = A;
        positions = {buffer4, buffer3, buffer2, buffer1};
      end
       
    Case3:
       begin
        buffer3 = A;
        positions = {buffer4, buffer3, buffer2, buffer1};
       end
    
    Case4:
        begin
          buffer4 = A;
          positions = {buffer4, buffer3, buffer2, buffer1};
       end 
       
   
    endcase   
   end    
endmodule
 

module DisplayDriverFSM(input clk, input logic [27:0] positions, output logic [3:0] an, output logic [6:0] seg);  

parameter [3:0]
P1AN0 = 3'b000,
P1AN1 = 3'b001,
P1AN2 = 3'b010,
P1AN3 = 3'b011;

//Probably delete these states
//P2AN0 = 3'b100,
//P2AN1 = 3'b101,
//P2AN2 = 3'b110,
//P2AN3 = 3'b111;

logic [3:0] NS;
logic [3:0] PS = P1AN0; 

   
 
always_ff @(posedge clk) 
       begin
           PS <= NS;
         end      

always_comb
 begin
      
      
    case (PS)
          
          P1AN0:   
             begin
                 an = 4'b1110;
                 seg = ~positions[6:0];
                 NS = P1AN1;
              end 
              
           P1AN1:
               begin 
                 an = 4'b1101;
                 seg = ~positions[13:7];
                 NS = P1AN2;
               end    

           P1AN2:
               begin 
                 an = 4'b1011;
                 seg = ~positions[20:14];
                 NS = P1AN3;
               end                      
           
             P1AN3:
               begin 
                 an = 4'b0111;
                 seg = ~positions[27:21];
                 NS = P1AN0;
               end   
               
            default: an = 4'b1111;   
  endcase
  end  


 endmodule
  

module SetBoardTop(clk, A, B, an, seg);

input clk;
input logic [6:0] A;
input logic [3:0] B;

output [6:0] seg;
output [3:0] an;

wire t1;
wire [27:0] t2;
    
logic [27:0] positions = 28'b0000000000000000000000000000;

clk_div2 div(.clk(clk), .sclk(t1)); //This must be set around 15000 for the display 
DisplayDriverFSM Display(.clk(t1), .positions(t2), .an(an), .seg(seg));
set setbits(.A(A), .B(B), .positions(t2));


endmodule
