package body RT.Hitables is

    overriding function Hit
       (H   :        Hitable_List; R : Ray; T_Min : F32; T_Max : F32;
        Rec : in out Hit_Record) return Boolean
    is
        Next_Hit       : Hit_Record;
        Closest_So_Far : F32 := T_Max;
    begin
        return Hit_Anything : Boolean := False do
            for Target of H.Targets loop
                if Hit (Target.all, R, T_Min, Closest_So_Far, Next_Hit) then
                    Hit_Anything   := True;
                    Closest_So_Far := Next_Hit.T;
                    Rec            := Next_Hit;
                end if;
            end loop;
        end return;
    end Hit;

    overriding function Hit
       (S : Sphere; R : Ray; T_Min : F32; T_Max : F32; Rec : in out Hit_Record)
        return Boolean
    is
        OC                : constant Vec3 := R.Origin - S.Center;
        A                 : constant F32  := Length2(R.Direction);
        Half_B            : constant F32  := Dot (OC, R.Direction);
        C                 : constant F32  := Length2(OC) - S.Radius * S.Radius;
        Discriminant      : constant F32  := Half_B * Half_B - A * C;
    begin
        if Discriminant < 0.0 then
            return False;
        end if;

        declare
            Sqrt_Disc : constant F32 := RT.Elem_Funcs.Sqrt (Discriminant);
            Root      : F32 := (-Half_B - Sqrt_Disc) / A;
        begin
            if Root < T_Min or else T_Max < Root then
                Root := (-Half_B + Sqrt_Disc) / A;
                if Root < T_Min or else T_Max < Root then
                    return False;
                end if;
            end if;

            Rec.T := Root;
            Rec.P := Point_At(R, Rec.T);
            Rec.Normal := (Rec.P - S.Center) / S.Radius;
            Rec.Mat := S.Mat;
            return True;
        end;
    end Hit;

end RT.Hitables;
