struct FunsizePackAndLaunchDetails (
	ADB,
	DeviceIP,
	GibbedPacker,
	ObbPacker,
	WorkingFolder,
	DataFolder,
	ObbName,
	WadName,
	AutoBuild,
	AutoLaunchGame,
	AutoDeployObb
)

global FunsizeLaunchInfo = FunsizePackAndLaunchDetails()

fn PackObb = (
	global FunsizeLaunchInfo
	FunsizeDataDirectory = FunsizeLaunchInfo.DataFolder
	WadFilePath =  FunsizeLaunchInfo.WorkingFolder +  FunsizeLaunchInfo.WadName
	ObbFilePath =  FunsizeLaunchInfo.WorkingFolder +  FunsizeLaunchInfo.ObbName
	if (doesFileExist  WadFilePath) then 
	(
		DOSCommand ("del " + WadFilePath)
	)

	if (doesFileExist  ObbFilePath) then 
	(
		DOSCommand ("del " + ObbFilePath)
	)

	workingDrive = (FilterString FunsizeLaunchInfo.WorkingFolder "\\")[1]
	datadir = substituteString FunsizeDataDirectory "\\" "/"
	waddir = substituteString WadFilePath "\\" "/"
	
	if datadir[datadir.count] == "/" then datadir = substring datadir 1 (datadir.count-1)
	DOSCommand (workingDrive + "&& cd "+ FunsizeLaunchInfo.WorkingFolder +"&&cd bin&&"+FunsizeLaunchInfo.GibbedPacker + " \"" + datadir + "\" \""+ waddir + "\"&&cd.." )
	DOSCommand (workingDrive + "&& cd "+ FunsizeLaunchInfo.WorkingFolder +"&&"+FunsizeLaunchInfo.ObbPacker)
	if FunsizeLaunchInfo.AutoDeployObb then (
		
		DOSCommand (FunsizeLaunchInfo.ADB + " disconnect " )
		DOSCommand (FunsizeLaunchInfo.ADB + " connect " + FunsizeLaunchInfo.DeviceIP )
		
		DOSCommand (workingDrive + "&& cd "+ FunsizeLaunchInfo.WorkingFolder +"&&"+FunsizeLaunchInfo.ADB + " push " + FunsizeLaunchInfo.ObbName + " /sdcard/Android/obb/com.stainlessgames.carmageddon/" + FunsizeLaunchInfo.ObbName )

		if FunsizeLaunchInfo.AutoLaunchGame then (
			
			DOSCommand (FunsizeLaunchInfo.ADB + " shell am start -n com.stainlessgames.carmageddon/.ParsonsLoader ")
		)
	)
)