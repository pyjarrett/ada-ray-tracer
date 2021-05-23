package body RT.Rays is
    use all type RT.Vecs.Vec3;

    function Point_At(R : Ray; T: F32) return Vec3 is (R.Origin + T * R.Direction);

end RT.Rays;
