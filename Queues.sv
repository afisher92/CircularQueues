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

// Declare pointers for high band and low band queues
reg [9:0] 		lowNew_ptr, lowOld_ptr, lowNext_new, lowNext_old;
reg [9:0]		lowRead_ptr;
reg [10:0] 		hiNew_ptr, hiOld_ptr, hiNext_new, hiNext_old;
reg [10:0]		hiRead_ptr;

// Declare status registers for high and low queues
//// Define low frequency Registers 
reg 			lowFull_reg, lowEmpty_reg;	//Low freq Q is full, is empty
reg [10:0]		hiEnd_ptr;

//// Define high frequency registers 
reg 			hiFull_reg, hiEmpty_reg;	//High freq Q is full, is empty
reg [9:0]		lowEnd_ptr;

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
		lowNew_ptr 		<= 10'h000;
		lowOld_ptr 		<= 10'h000;
		hiNew_ptr 		<= 10'h000;
		hiOld_ptr 		<= 10'h000;
	end else begin
		// Set Pointers
		lowNew_ptr 		<= lowNext_new;
		lowOld_ptr		<= lowNext_old;
		hiNew_ptr		<= hiNext_new;
		hiOld_ptr		<= hiNext_old;
	end
end

/* ------ Control for read/write pointers and empty/full registers -------------------------------- */
assign lowEnd_ptr		= lowOld_ptr + 1020;
assign lowFull_reg		= (!rst_n) ? 1'b0 : (lowOld_ptr == lowNew_ptr + 1);
assign lowEmpty_reg		= (!rst_n) ? 1'b1 : (lowNew_ptr == lowOld_ptr);
//assign hiEnd_ptr		= 
assign hiEmpty_reg		= (!rst_n) ? 1'b1 : (hiNew_ptr == hiOld_ptr);

/* ------ Manage pointers in high frequency queue ------------------------------------------------- */
assign hiNext_new		= (hiNext_new == 1536)	? 10'h000 : hiNew_ptr + 1;
assign hiNext_old		= (hiNext_old == 1536)	? 10'h000 : hiOld_ptr + 1;


	
endmodule