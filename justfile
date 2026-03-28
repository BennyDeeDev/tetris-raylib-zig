default: run

build:
    zig build

run:
    zig build run

clean:
    zig build uninstall
    rm -rf zig-out .zig-cache
