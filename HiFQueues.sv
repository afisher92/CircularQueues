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
reg [9:0]		read_ptr, next_read;

// Declare status registers for high and low queues
//// Define low frequency Registers 
reg 			full_reg, end_ptr, read;	//Low freq Q is full, when it is prepped to read, signal defining when to read samples
reg [9:0]		cnt;				//Counts how many addresses have samples writen to them

// Define wrt_smpl counter
reg			wrt_cnt;		// Keeps track of every other valid signal

/* ------ Instantiate the dual port modules -------------------------------------------------------- */
dualPort1024x16 i1024Port(.clk(clk),.we(we),.waddr(new_ptr),.raddr(read_ptr),.wdata(new_smpl),.rdata(smpl_out));

/* ------ Always Block to Update Pointers ---------------------------------------------------------- */
always @(posedge wrt_smpl, negedge rst_n) begin 
	if(!rst_n) begin
		// Reset Pointers
		new_ptr 		<= 10'h000;
		old_ptr 		<= 10'h000;
	end else begin
		// Set Pointers
		new_ptr 		<= next_new;
		old_ptr			<= next_old;
	end
end

always @(posedge clk, negedge rst_n)
	if(!rst_n)
		read_ptr <= old_ptr;
	else if(read)
		read_ptr <= next_read;

/* ------ Control for read/write pointers and empty/full registers -------------------------------- */
assign end_ptr		= old_ptr + 1020;
assign full_reg		= &cnt;
assign read		= (new_ptr == end_ptr);

/* ------ Manage Next Read/Write Pointers --------------------------------------------------------- */
always @(posedge wrt_cnt)
	next_new <= new_ptr + 1; 

always @(posedge next_new)
	if (read)
		next_old <= old_ptr + 1;

always @(posedge clk, negedge rst_n) begin
	if (!rst_n)
		next_read <= old_ptr + 1;
	else if (read & read_ptr != new_ptr - 1)
		next_read <= read_ptr + 1;
	else
		next_read <= old_ptr;
end

/* ------ Manage Queue Counters ------------------------------------------------------------------- */
// Low Frequency Q Counter 
always @(posedge wrt_smpl, negedge rst_n) begin
	if(!rst_n) // Counts until the array is full
		cnt		<= 10'h000;
	else if(~&cnt & wrt_cnt == 1) begin
		cnt		<= cnt + 1;
	end
	if(!rst_n) // Keep track of every other wrt_smpl
		wrt_cnt <= 1'b0;
	else
		wrt_cnt <= wrt_cnt + 1;
end
	
endmodule
