
	filein "Carma_ImportV19-Trent.ms"
	filein "ReincarnationTools.ms"

C1Folder = "g:\\Carma1\\"
C1DataFolder = C1Folder+"data\\"
C2Folder = "g:\\VanillaC2\\"
C2DataFolder = C2Folder+"data\\"
	CarsFolder = "cars\\"



fn ExportToFBX obj filename params selectedOnly:false = (
	select obj
	for param in params do FbxExporterSetParam param[1] param[2]

	makeDir (getFilenamePath filename)
	format "Exporting % to %\n" obj.name filename
	exportFile filename #noPrompt selectedOnly:selectedOnly using:FBXEXP
)

fn ConvertAllC2Cars exportFolder = (
	carFolders = getDirectories "G:\\VanillaC2\\Data\\CARS\\*"
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
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
	while i <= numCars do (
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".dat")).count != 0 then (
			
		--	try (
				carRoot = LoadC2Dat (C2DataFolder+CarsFolder+carName+"\\"+carName+".dat") &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
				ExportToFBX carRoot (exportFolder+"C2\\"+carname+"\\"+carname+".fbx") exportParams
				numConverted = numConverted + 1
		--	)
		/*	catch (
				numErrors = numErrors + 1
				format "Failed to convert %\n" carname to:errors
				KeepMaxAlive()
				CompleteRedraw()
			)
		*/	select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		)
		i = i + 1

		if i > 100 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)
fn ConvertAllC1Cars exportFolder = (
	carFolders = getFiles (C1DataFolder+CarsFolder+"*.txt")
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
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
	while i <= numCars do (
		carTxt = carFolders[i]
		carName = getfilenamefile carTxt
		
			--try (
				carRoot = LoadC1TXT  (C1DataFolder+CarsFolder+carName+".txt") &progressValue &progressText imp_onlyMainMeshes:true imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
	
				ExportToFBX carRoot (exportFolder+"C1\\"+carname+"\\"+carname+".fbx") exportParams
				numConverted = numConverted + 1
			--)
			/*catch (
				numErrors = numErrors + 1
				format "Failed to convert %\n" carname to:errors
				KeepMaxAlive()
				CompleteRedraw()
			)*/
			select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		
		i = i + 1

		if i > 100 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)


fn RenderAllC2Cars saveFolder = (
	carFolders = getDirectories "G:\\VanillaC2\\Data\\CARS\\*"
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
	renderSize = [2560,2560]
	while i <= numCars do (
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".dat")).count != 0 then (
			
		--	try (
				carRoot = LoadC2Dat (C2DataFolder+CarsFolder+carName+"\\"+carName+".dat") &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
				RenderThreeQuarterView (saveFolder+"C2\\"+carname+".png") outputsize:renderSize carroot:carRoot
				numConverted = numConverted + 1
		--	)
		/*	catch (
				numErrors = numErrors + 1
				format "Failed to convert %\n" carname to:errors
				KeepMaxAlive()
				CompleteRedraw()
			)
		*/	select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		)
		i = i + 1

		if i > 100 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)