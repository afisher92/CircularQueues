module Queues_tb();

reg clk, rst_n, wrt_smpl;
reg [15:0] newsmpl;
wire [15:0] smpl_out;
wire sequencing;

Queues iQ (.clk(clk), .rst_n(rst_n), .newsmpl(newsmpl), .wrt_smpl(wrt_smpl), .smpl_out(smpl_out), .sequencing(sequencing));

initial begin
  clk = 0;

end


always 
	#5 clk <= ~clk;


endmodule
