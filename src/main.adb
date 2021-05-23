with Ada.Exceptions;
with Ada.Numerics.Float_Random;
with Ada.Text_IO;

with GNAT.Traceback.Symbolic;

with RT.Cameras;
with RT.Hitables;
with RT.Rays;
with RT.Vecs;

procedure Main is
    use Ada.Text_IO;

    Rows : constant := 200;
    Cols : constant := 400;

    use RT;
    use RT.Cameras;
    use RT.Hitables;
    use RT.Rays;
    use RT.Vecs;

    Randomness : Ada.Numerics.Float_Random.Generator;

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

    function Sky_Color (R : Ray) return Vec3 is
        Unit_Direction : constant Vec3 := Unit_Vector (R.Direction);
        T              : constant F32  := 0.5 * (Unit_Direction.Y + 1.0);
    begin
        return (1.0 - T) * (1.0, 1.0, 1.0) + T * (0.5, 0.7, 1.0);
    end Sky_Color;

    function Ray_Cast (R : Ray; World : Hitable'Class) return Vec3 is
        Rec    : Hit_Record;
        Target : Vec3;
    begin
        if Hit (World, R, 0.000_1, F32'Last, Rec) then
            Target := Rec.P + Rec.Normal + Random_In_Unit_Sphere;
            return 0.5 * Ray_Cast (Ray'(Rec.P, Target - Rec.P), World);
        else
            return Sky_Color (R);
        end if;
    end Ray_Cast;

begin
    Put_Line ("P3");
    Put_Line (Cols'Image & " " & Rows'Image);
    Put_Line ("255");  -- Max color

    declare
        World : Hitable_List (2);
        Cam   : Camera;
        Samples : constant Positive := 100;
    begin
        World.Targets (1) :=
           new Sphere'(Center => (0.0, 0.0, -1.0), Radius => 0.5);
        World.Targets (2) := new Sphere'((0.0, -100.5, -1.0), 100.0);

        for Row in reverse 1 .. Rows loop
            for Col in 1 .. Cols loop
                declare
                    Result : Vec3 := (0.0, 0.0, 0.0);
                begin
                    for Sample in 1 .. Samples loop
                        declare
                            U               : constant F32  := (F32 (Col) + Random_F32) / F32 (Cols);
                            V               : constant F32  := (F32 (Row) + Random_F32) / F32 (Rows);
                            R               : constant Ray  := Make_Ray (Cam, U, V);
                            Color           : constant Vec3 := Ray_Cast (R, World);
                        begin
                            Result := Result + Color;
                        end;
                    end loop;
                    Result := Result / F32(Samples);
                declare
                        Gamma_Corrected : constant Vec3 :=
                                            (Elem_Funcs.Sqrt (Result.X), Elem_Funcs.Sqrt (Result.Y),
                                             Elem_Funcs.Sqrt (Result.Z));
                        I_Red           : constant Integer :=
                                            Integer (255.0 * Gamma_Corrected.X);
                        I_Green         : constant Integer :=
                                            Integer (255.0 * Gamma_Corrected.Y);
                        I_Blue          : constant Integer :=
                                            Integer (255.0 * Gamma_Corrected.Z);
                    begin
                        Put (I_Red'Image & " " & I_Green'Image & " " &
                                 I_Blue'Image & " ");
                    end;
                end;
            end loop;
            New_Line;
        end loop;
    end;
exception
    when Err : others =>
        Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Information (Err));
        Ada.Text_IO.Put_Line
           ("Exception traceback: " &
            GNAT.Traceback.Symbolic.Symbolic_Traceback (Err));
end Main;
