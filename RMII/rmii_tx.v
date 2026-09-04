module rmii_tx (
    input            clk,      
    input            rst_n,    
    input            valid_in, // RX has new data 
    input      [1:0] din,      // data in 2 bit
    output reg       tx_en,    
    output reg [1:0] txd       // data out 2 bit
);

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            tx_en <= 1'b0;
            txd   <= 2'd0;
        end else begin
            
            // transmit new data
            if (valid_in == 1'b1) begin
                tx_en <= 1'b1; 
                txd   <= din;  
            end 
            
            // end of packet / waiting
            else begin
                tx_en <= 1'b0;
                txd   <= 2'b00;
            end
            
        end
    end
endmodule