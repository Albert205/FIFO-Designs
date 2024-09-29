class bfm_generator #(int DATA_WIDTH = 8);
    int loop = 50;
    event drv_done;
    event scb_done;
    mailbox drv_mbx;

    task run();
        for (int i = 0; i < loop; i++)
        begin
            bfm_trans #(.DATA_WIDTH(DATA_WIDTH)) item = new();
            case(i)
                0: 
                    begin
                        item.i_wdata  = 0;
                        item.i_winc   = 0;
                        item.i_wrst_n = 1;
                        item.i_rinc   = 0;
                        item.i_rrst_n = 1;
                    end
                1:
                    begin
                        item.i_wdata  = 0;
                        item.i_winc   = 0;
                        item.i_wrst_n = 0;
                        item.i_rinc   = 0;
                        item.i_rrst_n = 0;
                    end
                2:
                    begin
                        item.i_wdata  = 0;
                        item.i_winc   = 0;
                        item.i_wrst_n = 1;
                        item.i_rinc   = 0;
                        item.i_rrst_n = 1;
                    end
                default:
                    item.randomize();
            endcase

            $display("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i+1, loop);
            drv_mbx.put(item);
            @(drv_done);
            @(scb_done);
        end
    endtask
endclass