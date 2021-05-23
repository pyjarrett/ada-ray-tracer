package body RT.Pseudorandom is


    function Random_F32 return F32 is
        use Ada.Numerics.Float_Random;
    begin
        return F32(Random(Randomness));
    end Random_F32;

    function Random_Vector return Vec3 is
        use Ada.Numerics.Float_Random;
    begin
        return V : Vec3 do
            V.X := F32 (Random (Randomness));
            V.Y := F32 (Random (Randomness));
            V.Z := F32 (Random (Randomness));
        end return;
    end Random_Vector;

    function Random_In_Unit_Sphere return Vec3 is
        P : Vec3;
    begin
        loop
            P := 2.0 * Random_Vector - (1.0, 1.0, 1.0);
            exit when Length2 (P) < 1.0;
        end loop;
        return P;
    end Random_In_Unit_Sphere;

end RT.Pseudorandom;