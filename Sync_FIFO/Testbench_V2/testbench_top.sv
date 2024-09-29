module tb;

    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 2;

    clk_if m_clk_if();
    fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if (m_clk_if.i_Clk);
    fifo_top #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) fifo_Inst0(m_fifo_if.DUT);

    test t0;

    initial
    begin
        t0 = new();
        t0.e0.m_clk_if = m_clk_if;
        t0.e0.m_fifo_if = m_fifo_if;
        t0.run();

        #50 $display("Error Count: %0d", t0.e0.s0.ERROR_COUNT);
            $display("Pass Count: %0d", t0.e0.s0.PASS_COUNT);
        #50 $finish;
    end
  
  	initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
endmodule
        