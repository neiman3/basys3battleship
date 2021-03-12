`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2021 09:38:39 PM
// Design Name: 
// Module Name: Battleship
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


module Battleship(
//    input [15:0] sw,
    input clk,
    input up,
    input down,
    input left,
    input right,
    input ok,
//    input sw1,
//    input sw2,
    output [7:0] DisplayOutput,
    output [3:0] an,
//    output [2:0] p1scoreboard,
//    output [2:0] p2scoreboard
    output logic [15:0] led
    );
    
    // clocks for top module
    logic clk_2;
    clk_div_2 clk_div_2 (.clk(clk), .sclk(clk_2));
    
    // game data logic
    logic [27:0]
        p1_ships = 28'b0,
        p1_ships_new = 28'b0,
        p1_ships_sunk = 28'b0, // these are not "sunk" ships. It is simply just an upda
        p2_ships = 28'b0,
        p2_ships_new = 28'b0,
        p1_torps = 28'b0,
        p1_torps_new = 28'b0,
        p2_torps = 28'b0,
        p2_torps_new = 28'b0,
        tship1, tship2, tship3, tship4,
        tship5, tship6, tship7;
    logic p1_ships_load, p2_ships_load, p1_torps_load, p2_torps_load, t8;
    Battleship_ShipAdder ShipAdder (.ship1(tship1), .ship2(tship2), .ship3(tship3), .shipout(tship4));
    Torpedo ShipSinker (.playerInitial(tship5), .torpedo(tship6), .playerFinal(tship7), .hit(t8)); // t8 is hit or miss status
//    Battleship_ShipSinker ShipSinker (.ships(tship5), .torps(tship6), .shipout(tship7));
    
    logic [1:0] p1_ships_num, p2_ships_num;
    logic [2:0] p1_scoreboard, p2_scoreboard;
    Battleship_ShipCounter ShipCounterp1 (.ships(p1_ships), .count(p1_ships_num));
    Battleship_ShipCounter ShipCounterp2 (.ships(p2_ships), .count(p2_ships_num));
    
    logic [9:0] t12, t13; // led output for sparkle
    logic t14; // enable torpedo animation
    
    logic dup, ddown, dleft, dright, dok; // debounced
    BattleshipDebounce upDebouncer (.in(up), .out(dup), .clk(clk));
    BattleshipDebounce downDebouncer (.in(down), .out(ddown), .clk(clk));
    BattleshipDebounce leftDebouncer (.in(left), .out(dleft), .clk(clk));
    BattleshipDebounce rightDebouncer (.in(right), .out(dright), .clk(clk));
    BattleshipDebounce okDebouncer (.in(ok), .out(dok), .clk(clk));
    TorpedoLEDTop LedSparkler (.clk(clk), .enter(dok&t14&~t8), .led(t12));
    //enable hit with t8
    // Scrollers for all game text
    logic [27:0] t1, t9, t10;
    Battleship_Scroller4 WelcomeScroller (.clk(clk), .screen1(28'b1111100101111111011001101000), .screen2(28'b0111101101110010010001001111), .screen3(28'b1001111100010011011010111101), .screen4(28'b0111101110110010001001101100), .ships(t1));
    Battleship_Scroller4 P1WinScroll (.clk(clk), .screen1(28'b0000000100111110010000000000), .screen2(28'b0000000111011011100001111100), .screen3(28'b0000000100111111001110000000), .screen4(28'b1101000111010001111011101101), .ships(t9));
    Battleship_Scroller4 P2WinScroll (.clk(clk), .screen1(28'b0000000100111111001110000000), .screen2(28'b0000000111011011100001111100), .screen3(28'b0000000100111110010000000000), .screen4(28'b1101000111010001111011101101), .ships(t10));
    
    // cursor navigator. Use tester as the new cursor selector.
    logic [27:0] t2;
    logic t11; // reset signal for cursor
    Battleship_Tester Cursor (.dup(dup), .ddown(ddown), .dleft(dleft), .dright(dright), .dok(dok), .rst(t11), .ships(t2), .clk(clk));

    // Display out
    logic [27:0] ships; // ships is the displayout variable
    Battleship_ShipDisplay ShipDisplay (.DisplayOutput(DisplayOutput), .an(an), .clk(clk), .ships(ships));
//    Battleship_ShipDisplay ShipDisplay (.DisplayOutput(DisplayOutput), .an(an), .clk(clk), .ships(28'b1011111110100011011011011110));
//    Battleship_Cursor Cursor (.up(dup), .down(ddown), .left(dleft), .right(dright), .ships(t2), .clk(clk));
//    Battleship_Cursor_Decoder decoder (.current_position(sw[13:11]), .current_sector(sw[15:14]), .ships(t1));
//    Battleship_Tester Tester (.dup(dup), .ddown(ddown), .dleft(dleft), .dright(dright), .ships(t1), .clk(clk));
    
    // state machine control
    parameter [4:0]
        StA = 5'd0,     // Start screen "batl ship pres ok"
        StB = 5'd1,     // "p1"
        StC = 5'd2,     // p1's ship 1
        StD = 5'd3,     // p1's ship 2
        StE = 5'd4,     // p1's ship 3
        StF = 5'd5,     // p2's ship 1
        StG = 5'd6,     // p2's ship 2
        StH = 5'd7,     // p2's ship 3
        StI = 5'd8,     // "strt"
        StJ = 5'd9,     // p1's turn
        StK = 5'd10,    // p1 calc
        StL = 5'd11,    // p2's turn
        StM = 5'd12,    // p2 calc
        StN = 5'd13,    // winner winner chicken dinner
        StO = 5'd14,
        StP = 5'd15,
        StQ = 5'd16,
        StR = 5'd17,
        StS = 5'd18,
        StT = 5'd19,
        StU = 5'd20,
        StV = 5'd21,
        StW = 5'd22;
    logic [4:0] ps = 5'b0, ns = 5'b0;
    logic proceed = 1'b1;
    
    always_ff @ (posedge dok) begin
        if (proceed) begin
            ps = ns;
        end
        if (p1_ships_load) begin p1_ships = p1_ships_new; end
        if (p2_ships_load) begin p2_ships = p2_ships_new; end
        if (p1_torps_load) begin p1_torps = p1_torps_new; end
        if (p2_torps_load) begin p2_torps = p2_torps_new; end
    end
    
    always_comb begin
        case (ps)
            StA: begin // start screen is rotating
                p1_ships_new = 28'b0;
                p1_ships_load = 1'b1;
                p2_ships_new = 28'b0;
                p2_ships_load = 1'b1;
                p1_torps_new = 28'b0;
                p1_torps_load = 1'b1;
                p2_torps_new = 28'b0;
                p2_torps_load = 1'b1;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = t1;
                ns = StB;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
             end
             StB: begin // waiting for p1 to press ok
                p1_ships_new = 28'b0;
                p1_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p1_torps_new = 28'b0;
                p1_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1001111100100000000000010010; // "p1 1"
                ns = StC;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StC: begin // p1 select first ship.
                p1_ships_new = t2;
                p1_ships_load = 1'b1;
                p2_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p1_torps_new = 28'b0;
                p1_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                if (clk_2) begin
                    ships = t2;
                end else begin
                    ships = 1'b0;
                end
                ns = StD;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StD: begin // p1 enter ship 2. load ship 1
                p1_ships_load = 1'b0; // load ships
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1001111100100000000001100111;
                ns = StE;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
            
            StE: begin // p1 ship select
                p1_ships_load = 1'b1; // load ships
                p1_ships_new = tship4;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p1_ships;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                if (clk_2) begin
                    ships = tship4;
                end else begin
                    ships = p1_ships;
                end
                ns = StF;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StF: begin
                p1_ships_load = 1'b0; // load ships
                p1_ships_new = tship4;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p1_ships;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1001111100100000000000110111;
                ns = StG;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
            
            StG: begin
                p1_ships_load = 1'b1; // load ships
                p1_ships_new = tship4;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p1_ships;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                if (clk_2) begin
                    ships = tship4;
                end else begin
                    ships = p1_ships;
                end
                ns = StH;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StH: begin // p2's turn to load ships
                p1_ships_load = 1'b0; // load ships
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p1_ships;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1001111110011100000001001000;
                ns = StI;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
            
            StI: begin
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b1;
                p2_ships_new = t2;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                if (clk_2) begin
                    ships = t2;
                end else begin
                    ships = 28'b0;
                end
                ns = StJ;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StJ: begin
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1001111110011100000001100111;
                ns = StK;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
            
            StK: begin 
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b1;
                p2_ships_new = tship4;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p2_ships;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                if (clk_2) begin
                    ships = tship4;
                end else begin
                    ships = p2_ships;
                end
                ns = StL;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StL: begin
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1001111110011100000000110111;
                ns = StM;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
            
            StM: begin 
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b1;
                p2_ships_new = tship4;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p2_ships;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                if (clk_2) begin
                    ships = tship4;
                end else begin
                    ships = p2_ships;
                end
                ns = StN;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            // here we begin the gameplay.
            
            StN: begin
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b0000000100111110010000000000; // begin p1's turn
                ns = StO;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
            
            StO: begin // p1 fires
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b1;
                p2_ships_new = tship7;
                p1_torps_load = 1'b1;
                p1_torps_new = tship4;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = p1_torps;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = p2_ships;
                tship6 = tship4;
                if(dup) begin
                    ships = p1_torps;
                end else if (dright) begin
                    ships = p1_ships;
                end else begin
                    if (clk_2) begin
                        ships = t2;
                    end else begin
                        ships = 28'b0;
                    end
                end
                if (t8) begin
                    if (tship7 == 28'b0) begin
                        ns = StV;
                    end else begin
                        ns = StP;
                    end
                end else begin
                    ns = StQ;
                end
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StP: begin // hit
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1011100100100011011000000000; // begin p2's turn
                ns = StR;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd1;
            end
            
            
            
            StQ: begin // miss
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b0100101010010101001010100101; // begin p2's turn
                ns = StR;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd1;
            end
            
            StR: begin// p2's turn
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b0000000100111111001110000000; // begin p2's turn
                ns = StS;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StS: begin // p2 fires
                p1_ships_load = 1'b1;
                p1_ships_new = tship7;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b1;
                p2_torps_new = tship4;
                tship1 = p2_torps;
                tship2 = t2;
                tship3 = 28'b0;
                tship5 = p1_ships;
                tship6 = tship4;
                if(dup) begin
                    ships = p2_torps;
                end else if (dright) begin
                    ships = p2_ships;
                end else begin
                    if (clk_2) begin
                        ships = t2;
                    end else begin
                        ships = 28'b0;
                    end
                end
                if (t8) begin
                    if (tship7 == 28'b0) begin
                        ns = StW;
                    end else begin
                        ns = StT;
                    end
                end else begin
                    ns = StU;
                end
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StT: begin// hit
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b1011100100100011011000000000; // begin p2's turn
                ns = StN;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd1;
            end
            
            
            StU: begin// miss
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b0100101010010101001010100101; // begin p2's turn
                ns = StN;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd1;
            end
            
            StV: begin // p1 won
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = t9;
                ns = StA;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            StW: begin // p2 won
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = t10; // begin p2's turn
                ns = StA;
                proceed = 1'b1;
                t11 = 1'd0;
                t14 = 1'd0;
            end
            
            default: begin
                p1_ships_load = 1'b0;
                p1_ships_new = 28'b0;
                p2_ships_load = 1'b0;
                p2_ships_new = 28'b0;
                p1_torps_load = 1'b0;
                p1_torps_new = 28'b0;
                p2_torps_load = 1'b0;
                p2_torps_new = 28'b0;
                tship1 = 28'b0;
                tship2 = 28'b0;
                tship3 = 28'b0;
                tship5 = 28'b0;
                tship6 = 28'b0;
                ships = 28'b0;
                ns = StA;
                proceed = 1'b1;
                t11 = 1'd1;
                t14 = 1'd0;
            end
                
                
        endcase
        
        case (p1_ships_num)
            2'd0: begin p1_scoreboard = 3'b000; end
            2'd1: begin p1_scoreboard = 3'b100; end
            2'd2: begin p1_scoreboard = 3'b110; end
            2'd3: begin p1_scoreboard = 3'b111; end
        endcase
        case (p2_ships_num)
            2'd0: begin p2_scoreboard = 3'b000; end
            2'd1: begin p2_scoreboard = 3'b001; end
            2'd2: begin p2_scoreboard = 3'b011; end
            2'd3: begin p2_scoreboard = 3'b111; end
        endcase
        
        led = {p1_scoreboard,t12,p2_scoreboard};
            
            
        
        
    end
    
    
    
endmodule
