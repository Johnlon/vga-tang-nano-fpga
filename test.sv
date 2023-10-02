`timescale 1ns/1ns


`include "top.v"

//measured in us
`define HALFCLK ((1000000.0/`CPU_CLOCK)/2.0)

module tb();

	reg clk;

	wire visible;
	wire hSync;
	wire vSync;

	wire hFront;
	wire hBack;
	wire vFront;
	wire vBack;

	wire [9:0] hCount;
	wire [9:0] vCount;
	wire [10:0] frames;
	wire [10:0] lines;

	wire hSyncvga = ~ hSync;
	wire vSyncvga = ~ vSync;

	top top0(
		.clk(clk),
		.visible(visible),
		.frames(frames),
		.lines(lines),

		.hCount(hCount),
		.hSync(hSync),
		.hFront(hFront),
		.hBack(hBack),

		.vCount(vCount),
		.vFront(vFront),
		.vSync(vSync),
		.vBack(vBack)
	);

	integer clks=0;

	initial begin
		$dumpfile("test.vcd");
		$dumpvars;
	end

	always begin
		#1

		$write("%10.3f us : clk %6d : hCount %d : vCount %d : ", $time/1000000.0, clks, hCount, vCount);
		
		if (visible) 
			$write(" == VISIBLE");
		else
			$write(" ==        ");

		// HORIZONTAL

		if (hFront) 
			$write(" == hFRONT");
		else
			$write(" ==       ");

		if (hSync) 
			$write(" == hSYNC");
		else
			$write(" ==      ");

		if (hBack) 
			$write(" == hBACK");
		else
			$write(" ==      ");

		if (hFront+hSync+hBack > 1) begin
			$error("\nillegal H state");
			$finish();
		end

		// VERTICAL 

		if (vFront) 
			$write(" == vFRONT");
		else
			$write(" ==       ");

		if (vSync)
			$write(" == vSYNC");
		else
			$write(" ==      ");

		if (vBack) 
			$write(" == vBACK");
		else
			$write(" ==      ");

		if (vFront+vSync+vBack > 1) begin
			$error("\nillegal V state");
			$finish();
		end

		$display("");
		clks = clks + 1;

		if (clks == 1000000) $finish();

		#`HALFCLK
		clk = 0;
		#(`HALFCLK-1)
		clk = 1;

	end

	always @(lines) begin
		$display("LINES %-d  EXPECT %f", lines, (31.777557100298 * lines));
	end

	always @(frames) begin
		$display("FRAME %-d  EXPECT %f", frames, (16.683217477656 * frames));
	end

endmodule
