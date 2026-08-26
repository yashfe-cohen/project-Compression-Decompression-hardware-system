module rmii_tx (
    input            clk,      
    input            rst_n,    
    input            valid_in, // RX has new byte
    input      [7:0] din,      // data in 8 bit
    input            end_pkt,  // end packet from RX crs_dv
    output reg       tx_en,    
    output reg [1:0] txd       // data out
);

    // FSM States
    localparam S_IDLE = 1'b0;  // waiting for valid_in
    localparam S_TX   = 1'b1;  // transmit data

    reg        st;              
    reg [7:0] shreg;           // register to hold bits

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            // Reset all 
            st    <= S_IDLE;
            tx_en <= 1'b0;
            txd   <= 2'd0;
            shreg <= 8'd0;
        end else begin

            case (st)
                S_IDLE: begin
                    tx_en <= 1'b0;
                    txd   <= 2'd0;
                    
                    // RX pushed FIRST byte
                    if (valid_in == 1'b1) begin
                        st    <= S_TX;       // TX
                        tx_en <= 1'b1;       
                        shreg <= din;        // load first byte
                        txd   <= din[1:0];   // output first 2 bits
                    end
                end

                S_TX: begin
                    // if packet ended
                    if (end_pkt == 1'b1) begin
                        st    <= S_IDLE; // end of packet
                        tx_en <= 1'b0; 
                        txd   <= 2'd0;
                    end 
                    // RX NEW byte
                    else if (valid_in == 1'b1) begin
                        shreg <= din;
                        txd   <= din[1:0]; 
                    end 
                    // shift 2 bits
                    else begin
                        txd   <= shreg[3:2];
                        shreg <= {2'b00, shreg[7:2]};
                    end
                end

                default: st <= S_IDLE;
            endcase
        end
    end

endmodule