CNTTypes = #("MODL","NULL","LITg","SKIN","EMT2","VFXI")
CNTAttribute = attributes CNTCustAttribute
(
	parameters main rollout:CNTAttributeParams
	(
		
		NodeTypeID type:#integer default:1
		NodeType type:#string default:"MODL"
		FileName type:#string ui:uiFileName default:""
		
	)
	rollout CNTAttributeParams "CNT Hierarchy Params"
	(
		dropdownlist uiNodeType "Node Type" items:CNTTypes selection:NodeTypeID
		--edittext uiNodeType2 "Node Type (string)" labelOnTop:true
		edittext uiFileName "Content Filename" labelOnTop:true
		on uiNodeType selected i do 
		(
			NodeTypeID = uiNodeType.selection
			NodeType = uiNodeType.items[i]
		)
	)
)

WheelTypes = #("Wheel_FR","Wheel_FL","Wheel_RR","Wheel_RL")
WheelTypesDisplay = #("Front Right", "Front Left", "Rear Right", "Rear Left")
CarWheelAttribute = attributes CarWheelAttrib
(
	parameters main rollout:CarWheelAttribRollout
	(
		WheelTypeID type:#integer default:1
		WheelType type:#string default:"Wheel_FR"
	)
	rollout CarWheelAttribRollout "Car Wheel Params"
	(
		dropdownlist uiWheelType "Wheel Type" items:WheelTypesDisplay selection:WheelTypeID
		
		on uiWheelType selected i do
		(
			WheelTypeID = uiWheelType.selection
			WheelType = uiWheelType.items[i]
		)
	)
)

fn IsObjectACNT obj =
(
	return isProperty obj "CNTCustAttribute"
)
fn IsObjectAWheel obj =
(
	return isProperty obj "CarWheelAttrib"
)
fn SetCarWheelType mdl wheeltype =
(
	if (IsObjectAWheel mdl) do
	(
		mdl.CarWheelAttrib.WheelType = wheeltype
		mdl.CarWheelAttrib.WheelTypeID = (finditem WheelTypes wheeltype)
	)
)
fn SetCNTNodeType mdl nodetype =
(
	if (IsObjectACNT mdl) ==false do custAttributes.add mdl CNTAttribute
	
	mdl.CNTCustAttribute.NodeType = nodetype
	mdl.CNTCustAttribute.NodeTypeID= (finditem CNTTypes nodetype)
)

struct CRSettings (GamePath, TexturePath, GibbedTools)

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
struct MDLMatGroup (matID, triStrip, triStripVertOffset,patchList, patchListVertOffset)


fn writestring2 f string =
(
	writestring f string
	fseek f -1 #seek_cur
)
fn ReadString2 f fixedLen =
(
    local str = ""
    for i = 1 to fixedLen do
    (
        str0 = ReadByte f #unsigned
        if str0!=0xFD AND str0!=0xFC do str+= bit.intAsChar str0
    )
    str
)
fn witepaddedstring f str =
(
	str_length =  str.count
	str_div4 = str_length / 4
	str_plus1 = 0
	if (mod str_length 4) > 0 do
	(
		str_plus1=1
	)
	str_added = str_div4 + str_plus1
	str_padding = (str_added * 4) - str_length + 4
	writelong f str_length #unsigned
	writestring2 f str
	for i = 1 to str_padding do
	(
		writebyte f 0
	)
)
fn readpaddedstring f =
(
	str_length =  readlong f #unsigned
	str_div4 = str_length / 4
	str_plus1 = 0
	if (mod str_length 4) > 0 do
	(
		str_plus1=1
	)
	str_added = str_div4 + str_plus1
	str_padding = (str_added * 4) - str_length + 4
	newString = readstring2 f str_length
	for i = 1 to str_padding do
	(
		readbyte f
	)
	return newString
)

fn writeCNTheader f =
(
	writebyte f 69
	writebyte f 35
	writebyte f 0
	writebyte f 4
)

fn readCNTheader f =
(
	readbyte f
	readbyte f
	readbyte f
	readbyte f
)

fn writeMDLheader f =
(
	writebyte f 69
	writebyte f 35
	writebyte f 2
	writebyte f 6
)

fn CheckBitIsSet flags bitNum =
(
	if bitNum==0 then
	(
		if (bit.and flags 1)==1 then return true
		else return false
	)
	else if (bit.and flags (bit.shift 1 bitNum))==(bit.shift 1 bitNum) then return true
	else return false
)
fn printFlagBits flags numBits fieldName =
(
	format "% has value of %\nIt's bits: " fieldName flags
	for i = (numBits-1) to 0 by -1 do
	(
		if (CheckBitIsSet flags i) then format "%" 1
		else format "%" 0
	)
	format "\n"
	
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

fn PrintArrayInFull arrayToPrint arrayName ignoreUndefined:false =
(
	format "\n\n% size: % \n" arrayName arrayToPrint.count
	format "% contents:\n" arrayName
	for i=1 to arrayToPrint.count do
	(
		if ignoreUndefined == false or arrayToPrint[i] != undefined do
		(
			format "%: %\n" i arrayToPrint[i]
		)
	)
	format "\n-------------\n"
)

fn AdjEdgeSortAll arrayToSort =
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
	
	--format "\nThird Pass: %\n" sorted.count
	--format "Third Pass:\n%\n" sorted
	
	-- PrintArrayInFull sorted "Final Pass"
	return sorted
)
fn FindAdjacentTriEdge tri v1 v2 =
(
	if tri.ref[1] == v1 and tri.ref[2] == v2 do return 1
	if tri.ref[1] == v2 and tri.ref[2] == v1 do return 1
		
	if tri.ref[1] == v1 and tri.ref[3] == v2 do return 2
	if tri.ref[1] == v2 and tri.ref[3] == v1 do return 2
		
	if tri.ref[2] == v1 and tri.ref[3] == v2 do return 3
	if tri.ref[2] == v2 and tri.ref[3] == v1 do return 3
		
	return 255
)

fn FindOppositeTriVert tri v1 v2 =
(
	if tri.ref[1] == v1 and tri.ref[2] == v2 do return 3
	if tri.ref[1] == v2 and tri.ref[2] == v1 do return 3
		
	if tri.ref[1] == v1 and tri.ref[3] == v2 do return 2
	if tri.ref[1] == v2 and tri.ref[3] == v1 do return 2
		
	if tri.ref[2] == v1 and tri.ref[3] == v2 do return 1
	if tri.ref[2] == v2 and tri.ref[3] == v1 do return 1
		
	return -1
)

fn CreateAdjacencyDB faceCount indexBuffer =
(
	global AdjTris = #()
	global AdjEdges = #()
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
	
	Sorted = AdjEdgeSortAll (deepcopy AdjEdges)
	
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
	return len
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
		)
	)
	append strips (deepcopy strip[best])
	--format "nFaces from this strip: %\n" nFaces
	return nFaces
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
		append removeOldStrip true
	)
	
	--format "strips.count = % \n removeOldStrip.count = %\n" strips.count removeOldStrip.count
	for i=strips.count to 1 by -1 do
	(
		if removeOldStrip[i] do 
		(
			deleteItem strips i
		)
	)
	insertItem mergedStrip strips 1
)

fn StripperShakeItBaby faceCount indices =
(
	--print "Shake It Baby!"
	strips = #()
	CreateAdjacencyDB faceCount indices
	
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
	--for i =1 to strips.count do
	--(
			--stripname = stringstream""
			--format "RawStrips[%]" i to:stripname
			--PrintArrayInFull strips[i] (stripname as string)
	--)
	
	MergeStrips &strips
	
	return strips
)


fn calcMeshBoundingBox verts =
(
	local vmin = undefined
	local vmax = undefined
	for vert in verts do
	(
		if vmin == undefined then vmin = [vert.x, vert.y, vert.z]
		else
		(
			if vmin.x > vert.x do vmin.x = vert.x
			if vmin.y > vert.y do vmin.y = vert.y
			if vmin.z > vert.z do vmin.z= vert.z
		)
		if vmax == undefined then vmax = [vert.x, vert.y, vert.z]
		else
		(
			if vmax.x < vert.x do vmax.x = vert.x
			if vmax.y < vert.y do vmax.y = vert.y
			if vmax.z < vert.z do vmax.z= vert.z
		)
			
	)
	vhalfDist = (length (vmax - vmin)) / 2
	vcenter = vmin + ((vmax - vmin) / 2)
	return (mbbox vmin: vmin vmax: vmax center: vcenter halfdist: vhalfDist)
)


fn bboxHasVert bboxVerts vert =
(
	for i=1 to bboxVerts.count do
	(
		if bboxVerts[i].x == vert.x and bboxVerts[i].y == vert.y and bboxVerts[i].z == vert.z do return true
	)
	return false
)

fn ExportMDLMesh folder_name model forcedFilename:"" =
(
	
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
	
	model_name = model.name
	if IsObjectACNT model do model_name = model.FileName
	mdl_name = folder_name+model_name+".mdl"
	if forcedFilename!="" do mdl_name=forcedFilename
	mdl_file = openfile mdl_name mode:"w"
	close mdl_file
	
	m = snapshotasmesh model
	
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
	normOldScale = normalize oldScale
	
	if normOldScale.x < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.x = 1
	)
	if normOldScale.y < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.y = -1
	)
	if normOldScale.z < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.z = -1
	)
	
    PREPFaceVerts = #()
	for i=1 to (getNumVerts m) do
	(
		pos = (getVert m i) * mirroredTransformScale
				
		append USERVerts (mdlUserVert x:pos.x y:pos.y  z:pos.z TimesUsed: 1)
	)
	
	vertNormals =#()
	faceIndicesForNormals =#()
	newVertsList = #()
	faceNewVertInds = #()
	faceIndicesForTVs =#()
	facesForMatID = #()
	tvToUSERVerts = #()
	for i=1 to numFaces do
	(
		faceCVerts = undefined
		faceTVertInds = undefined
		
		vertInds = getFace m i
		if meshHasVertColours do faceCVerts = getVCFace m i
		if meshHasTextureVerts then faceTVertInds = getTVFace m i
		else faceTVertInds = vertInds
		faceMatID = getfacematid m i
		
		
		rNorms = meshop.getFaceRNormals m i
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
		
		planeNormal = (cross (v2Data - v1Data) (v3Data - v1Data)) * mirroredTransformScale
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
		
		rNorms[1] = rNorms[1] * mirroredTransformScale
		rNorms[2] = rNorms[2] * mirroredTransformScale
		rNorms[3] = rNorms[3] * mirroredTransformScale
		
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
		
		
		USERFace =  mdlUserFace PlaneD:planeD PlaneX:planeNormal.x PlaneY:planeNormal.z PlaneZ:-planeNormal.y SmoothingGroup:smoothingGroup MaterialIndex:faceMatID v1Colour:v1Colour v2Colour:v2Colour v3Colour:v3Colour v1:VertInd1  v2:VertInd2  v3:VertInd3 v1NormX:rNorms[1].x v1NormY:rNorms[1].y v1NormZ:rNorms[1].z v2NormX:rNorms[2].x v2NormY:rNorms[2].y v2NormZ:rNorms[2].z v3NormX:rNorms[3].x v3NormY:rNorms[3].y v3NormZ:rNorms[3].z v1U:v1U v1V:v1V v1U2:v1U2 v1V2:v1V2 v2U:v2U v2V:v2V v2U2:v2U2 v2V2:v2V2 v3U:v3U v3V:v3V v3U2:v3U2 v3V2:v3V2
		
		append USERFaces USERFace
		append mid faceMatID
	)
	if meshHasTextureVerts == false then tv_count = USERVerts.count
	
	for i=1 to tv_count do
	(
		--pos = [USERVerts[tvToUSERVerts[i]].x,USERVerts[tvToUSERVerts[i]].y,USERVerts[tvToUSERVerts[i]].z]
		normalsForThisVert = vertNormals[i]
		faceIndicesForThisVert = faceIndicesForNormals[i]
		--facesForVert = meshop.getFacesUsingVert m #(i)
		
		for j=1 to normalsForThisVert.count do
		(
			currentVertNormal = normalsForThisVert[j]
			faceIndicesForThisNormal = faceIndicesForThisVert[j]
			append newVertsList #(pos,currentVertNormal)
			
			for k=1 to faceIndicesForThisNormal.count do
			(
				USERVerts[tvToUSERVerts[i]].TimesUsed +=1
				if(faceNewVertInds[faceIndicesForThisNormal[k]] == undefined) do faceNewVertInds[faceIndicesForThisNormal[k]] = #()
				faceNewVertInds[faceIndicesForThisNormal[k]][i] = newVertsList.count
			)
		)
	)
	
	mid = makeUniqueArray mid
	
	modelMat = model.material
	facesForFinalMatID = #()
	if modelMat != undefined then
	(
		format "Material is a \"%\"\n" (classof modelMat)
		usedMats = #()
		if classof modelMat == multimaterial do
		(
			
			for i=1 to mid.count do
			(
				faceMatID = mid[i]
				subMatName = modelMat.materiallist[faceMatID].name
				if subMatName != undefined do
				(
					usedMatPos = finditem usedMats subMatName
					
					if usedMatPos == 0 do 
					(
						append usedMats subMatName
						usedMatPos = usedMats.count
					)
					mtlconv[faceMatID] = usedMatPos
					if facesForFinalMatID[usedMatPos] == undefined then facesForFinalMatID[usedMatPos] = facesForMatID[faceMatID]
					else facesForFinalMatID[usedMatPos] = facesForFinalMatID[usedMatPos] + facesForMatID[faceMatID]
				)
			)
			for i=1 to usedMats.count do
			(
				format "Setting Default Name\n"
				matName =usedMats[i]
				if usedMats[i] == undefined or usedMats[i] == "" do matName = "Default"+(i as string)
				
				append mtl matName
			)
		)
		if classof modelMat == standardmaterial do
		(
		
			append mtl modelMat.name
			
			for i=1 to mid.count do
			(
				faceMatID = mid[i]
				
				mtlconv[faceMatID] = 1
				
				if facesForFinalMatID[1] == undefined then facesForFinalMatID[1] = facesForMatID[faceMatID]
				else facesForFinalMatID[1] = facesForFinalMatID[1] + facesForMatID[faceMatID]
			)
		)
	)
	else
	(
		append mtl "Default01"
		for i=1 to mid.count do
		(
			faceMatID = mid[i]
			
			mtlconv[faceMatID] = 1
			
			if facesForFinalMatID[1] == undefined then facesForFinalMatID[1] = facesForMatID[faceMatID]
			else facesForFinalMatID[1] = facesForFinalMatID[1] + facesForMatID[faceMatID]
		)
	)
	format "mtl: %\n" mtl
	finalFaceCount = 0
	format "Doing model %\n" model.name
	--format " verts.count: %\n t_verts.count: %\n faces.count: %\n" verts.count t_verts.count faces.count

	--format "--------- oldScale: [%, %, %]\n" oldScale.x oldScale.y oldScale.z
	--format "--------- oldTransform.scalepart: [%, %, %]\n" oldTransform.scalepart.x oldTransform.scalepart.y oldTransform.scalepart.z
	--format "--------- model.transform[1]: [%, %, %]\n" oldTransform[1].x oldTransform[1].y oldTransform[1].z
	--format "--------- model.transform[2]: [%, %, %]\n" oldTransform[2].x oldTransform[2].y oldTransform[2].z
	--format "--------- model.transform[3]: [%, %, %]\n" oldTransform[3].x oldTransform[3].y oldTransform[3].z
	
	for i=1 to mtl.count do
	(
		
		meshVerts = #()
		local bboxVerts = #()
		meshFaces = #()
		meshVertInds = #()
		meshVertsDone = #()
		meshVertsConv = #()
		meshFaceCount = 0
		
		format "I = %\n num faces for this MatID: %\n" i facesForFinalMatID[i].count
		

		for h=1 to facesForFinalMatID[i].count do
		(

			j = facesForFinalMatID[i][h]
			face = USERFaces[j]
			
			--vertInds = getFace m j
			--faceMatID = getfacematid m j
			
			--if mtlconv[faceMatID] != i do continue
			
			VertInd1 = face.v1
			VertInd2 = face.v2
			VertInd3 = face.v3
			
			v1Pos = USERVerts[VertInd1]
			v2Pos = USERVerts[VertInd2]
			v3Pos = USERVerts[VertInd3]
			
			bboxVerts = copy USERVerts #noMap
			--if (bboxHasVert bboxVerts v1Pos) == false do append bboxVerts v1Pos
			--if (bboxHasVert bboxVerts v2Pos) == false do append bboxVerts v2Pos
			--if (bboxHasVert bboxVerts v3Pos) == false do append bboxVerts v3Pos
			--format "J = %\n" j
			
			--format "faceIndicesForTVs[j] = %\n" faceIndicesForTVs[j]
			--format "faceIndicesForTVs[j][1] = % - faceIndicesForTVs[j][2] = % - faceIndicesForTVs[j][3] = %\n" faceIndicesForTVs[j][1] faceIndicesForTVs[j][2] faceIndicesForTVs[j][3]
			oldMeshVertInd1 = faceNewVertInds[j][faceIndicesForTVs[j][1]]
			oldMeshVertInd2 = faceNewVertInds[j][faceIndicesForTVs[j][2]]
			oldMeshVertInd3 = faceNewVertInds[j][faceIndicesForTVs[j][3]]
			
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
			
			
			newFace = #([ newMeshVertInd1 ,  newMeshVertInd2 ,  newMeshVertInd3 ], face.SmoothingGroup, i)
			
			
			append meshFaces newFace
			finalVertInd1 = newMeshVertInd1 + stripOffset
			finalVertInd2 = newMeshVertInd2 + stripOffset
			finalVertInd3 = newMeshVertInd3 + stripOffset
			
			finalFace = #([ finalVertInd1 ,  finalVertInd2 ,  finalVertInd3 ], face.SmoothingGroup, i)
			
			append PREPFaces finalFace
			PREP2USERfaceConv[PREPFaces.count] = j
			USER2PREPfaceConv[j] = PREPFaces.count
			
			meshFaceCount = meshFaceCount + 1
			finalFaceCount = finalFaceCount + 1
		)

			meshFaceCount = meshFaces.count
			finalFaceCount = finalFaceCount + meshFaces.count
		bbox = calcMeshBoundingBox bboxVerts

		
		shakenStrips = StripperShakeItBaby meshFaceCount meshVertInds
		stripList = #()
		

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
			stripPatch = shakenStrips[i]
			append patchList stripPatch[1]
			append patchList stripPatch[2]
			append patchList stripPatch[3]
		)
		
		newMesh = mdlMesh verts:(deepcopy meshVerts) faces:(deepcopy meshVertInds) stripOffset:stripOffset stripVertCount:meshVerts.count StripList:(deepcopy stripList) patchOffset:patchOffset patchVertCount:meshVerts.count PatchList:(deepcopy patchList) BBox:bbox

		append meshes newMesh
		stripOffset = PREPVerts.count
		patchOffset = PREPVerts.count
	)
	
	
		uniqueVerts = #()
		
		
	
	f = fopen mdl_name "wb"
	
	try
	(
		--print "Exporting MDL to file\n\nWriting Header"
		writeMDLheader f
		
		-- Unknown
		writebyte f 0
		writebyte f 0
		writebyte f 0
		writebyte f 0
		
		-- Flags
		writelong f 1 #unsigned
		
		-- Unknown
		--writebyte f 0
		--writebyte f 0
		--writebyte f 0
		--writebyte f 0
		writelong f 1 #unsigned
		
		--print "Writing Faces Count"
		-- TODO Add Faces Count
		writelong f PREPFaces.count #unsigned
		
		
		--print "Writing Unique Verts Count"
		-- TODO Add Unique Vert Position Count
		writelong f USERVerts.count #unsigned
		
		writelong f 0 
		
		--print "Writing Bounding Box"
		-- TODO Add Space For total ByteSize - Header
		bboxHalfDistance = (length (model.max - model.min) ) / 2
		
		writefloat f bboxHalfDistance
		writefloat f model.min.x
		writefloat f model.min.z
		writefloat f model.min.y
		writefloat f model.max.x
		writefloat f model.max.z
		writefloat f model.max.y
		writefloat f model.center.x
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
			faceMatID = face[3] - 1
			if faceMatID == undefined or faceMatID < 0 do faceMatID = 0
			writeshort f faceMatID #unsigned
			writeshort f 0
			faceInd1 = face[1].x - 1
			faceInd2 = face[1].y - 1
			faceInd3 = face[1].z - 1
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
			writefloat f -vert.tex.y
			
			writefloat f vert.tex2.x
			writefloat f -vert.tex2.y
			
			writebyte f vert.colour.r
			writebyte f vert.colour.g
			writebyte f vert.colour.b
			writebyte f vert.colour.a
			
			numVertsWrote = numVertsWrote + 1
		)
		
		--print "Writing Meshes Count"
		writeshort f meshes.count #unsigned
		
		
		--print "Writing Meshes"
		for mdlmsh in meshes do
		(
			
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
						writelong f (mdlmsh.StripList[j][1] - 1) #unsigned
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
		
		writelong f 0
		
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
			writefloat f face.PlaneZ
			writefloat f -face.PlaneD
			
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
			
			--format "Writing % colours - " 3
			writebyte f face.v1Colour.r
			writebyte f face.v1Colour.g
			writebyte f face.v1Colour.b
			writebyte f face.v1Colour.a
			
			writebyte f face.v2Colour.r
			writebyte f face.v2Colour.g
			writebyte f face.v2Colour.b
			writebyte f face.v2Colour.a
			
			writebyte f face.v2Colour.r
			writebyte f face.v2Colour.g
			writebyte f face.v2Colour.b
			writebyte f face.v2Colour.a
			
			--format "Writing % texcoords\n" 6
			writefloat f face.v1U
			writefloat f face.v1V
			writefloat f face.v1U2
			writefloat f face.v1V2
			
			writefloat f face.v2U
			writefloat f face.v2V
			writefloat f face.v2U2
			writefloat f face.v2V2
			
			writefloat f face.v3U
			writefloat f face.v3V
			writefloat f face.v3U2
			writefloat f face.v3V2
			
			writelong f 0
			writebyte f 0
		)
		
		--format "Writing PREP2USER face map data %\n" " "
		--print "Writing Face Numbers"
		-- TODO Write Sequence Of Faces Numbers ???
		for i=1 to PREP2USERfaceConv.count do
		(
			writelong f (i-1)
		)
		
		--print "Writing Vertex Count"
		-- TODO Write Vertex Count (Again???)
		
		--format "Writing PREP2USER vert count data %\n" " "
		writelong f PREP2USERvertConv.count
		
		
		
		--format "Writing PREP2USER vert map data %\n" " "
		--print "Writing Vertex Numbers"
		-- TODO Write Sequence Of Vertex Numbers ????????
		for i=1 to PREP2USERvertConv.count do
		(
			writelong f (i-1)
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
	
	if exceptionHappened then format "MDL Export for \"%\" Finished With Errors!" model.name
	--else print "Finished MDL Export!"
	model.transform = oldTransform
)

fn GatherMDLs nodes exportHierarchy =
(
	
	global models
	for model in nodes do
	(
			if exportHierarchy == true do
			(
				GatherMDLs model.children exportHierarchy
			)
			isACNT = IsObjectACNT model
		if (isACNT and model.CNTCustAttribute.NodeType == "MODL") or (isACNT == false  and classof model != dummy and (classof model == editable_mesh or classof model == editable_poly or superclassof model == geometryclass)) do
		(
			if finditem models model == 0 do
			(
				format "Found model \"%\" which is a %\n" model.name (classof model)
				append models model
			)
			
		)
	)
	PrintArrayInFull models "Models Found"
)

fn ExportMDL folder_name exportSelected exportHierarchy =
(
	global materials = #()
	global models = #()
	modelsDone = #()
	
	local nodes
	if exportSelected == true do
	(
		nodes = selection
	)
	if exportSelected == false do
	(
		nodes = for model in objects where model.ishidden == false collect model
	)
	
	GatherMDLs nodes exportHierarchy
	
	
	for mat in scenematerials do
	(
		if classof mat == standardmaterial do
		(
			if finditem materials mat == 0 do append materials mat
		)
		if classof mat == multimaterial do
		(
			for i = 1 to mat.numsubs do
			(
				submat = getsubmtl mat i
				if finditem materials submat == 0 do append materials submat
			)
		)
	)
	for nodeToExport in models do
	(
		ExportMDLMesh folder_name nodeToExport
	)
)

fn ExportCNTModel f model =
(
	format "Saving node % to CNT\n" model.name
	model_name = model.name
	model_name_length =  model_name.count
	
	if (IsObjectACNT model) == true then
	(
		if model.FileName != "" then model_file_name = model.FileName
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
		writebyte f 0
	)
		writebyte f 0
		writefloat f 0.0
	tm = copy model.transform
	
	numAxisNegativeScale = 0
	mirroredTransformScale = [1,1,1]
	
	
	if model.scale.x < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.x = -1
	)
	if model.scale.y < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.y = -1
	)
	if model.scale.z < 0 do
	(
		numAxisNegativeScale = numAxisNegativeScale + 1
		mirroredTransformScale.z = -1
	)
	tm = scale tm mirroredTransformScale false
	if model.parent != undefined do tm = tm * (inverse model.parent.transform)
	tm = matrix3 [-1,0,0] [0,0,1] [0,1,0] [0,0,0] * tm * inverse(matrix3 [-1,0,0] [0,0,1] [0,1,0] [0,0,0])
	--tm = matrix3 [tm[1].x,tm[1].z,-tm[1].y] [tm[3].x,tm[3].z,-tm[3].y] [tm[2].x,tm[2].z,-tm[2].y] [tm[4].x,tm[4].z,-tm[4].y]
		
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
			writestring2 f "MODL"
			writelong f model_file_name_length #unsigned
			writestring2 f model_file_name
			for j = 1 to model_file_name_padding do
			(
				writebyte f 0
			)
		)
		else
		(
			format "ERROR! Model is not editable_poly or editable_mesh or a geometryclass! Class is: %\n Setting it to null node\n" (classof model)
			writestring2 f "NULL"
		)
	)
	else
	(
		nodeType = model.NodeType
		if nodeType == "MODL" then
		(
			writestring2 f "MODL"
			writelong f model_file_name_length #unsigned
			writestring2 f model_file_name
			for j = 1 to model_file_name_padding do
			(
				writebyte f 0
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
	writelong f 0
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

fn CreateNewWheelNode trans wheelType selectAndFocus:false addAttributes:true =
(
	m = mesh vertices:#([-0.163197, 0.0, -0.316496],[-0.163197, 0.108248, -0.297409],[-0.163198, 0.20344, -0.24245],[-0.163198, 0.274093, -0.158248],[-0.163198, 0.311688, -0.0549589],[-0.163198, 0.311688, 0.0549589],[-0.163198, 0.274093, 0.158248],[-0.163198, 0.20344, 0.24245],[-0.163198, 0.108248, 0.297409],[-0.163198, 0.0, 0.316496],[-0.163198, -0.108248, 0.297409],[-0.163198, -0.20344, 0.24245],[-0.163198, -0.274093, 0.158248],[-0.163198, -0.311687, 0.054959],[-0.163198, -0.311688, -0.0549588],[-0.163198, -0.274093, -0.158248],[-0.163198, -0.20344, -0.24245],[-0.163198, -0.108248, -0.297409],[0.0, 0.122818, -0.33744],[0.0, 0.230822, -0.275083],[0.0, 0.310986, -0.179548],[0.0, 0.35364, -0.0623563],[0.0, 0.35364, 0.0623563],[0.0, 0.310986, 0.179548],[0.0, 0.230822, 0.275083],[0.0, 0.122818, 0.33744],[0.0, 0.0, 0.359096],[0.0, -0.122818, 0.33744],[0.0, -0.230822, 0.275083],[0.0, -0.310986, 0.179548],[0.0, -0.35364, 0.0623564],[0.0, -0.35364, -0.0623562],[0.0, -0.310986, -0.179548],[0.0, -0.230822, -0.275083],[0.0, -0.122818, -0.33744],[0.0, 0.0, -0.359096],[0.163197, 0.0, -0.316496],[0.163197, 0.108248, -0.297409],[0.163197, 0.20344, -0.24245],[0.163197, 0.274093, -0.158248],[0.163197, 0.311688, -0.0549589],[0.163197, 0.311688, 0.0549589],[0.163197, 0.274093, 0.158248],[0.163197, 0.20344, 0.24245],[0.163197, 0.108248, 0.297409],[0.163197, 0.0, 0.316496],[0.163197, -0.108248, 0.297409],[0.163197, -0.20344, 0.24245],[0.163197, -0.274093, 0.158248],[0.163197, -0.311687, 0.054959],[0.163197, -0.311688, -0.0549588],[0.163197, -0.274093, -0.158248],[0.163197, -0.20344, -0.24245],[0.163197, -0.108248, -0.297409],[0.163197, 0.0, -0.275879],[0.163197, 0.0943561, -0.259241],[0.163197, 0.177331, -0.211335],[0.163197, 0.238918, -0.137939],[0.163197, 0.271688, -0.0479058],[0.163197, 0.271688, 0.0479059],[0.163197, 0.238918, 0.137939],[0.163197, 0.177331, 0.211335],[0.163197, 0.0943561, 0.259241],[0.163197, 0.0, 0.275879],[0.163197, -0.094356, 0.259241],[0.163197, -0.177331, 0.211335],[0.163197, -0.238918, 0.137939],[0.163197, -0.271687, 0.0479059],[0.163197, -0.271688, -0.0479057],[0.163197, -0.238918, -0.137939],[0.163197, -0.177332, -0.211335],[0.163197, -0.0943563, -0.259241],[-0.0768025, 0.0, -0.275879],[-0.0768025, 0.0943561, -0.259241],[-0.0768026, 0.177331, -0.211335],[-0.0768026, 0.238918, -0.137939],[-0.0768026, 0.271688, -0.0479059],[-0.0768025, 0.271688, 0.0479058],[-0.0768026, 0.238918, 0.137939],[-0.0768026, 0.177331, 0.211335],[-0.0768026, 0.0943561, 0.259241],[-0.0768026, 0.0, 0.275879],[-0.0768025, -0.094356, 0.259241],[-0.0768026, -0.177331, 0.211335],[-0.0768026, -0.238918, 0.137939],[-0.0768025, -0.271687, 0.0479059],[-0.0768025, -0.271688, -0.0479057],[-0.0768026, -0.238918, -0.137939],[-0.0768026, -0.177332, -0.211335],[-0.0768025, -0.0943563, -0.259241]) faces:#([1.0, 2.0, 19.0],[19.0, 36.0, 1.0],[2.0, 3.0, 20.0],[20.0, 19.0, 2.0],[3.0, 4.0, 21.0],[21.0, 20.0, 3.0],[4.0, 5.0, 22.0],[22.0, 21.0, 4.0],[5.0, 6.0, 23.0],[23.0, 22.0, 5.0],[6.0, 7.0, 24.0],[24.0, 23.0, 6.0],[7.0, 8.0, 25.0],[25.0, 24.0, 7.0],[8.0, 9.0, 26.0],[26.0, 25.0, 8.0],[9.0, 10.0, 27.0],[27.0, 26.0, 9.0],[10.0, 11.0, 28.0],[28.0, 27.0, 10.0],[11.0, 12.0, 29.0],[29.0, 28.0, 11.0],[12.0, 13.0, 30.0],[30.0, 29.0, 12.0],[13.0, 14.0, 31.0],[31.0, 30.0, 13.0],[14.0, 15.0, 32.0],[32.0, 31.0, 14.0],[15.0, 16.0, 33.0],[33.0, 32.0, 15.0],[16.0, 17.0, 34.0],[34.0, 33.0, 16.0],[17.0, 18.0, 35.0],[35.0, 34.0, 17.0],[18.0, 1.0, 36.0],[36.0, 35.0, 18.0],[36.0, 19.0, 38.0],[38.0, 37.0, 36.0],[19.0, 20.0, 39.0],[39.0, 38.0, 19.0],[20.0, 21.0, 40.0],[40.0, 39.0, 20.0],[21.0, 22.0, 41.0],[41.0, 40.0, 21.0],[22.0, 23.0, 42.0],[42.0, 41.0, 22.0],[23.0, 24.0, 43.0],[43.0, 42.0, 23.0],[24.0, 25.0, 44.0],[44.0, 43.0, 24.0],[25.0, 26.0, 45.0],[45.0, 44.0, 25.0],[26.0, 27.0, 46.0],[46.0, 45.0, 26.0],[27.0, 28.0, 47.0],[47.0, 46.0, 27.0],[28.0, 29.0, 48.0],[48.0, 47.0, 28.0],[29.0, 30.0, 49.0],[49.0, 48.0, 29.0],[30.0, 31.0, 50.0],[50.0, 49.0, 30.0],[31.0, 32.0, 51.0],[51.0, 50.0, 31.0],[32.0, 33.0, 52.0],[52.0, 51.0, 32.0],[33.0, 34.0, 53.0],[53.0, 52.0, 33.0],[34.0, 35.0, 54.0],[54.0, 53.0, 34.0],[35.0, 36.0, 37.0],[37.0, 54.0, 35.0],[17.0, 16.0, 15.0],[15.0, 14.0, 13.0],[13.0, 12.0, 11.0],[15.0, 13.0, 11.0],[11.0, 10.0, 9.0],[9.0, 8.0, 7.0],[11.0, 9.0, 7.0],[7.0, 6.0, 5.0],[5.0, 4.0, 3.0],[7.0, 5.0, 3.0],[11.0, 7.0, 3.0],[15.0, 11.0, 3.0],[3.0, 2.0, 1.0],[15.0, 3.0, 1.0],[17.0, 15.0, 1.0],[18.0, 17.0, 1.0],[74.0, 75.0, 76.0],[76.0, 77.0, 78.0],[78.0, 79.0, 80.0],[76.0, 78.0, 80.0],[80.0, 81.0, 82.0],[82.0, 83.0, 84.0],[80.0, 82.0, 84.0],[84.0, 85.0, 86.0],[86.0, 87.0, 88.0],[84.0, 86.0, 88.0],[80.0, 84.0, 88.0],[76.0, 80.0, 88.0],[88.0, 89.0, 90.0],[76.0, 88.0, 90.0],[74.0, 76.0, 90.0],[73.0, 74.0, 90.0],[37.0, 38.0, 56.0],[56.0, 55.0, 37.0],[38.0, 39.0, 57.0],[57.0, 56.0, 38.0],[39.0, 40.0, 58.0],[58.0, 57.0, 39.0],[40.0, 41.0, 59.0],[59.0, 58.0, 40.0],[41.0, 42.0, 60.0],[60.0, 59.0, 41.0],[42.0, 43.0, 61.0],[61.0, 60.0, 42.0],[43.0, 44.0, 62.0],[62.0, 61.0, 43.0],[44.0, 45.0, 63.0],[63.0, 62.0, 44.0],[45.0, 46.0, 64.0],[64.0, 63.0, 45.0],[46.0, 47.0, 65.0],[65.0, 64.0, 46.0],[47.0, 48.0, 66.0],[66.0, 65.0, 47.0],[48.0, 49.0, 67.0],[67.0, 66.0, 48.0],[49.0, 50.0, 68.0],[68.0, 67.0, 49.0],[50.0, 51.0, 69.0],[69.0, 68.0, 50.0],[51.0, 52.0, 70.0],[70.0, 69.0, 51.0],[52.0, 53.0, 71.0],[71.0, 70.0, 52.0],[53.0, 54.0, 72.0],[72.0, 71.0, 53.0],[54.0, 37.0, 55.0],[55.0, 72.0, 54.0],[55.0, 56.0, 74.0],[74.0, 73.0, 55.0],[56.0, 57.0, 75.0],[75.0, 74.0, 56.0],[57.0, 58.0, 76.0],[76.0, 75.0, 57.0],[58.0, 59.0, 77.0],[77.0, 76.0, 58.0],[59.0, 60.0, 78.0],[78.0, 77.0, 59.0],[60.0, 61.0, 79.0],[79.0, 78.0, 60.0],[61.0, 62.0, 80.0],[80.0, 79.0, 61.0],[62.0, 63.0, 81.0],[81.0, 80.0, 62.0],[63.0, 64.0, 82.0],[82.0, 81.0, 63.0],[64.0, 65.0, 83.0],[83.0, 82.0, 64.0],[65.0, 66.0, 84.0],[84.0, 83.0, 65.0],[66.0, 67.0, 85.0],[85.0, 84.0, 66.0],[67.0, 68.0, 86.0],[86.0, 85.0, 67.0],[68.0, 69.0, 87.0],[87.0, 86.0, 68.0],[69.0, 70.0, 88.0],[88.0, 87.0, 69.0],[70.0, 71.0, 89.0],[89.0, 88.0, 70.0],[71.0, 72.0, 90.0],[90.0, 89.0, 71.0],[72.0, 55.0, 73.0],[73.0, 90.0, 72.0])
	m.transform = trans
	m.name = wheelType
	for i=1 to (GetNumFaces m) do
	(
		setFaceSmoothGroup m i 1
	)
	
	
		
	if addAttributes do
	(
		custAttributes.add m CNTAttribute #unique BaseObject:true
		SetCNTNodeType m "NULL"
		m.CNTCustAttribute.FileName = ""
	)

	
	custAttributes.add m CarWheelAttribute #unique BaseObject:true
	SetCarWheelType m wheelType
	
	if selectAndFocus do
	(
		select m
		max zoomext sel all
	)
	return m
)

fn CreateNewNULLNode trans nodename addAttributes:true selectAndFocus:false =
(
	
	--m = mesh vertices:#([0.05,0.05,0.05], [-0.05,0.05,0.05], [-0.05,-0.05,0.05], [0.05,-0.05,0.05],[0.05,0.05,-0.05], [-0.05,0.05,-0.05], [-0.05,-0.05,-0.05], [0.05,-0.05,-0.05]) faces:#([1,2,3], [1,3,4],[5,7,6],[5,8,7],[1,5,2],[2,5,6],[4,3,7],[4,7,8], [1,4,5],[5,4,8],[3,2,6],[3,6,7])
	m = mesh vertices:#([-0.00750644, -0.292164, -0.0157009],[0.00750644, -0.292164, -0.0157009],[-0.0225933, -0.022668, -0.0224066],[0.0225186, -0.0225186, -0.0224066],[-0.00750644, -0.292164, -0.000688014],[0.00750644, -0.292164, -0.000688014],[-0.0225933, -0.022668, 0.0224065],[0.0225186, -0.0225186, 0.0224065],[0.292164, -0.00750644, -0.00750644],[0.292164, 0.00750644, -0.00750644],[0.292164, -0.00750644, 0.00750644],[0.292164, 0.00750644, 0.00750644],[-0.0225933, 0.0225933, -0.0224065],[-0.00750644, 0.00750644, 0.27705],[0.00750644, 0.00750644, 0.27705],[0.022668, 0.0225933, -0.0224065],[0.00750644, -0.00750645, 0.27705],[-0.00750644, -0.00750645, 0.27705],[0.022668, 0.0225933, 0.0224065],[-0.0225933, 0.0225933, 0.0224065]) faces:#([1.0, 3.0, 4.0],[4.0, 2.0, 1.0],[5.0, 6.0, 8.0],[8.0, 7.0, 5.0],[1.0, 2.0, 6.0],[6.0, 5.0, 1.0],[2.0, 4.0, 8.0],[8.0, 6.0, 2.0],[3.0, 1.0, 5.0],[5.0, 7.0, 3.0],[9.0, 4.0, 16.0],[16.0, 10.0, 9.0],[11.0, 12.0, 19.0],[19.0, 8.0, 11.0],[9.0, 10.0, 12.0],[12.0, 11.0, 9.0],[10.0, 16.0, 19.0],[19.0, 12.0, 10.0],[4.0, 9.0, 11.0],[11.0, 8.0, 4.0],[13.0, 19.0, 16.0],[13.0, 4.0, 3.0],[15.0, 14.0, 18.0],[18.0, 17.0, 15.0],[20.0, 7.0, 18.0],[18.0, 14.0, 20.0],[14.0, 15.0, 19.0],[19.0, 20.0, 14.0],[17.0, 18.0, 7.0],[7.0, 8.0, 17.0],[15.0, 17.0, 8.0],[8.0, 19.0, 15.0],[20.0, 13.0, 7.0],[13.0, 20.0, 19.0],[13.0, 16.0, 4.0],[13.0, 3.0, 7.0])

	setFaceSmoothGroup m 1 1
	setFaceMatID m 1 2
	setFaceSmoothGroup m 2 1
	setFaceMatID m 2 2
	setFaceSmoothGroup m 3 1
	setFaceMatID m 3 2
	setFaceSmoothGroup m 4 1
	setFaceMatID m 4 2
	setFaceSmoothGroup m 5 2
	setFaceMatID m 5 2
	setFaceSmoothGroup m 6 2
	setFaceMatID m 6 2
	setFaceSmoothGroup m 7 4
	setFaceMatID m 7 2
	setFaceSmoothGroup m 8 4
	setFaceMatID m 8 2
	setFaceSmoothGroup m 9 4
	setFaceMatID m 9 2
	setFaceSmoothGroup m 10 4
	setFaceMatID m 10 2
	setFaceSmoothGroup m 11 1
	setFaceMatID m 11 1
	setFaceSmoothGroup m 12 1
	setFaceMatID m 12 1
	setFaceSmoothGroup m 13 2
	setFaceMatID m 13 1
	setFaceSmoothGroup m 14 2
	setFaceMatID m 14 1
	setFaceSmoothGroup m 15 4
	setFaceMatID m 15 1
	setFaceSmoothGroup m 16 4
	setFaceMatID m 16 1
	setFaceSmoothGroup m 17 8
	setFaceMatID m 17 1
	setFaceSmoothGroup m 18 8
	setFaceMatID m 18 1
	setFaceSmoothGroup m 19 8
	setFaceMatID m 19 1
	setFaceSmoothGroup m 20 8
	setFaceMatID m 20 1
	setFaceSmoothGroup m 21 8
	setFaceMatID m 21 1
	setFaceSmoothGroup m 22 1
	setFaceMatID m 22 2
	setFaceSmoothGroup m 23 1
	setFaceMatID m 23 3
	setFaceSmoothGroup m 24 1
	setFaceMatID m 24 3
	setFaceSmoothGroup m 25 4
	setFaceMatID m 25 3
	setFaceSmoothGroup m 26 4
	setFaceMatID m 26 3
	setFaceSmoothGroup m 27 8
	setFaceMatID m 27 3
	setFaceSmoothGroup m 28 8
	setFaceMatID m 28 3
	setFaceSmoothGroup m 29 16
	setFaceMatID m 29 3
	setFaceSmoothGroup m 30 16
	setFaceMatID m 30 3
	setFaceSmoothGroup m 31 32
	setFaceMatID m 31 3
	setFaceSmoothGroup m 32 32
	setFaceMatID m 32 3
	setFaceSmoothGroup m 33 4
	setFaceMatID m 33 3
	setFaceSmoothGroup m 34 8
	setFaceMatID m 34 3
	setFaceSmoothGroup m 35 1
	setFaceMatID m 35 1
	setFaceSmoothGroup m 36 4
	setFaceMatID m 36 2
	m.transform = trans
	m.name = nodename
	for i=1 to (getNumFaces m) do
	(
		setEdgeVis m i 1 false
		setEdgeVis m i 3 false
		setEdgeVis m i 2 false
	)
	newmat = undefined
	for mat in scenematerials do
	(
		if mat.name == "crTools_NullNodeMaterial" do 
		(
			newmat = mat
			exit
		)
	)
	if newmat == undefined do
	(
		newmat = multimaterial numsubs:3
		
		submat1 = standardmaterial()
		submat1.name = "crTools_NullNodeMaterial_X"
		submat1.diffuse = color 255 0 0
		newmat[1] = submat1
		
		submat2 = standardmaterial()
		submat2.name = "crTools_NullNodeMaterial_Y"
		submat2.diffuse = color 0 255 255
		newmat[2] = submat2
		
		submat3 = standardmaterial()
		submat3.name = "crTools_NullNodeMaterial_Z"
		submat3.diffuse = color 0 0 255
		newmat[3] = submat3
	)
	m.material = newmat
	--setFaceNormal m 1 [0,0,1]
	--setFaceNormal m 2 [0,0,1]
	--setFaceNormal m 3 [0,0,-1]
	--setFaceNormal m 4 [0,0,-1]
	--setFaceNormal m 5 [0,1,0]
	--setFaceNormal m 6 [0,1,0]
	--setFaceNormal m 7 [0,-1,0]
	--setFaceNormal m 8 [0,-1,0]
	--setFaceNormal m 9 [1,0,0]
	--setFaceNormal m 10 [1,0,0]
	--setFaceNormal m 11 [-1,0,0]
	--setFaceNormal m 12 [-1,0,0]
	
	/*setFaceSmoothGroup m 1 1
	setFaceSmoothGroup m 2 1
	setFaceSmoothGroup m 3 2
	setFaceSmoothGroup m 4 2
	setFaceSmoothGroup m 5 4
	setFaceSmoothGroup m 6 4
	setFaceSmoothGroup m 7 8
	setFaceSmoothGroup m 8 8
	setFaceSmoothGroup m 9 16
	setFaceSmoothGroup m 10 16
	setFaceSmoothGroup m 11 32
	setFaceSmoothGroup m 12 32*/
	
	if addAttributes do
	(
		custAttributes.add m CNTAttribute #unique BaseObject:true
		SetCNTNodeType m "NULL"
		m.CNTCustAttribute.FileName = ""
	)
	if selectAndFocus do
	(
		select m
		max zoomext sel all
	)
	
	return m
)

fn PrintMeshScript msh =
(
	m = snapshotasmesh msh
	numVerts = getNumVerts m
	numFaces = getNumFaces m
	
	format "m = mesh vertices:#("
	
	
	for i=1 to numVerts do
	(
		vert = getVert m i
		spacer=""
		if i > 1 do spacer=","
		format "%[%, %, %]" spacer vert.x vert.y vert.z
	)
	format ") faces:#("
	
	for i=1 to numFaces do
	(
		face = getFace m i
		spacer=""
		if i > 1 do spacer=","
		format "%[%, %, %]" spacer face.x face.y face.z
		
	)
	
	format ")\n"
	for i=1 to numFaces do
	(
		smoothingGroup = getFaceSmoothGroup m i
		matID = getfacematid m i
		
		format "setFaceSmoothGroup m % %\n" i smoothingGroup
		format "setFaceMatID m % %\n" i matID
		
	)
	
)

fn GetMDLTexture folder materialName importTextures:false =
(
	texmap = undefined
	format "Checking if material \"%\" exists: result = % importTextures =\n" (folder+materialName+".MT2") (((dotnetclass "System.IO.File").exists (folder+materialName+".MT2"))  as string) (importTextures as string)
	
	global CarmaSettings
	if importTextures and ((dotnetclass "System.IO.File").exists (folder+materialName+".MT2")) then
	(
		format "Material \"%\" exists!\n" (folder+materialName+".MT2")
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
				format "Found diffuse texture %!\n" textureName
			)
		)
		
		--format "\n------------\n"
		if (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".png")) then
		(
			format "Texture is already converted: %\n" CarmaSettings.TexturePath+"\\"+textureName+".png"
			texmap = bitmaptexture()
			texmap.filename = CarmaSettings.TexturePath+"\\"+textureName+".png"
		)
		else if (doesFileExist (CarmaSettings.TexturePath+"\\"+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (CarmaSettings.TexturePath+"\\"+textureName+".tga")
			texmap = bitmaptexture()
			texmap.filename = CarmaSettings.TexturePath+"\\"+textureName+".tga"
		)
		else if (doesFileExist (folder+textureName+".png")) then
		(
			format "Texture is already converted: %\n" (folder+textureName+".png")
			texmap = bitmaptexture()
			texmap.filename = folder+textureName+".png"
		)
		else if (doesFileExist (folder+textureName+".tga")) then
		(
			--format "Texture is already converted: %\n"  (folder+textureName+".tga")
			texmap = bitmaptexture()
			texmap.filename = folder+textureName+".tga"
		)
		else if (doesFileExist (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")) then
		(
			format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png")
			texmap = bitmaptexture()
			texmap.filename = CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".png"
		)
		else if (doesFileExist (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")) then
		(
			--format "Texture is already converted: %\n" (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga")
			texmap = bitmaptexture()
			texmap.filename = CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tga"
		)
		else
		(
			format "Texture needs convertng!\n"
			startPath = CarmaSettings.TexturePath
			if startPath == "" then startPath = folder
			TDXFilename = undefined
			if (doesFileExist (folder+texturename+".tdx")) then TDXFilename = folder+texturename+".tdx"
			else if (doesFileExist (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tdx")) then TDXFilename = CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\"+texturename+".tdx"
			
			--format "Looking for %.tdx in \"%\" or in \"%\"\n" texturename folder (CarmaSettings.GamePath+"\\Data_Core\\Content\\Textures\\")
			--format "TDXFilename: %\n" TDXFilename
			
			if TDXFilename != undefined do
			(
				HiddenDOSCommand (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") prompt:("Loading Texture: "+TDXFilename)
				format "Command For Converting Texture: %\n from start path: %" (CarmaSettings.GibbedTools+" \""+TDXFilename+"\"") startPath
				texmap = bitmaptexture()
				texmap.filename = (getFilenamePath TDXFilename)+"\\"+textureName+".png"
			)
		)
		--matFile = openfile folder+materialName+".MT2" "r"
		
	)
	if texmap==undefined do
	(
		format "texmap undefined for \"%\", using checker!\n" materialName
		texmap = checker()
		texmap.coords.U_Tiling =10
		texmap.coords.V_Tiling =10
	)
	return texmap
)

fn ImportMDL filename importTextures:false forcePREP:false =
(
	f = fopen filename "r"
	
	readbyte f
	readbyte f
	readbyte f
	readbyte f
	
	checksum = readlong f #unsigned
	flags = readlong f #unsigned
	--printFlagBits flags 32 "MDL Flags"
	
	prepSize = readlong f #unsigned
	
	firstFaceCount = readlong f #unsigned
	uniqueVertexCount = readlong f #unsigned
	
	fileSize = readlong f #unsigned
	
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
	
	materialCount = readshort f #unsigned
	meshMaterial = undefined
	global globalMaterialNames
	global globalMaterials
	if globalMaterialNames==undefined do globalMaterialNames = #()
	if globalMaterials==undefined do globalMaterials = #()
	materialNames = #()
	--format "=======================\nHandling Materials for mesh %\n=======================\n" filename
	if(materialCount == 1) then
	(
		materialName = readpaddedstring f
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
	)
	else 
	(
		meshMaterial = multimaterial numsubs:materialCount
		for i=1 to materialCount do
		(
			materialName = readpaddedstring f
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
				
				format "\nAbout To Call GetMDLTexture for %\n" materialName
				subMat.diffuseMap = GetMDLTexture (getFilenamePath filename) materialName importTextures:importTextures
				--format "Just Called GetMDLTexture for \n\n" materialName
				subMat.name = materialName
				showtexturemap subMat subMat.diffuseMap true
				append globalMaterials subMat
			)
			
			meshMaterial[i] = subMat
		)
	)
	
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
		verts = #()
		uniqueVerts = #()
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
			
			colR = readbyte f
			colG = readbyte f
			colB = readbyte f
			colA = readbyte f
			
			append verts (mdlVert pos:[-pX,-pZ,pY] norm:[-nX,-nZ,nY] tex:[uv1X,1-uv1Y] tex2:[uv2X,1-uv2Y] colour:(color colR colG colB colA))
				
			isUnique = true
			for j=1 to uniqueVerts.count do
			(
				if verts[i].pos == uniqueVerts[j].pos then -- and verts[i].norm == uniqueVerts[j].norm then
				(
					isUnique = false
					oldVertsToNewVerts[i] = j
				)
			)
			if isUnique then
			(
				append uniqueVerts verts[i]
				oldVertsToNewVerts[i] = uniqueVerts.count
			)
		)
		
		matGroups = #()
		
		matGroupCount = readshort f #unsigned
		for i = 1 to matGroupCount do
		(
			/*matGroup = MDLMatGroup matID:1 triStrip:#() patchList:#()
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
			for j=1 to triStripLength do
			(
				append matGroup.triStrip (readlong f #unsigned)
			)
			
			matGroup.patchListVertOffset = readlong f #usigned
			patchListVertCount = readlong f #unsigned
			patchListLength = readlong f #unsigned
			
			for j=1 to patchListLength do
			(
				append matGroup.patchList (readlong f #unsigned)
			)*/
			
			fseek f 48 #seek_cur
			
			triStripLength = readlong f #unsigned
			
			fseek f ((triStripLength * 4)+8) #seek_cur
			
			patchListLength = readlong f #unsigned
			fseek f (patchListLength * 4) #seek_cur
		)
		prepSkinDataSet = CheckBitIsSet flags 5
	
		
		local m = trimesh()
		
		setNumVerts m uniqueVerts.count
		setNumTVerts m verts.count
		--meshop.setNumMaps m 3
		--meshop.setMapSupport m 2 true
		--meshop.setNumMapVerts m 2 verts.count
		setNumCPVVerts m verts.count
		for i=1 to uniqueVerts.count do
		(
			setVert m i uniqueVerts[i].pos
			--setNormal m i uniqueVerts[i].norm
		)
		for i=1 to verts.count do
		(
			setTVert m i verts[i].tex.x verts[i].tex.y 0
			--meshop.setMapVert m 2 i [verts[i].tex2.x, verts[i].tex2.y, 0]
			setVertColor m i verts[i].colour
		)
		
		setNumFaces m rawfaces.count
		buildTVFaces m
		buildVCFaces m
		--meshop.setNumMapFaces m 2 faces.count
		for i=1 to rawfaces.count do
		(
			setFace m i oldVertsToNewVerts[rawfaces[i].v1] oldVertsToNewVerts[rawfaces[i].v3] oldVertsToNewVerts[rawfaces[i].v2]
			setEdgeVis m i 1 true
			setEdgeVis m i 2 true
			setEdgeVis m i 3 true
			setFaceNormal m i (normalize ((verts[rawfaces[i].v1].norm+verts[rawfaces[i].v2].norm+verts[rawfaces[i].v3].norm))/3)
			setFaceMatID m i (rawfaces[i].matID+1)
			setTVFace m i rawfaces[i].v1 rawfaces[i].v3 rawfaces[i].v2
			--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
			setVCFace m i rawfaces[i].v1 rawfaces[i].v3 rawfaces[i].v2
		)
	)
	else
	(
		
		PREPfaceCount = readlong f #unsigned
		fseek f (16 * PREPfaceCount) #seek_cur
		
		PREPvertcount = readlong f #unsigned
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
	)
	if prepSkinDataSet then
	(
		format "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nOMG PANIC! THIS MDL HAS PREP SKIN DATA AND I DON'T KNOW WHAT TO DO WITH IT!!! At Position: %\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n" (ftell f)
		format "Num Verts: %\nNum Faces: %\n" PREPvertcount PREPfacecount
		numBones = readshort f #unsigned
		unknown1 = readshort f #unsigned
		unknown2 = readshort f #unsigned
		format "Unknown1 = %\nUnknown2 = %\n" unknown1 unknown2
		
		boneNames = #()
		for i=1 to numBones do
		(
			append boneNames (readstring f)
		)
		PrintArrayInFull boneNames "boneNames"
		
		/*for i = 1 to 16 do
		(
			p = ftell f
			b1 = readbyte f #unsigned
			b2 = readbyte f #unsigned
			b3 = readbyte f #unsigned
			b4 = readbyte f #unsigned
			b1234 = (bit.shift b4 24) + (bit.shift b3 16) + (bit.shift b2 8) + b1
			b12 = (bit.shift b2 8) + b1
			b34 = (bit.shift b4 8) + b3
			fl = bit.IntAsFloat b1234
			
			format "%: bytes % % % %\t float %\t int %\t shorts: % %\n" p b1 b2 b3 b4 fl b1234 b12 b34
		)*/
		
	)
	/*if forcePREP == false then
	(
		USERflags = readlong f #unsigned
		
		--printFlagBits flags 32 "flags: "
		--printFlagBits USERflags 32 "USER flags: "
		
		userVerts = #()
		for i=1 to uniqueVertexCount do
		(
			vX = readfloat f
			vY = readfloat f
			vZ = readfloat f
			
			timesUsed = readlong f #unsigned
			append userVerts (mdlUserVert x:vX y:vY z:vZ TimesUsed: timesUsed)
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
			
			v1colR = readbyte f #unsigned
			v1colG = readbyte f #unsigned
			v1colB = readbyte f #unsigned
			v1colA = readbyte f #unsigned
			
			v2colR = readbyte f #unsigned
			v2colG = readbyte f #unsigned
			v2colB = readbyte f #unsigned
			v2colA = readbyte f #unsigned
			
			v3colR = readbyte f
			v3colG = readbyte f
			v3colB = readbyte f
			v3colA = readbyte f
			
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
			
			append userFaces (mdlUSERface PlaneD:planeD PlaneX:planeX PlaneY:planeY PlaneZ:planeZ v1NormX:v1nX v1NormY:v1nY v1NormZ:v1nZ v2NormX:v2nX v2NormY:v2nY v2NormZ:v2nZ v3NormX:v3nX v3NormY:v3nY v3NormZ:v3nZ MaterialIndex:matID SmoothingGroup: smoothinggroup v1:v1index v2:v2index v3:v3index v1Colour:(color v1colR v1colG v1colB v1colA) v2Colour:(color v2colR v2colG v2colB v2colA) v3Colour:(color v3colR v3colG v3colB v3colA) v1U:v1U v1V:v1V v1U2:v1U2 v1V2:v1V2 v2U:v2U v2V:v2V v2U2:v2U2 v2V2:v2V2 v3U:v3U v3V:v3V v3U2:v3U2 v3V2:v3V2 FaceFlags:faceFlags AppSpecificFlags:faceAppFlags)
			
			--format "Face %: %\n" i (userFaces[i] as string)
			--format "Vert indices: % % %\n" v1index v2index v3index
			append smoothingGroups smoothingGroup
		)
		uniqueSmoothingGroups = makeUniqueArray smoothingGroups
		
		fclose f
		
		--format "Num UserFaces: %\nNum UserVerts: %\n" userFaces.count userVerts.count
		local m = trimesh()
		setNumVerts m userVerts.count
		setNumTVerts m (userFaces.count*3)
		--meshop.setNumMaps m 3
		--meshop.setMapSupport m 2 true
		--meshop.setNumMapVerts m 2 verts.count
		setNumCPVVerts m (userFaces.count*3)
		for i=1 to userVerts.count do
		(
			setVert m i [-userVerts[i].x,-userVerts[i].z,userVerts[i].y]
			--setNormal m i uniqueVerts[i].norm
		)
		--for i=1 to verts.count do
		--(
			--setTVert m i verts[i].tex.x verts[i].tex.y 0
			--meshop.setMapVert m 2 i [verts[i].tex2.x, verts[i].tex2.y, 0]
			--setVertColor m i verts[i].colour
		--)
		
		setNumFaces m userFaces.count
		buildTVFaces m
		buildVCFaces m
		meshop.setNumMaps m 3 keep:true
		meshop.setMapSupport m 2 true
		meshop.setNumMapVerts m 2 (userFaces.count * 3)
		meshop.setNumMapFaces m 2 userFaces.count
		--meshop.setNumMapFaces m 2 faces.count
		--PrintArrayInFull userFaces "USER Faces"
		--PrintArrayInFull userVerts "USER Verts"
		for i=1 to userFaces.count do
		(
			setFace m i (userFaces[i].v1+1) (userFaces[i].v3+1) (userFaces[i].v2+1)
			setEdgeVis m i 1 true
			setEdgeVis m i 2 true
			setEdgeVis m i 3 true
			--setFaceNormal m i (normalize ((verts[rawfaces[i].v1].norm+verts[rawfaces[i].v2].norm+verts[rawfaces[i].v3].norm))/3)
			setFaceMatID m i (userFaces[i].MaterialIndex+1)
			setFaceSmoothGroup m i userFaces[i].SmoothingGroup
			setTVert m (i*3-2) userFaces[i].v1U (1-userFaces[i].v1V) 0
			setTVert m (i*3-1) userFaces[i].v2U (1-userFaces[i].v2V) 0
			setTVert m (i*3) userFaces[i].v3U (1-userFaces[i].v3V) 0
			
			setTVFace m i (i*3-2) (i*3) (i*3-1)
			
			meshop.setMapVert m 2 (i*3-2) [userFaces[i].v1U2, 1-userFaces[i].v1V2, 0]
			meshop.setMapVert m 2 (i*3-1) [userFaces[i].v2U2, 1-userFaces[i].v2V2, 0]
			meshop.setMapVert m 2 (i*3) [userFaces[i].v3U2, 1-userFaces[i].v3V2, 0]
			
			meshop.setMapFace m 2 i [i*3-2, i*3-1, i*3]
			--meshop.setMapFace m 2 i [faces[i].v1, faces[i].v3, faces[i].v2]
			setVertColor m (i*3-2) userFaces[i].v1colour
			setVertColor m (i*3-1) userFaces[i].v2colour
			setVertColor m (i*3) userFaces[i].v3colour
			setVCFace m i (i*3-2) (i*3) (i*3-1)
		)
	)*/
	if forcePREP == false then
	(
		USERflags = readlong f #unsigned
		
		--printFlagBits flags 32 "flags: "
		--printFlagBits USERflags 32 "USER flags: "
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
			
			setFace m i (v1index+1) (v3index+1) (v2index+1)
			setEdgeVis m i 1 true
			setEdgeVis m i 2 true
			setEdgeVis m i 3 true
			--setFaceNormal m i (normalize ((verts[rawfaces[i].v1].norm+verts[rawfaces[i].v2].norm+verts[rawfaces[i].v3].norm))/3)
			setFaceMatID m i (matID+1)
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
			setVertColor m (i*3-2) (color v1colR v1colG v1colB v1colA)
			setVertColor m (i*3-1) (color v2colR v2colG v2colB v2colA)
			setVertColor m (i*3) (color v3colR v3colG v3colB v3colA)
			setVCFace m i (i*3-2) (i*3) (i*3-1)
			
			--append userFaces (mdlUSERface PlaneD:planeD PlaneX:planeX PlaneY:planeY PlaneZ:planeZ v1NormX:v1nX v1NormY:v1nY v1NormZ:v1nZ v2NormX:v2nX v2NormY:v2nY v2NormZ:v2nZ v3NormX:v3nX v3NormY:v3nY v3NormZ:v3nZ MaterialIndex:matID SmoothingGroup: smoothinggroup v1:v1index v2:v2index v3:v3index v1Colour:(color v1colR v1colG v1colB v1colA) v2Colour:(color v2colR v2colG v2colB v2colA) v3Colour:(color v3colR v3colG v3colB v3colA) v1U:v1U v1V:v1V v1U2:v1U2 v1V2:v1V2 v2U:v2U v2V:v2V v2U2:v2U2 v2V2:v2V2 v3U:v3U v3V:v3V v3U2:v3U2 v3V2:v3V2 FaceFlags:faceFlags AppSpecificFlags:faceAppFlags)
			
			--format "Face %: %\n" i (userFaces[i] as string)
			--format "Vert indices: % % %\n" v1index v2index v3index
			--append smoothingGroups smoothingGroup
		)
		uniqueSmoothingGroups = makeUniqueArray smoothingGroups
		
		fclose f
		
		--meshop.setNumMapFaces m 2 faces.count
		--PrintArrayInFull userFaces "USER Faces"
		--PrintArrayInFull userVerts "USER Verts"
		
	)
	
	m = mesh mesh:m
	m.material = meshMaterial
	--update m
	return m
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

struct LITGnode (lightType, lightBounds, objectNameLength, objectName)
struct EMT2node (bytes)
struct MODLnode (objectNameLength, objectName)
struct SKINnode (objectNameLength, objectName)
struct VFXInode (objectNameLength, objectName)
struct NewCNTNode (nameLength, nodeName, isA12CNT, unknownFloat, parentNode, transformMatrix, position, combinedMatrix, absolutePosition,  nodeType, nodeData, numChildren, children)
fn ImportCNTNode f parentNode = 
(
	local newNode = NewCNTNode nameLength:0 nodeName:"" isA12CNT:false unknownFloat:0 parentNode:undefined transformMatrix:(matrix3 1) position:[0,0,0] combinedMatrix:(matrix3 1) absolutePosition:[0,0,0] nodeType:"NULL" nodeData:undefined numChildren:0 children:#()
	newNode.nameLength = readlong f #unsigned
	newNode.nodeName = readstring2 f newNode.nameLength

	if parentNode !=undefined then
	(
		format "Loading node \"%\", parent is \"%\"\n" newNode.nodeName parentNode.nodeName
	)	
	else
	(
		format "Loading root node \"%\"\n" newNode.nodeName
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

fn ParseCNTNodes cntNode folderName importTextures:false forcePREP:false =
(
	if cntNode.nodeType == "MODL" or cntNode.nodetype == "SKIN" then
	(
		fname = folderName + cntNode.nodeData.objectName + ".mdl"
		format "Loading MDL from %\n" fname
		newMesh = ImportMDL fname importTextures:importTextures forcePREP:forcePREP
		newMesh.name = cntNode.nodeName
		newMesh.transform = cntNode.combinedMatrix
		
	)
	else
	(
		if cntNode.nodeName == "Wheel_FR" or cntNode.nodeName == "Wheel_FL" or cntNode.nodeName == "Wheel_RR" or cntNode.nodeName == "Wheel_RL" then
		(
			newMesh = CreateNewWheelNode cntNode.combinedMatrix cntNode.nodeName addCNTAttributes:false
			
		)
		else newMesh = CreateNewNULLNode cntNode.combinedMatrix cntNode.nodeName addAttributes:false
	)
	for i=1 to cntNode.numChildren do
	(
		childMesh = ParseCNTNodes cntNode.children[i] folderName importTextures:importTextures forcePREP:forcePREP
		childMesh.parent = newMesh
	)
	custAttributes.add newMesh CNTAttribute #unique BaseObject:true
	SetCNTNodeType newMesh cntNode.nodetype
	newMesh.CNTCustAttribute.FileName = newMesh.name
	if cntNode.nodetype == "LITG" or cntNode.nodetype == "MODL" or cntNode.nodetype == "SKIN" or cntNode.nodetype == "VFXI" do newMesh.CNTCustAttribute.FileName = cntNode.nodeData.objectName
	return newMesh
)
fn ImportCNT cnt_name importTextures:false forcePREP:false =
(
	f = fopen cnt_name "r"
	
	readCNTHeader f
	
	cntNode = ImportCNTNode f undefined
	format "Root cnt node is %\n" cntNode.nodeName
	global globalMaterials = #()
	globalMaterials = #()
	global globalMaterialNames =#()
	globalMaterialNames =#()
	ParseCNTNodes cntNode (getFilenamePath cnt_name) importTextures:importTextures forcePREP:forcePREP
	
	fclose f
)



rollout carma_reincarnation_settings "Settings"
(
	global CarmaSettings
	
	Group "Paths"
	(
		editText gameFolderTextBox "Game Folder:" fieldWidth: 210 across: 2 labelOnTop:true text:CarmaSettings.GamePath
		button setGameFolder "Browse" align:#right offset:[0,16]
		editText textureConversionFolderTextBox "Texture Conversion Folder:" fieldWidth: 210 across:2 labelOnTop:true text:CarmaSettings.TexturePath
		button setTextureFolder "Browse" align:#right offset:[0,16]
		editText GibbedToolsLocationTextBox "Gibbed Tools Location:" fieldWidth: 210 across:2 labelOnTop:true text:CarmaSettings.GibbedTools
		button setGibbedToolsLocation "Browse" align:#right offset:[0,16]
	)
	button saveButton "Save Settings"
	
	on setGameFolder pressed do
	(
		f = getSavePath caption:"Browse To Game Folder..."
		if f == undefined then gameFolderTextBox.text = ""
		else gameFolderTextBox.text = f
	)
	on setTextureFolder pressed do
	(
		f = getSavePath caption:"Browse To Texture Conversion Folder..."
		if f == undefined then textureConversionFolderTextBox.text = ""
		else textureConversionFolderTextBox.text = f
	)
	on setGibbedToolsLocation pressed do
	(
		f = getOpenFilename caption:"Browse To Gibbed Tools" filename:"Gibbed.Duels.TdxConvert.exe" types:"Gibbed.Duels.TdxConvert.exe|Gibbed.Duels.TdxConvert.exe"
		
		if f == undefined then GibbedToolsLocationTextBox.text = ""
		else GibbedToolsLocationTextBox.text = f
	)
	
	on saveButton pressed do
	(
		currentScriptFileName = getThisScriptFilename()
		currentScriptFolder = getFilenamePath currentScriptFileName
		
		
		CarmaSettings.GamePath = gameFolderTextBox.text
		CarmaSettings.TexturePath = textureConversionFolderTextBox.text
		CarmaSettings.GibbedTools = GibbedToolsLocationTextBox.text 
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GamePath" CarmaSettings.GamePath
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "TextureConversionPath" CarmaSettings.TexturePath
		setINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GibbedTools" CarmaSettings.GibbedTools
		DestroyDialog carma_reincarnation_settings
	)
)

rollout carma_reincarnation_import "Import"
(
		button imp_MDL "Import Single MDL" width:160 height:30 tooltip:"Import an MDL file"
		button imp_CNT "Import CNT" width:160 height:30 tooltip:"Import a CNT file"

	Group "Options"
	(
		checkbox imp_textures "Import Textures" width:150 checked:false
		checkbox imp_forcePREP "Force PREP Data" width:150 checked:false
	)
	
	on imp_MDL pressed do
	(
		format "Test test test\n"
		mdl_name = GetOpenFileName caption:"Open MDL File" types:"MDL(*.MDL)|*.mdl"
		if mdl_name != undefined do
		(
			
			global globalMaterials = #()
			globalMaterials = #()
			global globalMaterialNames =#()
			globalMaterialNames =#()
			ImportMDL mdl_name importTextures:imp_textures.checked forcePREP:imp_forcePREP.checked 
		)
	)
	
	on imp_CNT pressed do
	(
		format "Test test test\n"
		--CreateNewNULLNode [1,1,0] 1
		cnt_name = GetOpenFileName caption:"Open CNT File" types:"CNT(*.CNT)|*.cnt"
		if cnt_name != undefined do
		(
			ImportCNT cnt_name importTextures:imp_textures.checked forcePREP:imp_forcePREP.checked
		)
	)
)

fn SplitVertexNormals =
(
	oldTransform = selection[1].transform
	selection[1].transform = matrix3 1
	m = snapshotasmesh selection[1]
	
	newVertsList = #()
	faceNewVertInds = #()
	
	vertNormals = #()
	faceIndicesForNormals =#()
	for i=1 to (getNumFaces m) do
	(
		verts = getFace m i
		rNorms = meshop.getFaceRNormals m i
		
		if(vertNormals[verts.x] == undefined) do
		(
			vertNormals[verts.x] = #()
			faceIndicesForNormals[verts.x] = #()
		)
		if(vertNormals[verts.y] == undefined) do 
		(
			vertNormals[verts.y] = #()
			faceIndicesForNormals[verts.y] = #()
		)
		if(vertNormals[verts.z] == undefined) do 
		(
			vertNormals[verts.z] = #()
			faceIndicesForNormals[verts.z] = #()
		)
		
		if (finditem vertNormals[verts.x] rNorms[1])==0 then
		(	
			append vertNormals[verts.x] rNorms[1]
			faceIndicesForNormals[verts.x][vertNormals[verts.x].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[verts.x][(finditem vertNormals[verts.x] rNorms[1])] i
		)
		if (finditem vertNormals[verts.y] rNorms[2])==0 then
		(
			append vertNormals[verts.y] rNorms[2]
			faceIndicesForNormals[verts.y][vertNormals[verts.y].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[verts.y][(finditem vertNormals[verts.y] rNorms[2])] i
		)
		if (finditem vertNormals[verts.z] rNorms[3])==0 then
		(
			append vertNormals[verts.z] rNorms[3]
			faceIndicesForNormals[verts.z][vertNormals[verts.z].count] = #(i)
		)
		else
		(
			
			append faceIndicesForNormals[verts.z][(finditem vertNormals[verts.z] rNorms[3])] i
		)
	)
	
	for i=1 to (getNumVerts m) do
	(
		
		pos = getVert m i
		normalsForThisVert = vertNormals[i]
		faceIndicesForThisVert = faceIndicesForNormals[i]
		--facesForVert = meshop.getFacesUsingVert m #(i)
		
		for j=1 to normalsForThisVert.count do
		(
			currentVertNormal = normalsForThisVert[j]
			faceIndicesForThisNormal = faceIndicesForThisVert[j]
			append newVertsList #(pos,currentVertNormal)
			for k=1 to faceIndicesForThisNormal.count do
			(
				oldFaceVerts = getFace m faceIndicesForThisNormal[k]
				if(faceNewVertInds[faceIndicesForThisNormal[k]] == undefined) do faceNewVertInds[faceIndicesForThisNormal[k]] = #()
				faceNewVertInds[faceIndicesForThisNormal[k]][i] = newVertsList.count
			)
		)
	)
	format "FaceNewVertInds:\n\n"
	for i=1 to faceNewVertInds.count do
	(
		format "%: #(   " i
		for j=1 to faceNewVertInds[i].count where faceNewVertInds[i][j] != undefined do
		(
			format "%: %    " j faceNewVertInds[i][j]
		)
		format ") \n"
	)
	format "\n\n\n\n"
	
		--selection[1].transform = oldTransform 
		--return 0
		newM = trimesh()
		setNumVerts newM newVertsList.count
		for i=1 to newVertsList.count do
		(
			setVert newM i newVertsList[i][1]
			setNormal newM i newVertsList[i][2]
			--setNormal m i uniqueVerts[i].norm
		)
		
		setNumFaces newM (getNumFaces m)
		for i=1 to (getNumFaces m) do
		(
			oldVertInds = getFace m i
			setFace newM i faceNewVertInds[i][oldVertInds.x] faceNewVertInds[i][oldVertInds.y] faceNewVertInds[i][oldVertInds.z]
			setEdgeVis newM i 1 true
			setEdgeVis newM i 2 true
			setEdgeVis newM i 3 true
			setFaceNormal newM i (getFaceNormal m i)
			setFaceMatID newM i (getFaceMatID m i)
			setFaceSmoothGroup newM i (getFaceSmoothGroup m i)
		)
		finalMesh = mesh mesh:newM
		finalMesh.transform = oldTransform
		selection[1].transform = oldTransform 
)
fn SetToCNTNodes mdl =
(
	if (IsObjectACNT mdl) ==false do
	(
		custAttributes.add mdl CNTAttribute
		mdl.CNTCustAttribute.FileName = mdl.name
		if (classof mdl) == dummy then 
		(
			mdl.CNTCustAttribute.NodeType = "NULL"
			mdl.CNTCustAttribute.NodeTypeID=2
			
		)
	)
)
fn SetSelectionToCNTNodes =
(
	for mdl in (selection as array) do
	(
		SetToCNTNodes mdl
	)
)
fn SetAllToCNTNodes =
(
	
	for mdl in ($*) do
	(
		SetToCNTNodes mdl
	)
)

fn CustAttsTests =
(
	obj = selection[1]
	
	attrib = isProperty obj "CNTCustAttribute"
	
	format "Object customer attribute: %\n" attrib
)

rollout carma_reincarnation_export "Export"
(
	
	Group "Actions"
	(
	button export_cnt "Export CNT" width:120 height:30 tooltip:"Export visible objects in the scene" across:2
	button export_mdl "Export MDL" width:120 height:30 tooltip:"Export visible objects in the scene" across:2
	button export "Export Full CNT & MDL Hierarchy" width:260 height:30 tooltip:"Export visible objects in the scene"
	)
	Group  "Options"
	(
		checkbox exp_cnt "Export CNT (Selected Model Is Root)" width:150 checked:true
		checkbox exp_mdl "Export MDLs" width:150 checked:true
		checkbox exp_mdlSelected "Export Only Selected MDLs" width:150 checked:false
		checkbox exp_mdlHierarchy "Include Child Mesh Nodes" width:150 checked:false
		checkbox exp_mats "Export Materials" checked:true
		checkbox exp_struct "Export Structure.xml" checked:true
		checkbox exp_tristrips "Create Triangle Strips" checked:true
		checkbox exp_log "create log file" checked:false
	)
	
	on exp_mdlSelected changed state do (
		if state == false do exp_mdlHierarchy.checked = false
		if state == true do exp_mdlHierarchy.checked = true	
		)
	on exp_mdlHierarchy changed state do (
			if state == true do 
			(
				if exp_mdlSelected.checked == false do exp_mdlHierarchy.checked = false
			)
		)
	on export_cnt pressed do
	(
			cnt_name = GetSaveFileName caption:"Save CNT As" types:"CNT(*.CNT)|*.cnt"
			if cnt_name != undefined do
			(
				ExportCNT cnt_name selection[1]
			)
	)
	on export_mdl pressed do
	(
			mdl_name = GetSaveFileName caption:"Save MDL As" types:"MDL(*.MDL)|*.mdl"
			if mdl_name != undefined do
			(
				mdl_path = getFilenamePath mdl_name
				ExportMDLMesh folder_name selection[1] forcedFilename:mdl_name
			)
	)
	on export pressed do
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
				mdl_path = getFilenamePath cnt_name
				ExportMDL mdl_path true true
				ExportCNT cnt_name selection[1]
			)
		)
	)
)

	rollout carma_reincarnation_about "about"
	(
		label lab1 "Carmageddon: Reincarnation Tools"
		label lab2 "by Trent"
	)
rollout carma_reincarnation_exporter "Carmageddon: Reincarnation Tools"
(
	/*Group "Mode"
	(
		checkbutton mode_import "Import" across:2 width:73 
		checkbutton mode_export "Export" width:73 checked:true
	)*/
	
	Group "Tools"
	(
		button tool_splitVertexNormals "Split Mesh By Smoothing Group"
		button tool_PrintMeshScript "Print Mesh Script"
		button settingsButton "Settings"
		
	)
		Group "Node Tools"
		(
			button tool_makeCNTNodes "Make All CNTs" across:2
			button tool_makeSelectedCNTNodes "Make Selected CNTs" across:2
			button tool_makeNULLNode "Create NULL Node"  across:2
			button tool_convertToNULLNode "Convert To NULL Node"  across:2
		)
		Group "Wheels Tools"
		(
			button tool_makeWheelFRNode "Create FR Wheel Node"  across:2
			button tool_convertToWheelFRNode "Convert To FR Wheel Node"  across:2
			button tool_makeWheelFLNode "Create FL Wheel Node"  across:2
			button tool_convertToWheelFLNode "Convert To FL Wheel Node"  across:2
			button tool_makeWheelRRNode "Create RR Wheel Node"  across:2
			button tool_convertToWheelRRNode "Convert To RR Wheel Node"  across:2
			button tool_makeWheelRLNode "Create RL Wheel Node"  across:2
			button tool_convertToWheelRLNode "Convert To RL Wheel Node"  across:2
			button tool_makeAllWheelNodes "Create All Four Wheel Node"
		)
	
	on tool_PrintMeshScript pressed do
	(
		PrintMeshScript selection[1]
	)
	on tool_makeWheelFRNode pressed do
	(
		undo "Create FR Wheel Node" on
		(
			trans = matrix3 1
			if selection[1] != undefined do trans = selection[1].transform
			CreateNewWheelNode trans "Wheel_FR" selectAndFocus:false
		)
	)
	on tool_makeWheelFLNode pressed do
	(
		undo "Create FL Wheel Node" on
		(
			trans = matrix3 1
			if selection[1] != undefined do trans = selection[1].transform
			CreateNewWheelNode trans "Wheel_FL" selectAndFocus:false
		)
	)
	on tool_makeWheelRRNode pressed do
	(
		undo "Create RR Wheel Node" on
		(
			trans = matrix3 1
			if selection[1] != undefined do trans = selection[1].transform
			CreateNewWheelNode trans "Wheel_RR" selectAndFocus:false
		)
	)
	on tool_makeWheelRLNode pressed do
	(
		undo "Create RL Wheel Node" on
		(
			trans = matrix3 1
			if selection[1] != undefined do trans = selection[1].transform
			CreateNewWheelNode trans "Wheel_RL" selectAndFocus:false
		)
	)
	
	on tool_convertToWheelFRNode pressed do
	(
		undo "Convert To FR Wheel Node" on
		(
			if selection[1] != undefined do
			(
				trans = selection[1].transform
				CreateNewWheelNode trans "Wheel_FR" selectAndFocus:false
				delete selection[1]
			)
		)
	)
	on tool_convertToWheelFLNode pressed do
	(
		undo "Convert To FL Wheel Node" on
		(
			if selection[1] != undefined do
			(
				trans = selection[1].transform
				CreateNewWheelNode trans "Wheel_FL" selectAndFocus:false
				delete selection[1]
			)
		)
	)
	on tool_convertToWheelRRNode pressed do
	(
		undo "Convert To RR Wheel Node" on
		(
			if selection[1] != undefined do 
			(
				trans = selection[1].transform
				CreateNewWheelNode trans "Wheel_RR" selectAndFocus:false
				delete selection[1]
			)
		)
	)
	on tool_convertToWheelRLNode pressed do
	(
		undo "Convert To RL Wheel Node" on
		(
			if selection[1] != undefined do 
			(
				trans = selection[1].transform
				CreateNewWheelNode trans "Wheel_RL" selectAndFocus:false
				delete selection[1]
			)
		)
	)
	on tool_makeAllWheelNodes pressed do
	(
		undo "Make All Wheel Nodes" on
		(
			trans = matrix3 1
			whl = CreateNewWheelNode trans "Wheel_FL" selectAndFocus:false
			whl.rotation = (angleaxis 180 [0,0,1]) as quat
			whl.position = [1,-1.5,0.3]
			whl = CreateNewWheelNode trans "Wheel_FR" selectAndFocus:false
			whl.position = [-1,-1.5,0.3]
			whl = CreateNewWheelNode trans "Wheel_RL" selectAndFocus:false
			whl.rotation = (angleaxis 180 [0,0,1]) as quat
			whl.position = [1,1.5,0.3]
			whl = CreateNewWheelNode trans "Wheel_RR" selectAndFocus:false
			whl.position = [-1,1.5,0.3]
		)
	)
	on tool_makeNULLNode pressed do
	(
		undo "Create NULL Node" on
		(
			trans = matrix3 1
			if selection[1] != undefined do trans = selection[1].transform
			CreateNewNULLNode trans "NewNullNode" selectAndFocus:true
		)
	)
	on tool_convertToNULLNode pressed do
	(
		undo "Convert To Wheel Node" on
		(
			for obj in (selection as array) do
			(
				trans = obj.transform
				CreateNewNULLNode trans "NewNullNode" selectAndFocus:false
				delete obj
			)
		)
	)
	on tool_makeSelectedCNTNodes pressed do
	(
		SetSelectionToCNTNodes()
	)
	on tool_makeCNTNodes pressed do
	(
		SetAllToCNTNodes()
	)
	on tool_splitVertexNormals pressed do
	(
		SplitVertexNormals()
	)
	--group "progress"
	--(
	--	progressbar exp_prog color:red
	--	label exp_prog_lab "status:" align:#left
	--	label exp_prog_it "item:" align:#left
	--)
	on settingsButton pressed do
	(
	parentDialog = windows.getChildHWND 0 "Carmageddon: Reincarnation Tools"
		createDialog carma_reincarnation_settings 300 200 parent:parentDialog[1]
	)
	on carma_reincarnation_exporter open do
	(
		
		currentScriptFileName = getThisScriptFilename()
		currentScriptFolder = getFilenamePath currentScriptFileName

		global CarmaSettings = CRSettings()

		CarmaSettings.GamePath = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GamePath"
		CarmaSettings.TexturePath = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "TextureConversionPath"
		CarmaSettings.GibbedTools = getINISetting (currentScriptFolder+"CarmaReincarnationToolsSettings.ini") "Paths" "GibbedTools"
		format "GamePath: %\nTexturePath: %\n GibbedTools: %\n" CarmaSettings.GamePath CarmaSettings.TexturePath CarmaSettings.GibbedTools
		if CarmaSettings.GamePath == undefined or CarmaSettings.GamePath == "" then
		(
			parentDialog = windows.getChildHWND 0 "Carmageddon: Reincarnation Tools"
			createDialog carma_reincarnation_settings 300 200 parent:parentDialog[1]
		)

	)
)


--createdialog carma_reincarnation_exporter 200 360 50 150

crToolsFloater = newrolloutfloater "Carmageddon: Reincarnation Tools" 300 400
AddRollout carma_reincarnation_exporter crToolsFloater
AddRollout carma_reincarnation_import crToolsFloater
AddRollout carma_reincarnation_export crToolsFloater
AddRollout carma_reincarnation_about crToolsFloater