class clk_freq_rand;
    rand int per_wclk;
    rand int per_rclk;

    constraint c_wclk
    {
        per_wclk >= 20;
        per_wclk <= 60;
    }

    constraint c_rclk
    {
        per_rclk >= 20;
        per_rclk <= 60;
    }

    function void display();
        $display("---------- Randomized Clock Periods ----------");
        $display("Read clock period: %0d", per_rclk);
        $display("Write clock period: %0d", per_wclk);
        $display ("---------------------------------------------");
    endfunction
endclass