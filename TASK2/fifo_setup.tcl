clear -all

analyze -sv09 fifo_top.sv fifo.sv
elaborate -top fifo_top

clock clk
reset ~rst

prove -all

# Generate a report
report -all -file report.txt -force

# # Exit the session
# exit -force