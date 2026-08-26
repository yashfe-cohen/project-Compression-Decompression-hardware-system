module Compression (
    input        clk,          
    input        rst_n,        
    
    // RJ45 Port A
    input        phya_rx_crs_dv, // crs_dv
    input  [1:0] phya_rxd,       // receive data 2 bit
    output       phya_tx_en,     // tx_en
    output [1:0] phya_txd,       // transmit data 2 bit
    
    // RJ45 Port B
    input        phyb_rx_crs_dv, // crs_dv
    input  [1:0] phyb_rxd,       // receive data 2 bit
    output       phyb_tx_en,     // tx_en
    output [1:0] phyb_txd        // transmit data 2 bit
);

    // Wires A to  B 
    wire [7:0] a_to_b_data; //dout to din
    wire       a_to_b_valid; //if rx done valid send to tx as valid_in

    //  Wires  B to  A
    wire [7:0] b_to_a_data; //dout to din
    wire       b_to_a_valid; // if rx done valid send to tx as valid_in

    //A RX to B TX
    
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
                                            .end_pkt  (~phya_rx_crs_dv),
                                            .tx_en    (phyb_tx_en),
                                            .txd      (phyb_txd)
    );

    //B rX to  A tX
    
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
                                            .end_pkt  (~phyb_rx_crs_dv),
                                            .tx_en    (phya_tx_en),
                                            .txd      (phya_txd)
    );

endmodule