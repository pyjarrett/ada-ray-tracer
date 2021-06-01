with RT;
with RT.Rays;
with RT.Vecs;

package RT.Cameras with
    Pure
is
    use RT.Rays;
    use RT.Vecs;

    type Camera is record
        Lower_Left_Corner : Vec3 := (-2.0, -1.0, -1.0);
        Horizontal        : Vec3 := (4.0, 0.0, 0.0);
        Vertical          : Vec3 := (0.0, 2.0, 0.0);
        Origin            : Point3 := (0.0, 0.0, 0.0);
    end record;

    function Make_Ray (C : Camera; U, V : F32) return Ray;

end RT.Cameras;
