ActiveOctree = undefined
Diffuse1Aliases = #("DiffuseColour","Side1_DiffuseColour1")
Diffuse2Aliases = #("DiffuseColour2","Side1_DiffuseColour2")
Diffuse3Aliases = #("Side2_DiffuseColour")
NormalMap1Aliases = #("NormalMap","Normal_Map","Side1_Normal_Map1")
NormalMap2Aliases = #("Normal_Map2","Side1_Normal_Map2")
NormalMap3Aliases = #("Side2_Normal_Map")
SpecMap1Aliases = #("SpecMap","Spec_Map","Side1_Spec_Map1")
SpecMap2Aliases = #("Spec_Map2","Side1_Spec_Map2")
SpecMap3Aliases = #("Side2_Spec_Map")
struct MT2File (
	Name,
	basedOffOf,
	DiffuseName1,
	DiffuseName2,
	DiffuseName3,
	SpecularName1,
	SpecularName2,
	SpecularName3,
	NormalName1,
	NormalName2,
	NormalName3,
	DecalTexture,
	DecalSpecular,
	BlendMap,
	Foam,
	TexturePath,

	fn FindTexture textureName folder = (
		global CarmaSettings
		texmap = undefined
		--format "\n------------\n"
		if (doesFileExist (folder+textureName+".png")) then
		(
			--format "Texture is already converted: %\n" (folder+textureName+".png")
			texmap = folder+textureName+".png"
		)
		else if (doesFileExist (folder+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (folder+textureName+".tga")
			texmap = folder+textureName+".tga"
		)
		else if (doesFileExist (folder+"NON_VT\\"+textureName+".png")) then
		(
			--format "Texture is already converted: %\n" (folder+textureName+".png")
			texmap = folder+"NON_VT\\"+textureName+".png"
		)
		else if (doesFileExist (folder+"NON_VT\\"+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (folder+textureName+".tga")
			texmap = folder+"NON_VT\\"+textureName+".tga"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
			texmap = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".png"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tga")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
			texmap = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tga"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
			texmap = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".png"
		)
		else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tga")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
			texmap = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tga"
		)
		else if (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".png")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.TexturePath+"\\"+textureName+".png")
			texmap = CarmaSettings.TexturePath+"\\"+textureName+".png"
		)
		else if (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (CarmaSettings.TexturePath+"\\"+textureName+".tga")
			texmap = CarmaSettings.TexturePath+"\\"+textureName+".tga"
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
			
			--format "Looking for %.tdx in \"%\" or in \"%\"\n" texturename folder (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\")
			--format "TDXFilename: %\n" TDXFilename
			
			if TDXFilename != undefined do
			(
				
				--HiddenDOSCommand (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") prompt:("Loading Texture: "+TDXFilename)
				--format "Command For Converting Texture: %\n from start path: %" (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") startPath
				
				--if CarmaSettings.TexturePath != "" then (dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX").Convert TDXFilename CarmaSettings.TexturePath
				ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
				ConvertTDX.Convert TDXFilename CarmaSettings.TexturePath false 5 CarmaSettings.MaxResolution
				--format "TDX result is %\n" tdxresult
				texmap = CarmaSettings.TexturePath+"\\"+textureName+".png"
			)
		)
		 texmap
	),
	fn LoadMT2 materialName = (


		global globalMaterialNames
		global globalMaterials
		texmap = undefined
		--format "Checking if material \"%\" exists: result = % importTextures =\n" (folder+materialName+".MT2") (((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))  as string) (importTextures as string)
		
		global CarmaSettings
		Name = materialName
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
			basedOffOf = (basedOffTag.Attributes.GetNamedItem "Name").Value
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
		)
	)
)

struct MDLLoader (
	fn readCNTheader f =
	(
		readbyte f #unsigned
		readbyte f #unsigned
		readbyte f #unsigned
		readbyte f #unsigned
	),
	fn LoadCRTexture folder texturename =
	(
		global CarmaSettings
		texmap = undefined
			--format "\n------------\n"
			if (doesFileExist (folder+textureName+".png")) then
			(
				--format "Texture is already converted: %\n" (folder+textureName+".png")
				texmap = bitmaptexture()
				texmap.filename = folder+textureName+".png"
			)
			else if (doesFileExist (folder+textureName+".tga")) then
			(
				--format "Texture is already converted: %\n"  (folder+textureName+".tga")
				texmap = bitmaptexture()
				texmap.filename = folder+textureName+".tga"
			)
			else if (doesFileExist (folder+"NON_VT\\"+textureName+".png")) then
			(
				--format "Texture is already converted: %\n" (folder+textureName+".png")
				texmap = bitmaptexture()
				texmap.filename = folder+"NON_VT\\"+textureName+".png"
			)
			else if (doesFileExist (folder+"NON_VT\\"+textureName+".tga")) then
			(
				--format "Texture is already converted: %\n"  (folder+textureName+".tga")
				texmap = bitmaptexture()
				texmap.filename = folder+"NON_VT\\"+textureName+".tga"
			)
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".png")) then
			(
				--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
				texmap = bitmaptexture()
				texmap.filename = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".png"
			)
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tga")) then
			(
				--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
				texmap = bitmaptexture()
				texmap.filename = CarmaSettings.DataCorePath+"\\Content\\Textures\\"+texturename+".tga"
			)
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".png")) then
			(
				--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
				texmap = bitmaptexture()
				texmap.filename = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".png"
			)
			else if (doesFileExist (CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tga")) then
			(
				--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
				texmap = bitmaptexture()
				texmap.filename = CarmaSettings.DataCorePath+"\\Content\\Textures\\NON_VT\\"+texturename+".tga"
			)
			else if (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".png")) then
			(
				--format "Texture is already converted: %\n" (CarmaSettings.TexturePath+"\\"+textureName+".png")
				texmap = bitmaptexture()
				texmap.filename = CarmaSettings.TexturePath+"\\"+textureName+".png"
			)
			else if (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".tga")) then
			(
				--format "Texture is already converted: %\n"  (CarmaSettings.TexturePath+"\\"+textureName+".tga")
				texmap = bitmaptexture()
				texmap.filename = CarmaSettings.TexturePath+"\\"+textureName+".tga"
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
				
				--format "Looking for %.tdx in \"%\" or in \"%\"\n" texturename folder (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\")
				--format "TDXFilename: %\n" TDXFilename
				
				if TDXFilename != undefined do
				(
					
					--HiddenDOSCommand (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") prompt:("Loading Texture: "+TDXFilename)
					--format "Command For Converting Texture: %\n from start path: %" (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") startPath
					
					--if CarmaSettings.TexturePath != "" then (dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX").Convert TDXFilename CarmaSettings.TexturePath
					ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
					ConvertTDX.Convert TDXFilename CarmaSettings.TexturePath false 5 CarmaSettings.MaxResolution
					--format "TDX result is %\n" tdxresult
					texmap = bitmaptexture()
					texmap.filename = CarmaSettings.TexturePath+"\\"+textureName+".png"
				)
			)
		 texmap
	),
	fn GetMDLTexture folder materialName importTextures:false =
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
			basedOffOf = (basedOffTag.Attributes.GetNamedItem "Name").Value
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
	),
	fn LoadMaterial materialName importTextures:false mergeMDLs:false =
	(

		global globalMaterialNames
		global globalMaterials
		global merge_MatsIDsToNames
		global merge_SubMat
		if(finditem globalMaterialNames materialName) > 0 then
		(
				--format "Material is in array at position %\n" (finditem globalMaterialNames materialName)
			meshMaterial = globalMaterials[(finditem globalMaterialNames materialName)]
			
		)
		else
		(
			--format "Material is not already loaded\n"
		)
		if meshMaterial == undefined do
		(
			append globalMaterialNames materialName
			meshMaterial = StandardMaterial()
			meshMaterial.shaderType = 1
			--format "\nAbout To Call GetMDLTexture for %\n" materialName
			meshMaterial.diffuseMap = GetMDLTexture (getFilenamePath filename) materialName importTextures:importTextures
			
			
			if  ((dotnetclass "System.IO.File").exists ((getFilenamePath filename)+materialName+".MTL")) then
			(
				local mtlMat = MTLFile()
				mtlMat.load ( (getFilenamePath filename)+materialname+".mtl")
				mtlmat.ApplyToMaterial meshMaterial
			)
			--format "Just Called GetMDLTexture for \n\n" materialName
			meshMaterial.name = materialName
			showtexturemap meshMaterial meshMaterial.diffuseMap true
				append globalMaterials meshMaterial
		)
		if mergeMDLs == true then
		(
			matExistsInMerged = finditem merge_MatsIDsToNames materialName
			if matExistsInMerged == 0 then
			(
				if merge_SubMat.material.count == 1 and merge_SubMat.material[1].name=="##DELETEME##" then
				(
					merge_SubMat.material[merge_SubMat.material.count] = globalMaterials[(finditem globalMaterialNames materialName)]
				)
				else
				(
					merge_SubMat.material[merge_SubMat.material.count+1] = globalMaterials[(finditem globalMaterialNames materialName)]
				)
				meshMaterial = merge_SubMat
				merge_MatsIDsToNames[merge_SubMat.material.count] = materialName
				merge_OldMatIDsToNew[1] = merge_SubMat.material.count
			)
			else 
			(
				merge_OldMatIDsToNew[1] = matExistsInMerged
			)
		)

		meshMaterial
	)
	fn ImportMDL filename importTextures:false forcePREP:false useUniqueVerts:true useTriStrips:false mergeMDLs:false mergeSplits: true origin:[0,0,0] SpawnOctree:false =
	(
		f = fopen filename "r"

		stopwatch = dotNetObject "system.diagnostics.stopwatch"
		frequency = stopwatch.frequency
		nanosecspertick = (1000 * 1000 * 1000) / frequency
		stopwatch.start()
		
		magic1 = readbyte f #unsigned
		magic2 = readbyte f #unsigned
		mdlMinorVersion = readbyte f #unsigned
		mdlMajorVersion = readbyte f #unsigned
		version61orless=false
		version63orhigher=false
		if mdlMinorVersion < 2 or mdlMajorVersion < 6 then version61orless=true
		if mdlMinorVersion > 2 or mdlMajorVersion > 6 then version63orhigher=true
		
		checksum = readlong f #unsigned
		flags = readlong f #unsigned
		--printFlagBits flags 32 "MDL Flags"
		
		prepSize = readlong f #unsigned
		
		firstFaceCount = readlong f #unsigned
		uniqueVertexCount = readlong f #unsigned
		
		fileSize = readlong f #unsigned
		if filesize == 0 then forcePREP = false
		if version63orhigher == false or filesize > 0 then
		(
			boundingSphereRadius = readfloat f
			bboxMinX = readfloat f
			bboxMinY = readfloat f
			bboxMinZ = readfloat f
			bboxMaxX = readfloat f
			bboxMaxY = readfloat f
			bboxMaxZ = readfloat f
			bboxCenterX = readfloat f
			bboxCenterY = readfloat f
			bboxCenterZ = readfloat f
		)
		
		materialCount = readshort f #unsigned
		meshMaterial = undefined
		global globalMaterialNames
		global globalMaterials
		global merge_MatsIDsToNames
		global merge_SubMat
		if merge_SubMat == undefined then merge_SubMat = multisubmaterial()
		if globalMaterialNames==undefined do globalMaterialNames = #()
		if globalMaterials==undefined do globalMaterials = #()
		materialNames = #()
		merge_OldMatIDsToNew = #()

		if(materialCount == 1) then
		(
			materialName = readpaddedstring f version61OrLess:version61orless
			append materialNames materialName
				--format "Checking if material #% \"%\" already has been loaded\n" i materialName
			meshMaterial = LoadMaterial materialName importTextures:importTextures
		)
		else 
		(
			meshMaterial = multimaterial numsubs:materialCount
			for i=1 to materialCount do
			(
				materialName = readpaddedstring f version61OrLess:version61orless
				--format "matid: % matname: %\n" i materialName
				append materialNames materialName
				--format "Checking if material #% \"%\" already has been loaded\n" i materialName
				subMat = undefined
				if(finditem globalMaterialNames materialName) != 0 then
				(
					--format "Material is in array at position %\n" (finditem globalMaterialNames materialName)
					subMat = globalMaterials[(finditem globalMaterialNames materialName)]
				)
				else
				(
					--format "Material is not already loaded\n"
				)
				if subMat == undefined do
				(
					--format "Trying to load the material and texture!\n"
					append globalMaterialNames materialName
					subMat = StandardMaterial()
					subMat.shaderType = 1
					if materialName == "pup_outline" then
					(
						subMat.opacity = 5
					)
					
					--format "\nAbout To Call GetMDLTexture for %\n" materialName
					subMat.diffuseMap = GetMDLTexture (getFilenamePath filename) materialName importTextures:importTextures
					--format "Just Called GetMDLTexture for \n\n" materialName
					subMat.name = materialName
					showtexturemap subMat subMat.diffuseMap true
					
					
					if  ((dotnetclass "System.IO.File").exists ((getFilenamePath filename)+materialName+".MTL")) then
					(
						local mtlMat = MTLFile()
						mtlMat.load ( (getFilenamePath filename)+materialname+".mtl")
						mtlmat.ApplyToMaterial subMat
					)
					append globalMaterials subMat
				)
				
				meshMaterial[i] = subMat
				if mergeMDLs == true then
				(
					matExistsInMerged = finditem merge_MatsIDsToNames materialName
					if matExistsInMerged == 0 then
					(
						if merge_SubMat.material.count == 1 and merge_SubMat.material[1].name=="##DELETEME##" then
						(
							merge_SubMat.material[merge_SubMat.material.count] = subMat
						)
						else
						(
							merge_SubMat.material[merge_SubMat.material.count+1] = subMat
						)
						
						
						merge_MatsIDsToNames[merge_SubMat.material.count] = materialName
						merge_OldMatIDsToNew[i] = merge_SubMat.material.count
					)
					else 
					(
						merge_OldMatIDsToNew[i] = matExistsInMerged
					)
				)
			)
			if mergeMDLs == true then
			(
				meshMaterial = merge_SubMat
			)
		)

		timeForMaterials = stopwatch.ElapsedMilliseconds
		nanosecsForMaterials = stopwatch.ElapsedTicks * nanosecspertick
		totalMiliseconds = stopwatch.ElapsedMilliseconds
		totalNanoseconds = stopwatch.ElapsedTicks * nanosecspertick

		format "Materials parsed in % milliseconds (% nanoseconds)" timeForMaterials nanosecsForMaterials
	)
)