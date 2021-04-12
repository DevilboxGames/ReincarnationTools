
fn writeCNTheader f =
(
	writebyte f 69 #unsigned
	writebyte f 35 #unsigned
	writebyte f 0 #unsigned
	writebyte f 4 #unsigned
)

fn writeMDLheader f =
(
	writebyte f 69 #unsigned
	writebyte f 35 #unsigned
	writebyte f 2 #unsigned
	writebyte f 6 #unsigned
)

fn AdjEdgeSortByRefB e1 e2 =
(
	case of
	(
		(e1.refb < e2.refb): -1
		(e1.refb > e2.refb): 1
		default: 0
	)
)
fn AdjEdgeSortByRefA e1 e2 =
(
	case of
	(
		(e1.refa < e2.refa): -1
		(e1.refa > e2.refa): 1
		default: 0
	)
)
fn AdjEdgeSortByFace e1 e2 =
(
	case of
	(
		(e1.face < e2.face): -1
		(e1.face > e2.face): 1
		default: 0
	)
)

octree = undefined 

fn AdjEdgeSortAll &arrayToSort =
(
	sorted = #()
	--print "Sorting Edge Array"
	--format "\nOriginal array size: %\n" arrayToSort.count
	--format "Original array:\n%\n" arrayToSort
	firstPass = deepcopy arrayToSort
	qsort firstPass AdjEdgeSortByRefb 
	--format "\nFirst Pass size: %\n" firstPass.count
	--format "First Pass:\n%\n" firstPass
	-- PrintArrayInFull firstPass "First Pass"
	secondPass = #()
	currentRefB = firstPass[1]
	
	tmp = #()
	for i=1 to firstPass.count do
	(
		if currentRefB == firstPass[i].refb then
		(
			append tmp firstPass[i]
		)
		else
		(
			qsort tmp AdjEdgeSortByRefA 
			join secondPass tmp
			tmp=#()
			append tmp firstPass[i]
			currentRefB = firstPass[i].refb
		)
	)
	qsort tmp AdjEdgeSortByRefA 
	join secondPass tmp
	tmp=#()
	--format "\nSecond Pass: %\n" secondPass.count
	--format "Second Pass:\n%\n" secondPass
	
	-- PrintArrayInFull secondPass "Second Pass"
	
	currentRefB = secondPass[1].refb
	currentRefA = secondPass[1].refa
	
	for i=1 to secondPass.count do
	(
		if currentRefB == secondPass[i].refb and currentRefA == secondPass[i].refa then
		(
			append tmp secondPass[i]
		)
		else
		(
			qsort tmp AdjEdgeSortByFace 
			join sorted tmp
			tmp=#()
			append tmp secondPass[i]
			currentRefB = secondPass[i].refb
			currentRefA = secondPass[i].refa
		)
	)
	qsort tmp AdjEdgeSortByFace 
	join sorted tmp
	
	free tmp
	free firstPass
	free secondPass
	--gc()
	--format "\nThird Pass: %\n" sorted.count
	--format "Third Pass:\n%\n" sorted
	
	-- PrintArrayInFull sorted "Final Pass"
	sorted
)
fn FindAdjacentTriEdge tri v1 v2 =
(
	result = 255
	if tri.ref[1] == v1 and tri.ref[2] == v2 do result= 1
	if tri.ref[1] == v2 and tri.ref[2] == v1 do result=1
		
	if tri.ref[1] == v1 and tri.ref[3] == v2 do result=2
	if tri.ref[1] == v2 and tri.ref[3] == v1 do result=2
		
	if tri.ref[2] == v1 and tri.ref[3] == v2 do result=3
	if tri.ref[2] == v2 and tri.ref[3] == v1 do result=3
		
	result
)

fn FindOppositeTriVert tri v1 v2 =
(
	result=-1
	if tri.ref[1] == v1 and tri.ref[2] == v2 do result= 3
	if tri.ref[1] == v2 and tri.ref[2] == v1 do result= 3
		
	if tri.ref[1] == v1 and tri.ref[3] == v2 do result= 2
	if tri.ref[1] == v2 and tri.ref[3] == v1 do result= 2
		
	if tri.ref[2] == v1 and tri.ref[3] == v2 do result= 1
	if tri.ref[2] == v2 and tri.ref[3] == v1 do result= 1
		
	result
)

fn CreateAdjacencyDB faceCount &indexBuffer =
(
	global AdjTris
	global AdjEdges
	if AdjTris == undefined then AdjTris = #()
	else
	(
		free AdjTris
		AdjTris = #()
	)
	if AdjEdges == undefined then AdjEdges = #()
	else
	(
		free AdjEdges
		AdjEdges = #()
	)
	--gc()
	currentFace = 1
	currentEdge = 1
	edgeCount = 0
	indexBufferCount = indexBuffer.count
	
	--format "IndexBufferCount: %\n" indexBufferCount
	--format "FaceCount: %\n" faceCount
	
	for i=0 to (faceCount-1) do
	(
		ind1 = i * 3 + 1
		ind2 = i * 3 + 3
		ind3 = i * 3 + 2
		tri1 = -1
		tri2 = -1
		tri3 = -1
		vind1 = indexBuffer[ind1]
		vind2 = indexBuffer[ind2]
		vind3 = indexBuffer[ind3]
		--if ind1 > indexBufferCount or ind2 > indexBufferCount or ind3 > indexBufferCount do exit
		newTri = AdjacentTriangle ref: #(vind1, vind2, vind3) tri: #(tri1, tri2, tri3)
		--format "newTri: %\n" newTri
		append AdjTris newTri
		if vind1 < vind2 then
		(
			newEdge = AdjacentEdge refa: vind1 refb: vind2 face: currentFace
			currentEdge = currentEdge + 1
			edgeCount = edgeCount + 1
			append AdjEdges newEdge
		)
		else 
		(
			newEdge = AdjacentEdge refa: vind2 refb: vind1 face: currentFace
			currentEdge = currentEdge + 1
			edgeCount = edgeCount + 1
			append AdjEdges newEdge
		)
		if vind1 < vind3 then
		(
			newEdge = AdjacentEdge refa: vind1 refb: vind3 face: currentFace
			currentEdge = currentEdge + 1
			edgeCount = edgeCount + 1
			append AdjEdges newEdge
		)
		else 
		(
			newEdge = AdjacentEdge refa: vind3 refb: vind1 face: currentFace
			currentEdge = currentEdge + 1
			edgeCount = edgeCount + 1
			append AdjEdges newEdge
		)
		if vind2 < vind3 then
		(
			newEdge = AdjacentEdge refa: vind2 refb: vind3 face: currentFace
			currentEdge = currentEdge + 1
			edgeCount = edgeCount + 1
			append AdjEdges newEdge
		)
		else 
		(
			newEdge = AdjacentEdge refa: vind3 refb: vind2 face: currentFace
			currentEdge = currentEdge + 1
			edgeCount = edgeCount + 1
			append AdjEdges newEdge
		)
		
		currentFace = currentFace + 1
	)
	
	Sorted = AdjEdgeSortAll &AdjEdges
	
	--qSort Sorted AdjEdgeSortByRefB
	--qSort Sorted AdjEdgeSortByRefA
	--qSort Sorted AdjEdgeSortByFace
	
	--format "AdjEdges: \n%\n" AdjEdges
	--format "Sorted: \n%\n" Sorted
	
	local lastRefA = Sorted[1].refa
	local lastRefB = Sorted[1].refb
	
	
	--PrintArrayInFull AdjEdges "AdjEdges"
	--PrintArrayInFull Sorted "Sorted"
	
	local count = 0
	tmp = #()
	--print "Starting Edge Looping"
	for i=1 to edgeCount do
	(
		local face = Sorted[i].face
		local refa = Sorted[i].refa
		local refb = Sorted[i].refb
		--format "%:\tface: %\t\trefa: %\t\trefb: %\n" i face refa refb
		--format "\t\t\tlastrefa: %\tlastrefb: %\n" lastRefA lastRefB
		--print "\n-------\n"
		--format "Loop: % Face: %\n" i face
		--format "Refa: % Refb: %\n" refa refb
		--format "lastRefA: % lastRefB: %\n" lastRefA lastRefB
		--format "Count: % \n" count
		
		if refa == lastRefA and refb == lastRefB then
		(
			--print "found matching edge"
			count = count+1
			tmp[count] = face
		)
		else 
		(
			--print "not matching edge"
			if count == 2 then
			(
				--print "count is 2 so collecting"
				triInd1 = tmp[1]
				triInd2 = tmp[2]
				--format "Edge #% is connected to edge #%, setting connection between face % and face %\n" (i-2) (i-1) triInd1 triInd2
				tri1 = AdjTris[triInd1]
				tri2 = AdjTris[triInd2]
				--format "triInd1: % triInd2: %\n" triInd1 triInd2
				--format "tri1: % tri2: %\n" tri1 tri2
				
				edge1 = FindAdjacentTriEdge tri1 lastRefA lastRefB
				edge2 = FindAdjacentTriEdge tri2 lastRefA lastRefB
				
				
					
				
				--format "edge1: % edge2: %" edge1 edge2
				
				AdjTris[triInd1].tri[edge1] = triInd2
				AdjTris[triInd2].tri[edge2] = triInd1
				
			)
			--else format "Edge #% has no connection, skipping\n" (i-1)
			
			count = 0
			count = count+1
			tmp[count] = face
			lastRefA = refa
			lastRefB = refb
		)
	)
	if count == 2 then
	(
		
				--format "Edge #% is connected to edge #%, setting connection\n" (edgeCount-1) edgeCount
				triInd1 = tmp[1]
				triInd2 = tmp[2]
				tri1 = AdjTris[triInd1]
				tri2 = AdjTris[triInd2]
				
				edge1 = FindAdjacentTriEdge tri1 lastRefA lastRefB
				edge2 = FindAdjacentTriEdge tri2 lastRefA lastRefB
				
				AdjTris[triInd1].tri[edge1] = triInd2
				AdjTris[triInd2].tri[edge2] = triInd1
		
				--format "edge1: %\tedge2: %\ttriInd1: %\ttriInd2: %\n\ttri1: %\ttri2: %\n-----\n" edge1 edge2 triInd1 triInd2 tri1 tri2
				
	)
	--else format "Edge #% has no connection, skipping\n" edgeCount
	--free tmp
	
	--gc()
	--PrintArrayInFull AdjTris "AdjTris"
	--print "AdjacencyDB Done!"
)

fn TrackStrip face oldest middle &strip &faces tags offset =
(
	global AdjTris
	len = 2
	faceCount = 1
	--format "TrackStrip:\tface: %\toldest: %\tmiddle:%\n" face oldest middle
	if 1 + offset <= strip.count then
	(
		strip[1 + offset] = oldest
	)
	else
	(
		append strip oldest
	)
	
	if 2 + offset <= strip.count then
	(
		strip[2 + offset] = middle
	)
	else
	(
		append strip middle
	)
	--format "TrackStrip:\tface: %\toldest: %\tmiddle:%\n" face oldest middle
	
	bDoTheStrip = true
	oldFace = face
	itteration = 0
	while bDoTheStrip do
	(
		itteration=itteration+1
		
		newestIndex = FindOppositeTriVert (AdjTris[face]) oldest middle
		newest = AdjTris[face].ref[newestIndex]
		--format "TrackStrip Itteration %:\n\toldest: %\t\tmiddle: %\t\tnewest: %\t\tnewesstIndex: %\n" itteration oldest middle newest newestIndex
		
		
		len = len + 1
		if len + offset <= strip.count then
		(
			strip[len+offset] = newest
		)
		else append strip newest
		
		if faceCount + offset <= faces.count then
		(
			faces[faceCount+offset] = face
		)
		else append faces face
		faceCount = faceCount + 1
		
		
		tags[face] = true
		curEdge = FindAdjacentTriEdge AdjTris[face] middle newest
		local tri = AdjTris[face]
		triLink = AdjTris[face].tri[curEdge]
		
		if triLink == -1 then
		(
			--format "Trilink = -1, stopping stipper\n"
			bDoTheStrip = false
		)
		else
		(
			oldFace=face
			face = triLink
			if tags[face] == true do bDoTheStrip = false
		)
		
		oldest = middle
		middle = newest
	)
	len
)

fn ComputeBestStrip face faceCount indices &tags &strips =
(
	--print "Computing Best Strip"
	strip = #()
	strip[1] = #()
	strip[2] = #()
	strip[3] = #()
	faces = #()
	faces[1] = #()
	faces[2] = #()
	faces[3] = #()
	
	len = #()
		
	firstLen = #()
	refs1 = #()
	refs2 = #()
	
	--PrintArrayInFull AdjTris "AdjTris"
	
	refs1[1] = AdjTris[face].ref[1]
	refs2[1] = AdjTris[face].ref[2]
	
	refs1[2] = AdjTris[face].ref[3]
	refs2[2] = AdjTris[face].ref[1]
	
	refs1[3] = AdjTris[face].ref[2]
	refs2[3] = AdjTris[face].ref[3]
	
	--PrintArrayInFull refs1 "refs1"
	--PrintArrayInFull refs2 "refs2"
	
	for j=1 to 3 do
	(
		--format "\n\nComputeBestStrip loop #%\n" j
		strip[j] = #()
		faces[j] = #()
		
		
		ltags = deepcopy tags
		--format "Calling TrackStrip on\tface: %\trefs1[%]: %\trefs2[%]: %\n\n" face j refs1[j] j refs2[j]
		len[j] = TrackStrip face refs1[j] refs2[j] &strip[j] &faces[j] ltags 0
		--format "\n strip % length: %\n" j len[j]
		firstLen[j] = len[j]
		
		--PrintArrayInFull strip[j] "Strip for this loop"
		--PrintArrayInFull faces[j] "Faces for this loop"
		--format "FirstLen: % \tLen: %\n" firstLen[j] len[j]
		for i=1 to (len[j] / 2) do
		(
			t = strip[j][i]
			k = len[j] - (i-1)
			strip[j][i] = strip[j][k]
			strip[j][k] = t
		)
		
		for i=1 to ((len[j] - 2) / 2) do
		(
			t = faces[j][i]
			k = len[j] - (i-1) - 2
			faces[j][i] = faces[j][k]
			faces[j][k] = t
		)
		--PrintArrayInFull strip[j] "Strip for this loop after swapping"
		--PrintArrayInFull faces[j] "Faces for this loop after swapping"
		
		newRef1 = strip[j][len[j] - 2]
		newRef2 = strip[j][len[j] - 1]
		--format "\nCalling TrackStrip again on\tface: %\tnewRef1: %\tnewRef2: %\t\toffset: %\n\n" face newRef1 newRef2 (len[j]-3)
		extraLen = TrackStrip face newRef1 newRef2 &strip[j] &faces[j] ltags (len[j] - 3)
		--format "ComputeBestStrip itteration % extraLen: %\n" j extraLen
		len[j] = len[j] + extraLen - 3
		--PrintArrayInFull strip[j] "Strip for this loop after second TrackStrip"
		--PrintArrayInFull faces[j] "Faces for this loop after second TrackStrip"
		--format "ExtraLen: % \tLen: %\n" extraLen len[j]
	)
	bestLen = len[1]
	best = 1
	if bestLen < len[2] do 
	(
		bestLen = len[2]
		best = 2
	)
	if bestLen < len[3] do 
	(
		bestLen = len[3]
		best = 3
	)
	--PrintArrayInFull len "len array"
	nFaces = bestLen - 2
	
	--print "------\nThis is the tags array before setting faces to true:"
	--PrintArrayInFull tags "Tags:" ignoreUndefined:true
	
	--PrintArrayInFull strip[1] "Strip[1]"
	--PrintArrayInFull strip[2] "Strip[2]"
	--PrintArrayInFull strip[3] "Strip[3]"
	
	for j=1 to bestLen-2 do
	(
		tags[faces[best][j]] = true
	)
	
	--print "------\nAnd after:"
	--PrintArrayInFull tags "Tags:" ignoreUndefined:true
	--print "------\n"
	
	if (bit.and firstLen[best] 1) == 1 do
	(
		if bestLen == 3 or bestLen == 4 then
		(
			t = strip[best][2]
			strip[best][2] = strip[best][3]
			strip[best][3] = t
			--strip[best][2] = bit.xor strip[best][2] strip[best][3]
			--strip[best][3] = bit.xor strip[best][3] strip[best][2]
			--strip[best][2] = bit.xor strip[best][2] strip[best][3]
		)
		else
		(
			for i=1 to bestLen / 2 do
			(
				t = strip[best][i]
				strip[best][i] = strip[best][bestLen - (i-1)]
				strip[best][len[best] - (i-1) ] = t
			)
			
			if (bit.and (bestLen - firstLen[best]) 1) == 1 do
			(
				insertItem strip[best][1] strip[best] 1
				bestLen = bestLen + 1
			)
			/*t = strip[best][1]
			strip[best][1] = strip[best][2]
			strip[best][2] = t*/
		)
	)
	append strips (deepcopy strip[best])
	--free strip
	--free faces
	
	--free len
	--free firstLen
	--free refs1
	--free refs2
	--gc()
	
	--format "nFaces from this strip: %\n" nFaces
	nFaces
)

fn MergeStrips &strips =
(
	--print "Merge Strips"
	bFirst = true
	previousStrip = 1
	mergedStrip = #()
	removeOldStrip = #()
	
	for k=1 to strips.count do
	(
		if strips[k].count == 3 do
		(
			removeOldStrip[k] = false
			continue
		)
		
		if bFirst==false do
		(
			lastRef = strips[previousStrip][strips[previousStrip].count]
			firstRef = strips[k][1]
			
			append mergedStrip lastRef
			append mergedStrip firstRef
			
			if (bit.and mergedStrip.count 1) == 1 do
			(
				secondRef = strips[k][2]
				
				if firstRef != secondRef then
				(
					append mergedStrip firstRef
				)
				else
				(
					deleteItem strips[k] 1
				)
			)
		)
		
		join mergedStrip strips[k]
		
		bFirst = false
		previousStrip = k
		removeOldStrip[k]= true
	)
	
	--format "strips.count = % \n removeOldStrip.count = %\n" strips.count removeOldStrip.count
	for i=strips.count to 2 by -1 do
	(
		if removeOldStrip[i] do 
		(
			deleteItem strips i
		)
	)
	insertItem mergedStrip strips 1
	
	--free mergedStrip
	--free removeOldStrip
	--gc()
)

fn StripperShakeItBaby faceCount &indices =
(
	--print "Shake It Baby!"
	strips = #()
	CreateAdjacencyDB faceCount &indices
	
	tags = #()
	connectivity = #()
	for i=1 to faceCount do
	(
		connectivity[i] = i
	)
	
	nStrips = 0
	totalFaces = 0
	index = 1
	loopnum=1
	loopsWithoutChange = 0
	while totalFaces < faceCount do
	(
		while tags[index] == true do
		(
			index=index+1
		)
		
		firstFace = connectivity[index]
		--format "First Face of loop #% is: %\n" loopnum firstFace
		bestStripFaces = ComputeBestStrip firstFace faceCount indices &tags &strips
		if bestStripFaces <= 0 do loopsWithoutChange = loopsWithoutChange+1
		totalFaces = totalFaces + bestStripFaces
		nStrips = nStrips + 1
		--format "TotalFaces on loop %: %\n" loopnum totalFaces
		--format "FaceCount: %\n" faceCount
		loopnum = loopnum + 1
		if loopsWithoutChange > 15 do
		(
			print "OMG! Infinite Loop! Exiting!"
			exit
		)
	)
	--gc()
	--for i =1 to strips.count do
	--(
			--stripname = stringstream""
			--format "RawStrips[%]" i to:stripname
			--PrintArrayInFull strips[i] (stripname as string)
	--)
	--format "Number Of Strips Before Merge: %\n" strips.count
	MergeStrips &strips
	
	--free tags
	--free connectivity
	--format "Number Of Strips After Merge: %\n" strips.count
	--gc()
	strips
)

fn ExportMTLMaterial mtlfilename mat = (

		--Format "Exporting MTL to %\n" mtlfilename
	if (custAttributes.get mat mtlmat_ca) != undefined then
	(
		mtl = MTLFile()
		mtl.GetFromMaterial mat
		mtl.Save mtlfilename
	)
	else (
		Format "Error exporting MTL to %: CA doesn't exist!\n" mtlfilename
	)
)

struct OtherTexturesDef (
	TextureName,
	Alias
)

fn ExportMaterial folder materialName bitmapName baseMaterial:"simple_base" diffuseAlias:"DiffuseColour" otherTextures:#() =
(
	dotNet.loadAssembly "system.xml"
	xmlDoc=dotNetObject "system.xml.xmlDocument"
	--format "exporting mat %\\%\n.mt2" folder materialName
	
	
	xmlRoot = xmlDoc.CreateElement "Material"
	xmlDoc.AppendChild xmlRoot
	
	xmlDecl = xmlDoc.CreateXmlDeclaration "1.0" "" ""
	xmlDoc.InsertBefore xmlDecl xmlRoot
	
	xmlBaseOff = xmlDoc.CreateElement "BasedOffOf"
	xmlBaseOff.setAttribute "Name" baseMaterial
	xmlRoot.AppendChild xmlBaseOff
	
	xmlBaseOff = xmlDoc.CreateElement "DoubleSided"
	xmlBaseOff.setAttribute "Value" "TRUE"
	xmlRoot.AppendChild xmlBaseOff
	
	xmlPass = xmlDoc.CreateElement "Pass"
	xmlPass.SetAttribute "Number" "0"
	--xmlRoot.AppendChild xmlPass
	
	xmlTexture = xmlDoc.CreateElement "Texture"
	xmlTexture.SetAttribute "Alias" diffuseAlias
	if bitmapName != undefined and bitmapName != "" then textureFileName = getFilenameFile bitmapName
	else textureFileName = "NOTEXTURE"
	xmlTexture.SetAttribute "FileName" textureFileName

	xmlRoot.AppendChild xmlTexture
	if otherTextures != undefined then (
		for  otherTexture in otherTextures do (
			xmlOtherTexture = xmlDoc.CreateElement "Texture"
			xmlOtherTexture.SetAttribute "Alias" otherTexture.Alias
			if otherTexture.TextureName != undefined and otherTexture.TextureName != "" then textureFileName = getFilenameFile otherTexture.TextureName
			else textureFileName = "NOTEXTURE"
			xmlOtherTexture.setAttribute "FileName" textureFileName

			xmlRoot.AppendChild xmlOtherTexture
		)
	)

	
	xmlDoc.Save (folder+materialName+".MT2")
	
	free xmlDoc
	free xmlRoot
	free xmlDecl
	free xmlDoubleSided
	free xmlBaseOff
	free xmlPass
	free xmlTexture
	--gc()
)
fn ExportMaterialsAndTextures outputFolder exportTextures:true exportMats:true funsizeExport:false onlyUsedByMesh:undefined baseMaterial:"simple_base" diffuseAlias:"DiffuseColour" transparentDiffuseAlias:"DiffuseColour" baseTransparentMaterial:"glass_base" alphaTextureName:"" alphaTextureIndex:0 forceAlphaReplacement:false =
(
	global MaterialsToExport
	if(MaterialsToExport==undefined) then (
		MaterialsToExport = #()
	)
	bitmaps = #()
	rawBitmaps = #()
	rawAlphas = #()
	--print MaterialsToExport
	for i=1 to MaterialsToExport.count do
	(
		mtlName = MaterialsToExport[i][1]
		baseMat = baseMaterial
		diffAlias = diffuseAlias
		actualMat = MaterialsToExport[i][2]
		bitmapFileName = undefined
		oppactiyMapFileName = undefined

		if actualMat != undefined and actualMat.diffuseMap != undefined and (classof actualMat.diffuseMap) == bitmaptexture then
		(
			bitmapFileName = actualMat.diffuseMap.filename
		)
		if actualMat != undefined and actualMat.OpacityMap != undefined and (classof actualMat.OpacityMap) == bitmaptexture then
		(
			baseMat = baseTransparentMaterial
			diffAlias = transparentDiffuseAlias
		)
		if bitmapFileName!=undefined and exportTextures do
		(
			append bitmaps bitmapFileName
			append rawbitmaps bitmapFileName
			if actualMat.opacityMap == undefined then (
				append rawAlphas true
			)
			else (
				append rawAlphas false
			)
		)
		if exportMats do
		(
			--format "Exporting mat %" mtlName
			if funsizeExport then (
				--format " as MTL\n"
				ExportMTLMaterial (outputFolder+mtlName+".mtl") actualMat
			)
			else  (
				--format " as MT2\n"
				ExportMaterial outputFolder mtlName bitmapFileName baseMaterial:baseMat otherTextures:MaterialsToExport[i][3] diffuseAlias:diffAlias
			)
		)
	)
	if bitmaps.count > 0 then (
		makeUniqueArray bitmaps
		
		if funsizeExport then (
			alphas = #()
			for bmp in bitmaps do (
				append alphas rawAlphas[(findItem rawBitmaps bmp)]
			)
			ConvertIMG = dotnetclass "IMGToolLib.IMGTool"
			ConvertIMG.ConvertToIMG bitmaps outputFolder null
		)
		else  (
			for bitmapFilename in bitmaps do (
				alphaTex = alphaTextureName
				--format "converting texture % using % for alpha\n" bitmapFilename alphaTex
				bmp = openBitMap bitmapFilename
				if bmp.hasAlpha and forceAlphaReplacement == false then (
					alphaTex = ""
					--format "removing alpha image"
				)
				ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
				ConvertTDX.Convert bitmapFileName outputFolder 5 alphaTex alphaTextureIndex
			)
		)
	)
	--gc()
)

fn MaterialAlreadySetToExport matName =
(
	result = false
	global MaterialsToExport
	if(MaterialsToExport == undefined) then
		(
			MaterialsToExport = #()
		)
	for i=1 to MaterialstoExport.count do
	(
		if MaterialsToExport[i][1] == matName do result = true
	)
	result
)

fn TestStripper mO =
(
	m = snapshotasmesh mO
	numFaces  = getNumFaces m
	vertInds = #()
	for i=1 to numFaces do
	(
		inds = getFace m i
		format "%: [%,%,%]\n" i inds.x inds.y inds.z
		append vertInds (inds.x as integer)
		append vertInds (inds.y as integer)
		append vertInds (inds.z as integer)
	)
	format "vertinds:\n"
	for i=1 to vertinds.count by 3 do
	(
	format "[%, %, %]\n " vertInds[i] vertInds[i + 1] vertInds[i + 2]
	)
	strips = StripperShakeItBaby numFaces &vertInds
	
	for i=1 to strips.count do
	(
		format "\nStrip %\n" i
		format "Strip count %\n" strips[i].count
		format "Strip contents\n"
		for p=1 to strips[i].count do
		(
		format "%\n " strips[i][p]
		)
	)
	if strips[1].count > strips[2].count then tmp = strips[2].count
	else tmp = strips[1].count
	for i=1 to tmp do
	(
		asdf = "false"
		if strips[1][i] == strips[2][i] then asdf = "true"
		format "% \t\t %\t%\n" strips[1][i] strips[2][i] asdf
	)

	nm = mesh name:"stripped mesh"
	setnumverts nm (getnumverts m)
	
	nm
)
fn ExportMDLMesh folder_name model forcedFilename:""  exportMats:false exportTextures:false funsizeExport:false  createOctree:false =
(
	OctreeVerts = #()
	PREPVerts = #()
	PREPFaces = #()
	USERVerts = #()
	USERFaces = #()
	USER2PREPvertConv = #()
	USER2PREPfaceConv = #()
	PREP2USERvertConv = #()
	PREP2USERfaceConv = #()
	
	mtl = #()
	mtlconv = #()
	mid = #()
	meshes = #()
	
	oldTransform = copy model.transform
	oldScale = model.scale
	model.transform = matrix3 1
	if model.modifiers["CNT Hierarchy"] != undefined and model.modifiers["CNT Hierarchy"].BakeScaleIntoMesh == true then model.scale = oldScale
	
	model_name = model.name
	if IsObjectACNT model then model_name = model.modifiers["CNT Hierarchy"].FileName
	if forcedFilename!="" then 
	(
		mdl_name=forcedFilename
		outputFolder = GetFilenamePath mdl_name
	)
	else
	(
		mdl_name = folder_name+model_name+".mdl"
		outputFolder = folder_name
	)
	mdl_file = openfile mdl_name mode:"w"
	close mdl_file
	
	select model
	max modify mode
	normalMod = Edit_Normals()
	addModifier model normalMod

	--if meshop.getNumMaps model > 2 and meshop.getNumMapVerts m 2 > 0 then meshop.buildMapFaces model 2 keep:true
	m = snapshotasmesh model
	if (getNumTVerts m) < 1 then (
		setNumTVerts m ((getNumFaces m) * 3)
		buildTVFaces m
	)
	meshop.buildMapFaces m 1 keep:true
	
	numFaces  = getNumFaces m
	tv_count = getNumTVerts m
	vertNormals = #()
	meshHasVertColours = false
	meshHasTextureVerts = false
	if (getNumCPVVerts m) > 0 then
	(
		meshHasVertColours = true
	)
	if tv_count != 0 then
	(
		meshHasTextureVerts = true
	)
	
	stripOffset = 0
	patchOffset = 0
	numAxisNegativeScale = 0
	mirroredTransformScale = [-1,1,1]
	mirroredNormalTransformScale = [-1,1,1]
	normOldScale = normalize oldScale
	
	if normOldScale.x < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredNormalTransformScale.x = 1
	)
	if normOldScale.y < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredNormalTransformScale.y = -1
	)
	if normOldScale.z < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredNormalTransformScale.z = -1
	)
	
    PREPFaceVerts = #()
	for i=1 to (getNumVerts m) do
	(
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		pos = (getVert m i) * mirroredTransformScale
				
		append USERVerts (mdlUserVert x:pos.x y:pos.y  z:pos.z TimesUsed: 1)
	)
	pos = undefined
	--gc()
	
	vertNormals =#()
	faceIndicesForNormals =#()
	newVertsList = #()
	faceNewVertInds = #()
	faceIndicesForTVs =#()
	facesForMatID = #()
	tvToUSERVerts = #()
	for i=1 to numFaces do
	(
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		--if (mod i 5000) == 0 then gc()
		faceCVerts = undefined
		faceTVertInds = undefined
		
		vertInds = getFace m i
		if meshHasVertColours do faceCVerts = getVCFace m i
		if meshHasTextureVerts then faceTVertInds = getTVFace m i
		else faceTVertInds = vertInds
		--format "Face % uses vert inds % and tvertinds %\n" i vertinds tvertinds
		faceMatID = getfacematid m i
		if faceMatID >= 65536 then (
			faceMatID = 1
		)
		if (classof  model.material) == multimaterial and model.material.materiallist[faceMatID] == undefined then
		(
			--format "Face % has matID % which is not in material\n" i faceMatID
		)
		norm1 = normalMod.GetNormal (normalMod.GetNormalID i 1)
		norm2 = normalMod.GetNormal (normalMod.GetNormalID i 2)
		norm3 = normalMod.GetNormal (normalMod.GetNormalID i 3)
		rNorms = #(norm1, norm2, norm3) --meshop.getFaceRNormals m i
			if numAxisNegativeScale == 0 or numAxisNegativeScale == 2 then
			(
				
				t = vertInds.y
				vertInds.y = vertInds.z
				vertInds.z = t
				if faceTVertInds != undefined do
				(
					u = faceTVertInds.y
					faceTVertInds.y = faceTVertInds.z
					faceTVertInds.z = u
				)
				if faceCVerts != undefined do
				(
					c = faceCVerts.y
					faceCVerts.y = faceCVerts.z
					faceCVerts.z = c
				)
				n = rNorms[2]
				rNorms[2] = rNorms[3]
				rNorms[3] = n
			)
			else
			(
				--VertInd1 = vertInds.x
				--VertInd2 = vertInds.z
				--VertInd3 = vertInds.y
			)
				VertInd1 = vertInds.x
				VertInd2 = vertInds.y
				VertInd3 = vertInds.z
		
		tvToUSERVerts[faceTVertInds.x] = vertInds.x
		tvToUSERVerts[faceTVertInds.y] = vertInds.y
		tvToUSERVerts[faceTVertInds.z] = vertInds.z
		faceIndicesForTVs[i] = #(faceTVertInds.x, faceTVertInds.y, faceTVertInds.z)
		
		v1Data = [USERVerts[vertInds.x].x,USERVerts[vertInds.x].y,USERVerts[vertInds.x].z]
		v2Data = [USERVerts[vertInds.y].x,USERVerts[vertInds.y].y,USERVerts[vertInds.y].z]
		v3Data = [USERVerts[vertInds.z].x,USERVerts[vertInds.z].y,USERVerts[vertInds.z].z]

		if length (v2Data - v1Data) < 0.001 or  length (v3Data - v1Data) < 0.001 or  length (v2Data - v3Data) < 0.001 then
		(
			--format "Face % is degenerate, skipping\n" i
			--continue
		)
		
		planeNormal = (cross (v2Data - v1Data) (v3Data - v1Data)) * mirroredNormalTransformScale
		planeD = dot planeNormal v1Data
		if faceCVerts == undefined then
		(
			v1Colour = color 0 0 0 0
			v2Colour = color 0 0 0 0
			v3Colour = color 0 0 0 0
		)
		else
		(
			v1Colour = getVertColor m faceCVerts[1]
			v2Colour = getVertColor m faceCVerts[2]
			v3Colour = getVertColor m faceCVerts[3]
		)
		
		v1Norm = getNormal m vertInds.x
		v2Norm = getNormal m vertInds.y
		v3Norm = getNormal m vertInds.z
		
		if meshHasTextureVerts==false or  faceTVertInds == undefined then
		(
			v1U = 0
			v1V = 0
			v2U = 0
			v2V = 0
			v3U = 0
			v3V = 0
		)
		else
		(
			tv1 = getTVert m faceTVertInds.x
			tv2 = getTVert m faceTVertInds.y
			tv3 = getTVert m faceTVertInds.z
			
			
			v1U = tv1.x
			v1V = tv1.y
			v2U = tv2.x
			v2V = tv2.y
			v3U = tv3.x
			v3V = tv3.y
		)
		if (meshop.getNumMaps m) == 2 then
		(
			v1U2 = 0
			v1V2 = 0
			v2U2 = 0
			v2V2 = 0
			v3U2 = 0
			v3V2 = 0
		)
		else
		(
			secondUVMapFace= meshop.getMapFace m 2 i
			
			mv1 = meshop.getMapVert m 2 secondUVMapFace.x
			mv2 = meshop.getMapVert m 2 secondUVMapFace.y
			mv3 = meshop.getMapVert m 2 secondUVMapFace.z
			
			v1U2 = mv1.x
			v1V2 = mv1.y
			v2U2 = mv2.x
			v2V2 = mv2.y
			v3U2 = mv3.x
			v3V2 = mv3.y
		)
		
		smoothingGroup = getFaceSmoothGroup m i
		
		rNorms[1] = normalize (rNorms[1] * mirroredNormalTransformScale)
		rNorms[2] = normalize (rNorms[2] * mirroredNormalTransformScale)
		rNorms[3] = normalize (rNorms[3] * mirroredNormalTransformScale)
		
		if(vertNormals[faceTVertInds.x] == undefined) do
		(
			vertNormals[faceTVertInds.x] = #()
			faceIndicesForNormals[faceTVertInds.x] = #()
		)
		if(vertNormals[faceTVertInds.y] == undefined) do 
		(
			vertNormals[faceTVertInds.y] = #()
			faceIndicesForNormals[faceTVertInds.y] = #()
		)
		if(vertNormals[faceTVertInds.z] == undefined) do 
		(
			vertNormals[faceTVertInds.z] = #()
			faceIndicesForNormals[faceTVertInds.z] = #()
		)
		
		if (finditem vertNormals[faceTVertInds.x] rNorms[1])==0 then
		(	
			append vertNormals[faceTVertInds.x] rNorms[1]
			faceIndicesForNormals[faceTVertInds.x][vertNormals[faceTVertInds.x].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[faceTVertInds.x][(finditem vertNormals[faceTVertInds.x] rNorms[1])] i
		)
		if (finditem vertNormals[faceTVertInds.y] rNorms[2])==0 then
		(
			append vertNormals[faceTVertInds.y] rNorms[2]
			faceIndicesForNormals[faceTVertInds.y][vertNormals[faceTVertInds.y].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[faceTVertInds.y][(finditem vertNormals[faceTVertInds.y] rNorms[2])] i
		)
		if (finditem vertNormals[faceTVertInds.z] rNorms[3])==0 then
		(
			append vertNormals[faceTVertInds.z] rNorms[3]
			faceIndicesForNormals[faceTVertInds.z][vertNormals[faceTVertInds.z].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[faceTVertInds.z][(finditem vertNormals[faceTVertInds.z] rNorms[3])] i
		)
		
		if facesForMatID[faceMatID] == undefined do facesForMatID[faceMatID] = #()
		
		append facesForMatID[faceMatID] i
		
		
		USERFace =  mdlUserFace PlaneD:planeD PlaneX:-planeNormal.x PlaneY:planeNormal.z PlaneZ:-planeNormal.y SmoothingGroup:smoothingGroup MaterialIndex:faceMatID v1Colour:v1Colour v2Colour:v2Colour v3Colour:v3Colour v1:VertInd1  v2:VertInd2  v3:VertInd3 v1NormX:rNorms[1].x v1NormY:rNorms[1].y v1NormZ:rNorms[1].z v2NormX:rNorms[2].x v2NormY:rNorms[2].y v2NormZ:rNorms[2].z v3NormX:rNorms[3].x v3NormY:rNorms[3].y v3NormZ:rNorms[3].z v1U:v1U v1V:v1V v1U2:v1U2 v1V2:v1V2 v2U:v2U v2V:v2V v2U2:v2U2 v2V2:v2V2 v3U:v3U v3V:v3V v3U2:v3U2 v3V2:v3V2
		
		append USERFaces USERFace
		append mid faceMatID
	)
	if meshHasTextureVerts == false then tv_count = USERVerts.count
	--gc()
	faceNewVertIndsOldToNew = #()
	--messageBox ("TV Count = "+(tv_count as string)) title:"Debug Box"
	count = 0
	for i=1 to tv_count do
	(
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
		--pos = [USERVerts[tvToUSERVerts[i]].x,USERVerts[tvToUSERVerts[i]].y,USERVerts[tvToUSERVerts[i]].z]
		--normalsForThisVert = vertNormals[i]
		--faceIndicesForThisVert = faceIndicesForNormals[i]
		--facesForVert = meshop.getFacesUsingVert m #(i)
		
		for j=1 to vertNormals[i].count do
		(
			--currentVertNormal = vertNormals[i][j]
			--faceIndicesForThisNormal = faceIndicesForNormals[i][j]
			append newVertsList #(pos, vertNormals[i][j])
			
			for k=1 to faceIndicesForNormals[i][j].count do
			(
				USERVerts[tvToUSERVerts[i]].TimesUsed +=1
				if(faceNewVertInds[faceIndicesForNormals[i][j][k]] == undefined) do
				(
					faceNewVertIndsOldToNew[faceIndicesForNormals[i][j][k]] = #()
					faceNewVertInds[faceIndicesForNormals[i][j][k]] = #()
				)
				append faceNewVertIndsOldToNew[faceIndicesForNormals[i][j][k]] i
				append faceNewVertInds[faceIndicesForNormals[i][j][k]] newVertsList.count
				count+=1
			)
		)
	)
	deleteModifier model normalMod
	--messageBox ("Finished TV Counting. NewVertsListCount = "+(newVertsList.count as string)+"\n faceNewVertIndscount = "+(faceNewVertInds.count as string)+"\nCount = "+(count as string)) title:"Finished TV Counting"
	vertNormals =undefined
	free vertNormals
	faceIndicesForNormals = undefined
	free faceIndicesForNormals
	tvToUSERVerts = undefined
	free tvToUSERVerts
		--free USERVerts
		--format "faceNewVertIndex: %\n" faceNewVertInds
		--format "faceNewVertIndsOldToNew: %\n" faceNewVertIndsOldToNew
		--free faceNewVertInds
		--free newVertsList
	--gc()
	
	--messageBox "Cleared TV Data" title:"Cleared TV Data"
	
	mid = makeUniqueArray mid
	--PrintArrayInFull mid "MID"
	modelMat = model.material
	facesForFinalMatID = #()
	rawMaterials = #()
	OldMatIDsToNew = #()
	global MaterialsToExport
	usedMatsCount = 0
	if modelMat != undefined or (classof modelMat) != multimaterial or (classof modelMat) != standardmaterial then
	(
		--format "Material is a \"%\"\n" (classof modelMat)
		usedMats = #()
		if classof modelMat == multimaterial do
		(
			--format "% materials on object\n" modelMat.materiallist.count
			--format "% mids\n" mid.count
			for i=1 to mid.count do
			(
				faceMatID = mid[i]
				if modelMat.materiallist[faceMatID] != undefined and modelMat.materiallist[faceMatID].name != undefined do
				(
					
					subMatName = modelMat.materiallist[faceMatID].name
					usedMatPos = finditem usedMats subMatName
					matUsedBefore = "Mat Used Before"
					rawMaterials[faceMatID] = modelMat.materiallist[faceMatID]
					if usedMatPos == 0 do 
					(
						matUsedBefore = "Mat Not Used Before"
						usedMatsCount += 1
						usedMatPos = usedMatsCount
						usedMats[usedMatPos] = subMatName
					)
					mtlconv[faceMatID] = usedMatPos
					--format "MID %: \t faceMatID: % \t rawMaterials[faceMatID]: %\t %\t usedMatPos: %\n" i faceMatID rawMaterials[faceMatID] matUsedBefore usedMatPos
					if facesForFinalMatID[usedMatPos] == undefined then facesForFinalMatID[usedMatPos] = facesForMatID[faceMatID]
					else facesForFinalMatID[usedMatPos] = facesForFinalMatID[usedMatPos] + facesForMatID[faceMatID]
				)
			)
			
			
			for i=1 to usedMatsCount do
			(
				--format "Setting Default Name\n"
				matName =usedMats[i]
				if usedMats[i] != undefined then ( --or usedMats[i] == "" do matName = "Default"
				
					append mtl matName
				)
			)
		)
		--format "Used Mats Count: %\n" usedMatsCount
		if classof modelMat == standardmaterial do
		(
			--format "material % is a stdmat\n" modelMat.name
			append mtl modelMat.name
			append rawMaterials modelMat
			
			for i=1 to mid.count do
			(
				faceMatID = mid[i]
				
				mtlconv[faceMatID] = 1
				--format "MID %: \t faceMatID: % \t rawMaterials[faceMatID]: %\t %\t usedMatPos: %\n" i faceMatID rawMaterials[faceMatID] matUsedBefore usedMatPos
				if facesForFinalMatID[1] == undefined then facesForFinalMatID[1] = facesForMatID[faceMatID]
				else facesForFinalMatID[1] = facesForFinalMatID[1] + facesForMatID[faceMatID]
			)
		)
	)
	if mtl.count==0 then
	(
		--format "No Material Assigned, using default material\n"
		append mtl "Default1"
		
		for i=1 to mid.count do
		(
			faceMatID = mid[i]
			
			mtlconv[faceMatID] = 1
			
			if facesForFinalMatID[1] == undefined then facesForFinalMatID[1] = facesForMatID[faceMatID]
			else facesForFinalMatID[1] = facesForFinalMatID[1] + facesForMatID[faceMatID]
		)
	)
	--PrintArrayInFull mtl "List Of Materials"
	--PrintArrayInFull facesForFinalMatID "facesForFinalMatID"
	if exportMats or exportTextures do
	(
		for i=1 to mtl.count do
		(
			
			if (finditem mtlconv i) != 0 then (
				faceMatID = finditem mtlconv i
				actualMat = rawMaterials[faceMatID]
				
				if (MaterialAlreadySetToExport mtl[i]) == false do append MaterialsToExport #(mtl[i], actualMat, #())
			)
		)
	)
	free facesForMatID
	--format "mtl: %\n" mtl
	finalFaceCount = 0
	--format "Doing model %\n" model.name
	--format " verts.count: %\n t_verts.count: %\n faces.count: %\n" verts.count t_verts.count faces.count

	--format "--------- oldScale: [%, %, %]\n" oldScale.x oldScale.y oldScale.z
	--format "--------- oldTransform.scalepart: [%, %, %]\n" oldTransform.scalepart.x oldTransform.scalepart.y oldTransform.scalepart.z
	--format "--------- model.transform[1]: [%, %, %]\n" oldTransform[1].x oldTransform[1].y oldTransform[1].z
	--format "--------- model.transform[2]: [%, %, %]\n" oldTransform[2].x oldTransform[2].y oldTransform[2].z
	--format "--------- model.transform[3]: [%, %, %]\n" oldTransform[3].x oldTransform[3].y oldTransform[3].z
	
	--format "Number of mtls: %\n" mtl.count
	
	for i=1 to mtl.count do
	(
		if facesForFinalMatID[i] == undefined then continue
		meshVerts = #()
		local bboxVerts = #()
		meshFaces = #()
		meshVertInds = #()
		stripperVertInds =#()
		meshVertsDone = #()
		meshVertsConv = #()
		meshFaceCount = 0
		
		--format "I = %\n num faces for this MatID: %\n" i facesForFinalMatID[i].count
		

		for h=1 to facesForFinalMatID[i].count do
		(

			if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
			j = facesForFinalMatID[i][h]
			face = USERFaces[j]
			
			--vertInds = getFace m j
			--faceMatID = getfacematid m j
			
			--if mtlconv[faceMatID] != i do continue
			
			VertInd1 = face.v1
			VertInd2 = face.v2
			VertInd3 = face.v3

			octV1 =  mdlVert pos: (getVert m VertInd1)
			octV2 =  mdlVert pos:(getVert m VertInd2)
			octV3 =  mdlVert pos:(getVert m VertInd3)
			
			v1Pos = USERVerts[VertInd1]
			v2Pos = USERVerts[VertInd2]
			v3Pos = USERVerts[VertInd3]
			
			--bboxVerts = copy USERVerts #noMap
			--if (bboxHasVert bboxVerts v1Pos) == false do append bboxVerts v1Pos
			--if (bboxHasVert bboxVerts v2Pos) == false do append bboxVerts v2Pos
			--if (bboxHasVert bboxVerts v3Pos) == false do append bboxVerts v3Pos
			--format "J = %\n" j
			
			--format "faceIndicesForTVs[j] = %\n" faceIndicesForTVs[j]
			--format "faceIndicesForTVs[j][1] = % - faceIndicesForTVs[j][2] = % - faceIndicesForTVs[j][3] = %\n" faceIndicesForTVs[j][1] faceIndicesForTVs[j][2] faceIndicesForTVs[j][3]
			oldMeshIndInd1 = finditem faceNewVertIndsOldToNew[j] faceIndicesForTVs[j][1]
			oldMeshIndInd2 = finditem faceNewVertIndsOldToNew[j] faceIndicesForTVs[j][2]
			oldMeshIndInd3 = finditem faceNewVertIndsOldToNew[j] faceIndicesForTVs[j][3]
			
			oldMeshVertInd1 = faceNewVertInds[j][oldMeshIndInd1]
			oldMeshVertInd2 = faceNewVertInds[j][oldMeshIndInd2]
			oldMeshVertInd3 = faceNewVertInds[j][oldMeshIndInd3]
			
			if (finditem meshVertsDone oldMeshVertInd1) == 0 then
			(
				vert1Pos = v1Pos
				vert1Tex = [face.v1u, face.v1v]
				vert1Tex2 = [face.v1u2, face.v1v2]
				vert1Normal = newVertsList[oldMeshVertInd1][2]
				vert1Colour = face.v1Colour
				vert1 = mdlVert pos:vert1Pos norm:vert1Normal tex:vert1Tex tex2: vert1Tex2 colour:vert1Colour
				append meshVerts vert1
				append meshVertsDone oldMeshVertInd1
				meshVertsConv[oldMeshVertInd1] = meshVerts.count
				
				append PREPVerts vert1
				append OctreeVerts octV1
				
				--finalVertsConv[oldMeshVertInd1] = PREPVerts.count
				PREP2USERvertConv[PREPVerts.count] = face.v1
				USER2PREPvertConv[face.v1] = PREPVerts.count
				append meshVertInds meshVertsConv[oldMeshVertInd1] 
				newMeshVertInd1 = meshVertsConv[oldMeshVertInd1]
				
			)
			else
			(
				newMeshVertInd1 = meshVertsConv[oldMeshVertInd1]
				append meshVertInds newMeshVertInd1
			)
			if (finditem meshVertsDone oldMeshVertInd2) == 0 then
			(
				vert2Pos = v2Pos
				vert2Tex = [face.v2u, face.v2v]
				vert2Tex2 = [face.v2u2, face.v2v2]
				vert2Normal = newVertsList[oldMeshVertInd2][2]
				vert2Colour = face.v2Colour
				vert2 = mdlVert pos:vert2Pos norm:vert2Normal tex:vert2Tex tex2: vert2Tex2 colour:vert2Colour
				append meshVerts vert2
				append meshVertsDone oldMeshVertInd2
				meshVertsConv[oldMeshVertInd2] = meshVerts.count
				
				append PREPVerts vert2
				append OctreeVerts octV2
				--finalVertsConv[oldMeshVertInd2] = PREPVerts.count
				PREP2USERvertConv[PREPVerts.count] = face.v2
				USER2PREPvertConv[face.v2] = PREPVerts.count
				append meshVertInds meshVertsConv[oldMeshVertInd2] 
				newMeshVertInd2 = meshVertsConv[oldMeshVertInd2]
			)
			else
			(
				newMeshVertInd2 = meshVertsConv[oldMeshVertInd2]
				append meshVertInds newMeshVertInd2
			)
			if (finditem meshVertsDone oldMeshVertInd3) == 0 then
			(
				vert3Pos = v3Pos
				vert3Tex = [face.v3u, face.v3v]
				vert3Tex2 = [face.v3u2, face.v3v2]
				vert3Normal = newVertsList[oldMeshVertInd3][2]
				vert3Colour = face.v3Colour
				vert3 = mdlVert pos:vert3Pos norm:vert3Normal tex:vert3Tex tex2: vert3Tex2 colour:vert3Colour
				append meshVerts vert3
				append meshVertsDone oldMeshVertInd3
				meshVertsConv[oldMeshVertInd3] = meshVerts.count
				
				append PREPVerts vert3
				append OctreeVerts octV3
				--finalVertsConv[oldMeshVertInd3] = PREPVerts.count
				PREP2USERvertConv[PREPVerts.count] = face.v3
				USER2PREPvertConv[face.v3] = PREPVerts.count
				append meshVertInds meshVertsConv[oldMeshVertInd3] 
				newMeshVertInd3 = meshVertsConv[oldMeshVertInd3]
			)
			else
			(
				newMeshVertInd3 = meshVertsConv[oldMeshVertInd3]
				append meshVertInds newMeshVertInd3
			)
			
				
				append stripperVertInds meshVertsConv[oldMeshVertInd1]
				append stripperVertInds meshVertsConv[oldMeshVertInd3]
				append stripperVertInds meshVertsConv[oldMeshVertInd2]
			
			newFace = #([ newMeshVertInd1 ,  newMeshVertInd2 ,  newMeshVertInd3 ], face.SmoothingGroup, i)
			--format "face %: old verts: [%, %, %] new verts: [%, %, %]\n" j oldMeshVertInd1 oldMeshVertInd2 oldMeshVertInd3 newMeshVertInd1 newMeshVertInd2 newMeshVertInd3
			
			append meshFaces newFace
			finalVertInd1 = newMeshVertInd1 + stripOffset
			finalVertInd2 = newMeshVertInd2 + stripOffset
			finalVertInd3 = newMeshVertInd3 + stripOffset
			
			finalFace = (mdlFace matID: i smoothingGroup:face.SmoothingGroup v1:finalVertInd1 v2:finalVertInd2 v3:finalVertInd3 ) -- #([ finalVertInd1 ,  finalVertInd2 ,  finalVertInd3 ], face.SmoothingGroup, i)
			
			append PREPFaces finalFace
			PREP2USERfaceConv[PREPFaces.count] = j
			USER2PREPfaceConv[j] = PREPFaces.count
			
			meshFaceCount = meshFaceCount + 1
			finalFaceCount = finalFaceCount + 1
		)

			meshFaceCount = meshFaces.count
			finalFaceCount = finalFaceCount + meshFaces.count
		bbox = calcMeshBoundingBox USERVerts

			--PrintArrayInFull	USER2PREPvertConv "USER2PREPvertConv"
			--PrintArrayInFull	PREP2USERvertConv "PREP2USERvertConv"
		--PrintArrayInFull stripperVertInds "Verts before stripper"
		shakenStrips = StripperShakeItBaby meshFaceCount &stripperVertInds
		
		stripList = #()
		
		--format "Shakenstrips count: %\n" shakenStrips.count
		--format "Shakenstrips[1] count: %\n" shakenStrips[1].count

		if shakenStrips[1].count > 3 do
		(
			strip = shakenStrips[1]
			stripList[1] = #(strip[1], false)
			stripList[2] = #(strip[2], false)
			for i=3 to strip.count do
			(
				degenerate = false
				if strip[i-2] == strip[i-1] or strip[i-2] == strip[i] or strip[i-1]==strip[i] do degenerate = true
				stripList[i] = #(strip[i], degenerate)
			)
		)

		
		patchList = #()
		for i=2 to shakenStrips.count do
		(
			--format "Shakenstrips[%] count: %\n" i shakenStrips[i].count
			stripPatch = shakenStrips[i]
			append patchList stripPatch[1]
			append patchList stripPatch[2]
			append patchList stripPatch[3]
		)
		
		newMesh = mdlMesh verts:(deepcopy meshVerts) faces:(deepcopy meshVertInds) stripOffset:stripOffset stripVertCount:meshVerts.count StripList:(deepcopy stripList) patchOffset:patchOffset patchVertCount:meshVerts.count PatchList:(deepcopy patchList) BBox:bbox

		append meshes newMesh
		stripOffset = PREPVerts.count
		patchOffset = PREPVerts.count
		
		free meshVerts
		free bboxVerts
		free meshFaces
		free meshVertInds
		free stripperVertInds
		free meshVertsDone
		free meshVertsConv
		--gc()
	)
	
		uniqueVerts = #()
		
		--format "USERVerts: %\nPREPVerts: %\n" USERVerts.count PREPVerts.count
	
	f = fopen mdl_name "wb"
	PREPflags = 1
	hasSkinData = false
	USERflags = 0
	skinMod = undefined
	bonesList = #()
	if model.Modifiers["Skin"] != undefined then
	(
		hasSkinData = true
		PREPflags = bit.or PREPflags (bit.shift 1 5)
		PREPflags = 41
		USERflags = bit.or USERflags (bit.shift 1 2)
		skinMod = model.modifiers["Skin"]
		bonesList = GetBonesList model
		/*bonesList =#()
		for b in bonesList2 do
		(
			if b.name == "head" then bonesList[1] = b
			else if b.name == "hips" then bonesList[2] = b
			else if b.name == "left_arm" then bonesList[3] = b
			else if b.name == "left_collar" then bonesList[4] = b
			else if b.name == "left_fingers" then bonesList[5] = b
			else if b.name == "left_foot" then bonesList[6] = b
			else if b.name == "left_forearm" then bonesList[7] = b
			else if b.name == "left_hand" then bonesList[8] = b
			else if b.name == "left_leg" then bonesList[9] = b
			else if b.name == "left_shin" then bonesList[10] = b
			else if b.name == "left_thumb" then bonesList[11] = b
			else if b.name == "left_toe" then bonesList[12] = b
			else if b.name == "neck" then bonesList[13] = b
			else if b.name == "ribs" then bonesList[14] = b
			else if b.name == "right_arm" then bonesList[15] = b
			else if b.name == "right_collar" then bonesList[16] = b
			else if b.name == "right_fingers" then bonesList[17] = b
			else if b.name == "right_foot" then bonesList[18] = b
			else if b.name == "right_forearm" then bonesList[19] = b
			else if b.name == "right_hand" then bonesList[20] = b
			else if b.name == "right_leg" then bonesList[21] = b
			else if b.name == "right_shin" then bonesList[22] = b
			else if b.name == "right_thumb" then bonesList[23] = b
			else if b.name == "right_toe" then bonesList[24] = b
			else if b.name == "torso" then bonesList[25] = b
		)*/
	)
	--printFlagBits PREPflags 32 "PREP flags: "
	
	try
	(
		--print "Exporting MDL to file\n\nWriting Header"
		writeMDLheader f
		
		-- Unknown
		writebyte f 0 #unsigned
		writebyte f 0 #unsigned
		writebyte f 0 #unsigned
		writebyte f 0 #unsigned
		
		-- Flags
		writelong f PREPflags #unsigned
		
		-- Unknown
		--writebyte f 0
		--writebyte f 0
		--writebyte f 0
		--writebyte f 0
		prepDataSize = 4 + (PREPFaces.Count * 16) + 4 + (PREPVerts.count * 44) + 2
		for mdlmsh in meshes do
		(
			prepDataSize += 52
			prepDataSize += mdlmsh.StripList.count * 4
			prepDataSize += 12
			prepDataSize += mdlmsh.PatchList.count * 4
			if hasSkinData then
			(
				select model
				max modify mode
				modPanel.setCurrentObject skinMod
				prepDataSize += 6
				for bn in bonesList do
				(
					prepDataSize += bn.name.count + 1
				)
				prepDataSize += bonesList.count * 43
				
				numWeights = 0
			--format "Writing weight offsets\n"
				prepDataSize += 8 * PREPVerts.count
				for i=1 to PREPVerts.count do
				(
					vertNum = PREP2USERvertConv[i]
					weightCount = skinOps.GetVertexWeightCount skinMod vertNum
					
					numWeights += weightCount
					if weightCount == 1 then numWeights += 1
				)
				prepDataSize += 4
				prepDataSize += numWeights * 6
			)
		)
		writelong f prepDataSize #unsigned
		
		--print "Writing Faces Count"
		-- TODO Add Faces Count
		writelong f PREPFaces.count #unsigned
		
		
		--print "Writing Unique Verts Count"
		-- TODO Add Unique Vert Position Count
		writelong f USERVerts.count #unsigned
		
		writelong f 0 
		
		--print "Writing Bounding Box"
		-- TODO Add Space For total ByteSize - Header
		minLength = length model.min
		maxLength = length model.max
		--format "Min length: % - Max Length: %" minLength maxLength
		bboxHalfDistance = maxLength --(length (model.max - model.min) ) / 2
		if minLength > maxLength then bboxHalfDistance = minLength
		--format "BBox Radius: %\n" bboxHalfDistance
		--format "BBox: \tMin: [%, %, %]\n\tMax: [%, %, %]\n\tCenter: [%, %, %]" -model.max.x model.min.z -model.max.y -model.min.x model.max.z -model.min.y -model.center.x model.center.z -model.center.y
		writefloat f bboxHalfDistance
		writefloat f -model.max.x
		writefloat f model.min.z
		writefloat f -model.max.y
		writefloat f -model.min.x
		writefloat f model.max.z
		writefloat f -model.min.y
		writefloat f -model.center.x
		writefloat f model.center.z
		writefloat f -model.center.y
		
		
		--print "Writing Material Count"
		writeshort f mtl.count #unsigned
		
		
		--print "Writing Material Names"
		for matName in mtl do
		(
			--format "Writing Material Name: %\n" matName
			witepaddedstring f matName
		)
		
		--print "Writing Faces Count"
		writelong f PREPFaces.count 
		
		--print "Writing Faces"
		numFacesWrote = 0
		
		for face in PREPFaces do
		(
			numFacesWrote = numFacesWrote + 1
			faceMatID = face.matID - 1
			if faceMatID == undefined or faceMatID < 0 do faceMatID = 0
			writeshort f faceMatID #unsigned
			writeshort f 0
			faceInd1 = face.v1 - 1
			faceInd2 = face.v2 - 1
			faceInd3 = face.v3 - 1
			writelong f faceInd1 #unsigned
			writelong f faceInd2 #unsigned
			writelong f faceInd3 #unsigned
			
		)
		
		
		--print "Writing Vertex Count"
		writelong f PREPVerts.count #unsigned
		
		--print "Writing Vertices"
		numVertsWrote = 0
		
		for i=1 to PREPVerts.count do
		(
			--format "Writing Vert %: %\n" i finalVerts[i]
			vert = PREPVerts[i]
			writefloat f vert.pos.x
			writefloat f vert.pos.z
			writefloat f -vert.pos.y
			
			writefloat f vert.norm.x
			writefloat f vert.norm.z
			writefloat f -vert.norm.y
			
			writefloat f vert.tex.x
			writefloat f (1-vert.tex.y)
			
			writefloat f vert.tex2.x
			writefloat f (1-vert.tex2.y)
			
			writebyte f vert.colour.r #unsigned
			writebyte f vert.colour.g #unsigned
			writebyte f vert.colour.b #unsigned
			writebyte f vert.colour.a #unsigned
			
			numVertsWrote = numVertsWrote + 1
		)
		
		--print "Writing Meshes Count"
		writeshort f meshes.count #unsigned
		
		
		--print "Writing Meshes"
		for mdlmsh in meshes do
		(
			if mdlmsh == undefined then continue
				
			bbox = mdlmsh.BBox
			writefloat f bbox.center.x
			writefloat f bbox.center.z
			writefloat f -bbox.center.y
			writefloat f bbox.halfdist
			writefloat f bbox.vmin.x
			writefloat f bbox.vmin.z
			writefloat f bbox.vmin.y
			writefloat f bbox.vmax.x
			writefloat f bbox.vmax.z
			writefloat f bbox.vmax.y
			
			writelong f mdlmsh.stripOffset #unsigned
			writelong f mdlmsh.stripVertCount #unsigned
			writelong f mdlmsh.StripList.count #unsigned
			
			--PrintArrayInFull mdlmsh.StripList "mdlmsh.StripList"
			degenerateBit = bit.shift 1 31
			for j=1 to mdlmsh.StripList.count do
			(
				if (bit.and (mdlmsh.StripList[j][1] - 1) degenerateBit) == degenerateBit then
				(
					boxmessage = stringstream ""
					format "OH MY FUCKING GOD THIS MESH PART HAS MORE THAN % VERTICES AND THAT CAN NOT HAPPEN OR IT WON'T SAVE PROPERLY! FIX IT ARTIST MONKEY!" degenerateBit to:boxmessage
					messageBox boxmessage title:"HOLY SHIT IT BROKE!"
				)
				else
				(
					degenerate = 0
					if mdlmsh.StripList[j][2] == true then
					(
						vertIndToWrite = bit.or degenerateBit (mdlmsh.StripList[j][1] - 1)
						writelong f vertIndToWrite #unsigned --(mdlmsh.StripList[j][1] - 1) #unsigned
					)
					else 
					(
						writelong f (mdlmsh.StripList[j][1] - 1) #unsigned
					)
				)
			)
			
			
			writelong f mdlmsh.patchOffset #unsigned
			writelong f mdlmsh.patchVertCount #unsigned
			writelong f mdlmsh.PatchList.count #unsigned
			
			for j=1 to mdlmsh.PatchList.count do
			(
				writelong f (mdlmsh.PatchList[j] - 1)
			)
		)
		doneSiblings = #()
		if hasSkinData then
		(
			--format "Starting skin data\n"
			select model
			max modify mode
			modPanel.setCurrentObject skinMod
			
			--format "Writing bone names\n"
			writeshort f bonesList.count #unsigned
			
			maximumBonesPerVert = 0
			for i=1 to PREPVerts.count do
			(
				vertNum = PREP2USERvertConv[i]
				w = skinOps.GetVertexWeightCount skinMod vertNum
				if w > maximumBonesPerVert then maximumBonesPerVert = w
			)
			writeshort f 2
			rootBonenum = 0
			for i = 1 to bonesList.count do
			(
				if bonesList[i].parent == undefined then 
				(
					rootBonenum = i
					exit
				)
			)
			if rootBonenum == 0 then
			(
				if bonesList[i].name == "hips" then 
				(
					rootBonenum = i
					exit
				)
			)
			--format "RootBoneIndex: %\n" rootBonenum
			writeshort f (rootBonenum - 1 )
			for i=1 to bonesList.count do
			(
				writestring f bonesList[i].name
			)
			
			--format "Writing bone info\n"
			printarrayinfull bonesList "Bones List: "
			for i=1 to bonesList.count do
			(
				axisMin = (ik.getaxismin bonesList[i] #rotational)/360
				-- Min Limit
				writefloat f axisMin.x
				writefloat f axisMin.y
				writefloat f  axisMin.z
				
				axisMax = (ik.getaxismax bonesList[i] #rotational)/360
				-- Max Limit
				writefloat f axisMax.x
				writefloat f axisMax.y
				writefloat f axisMax.z
				
				relativePos = bonesList[i].position
				--format "Bone pos: %\n" relativepos
				if bonesList[i].parent != undefined then
				(
					relativePos = relativePos * (inverse bonesList[i].parent.transform)
				)
				else relativePos = [0,0,0]
				relativePos = ConvertToCRSpace relativePos
				
				--format "Relative pos: %\n" relativepos
				
				writefloat f -relativePos.x
				writefloat f relativePos.y
				writefloat f -relativePos.z
				
				--format "Writing parent\n"
				if bonesList[i].parent == undefined then writebyte f -1
				else
				(
					parentNum = (findItem bonesList bonesList[i].parent) - 1
					--format "BoneNum = % - ParentNum = %\n" i parentNum
					writebyte f parentNum
				)
				--format "Writing child = %\n" bonesList[i].children.count
				if bonesList[i].children.count == 0 then writebyte f -1
				else
				(
					--format "finding child\n %\n %\n" boneslist boneslist[i].children[1]
					childNum = (finditem bonesList bonesList[i].children[bonesList[i].children.count])
					
					--format "ChildNum = %\n" childNum
					childNum = childNum - 1
					writebyte f childNum
				)
				--format "Writing sibling\n"
				if bonesList[i].parent == undefined or bonesList[i].parent.children.count==1 then writebyte f -1
				else
				(
					siblingNum = -1
					for s = (finditem bonesList[i].parent.children bonesList[i]) to 1 by -1 do
					(
						potentialSiblingBone = bonesList[i].parent.children[s]
						potentialSiblingBoneNum = (finditem bonesList potentialSiblingBone)
						if potentialSiblingBone != bonesList[i] and (findItem doneSiblings potentialSiblingBoneNum) == 0 then
						(
							siblingNum = potentialSiblingBoneNum - 1
							exit
						)
					)
					--if bonesList[i].parent.children[1] != bonesList[i] then siblingNum = (finditem bonesList bonesList[i].parent.children[1]) - 1
					--else siblingNum = (finditem bonesList bonesList[i].parent.children[2]) - 1
					--format "BoneNum = % - SiblingBone = %\n" i siblingNum
					writebyte f siblingNum
					append doneSiblings (siblingNum+1)
				)
				
			)
			--format "Writing bone transforms\n"
			
			for i=1 to bonesList.count do
			(
				writefloat f -bonesList[i].rotation.y
				writefloat f bonesList[i].rotation.w
				writefloat f bonesList[i].rotation.x
				writefloat f bonesList[i].rotation.z
				
				writefloat f -bonesList[i].position.x
				writefloat f bonesList[i].position.z
				writefloat f -bonesList[i].position.y
				
				writefloat f 0
			)
			firstWeightIndex = 0
			--format "Writing weight offsets\n"
			
			for i=1 to PREPVerts.count do
			(
				vertNum = PREP2USERvertConv[i]
				weightCount = skinOps.GetVertexWeightCount skinMod vertNum
				if weightCount > 2 then
				(
					format "Vert % has % weights when it should only have 2!\n" i weightCount
				)
				if weightCount == 1 then weightCount = 2
				writeshort f weightCount #unsigned
				writeshort f 0
				writelong f firstWeightIndex #unsigned
				--format "%: %\t0\t%\n" i weightCount firstWeightIndex
				firstWeightIndex += weightCount
			)
			writelong f firstWeightIndex #unsigned
			--format "Writing weight bone indices\n"
			
			for i=1 to PREPVerts.count do
			(
				vertNum = PREP2USERvertConv[i]
				weightCount = skinOps.GetVertexWeightCount skinMod vertNum
				if weightCount == 1 then writeshort f 1 #unsigned
				for w=1 to weightCount do 
				(
					boneId = skinOps.GetVertexWeightBoneID skinMod vertNum w
					boneName = skinOps.GetBoneName skinMod boneId 1
					boneNum = 0
					for j=1 to bonesList.count do
					(
						if bonesList[j].name == boneName then 
						(
							boneNum = j-1
							j = bonesList.count + 1
						)
					)
					--format "Vertex #% (%)\tboneID: %\tboneNum: %\n\t\"%\"\t%\n" i vertNum boneID boneNum boneName bonesList[boneNum+1]
					writeshort f (boneId - 1) #unsigned
				)
				
			)
			
			--format "Writing weights\n"
			for i=1 to PREPVerts.count do
			(
				vertNum = PREP2USERvertConv[i] as integer
								
				weightCount = skinOps.GetVertexWeightCount skinMod vertNum
				if weightCount == 1 then writelong f 0 #unsigned
				for w=1 to weightCount do
				(
					weight = skinOps.GetVertexWeight  skinMod vertNum w
					writefloat f weight
				)
				
			)
		)
		
		
		/*sizeOfMDL = ftell f - 28
		--format "Size Of MDL = %\n----------------\n" sizeOfMDL
		--fclose f
		--f = fopen mdl_name "ab"
		fseek f 24 #seek_set
		writelong f sizeOfMDL
		exceptionHappened=false
		return 0*/
		
		writelong f USERflags
		
		--print "Writing USER Vertices"
		for i=1 to USERVerts.count do
		(
			writefloat f USERVerts[i].x
			writefloat f USERVerts[i].z
			writefloat f -USERVerts[i].y
			writelong f USERVerts[i].TimesUsed
		)
		
		--print "Writing USER Face Data"
		for i=1 to USERFaces.count do
		(
			--format "Face % " i
			face =USERFaces[i]
			
			
			
			
			--format "Writing % plane - " 1
			writefloat f face.PlaneD
			writefloat f face.PlaneX
			writefloat f face.PlaneY
			writefloat f face.PlaneZ
			
			matId = face.MaterialIndex
			smoothingGroup = face.SmoothingGroup
			
			--format "Writing % normals  - " 3
			writefloat f face.v1NormX
			writefloat f face.v1NormZ
			writefloat f -face.v1NormY
			
			writefloat f face.v2NormX
			writefloat f face.v2NormZ
			writefloat f -face.v2NormY
			
			writefloat f face.v3NormX
			writefloat f face.v3NormZ
			writefloat f -face.v3NormY
			
			--format "Writing matID, smoothing Group and % indices - " 3
			writelong f matId #unsigned
			writelong f smoothingGroup #unsigned
			writelong f (face.v1-1) #unsigned
			writelong f (face.v2-1) #unsigned
			writelong f (face.v3-1) #unsigned
			
			--format "Writing face #% - % / % / %\n" i face.v1 face.v2 face.v3
			--format "Writing % colours - " 3
			writebyte f face.v1Colour.r #unsigned
			writebyte f face.v1Colour.g #unsigned
			writebyte f face.v1Colour.b #unsigned
			writebyte f face.v1Colour.a #unsigned
			
			writebyte f face.v2Colour.r #unsigned
			writebyte f face.v2Colour.g #unsigned
			writebyte f face.v2Colour.b #unsigned
			writebyte f face.v2Colour.a #unsigned
			
			writebyte f face.v3Colour.r #unsigned
			writebyte f face.v3Colour.g #unsigned
			writebyte f face.v3Colour.b #unsigned
			writebyte f face.v3Colour.a #unsigned
			
			--format "Writing % texcoords\n" 6
			writefloat f face.v1U
			writefloat f (1-face.v1V)
			writefloat f face.v1U2
			writefloat f (1-face.v1V2)
			
			writefloat f face.v2U
			writefloat f (1-face.v2V)
			writefloat f face.v2U2
			writefloat f (1-face.v2V2)
			
			writefloat f face.v3U
			writefloat f (1-face.v3V)
			writefloat f face.v3U2
			writefloat f (1-face.v3V2)
			
			writebyte f 0 #unsigned
			writelong f 0 #unsigned
		)
		
		--format "Writing PREP2USER face map data %\n" " "
		--print "Writing Face Numbers"
		-- TODO Write Sequence Of Faces Numbers ???
		--format "PREP2USER Face Conversion:\n"
		for i=1 to PREP2USERfaceConv.count do
		(
			--format "% % \t\t\t=> \t% [%, %, %]\n" i PREPFaces[i][1] PREP2USERfaceConv[i] USERFaces[PREP2USERfaceConv[i]].v1 USERFaces[PREP2USERfaceConv[i]].v2 USERFaces[PREP2USERfaceConv[i]].v3
			
			writelong f (PREP2USERfaceConv[i]-1)
		)
		
		--print "Writing Vertex Count"
		-- TODO Write Vertex Count (Again???)
		
		--format "Writing PREP2USER vert count data %\n" " "
		writelong f PREP2USERvertConv.count
		--format "PREPVerts.Count = %\n PREP2USERvertConv.Count = %\n" PREPVerts.count PREP2USERvertConv.count
		
		
		--format "Writing PREP2USER vert map data %\n" " "
		--print "Writing Vertex Numbers"
		-- TODO Write Sequence Of Vertex Numbers ????????
		--format "PREP2USER Vert Conversion:\n"
		for i=1 to PREP2USERvertConv.count do
		(
			--format "% [%, %, %] \t\t\t=> \t% [%, %, %]\n" i PREPVerts[i].pos.x PREPVerts[i].pos.y PREPVerts[i].pos.z PREP2USERvertConv[i] USERVerts[PREP2USERvertConv[i]].x USERVerts[PREP2USERvertConv[i]].y USERVerts[PREP2USERvertConv[i]].z
			writelong f (PREP2USERvertConv[i]-1)
		)
		
		if hasSkinData then
		(
			writeshort f bonesList.count #unsigned
			
			for i=1 to bonesList.count do
			(
				boneTransformMatrix = bonesList[i].transform
				boneTransformMatrix.row1 *= -1
				boneTransformMatrix =  matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0] * boneTransformMatrix * inverse(matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0])
				
				writestring2 f bonesList[i].name
				for s=bonesList[i].name.count to 31 do writebyte f 0
					
				parentBone = -1
				if bonesList[i].parent != undefined then
				(
					for p=1 to bonesList.count do
					(
						if bonesList[p] == bonesList[i].parent then parentBone = p - 1
					)
				)
				
				writeshort f parentBone
				
				
					
				writefloat f boneTransformMatrix.row1.x
				writefloat f boneTransformMatrix.row1.y
				writefloat f boneTransformMatrix.row1.z
				
				writefloat f boneTransformMatrix.row2.x
				writefloat f boneTransformMatrix.row2.y
				writefloat f boneTransformMatrix.row2.z
				
				writefloat f boneTransformMatrix.row3.x
				writefloat f boneTransformMatrix.row3.y
				writefloat f boneTransformMatrix.row3.z
				
				writefloat f boneTransformMatrix.row4.x
				writefloat f boneTransformMatrix.row4.y
				writefloat f boneTransformMatrix.row4.z
			)
			
			writelong f userverts.count #unsigned
			
			for i=1 to userverts.count do
			(
			
				weightCount = skinOps.GetVertexWeightCount skinMod i
				--weightcount= (skinops.getvertexweightcount skinmod i)
				weightcount2 = weightcount
				if weightcount2 == 1 then weightcount2 = 2
				writeshort f weightcount2 #unsigned
				for w=1 to weightcount do
				(
					boneId = skinOps.GetVertexWeightBoneID skinMod i w
					boneName = skinOps.GetBoneName skinMod boneId 1
					boneNum = 0
					for j=1 to bonesList.count do
					(
						if bonesList[j].name == boneName then 
						(
							boneNum = j-1
							j = bonesList.count + 1
						)
					)
					writeshort f boneNum #unsigned
					
					
					writefloat f (skinops.getvertexweight skinMod i w)
					if w==1 then
					(
						writefloat f USERVerts[i].x
						writefloat f USERVerts[i].z
						writefloat f -USERVerts[i].y
					)
					
					else
					(
						writefloat f 0
						writefloat f 0
						writefloat f 0
					)
				)
				if weightCount == 1 then
				(
					writeshort f 1
					writefloat f 0
					writefloat f 0
					writefloat f 0
					writefloat f 0
				)
			)
		)
		--print "Writing MDL Content Size"
		--fclose f
		--f = fopen mdl_name "rb"
	
		--fseek f 0 #seek_end
		sizeOfMDL = ftell f - 28
		--format "Size Of MDL = %\n----------------\n" sizeOfMDL
		--fclose f
		--f = fopen mdl_name "ab"
		fseek f 24 #seek_set
		writelong f sizeOfMDL
		exceptionHappened=false
	)
	catch
	(
		
		exceptionHappened=true
		print "OMFG THERE SOMETHING HAS GONE FUCKING WRONG!!!"
		format "****** % ******\n" (getCurrentException())
		fclose f
	)
	fclose f
	free f
	free USERVerts
	free USERFaces
	free USER2PREPvertConv
	free USER2PREPfaceConv
	free PREP2USERvertConv
	free PREP2USERfaceConv
	
	free mtl
	free mtlconv
	free mid 
	free meshes
	
	free newVertsList
	free faceNewVertInds
	free faceIndicesForTVs
	
	
	free facesForFinalMatID
	free rawMaterials
	free uniqueVerts
		
	if exceptionHappened then format "MDL Export for \"%\" Finished With Errors!" model.name
	--else print "Finished MDL Export!"
	model.transform = oldTransform

	if createOctree then (
		global ActiveOctree = CNTOctree()
		ActiveOctree.GenerateOctree OctreeVerts PREPFaces (mbbox vmin:model.min vmax:model.max center:model.center)
		
		if RespawnOctreeAfterExport == true then (
			format "!!!!Spawning octree!!!!\n"
			ActiveOctree.SpawnLeafBoxes faces: PrepFaces verts:OctreeVerts
		)
	)
	free OctreeVerts
	free PREPVerts
	free PREPFaces

)

fn GatherMDLs nodes exportHierarchy =
(
	
	global models
	msg = ""
	for model in nodes do
	(
			if exportHierarchy == true do
			(
				GatherMDLs model.children exportHierarchy
			)
			isACNT = IsObjectACNT model
		if (isACNT and (model.modifiers["CNT Hierarchy"].NodeType == "MODL" or model.modifiers["CNT Hierarchy"].NodeType == "SKIN" or model.modifiers["CNT Hierarchy"].NodeType == "LITg")) then
		(
			if finditem models model == 0 do
			(
				--format "Found model \"%\" which is a %\n" model.name (classof model)
				append models model
			)
			
		)
		else if (isACNT == false  and classof model != dummy and (classof model == editable_mesh or classof model == editable_poly or superclassof model == geometryclass)) then
			(
				msg += model.name+"\n"
			)
	)
	if msg != "" then
	(
		messageBox ("The following objects are not set as CNT Nodes and will not be exported:\n\n"+msg) title:"Some objects won't be exported"
	)
	--PrintArrayInFull models "Models Found"
)

fn ExportLight folder_name nodeToExport exportGobo:false =
(
	light_name = nodeToExport.name
	light_name = nodeToExport.modifiers["CNT Hierarchy"].FileName

	
	light_name = folder_name+light_name+".light"
	
	lightObj = CRLight()
	lightObj.SetFromLight nodeToExport
	lightObj.SaveLight light_name

	if exportGobo then
	(
		bitmapFileName = undefined
		if lightObj.GoboTexture != undefined and (classof lightObj.GoboTexture) == bitmaptexture then
		(
			bitmapFileName = lightObj.GoboTexture.filename
		)
		if bitmapFileName!=undefined do
		(
			
			ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
			ConvertTDX.Convert bitmapFileName folder_name 5
		)
	)
)
fn ExportMDL folder_name exportSelected exportHierarchy  exportMats:false exportTextures:false funsizeExport:false createOctree:false nodes:undefined =
(
	global materials = #()
	global models = #()
	modelsDone = #()
	global MaterialsToExport
	MaterialsToExport=#()
	
	--local nodes
	if exportSelected == true then
	(
		nodes = selection
	)
	else if nodes == undefined or nodes.count < 1 do
	(
		nodes = for model in objects where model.ishidden == false collect model
	)
	
	GatherMDLs nodes exportHierarchy
	
	
	for mat in scenematerials do
	(
		if classof mat == standardmaterial do
		(
			--if finditem materials mat == 0 do append materials mat
		)
		if classof mat == multimaterial do
		(
			for i = 1000 to mat.numsubs do
			(
				submat = getsubmtl mat i
				if submat != undefined then (
				if submat.name == "crTools_NullNodeMaterial_X" or submat.name == "crTools_NullNodeMaterial_Y" or submat.name == "crTools_NullNodeMaterial_Z" then i = mat.numsubs + 1
					if finditem materials submat == 0 do append materials submat
				)
			)
		)
	)
	count = 0
	for i=1 to models.count do
	(
		nodeToExport = models[i]
		if count > 60 then i = models.count + 1
		else (
			count += 1
			if nodeToExport.modifiers["CNT Hierarchy"].NodeType == "LITg" then
			(
				ExportLight folder_name nodeToExport
				
			)
			else
			(
				ExportMDLMesh folder_name nodeToExport exportMats:exportMats exportTextures:exportTextures funsizeExport:funsizeExport  createOctree:createOctree
			)
			gc()
		)
	)
)

fn ExportCNTModel f model =
(
	--format "Saving node % to CNT\n" model.name
	model_name = model.name
	model_name_length =  model_name.count
	
	if (IsObjectACNT model) == true then
	(
		if model.modifiers["CNT Hierarchy"].FileName != "" then model_file_name = model.modifiers["CNT Hierarchy"].FileName
		else model_file_name = model_name
	)
	else
	(
		model_file_name = model_name
	)
	model_file_name_length =  model_file_name.count
	
	mdlnl_div4 = model_name_length / 4
	mdlnl_plus1 = 0
	if (mod model_name_length 4) > 0 do
	(
		mdlnl_plus1=1
	)
	mdlnl_added = mdlnl_div4 + mdlnl_plus1
	model_name_padding = (mdlnl_added * 4) - model_name_length
	
	
	mdlnl_div4 = model_file_name_length / 4
	mdlnl_plus1 = 0
	if (mod model_file_name_length 4) > 0 do
	(
		mdlnl_plus1=1
	)
	mdlnl_added = mdlnl_div4 + mdlnl_plus1
	model_file_name_padding = (mdlnl_added * 4) - model_file_name_length
	
	writelong f model_name_length #unsigned
	writestring2 f model_name
	for i = 1 to model_name_padding do
	(
		writebyte f 0 #unsigned
	)
		writebyte f 0 #unsigned
		writefloat f 0.0


		oldtm = copy model.transform
	if (IsObjectACNT model) and model.modifiers["CNT Hierarchy"].NodeType == "LITg" then model.transform = matrix3 oldtm.row1 oldtm.row3 -oldtm.row2 oldtm.row4
	oldScale = model.scale
	oldRotation = model.rotation
	oldPosition = model.position
	oldEulerAngles = oldRotation as EulerAngles
	oldEulerAngles.x = -oldEulerAngles.x
	oldEulerAngles.y = oldEulerAngles.y
	oldEulerAngles.z = -oldEulerAngles.z
	model.rotation = oldEulerAngles as quat
	if (IsObjectACNT model) == true and model.modifiers["CNT Hierarchy"].BakeScaleIntoMesh == true then model.scale = [1,1,1]
	
	model.position = oldPosition
	tm = copy model.transform

	--format "old pos: %, new pos: %\n" oldPosition model.position;
	model.rotation = oldRotation
	model.scale = oldScale
	
	model.position = oldPosition
	model.transform = oldtm
	--tm = (model.rotation as matrix3) * (transMatrix model.position) 


	numAxisNegativeScale = 0
	mirroredTransformScale = [1,1,1]
	
	
	if tm.scalepart.x < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.x = -1
	)
	if tm.scalepart.y < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.y = -1
	)
	if tm.scalepart.z < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.z = -1
	)
	tm = scale tm mirroredTransformScale false
	if model.parent != undefined do
	(
		--format "====This has a parent! %\n" model.parent.name
		oldParentScale= model.parent.scale
		model.parent.scale = [1,1,1]
		tm = tm * (inverse model.parent.transform)
		model.parent.scale = oldParentScale
	)
	tm = matrix3 [-1,0,0] [0,0,1] [0,1,0] [0,0,0] * tm * inverse(matrix3 [-1,0,0] [0,0,1] [0,1,0] [0,0,0])
	--tm = matrix3 [tm[1].x,tm[1].z,-tm[1].y] [tm[3].x,tm[3].z,-tm[3].y] [tm[2].x,tm[2].z,-tm[2].y] [tm[4].x,tm[4].z,-tm[4].y]
		
	--format "old tm: %, new tm: %\n" oldtm tm;
		writefloat f tm.row1.x
		writefloat f tm.row1.y
		writefloat f tm.row1.z
		writefloat f tm.row2.x
		writefloat f tm.row2.y
		writefloat f tm.row2.z
		writefloat f tm.row3.x
		writefloat f tm.row3.y
		writefloat f tm.row3.z
		writefloat f tm.row4.x
		writefloat f tm.row4.y
		writefloat f -tm.row4.z
	--writestring cnt_file "["+(model.transform.row1.x as string)+", "+(model.transform.row1.y as string)+", "+(model.transform.row1.z as string)+"]"
	--writestring cnt_file "["+(model.transform.row2.x as string)+", "+(model.transform.row2.y as string)+", "+(model.transform.row2.z as string)+"]"
	--writestring cnt_file "["+(model.transform.row3.x as string)+", "+(model.transform.row3.y as string)+", "+(model.transform.row3.z as string)+"]"
	--writestring cnt_file "["+(model.transform.row4.x as string)+", "+(model.transform.row4.y as string)+", "+(model.transform.row4.z as string)+"]"
	
	if (IsObjectACNT model) == false then
	(
		if classof model == dummy then
		(
			writestring2 f "NULL"
		)
		else if classof model == editable_mesh or classof model == editable_poly or superclassof model  == geometryclass then
		(
			writestring2 f "NULL"
			/*writestring2 f "MODL"
			writelong f model_file_name_length #unsigned
			writestring2 f model_file_name
			for j = 1 to model_file_name_padding do
			(
				writebyte f 0
			)*/
		)
		else
		(
			format "ERROR! Model is not editable_poly or editable_mesh or a geometryclass! Class is: %\n Setting it to null node\n" (classof model)
			writestring2 f "NULL"
		)
	)
	else
	(
		nodeType = model.modifiers["CNT Hierarchy"].NodeType
		if nodeType == "MODL" then
		(
			writestring2 f "MODL"
			writelong f model_file_name_length #unsigned
			writestring2 f model_file_name
			for j = 1 to model_file_name_padding do
			(
				writebyte f 0 #unsigned
			)
		)
		else if nodeType == "SKIN" then
		(
			writestring2 f "SKIN"
			writelong f model_file_name_length #unsigned
			writestring2 f model_file_name
			for j = 1 to model_file_name_padding do
			(
				writebyte f 0 #unsigned
			)
		)
		else if nodeType == "LITg" then
		(
			writestring2 f "LITg"
			writelong f 3
			
			writelong f model_file_name_length #unsigned
			writestring2 f model_file_name
			for j = 1 to model_file_name_padding do
			(
				writebyte f 0 #unsigned
			)
			
		)
		else 
		(
			writestring2 f "NULL"
		)
	)
	if model.children.count > 0 do
	(
		writelong f model.children.count
		for child in model.children do
		(
			ExportCNTModel f child
		)
	)
	if model.children.count < 1 do
	(
		writelong f 0
	)
	if ActiveOctree != undefined then (
		writelong f 1
		ActiveOctree.Save f
	)
	else (
		writelong f 0
	)
)
 
fn ExportCNT cnt_name model =
(
	
	cnt_file = openfile cnt_name mode:"w"
	close cnt_file
	
	f = fopen cnt_name "wb"
	writeCNTheader f
	
	ExportCNTModel f model
	
	fclose f
)


fn ExportMDLButtonPressed sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the object to export" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "This function only supports exporting one object at a time right now!" title:"Too many objects selected!"
	)
	else
	(
		exportTexturesChecked = sender.parent.controls.Item["ExportTexturesCheckbox"].checked
		exportMatsChecked = sender.parent.controls.Item["CreateMaterialsCheckbox"].checked
		exportMTLChecked = sender.parent.controls.Item["MTLMaterialsCheckbox"].checked
		createOctree = sender.parent.controls.Item["CreateOctreeCheckbox"].checked

		if IsCRLight selection[1] then
		(

			objectFileName = selection[1].name+".light"
			if (IsObjectACNT selection[1]) do objectFileName = selection[1].modifiers["CNT Hierarchy"].FileName+".light"
			mdl_name = GetSaveFileName filename:objectFileName caption:"Save Light As" types:"LIGHT(*.LIGHT)|*.light"
			if mdl_name != undefined do
			(
				mdl_path = getFilenamePath mdl_name

				ExportLight mdl_path selection[1] exportGobo:exportTexturesChecked
				messageBox ("Export Light to "+mdl_name+" completed!") title:"Export Finished!"
				gc()
			)
		)
		else
		(
			objectFileName = selection[1].name+".mdl"
			if (IsObjectACNT selection[1]) do objectFileName = selection[1].modifiers["CNT Hierarchy"].FileName+".mdl"
			mdl_name = GetSaveFileName filename:objectFileName caption:"Save MDL As" types:"MDL(*.MDL)|*.mdl"
			if mdl_name != undefined do
			(
				mdl_path = getFilenamePath mdl_name
				global MaterialsToExport
				MaterialsToExport=#()
				ExportMDLMesh mdl_path selection[1] forcedFilename:mdl_name exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:createOctree
				ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked
				messageBox ("Export MDL to "+mdl_name+" completed!") title:"Export Finished!"
				gc()
			)
		)
	)
)

fn ExportCNTButtonPressed sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			ExportCNT cnt_name selection[1]
			messageBox ("Export CNT Hierarchy to "+cnt_name+" completed!") title:"Export Finished!"
			gc()
		)
	)
)
fn ExportFullHierarchyButtonPressed sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
		cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			exportTexturesChecked = sender.parent.controls.Item["ExportTexturesCheckbox"].checked
			exportMatsChecked = sender.parent.controls.Item["CreateMaterialsCheckbox"].checked
			exportMTLChecked = sender.parent.controls.Item["MTLMaterialsCheckbox"].checked
			exportOctreeChecked = sender.parent.controls.Item["CreateOctreeCheckbox"].checked
			global MaterialsToExport
			MaterialsToExport=#()
			mdl_path = getFilenamePath cnt_name
			selectedModel = selection[1]
			ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			ExportCNT cnt_name selectedModel
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			--PrintArrayInFull = "MaterialsToExport"
			messageBox ("Export CNT & MDL Hierarchy to "+mdl_path+" completed!") title:"Export Finished!"
		)
	)	
)