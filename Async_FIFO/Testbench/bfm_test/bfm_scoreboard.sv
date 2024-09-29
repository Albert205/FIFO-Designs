class scoreboard #(int DATA_WIDTH = 8, ADDR_WIDTH = 2);
    mailbox scb_mbx;
    event scb_done;

    int ERROR_COUNT = 0;
    int PASS_COUNT = 0;

    task run();
        bit [DATA_WIDTH-1:0] ref_queue [$];
        bit [DATA_WIDTH-1:0] arr_Rd_Data;

        bit arr_Full;
        bit arr_Empty;

        forever
        begin
          	bfm_trans #(.DATA_WIDTH(DATA_WIDTH)) item;
            scb_mbx.get(item);
            item.printAll("Scoreboard");

            if(item.i_winc && !item.i_rinc)
            begin
                if(!arr_Full)
                begin
                    ref_queue.push_front(item.i_wdata);
                end
            end
            else if(item.i_rinc && !item.i_winc)
            begin
                if(!arr_Empty)
                begin
                    ref_queue.pop_back();
                end
            end
            else if(item.i_rinc && item.i_winc)
            begin
                ref_queue.push_front(item.i_wdata);
                ref_queue.pop_back();
            end

            arr_Rd_Data = ref_queue[ref_queue.size()-1];

            if(ref_queue.size() == 0)
            begin
                arr_Empty = 1'b1;
            end
            else if(ref_queue.size() == 2**ADDR_WIDTH)
            begin
                arr_Full = 1'b1;
            end
            else if(ref_queue.size() < 2**ADDR_WIDTH)
            begin
                arr_Empty = 1'b0;
                arr_Full = 1'b0;
            end

            /* Print the contents of the array */
            $write("[%0t] Scoreboard print ref_array: [", $time);
            foreach(ref_queue[i])
                $write(" 0x%0h ", ref_queue[i]);
            $display("]");          	

            /* Check 'FULL' status */
            if(item.o_wfull != arr_Full)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Full' mismatch bfm=%0b item=%0b",
                         $time, arr_Full, item.o_wfull);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Full' match bfm=%0b item=%0b",
                         $time, arr_Full, item.o_wfull);
            end
            
            /* Check 'EMPTY' status */
            if(item.o_rempty != arr_Empty)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Empty' mismatch bfm=%0b item=%0b",
                         $time, arr_Empty, item.o_rempty);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Empty' match bfm=%0b item=%0b",
                         $time, arr_Empty, item.o_rempty);
            end
            
            /* Check 'RDATA' */
            if(item.o_rdata != arr_Rd_Data)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Rd_Data' mismatch bfm=0x%0h item=0x%0h",
                         $time, arr_Rd_Data, item.o_rdata);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Rd_Data' match bfm=0x%0h item=0x%0h",
                         $time, arr_Rd_Data, item.o_rdata);
            end
            
            ->scb_done;
        end

    endtask
endclass


