with Ada.Numerics.Float_Random;
with RT.Vecs;

package RT.Pseudorandom is
    use RT.Vecs;

    function Random_F32 return F32 with
        Post => 0.0 <= Random_F32'Result and then Random_F32'Result <= 1.0;

    function Random_F32 (Min : F32; Max : F32) return F32 with
        Pre  => Min < Max,
        Post => Min <= Random_F32'Result and then Random_F32'Result <= Max;

    function Random_Vector return Vec3;
    function Random_Vector(Min, Max : F32) return Vec3 with
        Pre => Min < Max;

    function Random_In_Unit_Sphere return Vec3;
    function Random_Unit_Vector return Vec3;
    function Random_In_Hemisphere (N : Vec3) return Vec3;
    function Random_In_Unit_Disk return Vec3;

private

    Randomness : Ada.Numerics.Float_Random.Generator;

end RT.Pseudorandom;
