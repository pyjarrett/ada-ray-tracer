package body RT.Cameras is

    function Make_Ray (C : Camera; U, V : F32) return Ray is
       (Origin    => C.Origin,
        Direction =>
           C.Lower_Left_Corner + U * C.Horizontal + V * C.Vertical - C.Origin);

end RT.Cameras;
