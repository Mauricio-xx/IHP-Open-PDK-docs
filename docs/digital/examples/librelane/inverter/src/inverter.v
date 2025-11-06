// inverter.v
// Minimal combinational example used in LibreLane documentation.

module inverter (
    input  wire a,
    output wire y
);
    assign y = ~a;
endmodule
