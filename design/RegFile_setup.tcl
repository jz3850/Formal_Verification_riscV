clear -all

analyze -sv09 RegFile.sv
elaborate -top RegFile

clock ~clk
reset ~rst
