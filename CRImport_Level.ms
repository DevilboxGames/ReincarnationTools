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
			if tolower splitLevelPath[i] == "levels" then i = splitLevelPath.count + 1
			else environmentFolder = environmentFolder + splitLevelPath[i]+ "\\"
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
			if ((dotnetclass "System.IO.File").exists (CarmaSettings.DataCorePath+"\\Content\\Accessories\\"+accessoryType+"\\accessory.cnt")) then
			(
				accessory.accessoryFileName = CarmaSettings.DataCorePath+"\\Content\\Accessories\\"+accessoryType+"\\accessory.cnt"
			)
			else if ((dotnetclass "System.IO.File").exists (CarmaSettings.DataCorePath+"\\Content\\Pickups\\"+accessoryType+"\\accessory.cnt")) then
			(
				accessory.accessoryFileName = CarmaSettings.DataCorePath+"\\Content\\Pickups\\"+accessoryType+"\\accessory.cnt"
			)
		--)
	)
	--if accessory.accessoryFileName != undefied  and accessory.accessoryFileName != "" then 
		--format "Found accessory in: %\n" accessory.AccessoryFileName
	--else
		--format "No accessory found matching %\n" accessoryType
	KeepMaxAlive()
	accessory
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
	currentAccessoryColour = Color 0 0 0
	UniqueAccessoryList = #()
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
					nextComponent = "R"
				)
				else if readingColour == true then
				(
					if curLine == "}" or curLine == "}," then
					(
						readingColour = false
					)
					else if nextComponent == "R" then
					(
						filteredValue = filterString curLine ","
						currentAccessoryColour.r = filteredValue[1] as float
						nextComponent = "G"
					)
					else if nextComponent == "G" then
					(
						filteredValue = filterString curLine ","
						currentAccessoryColour.g = filteredValue[1] as float
						nextComponent = "B"
					)
					else if nextComponent == "B" then
					(
						filteredValue = filterString curLine ","
						currentAccessoryColour.b = filteredValue[1] as float
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
						appendIfUnique UniqueAccessoryList currentAccessoryType
						newAccessoryObject = FindAndLoadLevelAccessory currentAccessoryType (getFilenamePath lolFileName) isPowerup:isPowerup
						trans = matrix3 currentTransformRow1 currentTransformRow2 currentTransformRow3 currentTransformRow4
						--if tolower currentAccessoryType == "c1checkpoint" then format "Accessory named % of type %\n\tCurrent Transform: %\n" currentAccessoryName currentAccessoryType trans
						
						trans = (matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0]) * trans * inverse(matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0])
						
						--if tolower currentAccessoryType == "c1checkpoint" then format "\tConverted Transform: %\n\n" trans
						newAccessoryObject.transform = trans
						newAccessoryObject.accessoryName = currentAccessoryName2
						newAccessoryObject.accessoryID = currentAccessoryName
						newAccessoryObject.accessoryColour = currentAccessoryColour
						layerObject.addnode newAccessoryObject
					--)
				)
			)
		)
	)
	PrintArrayInFull UniqueAccessoryList "List Of Accessories: "
	--format "The Level.lol file: %\n" lolscript
)
fn ParseLevelRoutesTXT txtFileName =
(
	oldCurrentLayer = LayerManager.current
	routesLayer = LayerManager.getLayerFromName "sys_LevelRoutes"
	if routesLayer == undefined then
	(
		routesLayer = LayerManager.newLayerFromName "sys_LevelRoutes"
	)
	routesLayer.current = true
	
	format "Loading routes file: %\n" txtFileName
	
	if ((dotnetclass "System.IO.File").exists txtFileName) then
	(
		f = openfile txtFileName mode:"r"
		
		
			activeType=undefined
			activeSubType = undefined
			
			currentAINode = undefined
			AINodes = #()
			AINodeCount = 0
			currentAILink = undefined
			AILinkCount = 0
			currentMode = undefined
			lineNum=0
			while not (eof f) do
			(
				lineNum += 1
				
				curline = trimLeft (trimRight (readline f))
				if curline[1] == "[" then
				(
					currentAILink = undefined
					currentAINode = undefined
					if toupper curline == "[AINODE]" then
					(
						currentAINode = AINode name:("AINode_"+(AINodeCount as string))
						AINodeCount += 1
					)
					else if toupper curline == "[AILINK]" then
					(
						currentAILink = AILink name:("AILink_"+(AILinkCount as string))
						AILinkCount += 1
					)
				)
				else if currentAINode != undefined then
				(
					if curline[1] == "<" then currentMode = toupper curLine
					else
					(
						if curline == "" then continue
						case currentMode of
						(
							"<INDEX>":
							(
								currentAINode.Index = curline as integer
								AINodes[(curline as integer)+1] = currentAINode
							)
							"<POS>": 
							(
								currentAINode.pos = ConvertToCRSpace (StringAsPoint3 curline)
								currentAINode.pos.y = -currentAINode.pos.y
								--currentAINode.pos.z = -currentAINode.pos.z
							)
							"<RADIUS>":
							(

								currentAINode.Radius = curline as float
								if currentAINode.Radius < 0.1 then currentAINode.Radius = 0.1
							)
							"<RACE_LINE>":
							(
								currentAINode.RaceLine = ConvertToCRSpace (StringAsPoint3 curline)
								currentAINode.RaceLine.y = -currentAINode.RaceLine.y
								currentAINode.pos.z = -currentAINode.pos.z
							)
							"<RACE_LINE_OFFSET>":
							(
								currentAINode.RaceLineOffset = curline as float
							)
							"<TYPE>":
							(
								currentAINode.Type = curline as integer
							)
						)
					)
				)
				else if currentAILink != undefined then
				(
					if toupper curline == "<ONEWAY>" then currentAILink.OneWay = true
					--else if toupper curline == "WATER" then currentAILink.Water = true
					else if toupper curline == "\"\"LOOP\"\"" then currentAILink.Loop = true
					else if toupper curline == "\"\"INTERIOR\"\"" then currentAILink.Interior = true
					if curline[1] == "<" then currentMode = toupper curLine
					else
					(
						case currentMode of
						(
							"<NODES>":
							(
								if currentAILink.Node1 == undefined then currentAILink.Node1 = nodeTransformMonitor node:(AINodes[(curline as integer)+1]) forwardTransformChangeMsgs:false
								else if currentAILink.Node2 == undefined then currentAILink.Node2 = nodeTransformMonitor node:(AINodes[(curline as integer)+1]) forwardTransformChangeMsgs:false
							)
							"<WIDTH>":
							(
								currentAILink.Width = curline as float
							)
							"<TYPE>":
							(
								append currentAILink.LinkType (curline as integer)
							)
							"<RACE_VALUE>":
							(
								if curline == "water" then
								(
								append currentAILink.Water 1
								)
								else
								(
									append currentAILink.Water 0
								)
							)
						)
					)
					
				)
				
				
			)
		
		close f
	)
	else messageBox "Error: Routes.txt does not exist!" title:"No Routes.txt found!"
	
	
	oldCurrentLayer.current = true
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
				if sender.parent.controls.Item["LoadGeometryCheckbox"].checked then
				(
					rootMesh = ImportCNT cnt_name importTextures:sender.parent.controls.Item["ImportTexturesCheckbox"].checked forcePREP:sender.parent.controls.Item["ForcePrepCheckbox"].checked useTriStrips:sender.parent.controls.Item["UseTriStripsCheckbox"].checked
				)
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
				if sender.parent.controls.Item["LoadPathsCheckbox"].checked then
				(
					routesTXTFile  =(getFilenamePath cnt_name)+"routes.txt"
					ParseLevelRoutesTXT routesTXTFile
				)
					
			)
		)
	)
	gc()
)

struct C2MapCheckpoint
(
	NumQuads,
	Quads = #()
)
struct C2MapText
(
	Version,
	DirectLightColour,
	AmbientLight0,
	AmbientLight1,
	AmbientLight2,
	GridPos,
	GridRot,
	CheckPointCount,
	CheckPoints = #()
)
struct C2TextParser (
	f,
	curline,
	tokens = #(),
	nextTokenNum,
	currentToken,
	fn Start filename = (
		
		f = openfile fileName mode:"r"
		lineTokenNum = 0
		curline = ""
		tokens = #()
		currentToken = ""
		f
	),
	fn GetLine = (
			curline = ""
			quitLoop = false
			while not (eof f) and quitLoop == false do (
				curline = trimLeft (trimRight (readline f))
					if curline != "" and (substring curline 1 2) != "//" then (
						nextTokenNum = 1
						tokens = filterstring curline " ,"
						quitLoop = true
					)
			)
			if quitLoop == false then curLine = ""
			curLine
		),
		fn GetToken = (
			hitEof = false
			while (nextTokenNum > tokens.count or substring tokens[nextTokenNum] 1 2) == "//" and not (eof f) do
			(
				GetLine()
				if eof f then hitEof = true
			)
			currentToken = undefined
			if hitEof then
			(
			currentToken = tokens[nextTokenNum]
			nextTokenNum = nextTokenNum + 1
			)
			currentToken
		)
)
fn ImportC2LevelTXT txtFileName checkExisitingNodes:false =
(
	if ((dotnetclass "System.IO.File").exists txtFileName) then
	(
		parser = C2TextParser()
		f =parser.Start txtFileName
		
		activeType=undefined
			activeSubType = undefined
			
			currentAINode = undefined
			AINodes = #()
			AINodeCount = 0
			currentAILink = undefined
			AILinkCount = 0
			currentMode = undefined
			lineNum=0
		AINodeMap = #()
			
		mapData = C2MapText()
		Parser.GetToken()
		mapData.Version = Parser.GetToken() as integer
		mapData.DirectLightColour = Color (Parser.GetToken() as integer) (Parser.GetToken() as integer) (Parser.GetToken() as integer)
		mapData.AmbientLight0 =[ (Parser.GetToken() as float), (Parser.GetToken() as float)]
		mapData.AmbientLight1 =[ (Parser.GetToken() as float), (Parser.GetToken() as float)]
		mapData.AmbientLight2 =[ (Parser.GetToken() as float), (Parser.GetToken() as float)]
		
		gridX = Parser.GetToken() as float
		gridZ = Parser.GetToken() as float
		gridY = -(Parser.GetToken() as float)
		mapData.GridPos = [gridX, gridY, gridZ]
		mapData.GridRot = Parser.GetToken() as integer
		
		mapData.CheckPointCount = Parser.GetToken() as integer
		for i=1 to mapData.CheckPointCount do
		(
			Parser.GetToken()
			Parser.GetToken()
			Parser.GetToken()
			cp = C2MapCheckpoint()
			cp.NumQuads = Parser.GetToken() as integer
			for cp = 1 to cp.NumQuads do
			(
				cpX = Parser.GetToken() as float
				cpZ = Parser.GetToken() as float
				cpY = -(Parser.GetToken() as float)
				append cp.Quads [cpX, cpY, cpZ]
			)
			append mapData.CheckPoints cp
		)
		
			while not (eof f) do
			(
				lineNum += 1
				
				curline = trimLeft (trimRight (readline f))
				if curline == "" then continue
					
				splitval = filterstring curline " "
				
				
					if curline == "START OF OPPONENT PATHS" then 
					(
						currentMode = "OpponentPaths"
					)
						
					else (
							if currentMode == "OpponentPaths" then
							(
								if(splitval.count < 1) then continue
								numNodes = splitval[1] as number
								
								for i = 1 to numNodes do (
									
									pointLine = trimLeft (trimRight (readline f))
										splitPoint = filterString pointLine ", "
								if(splitPoint.count < 1) then 
									(
										i = i-1
										continue
									)
									nodePos = [(splitPoint[1] as float) * 6.9, -(splitpoint[3] as float) * 6.9, (splitPoint[2] as float) * 6.9]
									createNewNode = true
									if checkExisitingNodes then
									(
										for obj in objects where classof obj == AINode do ( 
											if (length (obj.pos - nodePos)) < 0.001 then 
											(
												format "% = %\n" ("AINode_"+(i as string)) obj.name 
													createNewNode = false
													append AINodes  obj
													break
											)
										)
											
									)
									if createNewNode == true then
									(
								currentAINode = AINode name:("AINode_"+(i as string))
									currentAINode.radius = 1.0
									currentAINode.type = 0
										currentAINode.pos = nodePos
									AINodeMap[i] = currentAI
										append AINodes currentAINode
									)
								)
								currentMode = "OpponentPaths_Links"
							)
							else if currentMode == "OpponentPaths_Links" then
							(
								splitval = filterstring curline " "
								if(splitval.count < 1) then continue
					
								numLinks = splitval[1] as number
								for i = 1 to numLinks do (
									
									linkLine = trimLeft (trimRight (readline f))
										splitlink = filterString linkLine ", "
								if(splitlink.count < 1) then
									(
										i = i-1
										continue
									)
									createNewNode = true
									if checkExisitingNodes then
									(
										for obj in objects where classof obj == AILink do ( 
											if obj.node1.node == AINodes[(splitlink[1] as integer)+1] and obj.node2.node == AINodes[(splitlink[2] as integer)+1] then 
											(
												format "% = %\n" ("AILink_"+(i as string)) obj.name 
													createNewNode = false
													linktype = (splitlink[8] as integer)
									if linktype > 0 then linktype = 1
									
									append currentAILink.LinkType linktype
													break
											)
										)
											
									)
									if createNewNode == true then
									(
								currentAILink = AILink name:("AILink_"+(i as string))
									currentAILink.Width = (splitlink[7] as float) * 6.9
									linktype = (splitlink[8] as integer)
									if linktype > 0 then linktype = 1
									
									append currentAILink.LinkType linktype
										currentAILink.Node1 = nodeTransformMonitor node:(AINodes[(splitlink[1] as integer)+1]) forwardTransformChangeMsgs:false
										currentAILink.Node2 = nodeTransformMonitor node:(AINodes[(splitlink[2] as integer)+1]) forwardTransformChangeMsgs:false
									)	
								)
								currentMode = undefined
							)
							
						)
			)
	)
)