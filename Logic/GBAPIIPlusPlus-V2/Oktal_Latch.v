`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:48:21 07/06/2014 
// Design Name: 
// Module Name:    Oktal_Latch 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Oktal_Latch( input [7:0] in, output [7:0] out, input latchenable, input outputenable
    );
   
   reg         [7:0] buff   = 8'b1;

   // Tristate based on outputenable
   assign out = (outputenable) ? 8'bz : buff;
      
   // Set registers when latchenable is high
   always @ * begin
      if (latchenable) begin
         buff <= in;
      end      
   end // always @ *
      
endmodule