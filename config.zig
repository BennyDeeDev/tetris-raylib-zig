pub const cell = 32;
pub const cols = 10;
pub const rows = 20;

pub const padding = cell;
pub const line_width = 1;
pub const piece_gap = 1;

pub const board_x = padding + line_width;
pub const board_y = padding + line_width;
pub const game_width = cols * cell;
pub const game_height = rows * cell;

pub const sidebar_width = cell * 3;
pub const screen_width = padding + game_width + padding + sidebar_width;
pub const screen_height = padding + game_height + padding;

pub const is_grid_enabled = true;
