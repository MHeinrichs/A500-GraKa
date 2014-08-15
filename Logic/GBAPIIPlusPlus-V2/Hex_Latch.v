//////////////////////////////////////////////////////////////////////////////////
// Company: A1k
// Engineer: Matthias Heinrichs
// 
// Create Date:    12:17:53 07/06/2014 
// Design Name: 	
// Module Name:    Hex_Latch 
// Project Name: 	 A500 Graphic card
// Target Devices: XL9572/144
// Tool versions: 14.6 - x64
// Description: A hexadecimal latch for bus adaptation
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Hex_Latch( input [15:0] in, output [15:0] out, input latchenable, input outputenable
    );
   
   reg         [15:0] buff   = 16'b1;

   // Tristate based on outputenable
   assign out = (outputenable) ? 16'bz : buff;
      
   // Set registers when latchenable is high
   always @ * begin
      if (latchenable) begin
         buff <= in;
      end      
   end // always @ *
      
endmodule