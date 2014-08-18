//////////////////////////////////////////////////////////////////////////////////
// Company: A1k
// Engineer: Matthias Heinrichs
// 
// Create Date:    12:17:53 07/06/2014 
// Design Name: 	
// Module Name:    GBAPIIPlusPlus 
// Project Name: 	 A500 Graphic card
// Target Devices: XL9572/144
// Tool versions: 14.6 - x64
// Description: 
//
// Dependencies: Hex_latch, Oktal_Latch, Tri_latch
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Let's rock!
//
//////////////////////////////////////////////////////////////////////////////////
module GBAPIIPlusPlus( 
	inout [15:0] DA,	//Amiga data bus
	inout [15:0] DG, 	//VGA data bus
	input [23:0] A, 	//Amiga address bus NOTE: only A23-A15, A12 and A6-A1 are connected!
	input AS,			//Amiga address strobe
	input UDS, 			//Amiga upper data strobe D[15:8]
	input LDS, 			//Amiga lower data strobe D[7:0]
	input RW,			//Amiga RW-Line 1= Read 0=Write
	input BERR,			//Amiga bus error signal
	input CFGIN,		//Amiga AutoConfigIn 0=active
	input reset,		//Amiga reset
	input mclk,			//VGA- clock 50Mhz
	input WAIT,			//VGA wait
	output [3:1] IO,	//spare IO pins: IO3 is a solder jumper
	output SLAVE,		//Amiga signal: slave active
	output CFGOUT,		//Amiga signal: Config out
	output XRDYD,		//Amiga signal not ready (Zorro bus wait)
	output MONISW,//Signal for monitor switch: 1= Amiga, 0= VGA
	output SA0,	//VGA address 0
	output SA12,	//VGA address 12
	output IOR,	//VGA IO read
	output IOW,	//VGA IO write
	output MEMR,	//VGA memory read
	output MEMW,	//VGA memory write
	output BALE,		//VGA Bus address latch enable
	output CLRG			//VGA reset
    );


	wire autoconfig, ioSelect, memSelect;
	wire [7:0] highAddr;
	wire [5:0] lowAddr;
	
	wire [15:0] autoConfigDataWide;

	reg AS_D0;
	reg autoConfigAdrHit, ioAdrHit, memAdrHit;
	reg [3:0] vgaStatemachine;
	reg sigBALE;
	reg sigIOR;
	reg sigIOW;
	reg sigMEMR;
	reg sigMEMW;
	reg sigXRDY;
	reg sigMONITORSW; //Monitor switch 0= Amiga 1= VGA
	reg [1:0] autoconfigDone;
	reg [3:0] autoConfigDataOut;
	reg shutUp;
	reg [7:0] ioSpace;
	reg [2:0] memSpace;
	reg sigConfigOut;
	reg ds; //datastrobe indicator
	reg [15:0] DA_R;
	reg [15:0] DG_R;
	reg sigSA0;
	reg sigSA12;
		
	//assigns
	assign highAddr	= A[23:16];
	assign lowAddr		= A[6:1];
	//assign boardSelect = memSelect == 1  || ioSelect == 1 ? 1 : 0;
	assign autoconfig = autoConfigAdrHit == 1       	 		&& AS == 0 ? 1 : 0;
	assign memSelect 	= memAdrHit	== 1								&& AS == 0 ? 1 : 0;
	assign ioSelect 	= ioAdrHit	== 1								&& AS == 0 ? 1 : 0;
	//assign autoconfig = highAddr == 8'hE8 && autoconfigDone != 2'b11 && CFGIN == 0	&& correctAS == 1 && ds ==1? 1:0;
	//assign memSelect 	= A[23:21] == memSpace && shutUp == 1'b0 && autoconfigDone[0] == 1'b1			&& correctAS == 1 ? 1:0;
	//assign ioSelect 	= highAddr == ioSpace  && shutUp == 1'b0 && autoconfigDone[1] == 1'b1			&& correctAS == 1 ? 1:0;

	assign CFGOUT		= sigConfigOut;
	assign SLAVE		= memAdrHit == 1  || ioAdrHit == 1 || autoConfigAdrHit ==1 ? 0 : 1'bz;
	assign CLRG			= reset;
	assign autoConfigDataWide = {autoConfigDataOut, 12'b1};
	assign MONISW		= sigMONITORSW;

	//assign IO[1]		= memAdrHit;
	//assign IO[2]		= ioAdrHit;
	assign IO[3]		= sigBALE;

	assign BALE			= sigBALE;
	//assign XRDYD		= vgaStatemachine ==4'h0 ? 1'bz : sigXRDY;
	assign XRDYD		= sigXRDY;
	//assign XRDYD		= sigXRDY==1 ? 1'bz : 1'b0;
	
	assign IOW			= sigIOW;
	assign IOR			= sigIOR;
	assign MEMW			= sigMEMW;
	assign MEMR			= sigMEMR;
	//assign DG			= DG_R;
	//assign DA			= DA_R;
	assign DG[15:0]	= (RW == 0 && (memAdrHit == 1  || ioAdrHit ==1))? DG_R : 16'bz; 
	assign DA[15:0]	= (RW == 1 && (autoConfigAdrHit == 1))? autoConfigDataWide : ( RW == 1 && (memAdrHit == 1  || ioAdrHit ==1) ? DA_R : 16'bz);

	//assign SA0			= ioSelect ==1 ? (A[12] || UDS ? 1 : 0) : UDS;
	//assign SA12			= ioSelect ==1 ? 0 : A[12];
	//assign SA0			= (ioAdrHit ==1 && A[12] == 1) || UDS == 1 ? 1 : 0;
	//assign SA12			= ioAdrHit ==1 || A[12] == 0 ? 0 : 1;

	assign SA0			= sigSA0;
	assign SA12			= sigSA12;

	//memdecode
	always @(negedge mclk, negedge reset)	
	begin
		if(reset==0) begin
			AS_D0					<= 1;
		end
		else begin //decode the address on every as-strobe and hold it until next as-strobe
			
			AS_D0	<= AS;
		end
	end
	
	// state/waitemachine VGA access
	always @(posedge mclk, negedge reset)
	begin
		if( reset == 0 ) begin// async reset
			vgaStatemachine <= 4'h0;
			sigBALE			<= 1;
			sigIOR			<= 1;
			sigIOW			<= 1;
			sigMEMR			<= 1;
			sigMEMW			<= 1;
			sigXRDY			<= 1;
			sigMONITORSW	<= 1;
			sigSA0			<= 1;
			sigSA12			<= 1;			
			DG_R				<= 16'b1;			
			DA_R				<= 16'b1;
			autoConfigAdrHit 	<= 0;
			memAdrHit 			<= 0;
			ioAdrHit 			<= 0;
			ds						<= 0;
		end
		else begin// beginning of statemachine
			
			ds <= LDS==0 || UDS==0; //datastrobe indicator

			if(highAddr == 8'hE8 && autoconfigDone != 2'b11 && CFGIN == 0 && BERR ==1 && reset == 1 && AS==0 && (LDS==0 || UDS==0)) begin //ac hit
				autoConfigAdrHit 	<= 1;
				memAdrHit 			<= 0;
				ioAdrHit 			<= 0;
			end
			else if (A[23:21] == memSpace && shutUp == 1'b0 && BERR ==1 && reset == 1 && AS==0) begin //mem hit
				autoConfigAdrHit 	<= 0;
				memAdrHit 			<= 1;
				ioAdrHit 			<= 0;
			end
			else if (highAddr == ioSpace  && shutUp == 1'b0 && BERR ==1 && reset == 1 && AS==0) begin //io hit
				autoConfigAdrHit 	<= 0;
				memAdrHit 			<= 0;
				ioAdrHit 			<= 1;
			end
			else begin // no hit
				autoConfigAdrHit 	<= 0;
				memAdrHit 			<= 0;
				ioAdrHit 			<= 0;
			end

		
			//statemachine
			case(vgaStatemachine)
				4'h0: // 1: wait for start
					if(memAdrHit == 1  || ioAdrHit == 1) begin
						sigXRDY <= 0;
						vgaStatemachine <= 4'h2;	//because the memAdrHit and ioAdrHit are delayed by one clock jump to state 2 immediately!
					end
					else begin
						sigBALE	<=1;
						sigIOR	<=1;
						sigIOW	<=1;
						sigMEMR	<=1;
						sigMEMW	<=1;
						sigXRDY	<=1;					
					end
				4'h1: // 2: just tansit
					vgaStatemachine <= 4'h2;
				4'h2: // 3:wait for datastrobe
					if(ds == 1) begin // on write we loose a clock here again!
						vgaStatemachine <= 4'h3;	
						//determine the addess lines
						if( memAdrHit == 1) begin
							sigSA0	<= UDS;
							sigSA12	<= A[12];
						end
						else if(ioAdrHit == 1) begin
							sigSA0	<= A[12] || UDS;
							sigSA12	<= 0;						
						end
					end
				4'h3: // 3:just transit
					begin
						vgaStatemachine <= 4'h4;
						//buffer the write data
						if(RW == 0) begin
							DG_R		<=  DA;
							vgaStatemachine <= 4'h5; //compensate the lost clock from above!
						end
						else begin
							vgaStatemachine <= 4'h4;
						end
					end
				4'h4: // 4:just transit
					vgaStatemachine <= 4'h5;
				4'h5:// 5:just transit
					begin
						//start of vga-memcycle
						sigBALE	<= 0;
						vgaStatemachine <= 4'h6;
					end
				4'h6:// 6:just transit
					begin
						//determine read or write and io or mem
						if(RW == 1) begin//read
							sigIOR	<= ~ioAdrHit; // just the invertion of the signals
							sigMEMR	<= ~memAdrHit;
						end
						else begin//write
							sigIOW	<= ~ioAdrHit; // just the invertion of the signals
							sigMEMW	<= ~memAdrHit;
							if(ioAdrHit == 1 && A[15] == 1 && UDS == 0)begin //monitor switch
								sigMONITORSW <= A[12];
							end												
						end
						vgaStatemachine <= 4'h7;
					end
				4'h7:// 7:just transit
					vgaStatemachine <= 4'h8;
				4'h8:// 8:just transit
					vgaStatemachine <= 4'h9;
				4'h9:// 9: wait for mem ready or for io: just transit
					if(ioAdrHit == 1 || WAIT == 1 ) begin//mem ready or IO selected
						vgaStatemachine <= 4'hA;
					end
				4'hA://10: just transit
					begin
						vgaStatemachine <= 4'hB;
						sigXRDY <= 1;
					end
				4'hB://11: just transit
					begin
						//end of write
						sigIOW	<= 1;
						sigMEMW	<= 1;
						vgaStatemachine <= 4'hC;
						if(RW==1)begin
							DA_R	<= DG;
						end
					end
				4'hC://12: just transit
					begin
						//end of read
						sigIOR	<= 1;
						sigMEMR	<= 1;
						vgaStatemachine <= 4'hD;
					end	
						
				4'hD://13: just transit
					begin
						//end of vga-memcycle
						sigBALE	<= 1;
						sigSA0	<= 1;
						sigSA12	<= 1;
						vgaStatemachine <= 4'hE;
					end
				4'hE://14: just transit
					begin
						DG_R				<= 16'b1;	//reset the data
						vgaStatemachine <= 4'hF;
					end
				4'hF://15: wait for end of cycle
					if(ioAdrHit == 0 && memAdrHit == 0) begin
						DA_R	<= 16'b1;
						vgaStatemachine <= 4'h0;						
					end
			endcase
		end
	end

	// autoconfig data forming
	always @(posedge autoConfigAdrHit, negedge reset)
	begin
		if( reset == 0 ) begin//async reset
			autoconfigDone  	<= 2'b0; // start autoconfig			
			shutUp	 			<= 1'b1; // shut up for now		
			ioSpace				<= 8'hFF;
			memSpace				<= 3'b111;
		end
		else begin// sync beginning of cycle
			
			if(RW == 1) begin
				case( lowAddr )
					6'b000000: // $00
						autoConfigDataOut <= 4'hC;		//Zorro II (2 bit), No Mem, no ROM
						//autoConfigDataOut <= 4'hE;		//Zorro II (2 bit), Mem, no ROM
					6'b000001: // $02
						if(autoconfigDone[0] == 0)
							autoConfigDataOut <= 4'hE; // 2. config, 2M (3 bit)
						else
							autoConfigDataOut <= 4'h1; // 64kb IO-space						
					6'b000010: // $04
						autoConfigDataOut <= 4'hE;
					6'b000011: // $06
						if(autoconfigDone[0] == 0)
							autoConfigDataOut <= 4'hF; // 04 =11 / 0E0F = 16
						else
							autoConfigDataOut <= 4'hE; // 03 =12 / 0E0E = 17
					6'b000100: // $08
						autoConfigDataOut <= 4'hF;
					6'b000101: // $0a
						autoConfigDataOut <= 4'hF;

					6'b001000: // $10
						autoConfigDataOut <= 4'hF;
					6'b001001: // $12
						autoConfigDataOut <= 4'h7;

					6'b001010: // $14
						autoConfigDataOut <= 4'h8; //eigene ID
					6'b001011: // $16
						autoConfigDataOut <= 4'h8;

					6'b001100: // $18			er_Serial - invert all (Byte 0, MSB)
						autoConfigDataOut <= 4'hF;
					6'b001101: // $1A
						autoConfigDataOut <= 4'hF;
					6'b001110: // $1C			(Byte 1)
						autoConfigDataOut <= 4'hF;
					6'b001111: // $1E
						autoConfigDataOut <= 4'hC;
					6'b010000: // $20			(Byte 2)
						autoConfigDataOut <= 4'hF;
					6'b010001: // $22
						autoConfigDataOut <= 4'hF;
					6'b010010: // $24			(Byte 3, LSB)
						autoConfigDataOut <= 4'hF;
					6'b010011: // $26
						autoConfigDataOut <= 4'hF;
					6'b100000: // $40
						autoConfigDataOut <= 4'b0000;
					6'b100001: // $42
						autoConfigDataOut <= 4'b0000;
					default:
						autoConfigDataOut <= 4'b1111;						
				endcase	
			end
			else if(RW == 0 && lowAddr == 6'b100100) begin// $48: write base address
					if( autoconfigDone == 2'b00) begin //base address for mem space							
						memSpace	<= DA[15:13];
						autoconfigDone <= 2'b01;
					end
					else begin //base address for io space
						ioSpace	<= DA[15:8];
						autoconfigDone <= 2'b11; 
						shutUp <= 1'b0;
					end
				end
			else if(RW == 0 && lowAddr == 6'b100110) begin// $4C: any write here causes shut up of the whole board!
					autoconfigDone <= 2'b11;
					shutUp <= 1'b1;
				end
			end
	end
	
	//config out has to be sampled AFTER the address-strobe, which fnishes the co config
	
		//config out generattion AFTER the adressstrobe!
	always @(posedge AS, negedge reset)
	begin
		if (reset ==0) begin // after reset
			sigConfigOut <= 1'b1;
		end
		else begin
			sigConfigOut <= autoconfigDone == 2'b11 ? 0 : 1;			
		end
			
	end
endmodule
