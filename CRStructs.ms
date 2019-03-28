
struct CRSettings (GamePath, DataCorePath, AllowSeperateDataCore, TexturePath, GibbedTools, LOLDecoder, MaxResolution,MaxResolutionID)

struct AdjacentTriangle (ref, tri)
struct AdjacentEdge (refa, refb, face)
struct mbbox (vmin, vmax, center, halfdist)
struct mdlFace (matID, flags, v1, v2, v3)
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

format "Defining MTL Structs - ca is %" mtlmat_ca
struct MTLLayer
(
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
		MappingModeU = mat.mtlmat_data.layer_mappingmode_u[layer]
		MappingModeV = mat.mtlmat_data.layer_mappingmode_v[layer]
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
		mat.mtlmat_data.layer_mappingmode_u[layer] = MappingModeU
		mat.mtlmat_data.layer_mappingmode_v[layer] = MappingModeV
		mat.mtlmat_data.layer_uv_slot[layer] 		= UVSlot
		mat.mtlmat_data.layer_numframes_u[layer] 	= NumFramesU
		mat.mtlmat_data.layer_numframes_v[layer] 	= NumFramesV
		mat.mtlmat_data.layer_layerflags[layer] 	= LayerFlags
	),
	fn Load f =
	(
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
	Version,				--UInt16
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

		version	=	1280
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
		SaveFlags	=	839124992
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
		writeshort f Version #unsigned
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
			PhysSubstance = mat.mtlmat_data.mat_substance - 1
			mat.mtlmat_data.flags = #()

			flags = 0
			for i=0 to 31 do (
				if(mtl.mtlmat_data.mat_flags[i] == true) then (
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
			
			for i = 0 to numlayers do (
				deleteItem Layers i
			)

			for i = 0 to mat.mtlmat_data.layer_name.count do (
				if mat.mtlmat_data.layer_name[i] != undefined then (
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

		for i=1 to 31 do (
			mat.mtlmat_data.mat_flags[i] =  ((bit.and saveflags (bit.shift 1 i)) == (bit.shift 1 i))
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
		
		Version = readshort f #unsigned
		NumLayers = readlong f #unsigned
		Layers = #()
		for i=1 to NumLayers do (
			layer = MTLLayer()
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
