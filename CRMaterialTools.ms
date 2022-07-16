CMDMaterialLibrary = #()
fn LoadCRTexture folder texturename type:"bitmap" =
(
	global CarmaSettings
	texmap = undefined
	foundFileName = undefined
		--format "\n------------\n"
		if (doesFileExist (folder+textureName+".png")) then
		(
			--format "Texture is already converted: %\n" (folder+textureName+".png")
			
			foundFileName = folder+textureName+".png"
		)
		else if (doesFileExist (folder+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (folder+textureName+".tga")
			
			foundFileName = folder+textureName+".tga"
		)
		else if (doesFileExist (folder+"NON_VT\\"+textureName+".png")) then
		(
			--format "Texture is already converted: %\n" (folder+textureName+".png")
			
			foundFileName = folder+"NON_VT\\"+textureName+".png"
		)
		else if (doesFileExist (folder+"NON_VT\\"+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (folder+textureName+".tga")
			
			foundFileName = folder+"NON_VT\\"+textureName+".tga"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
			
			foundFileName = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".png"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tga")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
			
			foundFileName = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tga"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
			
			foundFileName = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".png"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tga")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
			
			foundFileName = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tga"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\particle\\"+texturename+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
			
			foundFileName = CarmaSettings.DataCorePath+"\\Content\\Textures\\particle\\"+texturename+".png"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\particle\\"+texturename+".tga")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
			
			foundFileName = CarmaSettings.DataCorePath+"\\Content\\Textures\\particle\\"+texturename+".tga"
		)
		else if CarmaSettings.ConvertTexturesInPlace==false and (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.TexturePath+"\\"+textureName+".png")
			
			foundFileName = CarmaSettings.TexturePath+"\\"+textureName+".png"
		)
		else if  CarmaSettings.ConvertTexturesInPlace==false and (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (CarmaSettings.TexturePath+"\\"+textureName+".tga")
			
			foundFileName = CarmaSettings.TexturePath+"\\"+textureName+".tga"
		)
		else 
		(
			--format "Texture needs convertng!\n"
			startPath = CarmaSettings.TexturePath
			if startPath == "" then startPath = folder
			TDXFilename = undefined
			if (doesFileExist (folder+texturename+".tdx")) then TDXFilename = folder+texturename+".tdx"
			else if (doesFileExist (folder+"NON_VT\\"+texturename+".tdx")) then TDXFilename = folder+"NON_VT\\"+texturename+".tdx"
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tdx")) then TDXFilename = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tdx"
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tdx")) then TDXFilename = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tdx"
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\particle\\"+texturename+".tdx")) then TDXFilename = CarmaSettings.DataCorePath+"\\Content\\Textures\\particle\\"+texturename+".tdx"
			
			--format "Looking for %.tdx in \"%\" or in \"%\"\n" texturename folder (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\")
			--format "TDXFilename: %\n" TDXFilename
			
			if TDXFilename != undefined then
			(
				
				--HiddenDOSCommand (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") prompt:("Loading Texture: "+TDXFilename)
				--format "Command For Converting Texture: %\n from start path: %" (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") startPath
				convesionPath =  CarmaSettings.TexturePath
				if CarmaSettings.ConvertTexturesInPlace then (
					format "Converting texture in place!\n"
					convesionPath = getFilenamePath TDXFilename
				)
				--if CarmaSettings.TexturePath != "" then (dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX").Convert TDXFilename CarmaSettings.TexturePath
				--ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
				--ConvertTDX.Convert TDXFilename convesionPath false 5 CarmaSettings.MaxResolution
				TDXClass = dotNetClass "ToxicRagers.Stainless.Formats.TDX"
				TDXFile = TDXClass.Load TDXFilename
				texBitmp = TDXFile.GetBitmap 0
				texBitmp.Save (convesionPath+"\\"+textureName+".png")
				--format "TDX result is %\n" tdxresult
				
				foundFileName = convesionPath+"\\"+textureName+".png"
			)
			else (
				vtUtils = dotNetObject  "ToxicRagers.CarmageddonReincarnation.VirtualTextures.vtUtils" CarmaSettings.GamePath
				
				foundFileName = vtUtils.ExtractTexture texturename
				if foundFileName == "" then (
					format "ERROR: Texture % doesn't exist in any VT!" texturename
					foundFileName = undefined
				)
			)
		)
		if foundFileName != undefined then (
			texmap = bitmaptexture()
			
			texmap.filename = foundFileName
			if type == "normal" then (
				normBumb = Normal_Bump()
				normBumb.normal_map =texmap
				texmap = normBumb
			)
		)
		else (
			texmap = checker()
			texmap.coords.U_Tiling =10
			texmap.coords.V_Tiling =10
		)
	 texmap
)

MT2BaseMaterialOpacityType = #("Constant","DiffuseAlphaClip","NormalAlpha", "VertexAlpha", "Additive")
MT2BaseMaterialColourType = #("Texture","Vertex", "Material", "None")
struct MT2BaseMaterial (
	Name,
	DiffuseColourType,
	DiffuseAlias,
	NormalColourType,
	NormalAlias,
	SpecularColourType,
	SpecularAlias,
	OpacityFrom,
	OpacityClip
)

MT2BaseMaterials = #(
	(MT2BaseMaterial name:"car_shader_double_sided_base" DiffuseColourType:"Texture" DiffuseAlias:"Side1_DiffuseColour2" NormalColourType:"Texture" NormalAlias:"Side1_Normal_Map2" SpecularColourType:"Texture" SpecularAlias:"Side1_Spec_Map2" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"car_shader_base" DiffuseColourType:"Texture" DiffuseAlias:"Decals" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"DecalsSpec" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"car_shader_glass" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"car_translucent_body_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"glass_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"glow_simple_norm_spec_env_base_A" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"glow_simple_norm_spec_env_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"ped_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"ped_simple_decal_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"ped_decal_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"repulse_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"simple_1bit_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"None" SpecularColourType:"None"  OpacityFrom:"DiffuseAlphaClip" OpacityClip:0.66),
	(MT2BaseMaterial name:"simple_additive_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"None" SpecularColourType:"None" OpacityFrom:"Additive"),
	(MT2BaseMaterial name:"simple_anim_foliage" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"DiffuseAlphaClip" OpacityClip:0.66),
	(MT2BaseMaterial name:"simple_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"simple_norm_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"simple_norm_detail_spec_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"simple_norm_spec_1bit_env_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"DiffuseAlphaClip" OpacityClip:0.66),
	(MT2BaseMaterial name:"simple_norm_spec_env_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"vertex_norm_spec_env_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"simple_norm_spec_env_base_A" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"simple_norm_spec_env_blend_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"simple_spec_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"skybox_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"None" SpecularColourType:"None" OpacityFrom:"DiffuseAlpha"),
	(MT2BaseMaterial name:"unlit_1bit_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"NormalMap" SpecularColourType:"Texture" SpecularAlias:"SpecMap" OpacityFrom:"DiffuseAlphaClip" OpacityClip:0.66),
	(MT2BaseMaterial name:"unlit_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"None" NormalAlias:"" SpecularColourType:"None" SpecularAlias:"" OpacityFrom:"Constant"),
	(MT2BaseMaterial name:"water_base" DiffuseColourType:"Texture" DiffuseAlias:"DiffuseColour" NormalColourType:"Texture" NormalAlias:"Normal_Map" SpecularColourType:"Texture" SpecularAlias:"Spec_Map" OpacityFrom:"DiffuseAlpha")
)
fn CheckMT2Exists folder materialName = (

	local materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))
	if materialExists ==	false then (
		folder = CarmaSettings.DataCorePath+"\\Content\\Textures\\"
	)
	materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2")) 

	materialExists
)
fn GetMT2Texture folder materialName importTextures:false =
(
	texmap = undefined
	--format "Checking if material \"%\" exists: result = % importTextures =\n" (folder+materialName+".MT2") (((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))  as string) (importTextures as string)
	
	global CarmaSettings
	materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))
	if materialExists ==	false then (
		folder = CarmaSettings.DataCorePath+"\\Content\\Textures\\"
	)
	if importTextures and ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2")) then
	(
		--format "Material \"%\" exists!\n" (folder+materialName+".MT2")
		if (dotnetclass "system.xml.xmldocument") == undefined then
			dotNet.loadAssembly "system.xml"
		xmlDoc=dotNetObject "system.xml.xmlDocument"
		--clearListener()
		--format "Properties\n"
		--showProperties xmlDoc
		--format "\nMethods\n"
		--showMethods xmlDoc
		xmlDoc.load (folder+materialName+".MT2")
		if (xmlDoc.HasChildNodes)==false then xmlDoc.load (folder+materialName+".mt2")

		basedOffTag = (xmlDoc.GetElementsByTagName "BasedOffOf").item 0
		if basedOffTag != undefined then
		(
			basedOffOf = (basedOffTag.Attributes.GetNamedItem "Name").Value
		)
		textureTags = xmlDoc.GetElementsByTagName "Texture"
		
		--clearListener()
		--format "Properties\n"
		--showProperties textureTags
		--format "\nMethods\n"
		--showMethods textureTags
		textureName = undefined
		--format "\n------------\n"

		for i=1 to textureTags.count do
		(
			textureItem = textureTags.item (i-1)
			textureAlias = (textureItem.Attributes.GetNamedItem "Alias").Value
			--format "Texture Tag #%: Alias = \"%\" Filename = \"%\"\n" i textureAlias (textureItem.Attributes.GetNamedItem "FileName").Value
			if textureAlias == "DiffuseColour" or textureAlias == "Side1_DiffuseColour"  or textureAlias == "Side1_DiffuseColour2" or textureAlias == "Decals" then
			(
				textureName = (textureItem.Attributes.GetNamedItem "FileName").Value
				--format "Found diffuse texture %!\n" textureName
			)
		)
		if textureName != undefined then
		(
		texmap = LoadCRTexture folder textureName
		)
		--matFile = openfile folder+materialName+".MT2" "r"
		
		if texmap==undefined do
		(
			--format "texmap undefined for \"%\" in material %, using checker!\n" (folder+textureName+".tdx") materialName
		)
	)
	if texmap==undefined do
	(
		--format "texmap undefined for \"%\" in %, using checker!\n" materialName folder
		texmap = checker()
		texmap.coords.U_Tiling =10
		texmap.coords.V_Tiling =10
	)
	 texmap
)

fn GetMaterialFromMT2 folder materialName importTextures:false = (
	global CMDMaterialLibrary
	global MT2BaseMaterials
	global CarmaSettings
	mat = undefined
	for existingMat in CMDMaterialLibrary where existingMat.name == materialName do (
		mat = existingMat
	)

	if mat == undefined then (
		mat = Standardmaterial name:materialName twoSided:true diffuse:(color 0 0 0)
		append CMDMaterialLibrary mat
		materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))
		if materialExists ==	false then (
			folder = CarmaSettings.DataCorePath+"\\Content\\Textures\\"
		)
		if ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2")) then
		(
			--format "Material \"%\" exists!\n" (folder+materialName+".MT2")
			if (dotnetclass "system.xml.xmldocument") == undefined then
				dotNet.loadAssembly "system.xml"
			xmlDoc=dotNetObject "system.xml.xmlDocument"
			--clearListener()
			--format "Properties\n"
			--showProperties xmlDoc
			--format "\nMethods\n"
			--showMethods xmlDoc
			xmlDoc.load (folder+materialName+".MT2")
			if (xmlDoc.HasChildNodes)==false then xmlDoc.load (folder+materialName+".mt2")

			basedOffTag = (xmlDoc.GetElementsByTagName "BasedOffOf").item 0
			basedOffOf = "simple_base"
			if basedOffTag != undefined then
			(
				basedOffOf = (basedOffTag.Attributes.GetNamedItem "Name").Value
			)
			baseMat = undefined
			for bm in MT2BaseMaterials do (
				if (tolower bm.name) == (tolower basedOffOf) then baseMat = bm
			)

			textureTags = xmlDoc.GetElementsByTagName "Texture"
			
			--clearListener()
			--format "Properties\n"
			--showProperties textureTags
			--format "\nMethods\n"
			--showMethods textureTags
			textureName = undefined
			--format "\n------------\n"

			diffuseTextureName = undefined
			normalTextureName = undefined
			specularTextureName = undefined

			for i=1 to textureTags.count do
			(
				textureItem = textureTags.item (i-1)
				textureAlias = (textureItem.Attributes.GetNamedItem "Alias").Value
				--format "Texture Tag #%: Alias = \"%\" Filename = \"%\"\n" i textureAlias (textureItem.Attributes.GetNamedItem "FileName").Value
				if baseMat.DiffuseColourType == "Texture" and textureAlias == baseMat.DiffuseAlias then
				(
					diffuseTextureName = (textureItem.Attributes.GetNamedItem "FileName").Value
					--format "Found diffuse texture %!\n" textureName
				)
				else if baseMat.NormalColourType == "Texture" and textureAlias == baseMat.NormalAlias then
				(
					normalTextureName = (textureItem.Attributes.GetNamedItem "FileName").Value
					--format "Found diffuse texture %!\n" textureName
				)
				else if baseMat.SpecularColourType == "Texture" and textureAlias == baseMat.SpecularAlias then
				(
					specularTextureName = (textureItem.Attributes.GetNamedItem "FileName").Value
					--format "Found diffuse texture %!\n" textureName
				)
			)
			if diffuseTextureName != undefined then
			(
				mat.diffuseMap = LoadCRTexture folder diffuseTextureName
				--showtexturemap mat mat.diffuseMap on
				if baseMat.OpacityFrom=="DiffuseAlpha" or baseMat.OpacityFrom=="DiffuseAlphaClip" then (
					mat.opacityMap = LoadCRTexture folder diffuseTextureName
					mat.opacityMap.monooutput = 1
					--showtexturemap mat mat.opacityMap on
				)
			)
			if normalTextureName != undefined then
			(
				mat.bumpMap = LoadCRTexture folder normalTextureName type:"normal"
				--showtexturemap mat mat.bumpMap on
			)
			if specularTextureName != undefined then
			(
				mat.specularMap = LoadCRTexture folder specularTextureName
				--showtexturemap mat mat.specularMap on
			)
			--matFile = openfile folder+materialName+".MT2" "r"
			showtexturemap mat on
			if texmap==undefined do
			(
				--format "texmap undefined for \"%\" in material %, using checker!\n" (folder+textureName+".tdx") materialName
			)
		)
	)
	mat
)

fn LoadIImgTextture folder textureName = (
	local foundFileName = undefined

	if (doesFileExist (folder+textureName+".png")) then
	(
		foundFileName = folder+textureName+".png"
	)
	else if (doesFileExist (folder+textureName+".tga")) then
	(
		foundFileName = folder+textureName+".tga"
	)
	else if (doesFileExist (CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"+textureName+".png")) then
	(
		foundFileName = CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"+textureName+".png"
	)
	else if (doesFileExist (CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"+textureName+".tga")) then
	(
		foundFileName = CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"+textureName+".tga"
	)
	else if (doesFileExist (CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".png")) then
	(
		foundFileName = CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".png"
	)
	else if (doesFileExist (CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".tga")) then
	(
		foundFileName = CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".tga"
	)
	else if (doesFileExist (folder+textureName+".img")) then
	(

		ConvertIMG = dotnetclass "IMGToolLib.IMGTool"
		ConvertIMG.ConvertFromIMG (folder+textureName+".img") (CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".tga") (dotnetclass "ToxicRagers.Stainless.Formats.CompressionMethod").None
		foundFileName = CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".tga"
	)
	else if (doesFileExist (CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"+textureName+".img")) then
	(
		
		ConvertIMG = dotnetclass "IMGToolLib.IMGTool"
		ConvertIMG.ConvertFromIMG (CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"+textureName+".img") (CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".tga")  (dotnetclass "ToxicRagers.Stainless.Formats.CompressionMethod").None
		foundFileName = CarmaSettings.TexturePath+"FunsizeTextures\\"+textureName+".tga"
	)
	if foundFileName != undefined then (
		texmap = bitmaptexture()
		
		texmap.filename = foundFileName
		
	)
	else (
		texmap = checker()
		texmap.coords.U_Tiling =10
		texmap.coords.V_Tiling =10
	)
	texmap

)

fn CheckMTLExists folder materialName = (

	local materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MTL"))
	if materialExists ==	false then (
		folder = CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"
	)
	materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MTL"))

	materialExists
)
fn GetMaterialFromMTL folder materialName importTextures:false = (
		mat = undefined
	for existingMat in CMDMaterialLibrary where existingMat.name == materialName do (
		mat = existingMat
	)
	local originalFolder = folder
	if mat == undefined then (
		mat = Standardmaterial name:materialName twoSided:true diffuse:(color 0 0 0)
		append CMDMaterialLibrary mat
		materialExists = ((dotnetclass "System.IO.File").exists (folder+materialName+".MTL"))
		if materialExists ==	false then (
			folder = CarmaSettings.FunsizeSettings.DataFolder+"Data\\Content\\Textures\\"
		)
		if ((dotnetclass "System.IO.File").exists (folder+materialName+".MTL")) then
		(
			local mtlMat = MTLFile()
			mtlMat.load ( folder+materialname+".mtl")
			mtlmat.ApplyToMaterial mat
			local diffuseName = undefined
			for matLayer in mtlMat.Layers where matLayer.BlendMode == 0 and diffuseName == undefined do (
				diffuseName = matLayer.MapName

			)
			if diffuseName == undefined and mtlMat.Layers.Count > 0 then (
				diffuseName = mtlMat.Layers[1].mapname
			)
			if diffuseName != undefined then (
				mat.diffuseMap = LoadIImgTextture originalFolder diffuseName
				--showtexturemap mat mat.diffuseMap on
				bmp =  (openbitmap (mat.diffuseMap.filename))
				if bmp != undefined and bmp.hasAlpha then (
					mat.opacityMap = LoadIImgTextture originalFolder diffuseName
					mat.opacityMap.monooutput = 1
				)
		
			)
		)
	)
	mat
)
