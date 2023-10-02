# VGA Experiments with Tang Nano 9 FPGA

Experiments using a cheap Tang Nano 9 to generate VGA signals. 

What I want to do is to see how tolerant an LCD monitor is to the various signals deviating from standards to get a better understanding of how VGA really works.

The current impl generates just the V and H signals and no RGB.
Also emits signals for all the other phases like porches and visible areas and so on.

Also blinks the LED so I knoww it's actrually running without hooking up the oscilloscope or monitor.

I will try experiments like making the sync signals actually take an entire half cycle of the horizontal with just one of the edges in the right place, and I'll try a signal with and without porches and see what monitor does.

Of course any results are not necessarily predicting what some other monitor would do.

# Getting started

I followed these instructions using VSCode https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/
