vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
coverage save top.ucdb -onexit
run -all
#quit -sim
#vcover report top.ucdb -details -annotate -all -output cov_report.txt