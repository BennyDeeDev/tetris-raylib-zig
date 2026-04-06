const rl = @import("../../raylib.zig").rl;
const cfg = @import("../../config.zig");
const pc = @import("pieces.zig");

pub const Board = [cfg.rows][cfg.cols]?pc.Piece;

pub fn screenToBoard(x: c_int, y: c_int) struct { col: usize, row: usize } {
    return .{
        .col = @intCast(@divExact(x - cfg.board_x, cfg.cell)),
        .row = @intCast(@divExact(y - cfg.board_y, cfg.cell)),
    };
}

pub fn pieceToBoard(ap: anytype) [4][2]usize {
    const origin = screenToBoard(ap.x, ap.y);
    const data = pc.getPieceData(ap.piece);
    var cells: [4][2]usize = undefined;
    var i: usize = 0;
    for (data.states[ap.rotation], 0..) |shape_row, ri| {
        for (shape_row, 0..) |cell_val, ci| {
            if (cell_val == 1) {
                cells[i] = .{ origin.row + ri, origin.col + ci };
                i += 1;
            }
        }
    }
    return cells;
}

pub fn canMoveDown(board: Board, ap: anytype) bool {
    for (pieceToBoard(ap)) |c| {
        const next_row = c[0] + 1;
        if (next_row >= cfg.rows) return false;
        if (board[next_row][c[1]] != null) return false;
    }
    return true;
}

pub fn drawBoard(board: Board) void {
    rl.DrawRectangleLinesEx(
        .{
            .x = cfg.padding,
            .y = cfg.padding,
            .width = cfg.game_width + cfg.line_width * 2 + cfg.piece_gap,
            .height = cfg.game_height + cfg.line_width * 2 + cfg.piece_gap,
        },
        cfg.line_width,
        rl.LIGHTGRAY,
    );

    for (board, 0..) |board_row, ri| {
        for (board_row, 0..) |board_cell, ci| {
            if (board_cell) |piece| {
                const data = pc.getPieceData(piece);
                rl.DrawRectangle(
                    cfg.board_x + @as(c_int, @intCast(ci)) * cfg.cell + cfg.piece_gap,
                    cfg.board_y + @as(c_int, @intCast(ri)) * cfg.cell + cfg.piece_gap,
                    cfg.cell - cfg.piece_gap,
                    cfg.cell - cfg.piece_gap,
                    data.color,
                );
            }
        }
    }

    if (cfg.is_grid_enabled) {
        for (1..cfg.rows) |i| {
            const y: f32 = @floatFromInt(cfg.board_y + cfg.cell * @as(c_int, @intCast(i)));
            rl.DrawLineEx(
                .{ .x = @floatFromInt(cfg.board_x), .y = y },
                .{ .x = @floatFromInt(cfg.board_x + cfg.game_width), .y = y },
                cfg.line_width,
                rl.DARKGRAY,
            );
        }
        for (1..cfg.cols) |i| {
            const x: f32 = @floatFromInt(cfg.board_x + cfg.cell * @as(c_int, @intCast(i)));
            rl.DrawLineEx(
                .{ .x = x, .y = @floatFromInt(cfg.board_y) },
                .{ .x = x, .y = @floatFromInt(cfg.board_y + cfg.game_height) },
                cfg.line_width,
                rl.DARKGRAY,
            );
        }
    }
}
