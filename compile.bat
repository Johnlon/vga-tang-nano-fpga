c:\Users\johnl\apps\icarus\bin\iverilog.exe -DICARUS -g2012 test.sv
if  errorlevel 1 goto ERROR

c:\Users\johnl\apps\icarus\bin\vvp.exe -n a.out 

:ERROR
