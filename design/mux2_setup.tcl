clear -all

analyze -sv09 mux2.sv
elaborate -top mux2

clock -none
reset -none
