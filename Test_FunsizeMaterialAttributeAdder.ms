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

fn AddMatCAToSelectedMat = (
	mats =SMEGetSelMats()
	for mat in mats do (
		custattributes.add mat mtlmat_ca
	)
)