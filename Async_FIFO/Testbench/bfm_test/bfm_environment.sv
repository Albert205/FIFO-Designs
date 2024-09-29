class environment #(int DATA_WIDTH = 8, ADDR_WIDTH = 2);

  	bfm_generator   #(.DATA_WIDTH(DATA_WIDTH)) g0;
    bfm_driver      #(.DATA_WIDTH(DATA_WIDTH)) d0;
    bfm_monitor     #(.DATA_WIDTH(DATA_WIDTH))  m0;
  	bfm_scoreboard  #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))s0;

    mailbox scb_mbx;
    mailbox drv_mbx;

    virtual bfm_if #(.DATA_WIDTH(DATA_WIDTH)) m_bfm_if;

    event drv_done;
    event scb_done;

    function new();
        g0      = new();
        d0      = new();
        m0      = new();
        s0      = new();
        scb_mbx = new();
        drv_mbx = new();
    endfunction

    virtual task run();
        /* Connect virtual interface handles */
        d0.m_bfm_if = m_bfm_if;
        m0.m_bfm_if = m_bfm_if;

        /* Connect mailboxes */
        d0.drv_mbx = drv_mbx;
        g0.drv_mbx = drv_mbx;

        m0.scb_mbx = scb_mbx;
        s0.scb_mbx = scb_mbx;

        /* Connect event handles */
        d0.drv_done = drv_done;
        g0.drv_done = drv_done;
        m0.drv_done = drv_done;
        s0.scb_done = scb_done;
        g0.scb_done = scb_done;

        /* Start all components */
        fork
            g0.run();
            d0.run();
            m0.run();
            s0.run();
        join_any
    endtask
endclass
