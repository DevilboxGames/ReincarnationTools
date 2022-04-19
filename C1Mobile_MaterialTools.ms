function SMEGetSelMats = (    
	viewNode = sme.GetView (sme.activeView)
	smeSelMats = #()
	for n = 1 to trackViewNodes[#sme][(sme.activeView)].numSubs do (
		m = trackViewNodes[#sme][(sme.activeView)][n].reference
		b = viewNode.GetNodeByRef m
		if b.selected do append smeSelMats m
	)
	return smeSelMats
)

fn ApplyMatCA obj = (
	if(classof obj.material) == multimaterial then (
		
	)
)

fn DeleteMatCAOnSelectedMat = (
	
	mats =SMEGetSelMats()
	for mat in mats do (
		if mat_ca != undefined then custattributes.delete mat mat_ca
		custattributes.delete mat mtlmat_ca
		
	)
)
fn MatIsMTL Mat = (
	(isProperty mat "mat_flags") and (isProperty mat "mat_ambient") == false
)
fn MatIsC1MAT Mat = (
	(isProperty mat "mat_ambient")
)


fn AddMTLtoMat mat = (
	if (MatIsMTL mat) == false then (
		if MatIsC1MAT mat then (
			custattributes.delete mat mat_ca
		)
	custattributes.add mat mtlmat_ca
		
		for i =  mat.mtlmat_data.layer_name.count to 1 by -1 do (
			deleteItem mat.mtlmat_data.layer_name i
			deleteItem mat.mtlmat_data.layer_blend_mode i
			deleteItem mat.mtlmat_data.layer_alpha_opacity i
			deleteItem mat.mtlmat_data.layer_specialfx i
			deleteItem mat.mtlmat_data.layer_flipbook_fps i
			deleteItem mat.mtlmat_data.layer_scrollspeed_u i
			deleteItem mat.mtlmat_data.layer_scrollspeed_v i
			deleteItem mat.mtlmat_data.layer_mappingmode_u i
			deleteItem mat.mtlmat_data.layer_mappingmode_v i
			deleteItem mat.mtlmat_data.layer_uv_slot i
			deleteItem mat.mtlmat_data.layer_numframes_u i
			deleteItem mat.mtlmat_data.layer_numframes_v i
			deleteItem mat.mtlmat_data.layer_layerflags i
		)
		mtl = MTLFile()
		if mat != undefined and mat.diffuseMap != undefined and (classof mat.diffuseMap) == bitmaptexture then
		(
			bitmapFileName = mat.diffuseMap.filename
			mtl.Layers[1].mapname = getFilenameFile bitmapFileName
		)
		mtl.AmbientRed = mat.diffuse.r / 255
		mtl.AmbientGreen = mat.diffuse.g / 255
		mtl.AmbientRed = mat.diffuse.b / 255
		mtl.EmissiveRed = mat.ambient.r / 255
		mtl.EmissiveGreen = mat.ambient.g / 255
		mtl.EmissiveRed = mat.ambient.b / 255
		mtl.SpecularRed = mat.Specular.r / 255
		mtl.SpecularGreen = mat.Specular.g / 255
		mtl.SpecularRed = mat.Specular.b / 255
		mtl.SpecularPower = mat.SpecularLevel / 255
		
		mtl.ApplyToMaterial mat
	)
)
fn AddMatCAToSelectedMat deleteCA:false = (
	
		if(deleteCA) then (
			DeleteMatCAOnSelectedMat()
		)
	mats =SMEGetSelMats()
	for mat in mats do (
		AddMTLtoMat mat
	)
)

fn LoadAndApplyMTL mtl_file =  (

	mat = (SMEGetSelMats())[1]
	mtl = MTLFile()
	mtl.Load mtl_file
	mtl.ApplyToMaterial mat
)

fn GetAndSaveMTL mtl_file mat = (

	mat = mat
	mtl = MTLFile()
	mtl.GetFromMaterial mat
	mtl.Save mtl_file
)

fn GetAndSaveyMTL mtl_file = (

	GetAndSaveMTL mtl_file (SMEGetSelMats())[1]

)

fn TestMTLShit = (
	LoadAndApplyMTL "E:\Backups\CarmAndroid\WADs\Data_Android\DATA\CONTENT\TRACKS\LEVELS\CITY_A\0ROAD.MTL"
)

fn ApplyMTLToAllMatsInScene OnlyWithDiffuse:false OnlyProperlyNamed:false	= (
	numMats = 0
	format "Addimg CA to % mats \n" sceneMaterials.count
	for mat in sceneMaterials do (
		if classof mat == multimaterial then (
			for submat in mat.materiallist do (
				if submat != undefined then (
					if (OnlyWithDiffuse == false or submat.diffusemap != undefined) and (OnlyProperlyNamed == false or (matchPattern submat.name pattern:"material*#*") == false) then (
						numMats = numMats + 1
						AddMTLtoMat submat
					)
					if (mod numMats 20 )== 0 then (
						format "Done % mats\n" numMats
						if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
					)
				)
			)
		)
		else if classof mat == Standardmaterial then (
			if (OnlyWithDiffuse == false or mat.diffusemap != undefined)  and (OnlyWithProperName == false or (matchPattern mat.name pattern:"material*#*") == false) then (
				numMats = numMats + 1
				AddMTLtoMat mat
			)
		)
		if (mod numMats 20 )== 0 then (
			format "Done % mats\n" numMats
			if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		)
	)
	Format "Added MTL attribute to % mats \n" nummats
)

fn RemoveTrisWithDummyMaterials obj = (
	matids = #()
	if ClassOf obj.mat == multimaterial then (
		for i = 1 to obj.mat.materiallist.count do (
			if (custAttributes.get obj.mat.materiallist[i] mat_ca) == undefined then
			(
				append matids i
			)
		)
	)
	else (
		if (custAttributes.get obj.material mtlmat_ca) == undefined then
		(
			append matids 1
		)
	)

	format "found % mats to remove: %\n" matids.count matids
	if matids.count > 0 then (
		numfaces = getNumFaces obj
		for i = numfaces to 1 by -1 do (
			matid = getFaceMatID obj i 
			if (finditem matids matid) != 0 then (
				deleteface obj i
			)
		)
	)
	update obj
)