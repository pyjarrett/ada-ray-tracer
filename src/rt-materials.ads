limited with RT.Hitables;

with RT.Rays;
with RT.Vecs;

package RT.Materials is
    use RT.Rays;
    use RT.Vecs;

    type Material is interface;

    function Scatter (Mat : Material; R : Ray; Rec : RT.Hitables.Hit_Record; Attenuation : in out Vec3; Scattered : in out Ray) return Boolean is abstract;

    type Lambertian is new Material with record
        Albedo : Vec3;
    end record;

    overriding
    function Scatter (Mat : Lambertian; R : Ray; Rec : RT.Hitables.Hit_Record; Attenuation : in out Vec3; Scattered : in out Ray) return Boolean;

    type Metal is new Material with Record
        Albedo : Vec3;
        Fuzz : F32 := 1.0;
    end record;

    overriding
    function Scatter (Mat : Metal; R : Ray; Rec : RT.Hitables.Hit_Record; Attenuation : in out Vec3; Scattered : in out Ray) return Boolean;

    type Dielectric is new Material with record
        Ref_Index : F32 := 1.0;
    end record;

    overriding
    function Scatter (Mat : Dielectric; R : Ray; Rec : RT.Hitables.Hit_Record; Attenuation : in out Vec3; Scattered : in out Ray) return Boolean;

    function Schlick (Cosine, Ref_Index : F32) return F32;

end RT.Materials;
