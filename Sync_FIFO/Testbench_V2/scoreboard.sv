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
        bit arr_Data_Valid;

        forever
        begin
          	fifo_trans #(.DATA_WIDTH(DATA_WIDTH)) item;
            scb_mbx.get(item);
            item.printAll("Scoreboard");

            if(item.i_Wr_En && !item.i_Rd_En)
            begin
                if(!arr_Full)
                begin
                    ref_queue.push_front(item.i_Wr_Data);
                end
            end
            else if(item.i_Rd_En && !item.i_Wr_En)
            begin
                if(!arr_Empty)
                begin
                    ref_queue.pop_back();
                end
            end
            else if(item.i_Rd_En && item.i_Wr_En)
            begin
                ref_queue.push_front(item.i_Wr_Data);
                ref_queue.pop_back();
            end

            arr_Rd_Data = ref_queue[ref_queue.size()-1];

            if(ref_queue.size() == 0)
            begin
                arr_Empty = 1'b1;
                arr_Data_Valid = 1'b0;
            end
            else if(ref_queue.size() == 2**ADDR_WIDTH)
            begin
                arr_Full = 1'b1;
            end
            else if(ref_queue.size() < 2**ADDR_WIDTH)
            begin
                arr_Empty = 1'b0;
                arr_Full = 1'b0;
                arr_Data_Valid = 1'b1;
            end

            /* Print the contents of the array */
            $write("[%0t] Scoreboard print ref_array: [", $time);
            foreach(ref_queue[i])
                $write(" 0x%0h ", ref_queue[i]);
            $display("]");          	

            /* Check 'FULL' status */
            if(item.o_Full != arr_Full)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Full' mismatch bfm=%0b item=%0b",
                         $time, arr_Full, item.o_Full);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Full' match bfm=%0b item=%0b",
                         $time, arr_Full, item.o_Full);
            end
            
            /* Check 'EMPTY' status */
            if(item.o_Empty != arr_Empty)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Empty' mismatch bfm=%0b item=%0b",
                         $time, arr_Empty, item.o_Empty);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Empty' match bfm=%0b item=%0b",
                         $time, arr_Empty, item.o_Empty);
            end
            
            /* Check 'RDATA' */
            if(item.o_Rd_Data != arr_Rd_Data)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Rd_Data' mismatch bfm=0x%0h item=0x%0h",
                         $time, arr_Rd_Data, item.o_Rd_Data);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Rd_Data' match bfm=0x%0h item=0x%0h",
                         $time, arr_Rd_Data, item.o_Rd_Data);
            end
            
            /* Check 'DATA_VALID' status */
            if(item.o_Data_Valid != arr_Data_Valid)
            begin
                ERROR_COUNT += 1;
                $display("[%0t] Scoreboard ERROR => 'o_Data_Valid' mismatch bfm=%0b item=%0b",
                         $time, arr_Data_Valid, item.o_Data_Valid);
            end
            else
            begin
                PASS_COUNT += 1;
                $display("[%0t] Scoreboard PASS => 'o_Rd_Data' match bfm=%0b item=%0b",
                         $time, arr_Data_Valid, item.o_Data_Valid);
            end
            
            ->scb_done;
        end

    endtask
endclass


