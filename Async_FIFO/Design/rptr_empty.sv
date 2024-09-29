module rptr_empty
#(parameter ADDR_WIDTH = 3)
(
    input  logic                  i_rclk,
    input  logic                  i_rrst_n,
    input  logic                  i_rinc,
    input  logic [ADDR_WIDTH:0]   i_rq2_wptr,
    output logic                  o_rempty,
    output logic [ADDR_WIDTH:0]   o_rptr,
    output logic [ADDR_WIDTH-1:0] o_raddr
);

    logic r_rempty;
    logic w_rempty_next;

    logic [ADDR_WIDTH:0] w_rgray_next;

    always_ff @(posedge i_rclk or negedge i_rrst_n)
    begin
        if(!i_rrst_n)
            r_rempty <= 1'b1;
        else
            r_rempty <= w_rempty_next;
    end

    assign w_rempty_next = (w_rgray_next == i_rq2_wptr);

    assign o_rempty = r_rempty;

    gray_code_counter #(.ADDR_WIDTH(ADDR_WIDTH)) counter_Inst
    (
        .i_clk(i_rclk),
        .i_rst_n(i_rrst_n),
        .i_rinc(i_inc),
        .i_status(r_rempty),
        .o_addr(o_raddr),
        .o_ptr(o_rptr),
        .o_gray_next(w_rgray_next)
    );
endmodule