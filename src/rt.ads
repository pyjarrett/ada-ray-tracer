with Ada.Numerics.Generic_Elementary_Functions;

package RT with
    Pure
is
    type F32 is new Float range Float'Range;
    package Elem_Funcs is new Ada.Numerics.Generic_Elementary_Functions (F32);
end RT;
