const rl = @import("../../raylib.zig").rl;
const cfg = @import("../../config.zig");

pub const Piece = enum { I, O, T, S, Z, J, L };
pub const PieceShape = [4][4]u1;
pub const PieceData = struct {
    states: [4]PieceShape,
    color: rl.Color,
};

const table = struct {
    const I = PieceData{
        .states = .{
            .{ // 0°
                .{ 1, 1, 1, 1 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 90°
                .{ 1, 0, 0, 0 },
                .{ 1, 0, 0, 0 },
                .{ 1, 0, 0, 0 },
                .{ 1, 0, 0, 0 },
            },
            .{ // 180°
                .{ 1, 1, 1, 1 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 270°
                .{ 1, 0, 0, 0 },
                .{ 1, 0, 0, 0 },
                .{ 1, 0, 0, 0 },
                .{ 1, 0, 0, 0 },
            },
        },
        .color = rl.SKYBLUE,
    };
    const O = PieceData{
        .states = .{
            .{
                .{ 1, 1, 0, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{
                .{ 1, 1, 0, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{
                .{ 1, 1, 0, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{
                .{ 1, 1, 0, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
        },
        .color = rl.YELLOW,
    };
    const T = PieceData{
        .states = .{
            .{ // 0°
                .{ 0, 1, 0, 0 },
                .{ 1, 1, 1, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 90°
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 180°
                .{ 0, 0, 0, 0 },
                .{ 1, 1, 1, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 270°
                .{ 0, 1, 0, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
        },
        .color = rl.PURPLE,
    };
    const S = PieceData{
        .states = .{
            .{ // 0°
                .{ 0, 1, 1, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 90°
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 0, 1, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 180°
                .{ 0, 1, 1, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 270°
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 0, 1, 0 },
                .{ 0, 0, 0, 0 },
            },
        },
        .color = rl.GREEN,
    };
    const Z = PieceData{
        .states = .{
            .{ // 0°
                .{ 1, 1, 0, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 90°
                .{ 0, 0, 1, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 180°
                .{ 1, 1, 0, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 270°
                .{ 0, 0, 1, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
        },
        .color = rl.RED,
    };
    const J = PieceData{
        .states = .{
            .{ // 0°
                .{ 1, 0, 0, 0 },
                .{ 1, 1, 1, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 90°
                .{ 0, 1, 1, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 180°
                .{ 0, 0, 0, 0 },
                .{ 1, 1, 1, 0 },
                .{ 0, 0, 1, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 270°
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 0, 0 },
                .{ 1, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
        },
        .color = rl.BLUE,
    };
    const L = PieceData{
        .states = .{
            .{ // 0°
                .{ 0, 0, 1, 0 },
                .{ 1, 1, 1, 0 },
                .{ 0, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 90°
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 1, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 180°
                .{ 0, 0, 0, 0 },
                .{ 1, 1, 1, 0 },
                .{ 1, 0, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
            .{ // 270°
                .{ 1, 1, 0, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 1, 0, 0 },
                .{ 0, 0, 0, 0 },
            },
        },
        .color = rl.ORANGE,
    };
};

pub fn getPieceData(piece: Piece) PieceData {
    return switch (piece) {
        .I => table.I,
        .O => table.O,
        .T => table.T,
        .S => table.S,
        .Z => table.Z,
        .J => table.J,
        .L => table.L,
    };
}

pub fn drawPiece(x: c_int, y: c_int, piece: Piece, rotation: u2) void {
    const data = getPieceData(piece);
    for (data.states[rotation], 0..) |row, row_index| {
        for (row, 0..) |row_item, row_item_index| {
            if (row_item == 1) {
                rl.DrawRectangle(
                    x + cfg.piece_gap + (cfg.cell * @as(c_int, @intCast(row_item_index))),
                    y + cfg.piece_gap + (cfg.cell * @as(c_int, @intCast(row_index))),
                    cfg.cell - cfg.piece_gap,
                    cfg.cell - cfg.piece_gap,
                    data.color,
                );
            }
        }
    }
}
