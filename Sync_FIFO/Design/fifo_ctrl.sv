module fifo_ctrl
#(
    parameter ADDR_WIDTH = 2
)
(
    input logic                   i_Clk,
    input logic                   i_Reset,
    input logic                   i_Wr_En,
    input logic                   i_Rd_En,
    output logic                  o_Full,
    output logic                  o_Empty,
    output logic [ADDR_WIDTH-1:0] o_Wr_Addr,
    output logic [ADDR_WIDTH-1:0] o_Rd_Addr,
    output logic                  o_Data_Valid
);

    logic [1:0] w_FIFO_Cmd;

    logic [ADDR_WIDTH-1:0] r_Rd_Ptr, r_Rd_Ptr_Next;
    logic [ADDR_WIDTH-1:0] r_Wr_Ptr, r_Wr_Ptr_Next;
    logic r_Full, r_Full_Next;
    logic r_Empty, r_Empty_Next;
    logic r_Data_Valid, r_Data_Valid_Next;

    assign w_FIFO_Cmd = {i_Wr_En, i_Rd_En};

  always_ff @(posedge i_Clk, negedge i_Reset)
    begin
      	if(i_Reset)
        begin
            r_Rd_Ptr     <= 1'b0;
            r_Wr_Ptr     <= 1'b0;
            r_Full       <= 1'b0;
            r_Empty      <= 1'b1;
            r_Data_Valid <= 1'b0;
        end
        else    
        begin
            r_Rd_Ptr     <= r_Rd_Ptr_Next;
            r_Wr_Ptr     <= r_Wr_Ptr_Next;
            r_Full       <= r_Full_Next;
            r_Empty      <= r_Empty_Next;
            r_Data_Valid <= r_Data_Valid_Next;
        end
    end

    always_comb
    begin
        r_Rd_Ptr_Next     = r_Rd_Ptr;
        r_Wr_Ptr_Next     = r_Wr_Ptr;
        r_Full_Next       = r_Full;
        r_Empty_Next      = r_Empty;
        r_Data_Valid_Next = r_Data_Valid;
        case(w_FIFO_Cmd)            // Different combinations of FIFO read and write
            2'b01:                  // Read only
            begin
                if(~r_Empty)
                begin
                    r_Rd_Ptr_Next = r_Rd_Ptr + 1;
                    r_Full_Next = 1'b0;
                    if(r_Rd_Ptr_Next == r_Wr_Ptr)
                    begin
                        r_Empty_Next = 1'b1;
                        r_Data_Valid_Next = 1'b0;
                    end
                end
            end
            2'b10:                  // Write only
            begin
                if(~r_Full)
                begin
                    r_Wr_Ptr_Next = r_Wr_Ptr + 1;
                    r_Empty_Next = 1'b0;
                    r_Data_Valid_Next = 1'b1;
                    if(r_Wr_Ptr_Next == r_Rd_Ptr)
                        r_Full_Next = 1'b1;
                end
            end
            2'b11:                  // Read and write
            begin
                r_Wr_Ptr_Next = r_Wr_Ptr + 1;
                r_Rd_Ptr_Next = r_Rd_Ptr + 1;
            end
            default:
            begin
            end
        endcase
    end

    // Output logic
    assign o_Full = r_Full;
    assign o_Empty = r_Empty;
    assign o_Wr_Addr = r_Wr_Ptr;
    assign o_Rd_Addr = r_Rd_Ptr;
    assign o_Data_Valid = r_Data_Valid;

endmodule
