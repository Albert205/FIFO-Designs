class monitor #(int DATA_WIDTH = 8);

    virtual bfm_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event drv_done;
    mailbox scb_mbx;

    task run();
        forever
        begin
            bfm_trans #(.DATA_WIDTH(DATA_WIDTH)) item = new();
            @(drv_done);
            begin
                item.i_wdata  <= m_bfm_if.i_wdata;
                item.i_winc   <= m_bfm_if.i_winc;
                item.i_wrst_n <= m_bfm_if.i_wrst_n;
                
                item.i_rinc   <= m_bfm_if.i_rinc;
                item.i_rrst_n <= m_bfm_if.i_rrst_n;
                item.o_rdata  <= m_bfm_if.o_rdata;
                item.o_wfull  <= m_bfm_if.o_wfull;
                item.o_rempty <= m_bfm_if.o_rempty;
            end
            #1;
            scb_mbx.put(item);
        end
    endtask
endclass