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
	global CarmaSettings
	FunsizeDataDirectory = CarmaSettings.FunsizeSettings.DataFolder
	WadFilePath =  CarmaSettings.FunsizeSettings.WorkingFolder +  CarmaSettings.FunsizeSettings.WadName
	ObbFilePath =  CarmaSettings.FunsizeSettings.WorkingFolder +  CarmaSettings.FunsizeSettings.ObbName
	if (doesFileExist  WadFilePath) then 
	(
		DOSCommand ("del " + WadFilePath)
	)

	if (doesFileExist  ObbFilePath) then 
	(
		DOSCommand ("del " + ObbFilePath)
	)

	workingDrive = (FilterString CarmaSettings.FunsizeSettings.WorkingFolder "\\")[1]
	datadir = substituteString FunsizeDataDirectory "\\" "/"
	waddir = substituteString WadFilePath "\\" "/"
	
	if datadir[datadir.count] == "/" then datadir = substring datadir 1 (datadir.count-1)
	DOSCommand (workingDrive + "&& cd "+ CarmaSettings.FunsizeSettings.WorkingFolder +"&&cd bin&&"+CarmaSettings.FunsizeSettings.GibbedPacker + " \"" + datadir + "\" \""+ waddir + "\"&&cd.." )
	DOSCommand (workingDrive + "&& cd "+ CarmaSettings.FunsizeSettings.WorkingFolder +"&&"+CarmaSettings.FunsizeSettings.ObbPacker)
	if CarmaSettings.FunsizeSettings.AutoDeployObb then (
		
		DOSCommand (CarmaSettings.FunsizeSettings.ADB + " disconnect " )
		DOSCommand (CarmaSettings.FunsizeSettings.ADB + " connect " + CarmaSettings.FunsizeSettings.DeviceIP )
		
		DOSCommand (workingDrive + "&& cd "+ CarmaSettings.FunsizeSettings.WorkingFolder +"&&"+CarmaSettings.FunsizeSettings.ADB + " push " + CarmaSettings.FunsizeSettings.ObbName + " /sdcard/Android/obb/com.stainlessgames.carmageddon/" + CarmaSettings.FunsizeSettings.ObbName )

		if CarmaSettings.FunsizeSettings.AutoLaunchGame then (
			
			DOSCommand (CarmaSettings.FunsizeSettings.ADB + " shell am start -n com.stainlessgames.carmageddon/.ParsonsLoader ")
		)
	)
)