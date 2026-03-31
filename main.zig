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

const board_x = padding;
const board_y = padding;

const screen_width = padding + game_width + padding + sidebar_width;
const screen_height = padding + game_height + padding;

const line_width = 1;

const Direction = enum { vertical, horizontal };

pub fn main() void {
    ray.SetConfigFlags(ray.FLAG_WINDOW_HIGHDPI);
    ray.InitWindow(screen_width, screen_height, "Tetris Raylib Zig");
    defer ray.CloseWindow();

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        for (1..rows) |i| {
            const y: c_int = board_y + cell * @as(c_int, @intCast(i));
            drawLine(board_x, y, .horizontal, ray.DARKGRAY);
        }
        for (1..cols) |i| {
            const x: c_int = board_x + cell * @as(c_int, @intCast(i));
            drawLine(x, board_y, .vertical, ray.DARKGRAY);
        }

        drawLine(board_x, board_y, .horizontal, ray.LIGHTGRAY);
        drawLine(board_x, board_y, .vertical, ray.LIGHTGRAY);
        drawLine(board_x, board_y + game_height, .horizontal, ray.LIGHTGRAY);
        drawLine(board_x + game_width, board_y, .vertical, ray.LIGHTGRAY);
    }
}

fn drawLine(x: c_int, y: c_int, dir: Direction, color: ray.Color) void {
    const i_max: usize = if (dir == .horizontal) cols else rows;

    for (0..i_max) |i| {
        if (dir == .horizontal) {
            const _x: c_int = x + cell * @as(c_int, @intCast(i));
            ray.DrawRectangle(_x, y, cell, line_width, color);
        } else {
            const _y: c_int = y + cell * @as(c_int, @intCast(i));
            ray.DrawRectangle(x, _y, line_width, cell, color);
        }
    }
}
