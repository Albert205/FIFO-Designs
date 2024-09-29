module bfm_fifo
#(parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4)
(
    fifo_if.BFM _if
);
    logic [ADDR_WIDTH:0] r_wptr, r_wrptr1, r_wrptr2, r_wrptr3;
    logic [ADDR_WIDTH:0] r_rptr, r_rwptr1, r_rwptr2, r_rwptr3;

    localparam MEMDEPTH = 1<<ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] r_ex_mem [0:MEMDEPTH-1];

    always_ff @(posedge _if.i_wclk or negedge _if.i_wrst_n)
    begin
        if (!_if.i_wrst_n)
            r_wptr <= 0;
        else if (_if.i_winc && !_if.o_wfull)
        begin
            r_ex_mem[r_wptr[ADDR_WIDTH-1:0]] <= _if.i_wdata;
            r_wptr                           <= r_wptr + 1;
        end
    end

    always_ff @(posedge _if.i_wclk or negedge _if.i_wrst_n)
    begin
        if (!_if.i_wrst_n)
            {r_wrptr3, r_wrptr2, r_wrptr1} <= 0;
        else
            {r_wrptr3, r_wrptr2, r_wrptr1} <= {r_wrptr2, r_wrptr1, r_rptr};
    end

    always @(posedge _if.i_rclk or negedge _if.i_rrst_n)
    begin
        if (!_if.i_rrst_n)
            r_rptr <= 0;
        else if(_if.i_rinc && !_if.o_rempty)
            r_rptr <= r_rptr + 1;
    end

    always @(posedge _if.i_rclk or negedge _if.i_rrst_n)
    begin
        if (!_if.i_rrst_n)
             {r_rwptr3, r_rwptr2, r_rwptr1} <= 0;
        else 
            {r_rwptr3, r_rwptr2, r_rwptr1}  <= {r_rwptr2, r_rwptr1, r_wptr};
    end

    assign _if.o_rdata  = r_ex_mem[r_rptr[ADDR_WIDTH-1:0]];
    assign _if.o_rempty = (r_rptr == r_rwptr3);
    assign _if.o_wfull  = ((r_wptr[ADDR_WIDTH-1:0] == r_wrptr3[ADDR_WIDTH-1:0]) &&
                        (r_wptr[ADDR_WIDTH]    != r_wrptr3[ADDR_WIDTH]    ));
endmodule
