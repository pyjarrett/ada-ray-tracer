limited with RT.Materials;
with RT.Rays;
with RT.Vecs;

with Ada.Containers.Vectors;
with GNATCOLL.Refcount;

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

    procedure Set_Face_Normal (Rec : in out Hit_Record; R : Ray; Outward_Normal : Vec3);

    type Hitable is interface;

    function Hit
        (Table :        Hitable; R : Ray; T_Min : F32; T_Max : F32;
         Hit   : in out Hit_Record) return Boolean is abstract;

    type Sphere is new Hitable with record
        Center : Point3;
        Radius : F32;
        Mat : Material_Access;
    end record;

    overriding
    function Hit
        	(S : Sphere; R : Ray; T_Min : F32; T_Max : F32; Rec : in out Hit_Record) return Boolean;


    package Pointers is new GNATCOLL.Refcount.Shared_Pointers (Element_Type => Hitable'Class);
    package Hitable_Lists is new Ada.Containers.Vectors (Index_Type => Positive,
                                                         Element_Type => Pointers.Ref,
                                                         "=" => Pointers."=");
    type Hitable_List is new Hitable with private;

    procedure Clear (H : in out Hitable_List);
    procedure Add (H : in out Hitable_List; Obj : in Hitable'Class);
    -- Ada lacks something analogous to perfect forwarding from C++, in
    -- addition to missing arg packs and variadic arguments.  This keeps the
    -- interface somewhat similar in intent.

    overriding
    function Hit
        	(H : Hitable_List; R : Ray; T_Min : F32; T_Max : F32; Rec : in out Hit_Record) return Boolean;

private

    type Hitable_List is new Hitable with record
        Targets : Hitable_Lists.Vector;
    end record;

end RT.Hitables;
