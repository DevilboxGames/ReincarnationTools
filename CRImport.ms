fn readCNTheader f =
(
	readbyte f #unsigned
	readbyte f #unsigned
	readbyte f #unsigned
	readbyte f #unsigned
)
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
	return texmap
)
fn GetMDLTexture folder materialName importTextures:false =
(
	texmap = undefined
	--format "Checking if material \"%\" exists: result = % importTextures =\n" (folder+materialName+".MT2") (((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))  as string) (importTextures as string)
	
	global CarmaSettings
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
		if textureName == undefined then
		(
			
		texmap = checker()
		texmap.coords.U_Tiling =10
		texmap.coords.V_Tiling =10
			return texmap
		)
		texmap = LoadCRTexture folder textureName
		--matFile = openfile folder+materialName+".MT2" "r"
		
		if texmap==undefined do
		(
			format "texmap undefined for \"%\" in material %, using checker!\n" (folder+textureName+".tdx") materialName
		)
	)
	if texmap==undefined do
	(
		format "texmap undefined for \"%\" in %, using checker!\n" materialName folder
		texmap = checker()
		texmap.coords.U_Tiling =10
		texmap.coords.V_Tiling =10
	)
	return texmap
)
fn BlankUnknownSkinData fileName =
(
	backupFileName = (getFilenamePath fileName)
	--format "%\n" backupFileName
	backupFileName = backupFileName+(getFilenameFile fileName)
	--format "%\n" backupFileName
	backupFileName = backupFileName+"_backup"+(getFilenameType fileName)
	--format "%\n" backupFileName
	--format "Renaming \"%\" to \n\"%\"\n" fileName backupFileName
	renameFile fileName backupFileName
	
	f = fopen backupFileName "rb"
	fw = fopen fileName "wb"
	magic1 = readbyte f #unsigned
	writebyte fw magic1
	
	magic2 = readbyte f #unsigned
	writebyte fw magic2
	mdlMinorVersion = readbyte f #unsigned
	writebyte fw mdlMinorVersion
	mdlMajorVersion = readbyte f #unsigned
	writebyte fw mdlMajorVersion
	
	version61orless=false
	if mdlMinorVersion < 2 or mdlMajorVersion < 6 then version61orless=true
	for i=1 to 64 do
	(
		b = readbyte f
		writebyte fw b
	)
		
	materialCount = readshort f #unsigned
	writeshort fw materialCount #unsigned
	meshMaterial = undefined
	
	for i=1 to materialCount do
	(
		materialName = readpaddedstring f version61OrLess:version61orless
		witepaddedstring fw materialName
	)
	PREPfaceCount = readlong f #unsigned
	writelong fw PREPfaceCount #unsigned
	for i=1 to (16 * PREPfaceCount) do
	(
		b = readbyte f
		writebyte fw b
	)
	

	PREPvertcount = readlong f #unsigned
	writelong fw PREPvertcount #unsigned
	for i=1 to (44 * PREPvertcount) do
	(
		b = readbyte f
		writebyte fw b
	)
	
	matGroupCount = readshort f #unsigned
	writeshort fw matGroupCount #unsigned
	for i = 1 to matGroupCount do
	(
		for j = 1 to 48 do
		(
			b = readbyte f
			writebyte fw b
		)
		--fseek f 48 #seek_cur
		
		triStripLength = readlong f #unsigned
		writelong fw triStripLength
		
		for j = 1 to ((triStripLength * 4)+8) do
		(
			b = readbyte f
			writebyte fw b
		)
		--fseek f ((triStripLength * 4)+8) #seek_cur
		
		patchListLength = readlong f #unsigned
		writelong fw patchListLength
		--fseek f (patchListLength * 4) #seek_cur
		for j = 1 to (patchListLength * 4) do
		(
			b = readbyte f
			writebyte fw b
		)
		
	)
	prepSkinDataSet = true
	if prepSkinDataSet then
	(
		--format "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nOMG PANIC! THIS MDL HAS PREP SKIN DATA AND I DON'T KNOW WHAT TO DO WITH IT!!! At Position: %\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n" (ftell f)
		--format "Num Verts: %\nNum Faces: %\n" PREPvertcount PREPfacecount
		numBones = readshort f #unsigned
		unknown1 = readshort f #unsigned
		unknown2 = readshort f #unsigned
		writeshort fw numBones #unsigned
		writeshort fw unknown1 #unsigned
		writeshort fw unknown2 #unsigned
		--format "Unknown1 = %\nUnknown2 = %\n" unknown1 unknown2
		--skinMod = skin()
		--addmodifier m skinMod
		boneNames = #()
		for i=1 to numBones do
		(
			bname = readstring f
			writestring fw bname
		)
		--PrintArrayInFull boneNames "boneNames"
		
		boneInfo = #()
		for i = 1 to numbones do
		(
			for x=1 to 39 do
			(
				b = readbyte f
				writebyte fw b
			)
		)
		listOfBones = #()
		--select m
		--max modify mode
		--modPanel.setCurrentObject skinMod
		for i=1 to numbones do
		(
			for x=1 to 32 do
			(
				b = readbyte f
				writebyte fw b
			)
		)
		
		
		for i = 1 to PREPvertcount do
		(
			s = readshort f #unsigned
			writeshort fw s #unsigned
			s = readbyte f
			s = readbyte f
			writebyte fw 0 #unsigned
			writebyte fw 0 #unsigned
			s = readlong f #unsigned
			writelong fw s #unsigned
			
			--format "%: %     % - %     %\n" i weightCount unknown unknown2 weightIndex
		)
		pos = ftell f
		fseek f 0 #seek_end
		end = ftell f
		fseek f pos #seek_set
		for i=1 to (end - pos) do
		(
			b = readbyte f
			writebyte fw b
		)
	
	)
	fclose f
	fclose fw
)
fn ImportMDL_TR filenames importTextures:false forcePREP:false useUniqueVerts:true useTriStrips:false mergeMDLs:false mergeSplits: true origin:[0,0,0]=
(
	MaxMDLProcessor = dotNetObject "ToxicRagers.MaxTools.MaxMDLProcessor"
	loadedMDLs = MaxMDLProcessor.LoadMDLs filenames

	for mdl in loadedMDLs do
	(
		local m = trimesh()
		setNumVerts m mdl.PREPVertexCount
		setNumTVerts m (mdl.prepFaceCount*3)
		setNumCPVVerts m (mdl.prepFaceCount*3)
		
		setNumFaces m mdl.prepFaceCount
		buildTVFaces m
		buildVCFaces m
		meshop.setNumMaps m 3 keep:true
		meshop.setMapSupport m 2 true
		meshop.setNumMapVerts m 2 (mdl.prepFaceCount * 3)
		meshop.setNumMapFaces m 2 mdl.prepFaceCount
		userVerts = #()
		showProps mdl.Vertices.Item[1]
		format "Vert: %\n" mdl.Vertices.Item[1].Position
		format "[%, %, %]\n" mdl.Vertices.Item[1].normal.X mdl.Vertices.Item[1].normal.Y mdl.Vertices.Item[1].normal.Z
		format "PREPVertexCount: %\nVertices Size: %\n" mdl.PREPVertexCount mdl.Vertices.Count
		for i=0 to mdl.PREPVertexCount-1 do
		(
			vert =mdl.Vertices.Item[i] 

			vX = vert.Position.X
			vY = vert.Position.Y
			vZ = vert.Position.Z
			setVert m (i+1) [-vX,-vZ,vY]

			meshop.setVertAlpha m -2 #((i+1)) (mdl.Vertices.Item[i].colour.a/255)
			
			setTVert m (i+1) mdl.Vertices.Item[i].UV.x mdl.Vertices.Item[i].UV.y 0
			--meshop.setMapVert m 2 i [verts[i].tex2.x, verts[i].tex2.y, 0]
			setVertColor m (i+1) (color mdl.Vertices.Item[i].colour.r mdl.Vertices.Item[i].colour.g mdl.Vertices.Item[i].colour.b mdl.Vertices.Item[i].colour.a)
		)
		
		userFaces = #()
		smoothingGroups = #()
		for i=0 to mdl.prepFaceCount-1 do
		(
			j = i + 1
			face = mdl.Faces.Item[i]
			facev1 = face.verts[1]
			facev2 = face.verts[2]
			facev3 = face.verts[3]
			setFace m j (face.verts[1]+1) (face.verts[3]+1) (face.verts[2]+1)
			setEdgeVis m j 1 true
			setEdgeVis m j 2 true
			setEdgeVis m j 3 true
			--setFaceNormal m i (normalize ((verts[rawfaces[i].v1].norm+verts[rawfaces[i].v2].norm+verts[rawfaces[i].v3].norm))/3)
			
			if mergeMDLs == true then
			(
				if matID+1 > merge_OldMatIDsToNew.count then 
					setFaceMatID m j (merge_OldMatIDsToNew[merge_OldMatIDsToNew.count])
				else
					setFaceMatID m j (merge_OldMatIDsToNew[matID+1])
			)
			else
			(
				setFaceMatID m i (face.MaterialID+1)
			)
			norm1 = [mdl.Vertices.Item[facev1].normal.x, mdl.Vertices.Item[facev1].normal.y, mdl.Vertices.Item[facev1].normal.z]
			norm2 = [mdl.Vertices.Item[facev2].normal.x, mdl.Vertices.Item[facev2].normal.y, mdl.Vertices.Item[facev2].normal.z]
			norm3 = [mdl.Vertices.Item[facev3].normal.x, mdl.Vertices.Item[facev3].normal.y, mdl.Vertices.Item[facev3].normal.z]
			setFaceNormal m j (normalize ((norm1+norm2+norm3)/3))

			setTVFace m j (j*3-2) (j*3) (j*3-1)
			
			--meshop.setMapVert m 2 (i*3-2) [v1U2, 1-v1V2, 0]
			--meshop.setMapVert m 2 (i*3-1) [v2U2, 1-v2V2, 0]
			--meshop.setMapVert m 2 (i*3) [v3U2, 1-v3V2, 0]
			
			--meshop.setMapFace m 2 i [i*3-2, i*3-1, i*3]
			--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
			--format "vert #% alpha: %\n" v1Index v1colA
			--format "vert #% alpha: %\n" v2Index v2colA
			--format "vert #% alpha: %\n" v3Index v3colA
			setVCFace m j (j*3-2) (j*3) (j*3-1)
		)
		m = mesh mesh:m
	)
	free loadedMDLs
	
	format "Loaded MDLs using ToxicRagers: %\n" loadedMDLs

)
fn ImportMDL filename importTextures:false forcePREP:false useUniqueVerts:true useTriStrips:false mergeMDLs:false mergeSplits: true origin:[0,0,0]=
(
	f = fopen filename "r"
	
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
	printFlagBits flags 32 "MDL Flags"
	
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
	
	--format "=======================\nHandling Materials for mesh %\n=======================\n" filename
	if(materialCount == 1) then
	(
		materialName = readpaddedstring f version61OrLess:version61orless
		append materialNames materialName
			--format "Checking if material #% \"%\" already has been loaded\n" i materialName
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
	)
	else 
	(
		meshMaterial = multimaterial numsubs:materialCount
		for i=1 to materialCount do
		(
			materialName = readpaddedstring f version61OrLess:version61orless
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
	--format "======== merge_SubMat.material after======\n"
	--PrintArrayInFull merge_SubMat.material "merge_SubMat.material"
	--PrintArrayInFull merge_OldMatIDsToNew "merge_OldMatIDsToNew"
	--format "====================================\n"
	if forcePREP then
	(
		PREPfaceCount = readlong f #unsigned
		rawfaces = #()
		for i=1 to PREPfaceCount do
		(
			matID = readshort f #unsigned
			faceflags = readshort f #unsigned
			--printFlagBits faceflags 32 "Face Flags"
			v1 = readlong f #unsigned
			v2 = readlong f #unsigned
			v3 = readlong f #unsigned
			append rawfaces (mdlFace matID:matID flags:faceflags v1:(v1+1) v2:(v2+1) v3:(v3+1))
		)
		
		PREPvertcount = readlong f #unsigned
		--format "VertCount: %\n" PREPvertcount
		verts = #()
		uniqueVerts = #()
		uniqueVertsColours = #()
		oldVertsToNewVerts = #()
		for i=1 to PREPvertCount do
		(
			pX = readfloat f
			pY = readfloat f
			pZ = readfloat f
			
			nX = readfloat f
			nY = readfloat f
			nZ = readfloat f
			
			uv1X = readfloat f
			uv1Y = readfloat f
			
			uv2X = readfloat f
			uv2Y = readfloat f
			
			colR = readbyte f #unsigned
			colG = readbyte f #unsigned
			colB = readbyte f #unsigned
			colA = readbyte f #unsigned
			
			--format "vert #% colour: % % % %\n" i colR colG colB colA
			--format "R:% G:% B:% A:%\n" colR colG colB colA
			append verts (mdlVert pos:[-pX,-pZ,pY] norm:[nX,-nZ,nY] tex:[uv1X,1-uv1Y] tex2:[uv2X,1-uv2Y] colour:(color colR colG colB colA))
				
			isUnique = true
			if mergeSplits == true then
			(
				for j=1 to uniqueVerts.count do
				(
					if verts[i].pos == uniqueVerts[j].pos then -- and verts[i].norm == uniqueVerts[j].norm then
					(
						isUnique = false
						oldVertsToNewVerts[i] = j
					)
				)
			)
			if isUnique then
			(
				append uniqueVerts verts[i]
				append uniqueVertsColours colA
				oldVertsToNewVerts[i] = uniqueVerts.count
			)
		)
		--format "Unique Verts:%\n" uniqueVerts.count
		matGroups = #()
		triStripIndices = #()
		
		matGroupCount = readshort f #unsigned
		totalMatGroupTriangles=0
		for i = 1 to matGroupCount do
		(
			KeepMaxAlive()
			--format "Importing Mat Group %\n" i
			if useTriStrips then
			(
				
				matGroup = MDLMatGroup matID:i triStrip:#() patchList:#() numTriangles:0
				bb_cX = readfloat f
				bb_cY = readfloat f
				bb_cZ = readfloat f
				bb_Rad = readfloat f
				
				bb_minX = readfloat f
				bb_minY = readfloat f
				bb_minZ = readfloat f
				
				bb_maxX = readfloat f
				bb_maxY = readfloat f
				bb_maxZ = readfloat f
				
				matGroup.triStripVertOffset = readlong f #unsigned
				triStripVertCount = readlong f #unsigned
				triStripLength = readlong f #unsigned
				--format "Tristrip Vert Count: %\n Tristrip Length: % \n" triStripVertCount triStripLength
				degenerateBit = bit.shift 1 31
				antiDegenerateBit = bit.not degenerateBit
				tsi1 = undefined
				tsi2 = undefined
				tsi3 = undefined
				for j=1 to triStripLength do
				(
					
					tsi = (readlong f #unsigned)
					isDegenerate=false
					if (bit.and degenerateBit tsi)==degenerateBit do isDegenerate = true
					append matGroup.triStrip #((bit.and antiDegenerateBit tsi), isDegenerate)
					tsi1= tsi2
					tsi2 = tsi3
					tsi3 = (bit.and antiDegenerateBit tsi) + matGroup.triStripVertOffset
					if j > 2 then 
					(
						matGroup.numTriangles +=1
						--tsi1 = bit.and antiDegenerateBit matGroup.triStrip[matGroup.triStrip.count-2]
						--tsi2 = bit.and antiDegenerateBit matGroup.triStrip[matGroup.triStrip.count-1]
						--tsi3 = bit.and antiDegenerateBit matGroup.triStrip[matGroup.triStrip.count]
						
						if (bit.and degenerateBit matGroup.triStrip[matGroup.triStrip.count][1]) != degenerateBit then
						(
							if (bit.and j 1)==1 then
							(
								append triStripIndices (tsi1+1)
								append triStripIndices (tsi2+1)
								append triStripIndices (tsi3+1)
							)
							else							
							(
								append triStripIndices (tsi1+1)
								append triStripIndices (tsi3+1)
								append triStripIndices (tsi2+1)
							)
						)
					)
				)
				--format "Number Of TriStip Indices: %\n" matGroup.triStrip.count
				
				matGroup.patchListVertOffset = readlong f #usigned
				patchListVertCount = readlong f #unsigned
				patchListLength = readlong f #unsigned
				
				--format "Patch Vert Count: %\n Patch Length: % \n" patchListVertCount patchListLength
				for j=1 to patchListLength do
				(
					tsi1 = (readlong f #unsigned)
					append matGroup.patchList tsi1
					
					append triStripIndices (tsi1+1+matGroup.patchListVertOffset)
				)
				matGroup.numTriangles += patchListLength/3
				--format "Number Of Patch Indices: %\n" matGroup.patchList.count
				append matGroups matGroup
				totalMatGroupTriangles += matGroup.numTriangles
				--PrintArrayInFull matGroup.patchList "Patch List"
			)
			else
			(
				fseek f 48 #seek_cur
				
				triStripLength = readlong f #unsigned
				
				fseek f ((triStripLength * 4)+8) #seek_cur
				
				patchListLength = readlong f #unsigned
				fseek f (patchListLength * 4) #seek_cur
			)
		)
		prepSkinDataSet = CheckBitIsSet flags 5
	
		
		local m = trimesh()
		
		if useUniqueVerts then setNumVerts m uniqueVerts.count
		else setNumVerts m verts.count
		
		setNumTVerts m verts.count
		--meshop.setNumMaps m 3
		--meshop.setMapSupport m 2 true
		--meshop.setNumMapVerts m 2 verts.count
		setNumCPVVerts m verts.count
		if useUniqueVerts then
		(
			for i=1 to uniqueVerts.count do
			(
				setVert m i uniqueVerts[i].pos
				meshop.setVertAlpha m -2 #(i) (uniquevertscolours[i]/255)
				--setNormal m i uniqueVerts[i].norm
			)
		)
		for i=1 to verts.count do
		(
			if useUniqueVerts == false then
			(
				setVert m i verts[i].pos
				meshop.setVertAlpha m -2 #(i) (verts[i].colour.a/255)
			)
			setTVert m i verts[i].tex.x verts[i].tex.y 0
			--meshop.setMapVert m 2 i [verts[i].tex2.x, verts[i].tex2.y, 0]
			setVertColor m i (color verts[i].colour.b verts[i].colour.g verts[i].colour.r verts[i].colour.a)
		)
		if useTriStrips then setNumFaces m totalMatGroupTriangles
		else setNumFaces m rawfaces.count
		buildTVFaces m
		buildVCFaces m
		--meshop.setNumMapFaces m 2 faces.count
		
		numFacesToAdd = rawfaces.count
		if useTriStrips then
		(
			--format "Using TriStrips!\n"
			faceNumber = 0
			--format "Number Of TriStrip Indices: %\n" triStripIndices.count
			for i = 1 to matGroups.count do
			(
				for j = 3 to matGroups[i].triStrip.count do
				(
					if matGroups[i].triStrip[j][2] do continue
					if (bit.and j 1)==1 then
					(
						facev1 = matGroups[i].triStrip[j-2][1] + 1 + matGroups[i].triStripVertOffset
						facev2 = matGroups[i].triStrip[j-1][1] + 1+ matGroups[i].triStripVertOffset
						facev3 = matGroups[i].triStrip[j][1] + 1+ matGroups[i].triStripVertOffset
					)
					else
					(
						facev1 = matGroups[i].triStrip[j-2][1] + 1+ matGroups[i].triStripVertOffset
						facev2 = matGroups[i].triStrip[j][1] + 1+ matGroups[i].triStripVertOffset
						facev3 = matGroups[i].triStrip[j-1][1] + 1+ matGroups[i].triStripVertOffset
					)
					if facev1 == facev2 or facev1 == facev3 or facev2 == facev3 do continue
						faceNumber += 1
					if useUniqueVerts then setFace m faceNumber oldVertsToNewVerts[facev1] oldVertsToNewVerts[facev3] oldVertsToNewVerts[facev2]
					else setFace m faceNumber facev1 facev3 facev2
					
					setEdgeVis m faceNumber 1 true
					setEdgeVis m faceNumber 2 true
					setEdgeVis m faceNumber 3 true
					setFaceNormal m faceNumber (normalize ((verts[facev1].norm+verts[facev2].norm+verts[facev3].norm)/3))
					setFaceMatID m faceNumber (i)
					setTVFace m faceNumber facev1 facev3 facev2
					--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
					setVCFace m faceNumber facev1 facev3 facev2
				)
			
				for j = 1 to (matGroups[i].patchList.count/3) do
				(
					
						patchind1 = j * 3 - 2
						patchind2 = j * 3 - 1
						patchind3 = j * 3
						facev1 = matGroups[i].patchList[patchind1]
						facev1 += 1 + matGroups[i].patchListVertOffset
						facev2 = matGroups[i].patchList[patchind2]
						facev2 += 1 + matGroups[i].patchListVertOffset
						facev3 = matGroups[i].patchList[patchind3]
						facev3 += 1 + matGroups[i].patchListVertOffset
					if facev1 == facev2 or facev1 == facev3 or facev2 == facev3 do continue
					
					faceNumber+=1
					if useUniqueVerts then setFace m faceNumber oldVertsToNewVerts[facev1] oldVertsToNewVerts[facev3] oldVertsToNewVerts[facev2]
					else setFace m faceNumber facev1 facev3 facev2
					setEdgeVis m faceNumber 1 true
					setEdgeVis m faceNumber 2 true
					setEdgeVis m faceNumber 3 true
					setFaceNormal m faceNumber (normalize ((verts[facev1].norm+verts[facev2].norm+verts[facev3].norm)/3))
					if mergeMDLs == true then
					(
						setFaceMatID m faceNumber (merge_OldMatIDsToNew[i])
					)
					else
					(
						setFaceMatID m faceNumber (i)
					)
					setTVFace m faceNumber facev1 facev3 facev2
					--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
					setVCFace m faceNumber facev1 facev3 facev2
				)
			)
		)
		else
		(
			for i=1 to numFacesToAdd do
			(
				if useTriStrips then
				(
					facev1 = triStripIndices[i*3-2] 
					facev2 = triStripIndices[i*3-1]
					facev3 = triStripIndices[i*3]
				)
				else
				(
					facev1=rawfaces[i].v1
					facev2=rawfaces[i].v2
					facev3=rawfaces[i].v3
				)
					if useUniqueVerts then setFace m i oldVertsToNewVerts[facev1] oldVertsToNewVerts[facev3] oldVertsToNewVerts[facev2]
					else setFace m i facev1 facev3 facev2
				setEdgeVis m i 1 true
				setEdgeVis m i 2 true
				setEdgeVis m i 3 true
				setFaceNormal m i (normalize ((verts[facev1].norm+verts[facev2].norm+verts[facev3].norm)/3))
					
				if mergeMDLs == true then
				(
					setFaceMatID m i (merge_OldMatIDsToNew[rawfaces[i].matID+1])
				)
				else
				(
					setFaceMatID m i (rawfaces[i].matID+1)
				)
				
				setTVFace m i facev1 facev3 facev2
				--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
				setVCFace m i facev1 facev3 facev2
			)
		)
		
		m = mesh mesh:m
		m.material = meshMaterial
		
		if prepSkinDataSet then
		(
			--format "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nOMG PANIC! THIS MDL HAS PREP SKIN DATA AND I DON'T KNOW WHAT TO DO WITH IT!!! At Position: %\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n" (ftell f)
			--format "Num Verts: %\nNum Faces: %\n" PREPvertcount PREPfacecount
			numBones = readshort f #unsigned
			unknown1 = readshort f #unsigned
			unknown2 = readshort f #unsigned
			--format "Unknown1 = %\nUnknown2 = %\n" unknown1 unknown2
			skinMod = skin()
			addmodifier m skinMod
			boneNames = #()
			for i=1 to numBones do
			(
				append boneNames (readstring f)
			)
			--PrintArrayInFull boneNames "boneNames"
			
			boneInfo = #()
			for i = 1 to numbones do
			(
				
				v1X = readfloat f
				v1Y = readfloat f
				v1Z = readfloat f
				v2X = readfloat f
				v2Y = readfloat f
				v2Z = readfloat f
				v3X = readfloat f
				v3Y = readfloat f
				v3Z = readfloat f
				
				p = readbyte f
				c = readbyte f
				s = readbyte f
				boneInfo[i] = #([v1X,v1Y,v1Z], [v2X,v2Y,v2Z], [v3X,v3Y,v3Z], p, c, s)
				
				
				--format "%: \"%\" : { x:%   y:%   z:%} : { x:%   y:%   z:%} : { x:%   y:%   z:%} p: % c: % s:% \n" i boneNames[i] v1X v1Y v1Z v2X v2Y v2Z v3X v3Y v3Z p c s
				
				--format "%: \"%\" : { x:%   y:%   z:%} p: % c: % s:% \n" i boneNames[i] v3X v3Y v3Z p c s
			)
			listOfBones = #()
			select m
			max modify mode
			modPanel.setCurrentObject skinMod
			for i=1 to numbones do
			(
				qX = readfloat f
				qY = readfloat f
				qZ = readfloat f
				qW = readfloat f
				
				posX =  readfloat f
				posY =  readfloat f
				posZ =  readfloat f
				
				unknown_f = readfloat f
				fseek f -4 #seek_cur
				unknown_l = readlong f
				fseek f -4 #seek_cur
				unknown_lu = readlong f #unsigned
				fseek f -4 #seek_cur
				unknown_s1 = readshort f
				unknown_s2 = readshort f
				fseek f -4 #seek_cur
				unknown_su1 = readshort f #unsigned
				unknown_su2 = readshort f #unsigned
				
				boneTransform = (quat qz -qx qw qy) as matrix3
				bonePos =  [-posX, -posZ, posY]
				newBone = bonesys.createbone bonePos (bonePos + 0.1 * boneTransform.row1) (normalize boneTransform.row3) --bone name:boneNames[i] rotation:(quat qz -qx qw qy)
				listOfBones[i] = newBone
				listOfBones[i].rotation = quat qz -qx qw qy
				parentBone = boneInfo[i][4]+1
				newpos = [-posX, -posZ, posY]
				listOfBones[i].position = newpos
				listOfBones[i].name = boneNames[i]
				
				/*b = box()
				bMin = boneInfo[i][1]
				bMax = boneInfo[i][2]
				boxpos = (ConvertFromCRSpace (bMax - bMin)) + bonePos
				b.width = bMax.x - bMin.x
				b.length = bMax.y - bMin.y
				b.height = bMax.z - bMin.z
				boxpos.z += b.height / 2
				b.objectoffsetpos.z -= b.height / 2
				b.transform = b.transform * newBone.transform
				b.name = boneNames[i]+"_BBox"
				*/
				
				
				ik.SetAxisLimit newBone #rotational #{1, 2, 3}
				ik.SetAxisEase newBone #rotational #{1, 2, 3}
				--format "boneInfo[%] = %\n" i boneInfo[i]
				minLimit = ([boneInfo[i][1].x, boneInfo[i][1].y,boneInfo[i][1].z] * 360)-- * boneTransform
				maxLimit = ([boneInfo[i][2].x, boneInfo[i][2].y,boneInfo[i][2].z] * 360)-- * boneTransform
				
				ik.SetAxisMin newBone #rotational minLimit
				ik.SetAxisMax newBone #rotational maxLimit
				
				--skinops.addbone skinMod listOfBones[i] 0
				--format "%: \"%\" {X: %    Y:%    Z: %   W: %}   {X: %    Y: %     Z:    %}  ???: %\n" i boneNames[i] qx qy qz qw posx posy posz unknown_f
				--if unknown_f != 0 then format "unknown: float: %   long: %   unsigned long: %   shorts: % - %   unsigned shorts: % - %\n\n" unknown_f unknown_l unknown_lu unknown_s1 unknown_s2 unknown_su1 unknown_su2
			)
			
			sortedBones = deepcopy boneNames
			sort sortedBones
			oldbonestonewbones = #()
			newbonestooldbones = #()
			currentBones = #()
				if listOfBones[(finditem boneNames "hips")].children.count > 0 then
				(
					for i=1 to listOfBones[(finditem boneNames "hips")].children.count do append listOfBones[(finditem boneNames "hips")].children[i]
				)
			while currentBones.count > 0 do
			(
				currentBone = currentBones[1]
				deleteItem currentBones 1
				boneIndex = finditem boneNames currentBone.name
				currentBone.position = boneInfo[boneIndex][3] * listOfBones[(boneInfo[boneIndex][4] + 1)].transform
				if currentBone.children.count > 0 then
				(
					for i=1 to currentBone.children.count do append currentBone.children[i]
				)
			)
			for i=1 to boneNames.count do
			(
				parentBone = boneInfo[i][4]+1
				newpos = listOfBones[i].position
				while parentBone > 0 do
				(
					offsetPos = [-boneInfo[parentBone][3].x, -boneInfo[parentBone][3].z, boneInfo[parentBone][3].y] * listOfBones[parentBone].rotation
					newPos += offsetPos
					parentBone = boneInfo[parentBone][4]+1
				)
				--listOfBones[i].position = newpos
				for j=1 to sortedBones.count do
				(
					if sortedBones[j] == boneNames[i] then 
					(
						oldbonestonewbones[i] = j
						newbonestooldbones[j] = i
						break;
					)
				)
			)
			for i=1 to listOfBones.count do
			(
				
				skinops.addbone skinMod listOfBones[newbonestooldbones[i]] 0
				if boneInfo[i][4]+1 > 0 then listOfBones[i].parent = listOfBones[boneInfo[i][4]+1]
			)
			completeRedraw ()

			weightsPerVert = #()
			for i = 1 to PREPvertcount do
			(
				weightCount = readshort f #unsigned
				unknown = readbyte f #unsigned
				unknown2 = readbyte f #unsigned
				weightIndex = readlong f #unsigned
				/*if unknown != 0 or unknown2 != 0 then
				(
					format "%: %     % - %     %\n" i weightCount unknown unknown2 weightIndex
					printflagbits unknown 8 "Unknown Skin Data 1"
					printflagbits unknown2 8 "Unknown Skin Data 2"
					format "\n"
				)*/
				weightsPerVert[i] = #(weightCount, unknown, weightIndex, #(), #())
			)
			currentWeightIndex = 0
			weightCount = readlong f #unsigned
			for i=1 to weightsPerVert.count do
			(
				for j=1 to weightsPerVert[i][1] do
				(
					currentWeightIndex += 1
					boneIndex = readshort f #unsigned
					weightsPerVert[i][4][j] = boneIndex+1 --oldbonestonewbones[boneIndex + 1]
				)
			)
			currentWeightIndex = 0
			for i=1 to weightsPerVert.count do
			(
				for j=1 to weightsPerVert[i][1] do
				(
					currentWeightIndex += 1
					weight = readfloat f
					weightsPerVert[i][5][j] = weight
					--format "Vert %: weightIndex: % boneIndex: % weight: %\n" i currentWeightIndex weightsPerVert[i][4][j] weightsPerVert[i][5][j]
				)
			)
			/*printarrayinfull bonenames "BoneNames"
			printarrayinfull sortedBones "SortedBoneNames"
			printarrayinfull oldbonestonewbones "SortedBoneNames"
			printarrayinfull newbonestooldbones "SortedBoneNames"*/
			/*format "SkinMod Bones:\n"
			for i=1 to (skinops.getnumberbones skinmod) do
			(
				format "%: % (node: %)\n" i (skinops.getbonename skinmod i 1) (skinops.getbonename skinmod i 2)
			)*/
			
			--format "\nnum skin verts: %\nnum uniqueVerts: %\n\n" (skinOps.GetNumberVertices skinMod) uniqueVerts.count
			for i=1 to uniqueVerts.count do
			(
				--format "Vert #%" i
				vertIndex = finditem oldVertsToNewVerts i
				
				weightCount = skinOps.GetVertexWeightCount skinMod i
				--format "\nWeights on Vert Before Replacing (% found):\t" weightCount
				for x=1 to weightCount do
				(
					
					boneId = skinOps.GetVertexWeightBoneID skinMod i x
					boneName = skinOps.GetBoneName skinMod boneId 0
					boneNum = 0
					for j=1 to boneNames.count do
					(
						if boneNames[j] == boneName then 
						(
							boneNum = j
							break
						)
					)
					weight = skinOps.GetVertexWeight  skinMod i x
					--format "(% [%/%] - %), " boneName boneNum boneId weight
				)
				
				--format "\nWeights Being Added:\t\t\t\t"
				for x=1 to weightsPerVert[vertIndex][4].count do
				(
					--format "(% [%] - %), " sortedBones[weightsPerVert[vertIndex][4][x]] weightsPerVert[vertIndex][4][x] weightsPerVert[vertIndex][5][x]
				)

				for z=1 to boneNames.count do
				(
					if (finditem weightsPerVert[vertIndex][4] z) == 0 then 
					(
						append weightsPerVert[vertIndex][4] z
						append weightsPerVert[vertIndex][5] 0.0
					)
				)
				skinOps.ReplaceVertexWeights skinMod i weightsPerVert[vertIndex][4] weightsPerVert[vertIndex][5]
				skinOps.Invalidate SkinMod 0
				weightCount = skinOps.GetVertexWeightCount skinMod i
				--format "\nWeights on Vert (% found):\t\t\t" weightCount
				for x=1 to weightCount do
				(
					
					boneId = skinOps.GetVertexWeightBoneID skinMod i x
					boneName = skinOps.GetBoneName skinMod boneId 0
					boneNum = 0
					for j=1 to boneNames.count do
					(
						if boneNames[j] == boneName then 
						(
							boneNum = j
							exit
						)
					)
					weight = skinOps.GetVertexWeight  skinMod i x
					--format "(% [%/%] - %), " boneName boneNum boneId weight
				)
				--format "\n\n"
			)
			--format "\nnum skin verts: %\n\n" (skinOps.GetNumberVertices skinMod)
			
		)
		if listOfBones != undefined  then 
		(
			for x = 1 to listOfBones.count do
			(
				if listOfBones[x].parent == undefined then
					listOfBones[x].pos = listOfBones[x].pos + origin
			)
		)
		
		gc()
		--update m
		return m
	)
	else if filesize != 0 then
	(
		
		PREPfaceCount = readlong f #unsigned
		fseek f (16 * PREPfaceCount) #seek_cur
		
		PREPvertcount = readlong f #unsigned
		--format "Number of PREP Faces: %\n Number of PREP Verts: %\n" PREPfaceCount PREPvertCount
		--format "Number of USER Faces: %\n Number of USER Verts: %\n" firstFaceCount uniqueVertexCount
		fseek f (44 * PREPvertcount) #seek_cur
		
		matGroupCount = readshort f #unsigned
		for i = 1 to matGroupCount do
		(
			fseek f 48 #seek_cur
			
			triStripLength = readlong f #unsigned
			
			fseek f ((triStripLength * 4)+8) #seek_cur
			
			patchListLength = readlong f #unsigned
			fseek f (patchListLength * 4) #seek_cur
			
		)
		prepSkinDataSet = CheckBitIsSet flags 5
		if prepSkinDataSet then
		(
		
		--format "Prep Skin Data Pos: %\n" (ftell f)
			--format "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nOMG PANIC! THIS MDL HAS PREP SKIN DATA AND I DON'T KNOW WHAT TO DO WITH IT!!! At Position: %\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n" (ftell f)
			--format "Num Verts: %\nNum Faces: %\n" PREPvertcount PREPfacecount
			numBones = readshort f #unsigned
			unknown1 = readshort f #unsigned
			unknown2 = readshort f #unsigned
			--format "Unknown1 = %\nUnknown2 = %\n" unknown1 unknown2
			--skinMod = skin()
			--addmodifier m skinMod
			boneNames = #()
			for i=1 to numBones do
			(
				append boneNames (readstring f)
			)
			--PrintArrayInFull boneNames "boneNames"
			
		--format "Prep Skin After Namees Pos: %\n" (ftell f)
			boneInfo = #()
			for i = 1 to numbones do
			(
				
				v1X = readfloat f
				v1Y = readfloat f
				v1Z = readfloat f
				v2X = readfloat f
				v2Y = readfloat f
				v2Z = readfloat f
				v3X = readfloat f
				v3Y = readfloat f
				v3Z = readfloat f
				
				p = readbyte f
				c = readbyte f
				s = readbyte f
				
				boneInfo[i] = #([v1X,v1Y,v1Z], [v2X,v2Y,v2Z], [v3X,v3Y,v3Z], p, c, s)
				
				
				--format "%: \"%\" : { x:%   y:%   z:%} : { x:%   y:%   z:%} : { x:%   y:%   z:%} p: % c: % s:% \n" i boneNames[i] v1X v1Y v1Z v2X v2Y v2Z v3X v3Y v3Z p c s
			)
			listOfBones = #()
			--select m
			--max modify mode
			--modPanel.setCurrentObject skinMod
			for i=1 to numbones do
			(
				qX = readfloat f
				qY = readfloat f
				qZ = readfloat f
				qW = readfloat f
				
				posX =  readfloat f
				posY =  readfloat f
				posZ =  readfloat f
				
				unknown = readfloat f
				
				--format "%: \"%\" {X: %    Y:%    Z: %   W: %}   {X: %    Y: %     Z:    %}  ???: %\n" i boneNames[i] qx qy qz qw posx posy posz unknown
			)
		--format "Prep Skin After Bone Shit: %\n" (ftell f)
			
			for i=1 to listOfBones.count do
			(
				if boneInfo[i][4]+1 > 0 then listOfBones[i].parent = listOfBones[boneInfo[i][4]+1]
			)
			weightsPerVert = #()
			for i = 1 to PREPvertcount do
			(
				weightCount = readshort f #unsigned
				unknown = readbyte f #unsigned
				unknown2 = readbyte f #unsigned
				weightIndex = readlong f #unsigned
				
				--format "%: %     % - %     %\n" i weightCount unknown unknown2 weightIndex
				weightsPerVert[i] = #(weightCount, unknown, weightIndex, #(), #())
			)
			
		--format "Prep Skin Data After Verts: %\n" (ftell f)
			currentWeightIndex = 0
			weightCount = readlong f #unsigned
			for i=1 to weightsPerVert.count do
			(
				for j=1 to weightsPerVert[i][1] do
				(
					currentWeightIndex += 1
					boneIndex = readshort f #unsigned
					weightsPerVert[i][4][j] = boneIndex + 1
				)
			)
			
		--format "Prep Skin Data After Bone Indices: %\n" (ftell f)
			currentWeightIndex = 0
			for i=1 to weightsPerVert.count do
			(
				--format "Vert #% has % weights:\n" i weightsPerVert[i][1]
				for j=1 to weightsPerVert[i][1] do
				(
					currentWeightIndex += 1
					weight = readfloat f
					weightsPerVert[i][5][j] = weight
					--format "\t% - % %\n" j weightsPerVert[i][4][j] weightsPerVert[i][5][j]
					--format "Vert %: weightIndex: % boneIndex: % weight: %\n" i currentWeightIndex weightsPerVert[i][4][j] weightsPerVert[i][5][j]
				)
			)
		--format "Prep Skin Data After Weights: %\n" (ftell f)
		)
	)
	
	if forcePREP == false then
	(
		--format "User Data pos: %\n" (ftell f)
		USERflags = readlong f #unsigned
		USERskinSet = CheckBitIsSet USERflags 2
		if PREPfaceCount == undefined then PREPfaceCount = firstFaceCount
		--printFlagBits flags 32 "flags: "
		printFlagBits USERflags 32 "USER flags: "
		local m = trimesh()
		setNumVerts m uniqueVertexCount
		setNumTVerts m (PREPfaceCount*3)
		setNumCPVVerts m (PREPfaceCount*3)
		
		setNumFaces m PREPfaceCount
		buildTVFaces m
		buildVCFaces m
		meshop.setNumMaps m 3 keep:true
		meshop.setMapSupport m 2 true
		meshop.setNumMapVerts m 2 (PREPfaceCount * 3)
		meshop.setNumMapFaces m 2 PREPfaceCount
		userVerts = #()
		for i=1 to uniqueVertexCount do
		(
			vX = readfloat f
			vY = readfloat f
			vZ = readfloat f
			setVert m i [-vX,-vZ,vY]
			timesUsed = readlong f #unsigned
		)
		
		userFaces = #()
		smoothingGroups = #()
		for i=1 to PREPfaceCount do
		(
			planeD = readfloat f
			planeX = readfloat f
			planeY = readfloat f
			planeZ = readfloat f
			
			v1nX = readfloat f
			v1nY = readfloat f
			v1nZ = readfloat f
			
			v2nX = readfloat f
			v2nY = readfloat f
			v2nZ = readfloat f
			
			v3nX = readfloat f
			v3nY = readfloat f
			v3nZ = readfloat f
			
			matID = readlong f #unsigned
			smoothinggroup = readlong f #unsigned
			
			v1index = readlong f #unsigned
			v2index = readlong f #unsigned
			v3index = readlong f #unsigned
			
			
			--format "Writing face #% - % / % / %\n" i v1index v2index v3index
			
			v1colR = readbyte f #unsigned
			v1colG = readbyte f #unsigned
			v1colB = readbyte f #unsigned
			v1colA = readbyte f #unsigned
			
			v2colR = readbyte f #unsigned
			v2colG = readbyte f #unsigned
			v2colB = readbyte f #unsigned
			v2colA = readbyte f #unsigned
			
			v3colR = readbyte f #unsigned
			v3colG = readbyte f #unsigned
			v3colB = readbyte f #unsigned
			v3colA = readbyte f #unsigned
			
			v1U = readfloat f
			v1V = readfloat f
			v1U2 = readfloat f
			v1V2 = readfloat f
			
			v2U = readfloat f
			v2V = readfloat f
			v2U2 = readfloat f
			v2V2 = readfloat f
			
			v3U = readfloat f
			v3V = readfloat f
			v3U2 = readfloat f
			v3V2 = readfloat f
			
			faceFlags = readbyte f #unsigned
			faceAppFlags = readlong f #unsigned
			if faceFlags != 0 then
			(
				--printFlagBits faceFlags 8 "Face Flags"
			)
			if faceAppFlags != 0 then
			(
				printFlagBits faceAppFlags 32 "Face App Flags"
			)
			
			setFace m i (v1index+1) (v3index+1) (v2index+1)
			setEdgeVis m i 1 true
			setEdgeVis m i 2 true
			setEdgeVis m i 3 true
			--setFaceNormal m i (normalize ((verts[rawfaces[i].v1].norm+verts[rawfaces[i].v2].norm+verts[rawfaces[i].v3].norm))/3)
			
			if mergeMDLs == true then
			(
				if matID+1 > merge_OldMatIDsToNew.count then 
					setFaceMatID m i (merge_OldMatIDsToNew[merge_OldMatIDsToNew.count])
				else
					setFaceMatID m i (merge_OldMatIDsToNew[matID+1])
			)
			else
			(
				setFaceMatID m i (matID+1)
			)
			setFaceSmoothGroup m i smoothinggroup
			setTVert m (i*3-2) v1U (1-v1V) 0
			setTVert m (i*3-1) v2U (1-v2V) 0
			setTVert m (i*3) v3U (1-v3V) 0
			
			setTVFace m i (i*3-2) (i*3) (i*3-1)
			
			meshop.setMapVert m 2 (i*3-2) [v1U2, 1-v1V2, 0]
			meshop.setMapVert m 2 (i*3-1) [v2U2, 1-v2V2, 0]
			meshop.setMapVert m 2 (i*3) [v3U2, 1-v3V2, 0]
			
			meshop.setMapFace m 2 i [i*3-2, i*3-1, i*3]
			--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
			--format "vert #% alpha: %\n" v1Index v1colA
			--format "vert #% alpha: %\n" v2Index v2colA
			--format "vert #% alpha: %\n" v3Index v3colA
			setVertColor m (i*3-2) (color v1colR v1colG v1colB v1colA)
			setVertColor m (i*3-1) (color v2colR v2colG v2colB v2colA)
			setVertColor m (i*3) (color v3colR v3colG v3colB v3colA)
			meshop.setVertAlpha m -2 #(v1index+1) (v1colA/255)
			meshop.setVertAlpha m -2 #(v2index+1) (v2colA/255)
			meshop.setVertAlpha m -2 #(v3index+1) (v3colA/255)
			setVCFace m i (i*3-2) (i*3) (i*3-1)
			
			
			--append userFaces (mdlUSERface PlaneD:planeD PlaneX:planeX PlaneY:planeY PlaneZ:planeZ v1NormX:v1nX v1NormY:v1nY v1NormZ:v1nZ v2NormX:v2nX v2NormY:v2nY v2NormZ:v2nZ v3NormX:v3nX v3NormY:v3nY v3NormZ:v3nZ MaterialIndex:matID SmoothingGroup: smoothinggroup v1:v1index v2:v2index v3:v3index v1Colour:(color v1colR v1colG v1colB v1colA) v2Colour:(color v2colR v2colG v2colB v2colA) v3Colour:(color v3colR v3colG v3colB v3colA) v1U:v1U v1V:v1V v1U2:v1U2 v1V2:v1V2 v2U:v2U v2V:v2V v2U2:v2U2 v2V2:v2V2 v3U:v3U v3V:v3V v3U2:v3U2 v3V2:v3V2 FaceFlags:faceFlags AppSpecificFlags:faceAppFlags)
			
			--format "Face %: %\n" i (userFaces[i] as string)
			--format "Vert indices: % % %\n" v1index v2index v3index
			--append smoothingGroups smoothingGroup
		)
		if filesize > 0 then
		(
			for i =1 to PREPfaceCount do
			(
				faceMap = readlong f #unsigned
			)
			numPrepVerts = readlong f #unsigned
			
			for i=1 to numPrepVerts do
			(
				vertMap = readlong f #unsigned
			)
		)
		m = mesh mesh:m
		m.material = meshMaterial
		if USERskinSet then
		(
			USERboneCount = readshort f #unsigned
			
			skinMod = skin()
			addmodifier m skinMod
			select m
			max modify mode
			modPanel.setCurrentObject skinMod
			--format "USER Bone Count: %\n" USERBoneCount
			listOfBones = #()
			boneParents = #()
			for i=1 to USERboneCount do
			(
				boneName = readstring2 f 32
				parentBone = readshort f
				m11 = readfloat f
				m12 = readfloat f
				m13 = readfloat f
				m21 = readfloat f
				m22 = readfloat f
				m23 = readfloat f
				m31 = readfloat f
				m32 = readfloat f
				m33 = readfloat f
				m41 = readfloat f
				m42 = readfloat f
				m43 = readfloat f
				
							
				boneTransformMatrix = matrix3 [m11,m12,m13] [m21,m22,m23] [m31,m32,m33] [m41,m42,m43]
				boneTransformMatrix =  matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0] * boneTransformMatrix * inverse(matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0])
				boneTransformMatrix.row1 *= -1
				--format "boneName: % - parentBone - % \nTransform: %\n" boneName parentBone boneTransformMatrix
				newBone = bonesys.createbone boneTransformMatrix.row4 (boneTransformMatrix.row4 - 0.1 * boneTransformMatrix.row1) (normalize boneTransformMatrix.row3)
				newBone.transform = boneTransformMatrix
				newBone.name = boneName
				listOfBones[i] = newBone
				boneParents[i] = parentBone+1
				
				--skinops.addbone skinMod newBone 0
				
				--format "==== % ====\n BoneName: %\n parentBone: %\n matrix: \n\t{%, %, %}\n\t{%, %, %}\n\t{%, %, %}\n\t{%, %, %}\n\n" i boneName parentBone m11 m12 m13 m21 m22 m23 m31 m32 m33 m41 m42 m43
			)
			
			sortedBones = deepcopy boneNames
			sort sortedBones
			oldbonestonewbones = #()
			newbonestooldbones = #()
			for i=1 to boneNames.count do
			(
				for j=1 to sortedBones.count do
				(
					if sortedBones[j] == boneNames[i] then 
					(
						oldbonestonewbones[i] = j
						newbonestooldbones[j] = i
						break;
					)
				)
			)
			for i=1 to listOfBones.count do
			(
				
				skinops.addbone skinMod listOfBones[newbonestooldbones[i]] 0
			)
			completeRedraw ()
			for i=1 to USERboneCount do
			(
				if boneParents[i] > 0 then listOfBones[i].parent = listOfBones[boneParents[i]]
			)
			
			numWeightedVerts = readlong f
			--format "Num Weighted Verts: %\n" numWeightedVerts
			for v=1 to numWeightedVerts do
			(
				
				numWeights = readshort f #unsigned
				--format "Vert % - num weights: %\n" v numweights
				vertBones = #()
				vertWeights = #()
				for w=1 to numWeights do
				(
					boneNum = readshort f #unsigned
					
					weight = readfloat f
					vertBones[w] = boneNum+1
					vertWeights[w] = weight
					f1 = readfloat f
					f2 = readfloat f
					f3 = readfloat f
					--format "\t% - % % (%, %, %)\n" w bonenum weight f1 f2 f3
					--format "%.%] % : % - {%, %, %}\n" v w boneNum weight f1 f2 f3
				)
			
				skinOps.ReplaceVertexWeights skinMod v vertBones vertWeights
			)
			
		)
		uniqueSmoothingGroups = makeUniqueArray smoothingGroups
		
		fclose f
		
		--meshop.setNumMapFaces m 2 faces.count
		--PrintArrayInFull userFaces "USER Faces"
		--PrintArrayInFull userVerts "USER Verts"
		
		gc()
		--update m
		return m
	)
	
	
)
fn CalculateCNTNamePadding stringLength =
(
	
	mdlnl_div4 = stringLength / 4
	mdlnl_plus1 = 0
	if (mod stringLength 4) > 0 do
	(
		mdlnl_plus1=1
	)
	mdlnl_added = mdlnl_div4 + mdlnl_plus1
	model_name_padding = (mdlnl_added * 4) - stringLength
	return model_name_padding
)

fn ImportCNTNode f parentNode = 
(
	local newNode = NewCNTNode nameLength:0 nodeName:"" isA12CNT:false unknownFloat:0 parentNode:undefined transformMatrix:(matrix3 1) position:[0,0,0] combinedMatrix:(matrix3 1) absolutePosition:[0,0,0] nodeType:"NULL" nodeData:undefined numChildren:0 children:#()
	newNode.nameLength = readlong f #unsigned
	newNode.nodeName = readstring2 f newNode.nameLength

	if parentNode !=undefined then
	(
		--format "Loading node \"%\", parent is \"%\"\n" newNode.nodeName parentNode.nodeName
	)	
	else
	(
		--format "Loading root node \"%\"\n" newNode.nodeName
	)	
	--mdlnl_div4 = newNode.nameLength / 4
	--mdlnl_plus1 = 0
	--if (mod newNode.nameLength 4) > 0 do
	--(
	--	mdlnl_plus1=1
	--)
	--mdlnl_added = mdlnl_div4 + mdlnl_plus1
	--model_name_padding = (mdlnl_added * 4) - newNode.nameLength
	model_name_padding = CalculateCNTNamePadding newNode.nameLength
	for i=1 to model_name_padding do 
	(
		readbyte f
	)
	
	testIfA12Value = readbyte f
	if testIfA12Value > 0 do
	(
		newNode.isA12CNT = true
		readbyte f
	)
	
	newNode.unknownFloat = readfloat f
		
	m_Xx = readfloat f
	m_Xy = readfloat f
	m_Xz = readfloat f
	m_Yx = readfloat f
	m_Yy = readfloat f
	m_Yz = readfloat f
	m_Zx = readfloat f
	m_Zy = readfloat f
	m_Zz = readfloat f
	m_Px = readfloat f
	m_Py = readfloat f
	m_Pz = readfloat f
	newNode.transformMatrix = matrix3 [m_Xx,m_Xy,m_Xz] [m_Yx,m_Yy,m_Yz] [m_Zx,m_Zy,m_Zz] [m_Px,m_Py,m_Pz]
	newNode.transformMatrix =  matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0] * newNode.transformMatrix * inverse(matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0])
	newNode.position = newNode.transformMatrix.row4
	if parentNode != undefined then 
	(
		newNode.combinedMatrix = newNode.transformMatrix * parentNode.combinedMatrix
		newNode.absolutePosition = newNode.combinedMatrix.row4
		newNode.parentNode = parentNode
	)
	else
	(
		newNode.combinedMatrix = newNode.transformMatrix
		newNode.absolutePosition = newNode.position
	)
	
	newNode.nodeType = readstring2 f 4
	
	if newNode.nodeType == "LITg" then
	(
		newNode.nodeData = LITGnode lightType:0 lightBounds:undefined objectNameLength:0 objectName:""
		newNode.nodeData.lightType = readlong f
		newNode.nodeData.lightBounds = undefined
		if newNode.nodeData.lightType == 2 do
		(
			lightBounds = #()
			for i=1 to 26 do
			(
				append lightBounds (readfloat f)
			)
			newNode.nodeData.lightBounds = lightBounds
		)
		newNode.nodeData.objectNameLength = readlong f #unsigned
		newNode.nodeData.objectName = readstring2 f newNode.nodeData.objectNameLength
		nodePadding = CalculateCNTNamePadding newNode.nodeData.objectNameLength
		for i=1 to nodePadding do
		(
			readbyte f
		)
	)
	else if newNode.nodeType == "EMT2" then
	(
		newNode.nodeData = EMT2node bytes:#()
		for i=1 to 650 do 
		(
			append newNode.nodeData.bytes (readbyte f)
		)
	)
	else if newNode.nodeType == "MODL" then
	(
		newNode.nodeData = MODLnode objectNameLength:0 objectName:""
		
		newNode.nodeData.objectNameLength = readlong f #unsigned
		newNode.nodeData.objectName = readstring2 f newNode.nodeData.objectNameLength
		nodePadding = CalculateCNTNamePadding newNode.nodeData.objectNameLength
		for i=1 to nodePadding do
		(
			readbyte f
		)
	)
	else if newNode.nodeType == "SKIN" then
	(
		newNode.nodeData = SKINnode objectNameLength:0 objectName:""
		
		newNode.nodeData.objectNameLength = readlong f #unsigned
		newNode.nodeData.objectName = readstring2 f newNode.nodeData.objectNameLength
		nodePadding = CalculateCNTNamePadding newNode.nodeData.objectNameLength
		for i=1 to nodePadding do
		(
			readbyte f
		)
	)
	else if newNode.nodeType == "VFXI" then
	(
		newNode.nodeData = VFXInode objectNameLength:0 objectName:""
		
		newNode.nodeData.objectNameLength = readlong f #unsigned
		newNode.nodeData.objectName = readstring2 f newNode.nodeData.objectNameLength
		nodePadding = 0 --CalculateCNTNamePadding newNode.nodeData.objectNameLength
		for i=1 to nodePadding do
		(
			readbyte f
		)
	)
	
	newNode.numChildren = readlong f #unsigned
	newNode.children = #()
	
	for i=1 to newNode.numChildren do
	(
		append newNode.children (ImportCNTNode f newNode)
	)
	readlong f #unsigned
	--format "\"%\" has % children:\n" newNode.nodeName newNode.numChildren
	--for i=1 to newNode.children.count do
	--(
		--format "\t%: \"%\"\n" i newNode.children[i].nodeName
	--)
	return newNode
)
fn MergeCNTNodes outMesh inMesh =
(
	global mergedNodesToDelete
	if IsObjectACNT inMesh and inMesh.modifiers["CNT Hierarchy"].NodeType == "LITg" then
	(
		layerObject = LayerManager.getLayerFromName "sys_accessory_lighting_layer"
		if layerObject == undefined then
		(
			layerObject= LayerManager.newLayerFromName "sys_accessory_lighting_layer"
		)
		layerObject.addNode inMesh
	)
	else
	(
		append mergedNodesToDelete inMesh
	)
	if IsObjectACNT inMesh  and inMesh.modifiers["CNT Hierarchy"].NodeType != "MODL" and inMesh.modifiers["CNT Hierarchy"].NodeType != "SKIN" then
	(
		--format "Not Merging % in to %, it is a null\n" inMesh.name outMesh.name
	)
	else
	(
		--format "Merging % in to %\n" inMesh.name outMesh.name
			--convertTo inMesh Editable_Poly
			outMesh = outMesh + inMesh
			--delete childMesh
		
	)
	for i=1 to inMesh.children.count do
	(
		MergeCNTNodes outMesh inMesh.children[i]
	)
	
	return outMesh
)
fn ParseCNTNodes cntNode folderName importTextures:false forcePREP:false useTriStrips:false mergeMDLs: false mergeSplits: true origin:[0,0,0]=
(
	format "Parsing Node Type: %\n" cntNode.nodeType
	if cntNode.nodeType == "MODL" or cntNode.nodetype == "SKIN" then
	(
		format "This is a MESH or SKIN node!\n"
		fname = folderName + cntNode.nodeData.objectName + ".mdl"
		
	
		if ((dotnetclass "System.IO.File").exists fname) == false then
		(
			fname = CarmaSettings.DataCorePath+"\\Content\\Models\\" + cntNode.nodeData.objectName + ".mdl"
		)
		--format "Loading MDL from %\n" fname
		
		if ((dotnetclass "System.IO.File").exists fname) then
		(
			--fname = CarmaSettings.GamePath + "\\Data_core\\Content\\Models\\" + cntNode.nodeData.objectName + ".mdl"
		
			newMesh = ImportMDL fname importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs: mergeMDLs mergeSplits: mergeSplits origin:origin
			newMesh.name = cntNode.nodeName
			newMesh.transform = cntNode.combinedMatrix
		)
		else
		(
			newMesh = CreateNewNULLNode cntNode.combinedMatrix cntNode.nodeName addAttributes:false 
		)
		
		--format "Loading MDL from %\n" fname
		--newMesh = ImportMDL fname importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs: mergeMDLs mergeSplits: mergeSplits
		--newMesh.name = cntNode.nodeName
		--newMesh.transform = cntNode.combinedMatrix
		
	)
	else if cntNode.nodeType == "LITg" then
	(
		format "loading light %\n" cntNode.nodeData.objectName
		fname = folderName + cntNode.nodeData.objectName + ".light"
		newmesh = omniLight name:cntNode.nodeName
			newMesh.transform = cntNode.combinedMatrix
			newmesh.transform = matrix3 cntNode.combinedMatrix.row1 -cntNode.combinedMatrix.row3 cntNode.combinedMatrix.row2 cntNode.combinedMatrix.row4
		lightObj = CRLight()
		lightObj.LoadLight fname
		lightObj.SetToLight newMesh
	)
	else
	(
		format "This is a null node!\n"
		if (toLower cntNode.nodeName) == "wheel_fr" or (toLower cntNode.nodeName) == "wheel_fl" or (toLower cntNode.nodeName) == "wheel_rr" or (toLower cntNode.nodeName) == "wheel_rl" then
		(
			--newMesh = CreateNewWheelNode cntNode.combinedMatrix cntNode.nodeName addCNTAttributes:false
			
		)
		--else
			newMesh = CreateNewNULLNode cntNode.combinedMatrix cntNode.nodeName addAttributes:false 
	)
	format "Gone past the node setting shit\n"
	newMesh.pos = newMesh.pos + origin
	for i=1 to cntNode.numChildren do
	(
		childMesh = ParseCNTNodes cntNode.children[i] folderName importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:mergeMDLs origin:origin
		
			childMesh.parent = newMesh
		
	)
	
	cntNodeFileName = newMesh.name
	if cntNode.nodetype == "LITg" or cntNode.nodetype == "MODL" or cntNode.nodetype == "SKIN" or cntNode.nodetype == "VFXI" do cntNodeFileName = cntNode.nodeData.objectName
	SetToCNTNodes newMesh nodeType:cntNode.nodetype fileName: cntNodeFileName
	/*
	custAttributes.add newMesh CNTAttribute #unique BaseObject:true
	SetCNTNodeType newMesh cntNode.nodetype
	newMesh.CNTCustAttribute.FileName = newMesh.name
	if cntNode.nodetype == "LITG" or cntNode.nodetype == "MODL" or cntNode.nodetype == "SKIN" or cntNode.nodetype == "VFXI" do newMesh.CNTCustAttribute.FileName = cntNode.nodeData.objectName
	*/
	KeepMaxAlive()
	return newMesh
)
fn ImportCNT cnt_name importTextures:false forcePREP:false useTriStrips:false mergeMDLs:false mergeSplits:true origin:[0,0,0] =
(
	global merge_MatsIDsToNames = #()
	global merge_SubMat
	
	if mergeMDLs==true then
	(
		merge_SubMat = multisubmaterial()
		merge_SubMat.name = (getFilenameFile cnt_name) + "_MultiMat"
		merge_SubMat.count = 0
		merge_SubMat.material[1].name = "##DELETEME##"
		--format "merge_SubMat created: %\n" merge_SubMat;
	)
	
	f = fopen cnt_name "r"
	
	readCNTHeader f
	
	cntNode = ImportCNTNode f undefined
	format "Root cnt node is %\n" cntNode
	global globalMaterials = #()
	globalMaterials = #()
	global globalMaterialNames =#()
	globalMaterialNames =#()
	rootMesh = ParseCNTNodes cntNode (getFilenamePath cnt_name) importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs: mergeMDLs mergeSplits: mergeSplits origin:origin
	
	fclose f
	
	if mergeMDLs == true then
	(
		
		--format "======== merge_SubMat.material======\n"
		--PrintArrayInFull merge_SubMat.material "merge_SubMat.material"
		global mergedNodesToDelete = #()
		ConvertTo rootMesh Editable_Poly
		for i=1 to rootMesh.children.count do
		(
			rootMesh = MergeCNTNodes rootMesh rootMesh.children[i]
		)
		for i=1 to mergedNodesToDelete.count do
		(
			delete mergedNodesToDelete[i]
		)
	)
	return rootMesh
)

fn ImportMDLButtonPressed sender arg =
(
	global UseTR
	/*format "Sender:\n%\n" sender
	format "Arg:\n%\n" arg
	format "Parent Text: %\n" sender.parent.text
	for i=1 to sender.parent.controls.count do
	(
		format "Item #%: %\n" (i-1) sender.parent.controls.Item[i-1].name
	)
		format "% is checked: %\n" "ForcePREP" sender.parent.controls.Item["ForcePREP"].checked
		format "% is checked: %\n" "ImportTextures" sender.parent.controls.Item["ImportTextures"].checked
	*/
	stopwatch = dotNetObject "System.Diagnostics.Stopwatch"
	stopwatch.start()
	undo "Import C:R MDL/Light" on
	(
		oldheapfree = heapfree
		format "heapfree before: %\n" heapfree
		mdl_name = GetOpenFileName caption:"Open MDL File" types:"C:R Object (*.MDL, *.LIGHT)|*.mdl;*.light|C:R Model (*.MDL)|*.mdl|C:R Light (*.LIGHT)|*.light"
		if mdl_name != undefined do
		(
			filetype = tolower (getFilenameType mdl_name)
			if filetype == ".light" then
			(
				newmesh = omniLight name:(getFilenameFile mdl_name)
				lightObj = CRLight()
				lightObj.LoadLight mdl_name
				lightObj.SetToLight newMesh
			)
			else
			(
				global globalMaterials = #()
				globalMaterials = #()
				global globalMaterialNames =#()
				globalMaterialNames =#()
				if UseTR == true then
					ImportMDL_TR #(mdl_name) importTextures:sender.parent.controls.Item["ImportTexturesCheckbox"].checked forcePREP:sender.parent.controls.Item["ForcePrepCheckbox"].checked useTriStrips:sender.parent.controls.Item["UseTriStripsCheckbox"].checked mergeSplits:sender.parent.controls.Item["ImportMergeCheckbox"].checked
				
			--format "heapfree after tr: %\n" heapfree
		--stopwatch.stop()
		--format "----------------------------\nMDL Loaded In %:%.% ms\n" stopwatch.Elapsed.Minutes stopwatch.Elapsed.Seconds stopwatch.Elapsed.Milliseconds 
				--stopwatch.reset()
				--stopwatch.start()
				else
					ImportMDL mdl_name importTextures:sender.parent.controls.Item["ImportTexturesCheckbox"].checked forcePREP:sender.parent.controls.Item["ForcePrepCheckbox"].checked useTriStrips:sender.parent.controls.Item["UseTriStripsCheckbox"].checked mergeSplits:sender.parent.controls.Item["ImportMergeCheckbox"].checked
				--ImportMDL mdl_name importTextures:imp_textures.checked forcePREP:(imp_forcePREP.checked or imp_forceTriStrips.checked) useTriStrips:imp_forceTriStrips.checked
			)
		)
		format "heapfree after: %\n" heapfree
		format "bytes used for mdl load: %\n" (oldheapfree - heapfree)
	)
	stopwatch.stop()
	format "----------------------------\nMDL Loaded In %:%.% ms\n" stopwatch.Elapsed.Minutes stopwatch.Elapsed.Seconds stopwatch.Elapsed.Milliseconds 
	--gc() light:true
)
fn ImportCNTButtonPressed sender arg=
(
	
	undo "Import C:R CNT" on
	(
		--CreateNewNULLNode [1,1,0] 1
		cnt_name = GetOpenFileName caption:"Open CNT File" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			--ImportCNT cnt_name importTextures:imp_textures.checked forcePREP:(imp_forcePREP.checked or imp_forceTriStrips.checked) useTriStrips:imp_forceTriStrips.checked
			ImportCNT cnt_name importTextures:sender.parent.controls.Item["ImportTexturesCheckbox"].checked forcePREP:sender.parent.controls.Item["ForcePrepCheckbox"].checked useTriStrips:sender.parent.controls.Item["UseTriStripsCheckbox"].checked mergeMDLs:false mergeSplits:sender.parent.controls.Item["ImportMergeCheckbox"].checked
		)
	)
	--gc() light:true
)