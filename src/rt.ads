with Ada.Numerics.Generic_Elementary_Functions;
with Interfaces;

package RT with
    Pure
is
    type F32 is new Interfaces.IEEE_Float_32 range Interfaces.IEEE_Float_32'Range;
    package Elem_Funcs is new Ada.Numerics.Generic_Elementary_Functions (F32);
end RT;
