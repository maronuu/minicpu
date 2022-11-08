module tcomputer;
	reg clk, rstd;

	initial begin
		rstd = 1;
		#10 rstd = 0;
		#10 rstd = 1;
	end

	initial begin
		$dumpfile("computer.vcd");
		$dumpvars;
		clk = 0;
		#10000 $finish;
	end

	always  # 50 clk = ~clk;

	computer computer_body(clk, rstd);
endmodule