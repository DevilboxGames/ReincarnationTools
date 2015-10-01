fn ExportLevelAccessories levelLOLfile ExportPowerups:false =
(
	powerupsScriptText = "module((...), level_accessory_setup)\n"
	powerupsScriptText = powerupsScriptText + "accessories = {\n"
	lolScriptText = "module((...), level_accessory_setup)\n"
	lolScriptText = lolScriptText + "accessories = {\n"
	
	for i = 1 to layerManager.count-1 do
	(
		curLayer = layerManager.getLayer i
		layerName = curLayer.name
		refLayer = ILayerManager.getLayerObject i
		layerNodes = refs.dependents refLayer
		--format "curLayer: %\n refLayer: %\n\n" (showProperties curLayer) (showProperties refLayer)
		
	)
	
	lolScriptText = lolScriptText + "}\n";
	
)

fn ExportLevelPaperworkButtonPressed sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the base environment mesh)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the base environment mesh)" title:"Too many objects selected!"
	)
	else
	(
			
		undo "Save C:R Level Paperwork" on
		(
				struct_name = GetSaveFileName filename:"level.lol" caption:"Save Level.lol" types:"level.LOL|level.lol"
				if struct_name != undefined do
				(
					--structureXmlFile = (getFilenamePath cnt_name)+"structure.xml"
					ExportLevelAccesories struct_name
					messageBox ("Export Level.lol to "+struct_name+" completed!") title:"Export Finished!"
				)
		
		)
	)
)
fn ExportLevelButtonPressed sender arg=
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the base environment mesh)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the base environment mesh)" title:"Too many objects selected!"
	)
	else
	(
			
		undo "Export C:R Level" on
		(

			cnt_name = GetSaveFileName filename:"level.cnt" caption:"Save CNT As" types:"Level.CNT|level.cnt"
			if cnt_name != undefined do
			(
				exportTexturesChecked = sender.parent.controls.Item["ExportTexturesCheckbox"].checked
				exportMatsChecked = sender.parent.controls.Item["CreateMaterialsCheckbox"].checked
				global MaterialsToExport=#()
				mdl_path = getFilenamePath cnt_name
				ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked
				ExportCNT cnt_name selection[1]
				ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked
				--PrintArrayInFull MaterialsToExport "MaterialsToExport"
				
				levelLOLfile = (getFilenamePath cnt_name)+"level.lol"
				ExportLevelLOL levelLOLfile
				messageBox ("Export Car to "+mdl_path+" completed!") title:"Export Finished!"
			)
		)
	)
)