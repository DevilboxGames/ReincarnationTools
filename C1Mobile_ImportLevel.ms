fn ImportFunsizeLevelTXT filename  = (
	global CarmaSettings

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder

	local pathClass = (dotnetclass "System.IO.Path")
	local levelTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.Level").Load filename
	local careersTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.CareerModeTxt").Load (pathClass.Combine #(FunsizeDataPath, "Data", "Content", "careermode.txt"))
	local textXml = (dotnetobject "ToxicRagers.CarmageddonMobile.Formats.TextXml" (pathClass.Combine #(FunsizeDataPath, "Data", "Content","Text", "Text.xml")))

	local importTextures = CarmaSettings.ImportSettings.importTextures
	local forcePrep = CarmaSettings.ImportSettings.UsePrepData
	local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
	local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
	local SpawnOctree = false
	
	local levelFolder = pathClass.GetDirectoryName filename

	local levelNumString = (filterstring (pathClass.GetFileNameWithoutExtension fileName) "_")[2]
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
	local levelRoot = ImportCNT levelCntPath importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
	
	local levelNull = CreateNewNULLNode levelRoot.transform "level.cnt" addAttributes:true nodeType:"CNT"
	levelNull.modifiers["CNT Hierarchy"].FileName = "level.cnt"
	levelRoot.parent = levelNull
	if (doesFileExist lightCntPath) then (
		local lightRoot = ImportCNT lightCntPath importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		local lightNull = CreateNewNULLNode lightRoot.transform "light.cnt" addAttributes:true nodeType:"CNT"
		lightNull.modifiers["CNT Hierarchy"].FileName = "light.cnt"
		lightRoot.parent = lightNull
	)

	local currentLayer = layerManager.current

	(layerManager.getLayerFromName LevelLayerName).current = true
	local racingIndex = (filterstring (pathClass.GetFileNameWithoutExtension fileName) "_")[2] as integer
	SetFunsizeLevelSettingsFromTXT levelRoot levelTxt careersTxt textXml (GetFolderName FileName) racingIndex

	for i = 0 to levelTxt.Accessories.count - 1 do (
		local accData = levelTxt.Accessories.item[i]
		local accTransform = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 accData.Transform)
		PlaceAccessory accTransform accData.Name accData.InstanceName (ToxicRagersColourToMaxColor accData.InstanceColour)
	)

	for i = 0 to levelTxt.Cops.count - 1 do (
		local copData = levelTxt.Cops.item[i]
		local copType = copData.Type.ToString()
		local copPos = (ConvertCopFromFunsize (ToxicRagersVector3ToMaxPoint3 copData.Position)) 
		PlaceCopHelper copType copPos
	)

	(layerManager.getLayerFromName LevelPedLayerName).current = true

	for i = 0 to levelTxt.Peds.count - 1 do (
		local pedData = levelTxt.Peds.item[i]
		local pedPoints = #()
		for i = 0 to pedData.Paths.count - 1 do (
			local pathPoint = ConvertFromCRSpace (ToxicRagersVector3ToMaxPoint3 pedData.Paths.item[i])
			append pedPoints pathPoint
		)
		PlacePed pedData.PedType pedPoints pedData.LoopCount
	)

	(layerManager.getLayerFromName LevelPowerupLayerName).current = true

	for i = 0 to levelTxt.Powerups.count - 1 do (
		local pupDef = levelTxt.Powerups.item[i]
		local pupTrans = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 pupDef.Transform)
		local pupTypes = #()
		for p = 0 to pupDef.PowerupNames.count - 1 do (
			append pupTypes pupDef.PowerupNames.item[p]
		)

		PlacePowerup pupTrans pupTypes pupDef.RespawnTime
	)
	(layerManager.getLayerFromName LevelPathsLayerName).current = true

	ParseLevelRoutesTXT ((dotnetclass "System.IO.Path").Combine #((getFileNamePath filename), ("paths_"+levelNumString+".txt")))

	currentLayer.current = true

)