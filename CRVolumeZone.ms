struct ZoneSphereShape (
	Position,
	Radius
)
struct ZoneTictacShape (
	Start,
	End,
	Radius
)
struct ZoneCubeShape (
	Min,
	Max,
	Transform
)
struct ZoneLua (
	ZoneName,
	ZoneType,
	ShapeData,
	Children = #(),
	UserData,
	fn Load name f = (
		ZoneName = name
		lineNum=0
		isZoneModule = false

		zoneObject = ZoneLua()
		inZone = true

		while inZone and not (eof f) do (
			lineNum += 1


			curline = trimLeft (trimRight (readline f))
			if curline != "" and (findString curline "=") != undefined then (
				splitLine = FilterString " ="
				case splitLine[1] of (
					"type": (
						ZoneType = splitLine[2]
						ShapeData = case ZoneType of (
							"cube": ZoneCubeShape()
							"sphere": ZoneSphereShape()
							"tictac": ZoneTictacShape()
						)
					)
					"userdata":Userdata = splitLine[2]
					"children": (
						inChildren = true
						while inChildren and not (eof f) do (
							curline = trimLeft (trimRight (readline f))

							if curline != "" and (findString curline "=") != undefined then (
								splitLine = FilterString " ="
								childZone = ZoneLua()
								lineNume += zone.Load splitLine[1] f
								append Children childZone
							)
							if curline[1] == "}" then (
								inChildren = false
							) 
						)
					)
					"corners": (
						inCorners = true
						while inCorners abd not (eof f) do (
							curline = trimLeft (trimRight (readline f))

							if curline != "" and (findString curline "min") != undefined (
								splitLine = FilterString " ={},"
								ShapeData.Min = [splitLine[2],splitLine[3],splitLine[4]]
							)
							else if curline != "" and (findString curline "max") != undefined (
								splitLine = FilterString " ={},"
								ShapeData.Max = [splitLine[2],splitLine[3],splitLine[4]]
							)
							if curline[1] == "}" then (
								inCorners = false
							)
						)
					)
					"transform": (

						inTransform = true
						ShapeData.Transform = #()
						while inTransform abd not (eof f) do (
							curline = trimLeft (trimRight (readline f))

							if curline != "" and curline[1] == "{" and curline[curline.length-1]=="}" (
								splitLine = FilterString " ={},"
								append ShapeData.Transform [splitLine[2],splitLine[3],splitLine[4]]
							)
							if curline[1] == "}" then (
								inTransform = false
							)
						)
					)
					"ends":(
						splitLine = FilterString " ={},"
						ShapeData.Start = [splitLine[2],splitLine[3],splitLine[4]]
						ShapeData.Start = [splitLine[5],splitLine[6],splitLine[7]]
					)

				)
				else if splitLine[1] == "userdata" then UserDate = splitLine[2]
				zoneG = ZoneLua()
				lineNume += zone.Load splitLine[1] f
			)
			if curline[1] == "}" then (
				inZone = false
			) 
		)
		lineNum
	)
)
struct ZoneGroupLua (
	GroupName,
	Zones=#(),
	fn Load name f = (
		GroupName = name

		lineNum=0
		isZoneModule = false

		zoneObject = ZoneLua()
		inGroup = true

		while inGroup and not (eof f) do (
			lineNum += 1


			curline = trimLeft (trimRight (readline f))
			if curline != "" and (findString curline "=") != undefined then (
				splitLine = FilterString " ="
				zone = ZoneLua()
				lineNume += zone.Load splitLine[1] f
			)
			if curline[1] == "}" then (
				inGroup = false
			) 
		)
		lineNum
	)
)
struct ZoneLua (
	Filename,
	Groups=#(),

	fn Load luafilename = (

		if ((dotnetclass "System.IO.File").exists txtFileName) then
		(
			f = openfile luaFileName mode:"r"

			lineNum=0
			isZoneModule = false

			zoneObject = ZoneLua()

			while not (eof f) do (
				lineNum += 1


				curline = trimLeft (trimRight (readline f))
				if not isZoneModule then (
					if (substring curline 1 6) == "module" and (findString curline "static_volumes") != undefined then isZoneModule = true
				)
				else if curline != "" and (findString curline "=") != undefined then (
					splitLine = FilterString " ="
					zoneGroup = ZoneGroupLua()
					lineNume += zoneGroup.Load splitLine[1] f
				)
			)
		)
	)
)

VolumeZoneAttribute = attributes VolumeZoneCustomAttribute attribid:#(0x7304a5be, 0x43eecc39) version:1 
(
	parameters mainparams rollout:mainzonerollout (
		ZoneGroup type:#string ui:txt_ZoneGroup default:""
		Userdata type:#string ui:txt_Userdata default:""
	)
	rollout mainzonerollout "Zone Details" (
		edittext txt_ZoneGroup "Zone Group" labelontop:true
		edittext txt_Userdata "User data" labelontop:true
	)
)