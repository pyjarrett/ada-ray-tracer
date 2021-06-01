with Ada.Exceptions;
with Ada.Text_IO;

with GNATCOLL.Terminal;
with GNAT.Traceback.Symbolic;
with Interfaces;

with RT.BMP;
with RT.Cameras;
with RT.Hitables;
with RT.Image_Planes;
with RT.Materials;
with RT.Pseudorandom;
with RT.Rays;
with RT.Vecs;


procedure Main is
    Rows    : constant := 200;
    Cols    : constant := 400;
    Bounces : constant := 50;
    Samples : constant := 30;

    use RT;
    use RT.Cameras;
    use RT.Hitables;
    use RT.Materials;
    use RT.Pseudorandom;
    use RT.Rays;
    use RT.Vecs;

    Image : RT.Image_Planes.Image_Plane := RT.Image_Planes.Make_Image_Plane(Width => Cols, Height => Rows);
    Term_Info : GNATCOLL.Terminal.Terminal_Info;

    procedure Report_Progress (Done, Total : Integer) is
        Progress_Percent : constant Integer := Integer(Float'Rounding(Float(Done) / Float(Total) * 100.0));
    begin
        GNATCOLL.Terminal.Beginning_Of_Line(Term_Info);
        GNATCOLL.Terminal.Clear_To_End_Of_Line(Term_Info);
        Ada.Text_IO.Put (Progress_Percent'Image & "%");
    end Report_Progress;

    function Sky_Color (R : Ray) return Color3 is
        Unit_Direction : constant Vec3 := Unit_Vector (R.Direction);
        T              : constant F32  := 0.5 * (Unit_Direction.Y + 1.0);
    begin
        return (1.0 - T) * (1.0, 1.0, 1.0) + T * (0.5, 0.7, 1.0);
    end Sky_Color;

    function Ray_Cast
       (R : Ray; World : Hitable'Class; Depth : Integer) return Color3
    is
        Rec : Hit_Record;
    begin
        if Depth <= 0 then
            return (0.0, 0.0, 0.0);
        end if;

        if Hit (World, R, 0.001, F32'Last, Rec) then
            declare
                Scattered   : Ray;
                Attenuation : Color3;
            begin
                if Scatter (Rec.Mat.Get, R, Rec, Attenuation, Scattered) then
                    return
                       Attenuation * Ray_Cast (Scattered, World, Depth - 1);
                else
                    return (0.0, 0.0, 0.0);
                end if;
            end;
        end if;

        -- Nothing was hit.
        return Sky_Color (R);
    end Ray_Cast;
begin
    GNATCOLL.Terminal.Init_For_Stdout (Term_Info);

    declare
        World : Hitable_List;
        Cam   : constant Camera := Make_Camera;
    begin
        World.Add(Sphere'(Center => (0.0, 0.0, -1.0), Radius => 0.5,
                          Mat    => Make_Material(Lambertian'(Albedo => (0.1, 0.2, 0.5)))));
        World.Add(Sphere'(Center => (0.0, -100.5, -1.0), Radius => 100.0,
                          Mat    => Make_Material(Lambertian'(Albedo => (0.8, 0.8, 0.0)))));
        World.Add(Sphere'(Center => (1.0, 0.0, -1.0), Radius => 0.5,
                          Mat    => Make_Material(Metal'(Albedo => (0.8, 0.6, 0.2), Fuzz => 0.0))));
        World.Add(Sphere'(Center => (-1.0, 0.0, -1.0), Radius => 0.5,
                          Mat    => Make_Material(Dielectric'(Ref_Index => 1.5))));
        World.Add(Sphere'(Center => (-1.0, 0.0, -1.0), Radius => -0.45,
                          Mat => Make_Material(Dielectric'(Ref_Index => 1.5))));

        for Row in reverse 1 .. Rows loop
            Report_Progress(Rows - Row, Rows);
            for C in 1 .. Cols loop
                declare
                    Result : Color3 := (0.0, 0.0, 0.0);
                begin
                    for Sample in 1 .. Samples loop
                        declare
                            U : constant F32 :=
                               (F32 (C) + Random_F32) / F32 (Cols);
                            V : constant F32 :=
                               (F32 (Row) + Random_F32) / F32 (Rows);
                            R     : constant Ray  := Make_Ray (Cam, U, V);
                            Color : constant Color3 :=
                               Ray_Cast (R, World, Bounces);
                        begin
                            Result := Result + Color;
                        end;
                    end loop;
                    Result := Result / F32 (Samples);
                    declare
                        Gamma_Corrected : constant Vec3 :=
                           (Elem_Funcs.Sqrt (Result.X),
                            Elem_Funcs.Sqrt (Result.Y),
                            Elem_Funcs.Sqrt (Result.Z));
                        I_Red : constant Integer :=
                           Integer (255.0 * Gamma_Corrected.X);
                        I_Green : constant Integer :=
                           Integer (255.0 * Gamma_Corrected.Y);
                        I_Blue : constant Integer :=
                           Integer (255.0 * Gamma_Corrected.Z);
                    begin
                        Image.Raster(Row, C).Red := Interfaces.Unsigned_8(I_Red);
                        Image.Raster(Row, C).Green := Interfaces.Unsigned_8(I_Green);
                        Image.Raster(Row, C).Blue := Interfaces.Unsigned_8(I_Blue);
                    end;
                end;
            end loop;
        end loop;
    end;

    RT.BMP.Write ("output.bmp", Image);
exception
    when Err : others =>
        Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Information (Err));
        Ada.Text_IO.Put_Line
           ("Exception traceback: " &
            GNAT.Traceback.Symbolic.Symbolic_Traceback (Err));
end Main;
