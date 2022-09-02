fn ToxicRagersMatrix3DToMaxMatrix3 mat = (
	matrix3 [mat.M11, mat.M12, mat.M13] [mat.M21, mat.M22, mat.M23] [mat.M31, mat.M32, mat.M33] [mat.M41, mat.M42, mat.M43]
)
fn ToxicRagersVector3ToMaxPoint3 v3 = (
	[v3.x, v3.y, v3.z]
)
fn ToxicRagersColourToMaxColor col = (
	color (col.r * 255) (col.g * 255) (col.b * 255) (col.a * 255)
)