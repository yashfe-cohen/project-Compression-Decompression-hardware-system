`timescale 1 ns/ 1 ns
module Compression_vlg_tst();

    reg clk;
    reg rst_n;
    reg phya_rx_crs_dv;
    reg [1:0] phya_rxd;
    reg phyb_rx_crs_dv;
    reg [1:0] phyb_rxd;

    wire phya_tx_en;
    wire [1:0] phya_txd;
    wire phyb_tx_en;
    wire [1:0] phyb_txd;

    Compression i1 (
        .clk(clk),
        .phya_rx_crs_dv(phya_rx_crs_dv),
        .phya_rxd(phya_rxd),
        .phya_tx_en(phya_tx_en),
        .phya_txd(phya_txd),
        .phyb_rx_crs_dv(phyb_rx_crs_dv),
        .phyb_rxd(phyb_rxd),
        .phyb_tx_en(phyb_tx_en),
        .phyb_txd(phyb_txd),
        .rst_n(rst_n)
    );
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    reg [335:0] my_byte = 336'hFFFFFFFFFFFF_001122334455_0906_0001_0800_06_04_0001_001122334455_C0A80101_000000000000_0A64660C; 
    integer i;

    initial begin
        rst_n = 0; 
        phya_rx_crs_dv = 1'b0; 
        phya_rxd = 2'b00; 
        phyb_rx_crs_dv = 1'b0; 
        phyb_rxd = 2'b00;
        
        #100;
        rst_n = 1; 
        #100;

     
        @(negedge clk);
        phya_rx_crs_dv = 1'b1; 

        @(negedge clk);
        phya_rxd = 2'b11;      
        for (i = 0; i < 168; i = i + 1) begin
        @(negedge clk);
        phya_rxd = my_byte[1:0];   
        my_byte  = my_byte >> 2;   
        end

        @(negedge clk);
        phya_rx_crs_dv = 1'b0; 
        phya_rxd = 2'b00;

        @(negedge clk);
        phya_rx_crs_dv = 1'b1; 

        @(negedge clk);
        phya_rx_crs_dv = 1'b0;
        phya_rxd = 2'b00;
        
        #200; 
        $stop; 
    end

endmodule