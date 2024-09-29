class wmonitor #(int DATA_WIDTH = 8);
    
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event wdrv_done;
    event wmon_done;
    mailbox wscb_mbx;

    task run();
        forever
        begin
            wtrans #(.DATA_WIDTH(DATA_WIDTH)) dut_item = new();
            wtrans #(.DATA_WIDTH(DATA_WIDTH)) bfm_item = new(); 

            @(wdrv_done);
            begin
                dut_item.i_wdata  <= m_fifo_if.i_wdata;
                dut_item.i_winc   <= m_fifo_if.i_winc;
                dut_item.i_wrst_n <= m_fifo_if.i_wrst_n;
                dut_item.o_wfull  <= m_fifo_if.o_wfull;

                bfm_item.i_wdata  <= m_bfm_if.i_wdata;
                bfm_item.i_winc   <= m_bfm_if.i_winc;
                bfm_item.i_wrst_n <= m_bfm_if.i_wrst_n;
                bfm_item.o_wfull  <= m_bfm_if.o_wfull;
            end
            #1;
            wscb_mbx.put(dut_item);
            wscb_mbx.put(bfm_item);
            ->wmon_done;
        end
    endtask
endclass

class rmonitor #(int DATA_WIDTH = 8);
    
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event rdrv_done;
    event rmon_done;
    mailbox rscb_mbx;

    task run();
        forever
        begin
            rtrans #(.DATA_WIDTH(DATA_WIDTH)) dut_item = new();
            rtrans #(.DATA_WIDTH(DATA_WIDTH)) bfm_item = new(); 

            @(wdrv_done);
            begin
                dut_item.i_rrst_n <= m_fifo_if.i_rrst_n;
                dut_item.i_rinc   <= m_fifo_if.i_rinc;
                dut_item.o_rdata  <= m_fifo_if.o_rdata;
                dut_item.o_rempty <= m_fifo_if.o_rempty;

                bfm_item.i_rrst_n <= m_bfm_if.i_rrst_n;
                bfm_item.i_rinc   <= m_bfm_if.i_rinc;
                bfm_item.o_rdata  <= m_bfm_if.o_rdata;
                bfm_item.o_rempty <= m_bfm_if.o_rempty;
            end
            #1;
            rscb_mbx.put(dut_item);
            rscb_mbx.put(bfm_item);
            ->rmon_done;
        end
    endtask
endclass