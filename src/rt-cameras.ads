with RT;
with RT.Rays;
with RT.Vecs;

package RT.Cameras with
    Pure
is
    use RT.Rays;
    use RT.Vecs;

    type Camera is private;

    function Make_Camera (From: Point3; Look: Point3; Up : Vec3; Vertical_FOV, Aspect_Ratio : F32) return Camera;

    function Make_Ray (C : Camera; U, V : F32) return Ray;

private

    type Camera is record
        Origin            : Point3;
        Lower_Left_Corner : Point3;
        Horizontal        : Vec3;
        Vertical          : Vec3;
    end record;

end RT.Cameras;
