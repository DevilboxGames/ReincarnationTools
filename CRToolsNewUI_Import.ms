/* ==================================== *\
|* ===== Generic Import Callbacks ===== *|
\* ==================================== */

fn ImportMDLMenuClicked sender arg =
(
	global UseTR
	global CarmaSettings

	stopwatch = dotNetObject "System.Diagnostics.Stopwatch"
	stopwatch.start()
	undo "Import Max Damage Model" on
	(
		oldheapfree = heapfree
		mdl_name = GetOpenFileName caption:"Open MDL File" types:"Max Damage Model (*.MDL)|*.mdl"
		if mdl_name != undefined do
		(
			filetype = tolower (getFilenameType mdl_name)
			
			global globalMaterials = #()
			globalMaterials = #()
			global globalMaterialNames =#()
			globalMaterialNames =#()

			local importTextures = CarmaSettings.ImportSettings.importTextures
			local forcePrep = CarmaSettings.ImportSettings.UsePrepData
			local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
			local mergeSplits = CarmaSettings.ImportSettings.MergeSplits

			if UseTR == true then
				ImportMDL_TR #(mdl_name) importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeSplits:mergeSplits
			else
				ImportMDL mdl_name importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips useUniqueVerts:mergeSplits mergeSplits:mergeSplits
			
			
		)
	)
)
fn ImportLightMenuClicked sender arg =
(
	global UseTR
	
	stopwatch = dotNetObject "System.Diagnostics.Stopwatch"
	stopwatch.start()
	undo "Import Max Damage Light" on
	(
		oldheapfree = heapfree
		mdl_name = GetOpenFileName caption:"Open LIGHT File" types:"Max Damage Light (*.LIGHT)|*.light"
		if mdl_name != undefined do
		(
			filetype = tolower (getFilenameType mdl_name)
		
			newmesh = omniLight name:(getFilenameFile mdl_name)
			lightObj = CRLight()
			lightObj.LoadLight mdl_name
			lightObj.SetToLight newMesh
			
		)
	)
)

fn ImportRBAMenuClicked sender arg=
(
	
		RBA_name = GetOpenFileName caption:"Open RBA File" types:"RBA(*.RBA)|*.RBA"
		if RBA_name != undefined do
		(
			rba = ImportRBA RBA_name
			ApplyRBA rba
		)
)
fn ImportCNTMenuClicked sender arg=
(
	global CarmaSettings
	
		cnt_name = GetOpenFileName caption:"Open CNT File" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			local importTextures = CarmaSettings.ImportSettings.importTextures
			local forcePrep = CarmaSettings.ImportSettings.UsePrepData
			local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
			local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
			local SpawnOctree = false
			ImportCNT cnt_name importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		)
)

/* ==================================== *\
|* ======= Car Import Callbacks ======= *|
\* ==================================== */

fn ImportWheelClicked sender arg = (
	local wheelFilename = GetOpenFileName caption:"Open Wheel Rim" types:"Open Wheel Rim (rim.cnt)|rim.cnt"
	if wheelFilename != undefined then (
		ImportFullWheel wheelFilename
	)
)

fn ImportCarStructureClicked sender arg = (
	global CarmaSettings

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		structureFilename = GetOpenFileName caption:"Open Car Structure" types:"Open Structure (structure.xml)|structure.xml"

		if structureFilename != undefined then (
			local selectedCar = selection[1]

			LoadStructureXML structureFilename selectedCar
		)
	)
)

fn ImportCarSystemsDamageClicked sender arg = (
	global CarmaSettings

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		systemsDamageFilename = GetOpenFileName caption:"Open Car Systems Damage" types:"Open Systems Damage (systemsdamage.xml)|systemsdamage.xml"

		if systemsDamageFilename != undefined then (
			local selectedCar = selection[1]

			LoadSystemDamageXML systemsDamageFilename selectedCar
		)
	)
)

fn ImportCarSetupLUAClicked sender arg = (
	global CarmaSettings

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		setupluafilename = GetOpenFileName caption:"Open Handling Setup.LUA File" types:"Open Setup LUA Script(setup.lua, setup.lol)|setup.lua;setup.lol"

		if setupluafilename != undefined then (

			local selectedCar = selection[1]
			LoadHandlingSetupLua selectedCar setupluafilename
		)
	)
)

fn ImportCarVehicleSetupCFGClicked sender arg = (
	global CarmaSettings

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
		vehiclesetupCfgFilename = GetOpenFileName caption:"Open Vehicle_Setup.CFG" types:"Open Vehicle Setup Config (vehicle_setup.cfg)|vehicle_setup.cfg"

		if vehiclesetupCfgFilename != undefined then (
			local selectedCar = selection[1]

			LoadVehicleConfig selectedCar vehiclesetupCfgFilename
		)
	)
)

fn ImportCarVFXAnchorsLUAClicked sender arg = (
	global CarmaSettings
	
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		vfxAnchorsLuafilename = GetOpenFileName caption:"Open VFX Anchors LUA Script" types:"Open VFX Anchors LUA Script(vfx_anchors.lua, vfx_anchors.lol)|vfx_anchors.lua;vfx_anchors.lol"

		if vfxAnchorsLuafilename != undefined then (

			local selectedCar = selection[1]
			ImportVFXAnchors selectedCar vfxAnchorsLuafilename
		)
	)
)


fn ImportCarCrashSoundsConfigClicked sender arg = (
)

fn ImportCarVehicleSetupLUAClicked sender arg = (
	global CarmaSettings
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object  (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(

		vehiclesetupluafilename = GetOpenFileName caption:"Open Vehicle_Setup.LUA File" types:"Open Vehicle Setup LUA Script(vehicle_setup.lua, vehicle_setup.lol)|vehicle_setup.lua;vehicle_setup.lol"

		if vehiclesetupluafilename != undefined then (

			local selectedCar = selection[1]
			LoadVehicleSetupLua selectedCar vehiclesetupluafilename
		)
	)
)
fn ImportFullCarClicked sender arg = (

	global CarmaSettings

	car_cnt_name = GetOpenFileName caption:"Open Car.CNT File" types:"Car.CNT(Car.CNT)|car.cnt"
	if car_cnt_name != undefined then (
		local importTextures = CarmaSettings.ImportSettings.importTextures
		local forcePrep = CarmaSettings.ImportSettings.UsePrepData
		local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
		local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
		local SpawnOctree = false
		
		local rootMesh = ImportCNT car_cnt_name importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		
		AddVehilceCFGModifier rootMesh
		LoadVehicleConfig rootMesh (getFilenamePath car_cnt_name)
		
		SetAllCNTsToBakeScale rootMesh
		ReplaceWheels rootMesh

		local structureXmlFile = (getFileNamePath car_cnt_name)+"structure.xml"
		LoadStructureXML structureXmlFile rootMesh

		local systemsDamageXmlFile = (getFileNamePath car_cnt_name)+"systemsdamage.xml"
		LoadSystemDamageXML systemsDamageXmlFile rootMesh

		local setupLuaFile = (getFilenamePath car_cnt_name)+"setup.lua"
		if ((dotnetclass "System.IO.File").Exists setupLuaFile) == false then (
			setupLuaFile = (getFilenamePath car_cnt_name)+"setup.lol"
		)
		LoadHandlingSetupLua rootMesh setupLuaFile

		local vehicleSetupLuaFile = (getFilenamePath car_cnt_name)+"vehicle_setup.lua"
		if ((dotnetclass "System.IO.File").Exists vehicleSetupLuaFile) == false then (
			vehicleSetupLuaFile = (getFilenamePath car_cnt_name)+"vehicle_setup.lol"
		)

		LoadVehicleSetupLua rootMesh vehicleSetupLuaFile

		local vehicleSetupCfgFile = (getFilenamePath car_cnt_name)+"vehicle_setup.cfg"

		LoadVehicleConfig rootMesh vehicleSetupCfgFile

		local vfxAnchorsLuafilename = (getFilenamePath car_cnt_name)+"vfx_anchors.lua"
		if ((dotnetclass "System.IO.File").Exists vfxAnchorsLuafilename) == false then (
			vfxAnchorsLuafilename = (getFilenamePath car_cnt_name)+"vfx_anchors.lol"
		)

		ImportVFXAnchors rootMesh vfxAnchorsLuafilename


	)
)

/* ==================================== *\
|* ====== Level Import Callbacks ====== *|
\* ==================================== */

fn ImportLevelConfigClicked sender arg = (
)

fn ImportLevelSetupClicked sender arg = (
)

fn ImportLevelAccessoriesClicked sender arg = (
		file = GetOpenFileName caption:"Open Accessory Placement Script" types:"Open Accessory Placement (level.lua)|level.lua;level.lol"

		if file != undefined then (

			local selectedCar = selection[1]
			ParseLevelAccessoryLOL file
		)
)

fn ImportLevelPedsClicked sender arg = (
		file = GetOpenFileName caption:"Open Ped File XML" types:"Open Ped File XML (pedfile*.xml)|pedfile*.xml"

		if file != undefined then (

			local selectedCar = selection[1]
			ImportPedFile file
		)
)

fn ImportLevelRoutesClicked sender arg = (

		file = GetOpenFileName caption:"Open Level Routes TXT File" types:"Open Level Routes TXT (routes*.txt)|routes*.txt"

		if file != undefined then (

			local selectedCar = selection[1]
			ParseLevelRoutesTXT file
		)
)

fn ImportMinimapDefsClicked sender arg = (
)

fn ImportLevelIntroCamClicked sender arg = (
)

fn ImportLevelAudioClicked sender arg = (
)

fn ImportLevelZonesClicked sender arg = (
)

fn ImportLevelPostProcessScriptsClicked sender arg = (
)

fn ImportFullLevelClicked sender arg = (

	file = GetOpenFileName caption:"Open Level" types:"Open Level (level.cnt)|level.cnt"

	if file != undefined then (

		local filePath = getFilenamePath file
		local importTextures = CarmaSettings.ImportSettings.importTextures
		local forcePrep = CarmaSettings.ImportSettings.UsePrepData
		local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
		local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
		local SpawnOctree = false
		
		local rootMesh = ImportCNT file importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		
		ParseLevelRoutesTXT file
	)
)

/* ==================================== *\
|* ==== Accessory Import Callbacks ==== *|
\* ==================================== */

fn ImportAccessoryClicked sender arg = (
	file = GetOpenFileName caption:"Open Accessory" types:"Open Accessory (accessory.cnt)|accessory.cnt"

	if file != undefined then (

		local filePath = getFilenamePath file
		local importTextures = CarmaSettings.ImportSettings.importTextures
		local forcePrep = CarmaSettings.ImportSettings.UsePrepData
		local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
		local mergeSplits = CarmaSettings.ImportSettings.MergeSplits
		local SpawnOctree = false
		
		local rootMesh = ImportCNT file importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		
		local accessoryTxtPath = (dotnetclass "System.IO.Path").Combine filePath "accessory.txt"

		local accessoryTxt = ImportAccessoryTXT accessoryTxtPath rootMesh
	)
)

