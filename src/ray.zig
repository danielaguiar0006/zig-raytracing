const Position = @import("position.zig").Position;
const std = @import("std");

pub const Ray = struct {
    origin: Position,
    direction: @Vector(3, f64),

    pub fn At(self: Ray, t: f64) @Vector(3, f64) {
        return self.origin + self.direction * t;
    }

    pub fn UnitVector(self: Ray) @Vector(3, f64) {
        return Normalize(self.direction);
    }

    fn Normalize(vec: @Vector(3, f64)) @Vector(3, f64) {
        const length = std.math.sqrt(vec[0] * vec[0] + vec[1] * vec[1] + vec[2] * vec[2]);
        return .{
            vec[0] / length,
            vec[1] / length,
            vec[2] / length,
        };
    }
};
