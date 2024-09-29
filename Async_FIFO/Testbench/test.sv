class test #(int DATA_WIDTH = 8);
    environment env #(.DATA_WIDTH(DATA_WIDTH));

    function new();
        env = new();
    endfunction

    virtual task run();
        env.run();
    endtask
endclass