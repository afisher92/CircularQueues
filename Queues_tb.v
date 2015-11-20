module FreqQueue_tb();
reg clk,rst_n,fail,wrt_smpl;
wire [15:0] smpl_out_low,smpl_out_high;
wire squencing_low,squencing_high;
reg [15:0] data [0:10000];
reg [15:0] new_smpl;
integer i,j, test_high,test_low;
//reg [13:0] test_high, test_low;

// instanciate low frequency queue
lowFreqQueue lowFreqQueue1(.clk(clk),.rst_n(rst_n),.new_smpl(new_smpl),.wrt_smpl(wrt_smpl),.smpl_out(smpl_out_low),.sequencing(squencing_low));
// instanciate high frequency queue
highFreqQueue highFreqQueue1(.clk(clk),.rst_n(rst_n),.new_smpl(new_smpl),.wrt_smpl(wrt_smpl),.smpl_out(smpl_out_high),.sequencing(squencing_high));



initial begin
clk = 1'b0;
fail = 1'b0;
test_low =0;
test_high = 0;
wrt_smpl = 1'b0; 
// fill an array that will be pushed into the queue
for (i = 0; i < 16383; i = i + 1)
	data[i] = i;
	
rst_n = 1'b0;
#10 rst_n = 1'b1;
wrt_smpl = 1'b1;

end

// shifts in data and increments counter
always @ (posedge clk, negedge rst_n)
	if (!rst_n)
		j <= 0;
	else begin
		new_smpl <= data[j];
		j <= j+1; 
	end
// test the output of low frequency queue to the input
always @ (posedge clk) begin
	if (!rst_n)
		test_low <= 0;
	else if (squencing_low)
		if(smpl_out_low != data[test_low])begin
			fail <= 1'b1;
			$display("fail");
		end
		else
			test_low <= test_low + 1;
		
end

// test the output of the high frequency queue to the input
always @ (posedge clk) begin
	if (!rst_n)
		test_high <= 0;
	
	else if (squencing_high)
		if(smpl_out_high != data[test_high]) begin
			fail <= 1'b1;
			$display("fail");
		end
		else
			test_high <= test_high + 1;
		
end				

//set clk
always #5 clk = ~clk;

endmodule
