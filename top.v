
`ifndef  TOP_MOD
`define  TOP_MOD

`timescale 1ns/1ns

// these are 640x480@60Hz timings from CEA-861 here https://tomverbeure.github.io/video_timings_calculator
// TIMINGS ARE HERE: http://tinyvga.com/vga-timing/640x480@60Hz
/*

General timing
-----
Screen refresh rate		60 Hz
Vertical refresh		31.46875 kHz
Pixel freq.				25.175 MHz

Horizontal timing (line)
-----
Polarity of horizontal sync pulse is negative.

Scanline part	Pixels	Time [µs]
Visible area	640		25.422045680238
Front porch		16		0.63555114200596
Sync pulse		96		3.8133068520357
Back porch		48		1.9066534260179
Whole line		800		31.777557100298

Vertical timing (frame)
-----
Polarity of vertical sync pulse is negative.

Frame part		Lines	Time [ms]
Visible area	480		15.253227408143
Front porch		10		0.31777557100298
Sync pulse		2		0.063555114200596
Back porch		33		1.0486593843098
Whole frame		525		16.683217477656

*/

// FPGA clk 27 MHz
`define CPU_CLOCK   27.0
`define PIXEL_CLOCK 25.175
`define adj(a)      ( $rtoi(1.074627 * (a) ) )

module top
(
	output reg led,
	input clk,
	output visible,
	output hSync,
	output vSync,
	output hFront,
	output hBack,
	output vFront,
	output vBack

`ifdef ICARUS
	,output [9:0] hCount
	,output [9:0] vCount
	,output [10:0] lines
	,output [10:0] frames
`endif
);
	
	
	reg [9:0] hCount = 0;
	reg [9:0] vCount = 0;
	reg [10:0] frames = 0;
	reg [10:0] lines = 0;
	
	wire activeH = hCount <  `adj(640);
	wire hFront  = hCount >= `adj(640) && hCount < `adj(640+16);
	wire hSync   = hCount >= `adj(640+16) && hCount < `adj(640+16+96);
	wire hBack   = hCount >= `adj(640+16+96) && hCount < `adj(640+16+96+48);
	wire hEnd    = hCount == `adj(640+16+96+48-1);
	
	// lines
	wire activeV = vCount <  (480);
	wire vFront  = vCount >= (480) && vCount < (480+10);
	wire vSync   = vCount >= (480+10) && vCount < (480+10+2);
	wire vBack   = vCount >= (480+10+2) && vCount < (480+10+2+33);
	wire vEnd    = vCount == (480+10+2+33-1);

reg [23:0] counter;
always @(posedge clk ) begin // Counter block
    if (counter < 24'd1349_9999)       // 0.5s delay
        counter <= counter + 1'b1;
    else
        counter <= 24'd0;
end

always @(posedge clk ) begin // Toggle LED
    if (counter == 24'd1349_9999)       // 0.5s delay
        led <= ~led;                         // ToggleLED
end


	always @(posedge clk) begin
		if (hEnd) begin
			hCount <= 0; 
			lines <= lines + 1;
			if (vEnd) begin
				vCount <= 0;
				frames <= frames + 1;
			end else
				vCount <= vCount + 1;
		end
		else
			hCount <= hCount + 1;
	end

	assign visible = activeH && activeV;
	
endmodule


`endif