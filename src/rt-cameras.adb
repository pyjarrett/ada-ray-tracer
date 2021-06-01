package body RT.Cameras is

    function Make_Camera return Camera is
        Aspect_Ratio    : constant F32 := 16.0 / 9.0;
        Viewport_Height : constant F32 := 2.0;
        Viewport_Width  : constant F32 := Aspect_Ratio * Viewport_Height;
        Focal_Length    : constant F32 := 1.0;
    begin
        return C : Camera do
            C.Origin            := (0.0, 0.0, 0.0);
            C.Horizontal        := (Viewport_Width, 0.0, 0.0);
            C.Vertical          := (0.0, Viewport_Height, 0.0);
            C.Lower_Left_Corner :=
               C.Origin - C.Horizontal / 2.0 - C.Vertical / 2.0 -
               Vec3'(0.0, 0.0, Focal_Length);
        end return;
    end Make_Camera;

    function Make_Ray (C : Camera; U, V : F32) return Ray is
       (Origin    => C.Origin,
        Direction =>
           Unit_Vector
              (C.Lower_Left_Corner + U * C.Horizontal + V * C.Vertical -
               C.Origin));

end RT.Cameras;
