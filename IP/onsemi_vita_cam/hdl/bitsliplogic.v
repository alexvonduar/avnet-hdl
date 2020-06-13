module muxer12b
(
    input  wire        reset,   // Reset line
    input  wire        clk,     // Global clock
    input  wire        bitslip, // Bitslip control line
    input  wire [11:0] din,     // Input from LVDS receiver pin
    output wire [11:0] dout     // Output data
);

reg [11:0] sel;
reg [11:0] last;
reg [11:0] _dout;

assign dout = _dout;

always @ (posedge clk)
begin
    if (reset == 1'b1) begin
        sel   <= 12'b0000000001;
        last  <= 12'b0;
        _dout <= 12'b0;
    end
    else begin
        case(sel)
        12'b000000000001 : _dout <= last;
        12'b000000000010 : _dout <= {last[10:0], din[11]};
        12'b000000000100 : _dout <= {last[9:0],  din[11:10]};
        12'b000000001000 : _dout <= {last[8:0],  din[11:9]};
        12'b000000010000 : _dout <= {last[7:0],  din[11:8]};
        12'b000000100000 : _dout <= {last[6:0],  din[11:7]};
        12'b000001000000 : _dout <= {last[5:0],  din[11:6]};
        12'b000010000000 : _dout <= {last[4:0],  din[11:5]};
        12'b000100000000 : _dout <= {last[3:0],  din[11:4]};
        12'b001000000000 : _dout <= {last[2:0],  din[11:3]};
        12'b010000000000 : _dout <= {last[1:0],  din[11:2]};
        12'b100000000000 : _dout <= {last[0],    din[11:1]};
        default : _dout <= last;
        endcase
        if (bitslip == 1'b1)
        begin
            sel  <= {sel[10:0], sel[11]};
        end
        last <= din;
    end
end
endmodule

module muxer10b
(
    input  wire       reset,   // Reset line
    input  wire       clk,     // Global clock
    input  wire       bitslip, // Bitslip control line
    input  wire [9:0] din,     // Input from LVDS receiver pin
    output wire [9:0] dout     // Output data
);

reg [9:0] sel;
reg [9:0] last;
reg [9:0] _dout;

assign dout = _dout;

always @ (posedge clk)
begin
    if (reset == 1'b1) begin
        sel   <= 10'b0000000001;
        last  <= 10'b0;
        _dout <= 10'b0;
    end
    else begin
        case(sel)
        10'b0000000001 : _dout <= last;
        10'b0000000010 : _dout <= {last[8:0], din[9]};
        10'b0000000100 : _dout <= {last[7:0], din[9:8]};
        10'b0000001000 : _dout <= {last[6:0], din[9:7]};
        10'b0000010000 : _dout <= {last[5:0], din[9:6]};
        10'b0000100000 : _dout <= {last[4:0], din[9:5]};
        10'b0001000000 : _dout <= {last[3:0], din[9:4]};
        10'b0010000000 : _dout <= {last[2:0], din[9:3]};
        10'b0100000000 : _dout <= {last[1:0], din[9:2]};
        10'b1000000000 : _dout <= {last[0],   din[9:1]};
        default : _dout <= last;
        endcase
        if (bitslip == 1'b1)
        begin
            sel  <= {sel[8:0], sel[9]};
        end
        last <= din;
    end
end
endmodule

module muxer8b
(
    input  wire       reset,   // Reset line
    input  wire       clk,     // Global clock
    input  wire       bitslip, // Bitslip control line
    input  wire [7:0] din,     // Input from LVDS receiver pin
    output wire [7:0] dout     // Output data
);

reg [7:0] sel;
reg [7:0] last;
reg [7:0] _dout;

assign dout = _dout;

always @ (posedge clk)
begin
    if (reset == 1'b1) begin
        sel   <= 8'b00000001;
        last  <= 8'b0;
        _dout <= 8'b0;
    end
    else begin
        case(sel)
        8'b00000001 : _dout <= last;
        8'b00000010 : _dout <= {last[6:0], din[7]};
        8'b00000100 : _dout <= {last[5:0], din[7:6]};
        8'b00001000 : _dout <= {last[4:0], din[7:5]};
        8'b00010000 : _dout <= {last[3:0], din[7:4]};
        8'b00100000 : _dout <= {last[2:0], din[7:3]};
        8'b01000000 : _dout <= {last[1:0], din[7:2]};
        8'b10000000 : _dout <= {last[0],   din[7:1]};
        default : _dout = last;
        endcase
        if (bitslip == 1'b1)
        begin
            sel <= {sel[6:0], sel[7]};
        end
        last <= din;
    end
end
endmodule

module muxer4b
(
    input  wire       reset,   // Reset line
    input  wire       clk,     // Global clock
    input  wire       bitslip, // Bitslip control line
    input  wire [3:0] din,     // Input from LVDS receiver pin
    output wire [3:0] dout     // Output data
);

reg [3:0] sel;
reg [3:0] last;
reg [3:0] _dout;

assign dout = _dout;

always @ (posedge clk)
begin
    if (reset == 1'b1) begin
        sel   <= 4'b0001;
        last  <= 4'b0;
        _dout <= 4'b0;
    end
    else begin
        case(sel)
        4'b0001 : _dout <= last;
        4'b0010 : _dout <= {last[2:0], din[3]};
        4'b0100 : _dout <= {last[1:0], din[3:2]};
        4'b1000 : _dout <= {last[0],   din[3:1]};
        default : _dout = last;
        endcase
        if (bitslip == 1'b1)
        begin
            sel <= {sel[2:0], sel[3]};
        end
        last <= din;
    end
end
endmodule


module bitsliplogic # (
    parameter DATAWIDTH = 10
)
(
    input  wire                 reset,   // Reset line
    input  wire                 clk,     // Global clock
    input  wire                 bitslip, // Bitslip control line
    input  wire [DATAWIDTH-1:0] din,     // Input from LVDS receiver pin
    output wire [DATAWIDTH-1:0] dout     // Output data
);

generate
case(DATAWIDTH)
12: muxer12b m12(.reset(reset), .clk(clk), .bitslip(bitslip), .din(din), .dout(dout));
10: muxer10b m10(.reset(reset), .clk(clk), .bitslip(bitslip), .din(din), .dout(dout));
8: muxer8b m8(.reset(reset), .clk(clk), .bitslip(bitslip), .din(din), .dout(dout));
4: muxer4b m4(.reset(reset), .clk(clk), .bitslip(bitslip), .din(din), .dout(dout));
default: assign dout = din;
endcase
endgenerate
endmodule
