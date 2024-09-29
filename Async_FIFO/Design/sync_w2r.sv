module sync_w2r
#(parameter ADDR_WIDTH = 3)
(
    input  logic                i_rclk,
    input  logic                i_rrst_n,
    input  logic [ADDR_WIDTH:0] i_wptr,
    output logic [ADDR_WIDTH:0] o_rq2_wptr
);
    logic [ADDR_WIDTH:0] r_wptr;

    always_ff @(posedge i_rclk or negedge i_rrst_n)
    begin
        if(!i_rrst_n)
        begin
            r_wptr     <= 'b0;
            o_rq2_wptr <= 'b0;
        end
        else
        begin
            r_wptr     <= i_wptr;
            o_rq2_wptr <= r_wptr;
        end
    end
endmodule