class environment #(int DATA_WIDTH = 8);

    wgenerator #(.DATA_WIDTH(DATA_WIDTH)) w_gen;
    rgenerator #(.DATA_WIDTH(DATA_WIDTH)) r_gen;

    wdriver #(.DATA_WIDTH(DATA_WIDTH)) w_drv;
    rdriver #(.DATA_WIDTH(DATA_WIDTH)) r_drv;

    wmonitor #(.DATA_WIDTH(DATA_WIDTH)) w_mon;
    rmonitor #(.DATA_WIDTH(DATA_WIDTH)) r_mon;

    wscoreboard #(.DATA_WIDTH(DATA_WIDTH)) w_scb;
    rscoreboard #(.DATA_WIDTH(DATA_WIDTH)) r_scb;

    mailbox wdrv_mbx;
    mailbox rdrv_mbx;

    mailbox wscb_mbx;
    mailbox rscb_mbx;

    event wdrv_done;
    event rdrv_done;

    event wmon_done;
    event rmon_done;

    event wscb_done;
    event rscb_done;

    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_fifo_if;
    virtual fifo_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    function new();
        w_gen = new();
        r_gen = new();

        w_drv = new();
        r_drv = new();

        w_mon = new();
        r_mon = new();

        w_scb = new();
        r_scb = new();
    endfunction

    virtual task run();
        /* Connect interface handles */
        w_drv.m_fifo_if = m_fifo_if;
        w_drv.m_bfm_if  = m_bfm_if;

        r_drv.m_fifo_if = m_fifo_if;
        r_drv.m_bfm_if  = m_bfm_if;

        w_mon.m_fifo_if = m_fifo_if;
        w_mon.m_bfm_if  = m_bfm_if;

        r_mon.m_fifo_if = m_fifo_if;
        r_mon.m_bfm_if  = m_bfm_if;

        /* Connect mailboxes */
        w_drv.wdrv_mbx = wdrv_mbx;
        r_drv.rdrv_mbx = rdrv_mbx;

        w_scb.wscb_mbx = wscb_mbx;
        r_scb.rscb_mbx = rscb_mbx;

        /* Connect events */
        w_drv.wdrv_done = wdrv_done;
        r_drv.rdrv_done = rdrv_done;

        w_mon.wmon_done = wmon_done;
        r_mon.rmon_done = rmon_done;

        w_scb.wscb_done = wscb_done;
        r_scb.rscb_done = rscb_done;

        /* Start all components */
        fork
            w_gen.run();
            r_gen.run();

            w_drv.run();
            r_drv.run();

            w_mon.run();
            r_mon.run();

            w_scb.run();
            r_scb.run();
        join_any
    endtask
endclass    
