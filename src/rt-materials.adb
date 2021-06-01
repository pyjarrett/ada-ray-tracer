with RT.Hitables;
with RT.Pseudorandom;

with RT.Debug;

package body RT.Materials is
    overriding function Scatter
       (Mat         :        Lambertian; R : Ray; Rec : RT.Hitables.Hit_Record;
        Attenuation : in out Color3; Scattered : in out Ray) return Boolean
    is
        Scatter_Direction : Vec3 := Rec.Normal + RT.Pseudorandom.Random_Unit_Vector;
    begin
        if Near_Zero(Scatter_Direction) then
            Scatter_Direction := Rec.Normal;
        end if;
        Scattered   := (Rec.P, Scatter_Direction);
        Attenuation := Mat.Albedo;
        return True;
    end Scatter;

    overriding function Scatter
       (Mat         :        Metal; R : Ray; Rec : RT.Hitables.Hit_Record;
        Attenuation : in out Color3; Scattered : in out Ray) return Boolean
    is
        Reflected : constant Vec3 :=
           Reflect (Unit_Vector (R.Direction), Rec.Normal);
    begin
        Scattered :=
           (Rec.P, Reflected + Mat.Fuzz * RT.Pseudorandom.Random_In_Unit_Sphere);
        Attenuation := Mat.Albedo;
        return Dot (Scattered.Direction, Rec.Normal) > 0.0;
    end Scatter;

    overriding function Scatter
       (Mat         :        Dielectric; R : Ray; Rec : RT.Hitables.Hit_Record;
        Attenuation : in out Color3; Scattered : in out Ray) return Boolean
    is
        Refracted      : Vec3;
        Ni_Over_Nt     : F32;
        Unit_Direction : constant Vec3 := Unit_Vector (R.Direction);
        use RT.Debug;
    begin
        Attenuation := (1.0, 1.0, 1.0);
        if Dot (Unit_Direction, Rec.Normal) > 0.0 then
            Ni_Over_Nt     := Mat.Ref_Index;
            Refracted := Refract (Unit_Direction, -Rec.Normal, Ni_Over_Nt);
        else
            Ni_Over_Nt     := 1.0 / Mat.Ref_Index;
            Refracted := Refract (Unit_Direction, Rec.Normal, Ni_Over_Nt);
        end if;

        Scattered := (Rec.P, Unit_Vector(Refracted));

        if Debug.Enabled then
            Print("Refracted:       " & Image (R));
            Print("     From:       " & Image (Unit_Direction));
            Print("     Normal:     " & Image (Rec.Normal));
            Print("     Refracted:  " & Image (Refracted));
            Print("     Scattered:  " & Image (Scattered));
            Print("     Angle:      " & Angle_Between (Unit_Direction, Refracted)'Image);
            Print("     Norm.Angle: " & Angle_Between (Unit_Direction, Rec.Normal)'Image);
            Print("     Dot:        " & Dot (Unit_Direction, Refracted)'Image);
            if Dot (Unit_Direction, Refracted) <= 0.0 then
                Print ("     Total internal refraction.");
            end if;
        end if;

        return True;
    end Scatter;

    function Schlick (Cosine, Ref_Index : F32) return F32 is
        R0 : F32 := (1.0 - Ref_Index) / (1.0 + Ref_Index);
    begin
        R0 := R0 * R0;
        return R0 + (1.0 - R0) * ((1.0 - Cosine) ** 5);
    end Schlick;
end RT.Materials;
