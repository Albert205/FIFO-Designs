class wscoreboard #(int DATA_WIDTH = 8);
    mailbox wscb_mbx;
    event wscb_done;
    event wmon_done;

    int W_ERROR_COUNT = 0;
    int W_PASS_COUNT = 0;

    task run();
        forever
        begin
            @(wmon_done);
            wtrans #(.DATA_WIDTH(DATA_WIDTH)) dut_item;
            wtrans #(.DATA_WIDTH(DATA_WIDTH)) bfm_item;

            wscb_mbx.get(dut_item);
            wscb_mbx.get(bfm_item);

            dut_item.printAll("DUT");
            bfm_item.printAll("BFM");

            // Check FULL status
            if(bfm_item.o_wfull != dut_item.o_wfull)
            begin
                W_ERROR_COUNT += 1;
                $display("T=%0t [wScoreboard ERROR] => o_wfull mismatch", $time);
            end
            else
            begin
                W_PASS_COUNT += 1;
                $display("T=%0t [wScoreboard PASS] => o_wfull match", $time);
            end
            
            $display("DUT = %0b, BFM = %0b", dut_item.o_wfull, bfm_item.o_wfull);

            ->wscb_done;
        end
    endtask
endclass

class wscoreboard #(int DATA_WIDTH = 8);
    mailbox rscb_mbx;
    event rscb_done;
    event rmon_done;

    int R_ERROR_COUNT = 0;
    int R_PASS_COUNT = 0;

    task run();
        forever
        begin
            @(rmon_done);
            rtrans #(.DATA_WIDTH(DATA_WIDTH)) dut_item;
            rtrans #(.DATA_WIDTH(DATA_WIDTH)) bfm_item;

            rscb_mbx.get(dut_item);
            rscb_mbx.get(bfm_item);

            dut_item.printAll("DUT");
            bfm_item.printAll("BFM");

            // Check EMPTY status
            if(bfm_item.o_rempty != dut_item.o_rempty)
            begin
                R_ERROR_COUNT += 1;
                $display("T=%0t [rScoreboard ERROR] => o_rempty mismatch", $time);
            end
            else
            begin
                R_PASS_COUNT += 1;
                $display("T=%0t [rScoreboard PASS] => o_rempty match", $time);
            end
            
            $display("DUT = %0b, BFM = %0b", dut_item.o_rempty, bfm_item.o_rempty);

            // Check DATA
            if(bfm_item.o_rdata != dut_item.o_rdata)
            begin
                R_ERROR_COUNT += 1;
                $display("T=%0t [rScoreboard ERROR] => o_rdata mismatch", $time);
            end
            else
            begin
                R_PASS_COUNT += 1;
                $display("T=%0t [rScoreboard PASS] => o_rdata match", $time);
            end

            $display("DUT = 0x%0h, BFM = 0x%0h", dut_item.o_rdata, bfm_item.o_rdata);

            ->wscb_done;
        end
    endtask
endclass



