with Interfaces;

package RT.Image_Planes is
    type Pixel is record
        Blue : Interfaces.Unsigned_8;
        Green : Interfaces.Unsigned_8;
        Red : Interfaces.Unsigned_8;
    end record;

    function Bits_Per_Pixel return Interfaces.Integer_16 is (24);

    type Pixel_Grid is
       array (Positive range <>, Positive range <>) of Pixel;

    type Image_Plane (Height : Positive; Width : Positive) is tagged record
        -- Wraps the pixel array so its bounds remain unknown, and yet because
        -- of the magic of discriminants, things still "just work", while also
        -- getting nicely named values for Width and Height.
        Raster : Pixel_Grid (1 .. Height, 1 .. Width);
    end record;

    function Make_Image_Plane (Width : Positive; Height : Positive) return Image_Plane;
    -- Convenience function to hide plane creation and avoid raster initialization.

end RT.Image_Planes;
