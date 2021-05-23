package RT.Vecs with
    Pure
is
    type Vec3 is record
        X, Y, Z : F32;
    end record;

    function "-" (V : Vec3) return Vec3;

    function "+" (A, B : Vec3) return Vec3;
    function "-" (A, B : Vec3) return Vec3;
    function "*" (A, B : Vec3) return Vec3;
    function "/" (A, B : Vec3) return Vec3;

    function "*" (S : F32; A : Vec3) return Vec3;
    function "/" (A : Vec3; S : F32) return Vec3;

    function Dot (A, B : Vec3) return F32;

    function Length (V : Vec3) return F32;
    function Length2 (V : Vec3) return F32;

    procedure Normalize (V : in out Vec3);
    function Cross (A, B : Vec3) return Vec3;

    function Unit_Vector(V : Vec3) return Vec3;

    function Reflect (V, N: Vec3) return Vec3;
end RT.Vecs;
