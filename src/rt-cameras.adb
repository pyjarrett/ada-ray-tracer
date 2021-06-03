with Ada.Numerics;
with RT.Pseudorandom;

package body RT.Cameras is

    function Degrees_To_Radians (Degrees : F32) return F32 is
       (Ada.Numerics.Pi / 180.0 * Degrees);

    function Make_Camera
       (From         : Point3; Look : Point3; Up : Vec3; Vertical_FOV : F32;
        Aspect_Ratio : F32; Aperture : F32; Focus_Distance : F32) return Camera
    is
        Theta           : constant F32 := Degrees_To_Radians (Vertical_FOV);
        Height          : constant F32 := RT.Elem_Funcs.Tan (Theta / 2.0);
        Viewport_Height : constant F32 := 2.0 * Height;
        Viewport_Width  : constant F32 := Aspect_Ratio * Viewport_Height;
    begin
        return C : Camera do
            C.W                 := Unit_Vector (From - Look);
            C.U                 := Unit_Vector (Cross (Up, C.W));
            C.V                 := Cross (C.W, C.U);
            C.Origin            := From;
            C.Horizontal        := Focus_Distance * Viewport_Width * C.U;
            C.Vertical          := Focus_Distance * Viewport_Height * C.V;
            C.Lower_Left_Corner :=
               C.Origin - C.Horizontal / 2.0 - C.Vertical / 2.0 -
               Focus_Distance * C.W;
            C.Lens_Radius := Aperture / 2.0;
        end return;
    end Make_Camera;

    function Make_Ray (C : Camera; S, T : F32) return Ray is
        RD : constant Vec3 :=
           C.Lens_Radius * RT.Pseudorandom.Random_In_Unit_Disk;
        Offset : constant Vec3 := C.U * RD.X + C.V * RD.Y;
    begin
        return R : Ray do
            R.Origin    := Offset + C.Origin;
            R.Direction :=
               Unit_Vector
                  (C.Lower_Left_Corner + S * C.Horizontal + T * C.Vertical -
                   C.Origin - Offset);
        end return;
    end Make_Ray;

end RT.Cameras;
