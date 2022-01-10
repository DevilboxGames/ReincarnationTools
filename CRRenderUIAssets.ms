
fn RenderHUDDamage file outputsize:[240,480] = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,9] rotation:(EulerAngles 0 0 180)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -25 35 0) castshadows:true
	lit.pos = [-45,-45,45]
	--ground = plane width:1000 length:1000 material:(MatteShadow())

	sceneStateMgr.Capture "PreHUDDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do obj.material = InkNPaint intersect_bias:10 min_ink_width:4.0  max_ink_width:4.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32)

	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreHUDDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreHUDDamageGeneration"
	delete cam
	delete lit

	--delete ground
)
fn RenderHUDDamageMobile file outputsize:[240,480] carroot: = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	if carroot == unsupplied then (
		carroot = $carbody
	)
	for obj in selection do (selectmore obj.children )
	carSize  = distance $.min $.max

	
	t = InvLerp 6.57049 11.0073 carSize
	camPos = Lerp [0,-0.4,5] [0,-0.4,9.52786] t --[0,-0.4,5]
	cam = Freecamera pos:camPos rotation:(EulerAngles 0 0 180)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -0 0 0) castshadows:false
	lit.pos = [-0,-0,45]
	--ground = plane width:1000 length:1000 material:(MatteShadow())

	sceneStateMgr.Capture "PreHUDDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do obj.material = InkNPaint intersect_bias:10 min_ink_width:2.0  max_ink_width:2.0 self_overlap_ink_on:true self_underlap_ink_on:false smgroup_edge_ink_on:true matid_ink_on:true paint_color:(color 32 32 32) ink_color:(color 14 14 14)

	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreHUDDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreHUDDamageGeneration"
	delete cam
	delete lit

	--delete ground
)
fn RenderHUDOutline file outputsize:[240,480] = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,9] rotation:(EulerAngles 0 0 180)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -25 35 0) castshadows:true
	lit.pos = [-45,-45,45]
	--ground = plane width:1000 length:1000 material:(MatteShadow())

	sceneStateMgr.Capture "PreHUDDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:false color1:(color 255 255 255)

	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreHUDDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreHUDDamageGeneration"
	delete cam
	delete lit

	--delete ground
)
fn RenderTopView file outputsize:[720,360] = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,17] rotation:(EulerAngles 0 0 -90)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -25 35 0) castshadows:true raytracedShadows:true
	lit.shadowGenerator = Adv__Ray_Traced()
	lit.pos = [-45,-45,45]
	ground = plane width:1000 length:1000 material:(MatteShadow())
	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	delete cam
	delete lit
	delete ground
)
fn RenderTopViewMobile file outputsize:[720,360] carRoot: = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	if carroot == unsupplied then (
		carroot = $carbody
	)
	for obj in selection do (selectmore obj.children )
	carSize  = distance $.min $.max

	
	t = InvLerp 6.57049 11.0073 carSize
	camPos = Lerp [0,-0.4,13] [0,-0.4,17.9006] t --[0,-0.4,5]

	cam = Freecamera pos:[0,0,13] rotation:(EulerAngles 0 0 -90)
	lit = Directionallight pos:[0,0,0] rotation:(EulerAngles 25 25 0) castshadows:true raytracedShadows:true
	lit.shadowGenerator = Adv__Ray_Traced()
	lit.pos = [-50,50,50]
	lit.shadow_density = 0.25
	ground = plane width:1000 length:1000 material:(MatteShadow())
	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	delete cam
	delete lit
	delete ground
)
fn RenderThreeQuarterView file outputsize:[240,240] selfIllum:100.0 closeUp:false carRoot: light1Value:180 light2Value:180 light1Multiplier:1.0 light2Multiplier:0.25= (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	if carroot == unsupplied then (
		carroot = $carbody
	)
	select carRoot

	for obj in selection do (selectmore obj.children )
	for obj in selection where (superClassOf obj) != GeometryClass do ( deselect obj)
	carSize  = distance $.min $.max

	if closeUp then (

		t = InvLerp 13.8565	18.0733 carSize
	
		cam = Freecamera()
		cam.rotation = (quat 0.538985 0.196175 0.280167 0.769751)
		cam.pos = Lerp  [3.99924,-5.2245,3.08177] [6.02309,-7.63649,4.22792] t 

	)
	else (

		t = InvLerp 6.57049 11.0073 carSize
	
		cam = Freecamera()
		cam.rotation = (quat 0.538985 0.196175 0.280167 0.769751)
		cam.pos = Lerp [6.19895,-7.84599,4.3273] [10.0652,-12.4536,6.51653] t --[6.19895,-7.84599,4.3273]
	)
	lit = Directionallight pos:[0,0,0] rotation:(EulerAngles 25 5 0) castshadows:true raytracedShadows:true value:light1Value multiplier:light1Multiplier
	lit.shadowGenerator = Adv__Ray_Traced()
	lit.pos = [-10,50,50]
	lit.shadow_density = 0.25
	lit2 = Omnilight pos:[3.2,-5,5] multiplier:light2Multiplier value:light2Value
	ground = plane width:1000 length:1000 material:(MatteShadow())

	sceneStateMgr.Capture "Pre34ViewGeneration" #{1..10}
	
	for obj in objects where (classof obj) == editable_mesh do (
		if classof obj.mat == multimaterial then (
			for i =1 to obj.material.material.count do (
				diffusebmp = obj.material.material[i].diffusemap
				obj.material.material[i].selfillumination = selfIllum
			)
		)
		else if classof obj.mat == standardmaterial then (
			diffusebmp = obj.material.diffusemap
			obj.material.selfillumination = selfIllum
		)
	)
	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	sceneStateMgr.Restore "Pre34ViewGeneration" #{1..10}
	sceneStateMgr.Delete "Pre34ViewGeneration"
	delete cam
	delete lit
	delete lit2
	delete ground
)
fn RenderMiniMap file outputsize:[180,90] = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,17] rotation:(EulerAngles 0 0 -90)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -45 45 0) castshadows:true
	lit.pos = [-45,-45,45]
	
	sceneStateMgr.Capture "PreMinimapDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do (
		oldmat =obj.material
		if (classof oldmat) == Multimaterial then (
			for submat in obj.material do (
				obj.material.materiallist[finditem obj.material.materiallist submat] = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:submat.diffuseMap paint_map_on:true
			)
		)
		else (
			diffuseMap = undefined
			if oldmat != undefined then diffuseMap = oldmat.diffuseMap
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:diffuseMap paint_map_on:true
		)
	)
	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreMinimapDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreMinimapDamageGeneration"
	delete cam
	delete lit

)
fn RenderSideView file outputsize:[180,90] = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera() 
 	cam.rotation = (EulerAngles -90 90 0)
	cam.pos = [-17,0,1]
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -45 45 0) castshadows:true
	lit.pos = [-45,-45,45]
	
	sceneStateMgr.Capture "PreSideviewDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do (
		oldmat =obj.material
		if (classof oldmat) == Multimaterial then (
			for submat in obj.material do (
				obj.material.materiallist[finditem obj.material.materiallist submat] = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:submat.diffuseMap paint_map_on:true
			)
		)
		else (
			diffuseMap = undefined
			if oldmat != undefined then diffuseMap = oldmat.diffuseMap
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:diffuseMap paint_map_on:true
		)
	)
	render camera:cam outputsize:outputsize outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreSideviewDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreSideviewDamageGeneration"
	
	delete cam
	delete lit

)

fn RenderUIAssets carname skinname outputfolder = (
	makedir outputfolder
	RenderHUDDamage (outputfolder+"hud_damage_backing.png")
	RenderHUDOutline (outputfolder+"hud_damage_outline.png")
	RenderTopView (outputfolder+carname+"_"+skinname+"_top.png")
	RenderMiniMap (outputfolder+carname+"_"+skinname+"_minimap.png")
	RenderSideView (outputfolder+carname+"_"+skinname+"_side.png")

	ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
	ConvertTDX.Convert (outputfolder+"hud_damage_backing.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+"hud_damage_outline.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+carname+"_"+skinname+"_top.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+carname+"_"+skinname+"_side.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+carname+"_"+skinname+"_minimap.png") outputFolder 5
)

fn RenderMobileUIAssets carname datafolder = (

	RenderHUDDamageMobile (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_HIGH\\DAMAGE\\"+carname+".png") outputsize:[128,256]
	RenderTopViewMobile (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H480\\GRID\\"+carname+".png") outputsize:[200,100]
	RenderTopViewMobile (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H600\\GRID\\"+carname+".png") outputsize:[250,125]
	RenderTopViewMobile (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H720\\GRID\\"+carname+".png") outputsize:[300,150]
	RenderThreeQuarterView (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_LOW\\THUMBS\\"+carname+".png") outputsize:[160,160]
	RenderThreeQuarterView (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_HIGH\\THUMBS\\"+carname+".png") outputsize:[240,240]

	ConvertIMG = dotnetclass "IMGToolLib.IMGTool"
	
	ConvertIMG.ConvertToIMG #(datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_HIGH\\DAMAGE\\"+carname+".png") (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_HIGH\\DAMAGE\\") null
	ConvertIMG.ConvertToIMG #(datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_HIGH\\THUMBS\\"+carname+".png") (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_HIGH\\THUMBs\\") null
	ConvertIMG.ConvertToIMG #(datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_LOW\\THUMBS\\"+carname+".png") (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\PPI_LOW\\THUMBs\\") null
	ConvertIMG.ConvertToIMG #(datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H480\\GRID\\"+carname+".png") (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H480\\GRID\\") null
	ConvertIMG.ConvertToIMG #(datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H600\\GRID\\"+carname+".png") (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H600\\GRID\\") null
	ConvertIMG.ConvertToIMG #(datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H720\\GRID\\"+carname+".png") (datafolder+"DATA\\CONTENT\\UI\\ASSETS\\H720\\GRID\\") null

)
