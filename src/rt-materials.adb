with RT.Hitables;
with RT.Pseudorandom;

package body RT.Materials is
    overriding function Scatter
       (Mat         :        Lambertian; R : Ray; Rec : RT.Hitables.Hit_Record;
        Attenuation : in out Vec3; Scattered : in out Ray) return Boolean
    is
        Target : constant Vec3 :=
           Rec.P + Rec.Normal + RT.Pseudorandom.Random_In_Unit_Sphere;
    begin
        Scattered   := (Rec.P, Target - Rec.P);
        Attenuation := Mat.Albedo;
        return True;
    end Scatter;

    overriding function Scatter
       (Mat         :        Metal; R : Ray; Rec : RT.Hitables.Hit_Record;
        Attenuation : in out Vec3; Scattered : in out Ray) return Boolean
    is
        Reflected : constant Vec3 :=
           Reflect (Unit_Vector (R.Direction), Rec.Normal);
    begin
        Scattered   := (Origin => Rec.P, Direction => Reflected + Mat.Fuzz * RT.Pseudorandom.Random_In_Unit_Sphere);
        Attenuation := Mat.Albedo;
        return Dot (Scattered.Direction, Rec.Normal) > 0.0;
    end Scatter;
end RT.Materials;
