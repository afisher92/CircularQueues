module LowFQueues (
	input 			clk, rst_n,
	input [15:0] 		new_smpl,
	input 			wrt_smpl,
	output [15:0] 		smpl_out,
	output 			sequencing
);

/* ------ Define any internal variables ------------------------------------------------------------- */
/*	Pointers designated as 'new' signify where the array is going to be written to
	Pointers designated as 'old' signify where the array is going to read from */

// Declare pointers for high band and low band queues
reg [9:0] 		new_ptr, old_ptr, next_new, next_old;
reg [9:0]		read_ptr;

// Declare status registers for high and low queues
//// Define low frequency Registers 
reg 			full_reg, end_ptr;	//Low freq Q is full, when it is prepped to read
reg [9:0]		cnt;				//Counts how many addresses have samples writen to them

// Define wrt_smpl counter
reg			wrt_cnt;		// Keeps track of every other valid signal

/* ------ Instantiate the dual port modules -------------------------------------------------------- */
// Instantiate the modules
dualPort1024x16 i1024Port(.clk(clk),.we(we),.waddr(new_ptr),.raddr(read_ptr),.wdata(new_smpl),.rdata(smpl_out));

/* ------ Define States ---------------------------------------------------------------------------- */
reg [1:0] state, nxt_state;
localparam WRITE 	= 2'b00;		//Arrays have not yet written thte required number of samples to begin reading
localparam FULL		= 2'b01;		//Arrays have written the required amount of samples
localparam READ		= 2'b10;		//Arrays performing reads and writes at each cycle

/* ------ Always Block to Update States ------------------------------------------------------------ */
always @(posedge clk, negedge rst_n) begin 
	if(!rst_n) begin
		// Reset Pointers
		new_ptr 		<= 10'h000;
		old_ptr 		<= 10'h000;
	end else begin
		// Set Pointers
		new_ptr 		<= lowNext_new;
		old_ptr			<= lowNext_old;
	end
end

always @(posedge clk, negedge rst_n)
	if (!rst_n)
		state <= INIT;
	else 
		state < nxt_state;

/* ------ Control for read/write pointers and empty/full registers -------------------------------- */
assign end_ptr		= 0ld_ptr + 1020;
assign full_reg		= &cnt;

/* ------ Manage Queue Counters ------------------------------------------------------------------- */
// Low Frequency Q Counter 
always @(posedge wrt_smpl, negedge rst_n) begin
	if(!rst_n)
		lowCnt		<= 10'h000;
	else if(~&lowCnt & wrt_cnt == 1) begin
		lowCnt		<= lowCnt + 1;
	end
	if(!rst_n) // Keep track of every other wrt_smpl
		wrt_cnt <= 1'b0;
	else
		wrt_cnt <= wrt_cnt + 1;
end
	
/* ------ Begin State Machine --------------------------------------------------------------------- */
always @(*) 
	case(state)
		WRITE : begin
			if (~lowEnd_reg)
				next_state = WRITE;
				if (wrt_cnt == 1) begin
					lowNew_ptr	= lowNew_ptr + 1
					lowWdata	= 
			
			

	
endmodule
