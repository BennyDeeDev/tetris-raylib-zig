# tetris-raylib-zig

Tetris built with [Raylib](https://www.raylib.com/) and [Zig](https://ziglang.org/).

## Building

```sh
just build
just run
```

## Piece representation

Each tetromino is stored as a `[4][4]u1` grid where `1` marks an occupied cell and `0` marks empty space. All 4 rotation states are stored explicitly — no matrix math at runtime. This makes shapes and rotations readable directly in source:

```zig
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
        // ...
    },
    .color = ray.PURPLE,
};
```

## Memory tradeoffs vs sprite-based rendering

This game uses software pixel drawing via Raylib rather than hardware sprites. The tradeoff:

- **Disk/storage**: efficient — piece shapes are just a few bytes of grid data, no sprite assets needed. This also makes it a good fit for WASM builds where bundle size matters.
- **RAM at runtime**: less efficient — drawing fills a framebuffer in memory every frame. On constrained hardware like the SNES (128KB total RAM), a 256×224 framebuffer alone consumes ~56KB, nearly half of total RAM.
