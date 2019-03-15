
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
