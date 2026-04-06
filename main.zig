const rl = @import("raylib.zig").rl;
const cfg = @import("config.zig");
const GameScene = @import("scenes/game/game.zig").GameScene;

const Scene = union(enum) {
    game: GameScene,

    fn init() Scene {
        return .{ .game = GameScene.init() };
    }

    fn update(self: *Scene) void {
        switch (self.*) {
            .game => |*s| s.update(),
        }
    }

    fn draw(self: *const Scene) void {
        switch (self.*) {
            .game => |s| s.draw(),
        }
    }
};

pub fn main() void {
    rl.SetConfigFlags(rl.FLAG_WINDOW_HIGHDPI);
    rl.InitWindow(cfg.screen_width, cfg.screen_height, "Tetris Raylib Zig");
    defer rl.CloseWindow();

    rl.SetTargetFPS(60);

    var scene = Scene.init();

    while (!rl.WindowShouldClose()) {
        scene.update();
        rl.BeginDrawing();
        defer rl.EndDrawing();
        rl.ClearBackground(rl.BLACK);
        scene.draw();
    }
}
