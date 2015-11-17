module Queues (
	input 			clk, rst_n,
	input [15:0] 	newsmpl,
	input 			wrt_smpl,
	output [15:0] 	smpl_out,
	output 			sequencing
);

/* ------ Define any internal variables ------------------------------------------------------------- */
/*	Pointers designated as 'new' signify where the array is going to be written to
	Pointers designated as 'old' signify where the array is going to read from */
reg [10:0] 		hiArray[1535:0], lowArray[1023:0]; 
wire 			data_wr, data_rd;

// Declare pointers for high band and low band queues
reg [10:0] 		lowNew_ptr, lowOld_ptr, lowNext_new, lowNext_old;
reg [10:0] 		hiNew_ptr, hiOld_ptr, hiNext_new, hiNext_old;

// Declare status registers for high and low queues
//// Define low frequency Registers 
reg 			lowFull_reg, lowEmpty_reg, lowFull_next, lowEmpty_next;

//// Define high frequency registers 
reg 			hiFull_reg, hiEmpty_reg, hiFull_next, hiEmpty_next;

/* ------ Instantiate the dual port modules -------------------------------------------------------- */
// Low frequency module connections 
reg [9:0] 		lowWaddr, lowRadder;
reg [15:0] 		lowWdata;
wire [15:0] 	lowRdata;

// High frequency module connections 
reg [10:0] 		hiWaddr, hiRadder;
reg [15:0] 		hiWdata;
wire [15:0] 	hiRdata;

// Instantiate the modules
dualPort1024x16 i1024Port(.clk(clk),.we(we),.waddr(lowWaddr),.raddr(lowRaddr),.wdata(lowWdata),.rdata(lowRdata));
dualPort1536x16 i1536Port(.clk(clk),.we(we),.waddr(hiWaddr),.raddr(hiRaddr),.wdata(hiWdata),.rdata(hiRdata));

/* ----- Always Block to Update States ------------------------------------------------------------ */
always @(posedge clk) begin 
	if(!rst_n) begin
		// Reset Pointers
		lowNew_ptr <= 10'h000;
		lowOld_ptr <= 10'h000;
		hiNew_ptr <= 10'h000;
		hiOld_ptr <= 10'h000;
		// Reset Empty/full definitions
		lowFull_reg <= 1'b0;
		lowEmpty_reg <= 1'b1;
		hiFull_reg <= 1'b0;
		hiEmpty_reg <= 1'b1;
	end else begin
		// Set Pointers
		lowNew_ptr <= lowNext_new;
		lowOld_ptr <= lowNext_old;
		hiNew_ptr <= hiNext_new;
		hiOld_ptr <= hiNext_old;
		// Set Empty/full definitions
		lowFull_reg <= lowFull_next;
		lowEmpty_reg <= lowEmpty_next;
		hiFull_reg <= hiFull_next;
		hiEmpty_reg <= hiEmpty_next;
	end
end
	
	
	
	
endmodule
