module sync_r2w
#(parameter ADDR_WIDTH = 3)
(
    input  logic                i_wclk,
    input  logic                i_wrst_n,
    input  logic [ADDR_WIDTH:0] i_rptr,
    output logic [ADDR_WIDTH:0] o_wq2_rptr
);
    logic [ADDR_WIDTH:0] r_rptr;

    always_ff @(posedge i_wclk or negedge i_wrst_n)
    begin
        if(!i_wrst_n)
        begin
            r_rptr     <= 'b0;
            o_wq2_rptr <= 'b0;
        end
        else
        begin
            r_rptr     <= i_rptr;
            o_wq2_rptr <= r_rptr;
        end
    end
endmodule