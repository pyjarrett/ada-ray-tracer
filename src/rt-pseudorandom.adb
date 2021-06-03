package body RT.Pseudorandom is
    function Random_F32 return F32 is
        use Ada.Numerics.Float_Random;
    begin
        return F32 (Random (Randomness));
    end Random_F32;

    function Random_F32 (Min : F32; Max : F32) return F32 is
    begin
        return Min + (Max - Min) * Random_F32;
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

    function Random_Vector(Min, Max : F32) return Vec3 is (Random_F32(Min, Max), Random_F32(Min, Max), Random_F32(Min, Max));

    function Random_In_Unit_Sphere return Vec3 is
        P : Vec3;
    begin
        loop
            P := 2.0 * Random_Vector - (1.0, 1.0, 1.0);
            exit when Length2 (P) < 1.0;
        end loop;
        return P;
    end Random_In_Unit_Sphere;

    function Random_Unit_Vector return Vec3 is
       (Unit_Vector (Random_In_Unit_Sphere));

    function Random_In_Hemisphere (N : Vec3) return Vec3 is
        V : constant Vec3 := Random_In_Unit_Sphere;
    begin
        if Dot (V, N) > 0.0 then
            return V;
        else
            return -V;
        end if;
    end Random_In_Hemisphere;

    function Random_In_Unit_Disk return Vec3 is
        P : Vec3;
    begin
        loop
            P := (Random_F32 (-1.0, 1.0), Random_F32 (-1.0, 1.0), 0.0);
            if Length2 (P) < 1.0 then
                return P;
            end if;
        end loop;
    end Random_In_Unit_Disk;

end RT.Pseudorandom;
