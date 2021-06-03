with RT;
with RT.Rays;
with RT.Vecs;

package RT.Cameras is
    use RT.Rays;
    use RT.Vecs;

    type Camera is private;

    function Make_Camera
       (From         : Point3; Look : Point3; Up : Vec3; Vertical_FOV : F32;
        Aspect_Ratio : F32; Aperture : F32; Focus_Distance : F32)
        return Camera with
        Pre => Aspect_Ratio > 0.0 and then Aperture >= 0.0
        and then Focus_Distance >= 0.0;

    function Make_Ray (C : Camera; S, T : F32) return Ray;

private

    type Camera is record
        Origin            : Point3;
        Lower_Left_Corner : Point3;
        Horizontal        : Vec3;
        Vertical          : Vec3;
        U, V, W           : Vec3;
        Lens_Radius       : F32;
    end record;

end RT.Cameras;
