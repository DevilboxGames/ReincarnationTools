fn cleanImportedC1Level =
(
	
	objList = for obj in objects where classof obj == Dummy collect obj
	format "%\n" objList
	for obj in objList do
	(
		delete obj
	)
	
	targetObj = undefined
	objList = #()
	objList = for obj in objects where (substring obj.name 1 1) != "&" collect obj
	format "%\n" objList
	for obj in objList where classof obj != Dummy do
	(
		if targetObj == undefined then targetObj = obj
		else attach targetObj obj
	)
)
fn cleanCarmatName matname =
(
	
			matname = substituteString matname "!" "_"
			matname = substituteString matname "#" "_"
			matname = substituteString matname "\\" "_"
			matname = substituteString matname "&" "_"
			matname = substituteString matname ".MAT" ""
			matname = substituteString matname ".mat" ""
	return matname
)
fn cleanCarmaTextureNames filename=
(
	filenameOnly = filenamefrompath filename
	pathtofile = getFilenamePath filename
	if (findstring filenameonly "&") != undefined then
	(
		newFilename = substitutestring filenameonly "&" "_and_"
		copyfile filename (pathtofile + newfilename)
		return pathtofile + newfilename
	)
	else return filename
)
fn cleanImportedCarmaterials =
(
	for obj in geometry do
	(
		if classof obj.mat == Standardmaterial then
		(
			obj.mat.name = cleanCarmatName obj.mat.name
			if obj.mat.diffusemap != undefined and obj.mat.diffusemap.filename != undefined then
			(
				fullpath = mapPaths.getFullFilePath obj.mat.diffusemap.filename
				if fullpath != "" then
				(
					obj.mat.diffusemap.filename = fullpath
					obj.mat.diffusemap.filename = cleanCarmaTextureNames fullpath
				)
			) 
		)
		else if classof obj.mat == multimaterial then
		for mat in obj.mat do
		(
			mat.name = cleanCarmatName mat.name
			if mat.diffusemap != undefined and mat.diffusemap.filename != undefined then
			(
				fullpath = mapPaths.getFullFilePath mat.diffusemap.filename
				if fullpath != "" then
				(
					mat.diffusemap.filename = fullpath
					mat.diffusemap.filename = cleanCarmaTextureNames fullpath
				)
			) 
		)
	)
)

fn RemoveOpacityMaps = (
	for obj in objects do (
		if (classof  obj.material) == multimaterial then (
			for mat in obj.material.materiallist do (
				format "%\n" mat.name
				mat.opacitymap = undefined
			)
		)
		else  (
				format "%\n" obj.material.name
			obj.material.opacitymap = undefined
		)
	)
)

cleanImportedC1Level()
cleanImportedCarmaterials()
RemoveOpacityMaps()