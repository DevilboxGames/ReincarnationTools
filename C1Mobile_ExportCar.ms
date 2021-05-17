fn FunSize_CreateTextEntryRowContent key value comment:"" = (
	key = substitutestring key "&" "&amp;"
	value = substitutestring value "&" "&amp;"
	comment = substitutestring comment "&" "&amp;"
	"<Cell><Data>" + key + "</Data></Cell>" +		--Key
	"<Cell><Data>" + comment + "</Data></Cell>" + --Comment
	"<Cell><Data>" + value + "</Data></Cell>" + --English
	"<Cell><Data>" + value + "</Data></Cell>" + --French
	"<Cell><Data>" + value + "</Data></Cell>" + --Spanish
	"<Cell><Data>" + value + "</Data></Cell>" + --German
	"<Cell><Data>" + value + "</Data></Cell>" + --Italian
	"<Cell><Data>" + value + "</Data></Cell>" + --Japanese
	"<Cell><Data>" + value + "</Data></Cell>" + --Russian
	"<Cell><Data>" + value + "</Data></Cell>" + --Portuguese
	"<Cell><Data>" + value + "</Data></Cell>" + --Turkish
	"<Cell><Data>" + value + "</Data></Cell>" + --Chinese
	"<Cell><Data>" + value + "</Data></Cell>"   --Polish
)
fn FunsizeFindRowForCar xmlDoc carname key = (
	rows = xmlDoc.GetElementsByTagName "Row"

	foundEl = undefined

	for i = 0 to (rows.count - 1) do (

		el = rows.item[i]
		cellElements = el.FirstChild.FirstChild
		if (toupper cellElements.innertext) == (toupper key) then ( 
			foundEl = el
			i = rows.count
		)
	)
	foundEl
)
fn Funsize_AddTextToXML filename carname driverName driverWastedName driverDescription carFullName = (
	XmlDoc = dotNetObject "System.Xml.XmlDocument"
	XmlDoc.load filename
	TableNode = (XmlDoc.GetElementsByTagName "Table").item[0]

	driverNameRow = FunsizeFindRowForCar xmldoc carname (carname + "_DRIVER")
	if driverNameRow == undefined then driverNameRow = XmlDoc.CreateElement("Row")

	driverNameRow.innerXml = FunSize_CreateTextEntryRowContent (carname + "_DRIVER") driverName

	driverDescriptionRow = FunsizeFindRowForCar xmldoc carname (carname + "_INFO")
	if driverDescriptionRow == undefined then driverDescriptionRow = XmlDoc.CreateElement("Row")

	driverDescriptionRow.innerXml = FunSize_CreateTextEntryRowContent (carname + "_INFO") driverDescription

	driverWastedNameRow = FunsizeFindRowForCar xmldoc carname (carname + "_SHORT")
	if driverWastedNameRow == undefined then driverWastedNameRow = XmlDoc.CreateElement("Row")
	driverWastedNameRow.innerXml = FunSize_CreateTextEntryRowContent (carname + "_SHORT") driverWastedName

	carFullNameRow = FunsizeFindRowForCar xmldoc carname ("CAR_"+carname)
	if carFullNameRow == undefined then carFullNameRow = XmlDoc.CreateElement("Row")
	carFullNameRow.innerXml = FunSize_CreateTextEntryRowContent ("CAR_" + carname) carFullName

	TableNode.AppendChild(driverNameRow)
	TableNode.AppendChild(driverDescriptionRow)
	TableNode.AppendChild(driverWastedNameRow)
	TableNode.AppendChild(carFullNameRow)

	XmlDoc.Save(filename)
)

fn Funsize_ExportHUDScript FunsizeDataPath carname hudModifier = (
	hudScript = StringStream ""
	hudImage = "image[\"damage\\\\"+carname+"\"]"
	format "module((...), lube.menu_layout)\n" to:hudScript
	format "content({\n" to:hudScript
	format "class = \"lube.menu.list\",\n" to:hudScript
	format "items = {\n" to:hudScript
	format "  graphic({\n" to:hudScript
	format "    image = %,\n" hudImage to:hudScript
	format "    registration = anchor.top_left,\n" to:hudScript
	format "    x = -64,\n" to:hudScript
	format "    y = -128,\n" to:hudScript
	format "    w = 128,\n" to:hudScript
	format "    h = 256\n" to:hudScript
	format "  }),\n" to:hudScript

	for i = 1 to hudModifier.Parts.count do (

		format "  %({\n" hudModifier.Parts[i] to:hudScript
		format "    x = %,\n" (hudModifier.Positions[i].x as integer) to:hudScript
		format "    y = %,\n" (hudModifier.Positions[i].y as integer) to:hudScript
		if hudModifier.FlippedHorizontally[i] then
		(
			format "    skew_x = 180\n" to:hudScript
		)
		if hudModifier.FlippedVertically[i] then
		(
			format "    skew_y = 180\n" to:hudScript
		)
		if hudModifier.Scales[i].x != 1 then
		(
			format "    scale_x = %,\n" (hudModifier.Scales[i].x as integer) to:hudScript
		)
		if hudModifier.Scales[i].y != 1 then
		(
			format "    scale_y = %,\n" (hudModifier.Scales[i].y as integer) to:hudScript
		)
		format "    w = %,\n" (hudModifier.Positions[i].z as integer) to:hudScript
		format "    h = %\n" (hudModifier.Positions[i].w as integer) to:hudScript
		format "  })" to:hudScript
		if i < hudModifier.Parts.count then (
			format ",\n" to:hudScript
		)
		else (
			format "\n" to:hudScript
		)
	)

	format "  }" to:hudScript
	format "})" to:hudScript

	-- Base Verison
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT\\EN\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT\\EN\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT\\JA\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT\\JA\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT\\ZH\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT\\ZH\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f

	-- Amazon Version
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_AMAZON\\EN\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_AMAZON\\EN\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_AMAZON\\JA\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_AMAZON\\JA\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_AMAZON\\ZH\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_AMAZON\\ZH\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	
	-- Demo Verison
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_DEMO\\EN\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_DEMO\\EN\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_DEMO\\JA\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_DEMO\\JA\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_DEMO\\ZH\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_DEMO\\ZH\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f

	-- Promo Version
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_PROMO\\EN\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_PROMO\\EN\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_PROMO\\JA\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_PROMO\\JA\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f
	makeDir (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_PROMO\\ZH\\TYPE_3\\HUD_DAMAGE\\") 
	f = openfile (FunsizeDataPath+"DATA\\CONTENT\\UI\\LAYOUT_PROMO\\ZH\\TYPE_3\\HUD_DAMAGE\\"+carname+"_LAYOUT.lol")  mode:"w"
	format "%" (hudscript as string) to:f
	close f

	hudScript
)
fn Funsize_UpdateCarSpecs FunsizeDataPath carname carModifier = (
	newCarSpecs = StringStream ""
	
	f = openfile (FunsizeDataPath + "Data\\Content\\CarSpecs.txt") mode:"r"

	curline = readline f
	format "%\n" curline to:newCarSpecs
	format "\tParsing carspecs.txt\n\n===============\n\n"
	foundCar = false
	do (

		curline = readline f

		lineCarName = (filterString curline "\t")[1]
		if (toupper lineCarName) == (toupper carname) then (
			format "%\t%\t%\t%\t%\t%\t%\t%\t%\t%\n" carname carModifier.Defence carModifier.Offence carModifier.Power carModifier.Softness carModifier.BHPperTon carModifier.TopSpeed carModifier.Mass carModifier.ShadowMask carModifier.NaughtToSixty to:newCarSpecs
			foundCar = true
		)
		else (
			format "%\n" curline to:newCarSpecs
		)
	) 	while (eof f) == false 

	if foundCar != true then (
		format "%\t%\t%\t%\t%\t%\t%\t%\t%\t%\n" carname carModifier.Defence carModifier.Offence carModifier.Power carModifier.Softness carModifier.BHPperTon carModifier.TopSpeed carModifier.Mass carModifier.ShadowMask carModifier.NaughtToSixty to:newCarSpecs
	)
	close f
	free f
	f2 = openfile (FunsizeDataPath + "Data\\Content\\CarSpecs.txt") mode:"w+"
	format "%" (newCarSpecs as string) to:f2
	close f2

)
fn Funsize_QuickRaceCars FunsizeDataPath carname carModifier onlyAllowCars: = (
	newCarSpecs = StringStream ""
	
	f = openfile (FunsizeDataPath + "Data\\Content\\QUICKRACECARS.txt") mode:"r"

	format "\tParsing QUICKRACECARS.txt\n\n===============\n\n"
	foundCar = false
	do (

		curline = readline f

		if onlyAllowCars == unsupplied or (finditem onlyAllowCars (toupper curline)) > 0 then
		(
			if (toupper curline) == (toupper carname) then (
				format "%\n" carname to:newCarSpecs
				foundCar = true
			)
			else (
					format "%\n" curline to:newCarSpecs
			)
		)
	) 	while (eof f) == false 

	if foundCar != true then (
		
			format "%\n" carname to:newCarSpecs
	)
	close f
	free f
	f2 = openfile (FunsizeDataPath + "Data\\Content\\QUICKRACECARS.txt") mode:"w+"
	format "%" (newCarSpecs as string) to:f2
	close f2

)
fn Funsize_ExportCarTXTFile filename carRoot = (
	carModifier = carRoot.modifiers["Funsize Car"]

	carTXT = StringStream ""

	format "[LUMP]\n%\n\n" carRoot.name to:carTXT
	format "[DRIVER_NAME]\n%\n\n" carModifier.DriverName to:carTXT
	format "[SHRAPNEL]\n%,%,%\n\n" carModifier.Shrapnel.r carModifier.Shrapnel.g carModifier.Shrapnel.b to:carTXT

	if carModifier.EnginePosEnabled then
	(
		format "[ENGINE_POS]\n%,%,%\n\n" carModifier.EnginePos.x carModifier.EnginePos.y carModifier.EnginePos.z to:carTXT
	)

	format "[ENGINE_NOISE]\n" to:carTXT
	
	format "%\n" carModifier.EngineNoises to:carTXT


	if carModifier.Grooves != undefined then
	(
		format "%\n" carModifier.Grooves to:carTXT
	)

	whlfl = GetDescendantByName carRoot "whlfl"
	whlfr = GetDescendantByName carRoot "whlfr"
	whlrl = GetDescendantByName carRoot "whlrl"
	whlrr = GetDescendantByName carRoot "whlrr"
	whlml = GetDescendantByName carRoot "whlml"
	whlmr = GetDescendantByName carRoot "whlmr"

	if whlfl != undefined then (
		format "[DETACHABLE_PART]\nWHLFL\n\n<WHEEL>\n0\n\n" to:carTXT
	)
	if whlfr != undefined then (
		format "[DETACHABLE_PART]\nWHLFR\n\n<WHEEL>\n1\n\n" to:carTXT
	)
	if whlrl != undefined then (	
		format "[DETACHABLE_PART]\nWHLRL\n\n<WHEEL>\n2\n\n" to:carTXT
	)
	if whlrr != undefined then (
		format "[DETACHABLE_PART]\nWHLRR\n\n<WHEEL>\n3\n\n" to:carTXT
	)
	if whlml != undefined then (
		format "[DETACHABLE_PART]\nWHLML\n\n<WHEEL>\n4\n\n" to:carTXT
	)
	if whlmr != undefined then (
		format "[DETACHABLE_PART]\nWHLMR\n\n<WHEEL>\n5\n\n" to:carTXT
	)

	format "[DYNAMICS]\n" to:carTXT
	if carModifier.GraphicalWheelLimitsEnabled then (
		format "<GraphicalWheelLimits>\n%,%,%\n\n" carModifier.GraphicalWheelLimits.x carModifier.GraphicalWheelLimits.y carModifier.GraphicalWheelLimits.z carModifier.GraphicalWheelLimits.w to:carTXT
	)

	if carModifier.DynamicsText != undefined and carModifier.DynamicsText != "" then (
		format "<console>\n%\n\n" carModifier.DynamicsText to:carTXT
	)
	if carModifier.CollisionShapes != undefined and  carModifier.CollisionShapes.count > 0 then (
		local shapeGenerator = AccessoryFileLump()

		shapeGenerator.CreateShape (for obj in carModifier.CollisionShapes collect obj.node) roundedPolyhedronAmount:0.150000

		format "%\n\n<ShapeCheckSum>\n-1\n\n" (shapeGenerator.OutputShapeString()) to:carTXT 
	)

	if carModifier.MaxBodyworkCrushEnabled then
	(
		format "[BODYWORK_DAMAGE_MAX_CRUSH]\n%,%,%\n\n" carModifier.MaxBodyworkCrush.x carModifier.MaxBodyworkCrush.y carModifier.MaxBodyworkCrush.z to:carTXT
	)
	makeDir (getfilenamePath filename) 
	f = openfile filename mode:"w+"
	format "%" (carTXT as string) to:f
	close f 
)

fn ExportFunsizeCar carRoot nolaunch: false onlyAllowCars: = (
	global FunsizeLaunchInfo
	FunsizeDataPath = FunsizeLaunchInfo.DataFolder
	--for mat in scenematerials do format "%: %\n" mat.name (classof mat)
	ApplyMTLToAllMatsInScene OnlyWithDiffuse:false OnlyProperlyNamed:true
	carModifier = carRoot.modifiers["Funsize Car"]
	Funsize_AddTextToXML (FunsizeDataPath+"Data\\Content\\Text\\Text.xml") carModifier.CarName carModifier.DriverName carModifier.WastedName carModifier.CarDescription carModifier.CarFullName
	Funsize_ExportHUDScript FunsizeDataPath carModifier.carname carRoot.Modifiers["Funsize HUD Damage"]
	Funsize_UpdateCarSpecs FunsizeDataPath carModifier.carname carModifier
	Funsize_QuickRaceCars FunsizeDataPath carModifier.carname carModifier onlyAllowCars: onlyAllowCars
	Funsize_ExportCarTXTFile (FunsizeDataPath+"Data\\Content\\Vehicles\\" + carModifier.carname + "\\car.txt") carRoot
	

	carFolder = (FunsizeDataPath+"Data\\Content\\Vehicles\\" + carModifier.carname + "\\")

	global MaterialsToExport
	MaterialsToExport=#()
	ExportMDL carFolder false true exportMats:true exportTextures:true funsizeExport:true createOctree:false nodes:#(carRoot)
	ExportCNT (carFolder+"carbody.cnt") carRoot
	--for mat in MaterialsToExport do format "%, %\n" mat[2].name mat[2].mat_flags
	ExportMaterialsAndTextures carFolder exportMats:true exportTextures:true funsizeExport:true createOctree:false
	RenderMobileUIAssets carModifier.CarName FunsizeDataPath
	global FunsizeLaunchInfo

	if FunsizeLaunchInfo.AutoBuild and nolaunch == false then (
		PackObb()
	)
)