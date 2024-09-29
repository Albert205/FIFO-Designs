module register_file
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2
)
(
    input logic                     i_Clk,
    input logic [DATA_WIDTH-1:0]    i_Wr_Data,
    input logic [ADDR_WIDTH-1:0]    i_Wr_Addr,
    input logic                     i_Wr_En,
    input logic [ADDR_WIDTH-1:0]    i_Rd_Addr,
    output logic [DATA_WIDTH-1:0]   o_Rd_Data
);

    logic [DATA_WIDTH-1:0] r_Mem_Arr [0:2**ADDR_WIDTH-1];

    always_ff @(posedge i_Clk)
        if(i_Wr_En)
            r_Mem_Arr[i_Wr_Addr] <= i_Wr_Data;
    
    assign o_Rd_Data = r_Mem_Arr[i_Rd_Addr];
endmodule

