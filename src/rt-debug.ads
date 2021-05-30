with Ada.Text_IO;

with RT.Rays;
with RT.Vecs;

package RT.Debug is
    use RT.Rays;
    use RT.Vecs;

    Enabled : Boolean := False;

    function Image (V : Vec3) return String;
    function Image (R : Ray) return String;

    procedure Print (Str : String) renames Ada.Text_IO.Put_Line;

    function Angle_Between (A, B : Vec3) return F32;

end RT.Debug;
