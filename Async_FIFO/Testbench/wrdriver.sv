class wdriver #(int DATA_WIDTH = 8);

    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event wdrv_done;
    mailbox wdrv_mbx;

    task run();
        forever
        begin
            wtrans #(.DATA_WIDTH(DATA_WIDTH)) item;
            wdrv_mbx.get(item);
            begin
                m_fifo_if.i_wdata  <= item.i_wdata;
                m_fifo_if.i_winc   <= item.i_winc;
                m_fifo_if.i_wrst_n <= item.i_wrst_n;

                m_bfm_if.i_wdata  <= item.i_wdata;
                m_bfm_if.i_winc   <= item.i_winc;
                m_bfm_if.i_wrst_n <= item.i_wrst_n;
            end
            @(posedge m_fifo_if.write_cb);
            #item.wdelay;
            ->wdrv_done;
        end
    endtask
endclass

class rdriver #(int DATA_WIDTH = 8);

    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event rdrv_done;
    mailbox rdrv_mbx;

    task run();
        forever
        begin
            rtrans #(.DATA_WIDTH(DATA_WIDTH)) item;
            rdrv_mbx.get(item);
            begin
                m_fifo_if.i_rinc   <= item.i_rinc;
                m_fifo_if.i_rrst_n <= item.i_rrst_n;

                m_bfm_if.i_rinc   <= item.i_rinc;
                m_bfm_if.i_rrst_n <= item.i_rrst_n;
            end
            @(posedge m_fifo_if.read_cb);
            #item.rdelay;
            ->rdrv_done;
        end
    endtask
endclass
