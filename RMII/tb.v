`timescale 1ns / 1ps

module tb_compression();

    // Inputs
    reg clk;
    reg rst_n;
    
    // Port A Inputs
    reg phya_rx_crs_dv;
    reg [1:0] phya_rxd;
    // Port A Outputs
    wire phya_tx_en;
    wire [1:0] phya_txd;
    
    // Port B Inputs
    reg phyb_rx_crs_dv;
    reg [1:0] phyb_rxd;
    // Port B Outputs
    wire phyb_tx_en;
    wire [1:0] phyb_txd;

    // Instantiation of the Top Level Module (C is uppercase)
    Compression uut (
        .clk(clk), 
        .rst_n(rst_n), 
        
        .phya_rx_crs_dv(phya_rx_crs_dv), 
        .phya_rxd(phya_rxd), 
        .phya_tx_en(phya_tx_en), 
        .phya_txd(phya_txd),
        
        .phyb_rx_crs_dv(phyb_rx_crs_dv), 
        .phyb_rxd(phyb_rxd), 
        .phyb_tx_en(phyb_tx_en), 
        .phyb_txd(phyb_txd)
    );

    // Clock generation (50 MHz for RMII -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        
        phya_rx_crs_dv = 0;
        phya_rxd = 2'b00;
        
        phyb_rx_crs_dv = 0;
        phyb_rxd = 2'b00;

        #40;
        rst_n = 1;
        #20;
        
        
        phya_rx_crs_dv = 1'b1; 
        
        phya_rxd = 2'b01; #20; 
        phya_rxd = 2'b01; #20; 
        phya_rxd = 2'b11; #20;  
        

        phya_rxd = 2'b00; #20; 
        phya_rxd = 2'b01; #20; 
        phya_rxd = 2'b10; #20; 
        phya_rxd = 2'b11; #20; 

       
        
        phya_rxd = 2'b00; #120;
        
        phya_rx_crs_dv = 1'b0; 
        phya_rxd = 2'b00;
        
        #200;
        $finish;
    end
      
endmodule