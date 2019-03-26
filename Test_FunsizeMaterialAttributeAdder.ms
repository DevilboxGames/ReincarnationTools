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
fn AddMatCAToSelectedMat deleteCA:false = (
	
		if(deleteCA) then (
			DeleteMatCAOnSelectedMat()
		)
	mats =SMEGetSelMats()
	for mat in mats do (
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
	)
)