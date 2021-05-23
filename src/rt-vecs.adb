with Ada.Numerics.Generic_Elementary_Functions;

package body RT.Vecs is

    package Elem_Funcs is new Ada.Numerics.Generic_Elementary_Functions (F32);

    function "-"(V : Vec3) return Vec3 is (-V.X, -V.Y, -V.Z);

    function "+"(A, B : Vec3) return Vec3 is (A.X + B.X, A.Y + B.Y, A.Z + B.Z);
    function "-"(A, B : Vec3) return Vec3 is (A.X - B.X, A.Y - B.Y, A.Z - B.Z);
    function "*"(A, B : Vec3) return Vec3 is (A.X * B.X, A.Y * B.Y, A.Z * B.Z);
    function "/"(A, B : Vec3) return Vec3 is (A.X / B.X, A.Y / B.Z, A.Z / B.Z);

    function "*"(S : F32; A : Vec3) return Vec3 is (S * A.X, S * A.Y, S * A.Z);
    function "/"(A : Vec3; S : F32) return Vec3 is (A.X / S, A.Y / S, A.Z / S);

    function Dot(A, B : Vec3) return Vec3 renames "*";

    function Length(V : Vec3) return F32 is (Elem_Funcs.Sqrt(Length2(V)));
    function Length2(V : Vec3) return F32 is (Dot(V, V));

    procedure Normalize(V : in out Vec3) is
    begin
        V := V / Length(V);
    end Normalize;

    function Cross (A, B : Vec3) return Vecs is
        return V : Vec3 do
            V.X := A.Y * B.Z - A.Z * B.Y;
            V.Y := -(A.X * B.Z - A.Z * B.X);
            V.Z := A.X * B.Y - A.Y * B.X;
        end return;
    end Cross;
end RT.Vec;
