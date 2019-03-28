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
		custattributes.delete mat mtlmat_ca
		
	)
)
fn AddMTLtoMat mat = (
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
			mtl.Layers[1].mapname = bitmapFileName
		)
		
		mtl.ApplyToMaterial mat
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
fn GetAndSaveyMTL mtl_file = (

	mat = (SMEGetSelMats())[1]
	mtl = MTLFile()
	mtl.GetFromMaterial mat
	mtl.Save mtl_file
)

fn TestMTLShit = (
	LoadAndApplyMTL "C:\Dev\Carma\Funsize\WADs\Data_Android\DATA\CONTENT\VEHICLES\ANNIECAR\ANNIECAR.MTL"
)

fn ApplyMTLToAllMatsInScene = (
	numMats = 0
	for mat in sceneMaterials do (
		if classof mat == multimaterial then (
			for submat in mat.materiallist do (
				numMats = numMats + 1
				AddMTLtoMat submat
			)
		)
		else (
			numMats = numMats + 1
			AddMTLtoMat mat
		)
		
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
	)
	Format "Added MTL attribute to % mats \n" nummats
)