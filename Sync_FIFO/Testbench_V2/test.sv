class test #(int DATA_WIDTH = 8, ADDR_WIDTH = 2);
    environment e0 #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH));
    function new();
        e0 = new();
    endfunction

    virtual task run();
        e0.run();
    endtask
endclass