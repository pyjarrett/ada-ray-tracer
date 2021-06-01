with RT.Vecs;

package RT.Rays with
    Pure
is
    use RT.Vecs;

    type Ray is record
        Origin    : Point3;
        Direction : Vec3;
    end record;

    function Point_At(R : Ray; T: F32) return Point3;

end RT.Rays;
