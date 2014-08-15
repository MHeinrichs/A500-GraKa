`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:37:48 07/09/2014
// Design Name:   GBAPIIPlusPlus
// Module Name:   C:/Users/Matze/Documents/GitHub/A500-Graka/Logic/GBAPIIPlusPlus-V2/AutoConfigTest.v
// Project Name:  GBAPIIPlusPlus-V2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: GBAPIIPlusPlus
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module AutoConfigTest;

	// Inputs
	reg [23:0] A;
	reg AS;
	reg UDS;
	reg LDS;
	reg RW;
	reg BERR;
	reg CFGIN;
	reg reset;
	reg mclk;
	reg WAIT;
	reg [3:1] IO;

	// Outputs
	wire SLAVE;
	wire CFGOUT;
	wire XRDYD;
	wire MONISW;
	wire SA0;
	wire SA12;
	wire IOR;
	wire IOW;
	wire MEMR;
	wire MEMW;
	wire BALE;
	wire CLRG;

	// Bidirs
	wire [15:0] DA;
	wire [15:0] DG;

	// Instantiate the Unit Under Test (UUT)
	GBAPIIPlusPlus uut (
		.DA(DA), 
		.DG(DG), 
		.A(A), 
		.AS(AS), 
		.UDS(UDS), 
		.LDS(LDS), 
		.RW(RW), 
		.BERR(BERR), 
		.CFGIN(CFGIN), 
		.reset(reset), 
		.mclk(mclk), 
		.WAIT(WAIT), 
		.IO(IO), 
		.SLAVE(SLAVE), 
		.CFGOUT(CFGOUT), 
		.XRDYD(XRDYD), 
		.MONISW(MONISW), 
		.SA0(SA0), 
		.SA12(SA12), 
		.IOR(IOR), 
		.IOW(IOW), 
		.MEMR(MEMR), 
		.MEMW(MEMW), 
		.BALE(BALE), 
		.CLRG(CLRG)
	);
	
	
	reg [15:0]data;
	
	assign DA = RW==0? data : 16'bz;
	assign DG = MEMR ==0 || IOR == 0?  data : 16'bz;
	initial begin
		//the clock
		mclk = 0;
		forever	#1  mclk =  ! mclk;
	end

	initial begin
		// Initialize Inputs
		A = 0;
		AS = 0;
		UDS = 0;
		LDS = 0;
		RW = 0;
		BERR = 0;
		CFGIN = 0;
		reset = 0;
		WAIT = 1;
		IO = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Prepare the system
		AS		= 1;
		UDS 	= 1;
		LDS 	= 1;
		RW 	= 1;
		BERR 	= 1;
		CFGIN = 1;
		reset = 1;
		
		// Wait 100 ns for system
		#10;


		#10 CFGIN = 0;
		#10 A[23:8] = 16'hE800;		
		//read the autoconfig values for config 1
		#10 
		AS=1;
		UDS=1;
		RW =1;		
		A[7:0]=8'h000;
		#10 
		AS=0;
		UDS=0;		
		#10
		AS=1;
		UDS=1;
		A[7:0]=8'h02;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h04;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h06;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h08;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h0A;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h10;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h12;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h14;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h16;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h18;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1A;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1C;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1E;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h20;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h22;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h24;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h26;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h40;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h42;
		#10 
		AS=0;
		UDS=0;
		#10;

		//now write the first base address!
		AS=1;
		UDS=1;
		A[7:0]=8'h48;
		data=16'h2000;
		#10 
		AS=0;
		RW=0;
		#10;
		UDS=0;
		#10;
		
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 
		
		
		//read the autoconfig values for config 2
		#10 
		AS=1;
		UDS=1;
		RW =1;
		A[7:0]=8'h000;
		#10 
		AS=0;
		UDS=0;		
		#10
		AS=1;
		UDS=1;
		A[7:0]=8'h02;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h04;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h06;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h08;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h0A;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h10;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h12;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h14;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h16;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h18;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1A;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1C;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1E;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h20;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h22;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h24;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h26;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h40;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h42;
		#10 
		AS=0;
		UDS=0;
		#10;

		//now write the second base address!
		AS=1;
		UDS=1;
		A[7:0]=8'h48;
		data=16'hE900;
		#10 
		AS=0;
		RW=0;
		#10;
		UDS=0;
		#10;
		
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		 
		
		//read the autoconfig values for a potential 3rd board
		#10 
		AS=1;
		UDS=1;
		RW =1;
		A[7:0]=8'h000;
		#10 
		AS=0;
		UDS=0;		
		#10
		AS=1;
		UDS=1;
		A[7:0]=8'h02;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h04;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h06;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h08;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h0A;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h10;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h12;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h14;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h16;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h18;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1A;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1C;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h1E;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h20;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h22;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h24;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h26;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h40;
		#10 
		AS=0;
		UDS=0;
		#10;
		AS=1;
		UDS=1;
		A[7:0]=8'h42;
		#10 
		AS=0;
		UDS=0;
		#10;

		//now write the 3rd base address!
		AS=1;
		UDS=1;
		A[7:0]=8'h48;
		data=16'hEA00;
		#10 
		AS=0;
		RW=0;
		#10;
		UDS=0;
		#10;
		
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		
		
		//now write something to memory
		AS=1;
		UDS=1;
		A[23:0]=24'h200000;
		data=16'hEA00;
		#10 
		AS=0;
		WAIT=0;
		RW=0;
		#10;
		UDS=0;
		#30
		WAIT=1;
		#100;
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		

		//now read something form memory
		AS=1;
		UDS=1;
		A[23:0]=24'h200000;
		#10 
		AS=0;
		WAIT=0;
		UDS=0;
		RW=1;
		#30
		WAIT=1;
		#100;
		
		//now write something to io
		AS=1;
		UDS=1;
		A[23:0]=24'hE90000;
		data=16'hEA00;
		#10 
		AS=0;
		RW=0;
		#10;
		UDS=0;
		#100;
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		

		//now read something form io
		AS=1;
		UDS=1;
		A[23:0]=24'hE90000;
		#10 
		AS=0;
		UDS=0;
		RW=1;
		#100;
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		

		//now write minitor switch enable
		AS=1;
		UDS=1;
		A[23:0]=24'hE90000;
		A[15] = 1; //write to monitor
		A[12] = 0; //0 = vga on 1= amiga on
		#10 
		AS=0;
		RW=0;
		#10;
		UDS=0;
		#100;
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		

		//now write minitor switch disable
		AS=1;
		UDS=1;
		A[23:0]=24'hE90000;
		A[15] = 1; //write to monitor
		A[12] = 1; //0 = vga on 1= amiga on
		#10 
		AS=0;
		RW=0;
		#10;
		UDS=0;
		#100;
		//end
		AS=1;
		UDS=1;
		RW=1;
		#10; 		
			
		//end
		AS=1;
		UDS=1;
		RW=1;
		A[23:0]=24'bz;
		#10; 		
		$stop;
	end

		
      
endmodule

