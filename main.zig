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

const isGridEnabled = false;

pub fn main() void {
    ray.SetConfigFlags(ray.FLAG_WINDOW_HIGHDPI);
    ray.InitWindow(screen_width, screen_height, "Tetris Raylib Zig");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        if (isGridEnabled) {
            for (1..rows) |i| {
                const y: c_int = board_y + cell * @as(c_int, @intCast(i));
                drawLine(board_x, y, .Horizontal, ray.DARKGRAY);
            }
            for (0..cols) |i| {
                const x: c_int = board_x + cell * @as(c_int, @intCast(i));
                drawLine(x, board_y, .Vertical, ray.DARKGRAY);
            }
        }

        drawPiece(board_x, board_y + cell * 0, Piece.I, 0);
        drawPiece(board_x + cell * 5, board_y + cell * 0, Piece.I, 1);
        drawPiece(board_x, board_y + cell * 2, Piece.T, 0);
        drawPiece(board_x + cell * 5, board_y + cell * 2, Piece.T, 1);
        drawPiece(board_x, board_y + cell * 5, Piece.T, 2);
        drawPiece(board_x + cell * 5, board_y + cell * 5, Piece.T, 3);
        drawPiece(board_x, board_y + cell * 8, Piece.L, 0);
        drawPiece(board_x + cell * 5, board_y + cell * 8, Piece.L, 1);
        drawPiece(board_x, board_y + cell * 11, Piece.L, 2);
        drawPiece(board_x + cell * 5, board_y + cell * 11, Piece.L, 3);

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
    const O = PieceData{ .states = .{
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
    }, .color = ray.YELLOW };
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

const Direction = enum { Vertical, Horizontal };

fn drawLine(x: c_int, y: c_int, dir: Direction, color: ray.Color) void {
    const i_max: usize = if (dir == .Horizontal) cols else rows;

    for (0..i_max) |i| {
        if (dir == .Horizontal) {
            const _x: c_int = x + cell * @as(c_int, @intCast(i));
            ray.DrawRectangle(_x, y, cell, line_width, color);
        } else {
            const _y: c_int = y + cell * @as(c_int, @intCast(i));
            ray.DrawRectangle(x, _y, line_width, cell, color);
        }
    }
}
