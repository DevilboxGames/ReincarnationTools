
CRLightAttribute = attributes CRLightCustomAttribute attribID:#(0x5c212ae7, 0x57b99048) version:1
(
	parameters crlightparams rollout:CRLightRollout
	(
		UsePool type:#boolean default:false ui:chk_UsePool
		IsASunLight type:#boolean default: false ui:chk_IsASun

		ShadowSplitCount type:#integer default: 1 ui:spn_ShadowSplitCount
		ShadowSplitDistribution type:#float default:0.5 ui:spn_ShadowSplitDistribution
		ShadowDistanceMin type:#float default:0.5 ui:spn_ShadowDistanceMin
		ShadowDistanceMax type:#float default:2000 ui:spn_ShadowDistanceMax
		ShadowCoverageX type:#float default:1 ui:spn_ShadowCoverageX
		ShadowCoverageY type:#float default:1 ui:spn_ShadowCoverageY

		UseEdgeColour type:#boolean default:false ui:chk_UseEdgeColour
		EdgeColour type:#color default:(color 0 0 0 255) ui:colpck_EdgeColour
	)
	rollout CRLightRollout "CR Light Properties"
	(
		checkbox chk_UsePool "Use Pool"
		checkbox chk_IsASun "Is A Sun (possibly?)"
		group "Shadows"
		(
			spinner spn_ShadowSplitCount "Split Count" type:#integer range:[0,4,1]
			spinner spn_ShadowSplitDistribution "Split Distribution" type:#float range:[0,1,0.5]
			spinner spn_ShadowDistanceMin "Min Distance" type:#float range:[0,4000,0.1]
			spinner spn_ShadowDistanceMax "Max Distance" type:#float range:[0,4000,2000]
			spinner spn_ShadowCoverageX "Coverage X" type:#float range:[0,100,1]
			spinner spn_ShadowCoverageY "Coverage Y" type:#float range:[0,100,1]
		)
		group "Edge Colour"
		(
			checkbox chk_UseEdgeColour "Use Edge Colour"
			colorpicker colpck_EdgeColour "Colour" alpha:true title:"Light Edge Colour"
		)
	)

)

fn IsCRLight obj =
(
	(custAttributes.get obj CRLightAttribute) != undefined

)
fn AddAttributesToLight obj =
(
	if (IsCRLight obj) == false then custattributes.add obj CRLightAttribute
)


struct CRLight
(
	Name,
	FolderName,
	LightType,	-- 0 = Point, 1 = Directional, 2 = Spot

	ColourR,
	ColourG,
	ColourB,
	Intensity,
	Range,
	Inner,
	Outer,
	NearClip,
	Flags,


	ShadowResX,
	ShadowResY,
	ShadowCoverageX,
	ShadowCoverageY,
	ShadowBias,
	ShadowIntensity,
	SplitCount,
	SplitDistribution,
	ShadowDistanceMin,
	ShadowDistanceMax,


	UseEdgeColour,
	EdgeColourR,
	EdgeColourG,
	EdgeColourB,
	EdgeColourA,

	GoboScaleX,
	GoboScaleY,
	GoboOffsetX,
	GoboOffsetY,
	GoboTexture,

	FlagCastShadow,
	FlagUsesGobo,
	FlagUnknown8,
	FlagUsePool,

	fn SplitFlags =
	(
		FlagCastShadow = CheckBitIsSet Flags 0
		FlagUsesGobo = CheckBitIsSet Flags 2
		FlagUnknown8 = CheckBitIsSet Flags 3
		FlagUsePool = CheckBitIsSet Flags 8
	),
	fn SetFlags =
	(
		Flags = 0
		if FlagCastShadow then Flags = Flags + 0x1
		if FlagUsesGobo then Flags = Flags + 0x4
		if FlagUnknown8 then Flags = Flags + 0x8
		if FlagUsePool then Flags = Flags + 0x100
	),

	fn LoadLight fileName =
	(
		f = fopen fileName "r"
		result = false
		FolderName = getFilenamePath filename
		Name = getFilenameFile filename
		header = readlong f
		if header != 3 then
		(
			fclose f
			format "% isn't a valid LIGHT file!\n" fileName
			
		)
		else 
		(

			LightType = readlong f #unsigned
			ColourR = readfloat f
			ColourG = readfloat f
			ColourB = readfloat f
			Intensity = readfloat f
			Range = readfloat f
			Inner = readfloat f
			Outer = readfloat f
			NearClip = readfloat f
			Flags = readlong f #unsigned

			ShadowResX = readlong f
			ShadowResY = readlong f
			ShadowCoverageX = readfloat f
			ShadowCoverageY = readfloat f
			ShadowBias = readfloat f
			ShadowIntensity = readfloat f
			SplitCount = readlong f #unsigned
			SplitDistribution = readfloat f
			ShadowDistanceMin = readfloat f
			ShadowDistanceMax = readfloat f

			UseEdgeColour = readlong f #unsigned
			EdgeColourR = readbyte f
			EdgeColourG = readbyte f
			EdgeColourB = readbyte f
			EdgeColourA = readbyte f

			GoboScaleX = readfloat f
			GoboScaleY = readfloat f
			GoboOffsetX = readfloat f
			GoboOffsetY = readfloat f

			--nameLength = readlong f #unsigned
			GoboTexture = readpaddedstring f

			fclose f
			SplitFlags()
			result = true
		)
		result
	),

	fn SaveLight fileName =
	(
		f = fopen filename "w"
		SetFlags()
		writelong f 3
		writelong f LightType
		writefloat f ColourR
		writefloat f ColourG
		writefloat f ColourB

		writefloat f Intensity
		writefloat f Range
		writefloat f Inner
		writefloat f Outer
		writefloat f NearClip
		writelong f Flags

		writelong f ShadowResX
		writelong f ShadowResY
		writefloat f ShadowCoverageX
		writefloat f ShadowCoverageY
		writefloat f ShadowBias
		writefloat f ShadowIntensity
		writelong f SplitCount
		writefloat f SplitDistribution
		writefloat f ShadowDistanceMin
		writefloat f ShadowDistanceMax
		
		writelong f UseEdgeColour
		writebyte f EdgeColourR
		writebyte f EdgeColourG
		writebyte f EdgeColourB
		writebyte f EdgeColourA

		writefloat f GoboScaleX
		writefloat f GoboScaleY
		writefloat f GoboOffsetX
		writefloat f GoboOffsetY
		--writelong f GoboTexture.count
		witepaddedstring f GoboTexture

		fclose f
	),

	fn SetToLight obj =
	(
		if (IsCRLight obj) == false 
			then AddAttributesToLight obj

		if LightType == 0 then
			obj.type = #omni
		else if LightType == 1 then
			obj.type = #freeDirect
		else if LightType == 2 then
			obj.type = #freeSpot

		obj.rgb = color (ColourR * 255) (ColourG * 255) (ColourB * 255) 255
		obj.multiplier = Intensity

		obj.useNearAtten = true
		obj.showNearAtten = true
		obj.nearAttenStart = NearClip
		obj.nearAttenEnd = NearClip

		obj.useFarAtten = true
		obj.showFarAtten = true
		obj.farAttenStart = Range
		obj.farAttenEnd = Range

		if obj.type==  #freespot then
		(
		obj.hotspot = Inner
		obj.falloff = Outer
		)
		if FlagCastShadow then
		(
			obj.castShadows = true
			obj.shadowGenerator = shadowMap()
			if ShadowResX > ShadowResY then
				obj.shadowGenerator.mapsize = ShadowResX
			else
				obj.shadowGenerator.mapsize = ShadowResY

			obj.shadowGenerator.mapbias = ShadowBias
			obj.shadowmultiplier = ShadowIntensity

			obj.CRLightCustomAttribute.ShadowSplitCount = SplitCount
			obj.CRLightCustomAttribute.ShadowSplitDistribution = SplitDistribution
			obj.CRLightCustomAttribute.ShadowDistanceMin = ShadowDistanceMin
			obj.CRLightCustomAttribute.ShadowDistanceMax = ShadowDistanceMin
			obj.CRLightCustomAttribute.ShadowCoverageX = ShadowCoverageX
			obj.CRLightCustomAttribute.ShadowCoverageY = ShadowCoverageY

		)
		else
		(
			obj.castShadows = false
		)

		obj.CRLightCustomAttribute.UseEdgeColour = UseEdgeColour == 1
		obj.CRLightCustomAttribute.EdgeColour = color EdgeColourR EdgeColourG EdgeColourB EdgeColourA

		if FlagUsesGobo then
		(
			obj.projector = true
			obj.projectormap = LoadCRTexture FolderName GoboTexture
			format "%\n" obj.projectormap
			obj.projectormap.coords.U_Tiling = GoboScaleX
			obj.projectormap.coords.V_Tiling = GoboScaleY
			obj.projectormap.coords.U_Offset = GoboOffsetX
			obj.projectormap.coords.V_Offset = GoboOffsetY
		)
		else
		(
			obj.projector = false
		)

		obj.CRLightCustomAttribute.UsePool = FlagUsePool
		obj.CRLightCustomAttribute.IsASunLight = FlagUnknown8
	),
	fn SetFromLight obj =
	(
		if obj.type == #freeDirect then 
			LightType = 1
		else if obj.type == #freeSpot then
			LightType = 2
		else
			LightType = 0

		ColourR = obj.rgb.r / 255
		ColourG = obj.rgb.g / 255
		ColourB = obj.rgb.b / 255

		Intensity = obj.multiplier
		NearClip = obj.nearAttenEnd
		Range = obj.farAttenEnd

		if LightType == 0 then
		(
			Inner = 22.5
			Outer = 45
		)
		else 
		(
			Inner = obj.hotspot
			Outer = obj.falloff
		)
		if obj.castShadows then
		(
			FlagCastShadow = true
			ShadowResX = obj.shadowGenerator.mapsize
			ShadowResY = obj.shadowGenerator.mapsize

			ShadowBias = obj.shadowGenerator.mapbias
			ShadowIntensity = obj.shadowMultiplier

			SplitCount = obj.CRLightCustomAttribute.ShadowSplitCount
			SplitDistribution = obj.CRLightCustomAttribute.ShadowSplitDistribution
			ShadowDistanceMin = obj.CRLightCustomAttribute.ShadowDistanceMin
			ShadowDistanceMax = obj.CRLightCustomAttribute.ShadowDistanceMax
			ShadowCoverageX = obj.CRLightCustomAttribute.ShadowCoverageX
			ShadowCoverageY = obj.CRLightCustomAttribute.ShadowCoverageY
		)
		else
		(
			FlagCastShadow = false
			ShadowResX = 0
			ShadowResY = 0
			ShadowBias = 0
			ShadowIntensity = 1
			ShadowCoverageX = 1
			ShadowCoverageY = 1
			SplitCount = 0
			SplitDistribution = 0
			ShadowDistanceMin = 0
			ShadowDistanceMax = 0
		)

		if obj.CRLightCustomAttribute.UseEdgeColour then
		(
			UseEdgeColour = 1
			EdgeColourR = obj.CRLightCustomAttribute.EdgeColour.r
			EdgeColourG = obj.CRLightCustomAttribute.EdgeColour.g
			EdgeColourB = obj.CRLightCustomAttribute.EdgeColour.b
			EdgeColourA = obj.CRLightCustomAttribute.EdgeColour.a
		)
		else
		(
			UseEdgeColour = 0
			EdgeColourR = 0
			EdgeColourG = 0
			EdgeColourB = 0
			EdgeColourA = 255
		)

		if obj.projector then
		(
			FlagUsesGobo = true
			GoboTexture = getFilenameFile obj.projectormap.filename
			GoboScaleX = obj.projectormap.coords.U_Tiling
			GoboScaleY = obj.projectormap.coords.V_Tiling
			GoboOffsetX = obj.projectormap.coords.U_Offset
			GoboOffsetV = obj.projectormap.coords.V_Offset
			if GoboScaleX == undefined then GoboScaleX = 1
			if GoboScaleY == undefined then GoboScaleY = 1
			if GoboOffsetX == undefined then GoboOffsetX =0
			if GoboOffsetY == undefined then GoboOffsetY = 0
		)
		else
		(
			FlagUsesGobo = false
			GoboTexture = ""
			GoboScaleX = 1
			GoboScaleY = 1
			GoboOffsetX = 0
			GoboOffsetY = 0
		)

		FlagUsePool = obj.CRLightCustomAttribute.UsePool
		FlagUnknown8 = obj.CRLightCustomAttribute.IsASunLight
	)
)

fn ConverToCRLightButton_Pressed sender arg =
(
	for obj in selection do
	(
		if classof obj == freeSpot or classof obj == omnilight or classof obj == Directionallight then
			AddAttributesToLight obj
	)
)