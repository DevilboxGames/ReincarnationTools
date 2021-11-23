
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
			ExportMDLMesh mdl_path selection[1] forcedFilename:mdl_name exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:createOctree
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
		cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			ExportCNT cnt_name selection[1]
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
		cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			exportTexturesChecked = true
			exportMatsChecked = true
			exportMTLChecked = false
			exportOctreeChecked = false
			global MaterialsToExport
			MaterialsToExport=#()
			mdl_path = getFilenamePath cnt_name
			selectedModel = selection[1]
			ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
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
		cnt_name = GetSaveFileName caption:"Save Car.CNT As" types:"Car.CNT(Car.CNT)|car.cnt"
		if cnt_name != undefined do
		(
			exportTexturesChecked = true
			exportMatsChecked = true
			exportMTLChecked = false
			exportOctreeChecked = false
			global MaterialsToExport
			MaterialsToExport=#()
			mdl_path = getFilenamePath cnt_name
			selectedModel = selection[1]
			ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			ExportCNT cnt_name selectedModel
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			
		local structureXmlFile = (getFileNamePath car_cnt_name)+"structure.xml"
		ExportStructureXML structureXmlFile rootMesh

		local systemsDamageXmlFile = (getFileNamePath car_cnt_name)+"systemsdamage.xml"
		ExportSystemsDamageXML systemsDamageXmlFile rootMesh

		local setupLuaFile = (getFilenamePath car_cnt_name)+"setup.lua"
		ExportCarSetupLUA setupLuaFile rootMesh

		local vehicleSetupLuaFile = (getFilenamePath car_cnt_name)+"vehicle_setup.lua"
		ExportCarVehicleSetupLUA vehicleSetupLuaFile rootMesh

		local vehicleSetupCfgFile = (getFilenamePath car_cnt_name)+"vehicle_setup.cfg"
		ExportCarVehicleCFG vehicleSetupCfgFilerootMeshs

		local vfxAnchorsLuafilename = (getFilenamePath car_cnt_name)+"vfx_anchors.lua"
		ExportVFXAnchors vfxAnchorsLuafilename rootMesh



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
		ExportCarVehicleCFG file rootMesh
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

)