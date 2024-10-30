//! We are using a right-handed coordinate system:
//! The y-axis go up, the x-axis to the right, and the negative z-axis pointing in the viewing direction.

const std = @import("std");
const Position = @import("position.zig").Position;
const Color = @import("color.zig").Color;
const Ray = @import("ray.zig").Ray;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // --- IMAGE ---
    const aspectRatio: f64 = 16.0 / 9.0;
    const imageWidth: u32 = 400;

    // NOTE: Ensure the image height is at least 1
    const tempImageHeightCalculation: u32 = @intFromFloat(@as(f64, imageWidth) / aspectRatio);
    const imageHeight: u32 = if (tempImageHeightCalculation == 0) 1 else tempImageHeightCalculation;

    // --- CAMERA / VIEWPORT ---
    const focalLength: f64 = 1.0;
    const viewportHeight: f64 = 2.0;
    const viewportWidth: f64 = 2.0 * @as(f64, imageWidth) / @as(f64, imageHeight); // This is real valued
    const cameraCenter: Position = .{ .x = 0.0, .y = 0.0, .z = 0.0 };

    // Calculate the vectors across the horizontal and down the vertical viewport edges.
    const viewportU = @Vector(3, f64){ viewportWidth, 0.0, 0.0 };
    const viewportV = @Vector(3, f64){ 0.0, -viewportHeight, 0.0 };

    // Calculate the horizontal and vertical delta vectors from pixel to pixel.
    const pixelDeltaU: @Vector(3, f64) = viewportU / @as(@Vector(3, f64), @splat(imageWidth));
    const pixelDeltaV: @Vector(3, f64) = viewportV / @as(@Vector(3, f64), @splat(imageHeight));

    // Calculate the location of the upper left pixel.
    const viewportUpperLeft: @Vector(3, f64) =
        cameraCenter.ToVector() -
        @Vector(3, f64){ 0.0, 0.0, focalLength } -
        viewportU / @as(@Vector(3, f64), @splat(2.0)) -
        viewportV / @as(@Vector(3, f64), @splat(2.0));

    const pixelZeroLocation: @Vector(3, f64) =
        viewportUpperLeft +
        @as(@Vector(3, f64), @splat(0.5)) *
        (pixelDeltaU + pixelDeltaV);

    // --- RENDER ---
    try stdout.print("P3\n{d} {d}\n255\n", .{ imageWidth, imageHeight });

    for (0..imageHeight) |j| {
        std.debug.print("Scanlines remaining: {d}\n", .{imageHeight - j});
        for (0..imageWidth) |i| {
            const pixelCenter: @Vector(3, f64) =
                pixelZeroLocation +
                (@as(@Vector(3, f64), @splat(@as(f64, @floatFromInt(i)))) * pixelDeltaU) +
                (@as(@Vector(3, f64), @splat(@as(f64, @floatFromInt(j)))) * pixelDeltaV);

            const rayDirection: @Vector(3, f64) = pixelCenter - cameraCenter.ToVector();
            const ray: Ray = .{ .origin = cameraCenter, .direction = rayDirection };

            const pixelColor: Color = RayColor(&ray);
            try pixelColor.WriteColor(stdout);
        }
    }
    std.debug.print("\nDone!\n", .{});

    try bw.flush(); // Don't forget to flush!
}

pub fn RayColor(ray: *const Ray) Color {
    const unitDirection = ray.UnitVector();
    const aScalar: @Vector(3, f64) = @splat(0.5 * (unitDirection[1] + 1.0));
    const white: Color = .{ .red = 255, .green = 255, .blue = 255 };
    const lightBlue: Color = .{ .red = 128, .green = 178, .blue = 255 };

    return Color.InitFromNormalizedVector((@as(@Vector(3, f64), @splat(1.0)) - aScalar) *
        white.ToNormalizedVector() +
        aScalar *
        lightBlue.ToNormalizedVector());
}
