class monitor #(int DATA_WIDTH = 8);
    virtual clk_if                             m_clk_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;

    event drv_done;
    mailbox scb_mbx;

    task run();
        $display("T=%0t [Monitor] starting ...", $time);
        forever
        begin
          	fifo_trans #(.DATA_WIDTH(DATA_WIDTH)) item = new();
            @(drv_done);
            // Get output signals from interface
            begin
                item.i_Reset      <= m_fifo_if.i_Reset;
                item.i_Wr_Data    <= m_fifo_if.i_Wr_Data;
                item.i_Wr_En      <= m_fifo_if.i_Wr_En;
                item.i_Rd_En      <= m_fifo_if.i_Rd_En;
                item.o_Full       <= m_fifo_if.o_Full;
                item.o_Empty      <= m_fifo_if.o_Empty;
                item.o_Rd_Data    <= m_fifo_if.o_Rd_Data;
                item.o_Data_Valid <= m_fifo_if.o_Data_Valid;
                item.delay        <= m_fifo_if.delay;
            end
            #1;
            item.printOutputs("Monitor");
            scb_mbx.put(item);
        end
    endtask
endclass
        


