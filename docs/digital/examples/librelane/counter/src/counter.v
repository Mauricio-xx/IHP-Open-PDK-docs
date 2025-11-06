// counter.v
// 8-bit up/down counter with enable and synchronous reset.

module counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire       up_down,
    output reg  [7:0] value
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            value <= 8'd0;
        end else if (enable) begin
            value <= up_down ? value + 8'd1 : value - 8'd1;
        end
    end
endmodule
