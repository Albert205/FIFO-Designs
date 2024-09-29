module FIFO_top
#(parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4)
(
    fifo_if.DUT _if
);

    logic w_wclken;
    logic w_wfull;
    assign w_wclken = _if.i_winc && ~w_wfull;
    assign _if.o_wfull = w_wfull;

    logic [ADDR_WIDTH-1:0] w_waddr, w_raddr;
    logic [ADDR_WIDTH:0] w_wptr, w_rptr;
    logic [ADDR_WIDTH:0] w_wq2_rptr, w_rq2_wtpr;

    FIFO_mem #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) mem_Inst
    (
        .i_wclk(_if.i_wclk),
        .i_wclken(w_wclken),
        .i_wdata(_if.i_wdata),
        .i_waddr(w_waddr),
        .i_raddr(w_raddr),
        .o_rdata(_if.o_rdata)
    );

    rptr_empty #(.ADDR_WIDTH(ADDR_WIDTH)) rptr_Inst
    (
        .i_rclk(_if.i_rclk),
        .i_rrst_n(_if.i_rrst_n),
        .i_rinc(_if.i_rinc),
        .i_rq2_wptr(w_rq2_wtpr),
        .o_rempty(_if.o_rempty),
        .o_rptr(w_rptr),
        .o_raddr(w_raddr)
    );

    wptr_full #(.ADDR_WIDTH(ADDR_WIDTH)) wptr_Inst
    (
        .i_wclk(_if.i_wclk),
        .i_wrst_n(_if.i_wrst_n),
        .i_winc(_if.i_winc),
        .i_wq2_rptr(w_wq2_rptr),
        .o_wfull(w_wfull),
        .o_wptr(w_wptr),
        .o_waddr(w_waddr)
    );

    sync_r2w #(.ADDR_WIDTH(ADDR_WIDTH)) r2w_Inst
    (
        .i_wclk(_if.i_wclk),
        .i_wrst_n(_if.i_wrst_n),
        .i_rptr(w_rptr),
        .o_wq2_rptr(w_wq2_rptr)
    );

    sync_w2r #(.ADDR_WIDTH(ADDR_WIDTH)) w2r_Inst
    (
        .i_rclk(_if.i_rclk),
        .i_rrst_n(_if.i_rrst_n),
        .i_wptr(w_wptr),
        .o_rq2_wptr(w_rq2_wtpr)
    );

endmodule

