fn ExportLevelAccessories levelLOLfile ExportPowerups:false ExportAccessories:True =
(
	powerupsScriptText = "module((...), level_accessory_setup)\n"
	powerupsScriptText = powerupsScriptText + "accessories = {\n"
	lolScriptText = "module((...), level_accessory_setup)\n"
	lolScriptText = lolScriptText + "accessories = {\n"
	
	accessoryCount = 0
	
	for i = 1 to layerManager.count-1 do
	(
		curLayer = layerManager.getLayer i
		layerName = curLayer.name
		if (substring layerName 1 4) == "sys_" then continue
		refLayer = ILayerManager.getLayerObject i
		layerNodes = refs.dependents refLayer
		
		for x = 1 to layerNodes.count do
		(
			curNode = layerNodes[x]
			nodeName = curNode as string
			
			if (classOf curNode) == CarmaHelper_AccessoryPlaceHolder then
			(
				if (curNode as string) == "CarmaHelper_AccessoryPlaceholder" then
				(
					continue
				)
				nodetext = " = {\n"
				
				if curNode.accessoryName == undefined or curNode.accessoryName == "" then curNode.accessoryName = curNode.name
				nodetext  = nodetext+"\t\ttype = \""+curNode.accessoryType+"\",\n"
				nodetext  = nodetext+"\t\tname = \""+curNode.accessoryName+"\",\n"
				nodetext  = nodetext+"\t\tlayer = \""+layerName+"\",\n"
				
				nodetext = nodetext + "\t\ttransform = {\n"
				tm = curNode.transform
				if dot (normalize (cross tm.row3 tm.row1)) tm.row2 < 0.9 then tm.row1 = -tm.row1
				tm.row1 = normalize tm.row1
				tm.row2 = normalize tm.row2
				tm.row3 = normalize tm.row3
				tm = matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0] * tm * inverse(matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0])
				nodetext = nodetext + "\t\t\t{\n\t\t\t\t"+(tm.row1.x as string)+",\n\t\t\t\t"+(tm.row1.y as string)+",\n\t\t\t\t"+(tm.row1.z as string)+"\n\t\t\t},\n"
				nodetext = nodetext + "\t\t\t{\n\t\t\t\t"+(tm.row2.x as string)+",\n\t\t\t\t"+(tm.row2.y as string)+",\n\t\t\t\t"+(tm.row2.z as string)+"\n\t\t\t},\n"
				nodetext = nodetext + "\t\t\t{\n\t\t\t\t"+(tm.row3.x as string)+",\n\t\t\t\t"+(tm.row3.y as string)+",\n\t\t\t\t"+(tm.row3.z as string)+"\n\t\t\t},\n"
				nodetext = nodetext + "\t\t\t{\n\t\t\t\t"+(tm.row4.x as string)+",\n\t\t\t\t"+(tm.row4.y as string)+",\n\t\t\t\t"+(tm.row4.z as string)+"\n\t\t\t}\n"
				
				nodetext = nodetext + "\t\t},\n"
				nodetext = nodetext + "\t\tcolour = {\n\t\t\t\t"+((curNode.accessoryColour.r as integer) as string)+",\n\t\t\t\t"+((curNode.accessoryColour.g as integer) as string)+",\n\t\t\t\t"+((curNode.accessoryColour.b as integer) as string)+"\n\t\t},\n"
				if curNode.isPowerup then
				(
					nodetext = "\t"+(getFilenameFile maxFileName)+"_powerup_"+(accessoryCount as string) + nodetext + "\n\t},\n"
					powerupsScriptText = powerupsScriptText + nodeText
				)
				else
				(
					nodetext = "\t"+(getFilenameFile maxFileName)+"_accessory_"+(accessoryCount as string) + nodetext + "\n\t},\n"
					lolScriptText = lolScriptText + nodetext
				)
				accessoryCount = accessoryCount+1
			)
		)
		--format "curLayer: %\n refLayer: %\n\n" (showProperties curLayer) (showProperties refLayer)
		
	)
	
	lolScriptText = lolScriptText + "}\n";
	powerupsScriptText = powerupsScriptText + "}\n";
	if ExportAccessories == true then
	(
		f = openFile levelLOLfile mode:"wt"
		format "%" lolScriptText to:f
		close f
	)
	if ExportPowerups == true then
	(
		powerupFileName = (getFilenamePath levelLOLfile)+"powerups.lol"
		fp = openFile powerupFileName mode:"wt"
		format "%" powerupsScriptText to:fp
		close fp
	)
	format "Accessories: \n%\n===================================================\nPowerups: \n%" lolScriptText powerupsScriptText
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
					ExportLevelAccessories struct_name ExportPowerups:true
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
				ExportLevelAccessories levelLOLfile ExportPowerups:true
				messageBox ("Export Car to "+mdl_path+" completed!") title:"Export Finished!"
			)
		)
	)
)