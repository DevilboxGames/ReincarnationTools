fn ToxicRagersMatrix3DToMaxMatrix3 mat = (
	matrix3 [mat.M11, mat.M12, mat.M13] [mat.M21, mat.M22, mat.M23] [mat.M31, mat.M32, mat.M33] [mat.M41, mat.M42, mat.M43]
)
fn ToxicRagersVector3ToMaxPoint3 v3 = (
	[v3.x, v3.y, v3.z]
)
fn ToxicRagersColourToMaxColor col = (
	color (col.r * 255) (col.g * 255) (col.b * 255) (col.a * 255)
)

fn MaxMatrix3ToToxicRagersMatrix3D mat = (
	dotNetObject "ToxicRages.Helpers.Matrix3D" mat.row1.X mat.row1.Y mat.row1.Z mat.row2.X mat.row2.Y mat.row2.Z mat.row3.X mat.row3.Y mat.row3.Z mat.row4.X mat.row4.Y mat.row4.Z
	
)
fn MaxPoint3ToToxicRagersVector3 v3 = (
	dotNetObject "ToxicRages.Helpers.Vector3" v3.x v3.y v3.z
)
fn MaxColorToToxicRagersColour col = (
	dotNetObject "ToxicRages.Helpers.Colour" (col.r / 255) (col.g / 255) (col.b / 255) (col.a / 255)
)