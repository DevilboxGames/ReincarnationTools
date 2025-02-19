fn ImportFunsizeLevelTXT filename  = (
	global CarmaSettings

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder

	local pathClass = (dotnetclass "System.IO.Path")
	local careersTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.CareerModeTxt").Load (pathClass.Combine #(FunsizeDataPath, "Data", "Content", "careermode.txt"))
	local textXml = (dotnetobject "ToxicRagers.CarmageddonMobile.Formats.TextXml" (pathClass.Combine #(FunsizeDataPath, "Data", "Content","Text", "Text.xml")))

	local importTextures = CarmaSettings.ImportSettings.importTextures
	local forcePrep = CarmaSettings.ImportSettings.UsePrepData
	local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
	local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
	local SpawnOctree = false
	
	local levelFolder = pathClass.GetDirectoryName filename

	
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
	local levelTxtFiles = getFiles (pathClass.Combine levelFolder "level_*.txt")

	local pathManager = GetLevelAIPathManager()
	
	pathManager.IsFunsize = true
	for i=1 to levelTxtFiles.Count do (
		format "levelTxtFiles[%] = %\n" i levelTxtFiles[i]
		currentLayer.current = true
		local levelTxtFilename = leveltxtFiles[i]	
		local levelTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.Level").Load levelTxtFilename
		local levelNumString = (filterstring (pathClass.GetFileNameWithoutExtension levelTxtFilename) "_")[2]
			
		--if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString
		local LevelLayerName = "sys_level_"+(levelNumString)
		local LevelPedLayerName = LevelLayerName + "_ped"
		local LevelPowerupLayerName = LevelLayerName + "_powerups"
		local LevelPathsLayerName = "sys_LevelRoutes_" + levelNumString

		
		local raceInfoNull = CreateNewNULLNode levelRoot.transform ("sys_RaceInfo_"+levelNumString) addAttributes:true nodeType:"IGNORE"
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

		(layerManager.getLayerFromName LevelLayerName).current = true
		local racingIndex = (filterstring (pathClass.GetFileNameWithoutExtension levelTxtFilename) "_")[2] as integer
		SetFunsizeLevelSettingsFromTXT raceInfoNull levelTxt careersTxt textXml (GetFolderName levelTxtFilename) racingIndex



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

		format "funsizeraceindex: % (%)\n" (levelNumString as integer) levelNumString
		ParseLevelRoutesTXT ((dotnetclass "System.IO.Path").Combine #((getFileNamePath levelTxtFilename), ("paths_"+levelNumString+".txt"))) layerToUse:LevelPathsLayerName
	)
	currentLayer.current = true

)