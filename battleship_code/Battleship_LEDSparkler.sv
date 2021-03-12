module TorpedoLED(input clk, input enter, output logic [9:0] led);
  
parameter [2:0]
START = 3'b000,
STA = 3'b001,
STB = 3'b010,
STC = 3'b011,
STD = 3'b100,
STE = 3'b101,
STF = 3'b110,
STG = 3'b111;


logic [2:0] NS;
logic [2:0] PS = START;

   
 
always_ff @(posedge clk) 
       begin
          // if(PS != STG)
           PS <= NS;
         end      

always_comb
 begin
      
      
    case (PS)
       START:
              begin 
                led = 10'b0000000000;
                 if(enter)
                    NS = STA;
                 else
                    NS = PS;   
                 end  
        STA:
              begin
                 led = 10'b0000110000;
                 NS = STB;
              end  
             
        STB:       
              begin
                 led = 10'b0011111100;
                 NS = STC;
              end      
        
        STC:
              begin
                 led = 10'b0111001110;
                 NS = STD;
              end   
              
        STD:
              begin
                 led = 10'b1110000111;
                 NS = STE;
              end    
        STE:
              begin
                 led = 10'b1100000011;
                 NS = STF;
              end   
                            
        STF:
              begin
                 led = 10'b1000000001;
                 NS = STG;
              end  
              
        STG:
              begin
                 led = 10'b0000000000;
                 NS = START;
              end 
    endcase
   end                                                                                
endmodule

module TorpedoLEDTop(clk, enter, led);

input clk;
input enter;
output logic [9:0] led;

wire t1;

clk_div_jenna div(.clk(clk), .sclk(t1));
TorpedoLED fire(.clk(t1), .enter(enter), .led(led));

endmodule