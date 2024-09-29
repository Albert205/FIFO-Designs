class wgenerator #(int DATA_WIDTH = 8, int LOOP = 50);
    event wdrv_done;
    event wscb_done;
    event wrst_done;
    event rrst_done;
    mailbox wdrv_mbx;

    task wreset();
        wtrans #(.DATA_WIDTH(DATA_WIDTH)) wrst_item = new();
        wrst_item.i_wdata  = 0;
        wrst_item.i_winc   = 0;
        wrst_item.i_wrst_n = 1;

        wdrv_mbx.put(wrst_item);
        @(wdrv_done);
        @(wscb_done);

        wrst_item.i_wrst_n = 0;

        wdrv_mbx.put(wrst_item);
        @(wdrv_done);
        @(wscb_done);

        wrst_item.i_wrst_n = 1;

        wdrv_mbx.put(wrst_item);
        @(wdrv_done);
        @(wscb_done);

        $display("T=%0t [wGenerator] wReset completed!");
        ->wrst_done;
    endtask

    task run();
        wreset();
        @(rrst_done);
        for(int i = 0; i < LOOP; i++)
        begin
            wtrans #(.DATA_WIDTH(DATA_WIDTH)) item = new();
            item.randomize();
            $display("T=%0t [wGenerator] Loop:%0d/%0d create next item ...",
                     $time, i+1, LOOP);
            wdrv_mbx.put(item);
            @(wdrv_done);
            @(wscb_done);
        end
    endtask
endclass

class rgenerator #(int DATA_WIDTH = 8, int LOOP = 50);
    event rdrv_done;
    event rscb_done;
    event wrst_done;
    event rrst_done;
    mailbox rdrv_mbx;

    task rreset();
        rtrans #(.DATA_WIDTH(DATA_WIDTH)) rrst_item = new();
        rrst_item.i_rinc   = 0;
        rrst_item.i_rrst_n = 1;

        rdrv_mbx.put(rrst_item);
        @(rdrv_done);
        @(rscb_done);

        rrst_item.i_rrst_n = 0;

        rdrv_mbx.put(rrst_item);
        @(rdrv_done);
        @(rscb_done);

        rrst_item.i_rrst_n = 1;

        rdrv_mbx.put(rrst_item);
        @(rdrv_done);
        @(rscb_done);

        $display("T=%0t [rGenerator] rReset completed!");
        ->rrst_done;
    endtask

    task run();
        rreset();
        @(wrst_done);
        for(int i = 0; i < LOOP; i++)
        begin
            rtrans #(.DATA_WIDTH(DATA_WIDTH)) item = new();
            item.randomize();
            $display("T=%0t [rGenerator] Loop:%0d/%0d create next item ...",
                     $time, i+1, LOOP);
            rdrv_mbx.put(item);
            @(rdrv_done);
            @(rscb_done);
        end
    endtask
endclass



    
