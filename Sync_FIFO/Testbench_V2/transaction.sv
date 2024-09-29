class fifo_trans #(int DATA_WIDTH = 8);
    rand bit [DATA_WIDTH-1:0] i_Wr_Data;
    rand bit                  i_Wr_En;
    rand bit                  i_Rd_En;

    constraint c_enables
    {
      	i_Wr_En dist {0 := 3, 1 := 10};
        i_Rd_En dist {0 := 3, 1 := 2};
      	// i_Wr_En ^ i_Rd_En == 1;
    }
    
    bit                  o_Full;
    bit                  o_Empty;
    bit [DATA_WIDTH-1:0] o_Rd_Data;
    bit                  o_Data_Valid;
  	bit                  i_Reset;

    rand int delay;

    constraint c_delay
    {
        delay >= 0;
        delay <= 5;
    }

    function void copy(fifo_trans tmp);
        // Inputs
        this.i_Wr_Data = tmp.i_Wr_Data;
        this.i_Wr_En   = tmp.i_Wr_En;
        this.i_Rd_En   = tmp.i_Rd_En;
        this.i_Reset   = tmp.i_Reset;

        // Outputs
        this.o_Full       = tmp.o_Full;
        this.o_Empty      = tmp.o_Empty;
        this.o_Rd_Data    = tmp.o_Rd_Data;
        this.o_Data_Valid = tmp.o_Data_Valid;
    endfunction


    function void printInputs(string tag="");
      	string operation;
        if(i_Reset)
            operation = "Reset";
        else if(i_Wr_En && i_Rd_En)
          operation = "Write and Read";
        else if(i_Rd_En) 
         operation = "Read";
        else if(i_Wr_En)
          operation = "Write";
        else
          operation = "No-op";
        $display("T=%0t [%s: %s] wdata=0x%0h, reset=%0b, write=%0b, read=%0b, delay=%0d",
                 $time, tag, operation, i_Wr_Data, i_Reset, i_Wr_En, i_Rd_En, delay);
    endfunction

    function void printOutputs(string tag="");
        $display("T=%0t [%s] full=%0p, empty=%0b, rdata=0x%0h, valid=%0b",
                 $time, tag, o_Full, o_Empty, o_Rd_Data, o_Data_Valid);
    endfunction

    function void printAll(string tag="")'
        string operation;
        if(i_Wr_En && i_Rd_En)
          operation = "Write and Read";
        else if(i_Rd_En) 
         operation = "Read";
        else if(i_Wr_En)
          operation = "Write";
        else
          operation = "No-op";
        $display("T=%0t [%s: %s] wdata=0x%0h, reset=%0b, write=%0b, read=%0b, delay=%0d \n [OUTPUTS] full=%0b, empty=%0b, rdata=0x%0h, valid=%0b",
                 $time, tag, operation, i_Wr_Data, i_Reset, i_Wr_En, i_Rd_En, delay, o_Full, o_Empty, o_Rd_Data, o_Data_Valid);
    endfunction
endclass