`timescale 1ns/1ns

module top;
    bit i_Clk;
    always #10 i_Clk = ~i_Clk;

    initial
        i_Clk <= 0;

    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 2;

    fifo_if #(.DATA_WIDTH(DATA_WIDTH)) fifo_if0 (i_Clk);

    fifo_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo_Inst0 (fifo_if0.DUT);
    fifo_test #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) test_Inst0 (._if(fifo_if0));

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule : top

class fifo_trans #(int DATA_WIDTH = 8);
    rand bit [DATA_WIDTH-1:0] i_Wr_Data;
    rand bit                  i_Wr_En;
    rand bit                  i_Rd_En;

    constraint c_enables
    {
      	i_Wr_En dist {0 := 3, 1 := 10};
        i_Rd_En dist {0 := 3, 1 := 2};
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

    function void printInputs(string tag="");
      	string operation;
        if(i_Wr_En && i_Rd_En)
          operation = "Write and Read";
        else if(i_Rd_En) 
         operation = "Read";
        else if(i_Wr_En)
          operation = "Write";
        else
          operation = "No-op";
      $display("T=%0t [%s] wdata=0x%0h, reset=%0b, write=%0b, read=%0b, delay=%0d",
                 $time, operation, i_Wr_Data, i_Reset, i_Wr_En, i_Rd_En, delay);
    endfunction

    function void printOutputs(string tag="");
      $display("T=%0t [%s] full=%0p, empty=%0b, rdata=0x%0h, valid=%0b",
                 $time, tag, o_Full, o_Empty, o_Rd_Data, o_Data_Valid);
    endfunction
endclass

program automatic fifo_test #(int DATA_WIDTH = 8, ADDR_WIDTH = 2) (fifo_if _if);

  fifo_trans trans;

    initial
    begin
        trans = new();
        init();
        for(int i = 0; i < 20; i++)
            fifo_op();
        #10 $finish;
    end

    task init();
      	_if.i_Reset <= 0;
      	_if.reset_complete <= 0;
        @(negedge _if.fifo_cb);
        _if.i_Wr_Data <= 0;
        _if.i_Wr_En <= 0;
        _if.i_Rd_En <= 0;

        repeat (2) @(negedge _if.fifo_cb);
        _if.i_Reset <= 1;

        @(negedge _if.fifo_cb);
        _if.i_Reset <= 0;
      	_if.reset_complete <= 1;
    endtask : init

    task fifo_op();
        trans.randomize();
      $display("------------");
        trans.printInputs();
        _if.i_Reset <= trans.i_Reset;
        _if.i_Wr_Data <= trans.i_Wr_Data;
        _if.i_Wr_En <= trans.i_Wr_En;
        _if.i_Rd_En <= trans.i_Rd_En;

      @(posedge _if.fifo_cb);
        trans.o_Full <= _if.o_Full;
        trans.o_Empty <= _if.o_Empty;
        trans.o_Rd_Data <= _if.o_Rd_Data;
        trans.o_Data_Valid <= _if.o_Data_Valid;
      	#1ns;
        trans.printOutputs("FIFO OP Complete");

        #trans.delay;
    endtask
endprogram



