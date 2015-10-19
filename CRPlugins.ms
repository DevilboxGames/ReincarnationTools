if ImportCNT==undefined then 
(
	fn ImportCNT = ()
)

fn IsObjectAJoint obj =
(
	if classof obj == CarmaHelper_JointHelper then return true
	else return false
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
			
			format "JointType: %\nHinge: %\n Ball: %\n Slide: %\n" JointType JointType_Hinge JointType_Ball JointType_UJ JointType_Slide
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
	on attachedToNode nodeVar do
	(
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
		format "===========================================\n"
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


CarmaHelper_WheelType = #("Wheel_FR","Wheel_FL","Wheel_RR","Wheel_RL")
plugin simpleObject CarmaHelper_WheelPlaceholder
	Name:"Wheel"
	classID:#(0x4892a692, 0x7b9572ba)
	category:"Carmageddon: Reincarnation"
	version:1
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
				else
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
			return outMesh
		)
	fn loadWheelMesh cnt_name =
	(
		rimMesh = ImportCNT cnt_name importTextures:true forcePREP:false useTriStrips:false
		tyreMesh = ImportCNT ((getFilenamePath cnt_name)+"Tyre.cnt") importTextures:true forcePREP:false useTriStrips:false
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
			format "Using Preview Wheel with % verts\n" (getNumVerts actualMeshObj)
			format "Usingmesh with % verts\n" (getNumVerts usingMesh)
		)
		else 
		(
			thisNode.material=undefined
			--setmesh mesh placeholderMeshObj
			usingMesh = placeholderMeshObj
			format "Using Placeholder Wheel with % verts\n" (getNumVerts placeholderMeshObj)
			format "Usingmesh with % verts\n" (getNumVerts usingMesh)
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
		accessoryMesh = ImportCNT cnt_name importTextures:true forcePREP:false useTriStrips:false mergeMDLs:true
		actualMeshObj = copy accessoryMesh.mesh
		
		actualMeshMat =accessoryMesh.material
		delete accessoryMesh
		
		entry = AccessoryItemEntry()
		entry.AccessoryMesh = actualMeshObj 
		entry.AccessoryMaterial = actualMeshMat
		return entry
		
	),
	fn GetAccessory cnt_name =
	(
		splitPath = filterstring (getFileNamePath cnt_name) "/\\"
		accessoryType = splitPath[splitPath.count]
		
		accessoryExists = finditem ExistingAccessoryTypes accessoryType
		if accessoryExists > 0 then
		(
			return ExistingAccessoryMeshes[accessoryExists]
		)
		else
		(
			loadedMesh = loadAccessoryMesh cnt_name
			append ExistingAccessoryTypes accessoryType
			append ExistingAccessoryMeshes loadedMesh
			
			return loadedMesh
		)
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
		accessoryColour type:#color animatable:false ui:colpick_accessoryColour
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
	on attachedToNode nodeVar do
	(
		thisNode = nodeVar
		NodeStorage = nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
	)
	on buildmesh  do
	(
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

fn target_ainode_filter obj = ( (classof obj) == AINode)
fn target_ailink_filter obj = ( (classof obj) == AILink)
plugin Helper AILink
	name:"Level AI Link"
	classID:#(0x726998ab, 0x6dfa99f8)
	category:"Carmageddon: Reincarnation"
	extends: dummy
(
	local lastWidth, lastNode1Radius, lastNode2Radius, lastNode1Pos, lastNode2Pos, lastOneWay, meshObj, thisNode
	
	parameters paramblock rollout:params
	(
		NodeStorage type:#maxObject
		Node1 type:#maxObject
		Node2 type:#maxObject
		Width type:#float default: 1 ui:spn_Width
		LinkType type:#integer default: 0
		OneWay type:#boolean default:false ui:chk_OneWay
		Interior type:#boolean default:false ui:chk_Interior
		Loop type:#boolean default:false ui:chk_Loop
		Water type:#boolean default:false ui:chk_Water
	)
	rollout params "AI Link Parameters"
	(
		pickbutton pck_Node1 "Node 1" filter:target_ainode_filter autodisplay:true labelOnTop:true 
		pickbutton pck_Node2 "Node 2" filter:target_ainode_filter autodisplay:true labelOnTop:true 
		Spinner spn_Width "Width:" range:[0,1e9,1]
		Checkbox chk_OneWay "One Way:" default: false
		Checkbox chk_Loop "Lopp:" default: false
		Checkbox chk_Interior "Interior:" default: false
		Checkbox chk_Water "Water:" default: false
		
		on pck_Node1 picked obj do
		(
			format "Picked Node1: %\n" obj
			Node1 = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			if Node2 != undefined do
			(
				v = Node2.node.pos - Node1.node.pos
				vLen = length v
				vLen -= Node1.node.Radius + Node2.node.Radius
				vLen = vLen / 2
				vLen += Node1.node.Radius
				vNorm = normalize v
				format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.node.pos  Node2.node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + Node1.node.pos
				thisNode
			)
		)
		on pck_Node2 picked obj do
		(
			format "Picked Node2: %\n" obj
			Node2 = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			if Node1 != undefined do
			(
				v = Node2.node.pos - Node1.node.pos
				vLen = length v
				vLen -= Node1.node.Radius + Node2.node.Radius
				vLen = vLen / 2
				vLen += Node1.node.Radius
				vNorm = normalize v
				format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.node.pos  Node2.node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + Node1.node.pos
			)
		)
		on params open do
		(
			if Node1 != undefined then pck_Node1.object = Node1.node
			if Node2 != undefined then pck_Node2.object = Node2.node
		)
	)
	on attachedToNode nodeVar do
	(
		thisNode = nodeVar
		NodeStorage = nodeTransformMonitor node:nodeVar forwardTransformChangeMsgs:false
	)
	on postload do
	(
		thisNode = NodeStorage.node
		if Node2 != undefined and Node1 != undefined do
		(
				v = Node2.node.pos - Node1.node.pos
				vLen = length v
				vLen -= Node1.node.Radius + Node2.node.Radius
				vLen = vLen / 2
				vLen += Node1.node.Radius
				vNorm = normalize v
				format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.node.pos  Node2.node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + Node1.node.pos
		)
	)
	on postcreate do
	(
		
		if Node2 != undefined and Node1 != undefined do
		(
				v = Node2.node.pos - Node1.node.pos
				vLen = length v
				vLen -= Node1.node.Radius + Node2.node.Radius
				vLen = vLen / 2
				vLen += Node1.node.Radius
				vNorm = normalize v
				format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.node.pos  Node2.node.pos v vLen vNorm
				thisNode.pos = vNorm * (vLen ) + Node1.node.pos
		)
	)
	
	on getDisplayMesh do
	(
		updateMesh  =false
		node1Pos = [0,-1,0]
		node2Pos = [0,1,0]
		node1Radius = 1
		node2Radius = 1
		if meshObj == undefined then updateMesh = true
		if Node1 != undefined and Node2 != undefined then
		(
			node1Pos = Node1.node.pos
			node2Pos = Node2.node.pos
			node1Radius = Node1.node.Radius
			node2Radius = Node2.node.Radius
			
			if lastNode1Pos != Node1.node.pos or lastNode2Pos != Node2.node.pos then
			(
				updateMesh = true
				lastNode1Pos = Node1.node.pos
				lastNode2Pos = Node2.node.pos
			)
			if lastNode1Radius != Node1.node.Radius or lastNode2Radius != Node2.node.Radius then
			(
				updateMesh = true
				lastNode1Radius = Node1.node.Radius
				lastNode2Radius = Node2.node.Radius
			)
		)
		if lastWidth != Width then
		(
			updateMesh = true
			lastWidth = Width
		)
		if updateMesh then
		(
			--format "updating mesh\n"
			
			planeObj = createInstance plane width: lastWidth length:1 lengthsegs:1 widthsegs:1
			
			
				planeObj.length = (length (Node2pos - Node2pos)) - Node1Radius - Node2Radius
			
			m = planeObj.mesh
			
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
					tang = (cross vNorm [1,0,0]) * width
				)
				else
				(
					tang = (cross vNorm [0,0,1]) * width
				)
			setVert m 1 (verts[1] + tang)
			setVert m 2 (verts[2] - tang)
			setVert m 3 (verts[3] + tang)
			setVert m 4 (verts[4] - tang)
			meshObj = m
		)
		
		meshObj
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
plugin Helper AINode
	name:"Level AI Node"
	classID:#(0x47db14fe, 0x4e9b5f90)
	category:"Carmageddon: Reincarnation"
	extends:dummy
(
  local lastSize, meshObj, raceLineObj, lastRaceLine
  parameters pblock rollout:params
  (
		Index type:#integer default: 0
		Type type:#integer default: 0
		Radius type:#float default: 0.0 ui: spn_Radius
		Position type:#point3 default: [0,0,0]
		RaceLine type:#point3 default: [0,0,0]
		RaceLineOffset type:#float default: 0.0
		
		ShowRaceLine type:#boolean default: true ui: chk_ShowRaceLine
  )
  rollout params "AI Node Parameters"
  (
    Spinner spn_Radius "Radius:" range:[0, 1e9, 0]
	Checkbox chk_ShowRaceLine "Show Race Line:" default: true
  )
  on getDisplayMesh do
  (
    if (meshObj == undefined) do
    (
      meshObj = createInstance sphere radius:Radius segs:8
      lastSize = size
    )
	if (raceLineObj == undefined) or lastRaceLine != raceLine do
	(
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
	version:1
(
	local AINodesObjects, AILinksObjects, IconMesh, thisNode
	
	parameters RouteParamBlock rollout: RouteParameters
	(
	
		NodeStorage type:#maxObject
		Races type:#stringTab tabSizeVariable:true
		RoutesVersion type:#float default:2.5
		Lump type:#string default:""
	)
	parameters AINodeBlock
	(
		AINodes_Index type:#intTab tabSizeVariable:true
		AINodes_Type type:#intTab tabSizeVariable:true
		AINodes_Radius type:#floattab tabSizeVariable:true
		AINodes_Position type:#point3Tab tabSizeVariable:true
		AINodes_RaceLine type:#point3Tab tabSizeVariable:true
		AINodes_RaceLineOffset type:#floatTab tabSizeVariable:true
		
	)
	parameters AILinkBlock
	(
		AILinks_Node1 type:#intTab tabSizeVariable:true
		AILinks_Node2 type:#intTab tabSizeVariable:true
		AILinks_Width type:#floattab tabSizeVariable:true
		AILinks_Type type:#intTab tabSizeVariable:true
		AILinks_OneWay type:#boolTab tabSizeVariable:true
		AILinks_Interior type:#boolTab tabSizeVariable:true
		AILinks_Loop type:#boolTab tabSizeVariable:true
		AILinks_Water type:#boolTab tabSizeVariable:true
		
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
		iconMat = undefined
		mats = for mat in scenematerials where mat.name == "sys_AIRoutesIconMat" collect mat
		format "Mat Count: %\n" mats.count
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
		format "Icon Mat: %\n" iconMat
		showTextureMap iconMat on
		--IconMesh = createInstance plane width:1 lengthsegs:1 widthsegs:1 material:iconMat -- 
		--material = iconMat
		m = trimesh()
		verts = #([0.5,0.5,0],[0.5,-0.5,0],[-0.5,0.5,0],[-0.5,-0.5,0])
		faces = #([1,2,3],[2,4,3])
		tverts = #([1,1,0], [1,0,0], [0,1,0], [0,0,0])
		setNumVerts m 4
		setVert m 1 verts[1]
		setVert m 2 verts[2]
		setVert m 3 verts[3]
		setVert m 4 verts[4]
		setNumTVerts m 4
		setTVert m 1 tverts[1]
		setTVert m 2 tverts[2]
		setTVert m 3 tverts[3]
		setTVert m 4 tverts[4]
		setNumFaces m 2
		setFace m 1 faces[1]
		setFace m 2 faces[2]
		
		
		thisNode.material = iconMat
		setmesh mesh vertices:#([0.5,0.5,0],[0.5,-0.5,0],[-0.5,0.5,0],[-0.5,-0.5,0]) faces:#([1,2,3],[2,4,3])
		
		setNumTVerts mesh 4
		setTVert mesh 1 tverts[1]
		setTVert mesh 2 tverts[2]
		setTVert mesh 3 tverts[3]
		setTVert mesh 4 tverts[4]
		buildTVFaces mesh
		
		setTVFace mesh 1 faces[1]
		setTVFace mesh 2 faces[2]
		
	)
	rollout RouteParameters "Route Parameters"
	(
		button tstbutton "Test"
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