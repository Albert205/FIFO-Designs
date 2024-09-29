interface bfm_if #(parameter DATA_WIDTH = 8)
(
    input bit i_wclk,
    input bit i_rclk
);
    /* Write signals */
    logic [DATA_WIDTH-1:0] i_wdata;
    logic                  i_winc;
    logic                  i_wclk;
    logic                  i_wrst_n;
    /* Read signals */
    logic                  i_rinc;
    logic                  i_rclk;
    logic                  i_rrst_n;
    logic [DATA_WIDTH-1:0] o_rdata;
    /* EMPTY/FULL status */
    logic                  o_wfull;
    logic                  o_rempty;

    clocking write_cb @(posedge i_wclk); 
        output i_wdata, i_winc, i_wrst_n;
        input o_wfull;
    endclocking

    clocking read_cb @(posedge i_rclk);
        output i_rinc, i_rrst_n;
        input o_rdata, o_rempty;
    endclocking

    modport DUT 
    (
        input i_wdata, i_winc, i_wclk, i_wrst_n,
        input i_rinc, i_rclk, i_rrst_n,
        output o_rdata, o_wfull, o_rempty
    );

    modport TB
    (
        clocking write_cb, read_cb
    );

endinterface
    