class generator #(int DATA_WIDTH = 8);
    int loop = 20;
    event drv_done;
    event scb_done;
    mailbox drv_mbx;

    task run();
        for (int i = 0; i < loop; i++)
        begin
          	fifo_trans #(.DATA_WIDTH(DATA_WIDTH)) item = new();
            if(i == 0)
            begin
                item.i_Reset   = 0;
                item.i_Wr_Data = 0;
                item.i_Wr_En   = 0;
                item.i_Rd_En   = 0;
                item.delay     = 1;
            end
            else if (i == 1)
            begin
                item.i_Reset   = 1;
                item.i_Wr_Data = 0;
                item.i_Wr_En   = 0;
                item.i_Rd_En   = 0;
                item.delay     = 1;
            end
            else if (i == 2)
            begin
                item.i_Reset   = 0;
                item.i_Wr_Data = 0;
                item.i_Wr_En   = 0;
                item.i_Rd_En   = 0;
                item.delay     = 1;
            end
            else
                item.randomize();
            $display("------------------------------------------------------------------------");
            $display("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i+1, loop);
            drv_mbx.put(item);
            @(drv_done);
            @(scb_done);
        end
    endtask
endclass