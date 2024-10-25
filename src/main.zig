const std = @import("std");

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
    const maxColorValue: f32 = 255.999;

    // --- RENDER ---
    try stdout.print("P3\n{d} {d}\n255\n", .{ imageWidth, imageHeight });

    for (0..imageHeight) |i| {
        for (0..imageWidth) |j| {
            const y: f32 = @floatFromInt(i);
            const x: f32 = @floatFromInt(j);

            const r: f32 = x / @as(f32, imageWidth - 1);
            const g: f32 = y / @as(f32, imageHeight - 1);
            const b: f32 = 0.0;

            const ir: u32 = @intFromFloat(r * maxColorValue);
            const ig: u32 = @intFromFloat(g * maxColorValue);
            const ib: u32 = @intFromFloat(b * maxColorValue);

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }

    try bw.flush(); // Don't forget to flush!
}
