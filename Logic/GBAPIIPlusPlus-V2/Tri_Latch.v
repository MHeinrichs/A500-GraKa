//////////////////////////////////////////////////////////////////////////////////
// Company: A1k
// Engineer: Matthias Heinrichs
// 
// Create Date:    12:17:53 07/06/2014 
// Design Name: 	
// Module Name:    Tri_Latch 
// Project Name: 	 A500 Graphic card
// Target Devices: XL9572/144
// Tool versions: 14.6 - x64
// Description: A tri latch for bus adaptation
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Tri_Latch( input [2:0] in, output [2:0] out, input latchenable, input outputenable
    );
   
   reg         [2:0] buff   = 3'b1;

   // Tristate based on outputenable
   assign out = (outputenable) ? 3'bz : buff;
      
   // Set registers when latchenable is high
   always @ * begin
      if (latchenable) begin
         buff <= in;
      end      
   end // always @ *
      
endmodule