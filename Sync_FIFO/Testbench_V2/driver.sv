class driver #(int DATA_WIDTH = 8);
    
    virtual clk_if                             m_clk_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;
    
    event   drv_done;
    mailbox drv_mbx;

    task run();
        $display("T=%0t [Driver] starting ...", $time);
        forever
        begin
          	fifo_trans #(.DATA_WIDTH(DATA_WIDTH)) item;
            $display ("T=%0t [Driver] waiting for item ...", $time);
            drv_mbx.get(item);
            item.printInputs("Driver");
            // Drive signals in the interface
            begin
                m_fifo_if.i_Reset   <= item.i_Reset;
                m_fifo_if.i_Wr_Data <= item.i_Wr_Data;
                m_fifo_if.i_Wr_En   <= item.i_Wr_En;
                m_fifo_if.i_Rd_En   <= item.i_Rd_En;
                m_fifo_if.delay     <= item.delay;
            end
            @(posedge m_fifo_if.fifo_cb);
            #1ns;
            #item.delay;
            ->drv_done;
        end
    endtask
endclass
