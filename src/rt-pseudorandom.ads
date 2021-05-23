with Ada.Numerics.Float_Random;
with RT.Vecs;

package RT.Pseudorandom is
    use RT.Vecs;

    function Random_F32 return F32;
    function Random_Vector return Vec3;
    function Random_In_Unit_Sphere return Vec3;

private

    Randomness : Ada.Numerics.Float_Random.Generator;

end RT.Pseudorandom;
