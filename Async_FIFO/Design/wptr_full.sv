module wptr_full
#(parameter ADDR_WIDTH = 3)
(
    input  logic                  i_wclk,
    input  logic                  i_wrst_n,
    input  logic                  i_winc,
    input  logic [ADDR_WIDTH:0]   i_wq2_rptr,
    output logic                  o_wfull,
    output logic [ADDR_WIDTH:0]   o_wptr,
    output logic [ADDR_WIDTH-1:0] o_waddr
);

    logic r_wfull;
    logic w_wfull_next;

    logic [ADDR_WIDTH:0] w_wgray_next;

    always_ff @(posedge i_wclk or negedge i_wrst_n)
    begin
        if(!i_wrst_n)
            r_wfull <= 1'b0;
        else
            r_wfull <= w_wfull_next;
    end
    
    assign w_wfull_next = (w_wgray_next == {~i_wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1],
                                             i_wq2_rptr[ADDR_WIDTH-2:0]});
    
    assign o_wfull = r_wfull;

    gray_code_counter #(.ADDR_WIDTH(ADDR_WIDTH)) counter_Inst
    (
        .i_clk(i_wclk),
        .i_rst_n(i_wrst_n),
        .i_rinc(i_winc),
        .i_status(r_wfull),
        .o_addr(o_waddr),
        .o_ptr(o_wptr),
        .o_gray_next(w_wgray_next)
    );

endmodule