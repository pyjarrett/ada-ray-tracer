with Ada.Exceptions;
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

    function Sky_Color (R : Ray) return Vec3 is
        Unit_Direction : constant Vec3 := Unit_Vector (R.Direction);
        T              : constant F32  := 0.5 * (Unit_Direction.Y + 1.0);
    begin
        return (1.0 - T) * (1.0, 1.0, 1.0) + T * (0.5, 0.7, 1.0);
    end Sky_Color;

    function Ray_Cast (R : Ray; World : Hitable'Class) return Vec3 is
        Rec : Hit_Record;
    begin
        if Hit(World, R, 0.0, F32'Last, Rec) then
            return 0.5 * (Rec.Normal + (1.0, 1.0, 1.0));
        else
            return Sky_Color(R);
        end if;
    end Ray_Cast;

begin
    Put_Line ("P3");
    Put_Line (Cols'Image & " " & Rows'Image);
    Put_Line ("255");  -- Max color

    declare
        World             : Hitable_List (2);
        Cam               : Camera;
    begin
        World.Targets(1) := new Sphere' (Center => (0.0, 0.0, -1.0), Radius => 0.5);
        World.Targets(2) := new Sphere' ((0.0, -100.5, -1.0), 100.0);

        for Row in reverse 1 .. Rows loop
            for Col in 1 .. Cols loop
                declare
                    U : constant F32 := F32 (Col) / F32 (Cols);
                    V : constant F32 := F32 (Row) / F32 (Rows);
                    R : constant Ray := Make_Ray (Cam, U, V);
                    Color   : constant Vec3    := Ray_Cast (R, World);
                    I_Red   : constant Integer := Integer (255.0 * Color.X);
                    I_Green : constant Integer := Integer (255.0 * Color.Y);
                    I_Blue  : constant Integer := Integer (255.0 * Color.Z);
                begin
                    Put (I_Red'Image & " " & I_Green'Image & " " &
                        I_Blue'Image & " ");
                end;
            end loop;
            New_Line;
        end loop;
    end;
exception
    when Err : others =>
        Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Information (Err));
        Ada.Text_IO.Put_Line ("Exception traceback: " & GNAT.Traceback.Symbolic.Symbolic_Traceback (Err));
end Main;
