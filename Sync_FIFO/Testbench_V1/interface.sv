interface fifo_if #(parameter DATA_WIDTH = 8) (input bit i_Clk);
    logic                  i_Reset;
    logic [DATA_WIDTH-1:0] i_Wr_Data;
    logic                  i_Wr_En;
    logic                  i_Rd_En;
    logic                  o_Full;
    logic                  o_Empty;
    logic [DATA_WIDTH-1:0] o_Rd_Data;
    logic                  o_Data_Valid;
  
  	bit reset_complete = 1'b0;
    int delay;

    always_ff @(posedge i_Clk, negedge i_Reset)
      if(i_Reset)
      begin
        #1;
        reset_complete <= 1'b1;
      end

    clocking fifo_cb @(posedge i_Clk);
      	input o_Full, o_Empty, o_Rd_Data, o_Data_Valid;
        output i_Reset, i_Wr_Data, i_Wr_En, i_Rd_En;
    endclocking

    property read_when_empty;
      @(posedge i_Clk) disable iff(!reset_complete)
      	!(o_Empty && o_Data_Valid);
    endproperty
    assert_read_when_empty : assert property (read_when_empty);

    modport DUT (input i_Clk, i_Reset, i_Wr_Data, i_Wr_En, i_Rd_En,
                 output o_Full, o_Empty, o_Rd_Data, o_Data_Valid);

    modport TB (clocking fifo_cb);

endinterface

interface clk_if();
    logic i_Clk;
    initial
        i_Clk <= 0;
    always #10 i_Clk = ~i_Clk;
endinterface