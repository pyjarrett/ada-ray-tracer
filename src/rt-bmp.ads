with Interfaces;

with RT.Image_Planes;

package RT.BMP is
    -- Provides a simple uncompressed BMP implementation that will work with
    -- many image viewers.
    --
    -- PPM generation is neat, but it doesn't play well with Windows because
    -- output encoding has an effect on whether it's loadable by some viewers,
    -- since Powershell (and much of Windows as a whole) uses UTF-16 by default.
    --
    -- This avoids needing special powershell pipes and frees us stdout for
    -- additional diagnostics, in addition to having stderr available.
    --
    -- Before: "utf7" seems bizarre, but it ensure UTF-8 with no BOM
    --
    --     .\obj\main.exe | Out-File -FilePath output.ppm -Encoding utf7
    --
    use Interfaces;

    Byte : constant := 8;

    BMP_Magic : constant := 16#4D42#;
    -- This is "BM"

    type Bitmap_File_Header is record
        Identifier      : Integer_16 := BMP_Magic;
        File_Size_Bytes : Integer_32;
        Reserved        : Integer_16 := 0;
        Reserved2       : Integer_16 := 0;
        Offset          : Integer_32;
    end record with
        Size => Byte * 14;

    for Bitmap_File_Header use record
        Identifier      at  0 range 0 .. 15;
        File_Size_Bytes at  2 range 0 .. 31;
        Reserved        at  6 range 0 .. 15;
        Reserved2       at  8 range 0 .. 15;
        Offset          at 10 range 0 .. 31;
    end record;

    Bitmap_Info_Header_Size       : constant := 40;
    No_Compression                : constant := 0;
    Image_Size_BI_RGB             : constant := 0;
    Default_Vertical_Resolution   : constant := 0;
    Default_Horizontal_Resolution : constant := 0;
    Default_Colors_In_Palette     : constant := 0;  -- default to 2**n
    Every_Color_Important         : constant := 0;

    type Bitmap_Info_Header is record
        Size                  : Integer_32 := Bitmap_Info_Header_Size;
        Width                 : Integer_32;
        Height                : Integer_32;
        Num_Color_Planes      : Integer_16 := 1;
        Bits_Per_Pixel        : Integer_16;
        Compression_Method    : Integer_32 := No_Compression;
        Image_Size            : Integer_32 := Image_Size_BI_RGB;
        Horizontal_Resolution : Integer_32 := Default_Vertical_Resolution;
        Vertical_Resolution   : Integer_32 := Default_Horizontal_Resolution;
        Colors_In_Palette     : Integer_32 := Default_Colors_In_Palette;
        Num_Important_Colors  : Integer_32 := Every_Color_Important;
    end record with
        Size => Byte * 40;

    for Bitmap_Info_Header use record
        Size                  at  0 range 0 .. 31;
        Width                 at  4 range 0 .. 31;
        Height                at  8 range 0 .. 31;
        Num_Color_Planes      at 12 range 0 .. 15;
        Bits_Per_Pixel        at 14 range 0 .. 15;
        Compression_Method    at 16 range 0 .. 31;
        Image_Size            at 20 range 0 .. 31;
        Horizontal_Resolution at 24 range 0 .. 31;
        Vertical_Resolution   at 28 range 0 .. 31;
        Colors_In_Palette     at 32 range 0 .. 31;
        Num_Important_Colors  at 36 range 0 .. 31;
    end record;

    procedure Write (File_Name : in String; IP : in RT.Image_Planes.Image_Plane);
    -- Writes an extremely simple, uncompressed BMP as the given file.

end RT.BMP;
