if ImportCNT==undefined then 
(
	fn ImportCNT = ()
)

fn IsObjectAJoint obj =
(
	(classof obj) == CarmaHelper_JointHelper
)

polymesh = mesh

plugin simpleObject CarmaHelper_JointHelper
	Name: "Joint"
	classID: #(0x6d1e792f, 0x4883ec71)
	category: "Carmageddon: Reincarnation"
	version:1
(
	local lastMinLimit, lastMaxLimit, lastMinLimit2, lastMaxLimit2, lastMinTwist, lastMaxTwist, lastJointType, lastLimit1Start, lastLimit2Start, lastTwistStart, meshObj, thisNode
	
	parameters jointParamBlock rollout:jointParams
	(
		NodeStorage type:#maxObject
		JointType type:#integer animatable:false default:1 ui:rad_JointType
		JointType_Hinge type:#boolean animatable:false default:true
		JointType_Ball type:#boolean animatable:false default:false
		JointType_UJ type:#boolean animatable:false default:false
		JointType_Slide type:#boolean animatable:false default:false
		
		AxisIsSet type:#boolean default:false
		JointAxis type:#point3 animatable:false default:[1,0,0]
		JointNormal type:#point3 animtable:false default:[0,0,1]
		
		Weakness type:#float animatable:false ui:spn_Weakness
		
		UseLimit type:#boolean default:false ui:chk_UseLimit
		MinLimit type:#float animatable:false ui:spn_MinLimit
		MaxLimit type:#float animatable:false ui:spn_MaxLimit
		UseLimit2 type:#boolean default:false ui:chk_UseLimit2
		MinLimit2 type:#float animatable:false ui:spn_MinLimit2
		MaxLimit2 type:#float animatable:false ui:spn_MaxLimit2
		UseTwist type:#boolean default:false ui:chk_UseTwist
		MinTwist type:#float animatable:false ui:spn_MinTwist
		MaxTwist type:#float animatable:false ui:spn_MaxTwist
		FlapSprings type:#point3Tab tabSizeVariable:true
		UseLocation type:#boolean ui:chk_UseLocation
		UseNormal type:#boolean ui:chk_UseNormal
	)
	parameters visualSettingsBlock rollout:jointVisualSettings
	(
		Limit1Start type:#float animatable:false ui:spn_Limit1Start
		Limit2Start type:#float animatable:false ui:spn_Limit2Start
		TwistStart type:#float animatable:false ui:spn_TwistStart
	)
	rollout jointParams "Joint"
	(
		radiobuttons rad_JointType "Joint Type" columns:2 labels:#("Hinge", "Ball","UJ","Slide") 
		 
		spinner spn_Weakness "Weakness" fieldwidth:40 range:[-100000,100000,0]
		checkbox chk_UseLimit "Limit"
		spinner spn_MinLimit "" fieldwidth:40 across:2 range:[-360,360,0]
		spinner spn_MaxLimit "" fieldwidth:40 across:2 range:[-360,360,15]
		
		checkbox chk_UseLimit2 "Limit 2"
		spinner spn_MinLimit2 "" fieldwidth:40 across:2 range:[-360,360,0]
		spinner spn_MaxLimit2 "" fieldwidth:40 across:2 range:[-360,360,15]
		
		checkbox chk_UseTwist "Twist"
		spinner spn_MinTwist "" fieldwidth:40 across:2 range:[-360,360,0]
		spinner spn_MaxTwist "" fieldwidth:40 across:2 range:[-360,360,15]
		
		checkbox chk_UseLocation "Use Location"
		checkbox chk_UseNormal "Use Joint Normal"
		
		group "Flap Springs"
		(
			spinner spn_FlapSpring1 "" type:#worldunits range:[-10000, 10000, 0] across:3 fieldwidth:30
			spinner spn_FlapSpring2 "" type:#worldunits range:[-10000, 10000, 0] across:3 fieldwidth:30
			button but_AddFlapSpring "Add" across:3
			dotnetcontrol lv_FlapSprings "listview" height: 100
			button but_DelFlapSpring "Delete"
		)
		
		on jointParams open do
		(
			
			lv_FlapSprings.view  = (dotnetclass "view").details
			lv_FlapSprings.fullrowselect= true
			lv_FlapSprings.gridlines = true
			lv_FlapSprings.multiselect =false
			lv_FlapSprings.columns.add "Spring 1" 55
			lv_FlapSprings.columns.add "Spring 2" 55
			for i=1 to FlapSprings.count do
			(
				lvItem = dotnetobject "listviewitem" (FlapSprings[i].x as string)
				lvitem.subitems.add (FlapSprings[i].y as string)
				lv_FlapSprings.Items.add lvitem
			)
		)
		
		on but_DelFlapSpring pressed do
		(
			if lv_FlapSprings.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_FlapSprings.SelectedIndices.Item[0]
				lv_FlapSprings.Items.removeat selectedIndex
				deleteItem FlapSprings (selectedIndex+1)
			)
		)
		on but_AddFlapSpring pressed do
		(
						
				lvItem = dotnetobject "listviewitem" (spn_FlapSpring1.value as string)
				lvitem.subitems.add (spn_FlapSpring2.value as string)
				lv_FlapSprings.Items.add lvitem
				append FlapSprings [spn_FlapSpring1.value, spn_FlapSpring2.value, 0]
			
		)
		on rad_JointType changed index do
		(
			JointType_Hinge = false
			JointType_Ball = false
			JointType_UJ =false
			JointType_Slide =false
			case index of
			(
				1: JointType_Hinge=true
				2: JointType_Ball=true
				3: JointType_UJ=true
				4: JointType_Slide=true
			)
			
			--format "JointType: %\nHinge: %\n Ball: %\n Slide: %\n" JointType JointType_Hinge JointType_Ball JointType_UJ JointType_Slide
		)
		on chk_UseTwist changed state do
		(
			if state then
			(
				spn_MinTwist.enabled=true
				spn_MaxTwist.enabled=true
			)
			else
			(
				spn_MinTwist.enabled=false
				spn_MaxTwist.enabled=false
			)
		)
		/*on chk_UseLimit changed state do
		(
			if state then
			(
				spn_MinLimit.enabled=true
				spn_MaxLimit.enabled=true
			)
			else
			(
				spn_MinLimit.enabled=false
				spn_MaxLimit.enabled=false
			)
		)*/
		on chk_UseLimit2 changed state do
		(
			if state then
			(
				spn_MinLimit2.enabled=true
				spn_MaxLimit2.enabled=true
			)
			else
			(
				spn_MinLimit2.enabled=false
				spn_MaxLimit2.enabled=false
			)
		)
	)
	rollout jointVisualSettings "Visualisation Settings"
	(
		
		spinner spn_Limit1Start "Limit 1 Start Position" fieldwidth:40 range:[-360,360,0] labelOnTop:true
		spinner spn_Limit2Start "Limit 2 Start Position" fieldwidth:40 range:[-360,360,0] labelOnTop:true
		spinner spn_TwistStart "Twist Start Position" fieldwidth:40 range:[-360,360,0] labelOnTop:true
	)
	on postload do
	(
		thisNode = NodeStorage.node
	)
	on load do
	(
		thisNode = NodeStorage.node
	)
	on attachedToNode nodeVar do
	(
		
		thisNode = nodeVar
		NodeStorage =  nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
	)
	on buildmesh do
	(
		if meshObj == undefined or lastJointType != jointType or lastMinTwist != minTwist or lastMaxTwist != maxTwist or lastMinLimit != minLimit or lastMaxLimit != maxLimit or lastMinLimit2 != minLimit2 or lastMaxLimit2 != maxLimit2 or lastLimit1Start != Limit1Start or lastLimit2Start != Limit2Start or lastTwistStart != TwistStart then
		(
			verts =#(
				[0,0,0],
				[0.5,0,0],
				[0,0,0.25]
			)
			faces = #(
				[1, 2, 3]
			)
				vertCount=3
			faceVis = #(#(true,false, true))
			if JointType_Slide then
			(
				if maxLimit != minLimit then
				(
					if minLimit > maxLimit then
					(
						tmp = maxLimit
						thismaxLimit = minLimit
						thisminLimit = tmp
					)
					else
					(
						thismaxlimit= maxlimit
						thisminlimit =minlimit
					)
					midPoint = (thisMaxLimit+thisMinLimit)*0.5
					if thisMaxLimit - ((thisMaxLimit+thisMinLimit)*0.5) > 0.75 then midPoint = thisMaxLimit - 0.75
					v1 = [-thisMinLimit, 0.25,0.0]
					v2 = [-thisMinLimit, -0.25,0.0]
					v3 = [-midpoint, 0.25,0.0]
					v4 = [-midpoint, -0.25,0.0]
					v5 = [-thisMaxLimit, 0,0.0]
					v6 = [-midpoint, -0.75,0.0]
					v7 = [-midpoint, 0.75,0.0]
					append verts v1
					append verts v2
					append verts v3
					append verts v4
					append verts v5
					append verts v6
					append verts v7
					
					append faces [vertCount+1,vertCount+3,vertCount+2]
					append faces [vertCount+2,vertCount+3,vertCount+4]
					append faces [vertCount+5,vertCount+6,vertCount+4]
					append faces [vertCount+5,vertCount+3,vertCount+7]
					append faces [vertCount+5,vertCount+4,vertCount+3]
					
					append faceVis #(true, false, true)
					append faceVis #(false, false, true)
					append faceVis #(true, true, false)
					append faceVis #(false, true, true)
					append faceVis #(false, false, false)
						vertCount += 4
				)
			)
			else if JointType_Hinge or JointType_UJ or JointType_Ball then
			(
				if maxLimit != minLimit then
				(
					if minLimit > maxLimit then
					(
						tmp = maxLimit
						thismaxLimit = minLimit
						thisminLimit = tmp
					)
					else
					(
						thismaxlimit= maxlimit
						thisminlimit =minlimit
					)
					steps = (thismaxLimit - thisminLimit)/512
					width = steps/2
					radius1=0.75
					radius2=0.45
					radiusSteps = ((radius1 - radius2) * 0.5)/512
					heightSteps = ((thismaxLimit - thisminLimit)/360)*0.0001
					height=0
					for a = thisminLimit + Limit1Start to thismaxLimit + Limit1Start by steps do
					(
						v1 = [height, radius1*cos(a+width),radius1*sin(a+width)]
						v2 = [height+heightSteps, radius1*cos(a-width),radius1*sin(a-width)]
						v3 = [height, radius2*cos(a+width),radius2*sin(a+width)]
						v4 = [height+heightSteps, radius2*cos(a-width),radius2*sin(a-width)]
						
						radius1 -= radiusSteps
						radius2 += radiusSteps
						append verts v1
						append verts v2
						append verts v3
						append verts v4

						height += heightSteps
						append faces [vertCount+1,vertCount+3,vertCount+2]
						append faces [vertCount+2,vertCount+3,vertCount+4]
						if a== thisminLimit then 
						(
							append faceVis #(true, false, true)
							append faceVis #(true, true, false)
						)
						else if a+ steps >= thismaxLimit then 
						(
							append faceVis #(false, true, true)
							append faceVis #(false, true, true)
						)
						else
						(
							append faceVis #(false, false, true)
							append faceVis #(false, true, false)
						)
						vertCount += 4
					)
				)
			)
			if JointType_UJ or JointType_Ball then
			(
				if maxLimit2 != minLimit2 then
				(
					if minLimit2 > maxLimit2 then
					(
						tmp = maxLimit2
						thismaxLimit2 = minLimit2
						thisminLimit2 = tmp
					)
					else
					(
						thismaxlimit2= maxlimit2
						thisminlimit2 =minlimit2
					)
					steps = (thismaxlimit2 - thisminlimit2)/512
					width = steps/2
					radius1=0.75
					radius2=0.45
					radiusSteps = ((radius1 - radius2) * 0.5)/512
					heightSteps = ((thismaxlimit2 - thisminlimit2)/360)*0.0001
					height=0.0
					sideways = 0
					for a = thisminlimit2 + Limit2Start to thismaxlimit2 + Limit2Start by steps do
					(
						v1 = [ radius1*cos(a+width)+sideways,height,radius1*sin(a+width)]
						v2 = [radius1*cos(a-width)+sideways,height+heightSteps, radius1*sin(a-width)]
						v3 = [radius2*cos(a+width)+sideways,height,radius2*sin(a+width)]
						v4 = [radius2*cos(a-width)+sideways,height+heightSteps, radius2*sin(a-width)]
						radius1 -= radiusSteps
						radius2 += radiusSteps
						append verts v1
						append verts v2
						append verts v3
						append verts v4

						height += heightSteps
						append faces [vertCount+1,vertCount+3,vertCount+2]
						append faces [vertCount+2,vertCount+3,vertCount+4]
						if a== thisminlimit2 then 
						(
							append faceVis #(true, false, true)
							append faceVis #(true, true, false)
						)
						else if a+ steps >= thismaxlimit2 then 
						(
							append faceVis #(false, true, true)
							append faceVis #(false, true, true)
						)
						else
						(
							append faceVis #(false, false, true)
							append faceVis #(false, true, false)
						)
						vertCount += 4
					)
				)
			)
			if JointType_Ball then
			(
				if maxTwist != minTwist then
				(
					if minTwist > maxTwist then
					(
						tmp = maxTwist
						thismaxTwist = minTwist
						thisminTwist = tmp
					)
					else
					(
						thismaxTwist= maxTwist
						thisminTwist =minTwist
					)
					steps = (thismaxTwist - thisminTwist)/512
					width = steps/2
					radius1=0.75
					radius2=0.45
					radiusSteps = ((radius1 - radius2) * 0.5)/512
					heightSteps = ((thismaxTwist - thisminTwist)/360)*0.0001
					height=0.0
					sideways = 0
					for a = thisminTwist + TwistStart to thismaxTwist + TwistStart by steps do
					(
						v1 = [-radius1*cos(a+width)+sideways,radius1*sin(a+width),height]
						v2 = [-radius1*cos(a-width)+sideways, radius1*sin(a-width),height+heightSteps]
						v3 = [-radius2*cos(a+width)+sideways,radius2*sin(a+width),height]
						v4 = [-radius2*cos(a-width)+sideways, radius2*sin(a-width),height+heightSteps]
						append verts v1
						append verts v2
						append verts v3
						append verts v4

						radius1 -= radiusSteps
						radius2 += radiusSteps
						height += heightSteps
						append faces [vertCount+1,vertCount+3,vertCount+2]
						append faces [vertCount+2,vertCount+3,vertCount+4]
						if a== thisminTwist then 
						(
							append faceVis #(true, false, true)
							append faceVis #(true, true, false)
						)
						else if a+ steps >= thismaxTwist then 
						(
							append faceVis #(false, true, true)
							append faceVis #(false, true, true)
						)
						else
						(
							append faceVis #(false, false, true)
							append faceVis #(false, true, false)
						)
						vertCount += 4
					)
				)
			)
			tmpmeshObj = polymesh vertices:verts faces:faces
			for i = 1 to faceVis.count do
			(
				setEdgeVis tmpmeshObj i 1 faceVis[i][1]
				setEdgeVis tmpmeshObj i 2 faceVis[i][2]
				setEdgeVis tmpmeshObj i 3 faceVis[i][3]
			)
			 lastJointType = jointType
			lastMinTwist = minTwist
			lastMaxTwist = maxTwist
			lastMinLimit = minLimit
			lastMaxLimit = maxLimit 
			lastMinLimit2 = minLimit2
			lastMaxLimit2 = maxLimit2
			lastLimit1Start = Limit1Start 
			lastLimit2Start = Limit2Start 
			lastTwistStart = TwistStart 
			meshObj = copy tmpMeshObj.mesh
			delete tmpmeshobj
			
			trans = thisNode.transform
			transRow1 = JointAxis
			--format "transRow1 = %\n" transRow1
			if UseNormal then
			(
				transRow2 = cross  JointNormal JointAxis
				--format "transRow2 = %\n" transRow2
				transRow3 = JointNormal
				--format "transRow3 = %\n" transRow3
			)
			else
			(
				if JointAxis == [0,0,-1] then
				(
					--format "Axis is facing down\n"
					transRow2 = cross  [1,0,0] JointAxis
				--format "transRow3 = %\n" transRow3
					transRow3 = cross  JointAxis transRow2
				--format "transRow2 = %\n" transRow2
					transRow2 = cross JointAxis transRow3
				--format "transRow3 = %\n" transRow3
				)
				else if JointAxis == [0,0,1] then
				(
					--format "Axis is facing up\n"
					transRow2 = cross  [-1,0,0] JointAxis
				--format "transRow3 = %\n" transRow3
					transRow3 = cross transRow2 JointAxis
				--format "transRow2 = %\n" transRow2
					transRow2 = cross JointAxis transRow3
				--format "transRow3 = %\n" transRow3
				)
				else
				(
					--format "Axis is not facing backwards\n"
					transRow2 = cross JointAxis [0,0,-1]
				--format "transRow3 = %\n" transRow3
					transRow3 = cross   JointAxis transRow2
				--format "transRow2 = %\n" transRow2
					transRow2 = cross JointAxis transRow3
				--format "transRow3 = %\n" transRow3
				)
				trans.row2 = transRow2
				trans.row3 = transRow3
			)
			thisNode.transform = matrix3 transRow1 transRow2 transRow3 trans.row4
			
		)
		setmesh mesh meshObj
	)
	
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: 
				(
					coordsys grid (nodeTM.translation = gridPoint)
				)
				2: #stop
			)
		)
		on mouseMove click do
		(
			case click of
			(
				2: #stop
			)
		)
	)
)

format "CREATING CarmaHelper_WheelPlaceholder!!!!\n\n"
CarmaHelper_WheelType = #("Wheel_FR","Wheel_FL","Wheel_RR","Wheel_RL")
plugin simpleObject CarmaHelper_WheelPlaceholder
	Name:"Wheel"
	classID:#(0x4892a691, 0x7b9572bb)
	category:"Carmageddon: Reincarnation"
	version:2
(
	local usingMesh, actualMeshObj, actualMeshMat, placeholderMeshObj, lastWheelName, lastWheelFilename, thisNode, oldWheelFileName
	
	parameters wheelParamBlock rollout:wheelParams
	(
		NodeStorage type:#maxObject
		wheelType type:#string animatable:false default:CarmaHelper_WheelType[1]
		wheelTypeID type:#integer animatable:false default:1
		wheelFileName type:#string animatable:false ui:txt_wheelFileName
		wheelName type:#string animatable:false ui:txt_wheelName
		previewWheel type:#boolean animatable:false ui:chk_PreviewWheel
	)
	
		fn combineWheelMeshes obj doDelete:false =
		(
			outMesh = undefined
			if IsObjectACNT obj and obj.modifiers["CNT Hierarchy"].NodeType=="MODL" then
			(
				outMesh = copy obj
				convertTo outMesh Editable_Poly
			)
			for child in obj.children do
			(
				childMesh = combineWheelMeshes child
				
				if outMesh == undefined then 
				(
					outMesh = childmesh
				)
				else if childmesh !=undefined and childmesh.modifiers != undefined and IsObjectACNT childmesh and childmesh.modifiers["CNT Hierarchy"].NodeType=="MODL" then
				(
					/*oldMeshNumVerts = getNumVerts outMesh
					numVerts = getNumVerts childMesh
					numFaces = getNumFaces childMesh
					setNumVerts outMesh (oldMeshNumVerts+numVerts)
					for i = 1 to numVerts do
					(
						setVert outMesh (oldMeshNumVerts+i) (getVert childMesh i)
					)*/
					polyop.attach outMesh childMesh
				)
			)
			delete obj
			outMesh
		)
	fn loadWheelMesh cnt_name =
	(
		--format "======================\nLoading wheelmesh %\n==================\n" cnt_name
		rimMesh = ImportCNT cnt_name importTextures:true forcePREP:true useTriStrips:false
		tyreMesh = ImportCNT ((getFilenamePath cnt_name)+"Tyre.cnt") importTextures:true forcePREP:true useTriStrips:false
		append rimMesh.children tyreMesh
		combinedMesh = combineWheelMeshes rimMesh
		actualMeshObj = copy combinedMesh.mesh
		actualMeshMat =combinedMesh.material
		delete combinedMesh
		oldWheelFileName = cnt_name
		wheelFileName = cnt_name
		splitPath = filterstring (getFileNamePath cnt_name) "/\\"
		wheelName = splitPath[splitPath.count]
	)
	rollout wheelParams "Wheel Parameters"
	(
		dropdownlist dpdn_wheelType "Wheel Type" items:CarmaHelper_WheelType selection:wheelTypeID
		edittext txt_wheelName "Wheel Name" labelOnTop:true
		edittext txt_wheelFileName "Wheel Folder" labelOnTop:true 
		button but_loadWheel "Load Wheel"
		checkbox chk_PreviewWheel "Preview Wheel"
		
		on dpdn_wheelType selected i do 
		(
			wheelTypeID = dpdn_wheelType.selection
			wheelType = dpdn_wheelType.items[i]
			thisNode.name = wheelType
		)
		on but_loadWheel pressed do
		(
			cnt_name = GetOpenFileName caption:"Open Rim.CNT File" types:"Rim.CNT(Rim.CNT)|rim.cnt"
			if cnt_name != undefined then
			(
				loadWheelMesh cnt_name
			)
		)
		on wheelParams open do
		(
		)
	)
	
	on postLoad do
	(
		thisNode = NodeStorage.node
		oldWheelFilename=""
		usingMesh = undefined
		placeholderMeshObj = undefined
		actualMeshObj = undefined
	)
	on load do (
		thisNode = NodeStorage.node
		oldWheelFilename=""
		usingMesh = undefined
		placeholderMeshObj = undefined
		actualMeshObj = undefined
	)
	on attachedToNode nodeVar do
	(
		thisNode = nodeVar
		NodeStorage = nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
	)
	on buildmesh  do
	(
		if placeholderMeshObj == undefined then
		(
			tmpmesh = polymesh vertices:#([-0.163197, 0.0, -0.316496],[-0.163197, 0.108248, -0.297409],[-0.163198, 0.20344, -0.24245],[-0.163198, 0.274093, -0.158248],[-0.163198, 0.311688, -0.0549589],[-0.163198, 0.311688, 0.0549589],[-0.163198, 0.274093, 0.158248],[-0.163198, 0.20344, 0.24245],[-0.163198, 0.108248, 0.297409],[-0.163198, 0.0, 0.316496],[-0.163198, -0.108248, 0.297409],[-0.163198, -0.20344, 0.24245],[-0.163198, -0.274093, 0.158248],[-0.163198, -0.311687, 0.054959],[-0.163198, -0.311688, -0.0549588],[-0.163198, -0.274093, -0.158248],[-0.163198, -0.20344, -0.24245],[-0.163198, -0.108248, -0.297409],[0.0, 0.122818, -0.33744],[0.0, 0.230822, -0.275083],[0.0, 0.310986, -0.179548],[0.0, 0.35364, -0.0623563],[0.0, 0.35364, 0.0623563],[0.0, 0.310986, 0.179548],[0.0, 0.230822, 0.275083],[0.0, 0.122818, 0.33744],[0.0, 0.0, 0.359096],[0.0, -0.122818, 0.33744],[0.0, -0.230822, 0.275083],[0.0, -0.310986, 0.179548],[0.0, -0.35364, 0.0623564],[0.0, -0.35364, -0.0623562],[0.0, -0.310986, -0.179548],[0.0, -0.230822, -0.275083],[0.0, -0.122818, -0.33744],[0.0, 0.0, -0.359096],[0.163197, 0.0, -0.316496],[0.163197, 0.108248, -0.297409],[0.163197, 0.20344, -0.24245],[0.163197, 0.274093, -0.158248],[0.163197, 0.311688, -0.0549589],[0.163197, 0.311688, 0.0549589],[0.163197, 0.274093, 0.158248],[0.163197, 0.20344, 0.24245],[0.163197, 0.108248, 0.297409],[0.163197, 0.0, 0.316496],[0.163197, -0.108248, 0.297409],[0.163197, -0.20344, 0.24245],[0.163197, -0.274093, 0.158248],[0.163197, -0.311687, 0.054959],[0.163197, -0.311688, -0.0549588],[0.163197, -0.274093, -0.158248],[0.163197, -0.20344, -0.24245],[0.163197, -0.108248, -0.297409],[0.163197, 0.0, -0.275879],[0.163197, 0.0943561, -0.259241],[0.163197, 0.177331, -0.211335],[0.163197, 0.238918, -0.137939],[0.163197, 0.271688, -0.0479058],[0.163197, 0.271688, 0.0479059],[0.163197, 0.238918, 0.137939],[0.163197, 0.177331, 0.211335],[0.163197, 0.0943561, 0.259241],[0.163197, 0.0, 0.275879],[0.163197, -0.094356, 0.259241],[0.163197, -0.177331, 0.211335],[0.163197, -0.238918, 0.137939],[0.163197, -0.271687, 0.0479059],[0.163197, -0.271688, -0.0479057],[0.163197, -0.238918, -0.137939],[0.163197, -0.177332, -0.211335],[0.163197, -0.0943563, -0.259241],[-0.0768025, 0.0, -0.275879],[-0.0768025, 0.0943561, -0.259241],[-0.0768026, 0.177331, -0.211335],[-0.0768026, 0.238918, -0.137939],[-0.0768026, 0.271688, -0.0479059],[-0.0768025, 0.271688, 0.0479058],[-0.0768026, 0.238918, 0.137939],[-0.0768026, 0.177331, 0.211335],[-0.0768026, 0.0943561, 0.259241],[-0.0768026, 0.0, 0.275879],[-0.0768025, -0.094356, 0.259241],[-0.0768026, -0.177331, 0.211335],[-0.0768026, -0.238918, 0.137939],[-0.0768025, -0.271687, 0.0479059],[-0.0768025, -0.271688, -0.0479057],[-0.0768026, -0.238918, -0.137939],[-0.0768026, -0.177332, -0.211335],[-0.0768025, -0.0943563, -0.259241]) faces:#([1.0, 2.0, 19.0],[19.0, 36.0, 1.0],[2.0, 3.0, 20.0],[20.0, 19.0, 2.0],[3.0, 4.0, 21.0],[21.0, 20.0, 3.0],[4.0, 5.0, 22.0],[22.0, 21.0, 4.0],[5.0, 6.0, 23.0],[23.0, 22.0, 5.0],[6.0, 7.0, 24.0],[24.0, 23.0, 6.0],[7.0, 8.0, 25.0],[25.0, 24.0, 7.0],[8.0, 9.0, 26.0],[26.0, 25.0, 8.0],[9.0, 10.0, 27.0],[27.0, 26.0, 9.0],[10.0, 11.0, 28.0],[28.0, 27.0, 10.0],[11.0, 12.0, 29.0],[29.0, 28.0, 11.0],[12.0, 13.0, 30.0],[30.0, 29.0, 12.0],[13.0, 14.0, 31.0],[31.0, 30.0, 13.0],[14.0, 15.0, 32.0],[32.0, 31.0, 14.0],[15.0, 16.0, 33.0],[33.0, 32.0, 15.0],[16.0, 17.0, 34.0],[34.0, 33.0, 16.0],[17.0, 18.0, 35.0],[35.0, 34.0, 17.0],[18.0, 1.0, 36.0],[36.0, 35.0, 18.0],[36.0, 19.0, 38.0],[38.0, 37.0, 36.0],[19.0, 20.0, 39.0],[39.0, 38.0, 19.0],[20.0, 21.0, 40.0],[40.0, 39.0, 20.0],[21.0, 22.0, 41.0],[41.0, 40.0, 21.0],[22.0, 23.0, 42.0],[42.0, 41.0, 22.0],[23.0, 24.0, 43.0],[43.0, 42.0, 23.0],[24.0, 25.0, 44.0],[44.0, 43.0, 24.0],[25.0, 26.0, 45.0],[45.0, 44.0, 25.0],[26.0, 27.0, 46.0],[46.0, 45.0, 26.0],[27.0, 28.0, 47.0],[47.0, 46.0, 27.0],[28.0, 29.0, 48.0],[48.0, 47.0, 28.0],[29.0, 30.0, 49.0],[49.0, 48.0, 29.0],[30.0, 31.0, 50.0],[50.0, 49.0, 30.0],[31.0, 32.0, 51.0],[51.0, 50.0, 31.0],[32.0, 33.0, 52.0],[52.0, 51.0, 32.0],[33.0, 34.0, 53.0],[53.0, 52.0, 33.0],[34.0, 35.0, 54.0],[54.0, 53.0, 34.0],[35.0, 36.0, 37.0],[37.0, 54.0, 35.0],[17.0, 16.0, 15.0],[15.0, 14.0, 13.0],[13.0, 12.0, 11.0],[15.0, 13.0, 11.0],[11.0, 10.0, 9.0],[9.0, 8.0, 7.0],[11.0, 9.0, 7.0],[7.0, 6.0, 5.0],[5.0, 4.0, 3.0],[7.0, 5.0, 3.0],[11.0, 7.0, 3.0],[15.0, 11.0, 3.0],[3.0, 2.0, 1.0],[15.0, 3.0, 1.0],[17.0, 15.0, 1.0],[18.0, 17.0, 1.0],[74.0, 75.0, 76.0],[76.0, 77.0, 78.0],[78.0, 79.0, 80.0],[76.0, 78.0, 80.0],[80.0, 81.0, 82.0],[82.0, 83.0, 84.0],[80.0, 82.0, 84.0],[84.0, 85.0, 86.0],[86.0, 87.0, 88.0],[84.0, 86.0, 88.0],[80.0, 84.0, 88.0],[76.0, 80.0, 88.0],[88.0, 89.0, 90.0],[76.0, 88.0, 90.0],[74.0, 76.0, 90.0],[73.0, 74.0, 90.0],[37.0, 38.0, 56.0],[56.0, 55.0, 37.0],[38.0, 39.0, 57.0],[57.0, 56.0, 38.0],[39.0, 40.0, 58.0],[58.0, 57.0, 39.0],[40.0, 41.0, 59.0],[59.0, 58.0, 40.0],[41.0, 42.0, 60.0],[60.0, 59.0, 41.0],[42.0, 43.0, 61.0],[61.0, 60.0, 42.0],[43.0, 44.0, 62.0],[62.0, 61.0, 43.0],[44.0, 45.0, 63.0],[63.0, 62.0, 44.0],[45.0, 46.0, 64.0],[64.0, 63.0, 45.0],[46.0, 47.0, 65.0],[65.0, 64.0, 46.0],[47.0, 48.0, 66.0],[66.0, 65.0, 47.0],[48.0, 49.0, 67.0],[67.0, 66.0, 48.0],[49.0, 50.0, 68.0],[68.0, 67.0, 49.0],[50.0, 51.0, 69.0],[69.0, 68.0, 50.0],[51.0, 52.0, 70.0],[70.0, 69.0, 51.0],[52.0, 53.0, 71.0],[71.0, 70.0, 52.0],[53.0, 54.0, 72.0],[72.0, 71.0, 53.0],[54.0, 37.0, 55.0],[55.0, 72.0, 54.0],[55.0, 56.0, 74.0],[74.0, 73.0, 55.0],[56.0, 57.0, 75.0],[75.0, 74.0, 56.0],[57.0, 58.0, 76.0],[76.0, 75.0, 57.0],[58.0, 59.0, 77.0],[77.0, 76.0, 58.0],[59.0, 60.0, 78.0],[78.0, 77.0, 59.0],[60.0, 61.0, 79.0],[79.0, 78.0, 60.0],[61.0, 62.0, 80.0],[80.0, 79.0, 61.0],[62.0, 63.0, 81.0],[81.0, 80.0, 62.0],[63.0, 64.0, 82.0],[82.0, 81.0, 63.0],[64.0, 65.0, 83.0],[83.0, 82.0, 64.0],[65.0, 66.0, 84.0],[84.0, 83.0, 65.0],[66.0, 67.0, 85.0],[85.0, 84.0, 66.0],[67.0, 68.0, 86.0],[86.0, 85.0, 67.0],[68.0, 69.0, 87.0],[87.0, 86.0, 68.0],[69.0, 70.0, 88.0],[88.0, 87.0, 69.0],[70.0, 71.0, 89.0],[89.0, 88.0, 70.0],[71.0, 72.0, 90.0],[90.0, 89.0, 71.0],[72.0, 55.0, 73.0],[73.0, 90.0, 72.0])
			
			 placeholderMeshObj = copy tmpmesh.mesh
			delete tmpmesh
			--placeholderMeshObj.name = wheelType
			for i=1 to (GetNumFaces placeholderMeshObj) do
			(
				setFaceSmoothGroup placeholderMeshObj i 1
			)
		)
		
			if oldWheelFilename != wheelFileName and wheelFileName!= "" then
			(
				loadWheelMesh wheelFileName
			)
		if this.previewWheel and actualMeshObj!=undefined then
		(
			thisNode.material = actualMeshMat
			setmesh mesh actualMeshObj
			usingMesh = actualMeshObj
			--format "Using Preview Wheel with % verts\n" (getNumVerts actualMeshObj)
			--format "Usingmesh with % verts\n" (getNumVerts usingMesh)
		)
		else 
		(
			thisNode.material=undefined
			--setmesh mesh placeholderMeshObj
			usingMesh = placeholderMeshObj
			--format "Using Placeholder Wheel with % verts\n" (getNumVerts placeholderMeshObj)
			--format "Usingmesh with % verts\n" (getNumVerts usingMesh)
		)
		setmesh mesh usingMesh
		--setMesh  -- mesh vertices:#([-0.163197, 0.0, -0.316496],[-0.163197, 0.108248, -0.297409],[-0.163198, 0.20344, -0.24245],[-0.163198, 0.274093, -0.158248],[-0.163198, 0.311688, -0.0549589],[-0.163198, 0.311688, 0.0549589],[-0.163198, 0.274093, 0.158248],[-0.163198, 0.20344, 0.24245],[-0.163198, 0.108248, 0.297409],[-0.163198, 0.0, 0.316496],[-0.163198, -0.108248, 0.297409],[-0.163198, -0.20344, 0.24245],[-0.163198, -0.274093, 0.158248],[-0.163198, -0.311687, 0.054959],[-0.163198, -0.311688, -0.0549588],[-0.163198, -0.274093, -0.158248],[-0.163198, -0.20344, -0.24245],[-0.163198, -0.108248, -0.297409],[0.0, 0.122818, -0.33744],[0.0, 0.230822, -0.275083],[0.0, 0.310986, -0.179548],[0.0, 0.35364, -0.0623563],[0.0, 0.35364, 0.0623563],[0.0, 0.310986, 0.179548],[0.0, 0.230822, 0.275083],[0.0, 0.122818, 0.33744],[0.0, 0.0, 0.359096],[0.0, -0.122818, 0.33744],[0.0, -0.230822, 0.275083],[0.0, -0.310986, 0.179548],[0.0, -0.35364, 0.0623564],[0.0, -0.35364, -0.0623562],[0.0, -0.310986, -0.179548],[0.0, -0.230822, -0.275083],[0.0, -0.122818, -0.33744],[0.0, 0.0, -0.359096],[0.163197, 0.0, -0.316496],[0.163197, 0.108248, -0.297409],[0.163197, 0.20344, -0.24245],[0.163197, 0.274093, -0.158248],[0.163197, 0.311688, -0.0549589],[0.163197, 0.311688, 0.0549589],[0.163197, 0.274093, 0.158248],[0.163197, 0.20344, 0.24245],[0.163197, 0.108248, 0.297409],[0.163197, 0.0, 0.316496],[0.163197, -0.108248, 0.297409],[0.163197, -0.20344, 0.24245],[0.163197, -0.274093, 0.158248],[0.163197, -0.311687, 0.054959],[0.163197, -0.311688, -0.0549588],[0.163197, -0.274093, -0.158248],[0.163197, -0.20344, -0.24245],[0.163197, -0.108248, -0.297409],[0.163197, 0.0, -0.275879],[0.163197, 0.0943561, -0.259241],[0.163197, 0.177331, -0.211335],[0.163197, 0.238918, -0.137939],[0.163197, 0.271688, -0.0479058],[0.163197, 0.271688, 0.0479059],[0.163197, 0.238918, 0.137939],[0.163197, 0.177331, 0.211335],[0.163197, 0.0943561, 0.259241],[0.163197, 0.0, 0.275879],[0.163197, -0.094356, 0.259241],[0.163197, -0.177331, 0.211335],[0.163197, -0.238918, 0.137939],[0.163197, -0.271687, 0.0479059],[0.163197, -0.271688, -0.0479057],[0.163197, -0.238918, -0.137939],[0.163197, -0.177332, -0.211335],[0.163197, -0.0943563, -0.259241],[-0.0768025, 0.0, -0.275879],[-0.0768025, 0.0943561, -0.259241],[-0.0768026, 0.177331, -0.211335],[-0.0768026, 0.238918, -0.137939],[-0.0768026, 0.271688, -0.0479059],[-0.0768025, 0.271688, 0.0479058],[-0.0768026, 0.238918, 0.137939],[-0.0768026, 0.177331, 0.211335],[-0.0768026, 0.0943561, 0.259241],[-0.0768026, 0.0, 0.275879],[-0.0768025, -0.094356, 0.259241],[-0.0768026, -0.177331, 0.211335],[-0.0768026, -0.238918, 0.137939],[-0.0768025, -0.271687, 0.0479059],[-0.0768025, -0.271688, -0.0479057],[-0.0768026, -0.238918, -0.137939],[-0.0768026, -0.177332, -0.211335],[-0.0768025, -0.0943563, -0.259241]) faces:#([1.0, 2.0, 19.0],[19.0, 36.0, 1.0],[2.0, 3.0, 20.0],[20.0, 19.0, 2.0],[3.0, 4.0, 21.0],[21.0, 20.0, 3.0],[4.0, 5.0, 22.0],[22.0, 21.0, 4.0],[5.0, 6.0, 23.0],[23.0, 22.0, 5.0],[6.0, 7.0, 24.0],[24.0, 23.0, 6.0],[7.0, 8.0, 25.0],[25.0, 24.0, 7.0],[8.0, 9.0, 26.0],[26.0, 25.0, 8.0],[9.0, 10.0, 27.0],[27.0, 26.0, 9.0],[10.0, 11.0, 28.0],[28.0, 27.0, 10.0],[11.0, 12.0, 29.0],[29.0, 28.0, 11.0],[12.0, 13.0, 30.0],[30.0, 29.0, 12.0],[13.0, 14.0, 31.0],[31.0, 30.0, 13.0],[14.0, 15.0, 32.0],[32.0, 31.0, 14.0],[15.0, 16.0, 33.0],[33.0, 32.0, 15.0],[16.0, 17.0, 34.0],[34.0, 33.0, 16.0],[17.0, 18.0, 35.0],[35.0, 34.0, 17.0],[18.0, 1.0, 36.0],[36.0, 35.0, 18.0],[36.0, 19.0, 38.0],[38.0, 37.0, 36.0],[19.0, 20.0, 39.0],[39.0, 38.0, 19.0],[20.0, 21.0, 40.0],[40.0, 39.0, 20.0],[21.0, 22.0, 41.0],[41.0, 40.0, 21.0],[22.0, 23.0, 42.0],[42.0, 41.0, 22.0],[23.0, 24.0, 43.0],[43.0, 42.0, 23.0],[24.0, 25.0, 44.0],[44.0, 43.0, 24.0],[25.0, 26.0, 45.0],[45.0, 44.0, 25.0],[26.0, 27.0, 46.0],[46.0, 45.0, 26.0],[27.0, 28.0, 47.0],[47.0, 46.0, 27.0],[28.0, 29.0, 48.0],[48.0, 47.0, 28.0],[29.0, 30.0, 49.0],[49.0, 48.0, 29.0],[30.0, 31.0, 50.0],[50.0, 49.0, 30.0],[31.0, 32.0, 51.0],[51.0, 50.0, 31.0],[32.0, 33.0, 52.0],[52.0, 51.0, 32.0],[33.0, 34.0, 53.0],[53.0, 52.0, 33.0],[34.0, 35.0, 54.0],[54.0, 53.0, 34.0],[35.0, 36.0, 37.0],[37.0, 54.0, 35.0],[17.0, 16.0, 15.0],[15.0, 14.0, 13.0],[13.0, 12.0, 11.0],[15.0, 13.0, 11.0],[11.0, 10.0, 9.0],[9.0, 8.0, 7.0],[11.0, 9.0, 7.0],[7.0, 6.0, 5.0],[5.0, 4.0, 3.0],[7.0, 5.0, 3.0],[11.0, 7.0, 3.0],[15.0, 11.0, 3.0],[3.0, 2.0, 1.0],[15.0, 3.0, 1.0],[17.0, 15.0, 1.0],[18.0, 17.0, 1.0],[74.0, 75.0, 76.0],[76.0, 77.0, 78.0],[78.0, 79.0, 80.0],[76.0, 78.0, 80.0],[80.0, 81.0, 82.0],[82.0, 83.0, 84.0],[80.0, 82.0, 84.0],[84.0, 85.0, 86.0],[86.0, 87.0, 88.0],[84.0, 86.0, 88.0],[80.0, 84.0, 88.0],[76.0, 80.0, 88.0],[88.0, 89.0, 90.0],[76.0, 88.0, 90.0],[74.0, 76.0, 90.0],[73.0, 74.0, 90.0],[37.0, 38.0, 56.0],[56.0, 55.0, 37.0],[38.0, 39.0, 57.0],[57.0, 56.0, 38.0],[39.0, 40.0, 58.0],[58.0, 57.0, 39.0],[40.0, 41.0, 59.0],[59.0, 58.0, 40.0],[41.0, 42.0, 60.0],[60.0, 59.0, 41.0],[42.0, 43.0, 61.0],[61.0, 60.0, 42.0],[43.0, 44.0, 62.0],[62.0, 61.0, 43.0],[44.0, 45.0, 63.0],[63.0, 62.0, 44.0],[45.0, 46.0, 64.0],[64.0, 63.0, 45.0],[46.0, 47.0, 65.0],[65.0, 64.0, 46.0],[47.0, 48.0, 66.0],[66.0, 65.0, 47.0],[48.0, 49.0, 67.0],[67.0, 66.0, 48.0],[49.0, 50.0, 68.0],[68.0, 67.0, 49.0],[50.0, 51.0, 69.0],[69.0, 68.0, 50.0],[51.0, 52.0, 70.0],[70.0, 69.0, 51.0],[52.0, 53.0, 71.0],[71.0, 70.0, 52.0],[53.0, 54.0, 72.0],[72.0, 71.0, 53.0],[54.0, 37.0, 55.0],[55.0, 72.0, 54.0],[55.0, 56.0, 74.0],[74.0, 73.0, 55.0],[56.0, 57.0, 75.0],[75.0, 74.0, 56.0],[57.0, 58.0, 76.0],[76.0, 75.0, 57.0],[58.0, 59.0, 77.0],[77.0, 76.0, 58.0],[59.0, 60.0, 78.0],[78.0, 77.0, 59.0],[60.0, 61.0, 79.0],[79.0, 78.0, 60.0],[61.0, 62.0, 80.0],[80.0, 79.0, 61.0],[62.0, 63.0, 81.0],[81.0, 80.0, 62.0],[63.0, 64.0, 82.0],[82.0, 81.0, 63.0],[64.0, 65.0, 83.0],[83.0, 82.0, 64.0],[65.0, 66.0, 84.0],[84.0, 83.0, 65.0],[66.0, 67.0, 85.0],[85.0, 84.0, 66.0],[67.0, 68.0, 86.0],[86.0, 85.0, 67.0],[68.0, 69.0, 87.0],[87.0, 86.0, 68.0],[69.0, 70.0, 88.0],[88.0, 87.0, 69.0],[70.0, 71.0, 89.0],[89.0, 88.0, 70.0],[71.0, 72.0, 90.0],[90.0, 89.0, 71.0],[72.0, 55.0, 73.0],[73.0, 90.0, 72.0])
	)
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: 
				(
					thisNode.name = wheelType
					coordsys grid (nodeTM.translation = gridPoint)
				)
				2: #stop
			)
		)
		on mouseMove click do
		(
			case click of
			(
				2: #stop
			)
		)
	)
)

struct AccessoryItemEntry (AccessoryMesh,	AccessoryMaterial)

struct AccessoryManager (
	ExistingAccessoryTypes = #(),
	ExistingAccessoryMeshes = #(),
	
	fn loadAccessoryMesh cnt_name =
	(
		accessoryMesh = ImportCNT cnt_name importTextures:true forcePREP:true useTriStrips:false mergeMDLs:true
		actualMeshObj = copy accessoryMesh.mesh
		
		actualMeshMat =accessoryMesh.material
		delete accessoryMesh
		
		entry = AccessoryItemEntry()
		entry.AccessoryMesh = actualMeshObj 
		entry.AccessoryMaterial = actualMeshMat
		entry
		
	),
	fn GetAccessory cnt_name =
	(
		splitPath = filterstring (getFileNamePath cnt_name) "/\\"
		accessoryType = splitPath[splitPath.count]
		result = undefined
		accessoryExists = finditem ExistingAccessoryTypes accessoryType
		if accessoryExists > 0 then
		(
			result = ExistingAccessoryMeshes[accessoryExists]
		)
		else
		(
			loadedMesh = loadAccessoryMesh cnt_name
			append ExistingAccessoryTypes accessoryType
			append ExistingAccessoryMeshes loadedMesh
			
			result = loadedMesh
		)
		result
	),
	fn ClearAccessories =
	(
		delete ExistingAccessoryTypes
		delete ExistingAccessoryMeshes
		ExistingAccessoryTypes = #()
		ExistingAccessoryMeshes = #()
	)
	
)

AccessoryMan = AccessoryManager()

plugin simpleObject CarmaHelper_AccessoryPlaceholder
	Name:"Level Accessory"
	classID:#(0x40f1d017, 0x25af9649)
	category:"Carmageddon: Reincarnation"
	version:1
(
	local usingMesh, actualMeshObj, actualMeshMat, placeholderMeshObj, lastAccessoryName, lastAccessoryFilename, thisNode, oldAccessoryFileName
	
	parameters accessoryParamBlock rollout:accessoryParams
	(
		NodeStorage type:#maxObject
		accessoryFileName type:#string animatable:false ui:txt_accessoryFileName
		accessoryType type:#string animatable:false ui:txt_accessoryType
		accessoryName type:#string animatable:false ui:txt_accessoryName
		accessoryID type:#string animatable:false ui:txt_accessoryID
		accessoryColour type:#color animatable:false ui:colpick_accessoryColour default:(color 255 255 255)
		isPowerup type:#boolean animatable:false ui:chk_isPowerup
	)
	
		
	fn loadAccessoryMesh cnt_name =
	(
		/*
		accessoryMesh = ImportCNT cnt_name importTextures:true forcePREP:false useTriStrips:false mergeMDLs:true
		actualMeshObj = copy accessoryMesh.mesh
		
		actualMeshMat =accessoryMesh.material
		delete accessoryMesh*/
		global AccessoryMan
		accessoryEntry = AccessoryMan.GetAccessory cnt_name
		actualMeshObj = accessoryEntry.AccessoryMesh
		actualMeshMat = accessoryEntry.AccessoryMaterial
		oldAccessoryFileName = cnt_name
		accessoryFileName = cnt_name
		splitPath = filterstring (getFileNamePath cnt_name) "/\\"
		accessoryType = splitPath[splitPath.count]
	)
	rollout accessoryParams "Accessory Parameters"
	(
		edittext txt_accessoryID "Accessory Unique ID" labelOnTop:true
		edittext txt_accessoryName "Accessory Name" labelOnTop:true
		edittext txt_accessoryType "Accessory Type" labelOnTop:true
		edittext txt_accessoryFileName "Accessory Folder" labelOnTop:true 
		colorpicker colpick_AccessoryColour "Accessory Colour"
		button but_loadAccessory "Load Accessory"
		checkbox chk_isPowerup "Is Powerup"
		
		on but_loadAccessory pressed do
		(
			cnt_name = GetOpenFileName caption:"Open accessory.CNT File" types:"accessory.CNT(accessory.CNT)|accessory.cnt"
			if cnt_name != undefined then
			(
				loadAccessoryMesh cnt_name
			)
		)
		on accessoryParams open do
		(
		)
	)
	
	on postLoad do
	(
		thisNode = NodeStorage.node
		oldAccessoryFilename=""
		usingMesh = undefined
		placeholderMeshObj = undefined
		actualMeshObj = undefined
	)
	on load do (
		thisNode = NodeStorage.node
		oldAccessoryFilename=""
		usingMesh = undefined
		placeholderMeshObj = undefined
		actualMeshObj = undefined
	)
	on attachedToNode nodeVar do
	(
		thisNode = nodeVar
		NodeStorage = nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
	)

	on buildmesh  do
	(
		if thisNode == undefined and NodeStorage != undefined and  NodeStorage.node != undefined then (
			thisNode = NodeStorage.node
		)
		if thisNode != undefined then (
			if placeholderMeshObj == undefined then
			(
				tmpmesh = polymesh vertices:#([-0.00750644, -0.292164, -0.0157009],[0.00750644, -0.292164, -0.0157009],[-0.0225933, -0.022668, -0.0224066],[0.0225186, -0.0225186, -0.0224066],[-0.00750644, -0.292164, -0.000688014],[0.00750644, -0.292164, -0.000688014],[-0.0225933, -0.022668, 0.0224065],[0.0225186, -0.0225186, 0.0224065],[0.292164, -0.00750644, -0.00750644],[0.292164, 0.00750644, -0.00750644],[0.292164, -0.00750644, 0.00750644],[0.292164, 0.00750644, 0.00750644],[-0.0225933, 0.0225933, -0.0224065],[-0.00750644, 0.00750644, 0.27705],[0.00750644, 0.00750644, 0.27705],[0.022668, 0.0225933, -0.0224065],[0.00750644, -0.00750645, 0.27705],[-0.00750644, -0.00750645, 0.27705],[0.022668, 0.0225933, 0.0224065],[-0.0225933, 0.0225933, 0.0224065]) faces:#([1.0, 3.0, 4.0],[4.0, 2.0, 1.0],[5.0, 6.0, 8.0],[8.0, 7.0, 5.0],[1.0, 2.0, 6.0],[6.0, 5.0, 1.0],[2.0, 4.0, 8.0],[8.0, 6.0, 2.0],[3.0, 1.0, 5.0],[5.0, 7.0, 3.0],[9.0, 4.0, 16.0],[16.0, 10.0, 9.0],[11.0, 12.0, 19.0],[19.0, 8.0, 11.0],[9.0, 10.0, 12.0],[12.0, 11.0, 9.0],[10.0, 16.0, 19.0],[19.0, 12.0, 10.0],[4.0, 9.0, 11.0],[11.0, 8.0, 4.0],[13.0, 19.0, 16.0],[13.0, 4.0, 3.0],[15.0, 14.0, 18.0],[18.0, 17.0, 15.0],[20.0, 7.0, 18.0],[18.0, 14.0, 20.0],[14.0, 15.0, 19.0],[19.0, 20.0, 14.0],[17.0, 18.0, 7.0],[7.0, 8.0, 17.0],[15.0, 17.0, 8.0],[8.0, 19.0, 15.0],[20.0, 13.0, 7.0],[13.0, 20.0, 19.0],[13.0, 16.0, 4.0],[13.0, 3.0, 7.0])
				
				 placeholderMeshObj = copy tmpmesh.mesh
				delete tmpmesh
				--placeholderMeshObj.name = wheelType
				for i=1 to (GetNumFaces placeholderMeshObj) do
				(
					setFaceSmoothGroup placeholderMeshObj i 1
				)
			)
			
				if oldAccessoryFilename != accessoryFileName and accessoryFileName!= "" then
				(
					loadAccessoryMesh accessoryFileName
				)
			if actualMeshObj!=undefined then
			(
				thisNode.material = actualMeshMat
				setmesh mesh actualMeshObj
				usingMesh = actualMeshObj
				--format "Using Preview Wheel with % verts\n" (getNumVerts actualMeshObj)
				--format "Usingmesh with % verts\n" (getNumVerts usingMesh)
			)
			else 
			(
				thisNode.material=undefined
				--setmesh mesh placeholderMeshObj
				usingMesh = placeholderMeshObj
				--format "Using Placeholder Wheel with % verts\n" (getNumVerts placeholderMeshObj)
				--format "Usingmesh with % verts\n" (getNumVerts usingMesh)
			)
			setmesh mesh usingMesh
			--setMesh  -- mesh vertices:#([-0.163197, 0.0, -0.316496],[-0.163197, 0.108248, -0.297409],[-0.163198, 0.20344, -0.24245],[-0.163198, 0.274093, -0.158248],[-0.163198, 0.311688, -0.0549589],[-0.163198, 0.311688, 0.0549589],[-0.163198, 0.274093, 0.158248],[-0.163198, 0.20344, 0.24245],[-0.163198, 0.108248, 0.297409],[-0.163198, 0.0, 0.316496],[-0.163198, -0.108248, 0.297409],[-0.163198, -0.20344, 0.24245],[-0.163198, -0.274093, 0.158248],[-0.163198, -0.311687, 0.054959],[-0.163198, -0.311688, -0.0549588],[-0.163198, -0.274093, -0.158248],[-0.163198, -0.20344, -0.24245],[-0.163198, -0.108248, -0.297409],[0.0, 0.122818, -0.33744],[0.0, 0.230822, -0.275083],[0.0, 0.310986, -0.179548],[0.0, 0.35364, -0.0623563],[0.0, 0.35364, 0.0623563],[0.0, 0.310986, 0.179548],[0.0, 0.230822, 0.275083],[0.0, 0.122818, 0.33744],[0.0, 0.0, 0.359096],[0.0, -0.122818, 0.33744],[0.0, -0.230822, 0.275083],[0.0, -0.310986, 0.179548],[0.0, -0.35364, 0.0623564],[0.0, -0.35364, -0.0623562],[0.0, -0.310986, -0.179548],[0.0, -0.230822, -0.275083],[0.0, -0.122818, -0.33744],[0.0, 0.0, -0.359096],[0.163197, 0.0, -0.316496],[0.163197, 0.108248, -0.297409],[0.163197, 0.20344, -0.24245],[0.163197, 0.274093, -0.158248],[0.163197, 0.311688, -0.0549589],[0.163197, 0.311688, 0.0549589],[0.163197, 0.274093, 0.158248],[0.163197, 0.20344, 0.24245],[0.163197, 0.108248, 0.297409],[0.163197, 0.0, 0.316496],[0.163197, -0.108248, 0.297409],[0.163197, -0.20344, 0.24245],[0.163197, -0.274093, 0.158248],[0.163197, -0.311687, 0.054959],[0.163197, -0.311688, -0.0549588],[0.163197, -0.274093, -0.158248],[0.163197, -0.20344, -0.24245],[0.163197, -0.108248, -0.297409],[0.163197, 0.0, -0.275879],[0.163197, 0.0943561, -0.259241],[0.163197, 0.177331, -0.211335],[0.163197, 0.238918, -0.137939],[0.163197, 0.271688, -0.0479058],[0.163197, 0.271688, 0.0479059],[0.163197, 0.238918, 0.137939],[0.163197, 0.177331, 0.211335],[0.163197, 0.0943561, 0.259241],[0.163197, 0.0, 0.275879],[0.163197, -0.094356, 0.259241],[0.163197, -0.177331, 0.211335],[0.163197, -0.238918, 0.137939],[0.163197, -0.271687, 0.0479059],[0.163197, -0.271688, -0.0479057],[0.163197, -0.238918, -0.137939],[0.163197, -0.177332, -0.211335],[0.163197, -0.0943563, -0.259241],[-0.0768025, 0.0, -0.275879],[-0.0768025, 0.0943561, -0.259241],[-0.0768026, 0.177331, -0.211335],[-0.0768026, 0.238918, -0.137939],[-0.0768026, 0.271688, -0.0479059],[-0.0768025, 0.271688, 0.0479058],[-0.0768026, 0.238918, 0.137939],[-0.0768026, 0.177331, 0.211335],[-0.0768026, 0.0943561, 0.259241],[-0.0768026, 0.0, 0.275879],[-0.0768025, -0.094356, 0.259241],[-0.0768026, -0.177331, 0.211335],[-0.0768026, -0.238918, 0.137939],[-0.0768025, -0.271687, 0.0479059],[-0.0768025, -0.271688, -0.0479057],[-0.0768026, -0.238918, -0.137939],[-0.0768026, -0.177332, -0.211335],[-0.0768025, -0.0943563, -0.259241]) faces:#([1.0, 2.0, 19.0],[19.0, 36.0, 1.0],[2.0, 3.0, 20.0],[20.0, 19.0, 2.0],[3.0, 4.0, 21.0],[21.0, 20.0, 3.0],[4.0, 5.0, 22.0],[22.0, 21.0, 4.0],[5.0, 6.0, 23.0],[23.0, 22.0, 5.0],[6.0, 7.0, 24.0],[24.0, 23.0, 6.0],[7.0, 8.0, 25.0],[25.0, 24.0, 7.0],[8.0, 9.0, 26.0],[26.0, 25.0, 8.0],[9.0, 10.0, 27.0],[27.0, 26.0, 9.0],[10.0, 11.0, 28.0],[28.0, 27.0, 10.0],[11.0, 12.0, 29.0],[29.0, 28.0, 11.0],[12.0, 13.0, 30.0],[30.0, 29.0, 12.0],[13.0, 14.0, 31.0],[31.0, 30.0, 13.0],[14.0, 15.0, 32.0],[32.0, 31.0, 14.0],[15.0, 16.0, 33.0],[33.0, 32.0, 15.0],[16.0, 17.0, 34.0],[34.0, 33.0, 16.0],[17.0, 18.0, 35.0],[35.0, 34.0, 17.0],[18.0, 1.0, 36.0],[36.0, 35.0, 18.0],[36.0, 19.0, 38.0],[38.0, 37.0, 36.0],[19.0, 20.0, 39.0],[39.0, 38.0, 19.0],[20.0, 21.0, 40.0],[40.0, 39.0, 20.0],[21.0, 22.0, 41.0],[41.0, 40.0, 21.0],[22.0, 23.0, 42.0],[42.0, 41.0, 22.0],[23.0, 24.0, 43.0],[43.0, 42.0, 23.0],[24.0, 25.0, 44.0],[44.0, 43.0, 24.0],[25.0, 26.0, 45.0],[45.0, 44.0, 25.0],[26.0, 27.0, 46.0],[46.0, 45.0, 26.0],[27.0, 28.0, 47.0],[47.0, 46.0, 27.0],[28.0, 29.0, 48.0],[48.0, 47.0, 28.0],[29.0, 30.0, 49.0],[49.0, 48.0, 29.0],[30.0, 31.0, 50.0],[50.0, 49.0, 30.0],[31.0, 32.0, 51.0],[51.0, 50.0, 31.0],[32.0, 33.0, 52.0],[52.0, 51.0, 32.0],[33.0, 34.0, 53.0],[53.0, 52.0, 33.0],[34.0, 35.0, 54.0],[54.0, 53.0, 34.0],[35.0, 36.0, 37.0],[37.0, 54.0, 35.0],[17.0, 16.0, 15.0],[15.0, 14.0, 13.0],[13.0, 12.0, 11.0],[15.0, 13.0, 11.0],[11.0, 10.0, 9.0],[9.0, 8.0, 7.0],[11.0, 9.0, 7.0],[7.0, 6.0, 5.0],[5.0, 4.0, 3.0],[7.0, 5.0, 3.0],[11.0, 7.0, 3.0],[15.0, 11.0, 3.0],[3.0, 2.0, 1.0],[15.0, 3.0, 1.0],[17.0, 15.0, 1.0],[18.0, 17.0, 1.0],[74.0, 75.0, 76.0],[76.0, 77.0, 78.0],[78.0, 79.0, 80.0],[76.0, 78.0, 80.0],[80.0, 81.0, 82.0],[82.0, 83.0, 84.0],[80.0, 82.0, 84.0],[84.0, 85.0, 86.0],[86.0, 87.0, 88.0],[84.0, 86.0, 88.0],[80.0, 84.0, 88.0],[76.0, 80.0, 88.0],[88.0, 89.0, 90.0],[76.0, 88.0, 90.0],[74.0, 76.0, 90.0],[73.0, 74.0, 90.0],[37.0, 38.0, 56.0],[56.0, 55.0, 37.0],[38.0, 39.0, 57.0],[57.0, 56.0, 38.0],[39.0, 40.0, 58.0],[58.0, 57.0, 39.0],[40.0, 41.0, 59.0],[59.0, 58.0, 40.0],[41.0, 42.0, 60.0],[60.0, 59.0, 41.0],[42.0, 43.0, 61.0],[61.0, 60.0, 42.0],[43.0, 44.0, 62.0],[62.0, 61.0, 43.0],[44.0, 45.0, 63.0],[63.0, 62.0, 44.0],[45.0, 46.0, 64.0],[64.0, 63.0, 45.0],[46.0, 47.0, 65.0],[65.0, 64.0, 46.0],[47.0, 48.0, 66.0],[66.0, 65.0, 47.0],[48.0, 49.0, 67.0],[67.0, 66.0, 48.0],[49.0, 50.0, 68.0],[68.0, 67.0, 49.0],[50.0, 51.0, 69.0],[69.0, 68.0, 50.0],[51.0, 52.0, 70.0],[70.0, 69.0, 51.0],[52.0, 53.0, 71.0],[71.0, 70.0, 52.0],[53.0, 54.0, 72.0],[72.0, 71.0, 53.0],[54.0, 37.0, 55.0],[55.0, 72.0, 54.0],[55.0, 56.0, 74.0],[74.0, 73.0, 55.0],[56.0, 57.0, 75.0],[75.0, 74.0, 56.0],[57.0, 58.0, 76.0],[76.0, 75.0, 57.0],[58.0, 59.0, 77.0],[77.0, 76.0, 58.0],[59.0, 60.0, 78.0],[78.0, 77.0, 59.0],[60.0, 61.0, 79.0],[79.0, 78.0, 60.0],[61.0, 62.0, 80.0],[80.0, 79.0, 61.0],[62.0, 63.0, 81.0],[81.0, 80.0, 62.0],[63.0, 64.0, 82.0],[82.0, 81.0, 63.0],[64.0, 65.0, 83.0],[83.0, 82.0, 64.0],[65.0, 66.0, 84.0],[84.0, 83.0, 65.0],[66.0, 67.0, 85.0],[85.0, 84.0, 66.0],[67.0, 68.0, 86.0],[86.0, 85.0, 67.0],[68.0, 69.0, 87.0],[87.0, 86.0, 68.0],[69.0, 70.0, 88.0],[88.0, 87.0, 69.0],[70.0, 71.0, 89.0],[89.0, 88.0, 70.0],[71.0, 72.0, 90.0],[90.0, 89.0, 71.0],[72.0, 55.0, 73.0],[73.0, 90.0, 72.0])
		)
	)
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: 
				(
					if accessoryType as string != "" then
					(
						thisNode.name = accessoryType as string
					)
					else thisNode.name = "Accessory"
					coordsys grid (nodeTM.translation = gridPoint)
				)
				2: #stop
			)
		)
		on mouseMove click do
		(
			case click of
			(
				2: #stop
			)
		)
	)
)

--struct AINode (Index, Type, Radius, Position, RaceLine, RaceLineOffset)
--struct AILink (Node1, Node2, Width, Type, OneWay, Interior, Loop)
LinkMatLibrary = undefined


struct LinkMatTextureDetails (
	OneWayTexture,
	MaskTex1,
	MaskTex2
)

UIIconPath = getFileNamePath (getThisScriptFilename())
LinkMatTextures = LinkMatTextureDetails OneWayTexture:(bitmaptexture hasAlpha:true filename:(UIIconPath+"UI/OneWayIcon.png")) MaskTex1:(bitmaptexture filename:(UIIconPath+"UI/LinkMask.png")) MaskTex2:(bitmaptexture filename:(UIIconPath+"UI/LinkMask2.png"))
fn CreateLinkMaterial name:"AILinkMat" isoneWay:false isWater:false isloop:false isinterior:false isTrack:false isShortcut:false = (
	mat = DXMaterial()
	mat.effectFile =UIIconPath+"Shaders\\AIPathShader.fx"
	mat.masktex1 =LinkMatTextures.MaskTex1.bitmap
	mat.masktex2 =LinkMatTextures.MaskTex2.bitmap
	mat.onewaytex =LinkMatTextures.OneWayTexture.bitmap
	mat.isoneway =isoneWay
	mat.iswater = isWater
	mat.isloop = isloop
	mat.isinterior = isinterior
	mat.isTrack = isTrack
	mat.isShortcut = isShortcut
	showTextureMap mat on

	mat
)

struct LinkMatLibraryDetails (
	linkMatNormal,
	linkMatWater,
	linkMatLoop,
	linkMatInterior,
	linkMatShortcut,
	linkMatTrack,

	linkMatOneWayNormal,
	linkMatOneWayWater,
	linkMatOneWayLoop,
	linkMatOneWayInterior,
	linkMatOneWayShortcut,
	linkMatOneWayTrack,

	linkMatWaterLoop,
	linkMatWaterInterior,
	linkMatWaterShortcut,
	linkMatWaterTrack,
	linkMatLoopInterior,
	linkMatLoopShortcut,
	linkMatLoopTrack,
	linkMatInteriorShortcut,
	linkMatInteriorTrack,
	linkMatWaterLoopInterior,
	linkMatWaterLoopShortcut,
	linkMatWaterLoopTrack,
	linkMatWaterInteriorShortcut,
	linkMatWaterInteriorTrack,
	linkMatLoopInteriorShortcut,
	linkMatLoopInteriorTrack,
	linkMatWaterLoopInteriorShortcut,
	linkMatWaterLoopInteriorTrack,

	linkMatOneWayWaterLoop,
	linkMatOneWayWaterInterior,
	linkMatOneWayWaterShortcut,
	linkMatOneWayWaterTrack,
	linkMatOneWayLoopInterior,
	linkMatOneWayLoopShortcut,
	linkMatOneWayLoopTrack,
	linkMatOneWayInteriorShortcut,
	linkMatOneWayInteriorTrack,
	linkMatOneWayWaterLoopInterior,
	linkMatOneWayWaterLoopShortcut,
	linkMatOneWayWaterLoopTrack,
	linkMatOneWayWaterInteriorShortcut,
	linkMatOneWayWaterInteriorTrack,
	linkMatOneWayLoopInteriorShortcut,
	linkMatOneWayLoopInteriorTrack,
	linkMatOneWayWaterLoopInteriorShortcut,
	linkMatOneWayWaterLoopInteriorTrack,
	fn GetMaterial isoneWay iswater isloop isinterior isshortcut istrack = (
		foundMat = undefined

			matString = "linkMat"
		if iswater == false and isloop == false and isinterior == false and isshortcut == false and istrack == false then (
			if isoneWay then (
				matString = matString + "OneWayNormal"
			)
			else (
				matString = matString + "Normal"
			)
		)
		else (
			if isoneWay then matString = matString + "OneWay"
			if iswater then matString = matString + "Water"
			if isloop then matString = matString + "Loop"
			if isinterior then matString = matString + "Interior"
			if istrack and isshortcut == false then matString = matString + "Track"
			if isshortcut then matString = matString + "Shortcut"
				--format "Finding property with matstring: %\n" matString
		
		)

		foundMat = getProperty LinkMatLibrary matString
		if foundMat == undefined then (
			
			foundMat = CreateLinkMaterial name:matString isoneWay:isoneWay isWater:isWater isloop:isloop isinterior:isinterior isTrack:isTrack isShortcut:isShortcut
			setProperty LinkMatLibrary matString foundMat
		)
		foundMat
	)
)

LinkMatLibrary =LinkMatLibraryDetails()
--sCreateLinkMaterials()
fn target_ainode_filter obj = ( (classof obj) == AINode)
fn target_ailink_filter obj = ( (classof obj) == AILink)
plugin SimpleObject AILink
	name:"Level AI Link"
	classID:#(0x726998ab, 0x6dfa99f9)
	category:"Carmageddon: Reincarnation"
(
	local lastWidth, lastNode1Radius, lastNode2Radius, lastNode1Pos, lastNode2Pos, lastOneWay, meshObj, thisNode, node1ChangeHandler, node2ChangeHandler, activeRace, updateMesh, updateMaterials, aiPathController
	
	
	parameters paramblock rollout:params
	(
		NodeStorage type:#maxObject
		Node1 type:#maxObject
		Node2 type:#maxObject
		Width type:#float default: 1 ui:spn_Width
		OneWay type:#boolean default:false ui:chk_OneWay
		Interior type:#boolean default:false ui:chk_Interior
		IsLoop type:#boolean default:false ui:chk_Loop
		LinkType type:#intTab tabSizeVariable:true
		Water type:#intTab tabSizeVariable: true
		ForceMeshUpdate type:#boolean default:false ui:chk_ForceUpdateMesh
		DisplayOffset type:#float default: 0.75 ui:spn_DisplayOffset
		EditingRoute type:#integer default:1 ui:spn_EditingRoute

		on OneWay set val do (
			UpdateMesh=true
			UpdateMaterials=true
		)
		on Interior set val do (
			UpdateMesh=true
			UpdateMaterials=true
		)

		on IsLoop set val do (
			UpdateMesh=true
			UpdateMaterials=true
		)

		on LinkType set val do (
			UpdateMesh=true
			UpdateMaterials=true
		)

		on Water set val do (
			UpdateMesh=true
			UpdateMaterials=true
		)

		on EditingRoute set val do (
			UpdateMesh=true
			UpdateMaterials=true
			activeRace = val
		)

		on DisplayOffset set val do (
			UpdateMesh=true
		)
		on Node1 set val do if val != undefined and val.node != undefined then
		(
			updateMesh = true
			--format "setting Node1 to %\n" val
			if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
			if Node2 != undefined do
			(
				local node1node = val.node
				local node2node = Node2.node
				local v = node2node.pos - node1node.pos
				local vLen = length v
				vLen -= node1node.Radius + node2node.Radius
				vLen = vLen / 2
				vLen += node1node.Radius
				local vNorm = normalize v
				--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" node1node.pos  node2node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + node1node.pos
				
			)
			node1ChangeHandler = when transform val.node changes do
			(
				ForceMeshUpdate=true
				UpdateMesh = true
				/*if Node2 != undefined and Node2.node != undefined do
				(
					local node1node = Node1.node
					local node2node = Node2.node
					local v = node2node.pos - node1node.pos
					local vLen = length v
					vLen -= node1node.Radius + node2node.Radius
					vLen = vLen / 2
					vLen += node1node.Radius
					local vNorm = normalize v
					--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" node1node.pos  node2node.pos v vLen vNorm
					thisNode.pos = vNorm * (vLen ) + node1node.pos
				)*/
			)
		)
		on Node2 set val do  if val != undefined and val.node != undefined then
		(
			--format "setting Node2 to %\n" val
			if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler

				UpdateMesh = true
			if Node1 != undefined and Node1.node != undefined do
			(
				local node1node = Node1.node
				local node2node = val.node
				local v = node2node.pos - node1node.pos
				local vLen = length v
				vLen -= node1node.Radius + node2node.Radius
				vLen = vLen / 2
				vLen += node1node.Radius
				local vNorm = normalize v
				--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" node1node.pos  node2node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + node1node.pos
			)
			node2ChangeHandler = when transform val.node changes do
			(
				ForceMeshUpdate = true

				UpdateMesh = true
				/*if Node1 != undefined do
				(
					local node1node = Node1.node
					local node2node = Node2.node
					local v = node2node.pos - node1node.pos
					local vLen = length v
					vLen -= node1node.Radius + node2node.Radius
					vLen = vLen / 2
					vLen += node1node.Radius
					local vNorm = normalize v
					--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" node1node.pos  node2node.pos v vLen vNorm
					thisNode.pos = vNorm * (vLen ) + node1node.pos
				)*/
			)
		)
	)
	rollout params "AI Link Parameters"
	(
		pickbutton pck_Node1 "Node 1" filter:target_ainode_filter autodisplay:true labelOnTop:true 
		pickbutton pck_Node2 "Node 2" filter:target_ainode_filter autodisplay:true labelOnTop:true 
		Spinner spn_Width "Width:" range:[0,1e9,1]
		Checkbox chk_OneWay "One Way:" default: false
		Checkbox chk_Loop "Loop:" default: false
		Checkbox chk_Interior "Interior:" default: false
		Checkbox chk_Water "Water:" default: false
		Checkbox chk_Race "Race Track:" default: false
		Checkbox chk_Shortcut "Race Shortcut:" default: false
		Checkbox chk_ForceUpdateMesh "Update Mesh" default: false
		Spinner spn_DisplayOffset "Display Offset:" range:[0,1,0.75]
		Spinner spn_EditingRoute "Editing Route:" type:#integer range:[1,100,1]
		
		on chk_Water changed val do (
			if val == true then (
				Water[editingRoute] = 1
			)
			else (
				Water[editingRoute] = 0
			)
		)
		on chk_Shortcut changed val do (
			if val == true then (
				LinkType[editingRoute] = 2
				chk_Race.checked =true
			)
			else if chk_Race.checked then (
				LinkType[editingRoute] = 1
			)
			else (
				LinkType[editingRoute] = 0
			)
		)
		on chk_Race changed val do (
			if val == true and chk_Shortcut.checked == false then (
				LinkType[editingRoute] = 1
			)
			else if chk_Shortcut.checked then (
				LinkType[editingRoute] = 2
			)
			else (
				LinkType[editingRoute] = 0
			)
		)
		on pck_Node1 picked obj do
		(
			--format "Picked Node1: %\n" obj
			Node1 = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			/*if Node2 != undefined do
			(
				v = Node2.node.pos - Node1.node.pos
				vLen = length v
				vLen -= Node1.node.Radius + Node2.node.Radius
				vLen = vLen / 2
				vLen += Node1.node.Radius
				vNorm = normalize v
				--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.node.pos  Node2.node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + Node1.node.pos
				thisNode
			)
			if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
			node1ChangeHandler = when transform Node1.node changes do
			(
				ForceMeshUpdate = true
			)*/
		)
		on pck_Node2 picked obj do
		(
			--format "Picked Node2: %\n" obj
			Node2 = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			/*if Node1 != undefined do
			(
				v = Node2.node.pos - Node1.node.pos
				vLen = length v
				vLen -= Node1.node.Radius + Node2.node.Radius
				vLen = vLen / 2
				vLen += Node1.node.Radius
				vNorm = normalize v
				--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.node.pos  Node2.node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + Node1.node.pos
			)
			if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler
			node2ChangeHandler = when transform Node2.node changes do
			(
				ForceMeshUpdate = true
			)*/
		)
		on params open do
		(

				UpdateMesh = true
			if Node1 != undefined then pck_Node1.object = Node1.node
			if Node2 != undefined then pck_Node2.object = Node2.node
		)
	)
	on deleted do (
		--if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
		--if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler
			
	)
	on detachedFromNode nodeVar do (
		if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
		if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler
			
	)
	on attachedToNode nodeVar do
	(
		
		thisNode = nodeVar
				UpdateMesh = true
		NodeStorage = nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
		if(Node2 != undefined and Node1 != undefined) do
		(
			if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
			if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler
			node1ChangeHandler = when transform Node1.node changes do
			(
				ForceMeshUpdate = true
				UpdateMesh = true
			)
			node2ChangeHandler = when transform Node2.node changes do
			(
				ForceMeshUpdate = true
				UpdateMesh = true
			)
		)
	)
	on load do (

		thisNode = NodeStorage.node
	)
	on postload do
	(
		thisNode = NodeStorage.node
		if Node2 != undefined and Node1 != undefined do
		(
				
				local node1node = Node1.node
				local node2node = Node2.node
				local v = node2node.pos - node1node.pos
				local vLen = length v
				vLen -= node1node.Radius + node2node.Radius
				vLen = vLen / 2
				vLen += node1node.Radius
				local vNorm = normalize v
				--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" node1node.pos  node2node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + node1node.pos
				if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
				if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler
				node1ChangeHandler = when transform Node1.node changes do
				(
					ForceMeshUpdate = true
				)
				node2ChangeHandler = when transform Node2.node changes do
				(
					ForceMeshUpdate = true
				)
		)
	)
	on postcreate do
	(
		
		if Node2 != undefined and Node1 != undefined do
		(
				
				local node1node = Node1.node
				local node2node = Node2.node
				local v = node2node.pos - node1node.pos
				local vLen = length v
				vLen -= node1node.Radius + node2node.Radius
				vLen = vLen / 2
				vLen += node1node.Radius
				local vNorm = normalize v
				--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" node1node.pos  node2node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + node1node.pos
				--if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
				if node1ChangeHandler != undefined then deleteChangeHandler node1ChangeHandler
				if node2ChangeHandler != undefined then deleteChangeHandler node2ChangeHandler
				node1ChangeHandler = when transform Node1.node changes do
				(
					ForceMeshUpdate = true
				)
				node2ChangeHandler = when transform Node2.node changes do
				(
					ForceMeshUpdate = true
				)
		)
	)
	
	on buildmesh do
	(
		if thisNode == undefined and NodeStorage != undefined and NodeStorage.node != undefined then (
			thisNode = NodeStorage.node
			format "thisNode is undefined, setting it to NodeStorage!\n"
		)
		else if thisNode == undefined then (
			format "both thisNode and NodeStorage are undefined!!!!FUCKING SHITTING BOLLOCKSING CUNT!\n"
		)
		if aiPathController == undefined then (

		)
		--updateMesh  =true
		node1Pos = [0,-1,0]
		node2Pos = [0,1,0]
		node1Radius = 1
		node2Radius = 1
		--format "Will we update the mesh?\n"
		if meshObj == undefined then updateMesh = true
		if Node1 != undefined and Node1.node != undefined and Node2 != undefined and Node2.node != undefined then
		(
			node1Pos = Node1.node.pos
			node2Pos = Node2.node.pos
			node1Radius = Node1.node.Radius
			node2Radius = Node2.node.Radius/*
			format "nodes exist\n"
			if lastNode1Pos != Node1.node.pos or lastNode2Pos != Node2.node.pos then
			(
				format "node moved\n"
				updateMesh = true
				lastNode1Pos = Node1.node.pos
				lastNode2Pos = Node2.node.pos
			)
			if lastNode1Radius != Node1.node.Radius or lastNode2Radius != Node2.node.Radius then
			(
				format "node radius changed\n"

				updateMesh = true
				lastNode1Radius = Node1.node.Radius
				lastNode2Radius = Node2.node.Radius
			)*/
		)
		if lastWidth != Width then
		(
			updateMesh = true
			lastWidth = Width
		)
		if ForceMeshUpdate then
		(
			updateMesh = true
			ForceMeshUpdate = false
		)
		if updateMesh then
		(
--			format "updating mesh which has % verts, % tverts and % faces\n" (getNumVerts mesh) (getNumTVerts mesh) (getNumFaces mesh)
--			format "but meshObj has % verts, % tverts and % faces\n" (getNumVerts meshObj) (getNumTVerts meshObj) (getNumFaces meshObj)
			--planeObj = createInstance plane width: lastWidth length:1 lengthsegs:1 widthsegs:1 mapCoords:true
			
			--updateMesh=false
				--planeObj.length = (length (Node2pos - Node1pos)) - Node1Radius - Node2Radius
			if meshObj == undefined then (
				meshObj = trimesh() --planeObj.meshObj
			)
			--setNumVerts meshObj 4
			--setNumFaces meshObj 1
			
			v = Node2pos - Node1pos
			
			vLen = length v
			vLen -= Node1Radius + Node2Radius
			vLen = vLen / 2
			--vLen += Node1.node.Radius
			vNorm = normalize v
			thisNode.pos = vNorm * vLen + Node1pos + vNorm * Node1radius
			verts = #(-vNorm * vLen, -vNorm * vLen, vNorm * vLen, vNorm * vLen)
			tang = [Width,0,0]
			if abs (dot vNorm [0,0,1]) > 0.95 then
			(
				tang = (cross vNorm [1,0,0]) * (abs width)
			)
			else
			(
				tang = (cross vNorm [0,0,1]) * (abs width)
			)
			tang = [tang.x, tang.y, tang.z]
			offset = normalize (cross (normalize tang) vNorm) * DisplayOffset
			setNumVerts meshObj 4
			setNumFaces meshObj 2

			setNumTVerts meshObj 4

			meshop.setNumMaps meshObj 3 keep:true
			meshop.setMapSupport meshObj 2 true

			meshop.buildMapFaces meshObj 2
			meshop.setNumMapVerts meshObj 2 4 keep:true

			buildTVFaces meshObj
			
			setVert meshObj 1 (verts[1] - tang + offset)
			setVert meshObj 2 (verts[2] + tang + offset)
			setVert meshObj 3 (verts[3] - tang + offset)
			setVert meshObj 4 (verts[4] + tang + offset)
			
			setNumTVerts meshObj 4
			buildTVFaces meshObj
			uvScale = 0.1
			setTVert meshObj 3 ([0,vlen*uvScale,0])
			setTVert meshObj 4 ([1,vlen*uvScale,0])
			setTVert meshObj 1 ([0,0,0])
			setTVert meshObj 2 ([1,0,0])
			setFace meshObj 1 [1,2,3]
			setFace meshObj 2 [3,2,4]
			setTVFace meshObj 1 [1,2,3]
			setTVFace meshObj 2 [3,2,4]

			meshop.setMapVert meshObj 2 1 ([0,vlen*uvScale,0])
			meshop.setMapVert meshObj 2 2 ([width*uvScale,vlen*uvScale,0])
			meshop.setMapVert meshObj 2 3 ([0,0,0])
			meshop.setMapVert meshObj 2 4 ([width*uvScale,0,0])
			meshop.setMapFace meshObj 2 1 [1,2,3]
			meshop.setMapFace meshObj 2 2 [3,2,4]
			--meshObj = meshObj

			isTrack = false
			isShortcut = false
			isWater = false
			if editingRoute != undefined and editingRoute > 0 then (
				if editingRoute <= LinkType.count then (
					if LinkType[editingRoute] == 1 then isTrack = true
					else if LinkType[editingRoute] == 2 then isShortcut = true
				)
				if editingRoute <= Water.count and Water[editingRoute] == 1 then (
					isWater = true
				)
			)
			update meshObj
			--mesh = meshObj
			--format "regenerating link mesh with % verts and % faces\n" (getNumVerts meshObj) (getNumFaces meshObj)
			

			--format "Updated mesh with  % verts, % tverts and % faces\n" (getNumVerts mesh) (getNumTVerts mesh) (getNumFaces mesh)
			
		)
		if updateMaterials == true then (
			theMat= LinkMatLibrary.GetMaterial OneWay isWater IsLoop Interior isShortcut isTrack
			--format "setting material to %\n" theMat
			updateMaterials = false
			thisNode.material = theMat
		)
		/*if LinkType.count == 0 then
		(
		thisNode.wirecolor = color 255 0 0
		)
		else
		(
			colorR = 0
			colorB = 0
			colorG = 0
			for i=1 to LinkType.count do (
				if LinkType[i] == 1 then
				(
					colorG  = 128
				)
				else if  LinkType[i] == 2 then (
					colorB = 128
				)
				else (
					colorR = 128
				)
			)
			thisNode.wirecolor = color colorR colorG colorB
		)*/

		--thisNode.wirecolor = color 0 255 0
		
		--return meshObj
		
		mesh = meshObj
		

	)
	tool create
	(
		on mousePoint clickno do
		(
		
		  case clickno of
			(
				1: 
				(
					nodeTM = matrix3 1
					nodeTM.translation = worldPoint
					
				)
				2:
				(
					--Radius = length (nodeTM.translation - worldPoint) 
					#stop
				)
				
			)
		)
		
	)
)
plugin simpleObject AINode
	name:"Level AI Node 2"
	classID:#(0x47385999, 0x73234501)
	category:"Carmageddon: Reincarnation"
	version:1
(
  local lastSize, meshObj, raceLineObj, lastRaceLine, updateMesh
  parameters pblock rollout:params
  (
		Index type:#integer default: 0 ui:spn_Index
		Type type:#integer default: 0
		Radius type:#float default: 0.0 ui: spn_Radius
		DisplayRadius type:#float default: 1.0 ui: spn_DisplayRadius
		Position type:#point3 default: [0,0,0]
		RaceLine type:#point3 default: [0,0,0]
		RaceLineOffset type:#float default: 0.0
		
		ShowRaceLine type:#boolean default: false ui: chk_ShowRaceLine
		UseDisplayRadius type:#boolean default: true ui: chk_UseDisplayRadius

		on Radius set val do (
			UpdateMesh = true
		)
		on DisplayRadius set val do (
			UpdateMesh = true
		)
		on UseDisplayRadius set val do (
			UpdateMesh = true
		)
  )
  rollout params "AI Node Parameters"
  (
    Spinner spn_Radius "Radius:" range:[0, 1e9, 0]
	Checkbox chk_UseDisplayRadius "Use Display Radius" default: true
    Spinner spn_DisplayRadius "Radius:" range:[0, 1e9, 1]
	Checkbox chk_ShowRaceLine "Show Race Line:" default: true
	Spinner spn_Index "Index:" type:#integer range:[0,1000000,0]
  )
  on buildmesh do
  (
    if meshObj == undefined or UpdateMesh do
    (
    	--format "creating node display mesh\n"
    	rad= radius
    	if UseDisplayRadius then rad = displayradius
      meshObj = createInstance sphere radius:rad segs:8
      lastSize = rad
      updateMesh=false
    
	if ShowRaceLine and ((raceLineObj == undefined) or lastRaceLine != raceLine) do
	(
    	format "creating raceline mesh\n"
		vect = Position - RaceLine
		raceLineObj = trimesh()
		
		vertices = #([vect.x, vect.y, vect.z], [vect.x + Radius, vect.y, vect.z], [-(vect.x + Radius), vect.y, vect.z], [vect.x, vect.y + Radius, vect.z], [vect.x, -(vect.y + Radius), vect.z],[vect.x, vect.y, vect.z + Radius], [vect.x, vect.y, -(vect.z + Radius)])
		faces = #(1, 2, 1, 3, 1, 4, 1, 5, 1, 6, 1, 7)
		setNumVerts raceLineObj vertices.count
		setNumFaces raceLineObj (faces.count / 2)
		for i=1 to vertices.count do setVert raceLineObj i vertices[i]
		for i=1 to faces.count / 2 do setFace raceLineObj i faces[i] faces[i + 1] faces[i + 2]
		lastRaceLine = RaceLine
	)
    if Radius != lastSize do
    (
     -- meshObj.radius = Radius 
    --  lastSize = Radius
    )
    if ShowRaceLine then 
	(
	 --meshObj.mesh + raceLineObj
	)
	 --else 
	 mesh = meshObj.mesh
	 )
  )
  on attachedToNode nodeVar do
	(
		
		nodevar.xray = true
	)
	tool create
	(
	
		on mousePoint clickno do
		(
		
		  case clickno of
			(
				1: 
				(
					nodeTM = matrix3 1
					nodeTM.translation = worldPoint
					RaceLine = worldPoint
					Position = worldPoint
				)
				3:
				(
					Radius = length (nodeTM.translation - worldPoint) 
					#stop
				)
				
			)
		)
		on mouseMove clickno do
		(
		
			case clickno of
			(
				3: Radius = length (nodeTM.translation - worldPoint)
				--3: #stop
			)
		)
	)
)
plugin Helper AINode_Old
	name:"Level AI Node"
	classID:#(0x47db14fe, 0x4e9b5f90)
	category:"Carmageddon: Reincarnation"
	extends:dummy
(
  local lastSize, meshObj, raceLineObj, lastRaceLine
  parameters pblock rollout:params
  (
		Index type:#integer default: 0 ui:spn_Index
		Type type:#integer default: 0
		Radius type:#float default: 0.0 ui: spn_Radius
		Position type:#point3 default: [0,0,0]
		RaceLine type:#point3 default: [0,0,0]
		RaceLineOffset type:#float default: 0.0
		
		ShowRaceLine type:#boolean default: false ui: chk_ShowRaceLine
  )
  rollout params "AI Node Parameters"
  (
    Spinner spn_Radius "Radius:" range:[0, 1e9, 0]
	Checkbox chk_ShowRaceLine "Show Race Line:" default: true
	Spinner spn_Index "Index:" type:#integer range:[0,1000000,0]
  )
  on getDisplayMesh do
  (
    if (meshObj == undefined) do
    (
    	--format "creating node display mesh\n"
      meshObj = createInstance sphere radius:Radius segs:8
      lastSize = Radius
    )
	if ShowRaceLine and ((raceLineObj == undefined) or lastRaceLine != raceLine) do
	(
    	format "creating raceline mesh\n"
		vect = Position - RaceLine
		raceLineObj = trimesh()
		
		vertices = #([vect.x, vect.y, vect.z], [vect.x + Radius, vect.y, vect.z], [-(vect.x + Radius), vect.y, vect.z], [vect.x, vect.y + Radius, vect.z], [vect.x, -(vect.y + Radius), vect.z],[vect.x, vect.y, vect.z + Radius], [vect.x, vect.y, -(vect.z + Radius)])
		faces = #(1, 2, 1, 3, 1, 4, 1, 5, 1, 6, 1, 7)
		setNumVerts raceLineObj vertices.count
		setNumFaces raceLineObj (faces.count / 2)
		for i=1 to vertices.count do setVert raceLineObj i vertices[i]
		for i=1 to faces.count / 2 do setFace raceLineObj i faces[i] faces[i + 1] faces[i + 2]
		lastRaceLine = RaceLine
	)
    if Radius != lastSize do
    (
      meshObj.radius = Radius 
      lastSize = Radius
    )
    if ShowRaceLine then 
	(
	 --meshObj.mesh + raceLineObj
	)
	 --else 
	 meshObj.mesh
  )
	tool create
	(
	
		on mousePoint clickno do
		(
		
		  case clickno of
			(
				1: 
				(
					nodeTM = matrix3 1
					nodeTM.translation = worldPoint
					RaceLine = worldPoint
					Position = worldPoint
				)
				3:
				(
					Radius = length (nodeTM.translation - worldPoint) 
					#stop
				)
				
			)
		)
		on mouseMove clickno do
		(
		
			case clickno of
			(
				3: Radius = length (nodeTM.translation - worldPoint)
				--3: #stop
			)
		)
	)
)
plugin simpleObject CarmaHelper_LevelRoutes
	Name:"AI Routes"
	classID:#(0x20c755be, 0x683f57d2)
	category:"Carmageddon: Reincarnation"
	version:2
(
	local AINodesObjects, AILinksObjects, IconMesh, thisNode, thisMesh, lastPlacedNode, currentPlacingNode, lastPlacedLink, intersectGrid, lastViewPoint, draggingMouse, activeRace
	
	parameters RouteParamBlock rollout: RouteParameters
	(
	
		NodeStorage type:#maxObject
		Races type:#stringTab tabSizeVariable:true
		RoutesVersion type:#float default:2.5
		Lump type:#string default:""

		AINodes type:#maxObjectTab tabSizeVariable:true
		AINodes_Index type:#intTab tabSizeVariable:true
		AINodes_Type type:#intTab tabSizeVariable:true
		AINodes_Radius type:#floattab tabSizeVariable:true
		AINodes_Position type:#point3Tab tabSizeVariable:true
		AINodes_RaceLine type:#point3Tab tabSizeVariable:true
		AINodes_RaceLineOffset type:#floatTab tabSizeVariable:true
		
		AILinks type:#maxObjectTab tabSizeVariable:true
		AILinks_Node1 type:#intTab tabSizeVariable:true
		AILinks_Node2 type:#intTab tabSizeVariable:true
		AILinks_Width type:#floattab tabSizeVariable:true
		AILinks_Type type:#intTab tabSizeVariable:true
		AILinks_OneWay type:#boolTab tabSizeVariable:true
		AILinks_Interior type:#boolTab tabSizeVariable:true
		AILinks_Loop type:#boolTab tabSizeVariable:true
		AILinks_Water type:#boolTab tabSizeVariable:true
		
	)
	fn CreateNode type:0 radius:1 position:[0,0,0] raceLine:undefined racelineoffset:0 =
	(
		append AINodes_Type type
		append AINodes_Radius radius
		append AINodes_Position position
		if raceline != undefined then
			append AINodes_RaceLine raceline
	)
	rollout RouteParameters "Route Parameters"
	(
		group "Tools" (
			button but_CreatePath "Create Path"
		)
		group "Race Routes"
		(
			dotnetcontrol lv_Races "listview" height:100
			button but_AddRace "Add Race" across:2
			button but_DelRace "Delete Race"

		)
		group "AI Nodes"
		(
			dotnetcontrol lv_AINodes "listview" height:100
			button but_AddNode "New Node" across: 2
			button but_DelNode "Delete Node" across: 2

			spinner spn_NodeRadius "Radius"

			label lbl_NodePos "Position" across:2
			button but_MoveNode "Move"
			spinner spn_NodePosX "" across:3
			spinner spn_NodePosY "" across:3
			spinner spn_NodePosZ "" across:3

			label lbl_NodeRaceLine "Race Line" across:2
			button but_MoveRaceLine "Move"
			spinner spn_NodeRaceLineX "" across:3
			spinner spn_NodeRaceLineY "" across:3
			spinner spn_NodeRaceLineZ "" across:3
		)
		group "AI Links"
		(
			dotnetcontrol lv_AILinks "listview" height:100
			button but_AddLink "New Node" across: 2
			button but_DelLink "Delete Node" across: 2

			label lbl_Routes "Races"
			dotnetcontrol pnl_LinkTypes "panel"

			spinner spn_LinkNode1 "Node 1" type:#integer across:2
			button but_LinkNode1Pick "Pick"
			spinner spn_LinkNode2 "Node 2" type:#integer across:2
			button but_LinkNode2Pick "Pick"

			spinner spn_LinkWidth "Width"


		)

		fn UpdateRaces = (
			lv_Races.Items.clear()
			for race in Races do (
				lv_Races.Items.add race
			)
		)

		on but_AddRace pressed do (
			append Races ("Race"+((Races.count+1) as string))
			UpdateRaces()
		)
		on but_DelRace pressed do (
			deleteItem Races (Races.count)
			UpdateRaces()
		)
		fn UpdateAINodes = (
			lv_AINodes.Items.clear()
			while AINodes.count > 0 do ( deleteItem AINodes 1)

			for obj in objects where (classof obj) == AINode do (
				append AINodes obj
				lv_AINodes.Items.add obj.name
			)
		)
		fn UpdateAILinks = (
			lv_AILinks.Items.clear()
			while AILinks.count > 0 do ( deleteItem AILinks 1)

			for obj in objects where (classof obj) == AILink do (
				append AILinks obj
				lv_AILinks.Items.add obj.name
			)
		)
		on RouteParameters open do (
			 lv_Races.view = (dotnetclass "view").details
				lv_Races.fullrowselect= true
				lv_Races.gridlines = true
				lv_Races.multiselect =false
				lv_Races.columns.add "Name" 110

			 lv_AINodes.view = (dotnetclass "view").details
				lv_AINodes.fullrowselect= true
				lv_AINodes.gridlines = true
				lv_AINodes.multiselect =false
				lv_AINodes.columns.add "Name" 110

			 lv_AILinks.view = (dotnetclass "view").details
				lv_AILinks.fullrowselect= true
				lv_AILinks.gridlines = true
				lv_AILinks.multiselect =false
				lv_AILinks.columns.add "Name" 110

			UpdateRaces()
			UpdateAINodes()
			UpdateAILinks()
		)
		/*
		tool createPath
		(
			on start do (
				format "Create Path Tool started!\n"
					lastPlacedNode = undefined
					lastPlacedLink = undefined
					currentPlacingNode = undefined
			)
			on stop do (
				format "Create Path Tool finished!\n"
					lastPlacedNode = undefined
					lastPlacedLink = undefined
					currentPlacingNode = undefined

					UpdateAINodes()
					UpdateAILinks()
					CompleteRedraw()
			)
			on mousePoint click do (
				format "Mouse click %\n" click
				lastViewPoint = viewPoint
				if click > 1 then (
					if click == 2 then (
						nextPlacedNode = undefined
						closestDist = undefined
						mouseRay = mapScreenToWorldRay viewPoint 
						hits = 0
						for obj in objects where (classof obj) == AINode do (
							hit = intersectRay obj mouseRay
							if hit != undefined then(
								dist = distance hit.pos mouseRay.pos
								hits = hits + 1
								
								if(nearestDist == undefined or dist < nearestDist) then (
									nextPlacedNode = obj
									nearestDist = dist
								)
							)
						)

						if nextPlacedNode == undefined and (lastPlacedLink == undefined or lastPlacedLink.Node2 == undefined or lastPlacedLink.Node2.node == undefined) then (
							nextPlacedNode = AINode pos:worldPoint displayRadius:2.0
						)
						else if lastPlacedLink != undefined and lastPlacedLink.Node2 != undefined and lastPlacedLink.Node2.pos != undefined then (
							nextPlacedNode = lastPlacedLink.Node2.node
							lastPlacedLink = undefined
						)

						lastPlacedNode = nextPlacedNode
						format "Just placed %\n" lastPlacedNode
					)
					else if lastPlacedLink != undefined then (

						if currentPlacingNode != undefined then (
							
							lastPlacedNode = currentPlacingNode
							format "Setting lastPlacedNode from currentPlacingNode: %\n" lastPlacedNode
							currentPlacingNode = undefined

							-- Check if new node intersects with other links and insert it in the middle
							if shiftKey then (
								AILinks = for obj in objects where (classof obj) == AILink and obj != lastPlacedLink and (obj.Node1 == undefined or obj.Node1.node != lastPlacedNode) and (obj.Node2 == undefined or obj.Node2.node != lastPlacedNode) collect obj
								for obj in AILinks do (
									
									n1 = obj.Node1.node
									n2 = obj.Node2.node
									maxDist = distance n1.pos n2.pos
									linkray = Ray n1.pos (normalize (n2.pos - n1.pos))
									linkHit = intersectRay lastPlacedNode linkray

									if linkHit != undefined and (distance n1.pos linkHit.pos) < maxDist then (
										obj.Node2 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
										newIntersectionLink = AILink width:1.0
										newIntersectionLink.Node2 = nodeTransformMonitor node:n2 forwardTransformChangeMsgs:false

										newIntersectionLink.Node1 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
									)
								)
							 )

						)
						else if lastPlacedLink.Node2 != undefined then (
							lastPlacedNode = lastPlacedLink.Node2.node
							AILinks = for obj in objects where (classof obj) == AILink and obj != lastPlacedLink collect obj
							moveLinkStart = false
							foundLink = undefined
							for obj in AILinks do (
								if obj.Node1 != undefined and obj.Node2 != undefined and ((obj.Node1.node ==  lastPlacedLink.Node1.node and obj.Node2.node == lastPlacedLink.Node2.node) or (obj.Node2.node ==  lastPlacedLink.Node1.node and obj.Node1.node == lastPlacedLink.Node2.node) )then (
									moveLinkStart = true
									foundLink = obj
								)
							)

							if moveLinkStart then (
								format "Removing lastPlacedLink because a link already exists!"
								if draggingMouse and foundLink != undefined then (
									foundLink.width = lastPlacedLink.width
								)
								delete lastPlacedLink
							)
							format "Setting lastPlacedNode from lastPlacedLink.Node2: %\n" lastPlacedNode
						)

						lastPlacedLink = undefined
						draggingMouse = false
						lastViewPoint = undefined
					)

				
					currentPlacingNode = AINode pos:worldPoint displayRadius:2.0
					
					format "New AI link in Mousepoint! Creating new link and setting Node1 to last placed node ( % ) and Node2 to found node ( % )!\n" lastPlacedNode foundNode
					lastPlacedLink = AILink width:1.0
					lastPlacedLink.Node2 = nodeTransformMonitor node:currentPlacingNode forwardTransformChangeMsgs:false

					lastPlacedLink.Node1 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
				)
				
			)
			on mouseMove click do (
				if lbutton then 
				(
					if draggingMouse != true then (
						draggingMouse = true
					)
					else (
						viewPointDist = distance viewPoint lastViewPoint
						viewPointDiff = viewPoint - lastViewPoint
						if viewPointDiff.y > 0  then (
							viewPointDist = viewPointDist * -1
						) 
						if(lastPlacedLink != undefined) then (
							lastPlacedLink.width = lastPlacedLink.width + (viewPointDist * 0.1)
						)
					)
						lastViewPoint = viewPoint

				)
				else (
					foundNode = undefined
					nearestDist = undefined
					hits = 0
					mouseRay = mapScreenToWorldRay viewPoint 
					for obj in objects where (classof obj) == Editable_mesh or (classof obj) == Editable_Poly or (classof obj) == CarmaHelper_AccessoryPlaceholder do (
						hit = intersectRay obj mouseRay
						if hit != undefined then(
							hits = hits + 1
							dist = distance hit.pos mouseRay.pos
							
							if(nearestDist == undefined or dist < nearestDist) then (
								foundNode = obj
								nearestDist = dist
							)
						)
					)

					if currentPlacingNode != undefined then (

						if hits > 0 then (
							currentPlacingNode.pos = mouseRay.pos + mouseRay.dir * nearestDist
						)
						else (
							currentPlacingNode.pos = worldPoint
						)
					)
					foundNode = undefined
					nearestDist = undefined
					hits = 0
					--format "Moving Mouse!\n"
					for obj in objects where (classof obj) == AINode and obj != currentPlacingNode and obj != lastPlacedNode and (lastPlacedLink ==  undefined or ((lastPlacedLink.node2 == undefined or lastPlacedLink.node2.node != obj) and lastPlacedLink.node1 == undefined or lastPlacedLink.node1.node != obj )) do (
						hit = intersectRay obj mouseRay
						if hit != undefined then(
							dist = distance hit.pos mouseRay.pos
							hits = hits + 1
							
							if(nearestDist == undefined or dist < nearestDist) then (
								foundNode = obj
								nearestDist = dist
							)
						)
					)
					--format "Found % hits!\n" hits
					if foundNode != undefined then (
						if currentPlacingNode != undefined then (
							--format "Found node, deleting temp placing node!\n"
							if lastPlacedLink != undefined and lastPlacedLink.node2 != undefined and lastPlacedLink.node2.node == currentPlacingNode then (
								lastPlacedLink.node2 = undefined --nodeTransformMonitor node:foundNode forwardTransformChangeMsgs:false
							)
							delete currentPlacingNode
							currentPlacingNode = undefined
						)
						else (
							--format "Found node, currentPlacingNode node is undefined!\n"
						)

					)
					else if currentPlacingNode == undefined then (
						
							--format "Didn't find node, creating new temp placing node!\n"
						currentPlacingNode = AINode pos:worldPoint displayRadius:2.0
						foundNode = currentPlacingNode
					)
					if foundNode == undefined then (
						foundNode=currentPlacingNode
					)
					
					--format "Now to set AI Link nodes to % and % (currentPlacingNode= %)\n" lastPlacedLink foundNode currentPlacingNode
					
					if lastPlacedLink != undefined and (lastPlacedLink.Node2 == undefined or lastPlacedLink.Node2.node != foundNode) then (
						--format "Last link exists, setting Node2 to found node ( % )!\n" foundNode
						lastPlacedLink.Node2 = nodeTransformMonitor node:foundNode forwardTransformChangeMsgs:false
					)
				)
			)
			on mouseAbort click do (
				format "Aborting tool!\n"
				if lastPlacedLink != undefined then (
					n1 = undefined
					if lastPlacedLink.node1 !=undefined then n1 = lastPlacedLink.node1.node

					n2 = undefined
					if lastPlacedLink.node2 !=undefined then n2 = lastPlacedLink.node2.node

					format "Deleting link % (node1: % - node2: %)\n" lastPlacedLink n1 n2
					delete lastPlacedLink
				)
				if currentPlacingNode != undefined then (
					format "Deleting node %\n" currentPlacingNode
					delete currentPlacingNode
				)
			)
		)
		on but_CreatePath pressed do (
			format "Starting createPath tool!\n"
			startTool createPath
		)*/
	)
	on load do
	(
		thisNode = NodeStorage.node
		AINodesObjects = #()
		AILinksObjects = #()
	)
	on postLoad do
	(
		thisNode = NodeStorage.node
		AINodesObjects = #()
		AILinksObjects = #()
	)
	on attachedToNode nodeVar do
	(
		thisNode = nodeVar
		NodeStorage = nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
	)
	on buildmesh do
	(
		if thisMesh == undefined then (
			iconMat = undefined
			mats = for mat in scenematerials where mat.name == "sys_AIRoutesIconMat" collect mat
			--format "Mat Count: %\n" mats.count
			if mats.count == 0 then
			(
				iconMat = standardmaterial name:"sys_AIRoutesIconMat"
				scriptFileName = getThisScriptFilename()
				scriptFolder = getFileNamePath scriptFileName
				iconMat.diffuseMap = bitmaptexture filename:(scriptFolder+"UI/PathsIcon.png")
				iconMat.opacityMap = bitmaptexture filename:(scriptFolder+"UI/PathsIcon.png") monoOutput:1
				--IconMesh.material = iconMat
			)
			else iconMat = mats[1] --IconMesh.material = mats[0]
			--format "Icon Mat: %\n" iconMat
			showTextureMap iconMat on
			--IconMesh = createInstance plane width:1 lengthsegs:1 widthsegs:1 material:iconMat -- 
			--material = iconMat
			thisMesh = trimesh()
			verts = #([0.5,0.5,0],[0.5,-0.5,0],[-0.5,0.5,0],[-0.5,-0.5,0])
			faces = #([1,2,3],[2,4,3])
			tverts = #([1,1,0], [1,0,0], [0,1,0], [0,0,0])
			setNumVerts thisMesh 4
			setVert thisMesh 1 verts[1]
			setVert thisMesh 2 verts[2]
			setVert thisMesh 3 verts[3]
			setVert thisMesh 4 verts[4]
			setNumTVerts thisMesh 4
			setTVert thisMesh 1 tverts[1]
			setTVert thisMesh 2 tverts[2]
			setTVert thisMesh 3 tverts[3]
			setTVert thisMesh 4 tverts[4]
			setNumFaces thisMesh 2
			setFace thisMesh 1 faces[1]
			setFace thisMesh 2 faces[2]
			
			thisNode.material = iconMat

			setmesh thisMesh vertices:#([0.5,0.5,0],[0.5,-0.5,0],[-0.5,0.5,0],[-0.5,-0.5,0]) faces:#([1,2,3],[2,4,3])
			
			setNumTVerts thisMesh 4
			setTVert thisMesh 1 tverts[1]
			setTVert thisMesh 2 tverts[2]
			setTVert thisMesh 3 tverts[3]
			setTVert thisMesh 4 tverts[4]
			buildTVFaces thisMesh
			
			setTVFace thisMesh 1 faces[1]
			setTVFace thisMesh 2 faces[2]
			
		)
		mesh = thisMesh
	)
	
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: 
				(
					nodeTM.translation = worldPoint
				)
				2: #stop
			)
		)
		on mouseMove click do
		(
			case click of
			(
				2: #stop
			)
		)
	)
)


fn LinkSelectedAINodes = (
	nodes = for obj in $ where (classof obj) == AINode collect obj
	if nodes.count > 1 then (
		LinkAINodes nodes[1] nodes[2]
	)
	else format "Only % nodes found! %\n" nodes.count $
)

fn CreateLevelAIPathManager = (
	global aiPathManager = CarmaHelper_LevelRoutes name:"sys_AIPathManager"
	append aiPathManager.Races "Race1"
	aiPathManager
)

fn GetLevelAIPathManager = (
	global aiPathManager
	if aiPathManager == undefined or (isvalidnode aiPathManager) == false then (
		CreateLevelAIPathManager()
	)

	aiPathManager
)


rollout AILinkPathToolRollout "AI Path Tool" (
	local lastPlacedNode, currentPlacingNode, lastPlacedLink, intersectGrid, lastViewPoint, draggingMouse, activeRace
	local selectionChangeHandler, oldFrozenObjects, oldXrayObjects

		group "Tools" (
			button but_CreatePath "Create Path" across:2
			checkbutton but_AlterPath "Alter Path" across:2
			Label lbl_Settings "Settings:"
			checkbox chk_OneWay "OneWay"
			checkbox chk_Water "Water"
			checkbox chk_Loop "Loop"
			checkbox chk_Interior "Interior"
			checkbox chk_Track "Track"
			checkbox chk_Shortcut "Shortcut"
		)
		group "Race Routes"
		(
			dotnetcontrol lv_Races "listview" height:100
			button but_AddRace "Add Race" across:2
			button but_DelRace "Delete Race"

		)
		group "AI Nodes"
		(
			dotnetcontrol lv_AINodes "listview" height:100

		)
		group "AI Links"
		(
			dotnetcontrol lv_AILinks "listview" height:100


		)


		fn UpdateRaces = (

			aiPathManager = GetLevelAIPathManager()
			lv_Races.Items.clear()
			for race in aiPathManager.Races do (
				lv_Races.Items.add race
			)
		)

		on but_AddRace pressed do (
			append aiPathManager.Races ("Race"+((aiPathManager.Races.count+1) as string))
			UpdateRaces()
		)
		on but_DelRace pressed do (
			deleteItem aiPathManager.Races (aiPathManager.Races.count)
			UpdateRaces()
		)
		fn UpdateAINodes = (
			aiPathManager = GetLevelAIPathManager()
			lv_AINodes.Items.clear()
			while aiPathManager.AINodes.count > 0 do ( deleteItem aiPathManager.AINodes 1)

			for obj in objects where (classof obj) == AINode do (
				append aiPathManager.AINodes obj
				lv_AINodes.Items.add obj.name
			)
		)

		fn UpdateAILinks = (
			aiPathManager = GetLevelAIPathManager()
			lv_AILinks.Items.clear()
			while aiPathManager.AILinks.count > 0 do ( deleteItem aiPathManager.AILinks 1)

			for obj in objects where (classof obj) == AILink do (
				append aiPathManager.AILinks obj
				lv_AILinks.Items.add obj.name
			)
		)
		
		fn setChangeHandler = (
			
			if selectionChangeHandler != undefined then (
				deleteChangeHandler selectionChangeHandler
			)
			AILinks = for obj in objects where (classof obj) == AILink collect obj
			selectionChangeHandler = when select AILinks change obj do (
				if AILinkPathToolRollout.open and obj.isSelected  then (
					if but_AlterPath.checked then (

						if lv_Races.selectedIndices.count > 0 then (
							--format "altering path on race %\n" lv_Races.selectedIndices.item[0]
							obj.EditingRoute = lv_Races.selectedIndices.item[0] + 1
						
						)

						obj.OneWay = chk_OneWay.checked
						obj.IsLoop = chk_Loop.checked
						obj.Interior = chk_Interior.checked
						if lv_Races != undefined and lv_Races.selectedIndices != undefined and lv_Races.selectedIndices.count > 0 then (
							selectedIndex = lv_Races.selectedIndices.Item[0] + 1
							if chk_Water.checked then (
								obj.Water[selectedIndex] = 1
							)
							else (
								obj.Water[selectedIndex] = 0
							)
							
							if chk_Shortcut.checked then (
								obj.LinkType[selectedIndex] = 2
							)
							else if chk_Track.checked then (
								obj.LinkType[selectedIndex] = 1
							)
							else (
								obj.LinkType[selectedIndex] = 0
							)
						)
					)
					else (
					--format "setting link settings for %\n" obj

						chk_OneWay.checked = obj.OneWay
						chk_Loop.checked = obj.IsLoop
						chk_Interior.checked = obj.Interior
						if lv_Races != undefined and lv_Races.selectedIndices != undefined and lv_Races.selectedIndices.count > 0 then (
							selectedIndex = lv_Races.selectedIndices.Item[0] + 1
							chk_Water.checked = (obj.Water[selectedIndex] == 1)
							chk_Track.checked = (obj.LinkType[selectedIndex] == 1)
							chk_Shortcut.checked = (obj.LinkType[selectedIndex] == 2)
						)
					)
				)
			)
		)

		on but_AlterPath changed state do (

			clearSelection()
			if lv_Races.selectedIndices.count > 0 then (
				format "altering path on race %\n" lv_Races.selectedIndices.item[0]
			)
			if state then (

				setChangeHandler()
				oldFrozenObjects = for obj in objects where obj.isFrozen collect obj
				oldXrayObjects = for obj in objects where obj.xray collect obj
				nonLinkObjects = (for obj in objects where (classof obj) != AILink collect obj)
				freeze nonLinkObjects
				nonLinkObjects.showFrozenInGray = false
				nonLinkObjects.xray=true

			)
			else (
				unfreeze objects
				freeze oldFrozenObjects
				objects.showFrozenInGray = true
				objects.xray = false
				oldXrayObjects.xray = true

			)
			CompleteRedraw()

		)
		on lv_Races selectedindexchanged args do (
			--format "changed selected race to %\n" index
			if lv_Races.selectedIndices.count > 0 then (
				if but_AlterPath.checked then (
					clearSelection()
				)
				index = lv_Races.selectedIndices.item[0]+1
				aiPathManager = GetLevelAIPathManager()
				aiPathManager.activeRace = index
				for obj in objects where (classof obj) == AILink do (
					obj.EditingRoute = index
				)
			)
			CompleteRedraw()
		)
		on AILinkPathToolRollout close do (
				
			if selectionChangeHandler != undefined then (
				deleteChangeHandler selectionChangeHandler
			)
		)
		on AILinkPathToolRollout open do (
			setChangeHandler()

			 lv_Races.view = (dotnetclass "view").details
				lv_Races.fullrowselect= true
				lv_Races.gridlines = true
				lv_Races.multiselect =false
				lv_Races.columns.add "Name" 110

			 lv_AINodes.view = (dotnetclass "view").details
				lv_AINodes.fullrowselect= true
				lv_AINodes.gridlines = true
				lv_AINodes.multiselect =false
				lv_AINodes.columns.add "Name" 110

			 lv_AILinks.view = (dotnetclass "view").details
				lv_AILinks.fullrowselect= true
				lv_AILinks.gridlines = true
				lv_AILinks.multiselect =false
				lv_AILinks.columns.add "Name" 110

			UpdateRaces()
			UpdateAINodes()
			UpdateAILinks()
		)
		tool createPath
		(
			on start do (
				format "Create Path Tool started!\n"
					lastPlacedNode = undefined
					lastPlacedLink = undefined
					currentPlacingNode = undefined
			)
			on stop do (
				format "Create Path Tool finished!\n"
					lastPlacedNode = undefined
					lastPlacedLink = undefined
					currentPlacingNode = undefined

					UpdateAINodes()
					UpdateAILinks()
					setChangeHandler()
					CompleteRedraw()
			)
			on mousePoint click do (
				format "Mouse click % at %\n" click viewPoint
				lastViewPoint = viewPoint
				viewportSize = getViewSize()
				if viewPoint.x >= 0 and viewPoint.y >= 0 and viewPoint.x < viewportSize.x and viewPoint.y < viewportSize.y then (
					if click > 1 then (
						if click == 2 then (
							nextPlacedNode = undefined
							closestDist = undefined
							mouseRay = mapScreenToWorldRay viewPoint 
							hits = 0
							for obj in objects where (classof obj) == AINode do (
								hit = intersectRay obj mouseRay
								if hit != undefined then(
									dist = distance hit.pos mouseRay.pos
									hits = hits + 1
									
									if(nearestDist == undefined or dist < nearestDist) then (
										nextPlacedNode = obj
										nearestDist = dist
									)
								)
							)

							if nextPlacedNode == undefined and (lastPlacedLink == undefined or lastPlacedLink.Node2 == undefined or lastPlacedLink.Node2.node == undefined) then (
								nextPlacedNode = AINode pos:worldPoint displayRadius:2.0
							)
							else if lastPlacedLink != undefined and lastPlacedLink.Node2 != undefined and lastPlacedLink.Node2.pos != undefined then (
								nextPlacedNode = lastPlacedLink.Node2.node
								lastPlacedLink = undefined
							)

							lastPlacedNode = nextPlacedNode
							format "Just placed %\n" lastPlacedNode
						)
						else if lastPlacedLink != undefined then (

							if currentPlacingNode != undefined then (
								
								lastPlacedNode = currentPlacingNode
								format "Setting lastPlacedNode from currentPlacingNode: %\n" lastPlacedNode
								currentPlacingNode = undefined

								-- Check if new node intersects with other links and insert it in the middle
								if shiftKey then (
									AILinks = for obj in objects where (classof obj) == AILink and obj != lastPlacedLink and (obj.Node1 == undefined or obj.Node1.node != lastPlacedNode) and (obj.Node2 == undefined or obj.Node2.node != lastPlacedNode) collect obj
									for obj in AILinks do (
										
										n1 = obj.Node1.node
										n2 = obj.Node2.node
										maxDist = distance n1.pos n2.pos
										linkray = Ray n1.pos (normalize (n2.pos - n1.pos))
										linkHit = intersectRay lastPlacedNode linkray

										if linkHit != undefined and (distance n1.pos linkHit.pos) < maxDist then (
											obj.Node2 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
											newIntersectionLink = AILink width:1.0
											newIntersectionLink.Node2 = nodeTransformMonitor node:n2 forwardTransformChangeMsgs:false

											newIntersectionLink.Node1 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
										)
									)
								 )

							)
							else if lastPlacedLink.Node2 != undefined then (
								lastPlacedNode = lastPlacedLink.Node2.node
								AILinks = for obj in objects where (classof obj) == AILink and obj != lastPlacedLink collect obj
								moveLinkStart = false
								foundLink = undefined
								for obj in AILinks do (
									if obj.Node1 != undefined and obj.Node2 != undefined and ((obj.Node1.node ==  lastPlacedLink.Node1.node and obj.Node2.node == lastPlacedLink.Node2.node) or (obj.Node2.node ==  lastPlacedLink.Node1.node and obj.Node1.node == lastPlacedLink.Node2.node) )then (
										moveLinkStart = true
										foundLink = obj
									)
								)

								if moveLinkStart then (
									format "Removing lastPlacedLink because a link already exists!"
									if draggingMouse and foundLink != undefined then (
										foundLink.width = lastPlacedLink.width
									)
									delete lastPlacedLink
								)
								format "Setting lastPlacedNode from lastPlacedLink.Node2: %\n" lastPlacedNode
							)

							lastPlacedLink = undefined
							draggingMouse = false
							lastViewPoint = undefined
						)

					
						currentPlacingNode = AINode pos:worldPoint displayRadius:2.0
						
						format "New AI link in Mousepoint! Creating new link and setting Node1 to last placed node ( % ) and Node2 to found node ( % )!\n" lastPlacedNode foundNode
						lastPlacedLink = AILink width:1.0
						lastPlacedLink.Node2 = nodeTransformMonitor node:currentPlacingNode forwardTransformChangeMsgs:false

						lastPlacedLink.Node1 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
					)
				)
			)
			on mouseMove click do (
				if lbutton then 
				(
					if draggingMouse != true then (
						draggingMouse = true
					)
					else (
						viewPointDist = distance viewPoint lastViewPoint
						viewPointDiff = viewPoint - lastViewPoint
						if viewPointDiff.y > 0  then (
							viewPointDist = viewPointDist * -1
						) 
						if(lastPlacedLink != undefined) then (
							lastPlacedLink.width = lastPlacedLink.width + (viewPointDist * 0.1)
						)
					)
						lastViewPoint = viewPoint

				)
				else (
					foundNode = undefined
					nearestDist = undefined
					hits = 0
					mouseRay = mapScreenToWorldRay viewPoint 
					for obj in objects where (classof obj) == Editable_mesh or (classof obj) == Editable_Poly or (classof obj) == CarmaHelper_AccessoryPlaceholder do (
						hit = intersectRay obj mouseRay
						if hit != undefined then(
							hits = hits + 1
							dist = distance hit.pos mouseRay.pos
							
							if(nearestDist == undefined or dist < nearestDist) then (
								foundNode = obj
								nearestDist = dist
							)
						)
					)

					if currentPlacingNode != undefined then (

						if hits > 0 then (
							currentPlacingNode.pos = mouseRay.pos + mouseRay.dir * nearestDist
						)
						else (
							currentPlacingNode.pos = worldPoint
						)
					)
					foundNode = undefined
					nearestDist = undefined
					hits = 0
					--format "Moving Mouse!\n"
					for obj in objects where (classof obj) == AINode and obj != currentPlacingNode and obj != lastPlacedNode and (lastPlacedLink ==  undefined or ((lastPlacedLink.node2 == undefined or lastPlacedLink.node2.node != obj) and lastPlacedLink.node1 == undefined or lastPlacedLink.node1.node != obj )) do (
						hit = intersectRay obj mouseRay
						if hit != undefined then(
							dist = distance hit.pos mouseRay.pos
							hits = hits + 1
							
							if(nearestDist == undefined or dist < nearestDist) then (
								foundNode = obj
								nearestDist = dist
							)
						)
					)
					--format "Found % hits!\n" hits
					if foundNode != undefined then (
						if currentPlacingNode != undefined then (
							--format "Found node, deleting temp placing node!\n"
							if lastPlacedLink != undefined and lastPlacedLink.node2 != undefined and lastPlacedLink.node2.node == currentPlacingNode then (
								lastPlacedLink.node2 = undefined --nodeTransformMonitor node:foundNode forwardTransformChangeMsgs:false
							)
							delete currentPlacingNode
							currentPlacingNode = undefined
						)
						else (
							--format "Found node, currentPlacingNode node is undefined!\n"
						)

					)
					else if currentPlacingNode == undefined then (
						
							--format "Didn't find node, creating new temp placing node!\n"
						currentPlacingNode = AINode pos:worldPoint displayRadius:2.0
						foundNode = currentPlacingNode
					)
					if foundNode == undefined then (
						foundNode=currentPlacingNode
					)
					
					--format "Now to set AI Link nodes to % and % (currentPlacingNode= %)\n" lastPlacedLink foundNode currentPlacingNode
					/*
					if lastPlacedLink == undefined then(
						
						format "Creating new link and setting Node1 to last placed node ( % ) and Node2 to found node ( % )!\n" lastPlacedNode foundNode
						lastPlacedLink = AILink width:1.0
						lastPlacedLink.Node2 = nodeTransformMonitor node:foundNode forwardTransformChangeMsgs:false

						lastPlacedLink.Node1 = nodeTransformMonitor node:lastPlacedNode forwardTransformChangeMsgs:false
					)
					else*/
					if lastPlacedLink != undefined and (lastPlacedLink.Node2 == undefined or lastPlacedLink.Node2.node != foundNode) then (
						--format "Last link exists, setting Node2 to found node ( % )!\n" foundNode
						lastPlacedLink.Node2 = nodeTransformMonitor node:foundNode forwardTransformChangeMsgs:false
					)
				)
			)
			on mouseAbort click do (
				format "Aborting tool!\n"
				if lastPlacedLink != undefined then (
					n1 = undefined
					if lastPlacedLink.node1 !=undefined then n1 = lastPlacedLink.node1.node

					n2 = undefined
					if lastPlacedLink.node2 !=undefined then n2 = lastPlacedLink.node2.node

					format "Deleting link % (node1: % - node2: %)\n" lastPlacedLink n1 n2
					delete lastPlacedLink
				)
				if currentPlacingNode != undefined then (
					format "Deleting node %\n" currentPlacingNode
					delete currentPlacingNode
				)
			)
		)
		on but_CreatePath pressed do (
			format "Starting createPath tool!\n"
			but_AlterPath.checked = false
			startTool createPath
		)
)


fn OpenAIPathsFloater = (
	if AILinkPathToolRollout.open then (
		DestroyDialog AILinkPathToolRollout
	)
	floater = createDialog AILinkPathToolRollout style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar AILinkPathToolRollout style:#(#cui_floatable,#cui_dock_left,#cui_handles) minSize:[200,350] maxSize:[-1,-1]

	return floater
)
