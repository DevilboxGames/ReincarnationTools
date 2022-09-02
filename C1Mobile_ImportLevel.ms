fn ImportFunsizeLevelTXT filename  = (
	global CarmaSettings
	local pathClass = (dotnetclass "System.IO.Path")
	local levelTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.Level").Load filename

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

	if (LayerManager.getLayerFromName LevelLayerName) == undefined then(
		LayerManager.newLayerFromName LevelLayerName
	)
	if (LayerManager.getLayerFromName LevelPedLayerName) == undefined then(
		LayerManager.newLayerFromName LevelPedLayerName
	)
	if (LayerManager.getLayerFromName LevelPowerupLayerName) == undefined then(
		LayerManager.newLayerFromName LevelPowerupLayerName
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

	local racingIndex = (filterstring (pathClass.GetFileNameWithoutExtension fileName) "_")[2] as integer
	SetFunsizeLevelSettingsFromTXT levelRoot levelTxt (GetFolderName FileName) racingIndex

	for i = 0 to levelTxt.Accessories.count - 1 do (
		local accData = levelTxt.Accessories.item[i]
		local accTransform = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 accData.Transform)
		PlaceAccessory accTransform accData.Name accData.InstanceName (ToxicRagersColourToMaxColor accData.InstanceColour)
	)

)