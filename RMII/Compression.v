module Compression (
    input            clk,          
    input            rst_n,        
    
    // RJ45 Port A
    input            phya_rx_crs_dv, 
    input      [1:0] phya_rxd,       
    output           phya_tx_en,     
    output     [1:0] phya_txd,       
    
    // RJ45 Port B
    input            phyb_rx_crs_dv, 
    input      [1:0] phyb_rxd,       
    output           phyb_tx_en,     
    output     [1:0] phyb_txd        
);

    wire [1:0] a_to_b_data; 
    wire       a_to_b_valid; 

    wire [1:0] b_to_a_data; 
    wire       b_to_a_valid; 

    // --- A RX to B TX ---
    rmii_rx rx_from_a (
        .clk    (clk),
        .rst_n  (rst_n),
        .crs_dv (phya_rx_crs_dv),
        .rxd    (phya_rxd),
        .dout   (a_to_b_data),
        .valid  (a_to_b_valid)
    );

    rmii_tx tx_to_b (
        .clk      (clk),
        .rst_n    (rst_n),
        .valid_in (a_to_b_valid),
        .din      (a_to_b_data),
        .tx_en    (phyb_tx_en),
        .txd      (phyb_txd)
    );

    // --- B RX to A TX ---
    rmii_rx rx_from_b (
        .clk    (clk),
        .rst_n  (rst_n),
        .crs_dv (phyb_rx_crs_dv),
        .rxd    (phyb_rxd),
        .dout   (b_to_a_data), 
        .valid  (b_to_a_valid)
    ); 

    rmii_tx tx_to_a (
        .clk      (clk),
        .rst_n    (rst_n),
        .valid_in (b_to_a_valid),
        .din      (b_to_a_data),
        .tx_en    (phya_tx_en),
        .txd      (phya_txd)
    );

endmodule