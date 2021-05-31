package body RT.Image_Planes is
    function Make_Image_Plane (Width : Positive; Height : Positive) return Image_Plane is
    begin
        return IP : Image_Plane (Width => Width, Height => Height) do
            null;
        end return;
    end Make_Image_Plane;
end RT.Image_Planes;
