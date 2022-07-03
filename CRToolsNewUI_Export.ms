
fn ExportMDLMenuClicked sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the object to export" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "This function only supports exporting one object at a time right now!" title:"Too many objects selected!"
	)

	else
	(
		exportTexturesChecked = true
		exportMatsChecked = true
		exportMTLChecked = false
		exportOctreeChecked = false

	
		objectFileName = selection[1].name+".mdl"
		if (IsObjectACNT selection[1]) do objectFileName = selection[1].modifiers["CNT Hierarchy"].FileName+".mdl"
		mdl_name = GetSaveFileName filename:objectFileName caption:"Save MDL As" types:"MDL(*.MDL)|*.mdl"
		if mdl_name != undefined do
		(
			mdl_path = getFilenamePath mdl_name
			global MaterialsToExport
			MaterialsToExport=#()
			ExportMDLMesh mdl_path selection[1] forcedFilename:mdl_name exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked
			messageBox ("Export MDL to "+mdl_name+" completed!") title:"Export Finished!"
			gc()
		)
	
	)
)
fn ExportLightMenuClicked sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the object to export" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "This function only supports exporting one object at a time right now!" title:"Too many objects selected!"
	)
	else if (IsCRLight selection[1]) == false then 
	(
	messageBox "Please select a light!" title:"This is not a light!"
	)
	else
	(
		exportTexturesChecked = true
		exportMatsChecked = true
		exportMTLChecked = false
		exportOctreeChecked = false

	

		objectFileName = selection[1].name+".light"
		if (IsObjectACNT selection[1]) do objectFileName = selection[1].modifiers["CNT Hierarchy"].FileName+".light"
		mdl_name = GetSaveFileName filename:objectFileName caption:"Save Light As" types:"LIGHT(*.LIGHT)|*.light"
		if mdl_name != undefined do
		(
			mdl_path = getFilenamePath mdl_name

			ExportLight mdl_path selection[1] exportGobo:exportTexturesChecked
			messageBox ("Export Light to "+mdl_name+" completed!") title:"Export Finished!"
			gc()
		)
		
	)
)

fn ExportRBAMenuClicked sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the objects to create an RBA from" title:"No objects selected!"
	)
	else
	(
		rba_name = GetSaveFileName caption:"Save RBA As" types:"RBA(*.RBA)|*.rba"
		if rba_name != undefined do
		(
			ExportRBA rba_name selection[1]
			messageBox ("Export RBA Hierarchy to "+rba_name+" completed!") title:"Export Finished!"
			gc()
		)
	)
)
fn ExportCNTMenuClicked sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		local selectedCnt = selection[1]
		local cntFileName = unsupplied
		if (IsObjectACNT selectedCnt) and selectedCnt.modifiers["CNT Hierarchy"].NodeType == "CNT" then (
			cntFileName = selectedCnt.modifiers["CNT Hierarchy"].fileName + ".cnt"
		)
		cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt" filename: cntFileName
		if cnt_name != undefined do
		(
			if (IsObjectACNT selectedCnt) and (selectedCnt.modifiers["CNT Hierarchy"].NodeType == "IGNORE" or selectedCnt.modifiers["CNT Hierarchy"].NodeType == "CNT") then (
				selectedCnt = selectedCnt.children[1]
			)
			ExportCNT cnt_name selectedCnt
			messageBox ("Export CNT Hierarchy to "+cnt_name+" completed!") title:"Export Finished!"
			gc()
		)
	)
)

fn ExportFullHierarchyMenuClicked sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		selectedModel = selection[1]
		local cntFileName = unsupplied

		if (IsObjectACNT selectedModel) and selectedModel.modifiers["CNT Hierarchy"].NodeType == "CNT" then (
			cntFileName = selectedModel.modifiers["CNT Hierarchy"].fileName + ".cnt"
		)

		cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt" filename:cntFileName
		if cnt_name != undefined do
		(
			exportTexturesChecked = true
			exportMatsChecked = true
			exportMTLChecked = false
			exportOctreeChecked = false
			
			global MaterialsToExport
			MaterialsToExport=#()
			
			mdl_path = getFilenamePath cnt_name
			
			if (IsObjectACNT selectedModel) and (selectedModel.modifiers["CNT Hierarchy"].NodeType == "IGNORE" or selectedModel.modifiers["CNT Hierarchy"].NodeType == "CNT") then (
				selectedModel = selectedModel.children[1]
			)

			ExportMDL mdl_path false true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked nodes:#(selectedModel)
			ExportCNT cnt_name selectedModel
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			--PrintArrayInFull = "MaterialsToExport"
			messageBox ("Export CNT & MDL Hierarchy to "+mdl_path+" completed!") title:"Export Finished!"
		)
	)	
)


/* ==================================== *\
|* ======= Car Export Callbacks ======= *|
\* ==================================== */

fn ExportCarFullClicked sender arg = (

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		car_cnt_name = GetSaveFileName caption:"Save Car.CNT As" types:"Car.CNT(Car.CNT)|car.cnt"
		if car_cnt_name != undefined do
		(
			exportTexturesChecked = true
			exportMatsChecked = true
			exportMTLChecked = false
			exportOctreeChecked = false
			global MaterialsToExport
			MaterialsToExport=#()
			mdl_path = getFilenamePath car_cnt_name
			selectedModel = selection[1]
			--ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			--ExportCNT car_cnt_name selectedModel
			--ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			
		local structureXmlFile = (getFileNamePath car_cnt_name)+"structure.xml"
		ExportStructureXML structureXmlFile selectedModel

		local systemsDamageXmlFile = (getFileNamePath car_cnt_name)+"systemsdamage.xml"
		ExportSystemsDamageXML systemsDamageXmlFile selectedModel

		local setupLuaFile = (getFilenamePath car_cnt_name)+"setup.lua"
		ExportCarSetupLUA setupLuaFile selectedModel

		local vehicleSetupLuaFile = (getFilenamePath car_cnt_name)+"vehicle_setup.lua"
		ExportCarVehicleSetupLUA vehicleSetupLuaFile selectedModel

		local vehicleSetupCfgFile = (getFilenamePath car_cnt_name)+"vehicle_setup.cfg"
		ExportCarVehicleCFG vehicleSetupCfgFile selectedModel

		local vfxAnchorsLuafilename = (getFilenamePath car_cnt_name)+"vfx_anchors.lua"
		ExportVFXAnchors vfxAnchorsLuafilename selectedModel



			--PrintArrayInFull = "MaterialsToExport"
			messageBox ("Export Car to "+mdl_path+" completed!") title:"Export Finished!"
		)
	)	
)
fn ExportCarStructureClicked sender arg = (
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save Structure XML As" types:"Structure.XML (Structure.XML)|structure.xml"
		ExportStructureXML structureXmlFile selection[1]
	)
)
fn ExportCarSystemsDamageClicked sender arg = (
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save SystemsDamage XML As" types:"SystemsDamage.XML (SystemsDamage.XML)|systemsdamage.xml"
		ExportSystemsDamageXML systemsDamageXmlFile selection[1]
	)

)
fn ExportCarSetupLUAClicked sender arg = (

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save Handlng Setup LUA As" types:"Handling Setup LUA (Setup.lua)|setup.lua;setup.lol"
		ExportCarSetupLUA file selection[1]

	)
)
fn ExportCarVehicleSetupLUAClicked sender arg = (

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save Vehicle Setup Lua As" types:"Vehicle Setup Lua (Vehicle_Setup.LUA)|vehicle_setup.lua;vehicle_setup.lol"
		ExportCarVehicleSetupLUA file selection[1]
	)
)
fn ExportCarVehicleSetupCFGClicked sender arg = (

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save Vehicle Setup Config As" types:"Vehicle Setup Config (Vehicle_setup.cfg)|vehicle_setup.cfg"
		ExportCarVehicleCFG file selection[1]
	)
)
fn ExportCarVFXAnchorsLUAClicked sender arg = (

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save VFX Anchors Lua As" types:"VFX Anchors Lua (VFX_Anchors.LUA)|vfx_anchors.lua;vfx_anchors.lol"
		ExportVFXAnchors file selection[1]
	)
)
fn ExportCarCrashSoundsConfigClicked sender arg = (

)

fn ExportWheelClicked sender arg = (
	if (selection as array).count == 0 then
	(
		messageBox "Please select the wheel rim object to export" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the rim object to export" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName caption:"Save Wheel" filename:"rim.cnt" types:"Wheel (Rim.CNT)|rim.cnt"
		ExportFullWheel file selection[1]
	)
)



/* ==================================== *\
|* ====== Level Export Callbacks ====== *|
\* ==================================== */

fn ExportLevelFullClicked sender arg = (

)
fn ExportLevelConfigClicked sender arg = (

)
fn ExportLevelSetupClicked sender arg = (

)
fn ExportLevelAccessoriesClicked sender arg = (

)
fn ExportLevelPedsClicked sender arg = (

)
fn ExportLevelRoutesClicked sender arg = (

)
fn ExportLevelMinimapDefsClicked sender arg = (

)
fn ExportLevelIntroCamClicked sender arg = (

)
fn ExportLevelAudioClicked sender arg = (

)
fn ExportLevelZonesClicked sender arg = (

)
fn ExportLevelPostProcessScriptsClicked sender arg = (

)

/* ==================================== *\
|* ==== Accessory Export Callbacks ===  *|
\* ==================================== */

fn ExportAccessoryClicked sender arg = (
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the accessory root)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the accessory base)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName filename:"accessory.txt" caption:"Save Accessory TXT As" types:"Accessory TXT (Accessory.TXT)|accessory.txt;accessory.txt"
		ExportAccessoryTXT file selection[1]
	)
)
fn ExportFullAccessoryClicked sender arg = (
	global CarmaSettings

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the accessory root)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the accessory base)" title:"Too many objects selected!"
	)
	else
	(
		cnt_name = GetSaveFileName caption:"Save Accessory.CNT As" types:"Accessory.CNT(Accessory.CNT)|accessory.cnt"
		if cnt_name != undefined do
		(
			exportTexturesChecked = CarmaSettings.ExportSettings.ExportTextures
			exportMatsChecked = CarmaSettings.ExportSettings.ExportMaterials
			exportMTLChecked = CarmaSettings.ExportSettings.ExportMTL
			exportOctreeChecked = false
			global MaterialsToExport
			MaterialsToExport=#()
			mdl_path = getFilenamePath cnt_name
			selectedModel = selection[1]
			ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			ExportCNT cnt_name selectedModel
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			local accessoryTxtPath = mdl_path+"accessory.txt"
			ExportAccessoryTXT accessoryTxtPath selection[1]
		)	
	)
)

/* ==================================== *\
|* ==== Mobile Car Export Callbacks ===  *|
\* ==================================== */
fn ExportMobileFullCar sender arg = (
if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car root)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car base)" title:"Too many objects selected!"
	)
	else
	(
		
		ExportFunsizeCar selection[1]
			
	)

)

fn ExportMobileCarTxt sender arg = (
if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car root)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car base)" title:"Too many objects selected!"
	)
	else
	(
		global CarmaSettings
		FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
		carModifier = selection[1].modifiers["Funsize Car"]
		txt_name = (FunsizeDataPath+"Data\\Content\\Vehicles\\" + carModifier.carname + "\\car.txt") -- GetSaveFileName caption:"Save car.TXT As" types:"car.TXT(car.TXT)|car.txt"
		if txt_name != undefined do
		(
			Funsize_ExportCarTXTFile txt_name selection[1]

			if CarmaSettings.FunsizeSettings.AutoBuild then (
				format "Autobuilding \n"
				PackObb()
			)
		)	
	)

)/* ==================================== *\
|* ==== Mobile Accessory Export Callbacks ===  *|
\* ==================================== */

fn ExportMobileAccessoryClicked sender arg = (
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the accessory root)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the accessory base)" title:"Too many objects selected!"
	)
	else
	(

		file = GetSaveFileName filename:"accessory.txt" caption:"Save Accessory TXT As" types:"Accessory TXT (Accessory.TXT)|accessory.txt;accessory.txt"
		ExportAccessoryTXT file selection[1]
	)
)
fn ExportFullMobileAccessoryClicked sender arg = (
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the accessory root)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the accessory base)" title:"Too many objects selected!"
	)
	else
	(
		cnt_name = GetSaveFileName caption:"Save Accessory.CNT As" types:"Accessory.CNT(Accessory.CNT)|accessory.cnt"
		if cnt_name != undefined do
		(
			exportTexturesChecked = true
			exportMatsChecked = true
			exportMTLChecked = true
			exportOctreeChecked = false
			global MaterialsToExport
			MaterialsToExport=#()
			mdl_path = getFilenamePath cnt_name
			selectedModel = selection[1]
			ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			ExportCNT cnt_name selectedModel
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			local accessoryTxtPath = mdl_path+"accessory.txt"
			ExportAccessoryTXT accessoryTxtPath selection[1]
		)	
	)
)