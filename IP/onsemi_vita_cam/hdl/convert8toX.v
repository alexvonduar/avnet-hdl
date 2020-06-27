module convert8to12
(
    input  wire        reset,   // Reset line
    input  wire        wclk,    // write clock
    input  wire        bitslip, // Bitslip control line
    input  wire        rclk,    // read clock
    input  wire        din,     // Input from LVDS receiver pin
    output wire [11:0] dout     // Output data
);

reg [11:0] sel;
reg [11:0] wrt;
reg [11:0] _curr;
reg [11:0] _last;
reg [23:0] _dout;

assign dout = _dout[23:12];

always @ (posedge wclk or posedge reset)
begin
    if (reset == 1'b1) begin
        wrt   <= 12'b000000000001;
        _curr <= 12'b0;
    end
    else begin
        case(wrt)
        12'b000000000001 : _curr[11] <= din;
        12'b000000000010 : _curr[10] <= din;
        12'b000000000100 : _curr[9]  <= din;
        12'b000000001000 : _curr[8]  <= din;
        12'b000000010000 : _curr[7]  <= din;
        12'b000000100000 : _curr[6]  <= din;
        12'b000001000000 : _curr[5]  <= din;
        12'b000010000000 : _curr[4]  <= din;
        12'b000100000000 : _curr[3]  <= din;
        12'b001000000000 : _curr[2]  <= din;
        12'b010000000000 : _curr[1]  <= din;
        12'b100000000000 : _curr[0]  <= din;
        default:           _curr[11] <= din;
        endcase
        wrt <= {wrt[10:0], wrt[11]};
    end
end

always @ (posedge rclk or posedge reset)
begin
    if (reset == 1'b1) begin
        sel   <= 12'b000000000001;
        _last <= 12'b0;
        _dout <= 24'b0;
    end
    else begin
        case(sel)
        12'b000000000001 : _dout[11:0] <= _last;
        12'b000000000010 : _dout[11:0] <= {_last[10:0], _curr[11]};
        12'b000000000100 : _dout[11:0] <= {_last[9:0],  _curr[11:10]};
        12'b000000001000 : _dout[11:0] <= {_last[8:0],  _curr[11:9]};
        12'b000000010000 : _dout[11:0] <= {_last[7:0],  _curr[11:8]};
        12'b000000100000 : _dout[11:0] <= {_last[6:0],  _curr[11:7]};
        12'b000001000000 : _dout[11:0] <= {_last[5:0],  _curr[11:6]};
        12'b000010000000 : _dout[11:0] <= {_last[4:0],  _curr[11:5]};
        12'b000100000000 : _dout[11:0] <= {_last[3:0],  _curr[11:4]};
        12'b001000000000 : _dout[11:0] <= {_last[2:0],  _curr[11:3]};
        12'b010000000000 : _dout[11:0] <= {_last[1:0],  _curr[11:2]};
        12'b100000000000 : _dout[11:0] <= {_last[0],    _curr[11:1]};
        default : _dout[11:0] <= _last;
        endcase
        if (bitslip == 1'b1)
        begin
            sel <= {sel[10:0], sel[11]};
        end
        _last <= _curr;
        _dout[23:12] <= _dout[11:0];
    end
end
endmodule

module convert8to10
(
    input  wire       reset,   // Reset line
    input  wire       wclk,    // write clock
    input  wire       rclk,    // read clock
    input  wire [3:0] din,     // Input from LVDS receiver pin
    output wire [9:0] dout     // Output data
);

reg [39:0] dbuf;
reg [3:0] wrt;
reg [3:0] rd;
reg [9:0] _dout;

assign dout = _dout;

always @ (posedge wclk or posedge reset)
begin
    if (reset == 1'b1) begin
        wrt  <= 4'd0;
        dbuf <= 40'd0;
    end
    else begin
        case(wrt)
        4'd0: begin
            dbuf[3:0]   <= din;
            wrt <= 4'd1;
        end
        4'd1: begin
            dbuf[7:4]  <= din;
            wrt <= 4'd2;
        end
        4'd2: begin
            dbuf[11:8] <= din;
            wrt <= 4'd3;
        end
        4'd3: begin
            dbuf[15:12] <= din;
            wrt <= 4'd4;
        end
        4'd4: begin
            dbuf[19:16] <= din;
            wrt <= 4'd5;
        end
        4'd5: begin
            dbuf[23:20] <= din;
            wrt <= 4'd6;
        end
        4'd6: begin
            dbuf[27:24] <= din;
            wrt <= 4'd7;
        end
        4'd7: begin
            dbuf[31:28] <= din;
            wrt <= 4'd8;
        end
        4'd8: begin
            dbuf[35:32] <= din;
            wrt <= 4'd9;
        end
        4'd9: begin
            dbuf[39:36] <= din;
            wrt <= 4'd0;
        end
        default: begin
            dbuf[3:0] <= din;
            wrt <= 4'd1;
        end
        endcase
    end
end

always @ (posedge rclk or posedge reset)
begin
    if (reset == 1'b1) begin
        rd   <= 4'b0100;
        _dout <= 10'b0;
    end
    else begin
        case(rd)
        4'b0001 : _dout[9:0] <= dbuf[9:0];
        4'b0010 : _dout[9:0] <= dbuf[19:10];
        4'b0100 : _dout[9:0] <= dbuf[29:20];
        4'b1000 : _dout[9:0] <= dbuf[39:30];
        default : _dout[9:0] <= dbuf[9:0];
        endcase
        rd <= {rd[2:0], rd[3]};
    end
end
endmodule

module convert8toX # (
    parameter DATAWIDTH = 10
)
(
    input  wire                 reset,   // Reset line
    input  wire                 wclk,     // write clock
    input  wire                 rclk,    // read clock
    input  wire [3:0]           din,     // Input from LVDS receiver pin
    output wire [DATAWIDTH-1:0] dout     // Output data
);

generate
case(DATAWIDTH)
//12: convert8to12 c8to12(.reset(reset), .wclk(wclk), .bitslip(bitslip), .rclk(rclk), .din(din), .dout(dout));
10: convert8to10 c8to10(.reset(reset), .wclk(wclk), .rclk(rclk), .din(din), .dout(dout));
endcase
endgenerate
endmodule
