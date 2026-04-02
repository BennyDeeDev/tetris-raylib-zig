const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const cell = 32;
const cols = 10;
const rows = 20;

const padding = cell;
const sidebar_width = cell * 3;

const game_width = cols * cell;
const game_height = rows * cell;

const line_width = 1;

const board_x = padding + line_width;
const board_y = padding + line_width;

const screen_width = padding + game_width + padding + sidebar_width;
const screen_height = padding + game_height + padding;

const piece_gap = 1;

const is_grid_enabled = true;

fn shuffleBag() [7]Piece {
    var bag = [7]Piece{ .I, .O, .T, .S, .Z, .J, .L };
    var i: usize = bag.len - 1;
    while (i > 0) : (i -= 1) {
        const j = std.crypto.random.intRangeLessThan(usize, 0, i + 1);
        const tmp = bag[i];
        bag[i] = bag[j];
        bag[j] = tmp;
    }
    return bag;
}

const GameState = struct {
    bag: [7]Piece,
    bag_index: usize,
    active_piece: ?ActivePiece,
    tick_counter: usize,
};

const ActivePiece = struct {
    piece: Piece,
    rotation: u2,
    x: c_int,
    y: c_int,
};

pub fn main() void {
    ray.SetConfigFlags(ray.FLAG_WINDOW_HIGHDPI);
    ray.InitWindow(screen_width, screen_height, "Tetris Raylib Zig");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    var gs = GameState{
        .bag = shuffleBag(),
        .bag_index = 0,
        .active_piece = null,
        .tick_counter = 0,
    };

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        ray.DrawRectangleLinesEx(
            .{
                .x = padding,
                .y = padding,
                .width = game_width + line_width * 2 + piece_gap,
                .height = game_height + line_width * 2 + piece_gap,
            },
            line_width,
            ray.LIGHTGRAY,
        );

        gs.tick_counter += 1;
        if (gs.tick_counter % 30 == 0) {
            gs.tick_counter = 0;
            if (gs.active_piece == null) {
                if (gs.bag_index >= 7) {
                    gs.bag = shuffleBag();
                    gs.bag_index = 0;
                }
                const next_piece = gs.bag[gs.bag_index];
                gs.bag_index += 1;
                gs.active_piece = ActivePiece{ .piece = next_piece, .rotation = 0, .x = cell * 4, .y = cell };
            } else if (gs.active_piece) |*ap| {
                ap.y += cell;
            }
        }

        if (gs.active_piece) |ap| {
            drawPiece(ap.x, ap.y, ap.piece, ap.rotation);
        }

        if (is_grid_enabled) {
            for (1..rows) |i| {
                const y: f32 = @floatFromInt(board_y + cell * @as(c_int, @intCast(i)));
                ray.DrawLineEx(.{
                    .x = @floatFromInt(board_x),
                    .y = y,
                }, .{
                    .x = @floatFromInt(board_x + game_width),
                    .y = y,
                }, line_width, ray.DARKGRAY);
            }
            for (1..cols) |i| {
                const x: f32 = @floatFromInt(board_x + cell * @as(c_int, @intCast(i)));
                ray.DrawLineEx(.{
                    .x = x,
                    .y = @floatFromInt(board_y),
                }, .{
                    .x = x,
                    .y = @floatFromInt(board_y + game_height),
                }, line_width, ray.DARKGRAY);
            }
        }
    }
}

const Piece = enum { I, O, T, S, Z, J, L };
const PieceShape = [4][4]u1;
const PieceData = struct {
    states: [4]PieceShape,
    color: ray.Color,
};

const pieces = struct {
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
        .color = ray.SKYBLUE,
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
        .color = ray.YELLOW,
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
        .color = ray.PURPLE,
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
        .color = ray.GREEN,
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
        .color = ray.RED,
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
        .color = ray.BLUE,
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
        .color = ray.ORANGE,
    };
};

fn getPieceData(piece: Piece) PieceData {
    return switch (piece) {
        .I => pieces.I,
        .O => pieces.O,
        .T => pieces.T,
        .S => pieces.S,
        .Z => pieces.Z,
        .J => pieces.J,
        .L => pieces.L,
    };
}

fn drawPiece(x: c_int, y: c_int, piece: Piece, rotation: u2) void {
    const data = getPieceData(piece);
    for (data.states[rotation], 0..) |row, row_index| {
        for (row, 0..) |row_item, row_item_index| {
            if (row_item == 1) {
                ray.DrawRectangle(
                    x + piece_gap + (cell * @as(c_int, @intCast(row_item_index))),
                    y + piece_gap + (cell * @as(c_int, @intCast(row_index))),
                    cell - piece_gap,
                    cell - piece_gap,
                    data.color,
                );
            }
        }
    }
}
