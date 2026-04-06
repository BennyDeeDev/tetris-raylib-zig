const std = @import("std");
const cfg = @import("../../config.zig");
const bd = @import("board.zig");
const pc = @import("pieces.zig");

const ActivePiece = struct {
    piece: pc.Piece,
    rotation: u2,
    x: c_int,
    y: c_int,
};

pub const GameScene = struct {
    board: bd.Board,
    bag: [7]pc.Piece,
    bag_index: usize,
    active_piece: ?ActivePiece,
    tick_counter: usize,

    pub fn init() GameScene {
        return .{
            .board = std.mem.zeroes(bd.Board),
            .bag = shuffleBag(),
            .bag_index = 0,
            .active_piece = null,
            .tick_counter = 0,
        };
    }

    pub fn update(self: *GameScene) void {
        self.tick_counter += 1;
        if (self.tick_counter % 30 == 0) {
            self.tick_counter = 0;
            if (self.active_piece == null) {
                if (self.bag_index >= 7) {
                    self.bag = shuffleBag();
                    self.bag_index = 0;
                }
                const next_piece = self.bag[self.bag_index];
                self.bag_index += 1;
                self.active_piece = ActivePiece{
                    .piece = next_piece,
                    .rotation = 0,
                    .x = cfg.cell * 4 + cfg.piece_gap,
                    .y = cfg.cell + cfg.piece_gap,
                };
            } else if (self.active_piece) |*ap| {
                if (bd.canMoveDown(self.board, ap.*)) {
                    ap.y += cfg.cell;
                } else {
                    for (bd.pieceToBoard(ap.*)) |c| {
                        self.board[c[0]][c[1]] = ap.piece;
                    }
                    self.active_piece = null;
                }
            }
        }
    }

    pub fn draw(self: *const GameScene) void {
        bd.drawBoard(self.board);
        if (self.active_piece) |ap| pc.drawPiece(ap.x, ap.y, ap.piece, ap.rotation);
    }
};

fn shuffleBag() [7]pc.Piece {
    var bag = [7]pc.Piece{ .I, .O, .T, .S, .Z, .J, .L };
    var i: usize = bag.len - 1;
    while (i > 0) : (i -= 1) {
        const j = std.crypto.random.intRangeLessThan(usize, 0, i + 1);
        const tmp = bag[i];
        bag[i] = bag[j];
        bag[j] = tmp;
    }
    return bag;
}
