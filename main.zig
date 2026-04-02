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

        drawPiece(board_x + 64, board_y + 64, Piece.O);

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
const PieceShape = [4][1]u1;

const pieces = struct {
    const O = [2]PieceShape{
        .{ .{0}, .{1}, .{1}, .{0} },
        .{ .{0}, .{1}, .{1}, .{0} },
    };
};

fn drawPiece(x: c_int, y: c_int, piece: Piece) void {
    switch (piece) {
        .O => {
            for (pieces.O, 0..) |row, rowIndex| {
                for (row, 0..) |rowItem, rowItemIndex| {
                    if (rowItem[0] == 1) {
                        ray.DrawRectangle(
                            x + piece_gap + (cell * @as(c_int, @intCast(rowItemIndex))),
                            y + piece_gap + (cell * @as(c_int, @intCast(rowIndex))),
                            cell - piece_gap,
                            cell - piece_gap,
                            ray.YELLOW,
                        );
                    }
                }
            }
        },
        else => {},
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
