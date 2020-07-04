fn DummyUpTheHierarchy rootobj parentDummy = (
	if $car_parts_container == undefined then Dummy name:"car_parts_container"
	0
	weakparts = for obj in rootobj.children /*where (obj.modifiers["Car Weld"] !=undefined and (for mod in obj.modifiers where mod.name == "Car Weld" and (mod.Weakness_Set ==true or mod.Joints.count > 1) collect mod).count > 0)*/ collect obj
	for part in weakparts do (
		if (classof part) == Editable_mesh or (classof part) == Editable_Poly then (
			partDummy = Dummy name:(part.name) transform:part.transform parent: parentDummy boxsize:[50,50,50]
			DummyUpTheHierarchy part partDummy
			part.parent=$car_parts_container
			part.transform = matrix3 1
		)
		else (
			DummyUpTheHierarchy part part
			part.parent = parentDummy
		)
	)
)

fn FixupCarForUE4 rootMesh carFolder = (
	ReplaceNullsWithDummy()
	RenameDuplicateParts()
	wheels = for obj in objects where (substring obj.name 1 5) == "wheel" collect obj
	
	LoadStructureXML (carFolder+"structure.xml") rootMesh
	for wheel in wheels do (
		physWheel = Dummy name:("Phys"+wheel.name) pos:wheel.pos parent: rootMesh boxsize:[50,50,50]
		wheelOffset = Dummy name:(wheel.name+"_Offset") pos:wheel.pos parent: wheel.parent boxsize:[50,50,50]
		wheel.parent = wheelOffset
	)


	--DummyUpTheHierarchy rootMesh rootMesh
/*
	weakparts = for obj in objects where (obj.modifiers["Car Weld"] !=undefined and (for mod in obj.modifiers where mod.name == "Car Weld" and (mod.Weakness_Set ==true or mod.Joints.count > 1) collect mod).count > 0) collect obj
	for part in weakparts do (
		partDummy = Dummy name:(part.name) transform:part.transform parent: part.parent boxsize:[50,50,50]
		for child in part.children do (
			child.parent = partDummy
		)
		part.parent=undefined
		part.transform = matrix3 1
	)
	*/
)


fn ExportToFBX obj filename params selectedOnly:false = (
	select obj
	for param in params do FbxExporterSetParam param[1] param[2]

	makeDir (getFilenamePath filename)
	format "Exporting % to %\n" obj.name filename
	exportFile filename #noPrompt selectedOnly:selectedOnly using:FBXEXP
)


fn GetAllFilesToLoad pattern rootfolder = (
	allDirectories = getDirectories (rootfolder+"/*")

	allFiles = (getFiles(rootfolder +"\\"+ pattern))
	--format "Found % files in %\n" allFiles.count rootfolder
	for directory in allDirectories do (
		join allFiles (getFiles(directory + pattern))
		join allDirectories (getDirectories (directory+"/*"))
	)

	allFiles
)

fn GetFolderName filepath = (
	pathParts = filterstring (getFilenamePath filepath) "\\/"
	pathParts[pathParts.count]
)

fn ExportAllPeds exportFolder = (

	CarmaSettings.SetupForUE4 = true
	bodyformspath = CarmaSettings.DataCorePath+"\\Content\\Peds\\Bodyforms"
	allBodyformCNTs = GetAllFilesToLoad "bodyform.cnt" bodyformspath

	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for cntFile in allBodyformCNTs do (
		rootObject = ImportCNT cntFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
		pedName = GetFolderName cntFile
		fbxPath = (exportFolder+pedName+"\\"+pedname+".fbx")
		format "Loading % at % and exporting to %\n" pedName cntFile fbxPath
		ExportToFBX rootObject (exportFolder+pedName+"\\"+pedname+".fbx") exportParams
			numConverted = numConverted + 1
			delete objects

		
	)
)
fn ExportAllPedProps exportFolder = (

	CarmaSettings.SetupForUE4 = true
	propspath = CarmaSettings.DataCorePath+"\\Content\\Peds\\Props"
	allpropCNTs = GetAllFilesToLoad "accessory.cnt" propspath

	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for cntFile in allpropCNTs do (
		rootObject = ImportCNT cntFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
		pedName = GetFolderName cntFile
		fbxPath = (exportFolder+pedName+"\\"+pedname+".fbx")
		format "Loading % at % and exporting to %\n" pedName cntFile fbxPath
		ExportToFBX rootObject (exportFolder+pedName+"\\"+pedname+".fbx") exportParams
			numConverted = numConverted + 1
			delete objects

		
	)
)

fn ExportAllAnimations exportFolder = (

	CarmaSettings.SetupForUE4 = true
	bodyformspath = CarmaSettings.DataCorePath+"\\Content\\Peds\\Bodyforms"
	Animationspath = CarmaSettings.DataCorePath+"\\Content\\Peds\\animations"
	pedsForAnims = #(
		#("a_bear", "a_bear_01"),
		#("a_cow", "a_cow_01"),
		#("a_dog", "a_dog_pitbull"),
		#("a_elephant", "a_elephant"),
		#("a_penguin", "a_penguin"),
		#("a_sheep", "a_sheep_01"),
		#("d_anna", "d_anna"),
		#("d_don", "d_don"),
		#("d_grimm", "d_grimm_02"),
		#("d_hammerhead", "d_hammerhead"),
		#("d_hunch", "d_grimm"),
		#("d_m_", "d_kutter"),
		#("d_f_", "d_autoscum"),
		#("d_madam", "d_madam_scarlett"),
		#("d_max", "d_max"),
		#("d_mother_trucker", "d_mother_trucker"),
		#("d_twin_l", "d_twins_l"),
		#("d_twin_r", "d_twins_r"),
		#("d_val", "d_val"),
		#("f_fat", "f_fat_clothed"),
		#("f_gen", "f_baggypants"),
		#("f_gran", "f_granny"),
		#("f_miniskirt", "f_miniskirt"),
		#("m_fat", "m_fat"),
		#("m_flag", "m_flagman"),
		#("m_football", "m_football"),
		#("m_gen", "m_shorts"),
		#("m_oldman", "m_oldman")
	)
	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for pedForAnim in pedsForAnims do (
		allAnimationANMs = GetAllFilesToLoad "*.ANM" Animationspath
		CNTFile = bodyformspath + "\\" + pedForAnim[2] + "\\bodyform.cnt"
		--format "CNT file: %\n" cntFile
		for ANMFile in allAnimationANMs where (findString (getFilenameFile ANMFile) pedForAnim[1]) == 1 do (
			animName = getFilenameFile ANMFile
			--format "AnimName: %\n" ANMFile
			--format "AnimPrefix: %\n" pedForAnim[1]
			--Format "Prefix in anim name: %\n" (findString (getFilenameFile ANMFile) pedForAnim[1])
			rootObject = ImportCNT CNTFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
			
			--format "ANM file: %\n" ANMFile
			anim = CRSkeletalAnimation()
			anim.Load FileToLoad:ANMFile
			anim.ApplyToCharacter rootObject
			fbxPath = (exportFolder+animName+".fbx")
			--format "Loading % at % and exporting to %\n" animName ANMFile fbxPath
			ExportToFBX rootObject (exportFolder+animName+".fbx") exportParams
				numConverted = numConverted + 1
				delete objects
				
		)
		
	)
)


fn ExportAllAccessories exportFolder = (

	CarmaSettings.SetupForUE4 = true
	propspath = CarmaSettings.DataCorePath+"\\Content\\Accessories"
	allpropCNTs = GetAllFilesToLoad "accessory.cnt" propspath

	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for cntFile in allpropCNTs do (
		rootObject = ImportCNT cntFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
		accessoryname = GetFolderName cntFile
		fbxPath = (exportFolder+accessoryname+"\\"+accessoryname+".fbx")
		format "Loading % at % and exporting to %\n" accessoryname cntFile fbxPath
		ExportToFBX rootObject (exportFolder+accessoryname+"\\"+accessoryname+".fbx") exportParams
			numConverted = numConverted + 1
			delete objects

		
	)
)
fn ExportAllPickups exportFolder = (

	CarmaSettings.SetupForUE4 = true
	propspath = CarmaSettings.DataCorePath+"\\Content\\Pickups"
	allpropCNTs = GetAllFilesToLoad "accessory.cnt" propspath

	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for cntFile in allpropCNTs do (
		rootObject = ImportCNT cntFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
		pickupname = GetFolderName cntFile
		fbxPath = (exportFolder+pickupname+"\\"+pickupname+".fbx")
		format "Loading % at % and exporting to %\n" pickupname cntFile fbxPath
		ExportToFBX rootObject (exportFolder+pickupname+"\\"+pickupname+".fbx") exportParams
			numConverted = numConverted + 1
			delete objects

		
	)
)

fn ExportAllWheels exportFolder = (

	CarmaSettings.SetupForUE4 = true
	propspath = CarmaSettings.DataCorePath+"\\Content\\Vehicles\\Wheels"
	allwheelCNTs = GetAllFilesToLoad "*.cnt" propspath

	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for cntFile in allwheelCNTs do (
		if (findstring cntfile "default_c1") == undefined then (
		rootObject = ImportCNT cntFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
		wheelname = GetFolderName cntFile
		objectType = GetFilenameFile cntFile
		fbxPath = (exportFolder+wheelname+"\\"+wheelname+"_"+objectType+".fbx")
		format "Loading % at % and exporting to %\n" wheelname cntFile fbxPath
		ExportToFBX rootObject (exportFolder+wheelname+"\\"+wheelname+"_"+objectType+".fbx") exportParams
			numConverted = numConverted + 1
			delete objects
		)
		
	)
)

fn ExportAllVehicles exportFolder doCollisionsToo:true = (
	CarmaSettings.SetupForUE4 = true
	propspath = CarmaSettings.DataCorePath+"\\Content\\Vehicles"
	allwheelCNTs = GetAllFilesToLoad "car.cnt" propspath
	if doCollisionsToo then (
		allwheelCNTs = allwheelCNTs + (GetAllFilesToLoad "collision.cnt" propspath)
		allwheelCNTs = allwheelCNTs + (GetAllFilesToLoad "opponent_collision.cnt" propspath)
		allwheelCNTs = allwheelCNTs + (GetAllFilesToLoad "static_collision.cnt" propspath)
	)

	exportParams = #(
			#("Animation", true),
			#("ASCII", false),
			#("BakeAnimation", true),
			#("EmbedTextures", true),
			#("Lights", true),
			#("Cameras", true),
			#("ScaleFactor", 1.0),
			#("Skin", true),
			#("SmoothingGroups", true),
			#("Triangulate", true),
			#("TangentSpaceExport", true)
		)
	numConverted = 0
	for cntFile in allwheelCNTs do (
		if (findstring cntfile "c1") == undefined and (findstring cntfile "SR_") == undefined and (findstring cntfile "Alpha") == undefined  then (
		rootObject = ImportCNT cntFile importTextures:true forcePREP:true useTriStrips:false mergeMDLs:false mergeSplits:true
		
		FixupCarForUE4 rootObject (getFilenamePath cntfile)
		carname = GetFolderName cntFile
		objectType = GetFilenameFile cntFile
		fbxPath = (exportFolder+carname+"\\"+carname+"_"+objectType+".fbx")
		format "Loading % at % and exporting to %\n" carname cntFile fbxPath
		ExportToFBX rootObject (exportFolder+carname+"\\"+carname+"_"+objectType+".fbx") exportParams
			numConverted = numConverted + 1
			delete objects
		)
	)
)
fn PortAll = (
	CarmaSettings.SetupForUE4 = true
	ExportAllPeds "D:\\Unreal Projects\\CarmaTest\\Production\\Peds\\Bodyforms\\"
	ExportAllpedprops "D:\\Unreal Projects\\CarmaTest\\Production\\Peds\\Props\\"
	ExportAllWheels "D:\\Unreal Projects\\CarmaTest\\Production\\Vehicles\\Wheels\\"
	ExportAllAccessories "D:\\Unreal Projects\\CarmaTest\\Production\\Accessories\\"
	ExportAllPickups "D:\\Unreal Projects\\CarmaTest\\Production\\Pickups\\"
	ExportAllVehicles "D:\\Unreal Projects\\CarmaTest\\Production\\Vehicles\\" doCollisionsToo:true
)