
struct PedFile_SpawnSpec
(
	Type,
	Location,
	Location2,
	Radius,
	PedCount,
	GroupOrType,
	Homogenous,
	InitialMode,
	Direction,
	MaterialName,
	Density,

	fn ParseSpawnSpec luaText =
	(
		luaStream = luaText as StringStream
		lineNum = 0
		
		while (eof luaStream) == false do
		(
			lineNum += 1
			line = readLine luaStream
			splitLine = filterstring (trimleft line) ":()"
			if splitLine.count > 0 then
			(
				argsStream = (substituteString splitLine[3] "," ", ") as StringStream
				--format "doing % with args\n"  splitline[2] splitline[3]
				case splitline[2] of
				(
					"Set_Type":
					(
						Type =readToken argsStream
					)
					"Set_Location":
					(
						x = readToken argsStream
						y = readToken argsStream
						z = readToken argsStream
						x = (substring x 1 (x.count-1)) as float
						y = (substring y 1 (y.count-1)) as float
						z = z as float

						Location = ConvertFromCRSpace [x,y,z]
					)
					"Set_Radius":
					(
						x = readToken argsStream
						Radius = x as float
						format "%  - %\n" x radius
					)
					"Set_Count":
					(
						x = readToken argsStream
						PedCount = x as integer
					)
					"Set_Homogenous":
					(

						x = readToken argsStream
						if (tolower x) == "true" then Homogenous = true
						else Homogenous = false
					)
					"Set_GroupOrType":
					(
						GroupOrType = readToken argsStream
					)
					"Set_Location_0":
					(
						x = readToken argsStream
						y = readToken argsStream
						z = readToken argsStream
						x = (substring x 1 (x.count-1)) as float
						y = (substring y 1 (y.count-1)) as float
						z = z as float

						Location = ConvertFromCRSpace [x,y,z]
					)
					"Set_Location_1":
					(
						x = readToken argsStream
						y = readToken argsStream
						z = readToken argsStream
						x = (substring x 1 (x.count-1)) as float
						y = (substring y 1 (y.count-1)) as float
						z = z as float

						Location2 = ConvertFromCRSpace [x,y,z]
					)
					"Set_InitialMode":
					(
						InitialMode =readToken argsStream
					)
					"Set_Direction":
					(
						x = readToken argsStream
						Direction = x as integer
					)
					"Set_MaterialName":
					(
						MaterialName =readToken argsStream
					)
					"Set_Density":
					(
						x = readToken argsStream
						Density = x as float
					)
				)
			)
		)
		
		--while peekToken luaStream != undefined do format "%\n" (readToken luaStream)

	),
	fn CreateSpawnSpec =
	(
		luaText = StringStream ""
		append luaText ("\tCPedSpawnSpec:Set_Type(\""+type+"\")\r\n")
		append luaText ("\tCPedSpawnSpec:Set_GroupOrType(\""+GroupOrType+"\")\r\n")
		if MaterialName != undefined then append luaText ("\tCPedSpawnSpec:Set_MaterialName(\""+MaterialName+"\")\r\n")
		
		if InitialMode != undefined then append luaText ("\tCPedSpawnSpec:Set_InitialMode(\""+InitialMode+"\")\r\n")
		if Location != undefined and Location2 == undefined then 
		(
			crLoc = ConvertToCRSpace location
			append luaText ("\tCPedSpawnSpec:Set_Location("+(crLoc.x as string)+","+(crLoc.y as string)+","+(crLoc.z as string)+")\r\n")
		)
		else if Location != undefined and Location2 != undefined then 
		(
			crLoc = ConvertToCRSpace location
			append luaText ("\tCPedSpawnSpec:Set_Location_0("+(crLoc.x as string)+","+(crLoc.y as string)+","+(crLoc.z as string)+")\r\n")
		)
		if Location2 != undefined then
		(
			crLoc2 = ConvertToCRSpace location2
			append luaText ("\tCPedSpawnSpec:Set_Location_1("+(crLoc.x as string)+","+(crLoc.y as string)+","+(crLoc.z as string)+")\r\n")
		)
		if Homogenous != undefined and Homogenous == false then append luaText "\tCPedSpawnSpec:Set_Homogenous(false)\r\n"
		if Radius != undefined then
		(
			append luaText ("\tCPedSpawnSpec:Set_Radius("+(radius as string)+")\r\n")
		)
		if PedCount != undefined then
		(
			append luaText ("\tCPedSpawnSpec:Set_Count("+(pedcount as string)+")\r\n")
		)
		if Density != undefined then
		(
			append luaText ("\tCPedSpawnSpec:Set_Density("+(density as string)+")\r\n")
		)
		if Direction != undefined then
		(
			append luaText ("\tCPedSpawnSpec:Set_Direction("+(direction as string)+")\r\n")
		)

		return (luaText as string)
	)
)

struct PedFile
(
	PedFileName,
	SpawnSpecs=#(),
	
	fn LoadPedFile fname=
	(
		format "Loading Ped File %\n" fname
		SpawnSpecs = #()
		if (dotnetclass "system.xml.xmldocument") == undefined then
			dotNet.loadAssembly "system.xml"
		xmlDoc=dotNetObject "system.xml.xmlDocument"

		PedFileName = fname
		xmlDoc.load PedFileName

		spawnSpecTags = xmlDoc.GetElementsByTagName "SPAWN_SPEC"

		for i=1 to spawnSpecTags.count do
		(
			tag = spawnSpecTags.item (i-1)
			--format "Spawn spec %\n" i
			for j = 1 to tag.childnodes.count do
			(
				child = tag.childnodes.item (j-1)
				--format "\tChild node % of type %\n" i child.nodetype
				--if child.nodetype == child.nodetype.cdata then
				(
					luaText = child.value

					--format "Node is CData: %\n" luaText
					spawnSpec = PedFile_SpawnSpec()
					spawnSpec.ParseSpawnSpec luaText
					append SpawnSpecs spawnSpec
				)
			)
		)
	),
	mapped function PlaceCube spec =
	(
		if spec.type=="Point" then
		(
			cube = Box name:("PedSpawn_" + spec.GroupOrType) pos: spec.Location length: 2 width:2 height:4

		)
		if spec.type == "Radius" then
		(
			sphereobj = Sphere name:("PedSpawn_"+spec.GroupOrType) pos: spec.Location radius:spec.Radius
		)
	),
	function MakeSpawnSpecNode spec xmldoc =
	(
		specNode = xmlDoc.CreateElement "SPAWN_SPEC"
		textEl = xmldoc.CreateTextNode (spec.CreateSpawnSpec())
		specNode.AppendChild textEl
		((xmldoc.GetElementsByTagName "PED_SPAWN").item 0).AppendChild specnode

	),
	fn SavePedFile fname:undefined =
	(
		if fname != undefined then PedFileName = fname
		

		if (dotnetclass "system.xml.xmldocument") == undefined then
			dotNet.loadAssembly "system.xml"
		xmlDoc=dotNetObject "system.xml.xmlDocument"

	
		xmlRoot = xmlDoc.CreateElement "PED_SPAWN"
		xmlDoc.AppendChild xmlRoot
		
		xmlDecl = xmlDoc.CreateXmlDeclaration "1.0" "" ""
		xmlDoc.InsertBefore xmlDecl xmlRoot

		for spec in spawnspecs do MakeSpawnSpecNode spec xmldoc

		xmlDoc.save(PedFileName)
	),
	mapped function SwapPointForRadius spec =
	(
		spec.type = "Radius"
		spec.radius = 3
		spec.pedcount = 1

	),
	fn DebugPlaceCubes =
	(
		/*for spec in SpawnSpecs do
		(
			if spec.type=="Point" then
			(
				cube = Box name:("PedSpawn_" + spec.GroupOrType) pos: spec.Location length: 2 width:2 height:4

			)
		)*/
		PlaceCube SpawnSpecs
	)
)

fn TestPedFile =
(
	fname = "G:\\Steam\\steamapps\\common\\Carmageddon_Reincarnation\\Data_Core\\Content\\Levels\\C1CityA\\PedFile_race1.xml"
	pf = PedFile()
	pf.LoadPedFile fname
	pf.DebugPlaceCubes()
	--pf.SwapPointForRadius pf.SpawnSpecs
	pf.SavePedFile()
)	
fn ExportSelectedToPedFile fname =
(
	pf = PedFile()
	pf.PedFileName = fname
	for i=1 to $.count do (
		if (substring $[i].name 1 9) == "PedSpawn_" then
		(
			spawnSpec = PedFile_SpawnSpec()
			spawnSpec.GroupOrType = substring $[i].name 10 -1
			spawnSpec.Location = $[i].pos
			if(classOf $[i]) == Sphere then
			(
				spawnSpec.type="Radius"
				spawnSpec.radius = $[i].Radius
				spawnSpec.pedcount = 2
			)
			append pf.SpawnSpecs spawnSpec
		)
	)
	pf.SavePedFile()
	
)