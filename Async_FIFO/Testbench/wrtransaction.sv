class wtrans #(int DATA_WIDTH = 8);
    /* Random variables */
    rand bit [DATA_WIDTH-1:0] i_wdata;
    rand bit                  i_winc;
    rand int                  wdelay;

    constraint c_inc
    {
        i_winc dist {0:=4, 1:=6};
    }

    constraint c_delay
    {
        delay dist {0:=5, [1:5]:=10};
    }

    /* Non-random variables */
    bit i_wrst_n = 1'b1;
    bit o_wfull;

    function void printInputs(string tag="");
        $display("T=%0t [%s] Reset=%0b, wData = 0x%0h, Write = %0b",
                  $time, tag, i_wrst_n, i_wdata, i_winc);
    endfunction

    function void printOutput(string tag="");
        $display("T=%0t [%s] Full=%0b",
                  $time, tag, o_wfull);
    endfunction

    function void printAll(string tag="");
        printInputs(tag);
        printOutput(tag);
    endfunction

endclass

class rtrans #(int DATA_WIDTH = 8); 
    /* Random variables */
    rand bit i_rinc;
    rand int rdelay;

    constraint c_inc
    {
        i_rinc dist {0:=4, 1:=6};
    }

    constraint c_delay
    {
        delay dist {0:=5, [1:5]:=10};
    }

    /* Non-random variables */
    bit                  i_rrst_n = 1'b1;
    bit                  o_rempty;
    bit [DATA_WIDTH-1:0] o_rdata;

    function void printInputs(string tag="");
        $display("T=%0t [%s] Reset=%0b, Read=%0b",
                  $time, tag, i_rrst_n, i_rinc);
    endfunction

    function void printOutput(string tag="");
        $display("T=%0t [%s] Empty=%0b, rData=0x%0h",
                  $time, tag, o_rempty, o_rdata);
    endfunction

    function void printAll(string tag="");
        printInputs(tag);
        printOutput(tag);
    endfunction
endclass  