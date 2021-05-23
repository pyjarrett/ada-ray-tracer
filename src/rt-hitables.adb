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
        OC           : constant Vec3 := R.Origin - S.Center;
        A            : constant F32  := Dot (R.Direction, R.Direction);
        B            : constant F32  := Dot (OC, R.Direction);
        C            : constant F32  := Dot (OC, OC) - S.Radius * S.Radius;
        Discriminant : constant F32  := B * B - A * C;
        function Make_Hit (T : F32) return Hit_Record is
        begin
            return Hit : Hit_Record do
                Hit.T      := T;
                Hit.P      := Point_At (R, T);
                Hit.Normal := (Hit.P - S.Center) / S.Radius;
            end return;
        end Make_Hit;
    begin
        if Discriminant > 0.0 then
            declare
                Sqrt_Disc : constant F32 := RT.Elem_Funcs.Sqrt (Discriminant);
                Root1     : constant F32 := (-B - Sqrt_Disc) / A;
                Root2     : constant F32 := (-B + Sqrt_Disc) / A;
            begin

                if Root1 < T_Max and Root1 > T_Min then
                    Rec := Make_Hit (Root1);
                    return True;
                end if;

                if Root2 < T_Max and Root2 > T_Min then
                    Rec := Make_Hit (Root1);
                    return True;
                end if;
            end;
        end if;
        return False;
    end Hit;

end RT.Hitables;
