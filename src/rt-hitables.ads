limited with RT.Materials;
with RT.Rays;
with RT.Vecs;

package RT.Hitables is
    use RT.Rays;
    use RT.Vecs;

    type Material_Access is access RT.Materials.Material'Class;

    type Hit_Record is record
        T          : F32;
        P          : Point3;
        Normal     : Vec3;
        Front_Face : Boolean;
        Mat        : Material_Access;
    end record;

    type Hitable is interface;

    function Hit
        (Table :        Hitable; R : Ray; T_Min : F32; T_Max : F32;
         Hit   : in out Hit_Record) return Boolean is abstract;


    type Hitable_Access is access Hitable'Class;
    type Hitable_Access_List is array (Positive range <>) of Hitable_Access;

    type Hitable_List (Num : Positive) is new Hitable with record
        Targets : Hitable_Access_List (1 .. Num);
    end record;


    overriding
    function Hit
        	(H : Hitable_List; R : Ray; T_Min : F32; T_Max : F32; Rec : in out Hit_Record) return Boolean;

    type Sphere is new Hitable with record
        Center : Point3;
        Radius : F32;
        Mat : Material_Access;
    end record;

    overriding
    function Hit
        	(S : Sphere; R : Ray; T_Min : F32; T_Max : F32; Rec : in out Hit_Record) return Boolean;

end RT.Hitables;
