package RT.Vecs with
    Pure
is
    type Vec3 is record
        X, Y, Z : F32 := 0.0;
    end record;

    --------------------------------------------------------------------------
    -- Common operations for vector-like types.
    --------------------------------------------------------------------------

    function "+" (A, B : Vec3) return Vec3;
    function "-" (A, B : Vec3) return Vec3;
    function "*" (A, B : Vec3) return Vec3;

    function "*" (S : F32; A : Vec3) return Vec3;
    function "*" (A : Vec3; S : F32) return Vec3;
    function "/" (A : Vec3; S : F32) return Vec3;

    function Near_Zero (V : Vec3) return Boolean;
    function Near_Unit (V : Vec3) return Boolean;

    function Image (V : Vec3) return String;

    function "-" (V : Vec3) return Vec3;

    type Color3 is new Vec3;
    type Point3 is new Vec3;

    --------------------------------------------------------------------------

    function "+"(A : Point3; B : Vec3) return Point3 is (A + Point3(B));
    -- Translate a point by a vector.

    function "+"(A : Vec3; B : Point3) return Point3 is (Point3(A) + B);
    -- Translate a point by a vector.

    function "-"(A : Point3; B : Vec3) return Point3 is (A - Point3(B));
    -- Translate a point by a vector.

    function "-"(A : Vec3; B : Point3) return Point3 is (Point3(A) - B);
    -- Translate a point by a vector.

    function "-"(To : Point3; From : Point3) return Vec3 is (Vec3(To) - Vec3(From));
    -- The vector giving a direction between two points.

    --------------------------------------------------------------------------
    -- Vector specific functions
    --------------------------------------------------------------------------

    -- These functions are added after Color3 and Point3 types have been
    -- declared to prevent mistakes like taking the length of a color or
    -- trying to Refract or Reflect a point.

    function Dot (A, B : Vec3) return F32;

    function Length (V : Vec3) return F32;
    function Length2 (V : Vec3) return F32;

    procedure Normalize (V : in out Vec3);
    function Cross (A, B : Vec3) return Vec3;

    function Unit_Vector(V : Vec3) return Vec3;

    function Reflect (V, N: Vec3) return Vec3;

    function Refract (UV, N : Vec3; Ni_Over_Nt : F32) return Vec3;

end RT.Vecs;
