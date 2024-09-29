class bfm_driver #(int DATA_WIDTH = 8);

    virtual bfm_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event drv_done;
    mailbox drv_mbx;
    
    task run();
        forever 
        begin
            bfm_trans #(.DATA_WIDTH(DATA_WIDTH)) item;
            drv_mbx.get(item);
            begin
                m_bfm_if.i_wdata <= item.i_wdata;
                m_bfm_if.i_winc <= item.i_winc;
                m_bfm_if.i_wrst_n <= item.i_wrst_n;
                m_bfm_if.i_rinc <= item.i_rinc;
                m_bfm_if.i_rrst_n <= item.i_rrst_n;
            end
            ->drv_done;
        end
    endtask
endclass