

fn ProcessAllAccessories inputPath outputPath:unsupplied skipTo:0 = (

format "Looking in folder %\n" (inputPath+"Accessories\\")
	local rootAccessoryFolders = getDirectories (inputPath+"Accessories\\*")
	local levelFolders = getDirectories (inputPath+"Levels\\*")
	for levelFolder in levelFolders do (
		rootAccessoryFolders = rootAccessoryFolders + (getDirectories (levelFolder+"Accessories\\*"))
	)
	rootAccessoryFolders = rootAccessoryFolders + (getDirectories (inputPath+"Pickups\\*"))

	format "Found % accessories\n" rootAccessoryFolders.count
	local numProcessed = 0
	for filePath in rootAccessoryFolders do (
		if numProcessed >= skipTo then (
		format "Loading accessory %\n" filePath
		local file = filePath+"accessory.cnt"
		local importTextures = CarmaSettings.ImportSettings.importTextures
		local forcePrep = CarmaSettings.ImportSettings.UsePrepData
		local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
		local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
		local SpawnOctree = false
		
		local rootMesh = ImportCNT file importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		
		local accessoryTxtPath = (dotnetclass "System.IO.Path").Combine filePath "accessory.txt"

		local accessoryTxt = ImportAccessoryTXT accessoryTxtPath rootMesh
		if outputPath != unsupplied then (
			select rootMesh
			local destination = outputPath + (substring filePath inputPath.count filePath.count)
			makedir destination
			local outputfile = destination + "accessory.txt"
			ExportAccessoryTXT outputfile rootMesh
		)
		select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		)
			numProcessed = numProcessed+1

			--if numProcessed > 500 then return 0
		
	)
)



ProcessAllAccessories "D:\\Steam\\steamapps\\common\\Carmageddon Max Damage\\Data_Core\\Content\\" outputPath:"D:\\Work\\ReincarnationTools\\MaxScriptTools\\text_exports\\accessories" skipto:852