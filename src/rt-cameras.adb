with Ada.Numerics;

package body RT.Cameras is

    function Degrees_To_Radians (Degrees : F32) return F32 is
       (Ada.Numerics.Pi / 180.0 * Degrees);

    function Make_Camera
        (From           : Point3;
         Look           : Point3;
         Up             : Vec3;
         Vertical_FOV   : F32;
         Aspect_Ratio   : F32;
         Aperture       : F32;
         Focus_Distance : F32) return Camera
    is
        Theta           : constant F32  := Degrees_To_Radians (Vertical_FOV);
        Height          : constant F32  := RT.Elem_Funcs.Tan (Theta / 2.0);
        Viewport_Height : constant F32  := 2.0 * Height;
        Viewport_Width  : constant F32  := Aspect_Ratio * Viewport_Height;
        W               : constant Vec3 := Unit_Vector (From - Look);
        U               : constant Vec3 := Unit_Vector (Cross (Up, W));
        V               : constant Vec3 := Cross (W, U);
    begin
        return C : Camera do
            C.Origin            := From;
            C.Horizontal        := Viewport_Width * U;
            C.Vertical          := Viewport_Height * V;
            C.Lower_Left_Corner :=
               C.Origin - C.Horizontal / 2.0 - C.Vertical / 2.0 - W;
        end return;
    end Make_Camera;

    function Make_Ray (C : Camera; U, V : F32) return Ray is
       (Origin    => C.Origin,
        Direction =>
           Unit_Vector
              (C.Lower_Left_Corner + U * C.Horizontal + V * C.Vertical -
               C.Origin));

end RT.Cameras;
