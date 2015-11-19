module Queues_tb();

reg clk, rst_n, wrt_smpl;
reg [15:0] new_smpl;
wire [15:0] smpl_out;
wire sequencing;

LowFQueues iLowQ (.clk(clk), .rst_n(rst_n), .new_smpl(new_smpl), .wrt_smpl(wrt_smpl), .smpl_out(smpl_out), .sequencing(sequencing));

initial begin
  clk = 0;
  rst_n = 0;
  wrt_smpl = 0;
  new_smpl = 16'h0000;
  #5 rst_n = 1;
end


always 
	#20 clk <= ~clk;

always 
	#10 wrt_smpl <= ~wrt_smpl;


endmodule
