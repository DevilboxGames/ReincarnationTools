leafindex = 0

struct AdjacentTriangle (ref, tri)
struct AdjacentEdge (refa, refb, face)
struct mbbox (vmin, vmax, center, halfdist)
struct mdlFace (matID, smoothingGroup, flags, v1, v2, v3)
struct mdlMesh (verts, faces, stripOffset, stripVertCount, StripList, patchOffset, patchVertCount, PatchList, BBox)
struct mdlVert (pos, norm, tex, tex2, colour)
struct mdlPrepFace (matID, flags, v1, v2, v3)
struct mdlPrepVert (Position, Normal, UV1, UV2, Colour)
struct mdlPrepMesh (verts, faces, stripOffset, stripVertCount, StripList, patchOffset, patchVertCount, PatchList, BBox)
struct mdlUserFace (PlaneD, PlaneX, PlaneY, PlaneZ, v1NormX, v1NormY, v1NormZ, v2NormX, v2NormY, v2NormZ, v3NormX, v3NormY, v3NormZ, MaterialIndex, SmoothingGroup, v1, v2, v3, v1Colour, v2Colour, v3Colour, v1U, v1V, v1U2, v1V2, v2U, v2V, v2U2, v2V2, v3U, v3V, v3U2, v3V2, FaceFlags, AppSpecificFlags)
struct mdlUserVert (x,y,z,TimesUsed, normX, normY, normZ)
struct MDLMatGroup (matID, triStrip, triStripVertOffset,patchList, patchListVertOffset, numTriangles)



struct LITGnode (lightType, lightBounds, objectNameLength, objectName)
struct SPLNnode (bytes)
struct EMT2node (bytes)
struct MODLnode (objectNameLength, objectName)
struct SKINnode (objectNameLength, objectName)
struct VFXInode (objectNameLength, objectName)
struct NewCNTNode (nameLength, nodeName, isA12CNT, unknownFloat, parentNode, transformMatrix, position, combinedMatrix, absolutePosition,  nodeType, nodeData, numChildren, children)

format "Defining MTL Structs - ca is %\n" mtlmat_ca
struct MTLLayer
(
	Version_Minor,	 -- byte
	Version_Major,	 -- byte
	MapNameLength,	--Int32
	MapName,			-- string padded to 4byte alignment
	BlendMode,			--Uint33
	AlphaOpacity,		--Float
	SpecialFX,			--UInt32
	FlipBookFPS,		--Float
	ScrollSpeedU,		--Float
	ScrollSpeedV,		--Float
	MappingModeU,	--UInt8
	MappingModeV,	--UInt8
	UVSlot,				--UInt8
	NumFramesU,		--UInt8
	NumFramesV,		--UInt8
	LayerFlags,			--UInt8
	fn Save f = 
	(
		if MapName == undefined then MapName = ""
		if MapName.count != MapNameLength then MapNameLength = MapName.count

		if Version_Minor == 0 and Version_Major == 5 then (
			writelong f MapNameLength
			if MapNameLength > 0 then
			(
				paddingLength = 3 - (bit.and (MapNameLength - 1) 3)
				
				writestring f MapName
				fseek f -1 #seek_cur
				for i=1 to paddingLength do
				(
					writeByte f 0
				)
			)
		)
		else if Version_Minor == 7 and Version_Major == 4 then (

				paddingLength = 32 - MapName.Count 
				
				writestring f MapName
				fseek f -1 #seek_cur
				for i=1 to paddingLength do
				(
					writeByte f 0
				)
		)
				writelong f BlendMode #unsigned
		writefloat f AlphaOpacity
		writelong f SpecialFX #unsigned
		writefloat f FlipBookFPS
		writefloat f ScrollSpeedU
		writefloat f ScrollSpeedV
		writebyte f MappingModeU #unsigned
		writebyte f MappingModeV #unsigned
		writebyte f UVSlot #unsigned
		writebyte f NumFramesU #unsigned
		writebyte f NumFramesV #unsigned
		writebyte f LayerFlags #unsigned
		
	),
	fn GetFromMaterial mat layer = (
			
		MapName = mat.mtlmat_data.layer_name[layer]
		BlendMode = mat.mtlmat_data.layer_blend_mode[layer] - 1
		AlphaOpacity = mat.mtlmat_data.layer_alpha_opacity[layer]
		SpecialFX = mat.mtlmat_data.layer_specialfx[layer] - 1
		FlipbookFPS = mat.mtlmat_data.layer_flipbook_fps[layer]
		ScrollSpeedU = mat.mtlmat_data.layer_scrollspeed_u[layer]
		ScrollSpeedV = mat.mtlmat_data.layer_scrollspeed_v[layer]
		MappingModeU = mat.mtlmat_data.layer_mappingmode_u[layer] - 1
		MappingModeV = mat.mtlmat_data.layer_mappingmode_v[layer] - 1
		UVSlot = mat.mtlmat_data.layer_uv_slot[layer]
		NumFramesU = mat.mtlmat_data.layer_numframes_u[layer]
		NumFramesV = mat.mtlmat_data.layer_numframes_v[layer]
		LayerFlags = mat.mtlmat_data.layer_layerflags[layer]
	),
	fn ApplyToMaterial mat layer = (
			
		mat.mtlmat_data.layer_name[layer] 			= MapName
		mat.mtlmat_data.layer_blend_mode[layer] 	= BlendMode + 1
		mat.mtlmat_data.layer_alpha_opacity[layer] = AlphaOpacity
		mat.mtlmat_data.layer_specialfx[layer] 	= SpecialFX + 1
		mat.mtlmat_data.layer_flipbook_fps[layer]  = FlipbookFPS
		mat.mtlmat_data.layer_scrollspeed_u[layer] = ScrollSpeedU
		mat.mtlmat_data.layer_scrollspeed_v[layer] = ScrollSpeedV
		mat.mtlmat_data.layer_mappingmode_u[layer] = MappingModeU + 1
		mat.mtlmat_data.layer_mappingmode_v[layer] = MappingModeV + 1
		mat.mtlmat_data.layer_uv_slot[layer] 		= UVSlot
		mat.mtlmat_data.layer_numframes_u[layer] 	= NumFramesU
		mat.mtlmat_data.layer_numframes_v[layer] 	= NumFramesV
		mat.mtlmat_data.layer_layerflags[layer] 	= LayerFlags
	),
	fn Load f =
	(

		if Version_Major == 5 and Version_Minor == 0 then (
			MapNameLength = readlong f

			if MapNameLength > 0 then
			(
				paddingLength = 3 - (bit.and (MapNameLength - 1) 3)
				MapName = ""
				for i = 1 to MapNameLength do
				(
					str0 = ReadByte f #unsigned
					if str0!=0xFD AND str0!=0xFC do MapName+= bit.intAsChar str0
				)
				for i=1 to paddingLength do
				(
					ReadByte f
				)
			)

		)
		else if Version_Minor == 7 and Version_Major == 4 then (
			MapNameLength = 32
			if MapNameLength > 0 then
			(
				MapName = ""
				local hitEndOfString = false
				for i = 1 to MapNameLength do
				(
					str0 = ReadByte f #unsigned
					if str0 ==0 then hitEndOfString = true
					if str0!=0xFD AND str0!=0xFC and hitEndOfString != false do MapName+= bit.intAsChar str0
				)
			)
		)
		BlendMode = readlong f #unsigned
		AlphaOpacity = readfloat f
		SpecialFX = readlong f #unsigned
		FlipBookFPS = readfloat f
		ScrollSpeedU = readfloat f
		ScrollSpeedV = readfloat f
		MappingModeU = readbyte f #unsigned
		MappingModeV = readbyte f #unsigned
		UVSlot = readbyte f #unsigned
		NumFramesU = readbyte f #unsigned
		NumFramesV = readbyte f #unsigned
		LayerFlags = readbyte f #unsigned
		
	)
)

struct MTLFile (
	Version_Minor,				--byte
	Version_Major,				--byte
	NumLayers,			--UInt32
	Layers,				--MTLLayer[]
	PhysSubstance,			--Int32
	PS2MipDistance,	--Float
	PS2MipValue,		--UInt8
	FlareSpec,			--UInt16
	SaveFlags,			--UInt32
	EmissiveRed,		--Float
	EmissiveGreen,	--Float
	EmissiveBlue,		--Float
	
	AmbientRed,		--Float
	AmbientGreen,		--Float
	AmbientBlue,		--Float
	
	SpecularRed,		--Float
	SpecularGreen,	--Float
	SpecularBlue,		--Float
	SpecularPower,		--Float
	
	AppType,			--UInt32
	AppFlags,			--UInt32
	on create do (

		version_minor	=	0
		version_major	=	5
		numLayers	=	1
		layer = MTLLayer()
			Layer.MapNameLength	=	8
			Layer.MapName	=	"texturename"
			Layer.BlendMode	=	0
			Layer.AlphaOpacity	=	1.0
			Layer.SpecialFX	=	0
			Layer.FlipBookFPS	=	25.0
			Layer.ScrollSpeedU	=	0.0
			Layer.ScrollSpeedV	=	0.0
			Layer.MappingModeU	=	1
			Layer.MappingModeV	=	1
			Layer.UVSlot	=	0
			Layer.NumFramesU	=	4
			Layer.NumFramesV	=	4
			Layer.LayerFlags	=	0
		Layers	=	#(layer)
		PhysSubstance	=	0
		PS2MipDistance	=	1.0
		PS2MipValue	=	0
		FlareSpec	=	0
		SaveFlags	=	838864128
		EmissiveRed	=	0.0
		EmissiveGreen	=	0.0
		EmissiveBlue	=	0.0
		AmbientRed	=	1.0
		AmbientGreen	=	1.0
		AmbientBlue	=	1.0
		SpecularRed	=	1.0
		SpecularGreen	=	1.0
		SpecularBlue	=	1.0
		SpecularPower	=	0.05
		AppType	=	0
		AppFlags	=	0


	),
	fn Save filename = 
	(
		f = fopen filename "wb"
		writebyte f Version_Minor #unsigned
		writebyte f Version_Major #unsigned
		writelong f NumLayers #unsigned
		
		for i=1 to NumLayers do (
			Layers[i].Save f
		)
		
		writelong f PhysSubstance
		writefloat f PS2MipDistance
		writebyte f PS2MipValue #unsigned
		writeshort f FlareSpec #unsigned
		writelong f SaveFlags #unsigned
		writefloat f EmissiveRed
		writefloat f EmissiveGreen
		writefloat f EmissiveBlue
		writefloat f AmbientRed
		writefloat f AmbientGreen
		writefloat f AmbientBlue
		writefloat f SpecularRed
		writefloat f SpecularGreen
		writefloat f SpecularBlue
		writefloat f SpecularPower
		writelong f AppType #unsigned
		writelong f AppFlags #unsigned
		fclose f
	),
	fn GetFromMaterial mat = (
		
		if (custAttributes.get mat mtlmat_ca) != undefined then
		(
			--format "Exporting Mat %\n" mat.name
			PhysSubstance = mat.mtlmat_data.mat_substance - 1
			
			flags = 0
			for i=0 to 31 do (
				if(mat.mtlmat_data.mat_flags[(i+1)] == true) then (
					flags = bit.or flags (bit.shift 1 i)
				)
			)
			SaveFlags = flags

			PS2MipDistance = mat.mtlmat_data.mat_PS2MipDistance
			PS2MipValue = mat.mtlmat_data.mat_PS2MipValue

			FlareSpec = mat.mtlmat_data.mat_FlareSpec

			ambientred = mat.mtlmat_data.mat_red
			ambientgreen = mat.mtlmat_data.mat_green
			ambientblue = mat.mtlmat_data.mat_blue
			
			emissivered = mat.mtlmat_data.mat_emissive_red
			emissivegreen = mat.mtlmat_data.mat_emissive_green
			emissiveblue = mat.mtlmat_data.mat_emissive_blue
			
			specularred = mat.mtlmat_data.mat_specular_red
			speculargreen = mat.mtlmat_data.mat_specular_green
			specularblue = mat.mtlmat_data.mat_specular_blue
			specularpower = mat.mtlmat_data.mat_specular_power
			
			for i = 1 to numlayers do (
				deleteItem Layers i
			)

			for i = 1 to mat.mtlmat_data.layer_name.count do (
				if mat.mtlmat_data.layer_name[i] != undefined then (
					--format "\tMTL Layer %: %\n" i mat.mtlmat_data.layer_name[i]
					layer = MTLLayer()
					layer.GetFromMaterial mat i
					append Layers layer
				)
			)
			numlayers = Layers.count
		)
	),
	fn ApplyToMaterial mat = (
		if (custAttributes.get mat mtlmat_ca) == undefined then
		(
			custAttributes.add mat mtlmat_ca
		)

		mat.mtlmat_data.mat_substance =PhysSubstance + 1

		for i=0 to 31 do (
			mat.mtlmat_data.mat_flags[i+1] =  ((bit.and saveflags (bit.shift 1 i)) == (bit.shift 1 i))
		)

		mat.mtlmat_data.mat_PS2MipDistance = PS2MipDistance
		mat.mtlmat_data.mat_PS2MipValue = PS2MipValue

		mat.mtlmat_data.mat_FlareSpec = FlareSpec

		mat.mtlmat_data.mat_red =ambientred
		mat.mtlmat_data.mat_green =ambientgreen
		mat.mtlmat_data.mat_blue =ambientblue
		
		mat.mtlmat_data.mat_emissive_red =emissivered
		mat.mtlmat_data.mat_emissive_green =emissivegreen
		mat.mtlmat_data.mat_emissive_blue =emissiveblue
		
		mat.mtlmat_data.mat_specular_red =specularred
		mat.mtlmat_data.mat_specular_green =speculargreen
		mat.mtlmat_data.mat_specular_blue =specularblue
		mat.mtlmat_data.mat_specular_power =specularpower
		
		for i =  mat.mtlmat_data.layer_name.count to 1 by -1 do (
			deleteItem mat.mtlmat_data.layer_name i
			deleteItem mat.mtlmat_data.layer_blend_mode i
			deleteItem mat.mtlmat_data.layer_alpha_opacity i
			deleteItem mat.mtlmat_data.layer_specialfx i
			deleteItem mat.mtlmat_data.layer_flipbook_fps i
			deleteItem mat.mtlmat_data.layer_scrollspeed_u i
			deleteItem mat.mtlmat_data.layer_scrollspeed_v i
			deleteItem mat.mtlmat_data.layer_mappingmode_u i
			deleteItem mat.mtlmat_data.layer_mappingmode_v i
			deleteItem mat.mtlmat_data.layer_uv_slot i
			deleteItem mat.mtlmat_data.layer_numframes_u i
			deleteItem mat.mtlmat_data.layer_numframes_v i
			deleteItem mat.mtlmat_data.layer_layerflags i
		)
		for i = 1 to numlayers do (
			layer = Layers[i]
			layer.ApplyToMaterial mat i
		)

	),
	fn Load filename = (
		f = fopen filename "r"
		
		Version_Minor = ReadByte f #unsigned
		Version_Major = ReadByte f #unsigned
		NumLayers = readlong f #unsigned
		Layers = #()
		for i=1 to NumLayers do (
			layer = MTLLayer()
			layer.Version_Minor = Version_Minor
			layer.Version_Major = Version_Major
			layer.Load f
			append Layers layer
		)
		
		PhysSubstance = readlong f
		PS2MipDistance = readfloat f
		PS2MipValue = readbyte f #unsigned
		FlareSpec = readshort f #unsigned
		SaveFlags = readlong f #unsigned
		EmissiveRed = readfloat f
		EmissiveGreen = readfloat f
		EmissiveBlue = readfloat f
		AmbientRed = readfloat f
		AmbientGreen = readfloat f
		AmbientBlue = readfloat f
		SpecularRed = readfloat f
		SpecularGreen = readfloat f
		SpecularBlue = readfloat f
		SpecularPower = readfloat f
		AppType = readlong f #unsigned
		AppFlags = readlong f #unsigned
		fclose f
	)
)

fn TestMTLLoadSave = (
	mtl = MTLFile()
	mtl.Load("E:\Backups\CarmAndroid\WADs\Data_Android\DATA\CONTENT\VEHICLES\ANNIECAR\ANNIECAR.MTL")
	mtl.Save("E:\Backups\CarmAndroid\WADs\Data_Android\DATA\CONTENT\VEHICLES\ANNIECAR\ANNIECAR2.MTL")
)
struct OctreeFaceIndex(
	Indices,
	IsRun
)
struct OctreeFaceRun (
	Entries
)
struct OctreeModelFaceData (
	ModelIndex,
	FaceRun
)
struct OctreeModelFaces (
	Entries
)
struct OctreeFaces (
	ModelFaces
)
struct OctreeLeafData (
	FacesLength,
	FacesData,
	
	ModelIndex,
	Faces,
	fn ParseFacesData = (
		local code = 0
		local run_length = 0
		ModelIndex = FacesData[1]
		loopthefaces = true

		local i = 1
		local face_index = 1
		Faces = #()
		while loopthefaces do (
			i = i + 1
			if i <= FacesLength then (
				code = FacesData[i]
				if code > 0xFF00 then (
					run_length = bit.and code 0xFF
					if run_length >= 0xFE then (
						loopthefaces = false
					)
				)
				else (
					face_index = code
					run_length = 1
				)
				if loopthefaces then (
					for rl = 1 to run_length do (
						append Faces face_index
						face_index = face_index + 1
					)
				)
			)
			else (
				loopthefaces =false
			)
		)
	),
	fn CreateFacesData = (
		if Faces.count > 0 then (
			FacesData = #()
			sort Faces
			append FacesData 0

			local lastFace = Faces[1]
			append FacesData lastFace
			
			local loopthefaces = true

			local faceid = 2
			local runlength = 0
			while loopthefaces do (
				if faceid <= Faces.count then (
					nextface = Faces[faceid]
					if (nextface - lastface) == 1 then (
						runlength = runlength + 1
						if faceid == Faces.count then (
							code = bit.or 0xFF00 runlength
							append FacesData code
							runlength = 0
						)
					)
					else (
						if runlength > 0 then (
							code = bit.or 0xFF00 runlength
							append FacesData code
							runlength = 0
						)
						append FacesData nextface
					)

					lastface = nextface
					faceid = faceid + 1
				)
				else (
					append FacesData 0xFFFF
					--append FacesData 0
					loopthefaces = false
				)
			)
			append FacesData 0xFFFF
		)
	),
	fn TestFaceCreateData = (
		local oldFacesData = copy FacesData #noMap
		CreateFacesData()

		format "oldFacesData.count = %;\t FacesData.count = %\n" oldFacesData.count FacesData.count
		local maxCount = oldFacesData.count
		if FacesData.count > oldFacesData.count then maxCount = FacesData.count

		for i = 1 to maxCount do (

			if i <= oldFacesData.count then (
				format "%\t\t" oldFacesData[i]
			)
			else (
				format "\t\t\t"
			)
			if i <= FacesData.count then (
				format "%\n" FacesData[i]
			)
			else (
				format "\n"
			)
		)

	)

)
struct OctreeNodeData (
	ChildMask,
	ChildType,
	SplitFlags,
	Children
)
struct OctreeNode (
	NodeData,
	LeafData,
	Bounds
)
struct CNTOctree (
	Version,
	LumpIndex,
	BoundsMin,
	BoundsMax,
	Size,
	Center,
	FaceListCount,
	Faces,
	FacesOffset,
	RootNode,
	CurrentDepth,

	fn GetNodeSize depth = (
		nodeSize = Size

		for i = 1 to depth do (
			nodeSize = nodeSize * 0.5
		)

		nodeSize
	),

	fn ReadLeaf f = (
		--for i= 1 to currentdepth do format "\t"
		--format "Reading leaf!\n"
		CurrentDepth = CurrentDepth + 1
		octLeaf = OctreeLeafData()
		octLeaf.FacesLength = readlong f
		--for i= 1 to currentdepth do format "\t"
		--format "FacesLength: % \n" octLeaf.FacesLength
		octLeaf.FacesData = #()
		if octLeaf.FacesLength + FacesOffset > Faces.count then (
			octleaf.FacesLength = Faces.count - FacesOffset
		)

		leafindex = leafindex+1
		
		--for i= 1 to currentdepth do format "\t"
			--format "Faces: "
		for i = FacesOffset to (FacesOffset + octLeaf.FacesLength) do (
		--	format "%, " (Faces[i] as string)
			append octLeaf.FacesData Faces[i]
		)

		--format "\n"
		FacesOffset = FacesOffset + octLeaf.FacesLength
		octLeaf.Faces = #()
		if octLeaf.FacesLength > 0 then (
			--format "Leaf FacesData (%): %\n\n" octLeaf.FacesData.count octLeaf.FacesData
			octLeaf.ParseFacesData()
			--format "Leaf Faces (%): %\n\n" octLeaf.Faces.count octLeaf.Faces
		)
		CurrentDepth = CurrentDepth - 1
		octLeaf
	),
	fn ReadNode f = (

		--for i= 1 to currentdepth do format "\t"
		--	format "Reading Node\n"
		CurrentDepth = CurrentDepth + 1
		octNode = OctreeNodeData()
		octNode.ChildMask = ReadByte f
		octNode.ChildType = ReadByte f
		octNode.SplitFlags = ReadByte f
		octNode.Children = #()

		--for i= 1 to currentdepth do format "\t"
		--printflagbits octNode.ChildMask 8 "ChildMask"
		--for i= 1 to currentdepth do format "\t"
		--printflagbits octNode.ChildType 8 "ChildType"
		--for i= 1 to currentdepth do format "\t"
		--printflagbits octNode.SplitFlags 8 "SplitFlags"
		for i = 1 to 8 do (
			nodemask = bit.shift 1 (i-1)
			nodeCell = OctreeNode()
			if (bit.and nodemask octNode.ChildMask) == nodemask then (
				if (bit.and nodemask octNode.ChildType) == nodemask then (
					nodeCell.LeafData = (ReadLeaf f)
					if leafindex == 200 then (
						--format "!!!!! 200th leaf index is %" i
					)
				)
				else (
					nodeCell.NodeData = (ReadNode f)
				)
			)
			else (
				if ((bit.and (i-1) 1) == 0 or (bit.and octNode.SplitFlags 1) ==1) and ((bit.and (i-1) 2) == 0 or (bit.and octNode.SplitFlags 2) == 2) and((bit.and (i-1) 4) == 0 or (bit.and octNode.SplitFlags 4) ==4) then (
					append octnode.children undefined --(OctreeNode LeafData:(OctreeLeafData FacesLength:0) )
				)
			)
			append octnode.Children nodeCell
		)
		CurrentDepth = CurrentDepth - 1
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		octNode

	),
	fn Load f = (
		CurrentDepth = -1
		FacesOffset = 1
		Version = readlong f #unsinged
		LumpIndex = readlong f #unsigned
		readshort f
		tmpMin = ConvertFromCRSpace [(readfloat f), (readfloat f), (ReadFloat f)]
		tmpMax = ConvertFromCRSpace [(readfloat f), (readfloat f), (ReadFloat f)]
		if tmpMin.x > tmpMax.x then (
			tmpX = tmpMin.x
			tmpMin.x = tmpMax.x
			tmpMax.x = tmpX
		)
		if tmpMin.y > tmpMax.y then (
			tmpY = tmpMin.y
			tmpMin.y = tmpMax.y
			tmpMax.y = tmpY
		)
		if tmpMin.z > tmpMax.z then (
			tmpZ = tmpMin.z
			tmpMin.z = tmpMax.z
			tmpMax.z = tmpZ
		)
		BoundsMin = tmpMin
		BoundsMax = tmpMax
		Size  = BoundsMax - BoundsMin
		Center = BoundsMin + (Size * 0.5)

		FaceListCount = readlong f  #unsigned
		Faces = #()
		i = 0
		facelistmode = 0
		-- 0 = faces
		-- 1 = ModelFaces
		-- 2 = Model Index
		-- 3 = Face Run
		-- 4 = Face Index
		-- 5 = Run Code
		--format "Number of faces: % (pos %)\n" FaceListCount (ftell f)
		while i < FaceListCount do (
			append Faces (readshort f #unsigned)
			i = i + 1
		)

		--format "Read faces: % (pos %)\n" Faces.count (ftell f)
		RootNode = ReadNode f

	),

	fn WriteLeaf f leaf = (
		--for i= 1 to currentdepth do format "\t"
		--format "Writing Leaf\n"
		CurrentDepth = CurrentDepth + 1
		
		--for i= 1 to currentdepth do format "\t"
		--	format "FacesCount: %\n" leaf.Faces.Count
		--for i= 1 to currentdepth do format "\t"
		--	format "Faces: "
		--for i = 1 to leaf.Faces.Count do (
			
		--		format "%, " leaf.faces[i]
		--)
		--format "\n"
		currentdepth = currentdepth - 1
		WriteLong f leaf.Faces.count
	),

	fn WriteNode f node = (
		--format "Writing Node\n"
		--for i= 1 to currentdepth do format "\t"
		--	format "Writing Node\n"
		currentdepth = currentdepth + 1
		writebyte f node.ChildMask
		writebyte f node.ChildType
		writebyte f node.SplitFlags
		--for i= 1 to currentdepth do format "\t"
		--printFlagBits node.ChildMask 8 "ChildMask"
		--for i= 1 to currentdepth do format "\t"
		---printFlagBits node.ChildType 8 "ChildType"
		--for i= 1 to currentdepth do format "\t"
		--printFlagBits node.SplitFlags 8 "Splitflags"
		for i = 1 to node.children.count do (
			if node.children[i] != undefined then (
				if node.children[i].leafdata != undefined then (
					WriteLeaf f node.children[i].leafdata
				)
				else if node.children[i].nodedata != undefined then (
					WriteNode f node.children[i].nodedata
				)
			)
		)
		currentdepth = currentdepth - 1
	),
	fn Save f = (
		 currentdepth = -1
		--format"Saving octree to CNT\n"
		writelong f Version #unsigned
		writelong f LumpIndex #unsigned
		writeshort f 0 -- FIXME: Add child matrix support
		tmpMin = ConvertToCRSpace BoundsMin
		writefloat f tmpMin.x
		writefloat f tmpMin.y
		writefloat f tmpMin.z
		tmpMax = ConvertToCRSpace BoundsMax
		writefloat f tmpMax.x
		writefloat f tmpMax.y
		writefloat f tmpMax.z

		writelong f 0 --Faces.count #unsigned
		--format "Faces count: %\n" (Faces.Count)
		i=1
		while i <= Faces.count do (
			writeshort f Faces[i] #unsigned
			i = i + 1
		)

		--WriteNode f rootnode
		WriteByte f 0
		WriteByte f 0
		WriteByte f 7

		Writelong f 0
		Writelong f 0

	),
	fn GetChildBounds parentNode parentBounds childIndex = (
		local bounds = mbbox()
		bounds.vmin = [0,0,0]
		bounds.vmax = [0,0,0]
		bounds.center = [0,0,0]

		if (bit.and parentNode.SplitFlags 1) == 1 then (
			-- split X
			if (bit.and childIndex 1) != 1 then (
				bounds.vmin.x = parentBounds.center.x
				bounds.vmax.x = parentBounds.vmax.x
			)
			else (	
				bounds.vmin.x = parentbounds.vmin.x
				bounds.vmax.x = parentbounds.center.x
			)
		)
		else (
			bounds.vmin.x = parentbounds.vmin.x
			bounds.vmax.x = parentbounds.vmax.x
		)
		if (bit.and parentNode.SplitFlags 2) == 2 then (
			-- split Y (3dsmax Z)
			if (bit.and childIndex 2) == 2 then (
				bounds.vmin.z = parentbounds.center.z
				bounds.vmax.z = parentbounds.vmax.z
			)
			else (	
				bounds.vmax.z = parentbounds.center.z
				bounds.vmin.z = parentbounds.vmin.z
			)
		)
		else (
			bounds.vmin.z = parentbounds.vmin.z
			bounds.vmax.z = parentbounds.vmax.z
		)
		if (bit.and parentNode.SplitFlags 4) == 4 then (
			-- split Z (3dsmax Y)
			if (bit.and childIndex 4) != 4 then (
				bounds.vmin.y = parentbounds.center.y
				bounds.vmax.y = parentbounds.vmax.y
			)
			else (	
				bounds.vmax.y = parentbounds.center.y
				bounds.vmin.y = parentbounds.vmin.y
			)
		)
		else (
			bounds.vmin.y = parentbounds.vmin.y
			bounds.vmax.y = parentbounds.vmax.y
		)

		bounds.center = bounds.vmin + (bounds.vmax - bounds.vmin) * 0.5

		bounds
	) ,
	
	fn SpawnLeafBox leaf nodedepth leafbounds parentObject pIndex:0 nodeLocation:"0" useBox:false verts:undefined faces:undefined = (
		local leafBox 
		local boxSize = leafbounds.vmax - leafbounds.vmin
		leafbox = getNodeByName ("Leaf_"+(nodeLocation as string))
		
		if leafBox == undefined then (
			leafBox = dummy boxsize:[boxSize.x, boxSize.y,boxSize.z]
			leafBox.pos = leafbounds.center
			leafBox.name = "Leaf_"+(nodeLocation as string)
			leafBox.parent = parentObject
			hide leafBox
		)
		if leaf.facesLength > 0 then (
			leafMesh = leafBox.children[1]
			if leafMesh == undefined and useBox == true then (
				leafMesh = box()
				leafMesh.width = boxSize.x
				leafMesh.length = boxSize.y
				leafMesh.height = boxSize.z
				leafMesh.pos = leafbounds.vmin + (boxSize * 0.5)
				
				leafMesh.pos = [leafbounds.center.x, leafbounds.center.y ,leafbounds.center.z- (boxSize.z*0.5)]

				leafMesh.name = "LeafMesh_"+(nodeLocation as string)
				leafMesh.parent = leafBox
			)
			else if useBox == false then (
				if leafMesh == undefined then (
					leafMesh = mesh numverts:0 numfaces:0
					leafMesh.name = "LeafMesh_"+(nodeLocation as string)
					leafMesh.parent = leafBox
				)
				if  verts != undefined then (
					numMeshVerts = getNumVerts leafMesh
					numMeshFaces = getNumFaces leafMesh
					newVerts = #()
					newFaces = #()
					for i = 1 to  leaf.Faces.count do (
						v1 = faces[leaf.Faces[i]+1].v1
						v2 = faces[leaf.Faces[i]+1].v2
						v3 = faces[leaf.Faces[i]+1].v3

						newFace = [numMeshVerts + ((i - 1) * 3) + 1, numMeshVerts + ((i - 1) * 3) + 2, numMeshVerts + ((i - 1) * 3) + 3]
						append newFaces newFace
						append newVerts verts[v1].pos
						append newVerts verts[v2].pos
						append newVerts verts[v3].pos

						

					)
					setNumVerts leafMesh (numMeshVerts + newVerts.count) true
					setNumFaces leafMesh (numMeshFaces + newFaces.count) true
					for j = 1 to newVerts.count do (
						setVert leafMesh (j+numMeshVerts) newVerts[j]
					)
					for k = 1 to newFaces.count do (
						setFace leafMesh (k+numMeshFaces) newFaces[k]
									
						setEdgeVis leafMesh k 1 true
						setEdgeVis leafMesh k 2 true
						setEdgeVis leafMesh k 3 true
					)
					update leafMesh
				)
			)
			
			--redrawViews() 
			if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
			leafbox
		)
		leafBox
	),

	fn SpawnLeafBoxes currentnode: undefined bbox:undefined nodedepth: 0 nodeLocation:"0" xPos:false yPos:false zPos:false parentObject:undefined pIndex:0 verts:undefined faces:undefined useBox:false = (
		FaceListCountdone = 0

		if currentnode == undefined then (
			currentnode = RootNode
			bbox = mbbox()
			bbox.vmin = BoundsMin
			bbox.vmax = BoundsMax
			bbox.center = Center
		)
		newobject = getNodeByName ("Node_"+(nodeLocation as string))
			--format "current node object: % (Node_%_%)\n" newObject (nodedepth as string) (pIndex as string)
		if (newobject == undefined) then (
			newobject = dummy boxsize:[bbox.vmax.x - bbox.vmin.x, bbox.vmax.y - bbox.vmin.y,bbox.vmax.z - bbox.vmin.z]
			newobject.pos = bbox.center
			newobject.name = "Node_"+(nodeLocation as string)
			newobject.parent = parentObject
			hide newobject
		)
		--format "LastCellSize: % - LastCellMin: %\n\n" lastCellSize lastCellMin
		for i = 1 to 8 do (
			
			local nodemask = bit.shift 1 (i-1)
			local nodeCell = currentnode.children[i]
			if nodeCell != undefined then (
			nodecell.Bounds = GetChildBounds currentnode bbox (i-1)

				if Nodecell.leafdata != undefined then (
					local spawnedbox = SpawnLeafBox nodecell.leafdata (nodedepth + 1) nodecell.bounds newobject pIndex:i  verts:verts faces:Faces useBox:useBox  nodeLocation:(nodeLocation+(i as string))
					spawnedbox.parent = newobject
				)
				else if nodecell.nodedata != undefined then (
					
					local spawnednode = SpawnLeafBoxes currentNode:nodecell.nodedata bbox:nodecell.bounds nodedepth:(nodedepth+1) pIndex:(i-1)  useBox:useBox parentObject: newObject verts:verts  faces:Faces nodeLocation:(nodeLocation+(i as string))
					--spawnednode.parent=newobject
				)
			)
		)
		--format "Bounds: % - % Center: % Size %\n\n" BoundsMin BoundsMax Center Size
		
			if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()

		
		--format "Bounds: % - % Center: % Size %\n\n" BoundsMin BoundsMax Center Size
				newobject
	),

	ModelVerts,
	ModelFaces,
	FaceDepths,

	BoundsObject,
	FaceObject,
	FacesItterated = 0,

	fn FaceIntersectsBounds faceIndex bounds faces:undefined = (

		if faces == undefined then (
			format "Faces undefined!\n"
			faces = ModelFaces
		)


		if BoundsObject == undefined then (
			boundsheight = (bounds.vmax.z - bounds.vmin.z) * 0.5
			BoundsObject = Box width:(bounds.vmax.x - bounds.vmin.x) length:(bounds.vmax.y - bounds.vmin.y) height:(bounds.vmax.z - bounds.vmin.z) pos:[bounds.center.x, bounds.center.y, bounds.center.z - boundsheight]
		)
		else (
			BoundsObject.width = (bounds.vmax.x - bounds.vmin.x)
			BoundsObject.length = (bounds.vmax.y - bounds.vmin.y) 
			BoundsObject.height = (bounds.vmax.z - bounds.vmin.z) 
			boundsheight = (bounds.vmax.z - bounds.vmin.z) * 0.5
			BoundsObject.pos = [bounds.center.x, bounds.center.y, bounds.center.z - boundsheight]
			update FaceObject
		)
		
			local v1 = [ModelVerts[faces[faceIndex].v1].pos.x,ModelVerts[faces[faceIndex].v1].pos.y,ModelVerts[faces[faceIndex].v1].pos.z]
			local v2 = [ModelVerts[faces[faceIndex].v2].pos.x,ModelVerts[faces[faceIndex].v2].pos.y,ModelVerts[faces[faceIndex].v2].pos.z]
			local v3 = [ModelVerts[faces[faceIndex].v3].pos.x,ModelVerts[faces[faceIndex].v3].pos.y,ModelVerts[faces[faceIndex].v3].pos.z]
		if FaceObject == undefined then (
			FaceObject = mesh vertices:#(v1,v2,v3) faces:#([faces[faceIndex].v1,faces[faceIndex].v2,faces[faceIndex].v3])
			update FaceObject
		)
		else (
			setVert FaceObject 1 v1
			setVert FaceObject 2 v2
			setVert FaceObject 3 v3
			update FaceObject
		)

		--
		if FacesItterated > 100 then (
			redrawViews()
			if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		)
		
		local doesIntersect = intersects BoundsObject FaceObject

		
		doesIntersect
	),
	fn CalculateSplitFlags bounds faces = (

		local splitFlags = 0
		local xMinFaces = 0
		local xMaxFaces = 0
		local yMinFaces = 0
		local yMaxFaces = 0
		local zMinFaces = 0
		local zMaxFaces = 0

		for i = 1 to faces.count do (

			v1 = ModelVerts[faces[i].v1].pos
			v2 = ModelVerts[faces[i].v2].pos
			v3 = ModelVerts[faces[i].v3].pos

			if v1.x < bounds.center.x and v2.x < bounds.center.x and v3.x < bounds.center.x then (
				xMinFaces = xMinFaces + 1
			)
			if v1.x > bounds.center.x and v2.x > bounds.center.x and v3.x > bounds.center.x then (
				xMaxFaces = xMaxFaces + 1
			)
			if v1.y < bounds.center.y and v2.y < bounds.center.y and v3.y < bounds.center.y then (
				yMinFaces = yMinFaces + 1
			)
			if v1.y > bounds.center.y and v2.y > bounds.center.y and v3.y > bounds.center.y then (
				yMaxFaces = yMaxFaces + 1
			)
			if v1.z < bounds.center.z and v2.z < bounds.center.z and v3.z < bounds.center.z then (
				zMinFaces = zMinFaces + 1
			)
			if v1.z > bounds.center.z and v2.z > bounds.center.z and v3.z > bounds.center.z then (
				zMaxFaces = zMaxFaces + 1
			)

		)

		
		--Split X
		if (xMinFaces + xMaxFaces) > (0.5 * faces.count) then (
			splitflags = bit.or splitflags 1
		)
		--Split Y (3DSMax Z)
		if (zMinFaces + zMaxFaces) > (0.5 * faces.count) then (
			splitflags = bit.or splitflags 2
		)
		--Split Z (3DSMax Y)
		if (yMinFaces + yMaxFaces) > (0.5 * faces.count) then (
			splitflags = bit.or splitflags 4
		)

		--format "Split: xMin: % xMax: % yMin: % yMax: % zMin: % zMax: %\n" xMinFaces xMaxFaces yMinFaces yMaxFaces zMinFaces zMaxFaces
		--printFlagBits splitFlags 8 "SplitFlags" 
		splitflags
	),
	fn CreateLeaf faces = (
		leaf = OctreeLeafData()
		leaf.Faces = #()
		leaf.FacesData = #()
		for i = 1 to faces.count do (
			append leaf.Faces ((finditem ModelFaces faces[i]) - 1)
		)

		--format "Append % faces to leaf\n" faces.count
		leaf.CreateFacesData()
		leaf.FacesLength = leaf.FacesData.count

		leaf
	),
	fn CreateNode parentbounds faces = (

		outputNode = OctreeNode()
		local FacesInBox = 0
		CurrentDepth = CurrentDepth + 1
		local splitflags = 0
		
		if CurrentDepth >= 9 or (CurrentDepth > 0 and faces.count < 200) then (
			--format "Max Depth Reached\n"
			splitflags = 0
			if faces.count > (200/8) then (
				if (parentbounds.vmax.x - parentbounds.vmin.x) > 100.0f then  (
					splitflags = bit.or splitflags 1
				)
				if (parentbounds.vmax.y - parentbounds.vmin.y) > 100.0f then (
					splitflags = bit.or splitflags 4
				)
			)
			if splitflags == 0 then (
				--format "Split flags is 0, creating leaf of % faces\n" faces.count
				leaf = CreateLeaf faces
				outputNode.leafdata = leaf
			)
		)
		else (
			splitflags = CalculateSplitFlags parentbounds faces
		)
		if outputNode.leafdata == undefined  and CurrentDepth > 0 and splitflags == 0 then (
			--format "Creating leaf at depth %\n" currentDepth
			leaf = CreateLeaf faces
			outputNode.leafdata = leaf
		)
		if outputNode.leafdata == undefined then (
			--format "Creating branch node at depth %\n" currentDepth
			nodedata = OctreeNodeData()
			nodedata.ChildMask = 0
			nodedata.ChildType = 0
			nodedata.SplitFlags = splitflags
			nodedata.Children=#()
			for i = 1 to 8 do (
				--format "\nCreating Child Node %\n" i
				
				nodemask = bit.shift 1 (i-1)
				if ((bit.and splitflags 1) == 0 and (bit.and (i - 1) 1) == 1) or ((bit.and splitflags 2) == 0 and (bit.and (i - 1) 2) == 2) or ((bit.and splitflags 4) == 0 and (bit.and (i - 1) 4) == 4) then (
					--format "Not split, node doesn't exist\n"
					--printflagbits splitflags 8 "SplitFlags"
					append nodedata.children undefined
				)
				else (
					nodedata.ChildMask = bit.or nodemask nodedata.ChildMask
					--format "Making child bounds and collecting faces\n"
					local childbounds = GetChildBounds nodedata parentbounds (i - 1)
					childbounds.vmin = childbounds.vmin - [0.001,0.001,0.001]
					childbounds.vmax = childbounds.vmax + [0.001,0.001,0.001]
					local childfaces = #()
					for f = 1 to faces.count do (
						if (FaceIntersectsBounds f childbounds faces:faces) do (
							append childfaces faces[f]
						)
					)
					--format "Old Faces: % ChildFaces: %\n" faces.count childfaces.count
					append nodedata.children (CreateNode childbounds childfaces)
					if nodedata.children[i].leafdata != undefined then (
						nodedata.childtype = bit.or nodedata.childtype (bit.shift 1 (i - 1))
					)
				)
			)
			outputnode.nodedata = nodedata			
		)
		
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		CurrentDepth = CurrentDepth - 1
		outputNode
	),
	fn GatherFaceData node = (
		if node != undefined then (
			for child in node.children do (
				if child != undefined then (
					if child.leafData != undefined then (
						for faceEntry in child.leafdata.FacesData do (
							append Faces faceEntry
						)
					)
					else (
						GatherFaceData child.nodedata
					)
				)
			)
		)
		FacesListCount = Faces.count
	),
	fn GenerateOctree verts meshfaces bounds = (
		ModelFaces = copy meshfaces #nomap
		ModelVerts = copy verts #nomap
		Format "Generating octree from % verts and % faces within bounds %\n" verts.count meshfaces.count bounds
		Version = 3
		LumpIndex = 1
		BoundsMin = bounds.vmin - [0.001, 0.001, 0.001]
		BoundsMax = bounds.vmax + [0.001, 0.001, 0.001]
		Faces = #()
		Size = bounds.vmax - bounds.vmin
		Center = bounds.center

		CurrentDepth = -1
		FaceDepths = #()

		format "Creating Root Node\n"
		--RootNode = (CreateNode bounds ModelFaces).nodeData
		--GatherFaceData rootnode
		if BoundsObject != undefined then delete BoundsObject
		if FaceObject != undefined then delete FaceObject

		free ModelFaces
		free ModelVerts
	)
)


fn TestCNTOctree level:"MINES" SpawnBoxes:true SetActiveOctree:false Resave:false ThenReload: false= (
	local cntOct = CNTOctree()
	f = undefined
	try (
		f = fopen ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\\DATA\\CONTENT\\TRACKS\\LEVELS\\"+level+"\LEVEL.CNT") "r"

		fseek f 93 #seek_set 
		cntOct.Load f
		if SpawnBoxes then (
			cntOct.SpawnLeafBoxes useBox:true
		)
		fclose f

		if Resave then (
			cntOct.GatherFaceData cntOct.rootnode
			copyfile ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\\DATA\\CONTENT\\TRACKS\\LEVELS\\"+level+"\LEVEL.CNT") ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\\DATA\\CONTENT\\TRACKS\\LEVELS\\"+level+"\LEVEL_test.CNT")
			
			
		f = fopen ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\\DATA\\CONTENT\\TRACKS\\LEVELS\\"+level+"\LEVEL_test.CNT") "r"

		fseek f 93 #seek_set 
			cntOct.Save  f
		fclose f
			if ThenReload then (
				cntOct = CNTOctree()
			f = fopen ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\\DATA\\CONTENT\\TRACKS\\LEVELS\\"+level+"\LEVEL_test.CNT") "r"

			fseek f 93 #seek_set 
			cntOct.Load  f
			fclose f
				
		if SpawnBoxes then (
			oldnodes = $'Node*'
			oldleafs = $'Leaf*'
			for obj in oldnodes do obj.name = "Original_"+obj.name
			for obj in oldleafs do obj.name = "Original_"+obj.name
			cntOct.SpawnLeafBoxes useBox:true
		)
			)
		)
	)
	catch (
		format "There was an error \n"
		if f != undefined then (
			fclose f
		)
		throw()
	)
	if SetActiveOctree then (
		ActiveOctree =cntOct
	)
	1
)

struct VFXAnchorData (
	AnchorID,
	LumpName,
	Offset,
	Rotation,
	Scale
)
struct VFXAnchorGroupData (
	GroupName,
	Anchors
)
