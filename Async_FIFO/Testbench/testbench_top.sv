module testbench_top;
    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 4;
    localparam w_hperiod  = 10;
    localparam r_hperiod  = 15;

    clk_if #(.w_hperiod(w_hperiod),.r_hperiod(r_hperiod)) m_clk_if;
    fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if
    (
     .i_wclk(m_clk_if.wclk), 
     .i_rclk(m_clk_if.rclk)
     );

     fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if
    (
     .i_wclk(m_clk_if.wclk), 
     .i_rclk(m_clk_if.rclk)
     );

     FIFO_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo_Inst(m_fifo_if.DUT);
     bfm_fifo #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) bfm_Inst(m_bfm_if.BFM);

     test t0;

     initial
     begin
        t0 = new();
        t0.env.m_fifo_if = m_fifo_if;
        t0.env.m_bfm_if  = m_bfm_if;
        t0.run();

        #50 $display("Write Error Count = %0d", t0.env.w_scb.W_ERROR_COUNT);
            $display("Read Error Count = %0d", t0.env.r_scb.R_ERROR_COUNT);
            $display("Write Pass Count = %0d", t0.env.w_scb.W_PASS_COUNT);
            $display("Read Pass Count = %0d", t0.env.r_scb.R_PASS_COUNT);
        #50 $finish;
     end

     initial
     begin
        $dumpfile("dump.vcd");
        $dumpvars;
     end
endmodule
