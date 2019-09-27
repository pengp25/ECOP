@echo off
set xv_path=D:\\software\\Vivado\\2015.2\\bin
call %xv_path%/xsim sim_cpu_behav -key {Behavioral:sim_1:Functional:sim_cpu} -tclbatch sim_cpu.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
