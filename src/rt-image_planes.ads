with Interfaces;

package RT.Image_Planes is
    type Pixel is record
        Red : Interfaces.Unsigned_8;
        Green : Interfaces.Unsigned_8;
        Blue : Interfaces.Unsigned_8;
    end record;

    Black : constant Pixel := (0, 0, 0);

    type Pixel_Row is array (Positive range <>) of Pixel;
    --  type Pixel_Grid(Width : is array (Positive range <>) of Pixel_Row;
    type Pixel_Array is
       array (Positive range <>, Positive range <>) of Pixel;

    type Image_Plane (Height : Positive; Width : Positive) is tagged record
        Raster : Pixel_Array (1 .. Height, 1 .. Width);
    end record;

    function Bits_Per_Pixel (IP : Image_Plane) return Interfaces.Integer_16 is (24);

    function Make_Image_Plane (Width : Positive; Height : Positive) return Image_Plane;

end RT.Image_Planes;
