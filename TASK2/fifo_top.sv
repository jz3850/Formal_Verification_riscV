module fifo_top (
    clk, rst, in_read_ctrl, in_write_ctrl, in_write_data, 
    out_read_data1, out_read_data2, out_is_full1, out_is_empty1, out_is_full2, out_is_empty2
    );
   
   
    input  logic       clk; 
    input  logic       rst;
    input  logic       in_read_ctrl;
    input  logic       in_write_ctrl;
    input  logic [7:0] in_write_data;
    output logic [7:0] out_read_data1;
    output logic [7:0] out_read_data2;
    output logic       out_is_full1;
    output logic       out_is_empty1;
    output logic       out_is_full2;
    output logic       out_is_empty2;

    fifo fifo_inst1 (
        .clk(clk),
        .rst(rst),
        .in_read_ctrl(in_read_ctrl),
        .in_write_ctrl(in_write_ctrl),
        .in_write_data(in_write_data),
        .out_read_data(out_read_data1),
        .out_is_full(out_is_full1),
        .out_is_empty(out_is_empty1)
    );

    fifo fifo_inst2 (
        .clk(clk),
        .rst(rst),
        .in_read_ctrl(in_read_ctrl),
        .in_write_ctrl(in_write_ctrl),
        .in_write_data(in_write_data),
        .out_read_data(out_read_data2),
        .out_is_full(out_is_full2),
        .out_is_empty(out_is_empty2)
    );

    assert property (@(posedge clk) disable iff (rst) (out_read_data1 == out_read_data2));
    assert property (@(posedge clk) disable iff (rst) (out_is_full1 == out_is_full2));
    assert property (@(posedge clk) disable iff (rst) (out_is_empty1 == out_is_empty2));

endmodule