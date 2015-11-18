module HiFQueues (
	input 			clk, rst_n,
	input [15:0] 	new_smpl,
	input 			wrt_smpl,
	output [15:0] 	smpl_out,
	output 			sequencing
);

/* ------ Define any internal variables ------------------------------------------------------------- */
/*	Pointers designated as 'new' signify where the array is going to be written to
	Pointers designated as 'old' signify where the array is going to read from */
	
reg [10:0] 		new_ptr, old_ptr, next_new, next_old;
reg [10:0]		read_ptr;

/* Define high frequency registers 
reg 			full_reg;			//High freq Q is full
reg				wrt_high; 			//TRUE until high freq Q is full for the first time
reg [10:0]		cnt;				//Counts how many addresses have samples writen to them

/* ------ Instantiate the dual port modules -------------------------------------------------------- */
// Instantiate the modules
dualPort1536x16 i536Port(.clk(clk),.we(we),.waddr(new_ptr),.raddr(read_ptr),.wdata(new_smpl),.rdata(smpl_out));

/* ------ Define States ---------------------------------------------------------------------------- */
reg [1:0] state, nxt_state;
localparam WRITE 	= 2'b00;		//Arrays have not yet written thte required number of samples to begin reading
localparam FULL		= 2'b01;		//Arrays have written the required amount of samples
localparam READ		= 2'b10;		//Arrays performing reads and writes at each cycle

/* ------ Always Block to Update States ------------------------------------------------------------ */
always @(posedge clk, negedge rst_n) begin 
	if(!rst_n) begin
		// Reset Pointers
		new_ptr 		<= 10'h1FE;
		old_ptr 		<= 10'h000;
	end else begin
		// Set Pointers
		new_ptr			<= next_new;
		old_ptr			<= next_old;
	end
end

always @(posedge clk, negedge rst_n)
	if (!rst_n)
		state <= INIT;
	else 
		state < nxt_state;

/* ------ Control for read/write pointers and empty/full registers -------------------------------- */
		
always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		wrt_high <= 1'b1;
	else if(old_ptr == 0 && new_ptr == 1531)
		wrt_high <= 1'b0;
end

assign full_reg		= (!rst_n) ? 1'b0 : (cnt == 1536);

/* ------ Manage pointers in high frequency queue ------------------------------------------------- */
assign next_new			= (next_new == 1536)	? 10'h000 : new_ptr + 1;
assign next_old			= (next_old == 1536)	? 10'h000 : old_ptr + 1;

/* ------ Manage Queue Counters ------------------------------------------------------------------- */
// High Frequency Q Counter
always @(posedge clk, negedge rst_n) 
	if (!rst_n)
		hiCnt		<= 11'h000;
	else if(hiCnt != 1535) begin
		hiCnt		<= hiCnt + 1;
	end
