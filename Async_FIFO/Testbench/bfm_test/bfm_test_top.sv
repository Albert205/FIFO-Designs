module tb;

    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 2;

    bit wclk, rclk;
    event clk_rand_done;

    bfm_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if (.i_wclk(wclk),.i_rclk(rclk));
    fifo_bfm #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) bfm_Inst(m_bfm_if.DUT);

    bfm_test t0;
    clk_freq_rand rand_clk;

    initial
    begin
        rand_clk = new();
        rand_clk.randomize();
        ->clk_rand_done;
    end

    initial
    begin
        wclk = 0;
        rclk = 0;
        @(clk_rand_done);
        fork
            begin
                forever
                begin
                    #(rand_clk.per_wclk/2);
                    wclk = ~wclk;
                end

                forever
                begin
                    #(rand_clk.per_rclk/2);
                    rclk = ~rclk;
                end
            end
        join_none
    end 

    initial
    begin
        t0 = new();
        t0.e0.m_bfm_if = m_bfm_if;
        @(clk_rand_done); 
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
        