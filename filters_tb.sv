module Filters_tb();

reg clk, rst_n;
reg [12:0] addr;
reg [15:0]rght_in,rght_out,lft_in, lft_out;
reg [15:0] scoobydoo[8191:0];

integer file,i;

// Call Nate and Brandon's filters code //
LPfilt iDUT(.rght_in(rght_in), .lft_in(lft_in), .sequencing(sequencing), .rst_n(rst_n), .rght_out(rght_out), .lft_out(lft_out), .clk(clk));

//test_filters iPoot(.clk(clk),.audio_in(audio_in),.audio_out(audio_out));

initial begin
    clk = 0;
    rst_n = 1;
    i = 0;
    $readmemh("audio_in.dat",scoobydoo); // Open the file once at the beginning //
    file = $fopen("results.csv");
end

// Read from audio_in for data //
always @(posedge clk) begin  
  rght_in <= scoobydoo[i]; // Write the ith line of the file to audio_in //
  lft_in <= scoobydoo[i];
  i = i + 1;
// Gets two x datas, needs to be corrected //
end

// Close file when all samples are written //
always @(posedge clk) begin  
 if (i == 8195) begin // Should be fixed to any file length, not hard coded //
  $fclose(file);
  $stop;
 end
 else if (i>2) begin
  $fdisplay(file,"%d,%d",rght_out,lft_out); 
 end
end

// Clock //
always begin
 #5 clk = ~clk;
end


endmodule
