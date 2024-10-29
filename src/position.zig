pub const Position = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn X(self: Position) f64 {
        return self.x;
    }

    pub fn Y(self: Position) f64 {
        return self.y;
    }

    pub fn Z(self: Position) f64 {
        return self.z;
    }

    pub fn ToVector(self: Position) @Vector(3, f64) {
        return @Vector(3, f64){ self.x, self.y, self.z };
    }
};
