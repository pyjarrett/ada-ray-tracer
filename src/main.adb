with Ada.Text_IO;

procedure Main is
    use Ada.Text_IO;

    Rows : constant := 5;
    Cols : constant := 3;
begin

    Put_Line ("P3");
    Put_Line (Cols'Image & " " & Rows'Image);
    Put_Line ("255");  -- Max color

    for Row in reverse 1 .. Rows loop
        for Col in 1 .. Cols loop
            declare
                Red     : constant Float   := Float (Col) / Float (Cols);
                Green   : constant Float   := Float (Row) / Float (Rows);
                Blue    : constant Float   := 0.2;
                I_Red   : constant Integer := Integer (255.0 * Red);
                I_Green : constant Integer := Integer (255.0 * Green);
                I_Blue  : constant Integer := Integer (255.0 * Blue);
            begin
                Put(I_Red'Image & " " & I_Green'Image & " " & I_Blue'Image & " ");
            end;
        end loop;
        New_Line;
    end loop;
end Main;
