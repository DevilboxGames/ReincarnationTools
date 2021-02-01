fn LinkAINodes node1 node2 width:1.0 = (
	aiLinkObj = AILink()
	aiLinkObj.Node1 = nodeTransformMonitor node:node1 forwardTransformChangeMsgs:false
	aiLinkObj.Node2 = nodeTransformMonitor node:node2 forwardTransformChangeMsgs:false
	aiLinkObj.Width= width;
	v = Node2.pos - Node1.pos
	vLen = length v
	vLen -= Node1.Radius + Node2.Radius
	vLen = vLen / 2
	vLen += Node1.Radius
	vNorm = normalize v
	--format " Node1 pos: %\n Node2 pos: %\n v: %\n vLen: %\n vNorm: %\n" Node1.pos  Node2.pos v vLen vNorm
	aiLinkObj.pos = vNorm * (vLen ) + Node1.pos

	aiLinkObj.ForceMeshUpdate = true
/*
			aiLinkObj.node1ChangeHandler = when transform Node1 changes do
			(
				ForceMeshUpdate = true
			)
			aiLinkObj.node2ChangeHandler = when transform Node2 changes do
			(
				ForceMeshUpdate = true
			)*/
)
fn ZE_Cam cam objs =
(
	local max2, fov, asp, v-- declare local variables
	-- define a function that returns the maximum value
	-- of a set of values in an array
	fn maxof vals = (local v=vals[1];for v1 in vals do (if v1 > v do v=v1);v)
	fov=0-- initialize the fov value
	asp=(renderWidth as float)/renderHeight-- calculate the renderer's image aspect ratio
	in coordsys cam-- work in coordinate system ofthe camera
	(
		for obj in objs where obj != cam do-- loop across all objects except the camera
		(
			if obj.min.z >=0 do continue-- if object is behind camera, skip it
			-- get max value of the object's bounding box, correcting for the image aspect ratio
			-- in the y values
			v = maxof #((abs obj.max.x),(abs obj.min.x),(abs (obj.max.y*asp)),(abs (obj.min.y*asp)))
			fov = maxof #(fov,(2*atan(-v/obj.min.z)))-- increase fov if needed
		)
	)
	cam.fov=fov-- set the camera's fov to the new fov value
)
fn GenerateAccessoryScreenshot accessoryName rootObject = (
	screenshotPath = (getFileNamePath (getThisScriptFilename()))+"UI\\Accessories\\"+accessoryName+".png"

	oldFramerate= frameRate
	frameRate = 5

	StopNullNodesRendering()
	makeDir (getFilenamePath screenshotPath)

	clearSelection()
	select rootObject
	for obj in selection do (
		if obj.children.count > 0 then (
			selectmore (for child in obj.children where (iskindof child GeometryClass) collect child)
		)
	)
	cam = Freecamera pos:$.center rotation:(eulerAngles -35.2644 30 35.2644)
	in coordsys cam (
		cam.pos = [0,0,1000]
	)
	lowestPoint = $.min.z
	ZE_Cam cam $
	startRotation = rootObject.rotation
	startPos = rootObject.position
	with animate on (
		at time 0 (
			rootObject.rotation = startRotation
			rootObject.pos = startPos
		)
		at time 1 (
			rootObject.rotation = ((eulerAngles 0 0 90) as quat) + rootObject.Rotation
			rootObject.position = startPos
		)
		at time 2 (
			rootObject.rotation = ((eulerAngles 0 0 90) as quat) + rootObject.Rotation
			rootObject.position = startPos
		)
		at time 3 (
			rootObject.rotation = ((eulerAngles 0 0 90) as quat) + rootObject.Rotation
			rootObject.position = startPos
		)
		at time 4 (
			rootObject.rotation = ((eulerAngles 0 0 90) as quat) + rootObject.Rotation
			rootObject.position = startPos
		)
	)
	lit = Directionallight pos:$.center rotation:(eulerAngles 24.94 -35.0399 -180) hotspot:400 falloff:400 castshadows:true raytracedShadows:true
	lit.shadowGenerator = Adv__Ray_Traced()
	in coordsys lit ( 
		lit.pos = [0,0,600]
	)
	lit2 = Directionallight pos:$.center rotation:(eulerAngles -35.2644 30 35.2644) hotspot:400 falloff:400 multiplier:1.0 castshadows:false raytracedShadows:false
	in coordsys lit2 ( 
		lit2.pos = [0,0,600]
	)
	ground = plane width:100000 length:1000 material:(MatteShadow()) pos:[0,0,lowestPoint]
	render camera:cam outputsize:[128,128] outputfile:screenshotPath vfb:off framerange:#active fromframe:0 toFrame:3
	frameRate = oldFramerate
	--delete cam
	--delete lit
	--delete lit2
	--delete ground

)
fn GenerateSingleAccessoryScreenshot accessoryName = (
	accessoryFolder = CarmaSettings.DataCorePath+"\\Content\\Accessories\\"+accessoryName
	rootObject = ImportCNT (accessoryFolder+"\\accessory.cnt") importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
	GenerateAccessoryScreenshot accessoryName rootObject
			
)
fn GenerateAllAccessoryScreenshots startIndex:1 limit:10 = (
	global CarmaSettings
	local accessoriesPath = CarmaSettings.DataCorePath+"\\Content\\Accessories\\"
	accessoryFolders = getDirectories (accessoriesPath+"*")
	numAccessories = accessoryFolders.count
	format "Converting % accessories from %\n" numAccessories accessoriesPath
	i = startIndex
	numThumbnailed = 0
	numErrors = 0
	if limit > 0 and limit < numAccessories then (
		numAccessories = limit
	)

	format "Converting % accessories from %\n" numAccessories accessoriesPath
	while i <= numAccessories do (
		accessoryFolder = accessoryFolders[i]
		if (getFiles (accessoryFolder+"\\accessory.cnt")) != 0 then (
			rootObject = ImportCNT (accessoryFolder+"\\accessory.cnt") importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
			GenerateAccessoryScreenshot (GetFolderName accessoryFolder) rootObject
			numThumbnailed = numThumbnailed + 1
			delete objects
		)
		i = i + 1
	)

)

fn GenerateTestGrid size:[10,10,5] = (

	local nodes = #()
	for x = 1 to size.x do (
		nodes[x] = #()
		for y = 1 to size.y do (

			nodes[x][y] = #()
			for z = 1 to size.z do (

				nodes[x][y][z] = AINode pos:([x,y,z]*2) radius:0.5
				if z > 1 then LinkAINodes nodes[x][y][z-1]  nodes[x][y][z] width:0.1
				if y > 1 then LinkAINodes nodes[x][y-1][z]  nodes[x][y][z] width:0.1
				if x > 1 then LinkAINodes nodes[x-1][y][z]  nodes[x][y][z] width:0.1
			)
		)
	)
)

struct AccessoryListItem (
	Name,
	Path,
	Image1,
	Image2,
	Image3,
	Image4
)
AccessoriesListItems = #()
struct MouseHitResponse (
	Hit,
	Object,
	Face,
	FaceCoords
)
rollout accessory_pallete_rollout "Accessory Placement" width:300 height:650
(
	local tempAccessories, tempLayer
	group "Tools" (
		button btn_PlaceAccessory "Place Accessory" across:2
		dropdownlist dpdn_Tool "Current Tool" items:#("Single", "Brush", "Line", "Curve", "Scatter", "Stamp")
		edittext txt_Layer "Race Layer" text:"Level"
	)
	group "Placement Settings" (
		checkbox chk_AlignWithGroundNormal "Orient to ground slope" default:true across:2
		checkbox chk_AlignWithGroundPosition "Align to ground height" default:true across:2
		dropdownlist dpdn_AlignWithDirection "Direction" items:#("Tool Rotation", "Follow Path", "World Aligned", "Random") across:2
		dropdownlist dpdn_ToolDirection "Tool Rotation" items:#("All", "Last", "Blend") across:2
		dropdownlist dpdn_PlacementRule "Placement Mode" items:#("Count", "Distance/Area", "Random")
		label lbl_PlacementValue "Setting 1" across:2
		label lbl_PlacementValue2 "Setting 2" across:2
		spinner spn_PlacementValue "" range:[0,1000,10] across:2
		spinner spn_PlacementValue2 "" range:[0,1000,10] across:2
		dropdownlist dpdn_ScatterType "Scatter type" items:#("Circle", "Square", "Face", "Object")
	)
	group "Accessories" (
		dotNetControl lv_Accessories "CMDControls.AccessoryList" height: 350 width:250
	)

	fn UpdateToolsUI = (

				dpdn_ScatterType.visible = false
				spn_PlacementValue.enabled = false
				spn_PlacementValue2.enabled = false
				spn_PlacementValue2.visible = false
				spn_PlacementValue.visible = false
				lbl_PlacementValue.text = ""
				lbl_PlacementValue2.text = ""
		case dpdn_Tool.selected of (
			"Single": (
				dpdn_ScatterType.visible = false
				spn_PlacementValue.enabled = false
				spn_PlacementValue2.enabled = false
				spn_PlacementValue2.visible = false
				spn_PlacementValue.visible = false
				lbl_PlacementValue.text = ""
				lbl_PlacementValue2.text = ""
			)
			"Brush": (
				lbl_PlacementValue.text = "Placement Distance"
				spn_PlacementValue.enabled = true
				spn_PlacementValue2.enabled = false
				spn_PlacementValue2.visible = false
						spn_PlacementValue.visible = true
				lbl_PlacementValue2.text = ""
			)
			"Line": (
				case dpdn_PlacementRule.selected of (
					"Count":(
						lbl_PlacementValue.text = "Count"
						spn_PlacementValue.enabled = true
						spn_PlacementValue2.enabled = false
						spn_PlacementValue2.visible = false
						spn_PlacementValue.visible = true
						lbl_PlacementValue2.text = ""
					)
					"Distance":(
						lbl_PlacementValue.text = "Distance"
						spn_PlacementValue.enabled = true
						spn_PlacementValue2.enabled = false
						spn_PlacementValue2.visible = false
						spn_PlacementValue.visible = true
						lbl_PlacementValue2.text = ""
					)
				)
			)
			"Scatter": (

				dpdn_ScatterType.visible = true
						lbl_PlacementValue.text = "Count"
						spn_PlacementValue.enabled = true
						spn_PlacementValue2.enabled = true
						spn_PlacementValue2.visible = true
						spn_PlacementValue.visible = true
						lbl_PlacementValue2.text = "Radius"
			)
		)
	)
	on accessory_pallete_rollout open do (
		global AccessoriesListItems
		lv_Accessories.GameDirectory = CarmaSettings.GamePath
		lv_Accessories.IconDirectory =  (getFileNamePath (getThisScriptFilename()))+"UI\\Accessories\\"
		lv_Accessories.Size = dotNetObject "System.Drawing.Size" 250 300
		lv_Accessories.GetAccessoriesList()
		UpdateToolsUI()
		
	)

	on dpdn_Tool selected i do (
		UpdateToolsUI()
	)
	on dpdn_PlacementRule selected i do (
		UpdateToolsUI()
	)

	fn FinaliseAccessories = (
		if tempAccessories.count > 0 then (
			format "Finalising % accessories\n" tempAccessories.count 
			local layerObject = LayerManager.getLayerFromName txt_Layer.text
			if layerObject == undefined then
			(
				layerObject= LayerManager.newLayerFromName txt_Layer.text
			)
			for accessory in tempAccessories do (
				layerObject.addnode accessory
			)
			tempAccessories = #()
		)
	)
	fn PlaceAccessory accessoryName accessoryFilename trans isPowerup:false = (
		local accessory = CarmaHelper_AccessoryPlaceholder()
		accessory.name = accessoryName
		accessory.isPowerup = isPowerup
		accessory.accessoryType = accessoryName
		accessory.accessoryFileName = accessoryFilename + "\\accessory.cnt"
		accessory.transform = trans
		
		tempLayer.addnode accessory
		append tempAccessories accessory
	)
	fn GetMouseObjectHit viewPoint = (
		local foundObj = undefined
		local nearestDist = undefined
		local foundHit = undefined
		local hits = 0
		local mouseRay = mapScreenToWorldRay viewPoint 
		for obj in objects where (isKindOf obj geometryclass) and (classof obj) != CarmaHelper_AccessoryPlaceholder do (
			local editModifier = undefined
			if (classof obj) != Editable_mesh then (
				editModifier =Edit_Mesh()
				addModifier obj editModifier
			)
					
			local hit = IntersectRayEx obj mouseRay

			if editModifier != undefined then (
				deleteModifier obj editModifier
				free editModifier
			)
			
			if hit != undefined then(
				hits = hits + 1
				local dist = distance hit[1].pos mouseRay.pos
				
				if(nearestDist == undefined or dist < nearestDist) then (
					foundObj = obj
					nearestDist = dist
					foundHit = hit
				)
			)
		) 

		if foundHit == undefined then (
			local rayPos = (mouseRay.position + mouseRay.dir * 100)
			local rayDir = [0,0,1]
			foundHit = #((ray rayPos rayDir), -1, [0,0,0])
		)
		MouseHitResponse Hit:foundHit[1] Object:foundObj Face:foundHit[2] FaceCoords:foundHit[3]
	)
	fn GetMouseHit viewPoint = (
		local foundObj = undefined
		local nearestDist = undefined
		local foundHit = undefined
		local hits = 0
		local mouseRay = mapScreenToWorldRay viewPoint 
		for obj in objects where (isKindOf obj geometryclass) and (classof obj) != CarmaHelper_AccessoryPlaceholder and (classof obj) != AILink  and (classof obj) != AINode/* and (tempAccessories.count == 0 or obj != tempAccessories[tempAccessories.count])*/ do (
			local hit = intersectRay obj mouseRay
			if hit != undefined then(
				hits = hits + 1
				local dist = distance hit.pos mouseRay.pos
				
				if(nearestDist == undefined or dist < nearestDist) then (
					foundObj = obj
					nearestDist = dist
					foundHit = hit
				)
			)
		) 

		if foundHit == undefined then (
			local rayPos = (mouseRay.position + mouseRay.dir * 100)
			local rayDir = [0,0,1]
			foundHit = ray rayPos rayDir
		)
		foundHit
	)

	fn GetMouseHitAgainstPlane viewPoint planePos planeNormal = (

		local mouseRay = mapScreenToWorldRay viewPoint 
		local t = (dot (planePos - mouseRay.pos) planeNormal) / (dot mouseRay.dir planeNormal)
		mouseRay.pos + mouseRay.dir * t
	)
	fn CheckClickInViewport viewpoint  = (

		local viewportSize = getViewSize()
		viewPoint.x >= 0 and viewPoint.y >= 0 and viewPoint.x < viewportSize.x and viewPoint.y < viewportSize.y
	)
	fn UpdateAccessoryPosition accessoryObject position:undefined rotation:undefined scale:undefined = (
		if position != undefined then (
			accessoryObject.pos = position
		)
		if rotation != undefined then (
			accessoryObject.rotation = rotation
		)
		if scale != undefined then (
			accessoryObject.scale = scale
		)
	)

	fn MakeOrientationMatrix groundNormal:[0,0,1] pathDirection:[0,1,0] position:[0,0,0] = (
		local xAxis = cross (normalize groundNormal) (normalize pathDirection)
		local yAxis = cross (normalize groundNormal) (normalize xAxis)
		matrix3 (normalize xAxis) (normalize yAxis) (normalize groundNormal) position
	)

	fn GetOrientation viewPoint direction = (
		local hit = GetMouseHit viewPoint
		local groundNormal = [0,0,1]
		if chk_AlignWithGroundNormal.checked then (
			groundNormal = hit.dir
		)
		MakeOrientationMatrix groundNormal:groundNormal pathDirection:direction position:hit.position
	)
	fn FaceAccessoryInToolDirection accessoryObject viewPoint = (

		local hit = GetMouseHitAgainstPlane viewPoint accessoryObject.pos accessoryObject.transform.row3
		local trans = MakeOrientationMatrix groundNormal:accessoryObject.transform.row3 pathDirection:(normalize (hit - accessoryObject.pos)) position:accessoryObject.pos
		accessoryObject.transform = trans
	)

	fn SingleAccessoryClick viewPoint moveToMouse:false lookAtMouse:false = (

		if tempAccessories.count == 0 then (
			local trans = GetOrientation viewPoint [0,1,0]
			PlaceAccessory lv_Accessories.SelectedAccessory.name lv_Accessories.SelectedAccessory.Path trans
		)
		else (
				lastAccessory = tempAccessories[tempAccessories.count]
			if dpdn_AlignWithDirection.selected =="Tool Rotation" and lookAtMouse then (
				FaceAccessoryInToolDirection lastAccessory viewPoint
			)
			if moveToMouse then (

				lastAccessory.transform = GetOrientation viewPoint (-lastAccessory.transform.row3)
			)
		)
	)

	fn ScatterAccessoryClick viewPoint moveToMouse:false lookAtMouse:false = (
		max create mode
			local numToPlace = spn_PlacementValue.value
			local radius = spn_PlacementValue2.value
			local numPerArea = numToPlace/radius
			local placeNewAccessories = false
			if tempAccessories.count < 1 then (
				placeNewAccessories = true
			)

			case dpdn_ScatterType.selected of (
				"Circle": (
				)
				"Square": (

				)
				"Face": (
					local hitInfo = GetMouseObjectHit viewPoint
					if hitInfo.Object != undefined then (
						local editModifier = undefined
						if (classof obj) != Editable_mesh then (
							editModifier =Edit_Mesh()
							addModifier hitInfo.Object editModifier
						)
						local faceArea = meshop.getFaceArea hitInfo.Object hitInfo.face
						seed (timeGetTime())
						case dpdn_PlacementRule.selected of (
							"Count": (
								numPerArea = ceil (numToPlace / faceArea)
						 	)
						 	"Distance/Area": (
						 		numPerArea = spn_PlacementValue.value
						 		numToPlace = ceil (numPerArea * faceArea)
					 		)
					 		"Random": (
					 			numToPlace = random 1 numToPlace
								numPerArea = ceil (numToPlace / faceArea)
				 			)
						)
						--format "Placement rule: % / FaceArea: % / NumPerArea: % / NumToPlace: %\n" dpdn_PlacementRule.selected faceArea numPerArea numToPlace
						local face = getFace hitInfo.Object hitInfo.face
						local v1 = getVert hitInfo.Object face.x
						local v2 = getVert hitInfo.Object face.y
						local v3 = getVert hitInfo.Object face.z
						while tempAccessories.count > numToPlace do (
							accessoryToDelete = tempAccessories[tempAccessories.count]
							deleteItem tempAccessories tempAccessories.count
							delete accessoryToDelete
						)
						if editModifier != undefined then (
							deleteModifier hitInfo.Object editModifier
							free editModifier
						)
						for i = 1 to numToPlace do (
							local xPos = random 0.0 1.0
							local yPos = random 0.0 1.0
							if xPos + yPos > 1.0 then (
								xPos = 1.0 - xPos
								yPos = 1.0 - yPos
							)
							local zPos = 1 - (xPos + yPos)
							local groundNormal = [0,0,1]

							local newpos = v1 * xPos + v2 * yPos + v3 * zPos
							if chk_AlignWithGroundNormal.checked then (
								groundNormal = hitInfo.Hit.dir
							)
							if moveToMouse == false and i <= tempAccessories.count and placeNewAccessories == false then (
								newPos = tempAccessories[i].pos
							)
							local trans = MakeOrientationMatrix groundNormal:groundNormal pathDirection:[0,1,0] position:newpos
							if placeNewAccessories or i > tempAccessories.count then (
								PlaceAccessory lv_Accessories.SelectedAccessory.name lv_Accessories.SelectedAccessory.Path trans
							)
							else (
								curAccessory = tempAccessories[i]
								curAccessory.transform = trans
								tempAccessories[i] = curAccessory
							)
						)
					)
				)
				"Object": (

				)
			)

		
	)
	tool placeAccessoryTool (
		on start do (
			tempAccessories = #()
			tempLayer = LayerManager.getLayerFromName "sys_AccessoryPlacementTool"
			if tempLayer == undefined then (
				tempLayer= LayerManager.newLayerFromName "sys_AccessoryPlacementTool"
			)
			local trans = matrix3 1
			trans.pos = [0,0,0]
			PlaceAccessory lv_Accessories.SelectedAccessory.name lv_Accessories.SelectedAccessory.Path trans
		)
		on stop do (
			FinaliseAccessories()
		)
		on mousePoint click do (
			case dpdn_Tool.selected of (
				"Single": (
					if (CheckClickInViewport viewPoint) and (click > 1 or lbutton == false) then (

						SingleAccessoryClick viewPoint
						FinaliseAccessories()
					)
					--stopTool placeAccessoryTool
				)
				"Brush": (
					if (CheckClickInViewport viewPoint) and (click > 1 or lbutton == false) then (
						if click == 1 then (
							SingleAccessoryClick viewPoint
						)
							FinaliseAccessories()
						
					)
				)
				"Scatter": (
					if (CheckClickInViewport viewPoint) then (
						ScatterAccessoryClick viewPoint moveToMouse:true
					)
					FinaliseAccessories()
				)
			)
		)
		on mouseMove click do (
			case dpdn_Tool.selected of (
				"Single": (
					if (CheckClickInViewport viewPoint) then (

						if lbutton then (
							SingleAccessoryClick viewPoint lookAtMouse:true
						)
						else  (
							SingleAccessoryClick viewPoint moveToMouse:true
						)
					)
				)
				"Brush": (
					if (CheckClickInViewport viewPoint) then (

						if lbutton then (
							SingleAccessoryClick viewPoint lookAtMouse:true
							hit = GetMouseHit viewPoint
							if (distance hit.pos tempAccessories[tempAccessories.count].pos) > spn_PlacementValue.value then (
								FinaliseAccessories()
							)
						)
						else  (
							SingleAccessoryClick viewPoint moveToMouse:true
						)
					)
				)
				"Scatter": (
					if (CheckClickInViewport viewPoint) then (

						if lbutton then (
							ScatterAccessoryClick viewPoint lookAtMouse:true
						)
						else (
							ScatterAccessoryClick viewPoint moveToMouse:true
						)
					)
				)
			)
		)
		on freeMove do (

			case dpdn_Tool.selected of (
				"Single": (
					if (CheckClickInViewport viewPoint) then (
						SingleAccessoryClick viewPoint moveToMouse:true
					)
				)
				"Brush": (
					if (CheckClickInViewport viewPoint) then (
						SingleAccessoryClick viewPoint moveToMouse:true
					)
				)
				"Scatter": (
					if (CheckClickInViewport viewPoint) then (
						ScatterAccessoryClick viewPoint moveToMouse:true
					)
				)
			)
		)
		on mouseAbort click do (
			select tempAccessories
			if selection.count > 0 then (
				delete selection
			)
			tempAccessories = #()
		)
	)

	on btn_PlaceAccessory pressed do (
		startTool placeAccessoryTool
	)
)

fn OpenAccessoryPlacementFloater = (
	if accessory_pallete_rollout.open then (
		DestroyDialog accessory_pallete_rollout
	)
	floater = createDialog accessory_pallete_rollout style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar accessory_pallete_rollout style:#(#cui_floatable,#cui_dock_left,#cui_handles) minSize:[300,500] maxSize:[-1,-1]

	floater
)