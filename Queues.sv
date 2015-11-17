module Queues (
	input clk, rst_n,
	input [15:0] newsmpl,
	input wrt_smpl,
	output [15:0] smpl_out,
	output sequencing
);

/* ------ Define any internal variables ------------------------------------------------------------- */
reg 			low_empty, low_full, high_empty, high_full;
reg [10:0] 		highArray[1535:0], lowArray[1023:0]; 
wire 			data_wr, data_rd;

// Declare pointers for high band and low band queues
reg [10:0] 		lowNew_ptr, lowOld_ptr, lowRead_ptr;
reg [10:0] 		hiNew_ptr, hiOld_ptr, hiRead_ptr;

// Declare status registers for high and low queues
//// Define high frequency registers 
reg 			hiFull_reg, hiEmpty_reg, hiFull_next, hiEmpty_next;
reg [10:0] 		hiWr_reg, hiWr_next, hiWr_succ; //Points to the high frequency register that needs to be written to
reg [10:0] 		hiRd_reg, hiRd_next, hiRd_succ; //Points to the high frequency register that needs to be read from

//// Define low frequency Registers 
reg 			lowFull_reg, lowEmpty_reg, lowFull_next, lowEmpty_next;
reg [10:0] 		lowWr_reg, lowWr_next, lowWr_succ; //Points to the low frequency register that needs to be written to
reg [10:0] 		lowRd_reg, lowRd_next, lowRd_succ; //Points to the low frequency register that needs to be read from

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

/* ----- Define queue empty/full functionality ----------------------------------------------------- */
// High Frequency empty 
assign high_empty = 

endmodule
