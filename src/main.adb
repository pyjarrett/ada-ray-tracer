with Ada.Text_IO;

with RT.Rays;
with RT.Vecs;

procedure Main is
    use Ada.Text_IO;

    Rows : constant := 200;
    Cols : constant := 400;

    use RT;
    use RT.Rays;
    use RT.Vecs;


    function Sky_Color (R : Ray) return Vec3 is
        Unit_Direction : constant Vec3 := Unit_Vector (R.Direction);
        T              : constant F32  := 0.5 * (Unit_Direction.Y + 1.0);
    begin
        return (1.0 - T) * (1.0, 1.0, 1.0) + T * (0.5, 0.7, 1.0);
    end Sky_Color;

    function Hit_Sphere (Center : Vec3; Radius : F32; R : Ray) return Boolean
    is
        OC           : constant Vec3 := R.Origin - Center;
        A            : constant F32  := Dot (R.Direction, R.Direction);
        B            : constant F32  := 2.0 * Dot (OC, R.Direction);
        C            : constant F32  := Dot (OC, OC) - Radius * Radius;
        Discriminant : constant F32  := B * B - 4.0 * A * C;
    begin
        return Discriminant > 0.0;
    end Hit_Sphere;

    function Ray_Cast (R : Ray) return Vec3 is
        Collision : constant Boolean := Hit_Sphere ((0.0, 0.0, -1.0), 0.5, R);
    begin
        return (if Collision then (1.0, 0.0, 0.0) else Sky_Color(R));
    end Ray_Cast;

begin
    Put_Line ("P3");
    Put_Line (Cols'Image & " " & Rows'Image);
    Put_Line ("255");  -- Max color

    declare
        Lower_Left_Corner : constant Vec3 := (-2.0, -1.0, -1.0);
        Horizontal        : constant Vec3 := (4.0, 0.0, 0.0);
        Vertical          : constant Vec3 := (0.0, 2.0, 0.0);
        Origin            : constant Vec3 := (0.0, 0.0, 0.0);
    begin
        for Row in reverse 1 .. Rows loop
            for Col in 1 .. Cols loop
                declare
                    U : constant F32 := F32 (Col) / F32 (Cols);
                    V : constant F32 := F32 (Row) / F32 (Rows);
                    R : constant Ray :=
                       (Origin    => Origin,
                        Direction =>
                           Lower_Left_Corner + U * Horizontal + V * Vertical);
                    Color   : constant Vec3    := Ray_Cast (R);
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
end Main;
