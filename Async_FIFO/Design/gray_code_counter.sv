module gray_code_counter
#(parameter ADDR_WIDTH = 3)
(
    input  logic                  i_clk,
    input  logic                  i_rst_n,
    input  logic                  i_inc,
    input  logic                  i_status,
    output logic [ADDR_WIDTH-1:0] o_addr,
    output logic [ADDR_WIDTH:0]   o_ptr,
    output logic [ADDR_WIDTH:0]   o_gray_next
);

    logic [ADDR_WIDTH-1:0] r_bin, r_bin_next;
    logic [ADDR_WIDTH-1:0] r_gray_next;

    // Binary count register
    always_ff @(posedge i_clk or negedge i_rst_n)
    begin
        if(!i_rst_n)
            r_bin <= 'b0;
        else
            r_bin <= r_bin_next;
    end

    assign o_addr = r_bin[ADDR_WIDTH-2:0];

    // Binary count incrementor
    always_comb
        r_bin_next = r_bin + (i_inc && ~i_status);
    
    // Binary to gray logic
    always_comb
        r_gray_next = (r_bin_next >> 1) ^ r_bin_next;
    
    assign o_gray_next = r_gray_next;
    
    // Gray-code register
    always_ff @(posedge i_clk or negedge i_rst_n)
    begin
        if(!i_rst_n)
            o_ptr <= 0;
        else
            o_ptr <= r_gray_next;
    end

endmodule