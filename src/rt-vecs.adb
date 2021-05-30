package body RT.Vecs is
    function "-"(V : Vec3) return Vec3 is (-V.X, -V.Y, -V.Z);

    function "+"(A, B : Vec3) return Vec3 is (A.X + B.X, A.Y + B.Y, A.Z + B.Z);
    function "-"(A, B : Vec3) return Vec3 is (A.X - B.X, A.Y - B.Y, A.Z - B.Z);
    function "*"(A, B : Vec3) return Vec3 is (A.X * B.X, A.Y * B.Y, A.Z * B.Z);
    function "/"(A, B : Vec3) return Vec3 is (A.X / B.X, A.Y / B.Z, A.Z / B.Z);

    function "*"(S : F32; A : Vec3) return Vec3 is (S * A.X, S * A.Y, S * A.Z);
    function "/"(A : Vec3; S : F32) return Vec3 is (A.X / S, A.Y / S, A.Z / S);

    function Dot(A, B : Vec3) return F32 is (A.X * B.X + A.Y * B.Y + A.Z * B.Z);

    function Length(V : Vec3) return F32 is (Elem_Funcs.Sqrt(Length2(V)));
    function Length2(V : Vec3) return F32 is (Dot(V, V));

    procedure Normalize(V : in out Vec3) is
    begin
        V := V / Length(V);
    end Normalize;

    function Cross (A, B : Vec3) return Vec3 is
    begin
        return V : Vec3 do
            V.X := A.Y * B.Z - A.Z * B.Y;
            V.Y := -(A.X * B.Z - A.Z * B.X);
            V.Z := A.X * B.Y - A.Y * B.X;
        end return;
    end Cross;

    function Unit_Vector (V : Vec3) return Vec3 is (V / Length(V));

    function Reflect (V, N: Vec3) return Vec3 is (V - 2.0 * Dot (V, N) * N);

    function Refract (UV, N : Vec3; Ni_Over_Nt : F32) return Vec3 is
        Cos_Theta : constant F32 := F32'Min(Dot (-UV, N), 1.0);
        R_Out_Perp : constant Vec3 := Ni_Over_Nt * (UV + Cos_Theta * N);
        R_Out_Parallel : constant Vec3 := -Elem_Funcs.Sqrt(abs (1.0 - Length2(R_Out_Perp))) * N;
        Result : constant Vec3 := R_Out_Perp + R_Out_Parallel;
    begin
        return Result;
    end Refract;

    function Near_Zero (V : Vec3) return Boolean is
        Epsilon : constant := 0.000_000_001;
    begin
        return abs V.X < Epsilon and then abs V.Y < Epsilon and then abs V.Z < Epsilon;
    end Near_Zero;

    function Near_Unit (V : Vec3) return Boolean is
        Epsilon : constant := 1.000_000_001;
    begin
        return abs V.X < Epsilon and then abs V.Y < Epsilon and then abs V.Z < Epsilon;
    end Near_Unit;

end RT.Vecs;
