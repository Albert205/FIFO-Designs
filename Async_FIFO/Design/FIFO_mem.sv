module FIFO_mem
#(parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 3)
(
    input  logic                  i_wclk,
    input  logic                  i_wclken,
    input  logic [DATA_WIDTH-1:0] i_wdata,
    input  logic [ADDR_WIDTH-1:0] i_waddr,
    input  logic [ADDR_WIDTH-1:0] i_raddr,
    output logic [DATA_WIDTH-1:0] o_rdata
);
    localparam MEMDEPTH = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] r_FIFO_mem [0:MEMDEPTH-1];

    always_ff @(posedge i_wclk)
        if (i_wclken)
            r_FIFO_mem[i_waddr] <= i_wdata;
    
    assign o_rdata = r_FIFO_mem[i_raddr];
endmodule
