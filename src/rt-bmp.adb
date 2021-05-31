with Ada.Streams.Stream_IO;

with Ada.Text_IO; -- for debugging...

package body RT.BMP is
    procedure Write (File_Name : in String; IP : in RT.Image_Planes.Image_Plane) is
        package AIO renames Ada.Text_IO;

        package SO renames Ada.Streams.Stream_IO;
        File : SO.File_Type;
        Strm : SO.Stream_Access;

        File_Header : Bitmap_File_Header;
        Info_Header : Bitmap_Info_Header;

        Header_Sizes : constant Interfaces.Integer_32 := (Bitmap_File_Header'Size + Bitmap_Info_Header'Size) / 8;
        Image_Data_Size : constant Integer_32 := Interfaces.Integer_32(Positive(IP.Bits_Per_Pixel) * IP.Width * IP.Height / 8);

        Row_Bytes_Toward_Four_Byte_Alignment : constant Integer := (IP.Width * Integer(IP.Bits_Per_Pixel) / 8) mod 4;
        Row_Padding : constant Integer := (if Row_Bytes_Toward_Four_Byte_Alignment mod 4 = 0 then 0 else 4 - Row_Bytes_Toward_Four_Byte_Alignment);
    begin
        SO.Create (File => File, Mode => SO.Out_File, Name => File_Name);
        Strm := SO.Stream (File);

        Info_Header := Bitmap_Info_Header'(Size                  => Bitmap_Info_Header_Size,
                                           Width                 => Interfaces.Integer_32(IP.Width),
                                           Height                => Interfaces.Integer_32(IP.Height),
                                           Num_Color_Planes      => 1,
                                           Bits_Per_Pixel        => IP.Bits_Per_Pixel,
                                           others                => <>);

        File_Header := Bitmap_File_Header'(File_Size_Bytes => Header_Sizes + Image_Data_Size,
                                           Offset          => Header_Sizes,
                                           others          => <>);

        Bitmap_File_Header'Write (Strm, File_Header);
        Bitmap_Info_Header'Write (Strm, Info_Header);
        for Row in 1 .. IP.Height loop
            for Col in 1 .. IP.Width loop
                RT.Image_Planes.Pixel'Write (Strm, IP.Raster(Row, Col));
            end loop;

            for P in 1 .. Row_Padding loop
                Interfaces.Unsigned_8'Write(Strm, 0);
            end loop;
        end loop;
        SO.Close(File);

        AIO.Put_Line ("Header sizes:" & Header_Sizes'Image);
        AIO.Put_Line ("Data Size:"  & Image_Data_Size'Image);
    end Write;
end RT.BMP;
