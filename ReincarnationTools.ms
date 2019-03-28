fileIn "CRFormHelpers.ms"
fileIn "CRRollouts.ms"

fileIn "CRAttributes.ms"

fileIn "CRStructs.ms"
--if PrintMeshScript== undefined then
--(
	filein "CRHelpsFunctions.ms"
--)
--fileIn "CRHelpsFunctions.ms"
fileIn "CRSkeletalAnimation.ms"



filein "CRLights.ms"
fileIn "CRHierarchyTools.ms"

fileIn "CRPlugins.ms"
fileIn "CRCarTools.ms"
fileIn "CRAccessory.ms"
fileIn "CRExport.ms"
fileIn "CRExport_car.ms"
fileIn "CRExport_level.ms"

fileIn "CRImport.ms"
fileIn "CRImport_Car.ms"
fileIn "CRImport_Level.ms"
fileIn "CRImport_Peds.ms"

filein "CRLights.ms"

fileIn "CRToolsUI.ms"

/*
crToolsFloater = newrolloutfloater "Carmageddon: Reincarnation Tools" 300 400
AddRollout carma_reincarnation_exporter crToolsFloater
AddRollout carma_reincarnation_import crToolsFloater
AddRollout carma_reincarnation_export crToolsFloater
AddRollout carma_reincarnation_about crToolsFloater
-- */
--try(CloseUI())catch()
	
	

DisableWindowsGhosting = DisableProcessWindowsGhosting()

if DisableWindowsGhosting != null then
	DisableWindowsGhosting.DisableProcessWindowsGhosting()
uiForm = CreateUI()
--createDialog carma_reincarnation_main