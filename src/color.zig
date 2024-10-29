const std = @import("std");

pub const Color = struct {
    red: u8,
    green: u8,
    blue: u8,

    pub fn new(r: u8, g: u8, b: u8) Color {
        return .{ .red = r, .green = g, .blue = b };
    }

    pub fn toVector(self: Color) @Vector(3, u8) {
        return .{ self.red, self.green, self.blue };
    }

    // pub fn WriteColor(WriterType: type, color: Color) !void {
    //     std.debug.print("Writing color: {any}\n", .{color});
    //     try WriterType.print("{d} {d} {d}\n", .{ color.red, color.green, color.blue });
    // }

    pub fn WriteColor(self: Color, writer: anytype) !void {
        std.debug.print("Writing color: {any}\n", .{self});
        try writer.print("{d} {d} {d}\n", .{ self.red, self.green, self.blue });
    }
};
