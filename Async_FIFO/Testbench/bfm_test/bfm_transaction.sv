class bfm_trans #(int DATA_WIDTH = 8);
    /* Random variables */
    rand bit [DATA_WIDTH-1:0] i_wdata;
    rand bit                  i_winc;
    rand bit                  i_rinc;

    rand int                  delay; // Random delay between consecutive operations

    constraint c_inc
    {
        i_winc dist {0:=2, 1:=8};
        i_rinc dist {0:=2, 1:=8};
    }

    constraint c_delay
    {
        delay dist {0:=5, [1:5]:=5};
    }

    /* Non-random variables */
    bit                  i_wrst_n;
    bit                  i_rrst_n;
    bit [DATA_WIDTH-1:0] o_rdata;
    bit                  o_wfull;
    bit                  o_rempty;

    function void printInputs(string tag="");
        string operation;
        if(i_wrst_n && i_rrst_n)
            operation = "Reset";
        else if(i_winc && i_rinc)
            operation = "Write and read";
        else if(i_winc)
            operation = "Write";
        else if(i_rinc)
            operation = "Read";
        else
            operation = "No-op";
        $display("T=%0t [%s: %s] Reset=%0b Write=%0b, Read=%0b, wData=0x%0h",
                  $time, tag, operation, i_wrst_n && i_rrst_n, i_winc, i_rinc, i_wdata);
    endfunction

    function void printOutputs(string tag="");
        $display("T=%0t [%s] Full=%0b, Empty=%0b, rData=0x%0h",
                  $time, tag, o_wfull, o_rempty, o_rdata);
    endfunction

    function void printAll(string tag="");
        string operation;
        if(i_wrst_n && i_rrst_n)
            operation = "Reset";
        else if(i_winc && i_rinc)
            operation = "Write and read";
        else if(i_winc)
            operation = "Write";
        else if(i_rinc)
            operation = "Read";
        else
            operation = "No-op";
        $display("T=%0t [%s: %s] Reset=%0b Write=%0b, Read=%0b, wData=0x%0h",
                 $time, tag, operation, i_wrst_n && i_rrst_n, i_winc, i_rinc, i_wdata);
        $display("  [OUTPUTS] Full=%0b, Empty=%0b, rData=0x%0h",
                 o_wfull, o_rempty, o_rdata);
    endfunction
        
endclass
