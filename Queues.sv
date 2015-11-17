//Quick Edit
module Queues (
	input clk, rst_n,
	input [15:0] newsmpl,
	input wrt_smpl,
	output [15:0] smpl_out,
	output sequencing
);

/* Define any internal wires or regs */
wire data_wr, data_rd;
reg low_empty, low_full, high_empty, high_full;

reg [10:0] highArray[1535:0], lowArray[1023:0]; 

// Declare pointers for high band and low band queues
reg [10:0] lowNew_ptr, lowOld_ptr, lowRead_ptr;
reg [10:0] hiNew_ptr, hiOld_ptr, hiRead_ptr;

// Declare status registers for high and low queues
reg full_regHi, empty_regHi, full_nextHi, empty_nextHi;
reg [10:0] hiWr_reg, hiWr_next, hiWr_succ; //Points to the high frequency register that needs to be written to
reg [10:0] hiRd_reg, hiRd_next, hiRd_succ; //Points to the high frequency register that needs to be read from
reg full_regLow, empty_regLow, full_nextLow, empty_nextLow;
reg [10:0] lowWr_reg, lowWr_next, lowWr_succ; //Points to the low frequency register that needs to be written to
reg [10:0] lowRd_reg, lowRd_next, lowRd_succ; //Points to the low frequency register that needs to be read from

/* Instantiate the dual port modules */
dualPort1024x16 i1024Port(.clk(clk),.we(we),.waddr(waddr),.radder(raddr),.wdata(wdata),.rdata(rdata));
dualPort1536x16 i1536Port(.clk(clk),.we(we),.waddr(waddr),.radder(raddr),.wdata(wdata),.rdata(rdata));

//Test from Modelsim

endmodule
