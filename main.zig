const std = @import("std");
const ray = @cImport({
    @cInclude("raylib.h");
});

const cell = 32;
const cols = 10;
const rows = 20;

const padding = cell;
const sidebar_width = cell * 1;

const game_width = cols * cell + cell;
const game_height = rows * cell + cell;

const screen_width = padding + game_width;
const screen_height = padding + game_height;

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

        for (2..rows + 1) |i| {
            const y = cell * @as(c_int, @intCast(i));
            drawLine(0, y, Direction.horizontal, ray.DARKGRAY);
        }
        for (2..cols + 1) |i| {
            const x = cell * @as(c_int, @intCast(i));
            drawLine(x, 0, Direction.vertical, ray.DARKGRAY);
        }

        drawLine(0, 32, Direction.horizontal, ray.LIGHTGRAY);
        drawLine(32, 0, Direction.vertical, ray.LIGHTGRAY);
        drawLine(0, game_height, Direction.horizontal, ray.LIGHTGRAY);
        drawLine(game_width, 0, Direction.vertical, ray.LIGHTGRAY);
    }
}

fn drawLine(x: c_int, y: c_int, dir: Direction, color: ray.Color) void {
    var _x = x;
    var _y = y;

    var i_max: u8 = 0;

    if (dir == .horizontal) {
        i_max = cols;
    } else if (dir == .vertical) {
        i_max = rows;
    }

    for (1..i_max + 1) |i| {
        if (dir == .horizontal) {
            _x = cell * @as(c_int, @intCast(i));
            ray.DrawRectangle(_x, _y, cell, line_width, color);
        } else if (dir == .vertical) {
            _y = cell * @as(c_int, @intCast(i));
            ray.DrawRectangle(_x, _y, line_width, cell, color);
        }

        std.debug.print("x = {}\n", .{_x});
        std.debug.print("y = {}\n", .{_y});
    }
}
