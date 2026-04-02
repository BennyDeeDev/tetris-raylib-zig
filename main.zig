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

const isGridEnabled = true;

fn shuffleBag(bag: *[7]Piece) void {
    var i: usize = bag.len - 1;
    while (i > 0) : (i -= 1) {
        const j = std.crypto.random.intRangeLessThan(usize, 0, i + 1);
        const tmp = bag[i];
        bag[i] = bag[j];
        bag[j] = tmp;
    }
}

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
    var tick_counter: usize = 0;
    var active_piece: ?ActivePiece = null;

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

        tick_counter += 1;
        if (tick_counter % 30 == 0) {
            tick_counter = 0;
            if (active_piece == null) {
                active_piece = ActivePiece{ .piece = .I, .rotation = 0, .x = cell * 4, .y = cell };
            } else {
                active_piece.?.y = active_piece.?.y + cell;
            }
        }

        if (active_piece) |ap| {
            drawPiece(ap.x, ap.y, ap.piece, ap.rotation);
        }

        if (isGridEnabled) {
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
    for (data.states[rotation], 0..) |row, rowIndex| {
        for (row, 0..) |rowItem, rowItemIndex| {
            if (rowItem == 1) {
                ray.DrawRectangle(
                    x + piece_gap + (cell * @as(c_int, @intCast(rowItemIndex))),
                    y + piece_gap + (cell * @as(c_int, @intCast(rowIndex))),
                    cell - piece_gap,
                    cell - piece_gap,
                    data.color,
                );
            }
        }
    }
}
