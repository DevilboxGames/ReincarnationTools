fn SwapTextures OldTex NewTex = (
	for mat in scenematerials where (classof mat) == Standard and (tolower mat.diffusemap.filename) == (tolower oldTex) do mat.diffusemap.filename = newTex
)

fn DisableDoubleSided = (
	for obj in selection do (
		if classof obj.material == Standard then (
			obj.material.twosided = false
		)
		else if classof obj.material == Multisubmaterial then (
			for mat in obj.material.material do (
				mat.twosided =false
			)
		)
	)
)