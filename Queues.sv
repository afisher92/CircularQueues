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
reg 			lowFull_reg, lowEnd_ptr;	//Low freq Q is full, when it is prepped to read
reg [9:0]		lowCnt;				//Counts how many addresses have samples writen to them

//// Define high frequency registers 
reg 			hiFull_reg;	//High freq Q is full
reg				wrt_high; 					//TRUE until high freq Q is full for the first time
reg [10;0]		hiCnt;		//Counts how many addresses have samples writen to them

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

/* ------ Define States ---------------------------------------------------------------------------- */
reg [1:0] state, nxt_state;
localparam INIT = 2'b00;		//Reset control values
localparam Write_Only = 2'b01;		//Arrays have not yet written thte required number of samples to begin reading
localparam Read_Write = 2'b10;		//Arrays performing reads and writes at each cycle

/* ------ Always Block to Update States ------------------------------------------------------------ */
always @(posedge clk, negedge rst_n) begin 
	if(!rst_n) begin
		// Reset Pointers
		lowNew_ptr 		<= 10'h000;
		lowOld_ptr 		<= 10'h000;
		hiNew_ptr 		<= 10'h1FE;
		hiOld_ptr 		<= 10'h000;
		// Reset counters
		lowCnt			<= 10'h000;
	end else begin
		// Set Pointers
		lowNew_ptr 		<= lowNext_new;
		lowOld_ptr		<= lowNext_old;
		hiNew_ptr		<= hiNext_new;
		hiOld_ptr		<= hiNext_old;
	end
end

always @(posedge clk, negedge rst_n)
	if (!rst_n)
		state <= INIT;
	else 
		state < nxt_state;

/* ------ Control for read/write pointers and empty/full registers -------------------------------- */
assign lowEnd_ptr		= lowOld_ptr + 1020;
//assign lowFull_reg		= (!rst_n) ? 1'b0 : (lowOld_ptr == lowNew_ptr + 1);
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		wrt_high <= 1'b1;
	else if(hiOld_ptr == 0 && hiNew_ptr == 1531)
		wrt_high <= 1'b0;
end
//assign hiFull_reg		= (!rst_n) ? 1'b0 : (1356  == hiNew_ptr - hiOld_ptr);

/* ------ Manage pointers in high frequency queue ------------------------------------------------- */
assign hiNext_new		= (hiNext_new == 1536)	? 10'h000 : hiNew_ptr + 1;
assign hiNext_old		= (hiNext_old == 1536)	? 10'h000 : hiOld_ptr + 1;

/* ------ Begin State Machine --------------------------------------------------------------------- */


	
endmodule
