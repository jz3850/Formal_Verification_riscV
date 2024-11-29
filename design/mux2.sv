`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: mux2
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


module mux2
    #(parameter WIDTH = 32)
    (input logic [WIDTH-1:0] d0, d1,
     input logic s,
     output logic [WIDTH-1:0] y);

assign y = s ? d1 : d0;

assert property (@(*)
    (s == 1'b0) |-> (y == d0)
) else $error("When s is 0, y should be equal to d0");

assert property (@(*)
    (s == 1'b1) |-> (y == d1)
) else $error("When s is 1, y should be equal to d1");
endmodule
