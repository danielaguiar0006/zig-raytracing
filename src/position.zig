pub const Position = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn ToVector(self: Position) @Vector(3, f64) {
        return @Vector(3, f64){ self.x, self.y, self.z };
    }
};
