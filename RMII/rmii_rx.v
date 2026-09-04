module rmii_rx (
    input            clk,      
    input            rst_n,    
    input            crs_dv,   
    input      [1:0] rxd,      
    output reg [1:0] dout,     
    output reg       valid     
);

    reg [1:0] crs_dv_shift;    

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            dout         <= 2'd0;
            valid        <= 1'b0;
            crs_dv_shift <= 2'b00;
        end else begin
            crs_dv_shift <= {crs_dv_shift[0], crs_dv};
            
            if (valid == 1'b1) begin
                
                if (crs_dv_shift == 2'b00) begin
                    valid <= 1'b0; 
                    dout  <= 2'b00;
                end 
                
                else begin
                    dout  <= rxd;
                end
                
            end 
            else begin
                if (crs_dv_shift[0] == 1'b1) begin
                    valid <= 1'b1;
                    dout  <= rxd;
                end
            end
        end
    end
endmodule