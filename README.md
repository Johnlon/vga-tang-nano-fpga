# VGA Experiments with Tang Nano 9 FPGA

Experiments using a cheap Tang Nano 9 to generate VGA signals. 

What I want to do is to see how tolerant an LCD monitor is to the various signals deviating from standards to get a better understanding of how VGA really works.

The current impl generates just the V and H signals and no RGB.
Also emits signals for all the other phases like porches and visible areas and so on.

Also blinks the LED so I know it's actrually running without hooking up the oscilloscope or monitor.

I will try experiments like making the sync signals actually take an entire half cycle of the horizontal with just one of the edges in the right place, and I'll try a signal with and without porches and see what monitor does.

Of course any results are not necessarily predicting what some other monitor would do.

# Why not use an Arduino or ESP32?

I did try and Arduino and it worked. But I wanted more fine grained control over the timings and the FPGA gives the ultimate in that. The Arduino has a 16 MHz clock but this is used to drive a CPU so there is relatively coarse grained timing control as 4 clocks are needed for a single CPU op. But an Arduino is simple and predicable for low speed apps.

The ESP32 on the other hand was a different story. The ESP32 is not bare metal like the Arduino and the real time OS on the ESP means that interrups keep happening all over the place that cause jitter and made a simple impl impossible. BitLuni and others have managed to make it work BUT to do that they need to leverage other bits of the ESP hardware such as the audio subsystem to make things jitter-free and this is just a total pain for me wanting to do some simple experiments.

So ... FPGA gives me the best trade off and it's also a new experience. I get VERY fine grained control and the signal timing is rock solid.
Also I already know Verilog from SPAM-1 my CPU (see other git repo) so that's also a bonus.

# Results

No video, yet if at all, but see these notes on the timing experiments https://github.com/Johnlon/vga-tang-nano-fpga/blob/main/top.v#L74-L104

# Getting started

I followed these instructions using VSCode https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/

Pinout is recorded in the *.cst file.

# VGA timings

I used these timings .. http://tinyvga.com/vga-timing/640x480@60Hz
