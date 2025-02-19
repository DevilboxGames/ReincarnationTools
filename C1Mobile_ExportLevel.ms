format "\nLoading C1Mobile_ExportLevel.ms\n"
fn ExportFunsizeLevelTXT levelRoot filename  = (
	global CarmaSettings

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder

	local pathClass = (dotnetclass "System.IO.Path")
	local levelTxt = (dotnetObject "ToxicRagers.CarmageddonMobile.Formats.Level")

	local exportTextures = CarmaSettings.ExportSettings.ExportTextures
	local exportMaterials = CarmaSettings.ExportSettings.ExportMaterials
	
	
	local levelFolder = pathClass.GetDirectoryName filename

	
	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	local LevelLayerName = "sys_level_"+(levelNumString)
	local LevelPedLayerName = LevelLayerName + "_ped"
	local LevelPowerupLayerName = LevelLayerName + "_powerups"
	local LevelPathsLayerName = LevelLayerName + "_paths"

	if (LayerManager.getLayerFromName LevelLayerName) == undefined then(
		LayerManager.newLayerFromName LevelLayerName
	)
	if (LayerManager.getLayerFromName LevelPedLayerName) == undefined then(
		LayerManager.newLayerFromName LevelPedLayerName
	)
	if (LayerManager.getLayerFromName LevelPowerupLayerName) == undefined then(
		LayerManager.newLayerFromName LevelPowerupLayerName
	)
	if (LayerManager.getLayerFromName LevelPathsLayerName) == undefined then(
		LayerManager.newLayerFromName LevelPathsLayerName
	)

	local levelCntPath = pathClass.Combine levelFolder "level.cnt"
	local lightCntPath = pathClass.Combine levelFolder "light.cnt"
	local levelModifier = levelRoot.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = levelRoot.modifiers["Funsize Level Info"] 
/*
	if (doesFileExist lightCntPath) then (
		local lightRoot = ImportCNT lightCntPath importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		local lightNull = CreateNewNULLNode lightRoot.transform "light.cnt" addAttributes:true nodeType:"CNT"
		lightNull.modifiers["CNT Hierarchy"].FileName = "light.cnt"
		lightRoot.parent = lightNull
	)*/

	local currentLayer = layerManager.current

	--(layerManager.getLayerFromName LevelLayerName).current = true
	local racingIndex = (filterstring (pathClass.GetFileNameWithoutExtension fileName) "_")[2] as integer
	SetFunsizeLevelSettingsFromTXT levelRoot levelTxt careersTxt textXml (GetFolderName FileName) racingIndex

	for i = 0 to levelTxt.Accessories.count - 1 do (
		local accData = levelTxt.Accessories.item[i]
		local accTransform = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 accData.Transform)
		PlaceMobileAccessory accTransform accData.Name accData.InstanceName (ToxicRagersColourToMaxColor accData.InstanceColour)
	)

	for i = 0 to levelTxt.Cops.count - 1 do (
		local copData = levelTxt.Cops.item[i]
		local copType = copData.Type.ToString()
		local copPos = (ConvertCopFromFunsize (ToxicRagersVector3ToMaxPoint3 copData.Position)) 
		PlaceCopHelper copType copPos
	)

	--(layerManager.getLayerFromName LevelPedLayerName).current = true

	for i = 0 to levelTxt.Peds.count - 1 do (
		local pedData = levelTxt.Peds.item[i]
		local pedPoints = #()
		for i = 0 to pedData.Paths.count - 1 do (
			local pathPoint = ConvertFromCRSpace (ToxicRagersVector3ToMaxPoint3 pedData.Paths.item[i])
			append pedPoints pathPoint
		)
		PlacePed pedData.PedType pedPoints pedData.LoopCount
	)

	--(layerManager.getLayerFromName LevelPowerupLayerName).current = true

	for i = 0 to levelTxt.Powerups.count - 1 do (
		local pupDef = levelTxt.Powerups.item[i]
		local pupTrans = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 pupDef.Transform)
		local pupTypes = #()
		for p = 0 to pupDef.PowerupNames.count - 1 do (
			append pupTypes pupDef.PowerupNames.item[p]
		)

		PlacePowerup pupTrans pupTypes pupDef.RespawnTime
	)
	--(layerManager.getLayerFromName LevelPathsLayerName).current = true

	ParseLevelRoutesTXT ((dotnetclass "System.IO.Path").Combine #((getFileNamePath filename), ("paths_"+levelNumString+".txt")))

	--currentLayer.current = true

)

fn Funsize_AddLeveltoXML levelInfoModifier overridePath:unsupplied = (
	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder

	if overridePath != unsupplied then (
		FunsizeDataPath = overridePath
	)

	local pathClass = (dotnetclass "System.IO.Path")
	local xmlPath = pathClass.Combine #(FunsizeDataPath, "Data", "Content","Text", "Text.xml")
	local textXml = (dotnetobject "ToxicRagers.CarmageddonMobile.Formats.TextXml" xmlPath)
	local language = (dotnetClass "ToxicRagers.CarmageddonMobile.Formats.TextXml+TextLanguage").Master

	local levelName = levelInfoModifier.LevelName
	local levelDescription = levelInfoModifier.LevelDescription
	local levelEnvironment = levelInfoModifier.LevelEnvironment
	local levelText3 = levelInfoModifier.LevelText3

	if levelName == undefined then (
		levelName = "UNNAMED RACE"
	)
	if levelDescription == undefined then (
		levelDescription = "This is an unnamed race which someone needs to fill out the details for"
	)
	if levelEnvironment == undefined then (
		levelEnvironment = "UNKNOWN"
	)
	if levelText3 == undefined then (
		levelText3 = ""
	)


	textXml.SetText  levelInfoModifier.LevelNameKey levelName language
	textXml.SetText  levelInfoModifier.LevelDescriptionKey levelDescription language
	textXml.SetText  levelInfoModifier.LevelEnvironmentKey levelEnvironment language
	textXml.SetText  levelInfoModifier.LevelText3Key levelText3 language

	textXml.Save xmlPath
)

fn Funsize_UpdateCareersTXT levelModifier levelInfoModifier overridePath:unsupplied = (

	
	local pathClass = (dotnetclass "System.IO.Path")
	local levelFolder = levelModifier.LevelFolderName
	local careerLevelNum = levelInfoModifier.LevelRaceNum
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
	
	if overridePath != unsupplied then (
		FunsizeDataPath = overridePath
	)
	
	local careersTxtPath = pathClass.Combine #(FunsizeDataPath, "Data", "Content", "careermode.txt")
	local careersTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.CareerModeTxt").Load careersTxtPath
	local levelCareerInfo = careersTxt.FindLevel levelFolder ("level_"+levelNumString+".txt")

	if levelCareerInfo == undefined then
	(
		levelCareerInfo = dotNetObject "ToxicRagers.CarmageddonMobile.Formats.CareerModeTextItem"
		careersTxt.Items.insert (careerLevelNum - 1) levelCareerInfo
	)
	else if (careersTxt.Items.IndexOf levelCareerInfo) != (careerLevelNum - 1) then
	(
		careersTxt.Items.remove levelCareerInfo
		careersTxt.Items.insert (careerLevelNum - 1) levelCareerInfo
	)

	if levelCareerInfo != undefined then (
		levelCareerInfo.LevelNameKey = levelInfoModifier.LevelNameKey
		levelCareerInfo.LevelDescriptionKey = levelInfoModifier.LevelDescriptionKey
		levelCareerInfo.EnvironmentNameKey = levelInfoModifier.LevelEnvironmentKey
		levelCareerInfo.LocalisationTextKey4 = levelInfoModifier.LevelText3Key
		
		levelCareerInfo.TrackUnlock = levelInfoModifier.TrackUnlock
		levelCareerInfo.VehicleUnlock = levelInfoModifier.VehicleUnlock
		levelCareerInfo.EventUnlock = levelInfoModifier.EventUnlock
		levelCareerInfo.SpecialCode = levelInfoModifier.SpecialCode

		levelCareerInfo.GameMode = levelInfoModifier.RaceType
		levelCareerInfo.LapLength = levelInfoModifier.LapLength
		levelCareerInfo.NumPeds = levelInfoModifier.PedCount
		levelCareerInfo.Laps = levelInfoModifier.Laps

		levelCareerInfo.AISkill = levelInfoModifier.AISkill
		levelCareerInfo.AICars = levelInfoModifier.AICars
		levelCareerInfo.NumAI = levelInfoModifier.NumAI
		levelCareerInfo.Boss = levelInfoModifier.Boss

		levelCareerInfo.RequiredCredits = levelInfoModifier.RequiredCredits

		levelCareerInfo.WinBonusLaps.Easy = levelInfoModifier.WinBonusLaps_Easy
		levelCareerInfo.WinBonusLaps.Medium = levelInfoModifier.WinBonusLaps_Medium
		levelCareerInfo.WinBonusLaps.Hard = levelInfoModifier.WinBonusLaps_Hard

		levelCareerInfo.WinBonusPeds.Easy = levelInfoModifier.WinBonusPeds_Easy
		levelCareerInfo.WinBonusPeds.Medium = levelInfoModifier.WinBonusPeds_Medium
		levelCareerInfo.WinBonusPeds.Hard = levelInfoModifier.WinBonusPeds_Hard

		levelCareerInfo.WinBonusWasted.Easy = levelInfoModifier.WinBonusWasted_Easy
		levelCareerInfo.WinBonusWasted.Medium = levelInfoModifier.WinBonusWasted_Medium
		levelCareerInfo.WinBonusWasted.Hard = levelInfoModifier.WinBonusWasted_Hard

		levelCareerInfo.StartTime.Easy = levelInfoModifier.StartTime_Easy
		levelCareerInfo.StartTime.Medium = levelInfoModifier.StartTime_Medium
		levelCareerInfo.StartTime.Hard = levelInfoModifier.StartTime_Hard
	)

	careersTxt.Save careersTxtPath

)

fn Funsize_CollectAccessoriesForLevelTxt levelModifier levelInfoModifier levelTxt = (

	
	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString
	local LevelLayerName = "sys_level_"+(levelNumString)
	local LevelPedLayerName = LevelLayerName + "_ped"
	local LevelPowerupLayerName = LevelLayerName + "_powerups"
	local LevelPathsLayerName = "sys_LevelRoutes"

	local accessoryNodes
	local pedNodes
	local powerupNodes
	local pathNodes

	(LayerManager.getLayerFromName LevelLayerName).nodes &accessoryNodes
	(LayerManager.getLayerFromName LevelPedLayerName).nodes &pedNodes
	(LayerManager.getLayerFromName LevelPowerupLayerName).nodes &powerupNodes

	for accessoryNode in accessoryNodes do (
		local accModifier = accessoryNode.Modifiers["Funsize Accessory"]
		if accModifier != undefined then (
			local accTransform = MaxMatrix3ToToxicRagersMatrix3D (ConvertMatrixToCRSpace accessoryNode.Transform)
			local accData = dotnetObject "ToxicRagers.CarmageddonMobile.Formats.AccessoryDef"
			accData.Name = accModifier.AccessoryType
			accData.Transform = accTransform
			if accModifier.InstanceName != undefined then 
			(
				 accData.InstanceName = accModifier.InstanceName
			)
			else (
				accData.InstanceName = ""
			)
			accData.InstanceColour = MaxColorToToxicRagersColour accModifier.InstanceColour
			
			levelTxt.Accessories.Add accData
		)
		else (
			local copModifier = accessoryNode.Modifiers["Funsize Cop"]
			if copModifier != undefined then (
				local copData = dotnetObject "ToxicRagers.CarmageddonMobile.Formats.CopDef"
				copData.Type = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.CopDef+CopType").NORM
				if copModifier.CopType == "APC" then (
					copData.Type = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.CopDef+CopType").APC
				)

				copData.Position = MaxPoint3ToToxicRagersVector3 (ConvertCopToFunsize accessoryNode.Position)
				levelTxt.Cops.Add copData
			)
		)
	)

	for pedNode in pedNodes do (
		local pedModifier = pedNode.Modifiers["Funsize Ped"]
		if pedModifier != undefined then (
			local pedData = dotnetObject "ToxicRagers.CarmageddonMobile.Formats.PedestrianDef"
			pedData.LoopCount = pedModifier.LoopCount
			pedData.PedType = pedModifier.PedType
			pedData.PathCount = numKnots pedNode
			for i = 1 to pedData.PathCount do (
				local knotPoint = MaxPoint3ToToxicRagersVector3 (ConvertToCRSpace (getknotpoint pedNode 1 i))
				pedData.Paths.Add knotPoint
			)
		)
	)
	for powerupNode in powerupNodes do (
		local powerupModifier = powerupNode.Modifiers["Funsize Powerup"]
		if powerupModifier != undefined then (
			local pupData = dotnetObject "ToxicRagers.CarmageddonMobile.Formats.PowerupDef"
			local pupTrans = MaxMatrix3ToToxicRagersMatrix3D (ConvertMatrixToCRSpace powerupNode.Transform)
			pupData.Transform = pupTrans
			pupData.RespawnTime = powerupModifier.RespawnTime
			pupData.PowerupCount = powerupModifier.PowerupTypes.Count
			for i = 1 to pupData.PowerupCount do (
				pupData.PowerupNames.Add powerupModifier.PowerupTypes[i]
			)
		)
	)
)

fn Funsize_ExportLevelPaths levelModifier levelInfoModifier overridePath:unsupplied = (

	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
	
	if overridePath != unsupplied then (
		FunsizeDataPath = overridePath
	)

	
)

fn Funsize_ExportLevelTxt levelModifier levelInfoModifier overridePath:unsupplied = (

	
	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
	
	if overridePath != unsupplied then (
		FunsizeDataPath = overridePath
	)
	
	local pathClass = (dotnetclass "System.IO.Path")
	local levelTxtPath = pathClass.Combine #(FunsizeDataPath, "Data", "Content", "TRACKS", "LEVELS", levelModifier.LevelFolderName, levelModifier.LevelFileName)
	/*
	levelModifier.LevelFileName = "level_"+(levelNumString)+".txt"
	levelModifier.LevelLayerName = "sys_level_"+(levelNumString)
	levelModifier.LevelPedLayerName = levelModifier.LevelLayerName + "_ped"
	levelModifier.LevelPowerupLayerName = levelModifier.LevelLayerName + "_powerups"
	levelModifier.LevelPathsLayerName = levelModifier.LevelLayerName + "_paths"
*/
	--levelModifier.LevelName = FunsizeGetValueFromXml (folderName+"_"+levelNumString)

	local levelTxt = dotnetobject "ToxicRagers.CarmageddonMobile.Formats.Level"

	if levelModifier.Environment != undefined then (
		levelTxt.Environment = levelModifier.Environment
	)
	if levelModifier.EnvironmentMap != undefined then (
		levelTxt.EnvironmentMap = levelModifier.EnvironmentMap
	)
	if levelModifier.ShadowStrength != undefined then (
		levelTxt.ShadowStrength = MaxColorToToxicRagersVector3 levelModifier.ShadowStrength
		--levelModifier.ShadowStrength = color (levelTxt.ShadowStrength.X * 255) (levelTxt.ShadowStrength.Y * 255) (levelTxt.ShadowStrength.Z * 255)
	)
	if levelModifier.MapName != undefined then (
		levelTxt.Map = dotnetObject "ToxicRagers.CarmageddonMobile.Formats.MapData"
		levelTxt.Map.Name = levelModifier.MapName
		levelTxt.Map.Size = (dotnetObject "ToxicRagers.Helpers.Vector2" levelModifier.MapSize.x levelModifier.MapSize.y)
		levelTxt.Map.Center = (dotnetObject "ToxicRagers.Helpers.Vector2" levelModifier.MapCenter.x levelModifier.MapCenter.y)
		--levelModifier.MapSize = point3 levelTxt.Map.Size.X levelTxt.Map.Size.Y 0
		--levelModifier.MapCenter = point3 levelTxt.Map.Center.X levelTxt.Map.Center.Y 0
	)
	if levelModifier.BigMap != undefined then (
		levelTxt.BigMap = levelModifier.BigMap
	)

	local gridHelper =levelModifier.GridHelper.Node
	levelTxt.Grid = dotnetObject "ToxicRagers.CarmageddonMobile.Formats.GridData"
	levelTxt.Grid.Position = MaxPoint3ToToxicRagersVector3 gridHelper.Position
	levelTxt.Grid.Orientation = (-gridHelper.rotation.z) + 90
	


	--levelModifier.GridHelper =  nodeTransformMonitor node:gridHelper forwardTransformChangeMsgs:false

	levelTxt.MapMatrix = MaxMatrix3ToToxicRagersMatrix3D levelModifier.MapMatrix 
	levelTxt.Fog = MaxColorToToxicRagersColour levelModifier.FogColour
	levelTxt.Lighting = MaxColorToToxicRagersColour levelModifier.LightingColour
	levelTxt.SetProperty "Headlights" levelModifier.Headlights
	if levelModifier.Splash != undefined then (
		levelTxt.Splash = levelModifier.Splash
	)
	if levelModifier.AutoRecoverHeightEnabled then (
		levelTxt.AutoRecoverHeight = levelModifier.AutoRecoverHeight
	)
	levelTxt.SetProperty "Viz" levelModifier.Viz
	levelTxt.AIPath = levelModifier.AIPath

	for i = 1 to (levelModifier.SmokeColours.count) do
	(
		local smokeColour = levelModifier.SmokeColours[i]
		levelTxt.SmokeColours.Add (MaxColorToToxicRagersColour smokeColour)
	)
	
	local matMods = FilterString levelModifier.MatMods ":"
	for i = 1 to matMods.count do
	(
		local matmodinfo = FilterString matMods[i] ";"
		local matmod = dotNetObject "ToxicRagers.CarmageddonMobile.Formats.MatMod"
		
		matMod.WallFriction = matmodinfo[1] as float
		matMod.TyreFriction = matmodinfo[2] as float
		matMod.DownForce = matmodinfo[3] as float
		matMod.Bumpiness = matmodinfo[4] as float
		matMod.TyreSound = matmodinfo[5] as integer 
		matMod.CrashSound = matmodinfo[6] as integer
		matMod.ScrapeSound = matmodinfo[7] as integer
		matMod.Sparks = matmodinfo[8] as float
		matMod.SmokeType = matmodinfo[9] as float
		
		levelTxt.MatMods.Add matMod
	)

	Funsize_CollectAccessoriesForLevelTxt levelModifier levelInfoModifier levelTxt

	levelTxt.Save levelTxtPath
)

fn ExportFunsizeLevel levelRoot nolaunch:false overridePath:unsupplied = (
	global CarmaSettings
	global MaterialsToExport
	
	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
	
	if overridePath != unsupplied then (
		FunsizeDataPath = overridePath
	)
	for obj in objects where (findstring obj.name "sys_RaceInfo_") == 1 and obj.modifiers["Funsize Level Info"] != undefined do (
	--for mat in scenematerials do format "%: %\n" mat.name (classof mat)
	ApplyMTLToAllMatsInScene OnlyWithDiffuse:false OnlyProperlyNamed:true
	
	local levelModifier = levelRoot.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = levelRoot.modifiers["Funsize Level Info"] 

		Funsize_AddLeveltoXML levelInfoModifier overridePath:overridePath
		Funsize_UpdateCareersTXT levelModifier levelInfoModifier overridePath:overridePath
		Funsize_ExportLevelPaths levelModifier levelInfoModifier overridePath:overridePath
		Funsize_ExportLevelTxt levelModifier levelInfoModifier overridePath:overridePath

	)
	
	levelFolder = (FunsizeDataPath+"Data\\Content\\Tracks\\Levels\\" + levelModifier.LevelFolderName + "\\")
	
	
	MaterialsToExport=#()
	ExportMDL levelFolder false true exportMats:true exportTextures:true funsizeExport:true createOctree:true nodes:#(levelRoot)
	ExportCNT (levelFolder+"level.cnt") levelRoot
	for mat in MaterialsToExport do format "%, %\n" mat[2].name mat[2].mat_flags
	ExportMaterialsAndTextures levelFolder exportMats:true exportTextures:true funsizeExport:true createOctree:false
	--RenderMobileUIAssets carModifier.CarName FunsizeDataPath
	

	if CarmaSettings.FunsizeSettings.AutoBuild and nolaunch == false then (
		PackObb()
	)
)
format "Finished loading C1Mobile_ExportLevel.ms\n\n"
