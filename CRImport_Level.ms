fn FindAndLoadLevelAccessory accessoryType levelPath isPowerup:false=
(
	
	global CarmaSettings
	
	accessory = CarmaHelper_AccessoryPlaceholder()
	accessory.name = accessoryType
	accessory.isPowerup = isPowerup
	accessory.accessoryType = accessoryType
	folder = levelPath
	--if substring folder (folder.count-1) -1 != "\\" then folder = folder + "\\"
	folder = folder+"Accessories\\"
	
	--format "Importing accessory \"%\"\n" accessoryType
	--format "Checking level accessory folder: %\n" (folder+accessoryType+"\\accessory.cnt")
	 if ((dotnetclass "System.IO.File").exists (folder+accessoryType+"\\accessory.cnt")) then
	(
		--format "Accessory found!\n"
		accessory.accessoryFileName = folder+accessoryType+"\\accessory.cnt"
	)
	else
	(
		splitLevelPath = filterstring levelpath "\\/"
		environmentFolder = ""
		breakOnNext = false
		for i=1 to splitLevelPath.count-2 do
		(
			if tolower splitLevelPath[i] == "levels" then break
			environmentFolder = environmentFolder + splitLevelPath[i]+ "\\"
			--if tolower splitLevelPath[i] == "environments" then breakOnNext = true
		)
		
		--format "Checking environment accessory folder: %\n" (environmentFolder+"Accessories\\"+accessoryType+"\\accessory.cnt")
		--if ((dotnetclass "System.IO.File").exists (environmentFolder+"Accessories\\"+accessoryType+"\\accessory.cnt")) then
		--(
		--	accessory.accessoryFileName = environmentFolder+"Accessories\\"+accessoryType+"\\accessory.cnt"
		--)
		--else 
		--(
			--format "Checking root accessory folder: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Accessories\\"+accessoryType+"\\accessory.cnt")
			if ((dotnetclass "System.IO.File").exists (CarmaSettings.GamePath+"\\Data_Core\\Content\\Accessories\\"+accessoryType+"\\accessory.cnt")) then
			(
				accessory.accessoryFileName = CarmaSettings.GamePath+"\\Data_Core\\Content\\Accessories\\"+accessoryType+"\\accessory.cnt"
			)
			else if ((dotnetclass "System.IO.File").exists (CarmaSettings.GamePath+"\\Data_Core\\Content\\Pickups\\"+accessoryType+"\\accessory.cnt")) then
			(
				accessory.accessoryFileName = CarmaSettings.GamePath+"\\Data_Core\\Content\\Pickups\\"+accessoryType+"\\accessory.cnt"
			)
		--)
	)
	--if accessory.accessoryFileName != undefied  and accessory.accessoryFileName != "" then 
		--format "Found accessory in: %\n" accessory.AccessoryFileName
	--else
		--format "No accessory found matching %\n" accessoryType
	
	return accessory
)
fn ParseLevelAccessoryLOL lolFileName isPowerup:false =
(
	format "Parsing Level LOL % ()\n" lolFileName isPowerup
	lolscript = (DecodeLOLFile lolFileName) as StringStream
	startedAccessories = false
	readingAccessory = false
	readingTransform = false
	readingTransformX = false
	readingTransformY = false
	readingTransformZ = false
	readingTransformPos = false
	nextComponent = "X"
	readingColour = false
	currentTransformRow1 = [0,0,0]
	currentTransformRow2 = [0,0,0]
	currentTransformRow3 = [0,0,0]
	currentTransformRow4 = [0,0,0]
	currentAccessoryName = ""
	currentAccessoryName2 = ""
	currentAccessoryType = ""
	currentAccessoryLayer = ""
	currentPosition = [0,0,0]
	while (eof lolscript) == false do
	(
		curLine = trimright (trimleft (readline lolscript))
		if curLine == "" then 
		(
			continue
		)
		if startedAccessories==false and curLine == "accessories = {" then
		(
			startedAccessories = true
		)
		else if startedAccessories == true then
		(
			if readingAccessory == false then
			(
				filteredString = filterstring curLine " "
				if filteredString[2] == "=" and filteredString[3] == "{" then
				(
					currentAccessoryName = filteredString[1]
					readingAccessory = true
				)
			)
			else
			(
				
				splitLine = filterstring curLine "="
				if trimright (trimleft splitLine[1]) == "name" then
				(
					currentAccessoryName2 = trimright (trimleft splitLine[2])
						currentAccessoryName2 = substring currentAccessoryName2 2 (currentAccessoryName2.count-3)
				)
				else if trimright (trimleft splitLine[1]) == "type" then
				(
					currentAccessoryType = trimright (trimleft splitLine[2])
						currentAccessoryType = substring currentAccessoryType 2 (currentAccessoryType.count-3)
				)
				else if trimright (trimleft splitLine[1]) == "layer" then
				(
					currentAccessoryLayer=  trimright (trimleft splitLine[2])
						currentAccessoryLayer = substring currentAccessoryLayer 2 (currentAccessoryLayer.count-3)
				)
				else if curLine == "transform = {" then
				(
					readingTransform=true
					nextComponent = "X"
					readingTransformX = true
					readingTransformY = false
					readingTransformZ = false
					currentTransformRow1 = [0,0,0]
					currentTransformRow2 = [0,0,0]
					currentTransformRow3 = [0,0,0]
					currentTransformRow4 = [0,0,0]
				)
				else if  readingTransform == true then
				(
						
					if readingTransformX == true then
					(
						if curLine == "{" then
						(
							--if currentAccessoryType == "c1checkpoint" then format "\tStarting to read X axis - "
						)
						else if curLine == "}" or curLine == "}," then
						(
							readingTransformX = false
							readingTransformY = true
							nextComponent= "X"
							--if currentAccessoryType == "c1checkpoint" then format "\n\tFinishing reading X axis\n"
						)
						else if nextComponent == "X" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow1.X = filteredValue[1] as float
							nextComponent = "Y"
							--if currentAccessoryType == "c1checkpoint" then format "X = % " filteredValue[1]
						)
						else if nextComponent == "Y" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow1.Y = filteredValue[1] as float
							nextComponent = "Z"
							--if currentAccessoryType == "c1checkpoint" then format "Y = % " filteredValue[1]
						)
						else if nextComponent == "Z" then
						(
							currentTransformrow1.Z = curLine as float
							nextComponent = "X"
							--if currentAccessoryType == "c1checkpoint" then format "Z = % " filteredValue[1]
						)
					)
					else if readingTransformY == true then
					(
						if curLine == "{" then
						(
						)
						else if curLine == "}" or curLine == "}," then
						(
							readingTransformY = false
							readingTransformZ = true
							nextComponent= "X"
						)
						else if nextComponent == "X" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow2.X = filteredValue[1] as float
							nextComponent = "Y"
						)
						else if nextComponent == "Y" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow2.Y = filteredValue[1] as float
							nextComponent = "Z"
						)
						else if nextComponent == "Z" then
						(
							currentTransformrow2.Z = curLine as float
							nextComponent = "X"
						)
					)
					else if readingTransformZ == true then
					(
						if curLine == "{" then
						(
						)
						else if curLine == "}" or curLine == "}," then
						(
							readingTransformZ = false
							readingTransformPos = true
							nextComponent= "X"
						)
						else if nextComponent == "X" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow3.X = filteredValue[1] as float
							nextComponent = "Y"
						)
						else if nextComponent == "Y" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow3.Y = filteredValue[1] as float
							nextComponent = "Z"
						)
						else if nextComponent == "Z" then
						(
							currentTransformrow3.Z = curLine as float
							nextComponent = "X"
						)
					)
					else if readingTransformPos == true then
					(
						if curLine == "{" then
						(
						)
						else if curLine == "}" or curLine == "}," then
						(
							readingTransformPos = false
							nextComponent= "X"
						)
						else if nextComponent == "X" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow4.X = filteredValue[1] as float
							nextComponent = "Y"
						)
						else if nextComponent == "Y" then
						(
							filteredValue = filterString curLine ","
							currentTransformrow4.Y = filteredValue[1] as float
							nextComponent = "Z"
						)
						else if nextComponent == "Z" then
						(
							currentTransformrow4.Z = curLine as float
							nextComponent = "X"
						)
					)
					else if curLine == "}," or curLine == "}" then
					(
						readingTransform = false
					)
				)
				else if curLine == "colour = {" then
				(
					readingColour = true
				)
				else if readingColour == true then
				(
					if curLine == "}" or curLine == "}," then
					(
						readingColour = false
					)
				)
				else if curLine == "}" or curLine == "}," then
				(
					readingAccessory = false
					
					--trans = transmatrix (ConvertFromCRSpace currentPosition)
					--newNode.transformMatrix = matrix3 [m_Xx,m_Xy,m_Xz] [m_Yx,m_Yy,m_Yz] [m_Zx,m_Zy,m_Zz] [m_Px,m_Py,m_Pz]
					--if tolower currentAccessoryType == "c1checkpoint" then 
					--(
						layerObject = LayerManager.getLayerFromName currentAccessoryLayer
						if layerObject == undefined then
						(
							layerObject= LayerManager.newLayerFromName currentAccessoryLayer
						)
						newAccessoryObject = FindAndLoadLevelAccessory currentAccessoryType (getFilenamePath lolFileName) isPowerup:isPowerup
						trans = matrix3 currentTransformRow1 currentTransformRow2 currentTransformRow3 currentTransformRow4
						--if tolower currentAccessoryType == "c1checkpoint" then format "Accessory named % of type %\n\tCurrent Transform: %\n" currentAccessoryName currentAccessoryType trans
						
						trans = (matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0]) * trans * inverse(matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0])
						
						--if tolower currentAccessoryType == "c1checkpoint" then format "\tConverted Transform: %\n\n" trans
						newAccessoryObject.transform = trans
						layerObject.addnode newAccessoryObject
					--)
				)
			)
		)
	)
	--format "The Level.lol file: %\n" lolscript
)
fn ImportLevelButtonPressed sender arg=
(

	undo "Import C:R Level" on
	(
		--CreateNewNULLNode [1,1,0] 1
		cnt_name = GetOpenFileName caption:"Open Level.CNT File" types:"Level.CNT(Level.CNT)|level.cnt"
		if cnt_name != undefined do
		(
			with redraw off
			(
				--ImportCNT cnt_name importTextures:imp_textures.checked forcePREP:(imp_forcePREP.checked or imp_forceTriStrips.checked) useTriStrips:imp_forceTriStrips.checked
				rootMesh = ImportCNT cnt_name importTextures:sender.parent.controls.Item["ImportTexturesCheckbox"].checked forcePREP:sender.parent.controls.Item["ForcePrepCheckbox"].checked useTriStrips:sender.parent.controls.Item["UseTriStripsCheckbox"].checked
				--AddVehilceCFGModifier rootMesh
				--LoadVehicleConfig rootMesh (getFilenamePath cnt_name)
				--SetAllCNTsToBakeScale rootMesh
				--ReplaceWheels rootmesh
				
				--structureXmlFile = (getFilenamePath cnt_name)+"structure.xml"
				--LoadStructureXML structureXmlFile rootMesh
				
				if sender.parent.controls.Item["LoadAccessoriesCheckbox"].checked then
				(
					setupLOLFile = (getFilenamePath cnt_name)+"level.lol"
					ParseLevelAccessoryLOL setupLOLfile
				)
				if sender.parent.controls.Item["LoadPowerupsCheckbox"].checked then
				(
					powerupLOLFile = (getFilenamePath cnt_name)+"powerups.lol"
					ParseLevelAccessoryLOL powerupLOLFile isPowerup:true
				)
			)
		)
	)
	gc()
)