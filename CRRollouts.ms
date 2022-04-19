rollout carma_reincarnation_dockfloater "Carmageddon Reincarnation Tools" width:420 height: 500
(
	dotnetcontrol eh "System.Windows.Forms.ContainerControl" width:405 height:500 align:#left
	local doRefresh = true
	
	on carma_reincarnation_dockfloater open do
	(	
		global CRToolsUI = eh
		carma_reincarnation_dockfloater.resized([405,500])
	)
	
	on carma_reincarnation_dockfloater clode do
	(
		global CToolsUI = undefined
	)
	
	on carma_reincarnation_dockfloater resized size do
	(
		--format "Rollout size: %\n" size
		eh.width = size.x
		eh.height = size.y
	)
	on eh Paint args do
	(
		if doRefresh then
		(
			doRefresh = false
			eh.refresh()
			doRefresh = true
		)
	)
)
global MaxTextureResolutionOptions = #("8192", "4096","2048","1024","512","256","128","64")
rollout carma_reincarnation_settings "Settings"
(
	global CarmaSettings, FunsizeLaunchInfo
	
	Group "Paths" 
	(
		editText gameFolderTextBox "Game Folder:" fieldWidth: 210 across: 2 labelOnTop:true text:CarmaSettings.GamePath
		button setGameFolder "Browse" align:#right offset:[0,16]
		checkbox chk_AllowSeperateDataCore "Custom Data_Core folder"
		editText dataCoreFolderTextBox "Data_Core Folder:" fieldWidth: 210 across: 2 labelOnTop:true text:CarmaSettings.DataCorePath
		button setDataCoreFolder "Browse" align:#right offset:[0,16]
		checkbox chk_SetupForUE4 "Import for UE4"
		editText GibbedToolsLocationTextBox "Gibbed Tools Location:" fieldWidth: 210 across:2 labelOnTop:true text:CarmaSettings.GibbedTools
		button setGibbedToolsLocation "Browse" align:#right offset:[0,16]
		editText LOLDecoderLocationTextBox "LOL Decoder Location:" fieldWidth: 210 across:2 labelOnTop:true text:CarmaSettings.LOLDecoder
		button setLOLDecoderLocation "Browse" align:#right offset:[0,16]
		checkbox chk_ConvertTexturesInPlace "Convert textures in same folder as TDX file"
		editText textureConversionFolderTextBox "Texture Conversion Folder:" fieldWidth: 210 across:2 labelOnTop:true text:CarmaSettings.TexturePath
		button setTextureFolder "Browse" align:#right offset:[0,16]
		dropdownlist maxTextureRes "Maximum Texture Resolution" items:MaxTextureResolutionOptions selection:(CarmaSettings.MaxResolutionID as Integer)
	)
	group "Funsize Settings" (
		editText funsizeDataFolderTextBox "Data_Android Folder:" fieldWidth: 210 across: 2 labelOnTop:true text:FunsizeLaunchInfo.DataFolder
		button setfunsizeDataFolder "Browse" align:#right offset:[0,16]
		editText funsizeAdbPathTextBox "ADB Path:" fieldWidth: 210 across: 2 labelOnTop:true text:FunsizeLaunchInfo.ADB
		button setfunsizeAdbPath "Browse" align:#right offset:[0,16]
		editText funsizeDeviceIPTextBox "Phone IP Address:" fieldWidth: 210 labelOnTop:true text:FunsizeLaunchInfo.DeviceIP
		editText funsizeGibbedPackerPathTextBox "Gibbed Packer Path:" fieldWidth: 210 across: 2 labelOnTop:true text:FunsizeLaunchInfo.GibbedPacker
		button setfunsizeGibbedPackerPath "Browse" align:#right offset:[0,16]
		editText funsizeObbPackerPathTextBox "ObbPacker Path:" fieldWidth: 210 across: 2 labelOnTop:true text:FunsizeLaunchInfo.ObbPacker
		button setfunsizeObbPackerPath "Browse" align:#right offset:[0,16]
		editText funsizeWorkingFolderTextBox "Working Folder:" tooltip:"The folder to store the generated WAD and OBB files in" fieldWidth: 210 across: 2 labelOnTop:true text:FunsizeLaunchInfo.WorkingFolder
		button setfunsizeWorkingFolder "Browse" align:#right offset:[0,16]

		editText funsizeWadFileNameTextBox "Wad File Name:" fieldWidth: 210 labelOnTop:true text:FunsizeLaunchInfo.WadName
		editText funsizeObbFileNameTextBox "Obb File Name:" fieldWidth: 210 labelOnTop:true text:FunsizeLaunchInfo.ObbName
		checkbox chk_AutoBuild "Auto Build On Export"
		checkbox chk_AutoDeployObb "Auto Deploy On Build"
		checkbox chk_AutoLaunchGame "Auto Launch Game On Deploy"
		
	)
	button saveButton "Save Settings" across:2
	button cancelButton "Cancel" across:2
	
	on carma_reincarnation_settings open do
	(
		chk_AllowSeperateDataCore.checked = CarmaSettings.AllowSeperateDataCore
		chk_AutoBuild.checked = FunsizeLaunchInfo.AutoBuild
		chk_AutoDeployObb.checked = FunsizeLaunchInfo.AutoDeployObb
		chk_AutoLaunchGame.checked = FunsizeLaunchInfo.AutoLaunchGame
	)
	on setGameFolder pressed do
	(
		f = getSavePath initialDir:CarmaSettings.GamePath caption:"Browse To Game Folder..."
		if f == undefined then gameFolderTextBox.text = CarmaSettings.GamePath
		else gameFolderTextBox.text = f

		if chk_AllowSeperateDataCore == false then dataCoreFolderTextBox.text = gameFolderTextBox.text + "\\Data_Core"
	)
	on setDataCoreFolder pressed do
	(
		f = getSavePath initialDir:CarmaSettings.DataCorePath caption:"Browse To Data_Core Folder..."
		if f == undefined then dataCoreFolderTextBox.text = CarmaSettings.DataCorePath
		else dataCoreFolderTextBox.text = f
	)
	on chk_AllowSeperateDataCore changed state do
	(
		dataCoreFolderTextBox.enabled = state
		setDataCoreFolder.enabled = state
		if state == false then dataCoreFolderTextBox.text = gameFolderTextBox.text + "\\Data_Core"
	)
	on chk_SetupForUE4 changed state do (

	)
	on chk_ConvertTexturesInPlace changed state do
	(
		textureConversionFolderTextBox.enabled = (state == false)
		setTextureFolder.enabled = (state == false)
		
	)
	on setTextureFolder pressed do
	(
		f = getSavePath initialDir:CarmaSettings.TexturePath caption:"Browse To Texture Conversion Folder..."
		if f == undefined then textureConversionFolderTextBox.text = CarmaSettings.TexturePath
		else textureConversionFolderTextBox.text = f
	)
	on setGibbedToolsLocation pressed do
	(
		f = getOpenFilename caption:"Browse To Gibbed Tools" filename:"Gibbed.Duels.FileFormats.dll" types:"Gibbed.Duels.FileFormats.dll|Gibbed.Duels.FileFormats.dll"
		
		if f == undefined then GibbedToolsLocationTextBox.text = CarmaSettings.GibbedTools
		else GibbedToolsLocationTextBox.text = f
	)
	on setLOLDecoderLocation pressed do
	(
		f = getOpenFilename caption:"Browse To LOLDecoderLib" filename:"LOLDecoderLib.dll" types:"LOLDecoderLib.dll|LOLDecoderLib.dll"
		
		if f == undefined then LOLDecoderLocationTextBox.text = CarmaSettings.LOLDecoder
		else LOLDecoderLocationTextBox.text = f
	)

	on setFunsizeDataFolder pressed do
	(
		f = getSavePath initialDir:FunsizeLaunchInfo.DataFolder caption:"Browse To Extracted Data_Android Folder..."
		if f == undefined then funsizeDataFolderTextBox.text = FunsizeLaunchInfo.DataFolder
		else funsizeDataFolderTextBox.text = f
	)

	on setfunsizeWorkingFolder pressed do
	(
		f = getSavePath initialDir:FunsizeLaunchInfo.WorkingFolder caption:"Browse To Your Working Folder..."
		if f == undefined then funsizeWorkingFolderTextBox.text = FunsizeLaunchInfo.WorkingFolder
		else funsizeWorkingFolderTextBox.text = f
	)

	on setfunsizeAdbPath pressed do
	(
		f = getOpenFilename initialDir:FunsizeLaunchInfo.ADB caption:"Browse To ADB.exe" filename:"adb.exe" types:"adb.exe|adb.exe"
		if f == undefined then funsizeAdbPathTextBox.text = FunsizeLaunchInfo.DataFolder
		else funsizeAdbPathTextBox.text = f
	)

	on setfunsizeGibbedPackerPath pressed do
	(
		f = getOpenFilename initialDir:FunsizeLaunchInfo.GibbedPacker caption:"Browse To Gibbed.Duels.Pack.exe..." filename:"Gibbed.Duels.Pack.exe" types:"Gibbed.Duels.Pack.exe|Gibbed.Duels.Pack.exe"
		if f == undefined then funsizeGibbedPackerPathTextBox.text = FunsizeLaunchInfo.GibbedPacker
		else funsizeGibbedPackerPathTextBox.text = f
	)

	on setfunsizeObbPackerPath pressed do
	(
		f = getOpenFilename initialDir:FunsizeLaunchInfo.ObbPacker caption:"Browse To ObbPacker..." filename:"ObbPacker.exe" types:"ObbPacker.exe|ObbPacker.exe"
		if f == undefined then funsizeObbPackerPathTextBox.text = FunsizeLaunchInfo.ObbPacker
		else funsizeObbPackerPathTextBox.text = f
	)

	on cancelButton pressed do ( DestroyDialog carma_reincarnation_settings)
	on saveButton pressed do
	(
		currentScriptFileName = getThisScriptFilename()
		currentScriptFolder = getFilenamePath currentScriptFileName
		
		
		CarmaSettings.GamePath = gameFolderTextBox.text
		CarmaSettings.DataCorePath = dataCoreFolderTextBox.text
		CarmaSettings.AllowSeperateDataCore = chk_AllowSeperateDataCore.checked
		CarmaSettings.SetupForUE4 = chk_SetupForUE4.checked
		CarmaSettings.ConvertTexturesInPlace = chk_ConvertTexturesInPlace.checked
		CarmaSettings.TexturePath = textureConversionFolderTextBox.text
		CarmaSettings.GibbedTools = GibbedToolsLocationTextBox.text 
		CarmaSettings.LOLDecoder = LOLDecoderLocationTextBox.text 
		CarmaSettings.MaxResolutionID = maxTextureRes.Selection
		CarmaSettings.MaxResolution = MaxTextureResolutionOptions[maxTextureRes.Selection] as Integer
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GamePath" CarmaSettings.GamePath

		if CarmaSettings.AllowSeperateDataCore == true then
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "AllowSeperateDataCore" "true"
		else
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "AllowSeperateDataCore" "false"

		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "DataCorePath" CarmaSettings.DataCorePath
		if CarmaSettings.ConvertTexturesInPlace then
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "ConvertTexturesInPlace" "true"
		else
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "ConvertTexturesInPlace" "false"
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "TextureConversionPath" CarmaSettings.TexturePath
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GibbedTools" CarmaSettings.GibbedTools
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "LOLDecoder" CarmaSettings.LOLDecoder
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Textures" "MaxResolution" (CarmaSettings.MaxResolution as String)

		if CarmaSettings.SetupForUE4 == true then
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Transforms" "SetupForUE4" "true"
		else
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Transforms" "SetupForUE4" "false"


		if FunsizeLaunchInfo != undefined then (
			FunsizeLaunchInfo.ADB = funsizeAdbPathTextBox.text
			FunsizeLaunchInfo.GibbedPacker = funsizeGibbedPackerPathTextBox.text
			FunsizeLaunchInfo.ObbPacker = funsizeObbPackerPathTextBox.text
			FunsizeLaunchInfo.DeviceIP = funsizeDeviceIPTextBox.text
			FunsizeLaunchInfo.WorkingFolder = funsizeWorkingFolderTextBox.text
			FunsizeLaunchInfo.DataFolder = funsizeDataFolderTextBox.text
			FunsizeLaunchInfo.ObbName = funsizeObbFileNameTextBox.text
			FunsizeLaunchInfo.WadName = funsizeWadFileNameTextBox.text
			FunsizeLaunchInfo.AutoBuild = chk_AutoBuild.checked
			FunsizeLaunchInfo.AutoDeployObb = chk_AutoDeployObb.checked
			FunsizeLaunchInfo.AutoLaunchGame = chk_AutoLaunchGame.checked
			if FunsizeLaunchInfo.WorkingFolder[FunsizeLaunchInfo.WorkingFolder.Count] != "\\" then FunsizeLaunchInfo.WorkingFolder = FunsizeLaunchInfo.WorkingFolder +"\\"
			if FunsizeLaunchInfo.DataFolder[FunsizeLaunchInfo.DataFolder.Count] != "\\" then FunsizeLaunchInfo.DataFolder = FunsizeLaunchInfo.DataFolder +"\\"

			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "ADB" FunsizeLaunchInfo.ADB
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "DeviceIP" FunsizeLaunchInfo.DeviceIP
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "GibbedPacker" FunsizeLaunchInfo.GibbedPacker
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "ObbPacker" FunsizeLaunchInfo.ObbPacker
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "WorkingFolder" FunsizeLaunchInfo.WorkingFolder
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "DataFolder" FunsizeLaunchInfo.DataFolder
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "ObbName" FunsizeLaunchInfo.ObbName
			setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "WadName" FunsizeLaunchInfo.WadName

			if FunsizeLaunchInfo.AutoLaunchGame then (
				setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "AutoLaunchGame" "true"
			)
			else (
				setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "AutoLaunchGame" "false"
			)
			if FunsizeLaunchInfo.AutoBuild then (
				setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "AutoBuild" "true"
			)
			else (
				setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "AutoBuild" "false"
			)
			if FunsizeLaunchInfo.AutoDeployObb then (
				setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "AutoDeployObb" "true"
			)
			else (
				setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Funsize" "AutoDeployObb" "false"
			)
		)
		DestroyDialog carma_reincarnation_settings
	)
)
