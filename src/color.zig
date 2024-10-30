const std = @import("std");

pub const MAX_COLOR_VALUE: f64 = 255.999;

pub const Color = struct {
    red: u8,
    green: u8,
    blue: u8,

    pub fn InitFromNormalizedVector(normalizedVector: @Vector(3, f64)) Color {
        return .{
            .red = @intFromFloat(normalizedVector[0] * MAX_COLOR_VALUE),
            .green = @intFromFloat(normalizedVector[1] * MAX_COLOR_VALUE),
            .blue = @intFromFloat(normalizedVector[2] * MAX_COLOR_VALUE),
        };
    }

    pub fn ToNormalizedVector(self: Color) @Vector(3, f64) {
        return .{
            @as(f64, @floatFromInt(self.red)) / MAX_COLOR_VALUE,
            @as(f64, @floatFromInt(self.green)) / MAX_COLOR_VALUE,
            @as(f64, @floatFromInt(self.blue)) / MAX_COLOR_VALUE,
        };
    }

    pub fn ToVector(self: Color) @Vector(3, u8) {
        return .{ self.red, self.green, self.blue };
    }

    pub fn WriteColor(self: Color, writer: anytype) !void {
        std.debug.print("Writing color: {any}\n", .{self});
        try writer.print("{d} {d} {d}\n", .{ self.red, self.green, self.blue });
    }
};
