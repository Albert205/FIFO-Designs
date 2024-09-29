module fifo_top
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2
)
(
    fifo_if.DUT _if
    // input logic                   i_Clk,
    // input logic                   i_Reset,
    // input logic [DATA_WIDTH-1:0]  i_Wr_Data,
    // input logic                   i_Wr_En,
    // input logic                   i_Rd_En,
    // output logic                  o_Full,
    // output logic                  o_Empty,
    // output logic [DATA_WIDTH-1:0] o_Rd_Data;
    // output logic                  o_Data_Valid
);

    logic [ADDR_WIDTH-1:0] w_Wr_Ptr, w_Rd_Ptr;
    logic w_Full;
    logic w_Wr_En;

    assign w_Wr_En = (~w_Full) && _if.i_Wr_En;
  	assign _if.o_Full = w_Full;

    fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) ctrl_Inst
    (
        .i_Clk(_if.i_Clk),
        .i_Reset(_if.i_Reset),
        .i_Wr_En(_if.i_Wr_En),
        .i_Rd_En(_if.i_Rd_En),
        .o_Full(w_Full),
        .o_Empty(_if.o_Empty),
        .o_Wr_Addr(w_Wr_Ptr),
        .o_Rd_Addr(w_Rd_Ptr),
        .o_Data_Valid(_if.o_Data_Valid)
    );

    register_file #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) reg_Inst
    (
        .i_Clk(_if.i_Clk),
        .i_Wr_Data(_if.i_Wr_Data),
        .i_Wr_Addr(w_Wr_Ptr),
        .i_Wr_En(w_Wr_En),
        .i_Rd_Addr(w_Rd_Ptr),
        .o_Rd_Data(_if.o_Rd_Data)
    );

endmodule