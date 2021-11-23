struct CRFunsizeSettings (
	ADB = "",
	DeviceIP = "",
	GibbedPacker = "",
	ObbPacker = "",
	WorkingFolder = "",
	DataFolder = "",
	ObbName = "main.507.com.stainlessgames.carmageddon.obb",
	WadName = "Data_Android.wad",
	AutoBuild = false, 
	AutoLaunchGame = false,
	AutoDeployObb = false,

	fn Load iniPath = (
		if hasINISetting iniPath "Funsize" then (
			ADB = getINISetting iniPath "Funsize" "ADB"
			DeviceIP = getINISetting iniPath "Funsize" "DeviceIP"
			GibbedPacker = getINISetting iniPath "Funsize" "GibbedPacker"
			ObbPacker = getINISetting iniPath "Funsize" "ObbPacker"
			WorkingFolder = getINISetting iniPath "Funsize" "WorkingFolder"
			if WorkingFolder[WorkingFolder.Count] != "\\" then WorkingFolder = WorkingFolder +"\\"

			DataFolder = getINISetting iniPath "Funsize" "DataFolder"
			if DataFolder[DataFolder.Count] != "\\" then DataFolder = DataFolder +"\\"
			
			ObbName = getINISetting iniPath "Funsize" "ObbName"
			WadName = getINISetting iniPath "Funsize" "WadName"

			if (getINISetting iniPath "Funsize" "AutoLaunchGame") == "true" then (
				AutoLaunchGame = true
			)
			else (
				AutoLaunchGame = false
			)
			if (getINISetting iniPath "Funsize" "AutoDeployObb") == "true" then (
				AutoDeployObb = true
			)
			else (
				AutoDeployObb = false
			)
			if (getINISetting iniPath "Funsize" "AutoBuild") == "true" then (
				AutoBuild = true
			)
			else (
				AutoBuild = false
			)
		)
	),
	fn Save iniPath = (
			setINISetting iniPath "Funsize" "ADB" ADB
			setINISetting iniPath "Funsize" "DeviceIP" DeviceIP
			setINISetting iniPath "Funsize" "GibbedPacker" GibbedPacker
			setINISetting iniPath "Funsize" "ObbPacker" ObbPacker
			setINISetting iniPath "Funsize" "WorkingFolder" WorkingFolder
			setINISetting iniPath "Funsize" "DataFolder" DataFolder
			setINISetting iniPath "Funsize" "ObbName" ObbName
			setINISetting iniPath "Funsize" "WadName" WadName

			if AutoLaunchGame then (
				setINISetting iniPath "Funsize" "AutoLaunchGame" "true"
			)
			else (
				setINISetting iniPath "Funsize" "AutoLaunchGame" "false"
			)
			if AutoBuild then (
				setINISetting iniPath "Funsize" "AutoBuild" "true"
			)
			else (
				setINISetting iniPath "Funsize" "AutoBuild" "false"
			)
			if AutoDeployObb then (
				setINISetting iniPath "Funsize" "AutoDeployObb" "true"
			)
			else (
				setINISetting iniPath "Funsize" "AutoDeployObb" "false"
			)
	)
)
struct CRExportSettings (
	ExportTextures = true,
	ExportMaterials = true,
	ExportMTL = false,
	ExportOldCNT = false,

	fn Load iniPath = (


		if (getINISetting iniPath "Export" "ExportTextures") == "true" then
			ExportTextures = true
		else if (hasINISetting iniPath "Export" "ExportTextures") then
			ExportTextures = false

		if (getINISetting iniPath "Export" "ExportMaterials") == "true" then
			ExportMaterials = true
		else if (hasINISetting iniPath "Export" "ExportMaterials") then
			ExportMaterials = false

		if (getINISetting iniPath "Export" "ExportMTL") == "true" then
			ExportMTL = true
		else if (hasINISetting iniPath "Export" "ExportMTL") then
			ExportMTL = false

		if (getINISetting iniPath "Export" "ExportOldCNT") == "true" then
			ExportOldCNT = true
		else if (hasINISetting iniPath "Export" "ExportOldCNT") then
			ExportOldCNT = false
	),
	fn Save iniPath = (

		if ExportTextures == true then 
			setINISetting iniPath "Export" "ExportTextures" "true"	
		else 
			setINISetting iniPath "Export" "ExportTextures" "false"

		if ExportMaterials == true then 
			setINISetting iniPath "Export" "ExportMaterials" "true"
		else
			setINISetting iniPath "Export" "ExportMaterials" "false"

		if ExportMTL == true then
			setINISetting iniPath "Export" "ExportMTL" "true"
		else 
			setINISetting iniPath "Export" "ExportMTL" "false"

		if ExportOldCNT == true then
			setINISetting iniPath "Export" "ExportOldCNT" "true"
		else 
			setINISetting iniPath "Export" "ExportOldCNT" "false"
	)
)
struct CRImportSettings (
	ImportTextures = true,
	UsePrepData = true,
	UseTriStrips = false,
	MergeSplits = true,
	SpawnOctree = false,

	fn Load iniPath = (
		if hasINISetting iniPath "Import" then (
			if (getINISetting iniPath "Import" "ImportTextures") == "true" then
				ImportTextures = true
			else if (hasINISetting iniPath "Import" "ImportTextures") then
				ImportTextures = false

			if (getINISetting iniPath "Import" "UserPrepData") == "true" then
				UsePrepData = true
			else if (hasINISetting iniPath "Import" "UserPrepData") then
				UsePrepData = false

			if (getINISetting iniPath "Import" "UseTriStrips") == "true" then
				UseTriStrips = true
			else if (hasINISetting iniPath "Import" "UseTriStrips") then
				UseTriStrips = false

			if (getINISetting iniPath "Import" "MergeSplits") == "true" then
				MergeSplits = true
			else if (hasINISetting iniPath "Import" "MergeSplits") then
				MergeSplits = false
		)
	),
	fn Save iniPath = (
		if ImportTextures == true then
			setINISetting iniPath "Import" "ImportTextures" "true"	
		else 
			setINISetting iniPath "Import" "ImportTextures" "false"

		if UsePrepData == true then
			setINISetting iniPath "Import" "UserPrepData" "true"
		else
			setINISetting iniPath "Import" "UserPrepData" "false"

		if UseTriStrips == true then
			setINISetting iniPath "Import" "UseTriStrips" "true"
		else 
			setINISetting iniPath "Import" "UseTriStrips" "false"
			

		if MergeSplits == true then
			setINISetting iniPath "Import" "MergeSplits" "true"
		else 
			setINISetting iniPath "Import" "MergeSplits" "false"

	)
)
struct CRUISettings (
	UseNewUI = false,
	AutoSwapContext = true,

	fn Load iniPath = (

		if (getINISetting iniPath "UI" "UseNewUI") == "true" then
			UseNewUI = true
		else
			UseNewUI = false

		if (getINISetting iniPath "UI" "AutoSwapContext") == "true" then
			AutoSwapContext = true
		else
			AutoSwapContext = false
	),
	fn Save iniPath = (
		if (UseNewUI == true) then
			setINISetting iniPath "UI" "UseNewUI" "true"
		else
			setINISetting iniPath "UI" "UseNewUI" "false"

		if (AutoSwapContext == true) then
			setINISetting iniPath "UI" "AutoSwapContext" "true"
		else
			setINISetting iniPath "UI" "AutoSwapContext" "false"
	)
)
struct CRSettings (
	GamePath,
	DataCorePath, 
	AllowSeperateDataCore, 
	SetupForUE4, 
	ConvertTexturesInPlace, 
	TexturePath, 
	GibbedTools, 
	LOLDecoder, 
	MaxResolution,
	MaxResolutionID,
	UISettings = CRUISettings(),
	ImportSettings = CRImportSettings(),
	ExportSettings = CRExportSettings(),
	FunsizeSettings = CRFunsizeSettings(),
	fn Load iniPath = (

		UISettings.Load iniPath
		ImportSettings.Load iniPath
		ExportSettings.Load iniPath
		FunsizeSettings.Load iniPath

		GamePath = getINISetting iniPath "Paths" "GamePath"
		
		if (getINISetting iniPath "Paths" "AllowSeperateDataCore") == "true" then
		(	
			AllowSeperateDataCore = true
			DataCorePath = getINISetting iniPath "Paths" "DataCorePath"
		)
		else
		(
			AllowSeperateDataCore = false
			DataCorePath = GamePath+"\\Data_Core"
		)
		--DataCorePath = getINISetting iniPath "Paths" "DataCorePath"
		if (getINISetting iniPath "Paths" "ConvertTexturesInPlace") == "true" then
			ConvertTexturesInPlace = true
		else
			ConvertTexturesInPlace = false

		if (getINISetting iniPath "Transforms" "SetupForUE4") == "true" then
			SetupForUE4 = true
		else
			SetupForUE4 = false	

		TexturePath = getINISetting iniPath "Paths" "TextureConversionPath"
		GibbedTools = getINISetting iniPath "Paths" "GibbedTools"
		LOLDecoder = getINISetting iniPath "Paths" "LOLDecoder"
		MaxResolution = getINISetting iniPath "Textures" "MaxResolution"
		
	),
	fn Save iniPath:unsupplied = (
			
		if iniPath == unsupplied then (
			currentScriptFileName = getThisScriptFilename()
			currentScriptFolder = getFilenamePath currentScriptFileName
			iniPath = (currentScriptFolder+"CarmaReincarnationToolsSettings.ini")
		)
		setINISetting iniPath "Paths" "GamePath" GamePath

		UISettings.Save iniPath
		ImportSettings.Save iniPath
		ExportSettings.Save iniPath
		FunsizeSettings.Save iniPath
		
		if AllowSeperateDataCore == true then
			setINISetting iniPath "Paths" "AllowSeperateDataCore" "true"
		else
			setINISetting iniPath "Paths" "AllowSeperateDataCore" "false"

		setINISetting iniPath "Paths" "DataCorePath" DataCorePath
		if ConvertTexturesInPlace then
			setINISetting iniPath "Paths" "ConvertTexturesInPlace" "true"
		else
			setINISetting iniPath "Paths" "ConvertTexturesInPlace" "false"
		setINISetting iniPath "Paths" "TextureConversionPath" TexturePath
		setINISetting iniPath "Paths" "GibbedTools" GibbedTools
		setINISetting iniPath "Paths" "LOLDecoder" LOLDecoder
		setINISetting iniPath "Textures" "MaxResolution" (MaxResolution as String)

		if SetupForUE4 == true then
			setINISetting iniPath "Transforms" "SetupForUE4" "true"
		else
			setINISetting iniPath "Transforms" "SetupForUE4" "false"
	)	
)
