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
MaxTextureResolutionOptions = #("8192", "4096","2048","1024","512","256","128","64")
rollout carma_reincarnation_settings "Settings"
(
	global CarmaSettings
	
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
	button saveButton "Save Settings" across:2
	button cancelButton "Cancel" across:2
	
	on carma_reincarnation_settings open do
	(
		chk_AllowSeperateDataCore.checked = CarmaSettings.AllowSeperateDataCore
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

		DestroyDialog carma_reincarnation_settings
	)
)
