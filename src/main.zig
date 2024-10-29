const std = @import("std");
const Color = @import("color.zig").Color;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    //std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // --- IMAGE ---
    const imageWidth: u32 = 256;
    const imageHeight: u32 = 256;

    // --- RENDER ---
    try stdout.print("P3\n{d} {d}\n255\n", .{ imageWidth, imageHeight });

    for (0..imageHeight) |i| {
        std.debug.print("\nScanlines remaining: {d}", .{imageHeight - i});
        for (0..imageWidth) |j| {
            const y: u8 = @intCast(i);
            const x: u8 = @intCast(j);

            //const pixelColor = Color.new(@as(u8, imageWidth - 1) - x, @as(u8, imageHeight - 1) - y, 0);
            const pixelColor = Color.new(x, y, 0);
            try pixelColor.WriteColor(stdout);
        }
    }
    std.debug.print("\nDone!\n", .{});

    try bw.flush(); // Don't forget to flush!
}
