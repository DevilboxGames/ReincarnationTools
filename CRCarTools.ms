fn GetJointAxisByVertexColour obj vertColor =
(
	[1,0,0]
)
fn SetAllCNTsToBakeScale obj =
(
	if obj.modifiers["CNT Hierarchy"] != undefined then
	(
		obj.modifiers["CNT Hierarchy"].BakeScaleIntoMesh = true
	)
	for i=1 to obj.children.count do SetAllCNTsToBakeScale obj.children[i]
)

fn AddVehilceCFGModifier obj =
(
	max modify mode
	structPartModifier = emptyModifier()
	
	structPartModifier.name = "vehicle_setup.cfg"
	addModifier obj structPartModifier
	custattributes.add structPartModifier VehicleSetupCFGAttribute baseObject:false
	structPartModifier
)

fn AddStructureAxleModifer obj =
(
	max modify mode
	structAnimModifier = emptyModifier()
	structAnimModifier.name = "Wishbone Axle"
	addModifier obj structAnimModifier
	custattributes.add structAnimModifier StructureWishboneAxleAttributes baseObject:false
	structAnimModifier
)
fn AddStructureWishboneMountModifer obj =
(
	max modify mode
	structAnimModifier = emptyModifier()
	structAnimModifier.name = "Wishbone Mount"
	addModifier obj structAnimModifier
	custattributes.add structAnimModifier StructureWishboneMount baseObject:false
	structAnimModifier
)
fn AddStructureWishboneHubModifer obj =
(
	max modify mode
	structAnimModifier = emptyModifier()
	structAnimModifier.name = "Wishbone Hub"
	addModifier obj structAnimModifier
	custattributes.add structAnimModifier StructureWishboneHub baseObject:false
	structAnimModifier
)
fn AddStructureWishboneTrailingArmModifer obj =
(
	max modify mode
	structAnimModifier = emptyModifier()
	structAnimModifier.name = "Wishbone Trailing Arm"
	addModifier obj structAnimModifier
	custattributes.add structAnimModifier StructureTrailingArm baseObject:false
	structAnimModifier
)

fn AddStructureAnimationModifer obj =
(
	max modify mode
	structAnimModifier = emptyModifier()
	structAnimModifier.name = "Part Animation"
	addModifier obj structAnimModifier
	custattributes.add structAnimModifier StructureAnimationAttributes baseObject:false
	structAnimModifier
)

fn AddStructurePointToPointModifer obj =
(
	max modify mode
	structAnimModifier = emptyModifier()
	structAnimModifier.name = "Point To Point Animation"
	addModifier obj structAnimModifier
	custattributes.add structAnimModifier StructureRotatePointToPointAttribute baseObject:false
	structAnimModifier
)
fn AddStructureWeldModifier obj =
(
	max modify mode
	structPartModifier = emptyModifier()
	
	structPartModifier.name = "Car Weld"
	addModifier obj structPartModifier
	custattributes.add structPartModifier StructureWeldAttribute baseObject:false
	structPartModifier
)

fn AddStructureCharacteristicsModifier obj =
(
	if (IsObjectAStructureCharacteristic obj)==false then
	(
		max modify mode
		structPartModifier = emptyModifier()
		structPartModifier.name = "Car Characteristics"
		addModifier obj structPartModifier
		custattributes.add structPartModifier StructureCharacteristicsAttribute baseObject:false
		
	)
)

fn AddStructurePartModifier obj doChildren:false =
(
	if (IsObjectAStructurePart obj)==false then
	(
		max modify mode
		structPartModifier = emptyModifier()
		structPartModifier.name = "Car Structure Part"
		addModifier obj structPartModifier
		custattributes.add structPartModifier StructurePartAttribute baseObject:false
		
	)
	
	if doChildren == true then for i=1 to obj.children.count do
	(
		AddStructurePartModifier obj.children[i] doChildren:true
	)
)
fn AddStructPartButton_Pressed sender arg =
(
	undo "Set As Structure Part" on
	(
		for obj in (selection as array) do
		(
			if (IsObjectACNT obj) == false then SetToCNTNodes obj
			
			AddStructurePartModifier obj
		)
	)
)
fn AddTrailingArm_Pressed sender arg =
(
	undo "Set As Trailing Arm" on
	(
		AddStructureWishboneTrailingArmModifer $
	)
)
fn AddWishboneHub_Pressed sender arg =
(
	undo "Set As Hub" on
	(
		AddStructureWishboneHubModifer $
	)
)

fn AddWishboneMount_Pressed sender arg =
(
	undo "Set As Mount" on
	(
		AddStructureWishboneMountModifer $
	)
)
fn AddWishboneAxle_Pressed sender arg =
(
	undo "Set As Axle" on
	(
		AddStructureAxleModifer $
	)
)
fn AddPointToPointButton_Pressed sender arg =
(
	undo "Add Point To Point Animation" on
	(
		AddStructurePointToPointModifer $
	)
)
fn AddAnimationButton_Pressed sender arg =
(
	undo "Add Standard Animation" on
	(
		AddStructureAnimationModifer $
	)
)
fn AddWeldButton_Pressed sender arg =
(
	undo "Add Weld" on
	(
		AddStructureWeldModifier $
	)
)
fn SetupCarStructureButton_Pressed sender arg =
(
	undo "Setup Car Structure" on
	(
		AddStructureCharacteristicsModifier selection[1]
		AddVehilceCFGModifier selection[1]
		AddStructurePartModifier selection[1] doChildren:true
	)
)

fn SetCarWheelType mdl wheeltype ignoreCheck:false =
(
	if (IsObjectAWheel mdl) or ignoreCheck do
	(
		format "Setting % wheel type to: %\n" mdl.name wheeltype
		if wheelType == "Wheel_FR" then append mdl.modifiers["Car Structure Part"].PhysicsProperties "FRONT_RIGHT_WHEEL"
		else if wheelType == "Wheel_FL" then append mdl.modifiers["Car Structure Part"].PhysicsProperties "FRONT_LEFT_WHEEL"
		else if wheelType == "Wheel_RR" then append mdl.modifiers["Car Structure Part"].PhysicsProperties "REAR_RIGHT_WHEEL"
		else if wheelType == "Wheel_RL" then append mdl.modifiers["Car Structure Part"].PhysicsProperties "REAR_LEFT_WHEEL"
		--mdl.CarWheelAttrib.WheelType = wheeltype
		--mdl.CarWheelAttrib.WheelTypeID = (finditem WheelTypes wheeltype)
	)
)

fn CreateJointHelper obj =
(
	if obj != undefined then jointName = "Joint_"+obj.name
	else jointName = "Joint_Helper_"
	m = CarmaHelper_JointHelper prefix:(jointName)
	
	m
)

fn CreateJointButton_Pressed sender arg =
(
	undo "Create Joint Helper" on
	(
		j = CreateJointHelper $
		if $ != undefined then j.position = $.position
	)
)

fn CreateHelperPoint_Pressed sender arg =
(
	undo "Create Helper Point" on
	(
		
		if $ != undefined then 
		(
			for obj in (selection as array) do
			(
				newDummyName = "Position_Helper_"+obj.name
				newDummyPosition = obj.position
				newDummy = point prefix:newDummyName position:newDummyPosition						
				newDummy.size = 1
				--newDummy.axistripod = true
				newDummy.cross = true
			)
		)
		else
		(
			newDummyPosition = [0,0,0]
			newDummyName = "Position_Helper_"
			newDummy = point prefix:newDummyName position:newDummyPosition						
			newDummy.size = 1
			--newDummy.axistripod = true
			newDummy.cross = true
		)
		
	)
)

fn CreateNewWheelNode trans wheelType selectAndFocus:false addAttributes:true wheelName:"default_eagle_R" =
(
	/*m = mesh vertices:#([-0.163197, 0.0, -0.316496],[-0.163197, 0.108248, -0.297409],[-0.163198, 0.20344, -0.24245],[-0.163198, 0.274093, -0.158248],[-0.163198, 0.311688, -0.0549589],[-0.163198, 0.311688, 0.0549589],[-0.163198, 0.274093, 0.158248],[-0.163198, 0.20344, 0.24245],[-0.163198, 0.108248, 0.297409],[-0.163198, 0.0, 0.316496],[-0.163198, -0.108248, 0.297409],[-0.163198, -0.20344, 0.24245],[-0.163198, -0.274093, 0.158248],[-0.163198, -0.311687, 0.054959],[-0.163198, -0.311688, -0.0549588],[-0.163198, -0.274093, -0.158248],[-0.163198, -0.20344, -0.24245],[-0.163198, -0.108248, -0.297409],[0.0, 0.122818, -0.33744],[0.0, 0.230822, -0.275083],[0.0, 0.310986, -0.179548],[0.0, 0.35364, -0.0623563],[0.0, 0.35364, 0.0623563],[0.0, 0.310986, 0.179548],[0.0, 0.230822, 0.275083],[0.0, 0.122818, 0.33744],[0.0, 0.0, 0.359096],[0.0, -0.122818, 0.33744],[0.0, -0.230822, 0.275083],[0.0, -0.310986, 0.179548],[0.0, -0.35364, 0.0623564],[0.0, -0.35364, -0.0623562],[0.0, -0.310986, -0.179548],[0.0, -0.230822, -0.275083],[0.0, -0.122818, -0.33744],[0.0, 0.0, -0.359096],[0.163197, 0.0, -0.316496],[0.163197, 0.108248, -0.297409],[0.163197, 0.20344, -0.24245],[0.163197, 0.274093, -0.158248],[0.163197, 0.311688, -0.0549589],[0.163197, 0.311688, 0.0549589],[0.163197, 0.274093, 0.158248],[0.163197, 0.20344, 0.24245],[0.163197, 0.108248, 0.297409],[0.163197, 0.0, 0.316496],[0.163197, -0.108248, 0.297409],[0.163197, -0.20344, 0.24245],[0.163197, -0.274093, 0.158248],[0.163197, -0.311687, 0.054959],[0.163197, -0.311688, -0.0549588],[0.163197, -0.274093, -0.158248],[0.163197, -0.20344, -0.24245],[0.163197, -0.108248, -0.297409],[0.163197, 0.0, -0.275879],[0.163197, 0.0943561, -0.259241],[0.163197, 0.177331, -0.211335],[0.163197, 0.238918, -0.137939],[0.163197, 0.271688, -0.0479058],[0.163197, 0.271688, 0.0479059],[0.163197, 0.238918, 0.137939],[0.163197, 0.177331, 0.211335],[0.163197, 0.0943561, 0.259241],[0.163197, 0.0, 0.275879],[0.163197, -0.094356, 0.259241],[0.163197, -0.177331, 0.211335],[0.163197, -0.238918, 0.137939],[0.163197, -0.271687, 0.0479059],[0.163197, -0.271688, -0.0479057],[0.163197, -0.238918, -0.137939],[0.163197, -0.177332, -0.211335],[0.163197, -0.0943563, -0.259241],[-0.0768025, 0.0, -0.275879],[-0.0768025, 0.0943561, -0.259241],[-0.0768026, 0.177331, -0.211335],[-0.0768026, 0.238918, -0.137939],[-0.0768026, 0.271688, -0.0479059],[-0.0768025, 0.271688, 0.0479058],[-0.0768026, 0.238918, 0.137939],[-0.0768026, 0.177331, 0.211335],[-0.0768026, 0.0943561, 0.259241],[-0.0768026, 0.0, 0.275879],[-0.0768025, -0.094356, 0.259241],[-0.0768026, -0.177331, 0.211335],[-0.0768026, -0.238918, 0.137939],[-0.0768025, -0.271687, 0.0479059],[-0.0768025, -0.271688, -0.0479057],[-0.0768026, -0.238918, -0.137939],[-0.0768026, -0.177332, -0.211335],[-0.0768025, -0.0943563, -0.259241]) faces:#([1.0, 2.0, 19.0],[19.0, 36.0, 1.0],[2.0, 3.0, 20.0],[20.0, 19.0, 2.0],[3.0, 4.0, 21.0],[21.0, 20.0, 3.0],[4.0, 5.0, 22.0],[22.0, 21.0, 4.0],[5.0, 6.0, 23.0],[23.0, 22.0, 5.0],[6.0, 7.0, 24.0],[24.0, 23.0, 6.0],[7.0, 8.0, 25.0],[25.0, 24.0, 7.0],[8.0, 9.0, 26.0],[26.0, 25.0, 8.0],[9.0, 10.0, 27.0],[27.0, 26.0, 9.0],[10.0, 11.0, 28.0],[28.0, 27.0, 10.0],[11.0, 12.0, 29.0],[29.0, 28.0, 11.0],[12.0, 13.0, 30.0],[30.0, 29.0, 12.0],[13.0, 14.0, 31.0],[31.0, 30.0, 13.0],[14.0, 15.0, 32.0],[32.0, 31.0, 14.0],[15.0, 16.0, 33.0],[33.0, 32.0, 15.0],[16.0, 17.0, 34.0],[34.0, 33.0, 16.0],[17.0, 18.0, 35.0],[35.0, 34.0, 17.0],[18.0, 1.0, 36.0],[36.0, 35.0, 18.0],[36.0, 19.0, 38.0],[38.0, 37.0, 36.0],[19.0, 20.0, 39.0],[39.0, 38.0, 19.0],[20.0, 21.0, 40.0],[40.0, 39.0, 20.0],[21.0, 22.0, 41.0],[41.0, 40.0, 21.0],[22.0, 23.0, 42.0],[42.0, 41.0, 22.0],[23.0, 24.0, 43.0],[43.0, 42.0, 23.0],[24.0, 25.0, 44.0],[44.0, 43.0, 24.0],[25.0, 26.0, 45.0],[45.0, 44.0, 25.0],[26.0, 27.0, 46.0],[46.0, 45.0, 26.0],[27.0, 28.0, 47.0],[47.0, 46.0, 27.0],[28.0, 29.0, 48.0],[48.0, 47.0, 28.0],[29.0, 30.0, 49.0],[49.0, 48.0, 29.0],[30.0, 31.0, 50.0],[50.0, 49.0, 30.0],[31.0, 32.0, 51.0],[51.0, 50.0, 31.0],[32.0, 33.0, 52.0],[52.0, 51.0, 32.0],[33.0, 34.0, 53.0],[53.0, 52.0, 33.0],[34.0, 35.0, 54.0],[54.0, 53.0, 34.0],[35.0, 36.0, 37.0],[37.0, 54.0, 35.0],[17.0, 16.0, 15.0],[15.0, 14.0, 13.0],[13.0, 12.0, 11.0],[15.0, 13.0, 11.0],[11.0, 10.0, 9.0],[9.0, 8.0, 7.0],[11.0, 9.0, 7.0],[7.0, 6.0, 5.0],[5.0, 4.0, 3.0],[7.0, 5.0, 3.0],[11.0, 7.0, 3.0],[15.0, 11.0, 3.0],[3.0, 2.0, 1.0],[15.0, 3.0, 1.0],[17.0, 15.0, 1.0],[18.0, 17.0, 1.0],[74.0, 75.0, 76.0],[76.0, 77.0, 78.0],[78.0, 79.0, 80.0],[76.0, 78.0, 80.0],[80.0, 81.0, 82.0],[82.0, 83.0, 84.0],[80.0, 82.0, 84.0],[84.0, 85.0, 86.0],[86.0, 87.0, 88.0],[84.0, 86.0, 88.0],[80.0, 84.0, 88.0],[76.0, 80.0, 88.0],[88.0, 89.0, 90.0],[76.0, 88.0, 90.0],[74.0, 76.0, 90.0],[73.0, 74.0, 90.0],[37.0, 38.0, 56.0],[56.0, 55.0, 37.0],[38.0, 39.0, 57.0],[57.0, 56.0, 38.0],[39.0, 40.0, 58.0],[58.0, 57.0, 39.0],[40.0, 41.0, 59.0],[59.0, 58.0, 40.0],[41.0, 42.0, 60.0],[60.0, 59.0, 41.0],[42.0, 43.0, 61.0],[61.0, 60.0, 42.0],[43.0, 44.0, 62.0],[62.0, 61.0, 43.0],[44.0, 45.0, 63.0],[63.0, 62.0, 44.0],[45.0, 46.0, 64.0],[64.0, 63.0, 45.0],[46.0, 47.0, 65.0],[65.0, 64.0, 46.0],[47.0, 48.0, 66.0],[66.0, 65.0, 47.0],[48.0, 49.0, 67.0],[67.0, 66.0, 48.0],[49.0, 50.0, 68.0],[68.0, 67.0, 49.0],[50.0, 51.0, 69.0],[69.0, 68.0, 50.0],[51.0, 52.0, 70.0],[70.0, 69.0, 51.0],[52.0, 53.0, 71.0],[71.0, 70.0, 52.0],[53.0, 54.0, 72.0],[72.0, 71.0, 53.0],[54.0, 37.0, 55.0],[55.0, 72.0, 54.0],[55.0, 56.0, 74.0],[74.0, 73.0, 55.0],[56.0, 57.0, 75.0],[75.0, 74.0, 56.0],[57.0, 58.0, 76.0],[76.0, 75.0, 57.0],[58.0, 59.0, 77.0],[77.0, 76.0, 58.0],[59.0, 60.0, 78.0],[78.0, 77.0, 59.0],[60.0, 61.0, 79.0],[79.0, 78.0, 60.0],[61.0, 62.0, 80.0],[80.0, 79.0, 61.0],[62.0, 63.0, 81.0],[81.0, 80.0, 62.0],[63.0, 64.0, 82.0],[82.0, 81.0, 63.0],[64.0, 65.0, 83.0],[83.0, 82.0, 64.0],[65.0, 66.0, 84.0],[84.0, 83.0, 65.0],[66.0, 67.0, 85.0],[85.0, 84.0, 66.0],[67.0, 68.0, 86.0],[86.0, 85.0, 67.0],[68.0, 69.0, 87.0],[87.0, 86.0, 68.0],[69.0, 70.0, 88.0],[88.0, 87.0, 69.0],[70.0, 71.0, 89.0],[89.0, 88.0, 70.0],[71.0, 72.0, 90.0],[90.0, 89.0, 71.0],[72.0, 55.0, 73.0],[73.0, 90.0, 72.0])
	m.transform = trans
	m.name = wheelType
	for i=1 to (GetNumFaces m) do
	(
		setFaceSmoothGroup m i 1
	)*/
	
	m = CarmaHelper_WheelPlaceholder()
	global CarmaSettings
	m.wheelType = wheelType
	m.transform = trans
	m.name = wheelType
	m.previewWheel=true
	format "\n\nAbout to set wheel filename to: %\n" (CarmaSettings.DataCorePath+"\\Content\\Vehicles\\Wheels\\"+wheelName+"\\rim.cnt")
	m.wheelFilename = CarmaSettings.DataCorePath+"\\Content\\Vehicles\\Wheels\\"+wheelName+"\\rim.cnt"
	format "Just set wheel filename to: %\n" m.wheelFilename
--	name:wheelType wheelType:CarmaHelper_WheelPlaceholder transform: trans
		
	if addAttributes do
	(
		SetToCNTNodes m nodeType:"NULL"
		m.modifiers["CNT Hierarchy"].BakeScaleIntoMesh = false
	)

	AddStructurePartModifier m
	--custAttributes.add m CarWheelAttribute #unique BaseObject:true
	
	SetCarWheelType m wheelType ignoreCheck:true
	
	if selectAndFocus do
	(
		select m
		max zoomext sel all
	)
	m
)

fn ConvertToWheelNode obj wheelType selectAndFocus:false addAttributes:true wheelName:"default_eagle_R" deleteOldMesh:true =
(
	
			trans = obj.transform
			newWheelNode = CreateNewWheelNode trans wheelType selectAndFocus:selectAndFocus addAttributes:addAttributes wheelName:wheelName
			append obj.parent.children newWheelNode
			for i=obj.children.count to 1 by -1 do
			(
				child = obj.children[i]
				
				append newWheelNode.children child
			)
			if deleteOldMesh then (
				delete obj
			)
			
			newWheelNode
)

fn CreateWheelButton_Pressed sender arg =
(
	
		undo "Create RL Wheel Node" on
		(
			selectedWheel = sender.parent.controls.Item["WheelSelectBox"].Items.Item[sender.parent.controls.Item["WheelSelectBox"].selectedIndex]
			wheelToMake = case selectedWheel of
			(
				"Front Right":
				(
					"Wheel_FR"
				)
				"Front Left":
				(
					"Wheel_FL"
				)
				"Rear Right":
				(
					"Wheel_RR"
				)
				"Rear Left":
				(
					"Wheel_RL"
				)
			)
			trans = matrix3 1
			if selection[1] != undefined do trans = selection[1].transform
			CreateNewWheelNode trans wheelToMake selectAndFocus:false
		)
)
fn ConvertToWheelButton_Pressed sender arg =
(
	
	if selection[1] != undefined do
	(
		undo "Create RL Wheel Node" on
		(
			selectedWheel = sender.parent.controls.Item["WheelSelectBox"].Items.Item[sender.parent.controls.Item["WheelSelectBox"].selectedIndex]
			wheelToMake = case selectedWheel of
			(
				"Front Right":
				(
					"Wheel_FR"
				)
				"Front Left":
				(
					"Wheel_FL"
				)
				"Rear Right":
				(
					"Wheel_RR"
				)
				"Rear Left":
				(
					"Wheel_RL"
				)
			)
			ConvertToWheelNode selection[1] wheelToMake
		)
	)
)

fn Create4WheelsButton_Pressed sender arg =
(
	
		undo "Make All Wheel Nodes" on
		(
			trans = matrix3 1
			whl = CreateNewWheelNode trans "Wheel_FL" selectAndFocus:false
			whl.rotation = (angleaxis 180 [0,0,1]) as quat
			whl.position = [1,-0.83895,0.3591]
			whl = CreateNewWheelNode trans "Wheel_FR" selectAndFocus:false
			whl.position = [-1,-0.83895,0.3591]
			whl = CreateNewWheelNode trans "Wheel_RL" selectAndFocus:false
			whl.rotation = (angleaxis 180 [0,0,1]) as quat
			whl.position = [1,2.16105,0.3591]
			whl = CreateNewWheelNode trans "Wheel_RR" selectAndFocus:false
			whl.position = [-1,2.16105,0.3591]
		)
)
fn DoSetWheelRadiusToPosition obj = 
(
	if (IsObjectAWheel obj) do
	(
		heightOffGround = obj.position.z
		obj.scale = [obj.scale.x, heightOffGround/0.3591, heightOffGround/0.3591]
	)
)
fn DoSetSelectedWheelsRadiusToPosition = 
(			
	for obj in (selection as array) do
	(
		DoSetWheelRadiusToPosition obj 
	)
)

fn SetWheelRadiusToPosButton_Pressed sender arg =
(
	if (IsObjectAWheel selection[1]) do
	(
		undo "Scale Wheel" on
		(	
			DoSetSelectedWheelsRadiusToPosition()
		)
	)
)

fn DoSetWheelPosToRadius obj = 
(	
	if (IsObjectAWheel obj) do
	(
		obj.position = [obj.position.x, obj.position.y,obj.scale.z*0.3591]
		
	)
)
fn DoSetSelectedWheelsPosToRadius = 
(
	for obj in (selection as array) do
	(
		DoSetWheelPosToRadius obj
	)
)
fn SetWheelPosToRadiusButton_Pressed sender arg =
(
	if (IsObjectAWheel selection[1]) do
	(
		undo "Scale Wheel" on
		(				
			DoSetSelectedWheelsPosToRadius()
		)
	)
)

fn FixMirrorButton_Pressed sender arg =
(
	undo "Fix Mirrored Geometry" on
	(
		if selection[1] != undefined then for obj in (selection as array) do
		(
			--emMod = edit_mesh()
			--addmodifier obj emMod
			children = #()
			
			for i=obj.children.count to 1 by -1 do
			(
				append children obj.children[i]
				
				deleteItem obj.children obj.children[i]
			)
			oldScale = obj.scale
			oldTransform = obj.transform
			obj.transform = matrix3 1
			obj.scale = oldScale
			--m = snapshotasmesh obj
			mirrorScale = [1,1,1]
			if obj.scale.x < 0 then mirrorScale.x = -1
			if obj.scale.y < 0 then mirrorScale.y = -1
			if obj.scale.z < 0 then mirrorScale.z = -1
				
			for i=1 to (Getnumverts obj) do
			(
				if (classof obj)==editable_poly or (classof obj) == PolyMeshObject then 
				(
					vertPos = (polyop.getvert obj i) * mirrorScale
					polyop.setvert obj #(i) vertpos
				)
				else 
				(
					vertPos = (meshop.getvert obj i) * mirrorScale
					meshop.setvert obj #(i) vertpos
				)
			)
			--obj.scale *= mirrorScale
			--emMod.mesh = m
			obj.transform = oldTransform
			obj.scale = oldScale * mirrorScale

			for child in children do
			(
				append obj.children child
			)
		)
	)
)