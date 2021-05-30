with Ada.Numerics;

package body RT.Debug is

    function Image (V : Vec3) return String is
       ("(" & F32'Image (V.X) & ", " & F32'Image (V.Y) & ", " &
        F32'Image (V.Z) & ")" & " Length: " & Length (V)'Image);
    function Image (R : Ray) return String is
       ("From: " & Image (R.Origin) & " To: " & Image (R.Direction) &
        " Length: " & Length (R.Direction)'Image);

    function Angle_Between (A, B : Vec3) return F32 is
        NA : constant Vec3 := Unit_Vector(A);
        NB : constant Vec3 := Unit_Vector(B);
    begin
        return Elem_Funcs.Arccos(Dot(NA, NB)) * 180.0 / Ada.Numerics.Pi;
    end Angle_Between;

end RT.Debug;
