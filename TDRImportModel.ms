	filein "ReincarnationTools.ms"

forceDummyNull = true

fn CreateModelFromMshs mshs = (
	outputMeshes = #()

	for i = 0 to mshs.Meshes.count - 1 do (

		local msh = mshs.Meshes.item[i]
		local mshverts = #()
		local mshuvs = #()
		local mshnorms = #()
		local mshcolours = #()
		local mshfaces = #()
		local mshfaceNormals = #()
		local faceCount = msh.FaceCount
		local vertCount = msh.VertexCount

		case (msh.Mode.ToString()) of (
			"Ngon": (
				for i = 0 to msh.FaceCount - 1 do (
					local curFace = msh.Faces.Item[i]
					append mshfaceNormals [curFace.normal.X, curFace.normal.Y, curFace.normal.Z]

					local faceVertCount = curFace.VertexCount
					local startVertIndex = mshverts.count + 1

					for v = 0 to faceVertCount - 1 do (
						if v > 1 then (
							append mshfaces [startVertIndex, startIndex + v - 1, startIndex + v ]
						)
						local curVert = curFace.Vertices.item[v]
						append mshverts [curVert.Position.X, -curVert.Position.Z, curVert.Position.Y]
						append mshnorms [curVert.Normal.X, -curVert.Normal.Z, curVert.Normal.Y]
						append mshuvs [curVert.UV.X, curVert.UV.Y * -1 + 1,0]
						append mshcolours [curVert.Colour.X, curVert.Colour.Y, curVert.Colour.Z, curVert.Colour.W]
					)

				)
			)
			"TriIndexedPosition": (
				for i = 0 to msh.FaceCount - 1 do (

					local curFace = msh.Faces.Item[i]
					local startVertIndex = mshverts.count+1
					for v = 0 to 2 do (
						local curVert = curFace.Vertices.item[v]
						--format "vertIndex : %\n" curVert.PositionIndex
						local vertPos = msh.Positions.Item[curVert.PositionIndex]
						append mshverts [vertPos.X, -vertPos.Z, vertPos.Y]
						append mshnorms [curVert.Normal.X, -curVert.Normal.Z, curVert.Normal.Y]
						append mshuvs [curVert.UV.X, curVert.UV.Y * -1 + 1,0]
						append mshcolours [curVert.Colour.X, curVert.Colour.Y, curVert.Colour.Z, curVert.Colour.W]
					)
					append mshfaces [startVertIndex, startVertIndex + 1, startVertIndex + 2]


				) 
			)
			"Tri": (
				for v = 0 to msh.VertexCount - 1 do (
					local curVert = msh.Vertices.item[v]
					append mshverts [curVert.Position.X, -curVert.Position.Z, curVert.Position.Y]
					local vertnorm = normalize [curVert.Normal.X, -curVert.Normal.Z, curVert.Normal.Y]
					append mshnorms vertnorm
					append mshuvs [curVert.UV.X, curVert.UV.Y * -1 + 1,0]
					append mshcolours [curVert.Colour.X, curVert.Colour.Y, curVert.Colour.Z, curVert.Colour.W]
				)
				for f = 0 to msh.FaceCount - 1 do (
					local curFace = msh.Faces.item[f]
					append mshfaces [curFace.V1+1, curFace.V2+1, curFace.V3+1]
				)
			)
			default: (
				format "!!!Unknown mshs format: %\n" (msh.Mode.ToString())
			)
		)

		outMesh = mesh vertices:mshverts faces:mshfaces
		for n = 1 to mshnorms.count do (
			setNormal outMesh n mshnorms[n]
		)
		if mshuvs.count > 0 then (
			setNumTVerts outMesh mshuvs.count
			for uv = 1 to mshuvs.count do (
				setTVert outmesh uv mshuvs[uv]
			)
			buildTVFaces outmesh
		)

		if mshcolours.count > 0 then (
			setNumCPVVerts outmesh mshcolours.count true
			buildVCFaces outmesh
		)
		
		for f = 1 to mshfaces.count do (
			if mshuvs.count > 0  then (
				setTVFace outmesh f mshfaces[f]
			)
			if mshcolours.count > 0 then (
				setVCFace outmesh f mshfaces[f]
			)
		)

		for vc = 1 to mshcolours.count do (
			setVertColor outmesh vc (color mshcolours[vc].x  mshcolours[vc].y  mshcolours[vc].z  mshcolours[vc].w)
		)
		update outMesh
		append outputMeshes outMesh
		--msh = mesh mesh:outMesh
	)
	outputMeshes
)

fn LoadMshsFile filename = (
	mshsClass = dotnetClass "ToxicRagers.TDR2000.Formats.MSHS"

	mshsClass.Load filename
)

fn LoadTxFile filename = (
	txClass = dotnetClass "ToxicRagers.TDR2000.Formats.TX"

	txClass.Load filename
)

fn LoadHieFile filename hFilename = (
	hieClass = dotnetClass "ToxicRagers.TDR2000.Formats.HIE"

	hieClass.Load filename hFilename
)

fn ProcessHIENode node parentObjIndex &mshses hie &processedMeshes &materials &componentTexts currentMaterial:undefined = (

	local currentIndex = parentObjIndex

	case (node.Type.ToString()) of (
		"Matrix": (

			--format "Creating null %\n" node.name
			--local trans = Matrix3 [node.Transform.m11, node.Transform.m12, node.Transform.m13]  (-1 * [node.Transform.m31, node.Transform.m32, node.Transform.m33]) [node.Transform.m21, node.Transform.m22, node.Transform.m23] [node.Transform.m41, -node.Transform.m43, node.Transform.m42]
			--if node.name == "EAGLE_MK4_V8_AXIS_DOOR_L" or node.name == "EAGLE_MK4_V8_AXIS_DOOR_R" then (
				--format "%: \n\tX = [%, %, %] \n\tY = [%, %, %] \n\tZ = [%, %, %] \n\tT = [%, %, %]\n\n" node.Name node.Transform.m11 node.Transform.m12 node.Transform.m13 node.Transform.m21 node.Transform.m22 node.Transform.m23 node.Transform.m31 node.Transform.m32 node.Transform.m33 node.Transform.m41 node.Transform.m42 node.Transform.m43
			--)

			local trans = Matrix3 [-node.Transform.m11, -node.Transform.m13, node.Transform.m12] [-node.Transform.m31, -node.Transform.m33, node.Transform.m32]  [node.Transform.m21, node.Transform.m23, -node.Transform.m22] [-node.Transform.m41, -node.Transform.m43, node.Transform.m42]
			trans = Matrix3 [node.Transform.m11, node.Transform.m12, node.Transform.m13] [node.Transform.m21, node.Transform.m22, node.Transform.m23]  [node.Transform.m31, node.Transform.m32, node.Transform.m33] [node.Transform.m41, node.Transform.m42, node.Transform.m43]
			trans =  matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0] * trans * inverse(matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])
			if node.name == "EAGLE_MK4_V8_AXIS_DOOR_L" or node.name == "EAGLE_MK4_V8_AXIS_DOOR_R" then (
				--format "%: \n\tX = [%, %, %] \n\tY = [%, %, %] \n\tZ = [%, %, %] \n\tT = [%, %, %]\n\n" node.Name trans.row1.x trans.row1.y trans.row1.z trans.row2.x trans.row2.y trans.row2.z trans.row3.x trans.row3.y trans.row3.z trans.row4.x trans.row4.y trans.row4.z
			)
			
			local currentObj = CreateNewNULLNode trans node.name
			currentObj.parent = processedMeshes[currentIndex + 1]
			
			if currentObj.parent != undefined then (
				currentObj.transform = trans * currentObj.parent.transform
			)
			else (
				currentObj.transform = trans
			)

			in coordsys parent (
				--currentObj.scale = trans.scalepart
				--currentObj.rotation = trans.rotationpart
				--currentObj.position = trans.translation
			)
			
			trans = currentObj.transform
			
			append processedMeshes currentObj
			append componentTexts hie.matrixes.item[node.index].componentText
			if hie.matrixes.item[node.index].componentText != undefined then 
				format "Obj % uses componenttext % of type %\n" currentObj.name hie.matrixes.item[node.index].name (hie.matrixes.item[node.index].componentText.ComponentType.ToString())
			currentIndex = processedMeshes.count - 1
		)
		"Mesh": (

			local mshIndex = node.Index
			if processedMeshes[currentIndex + 1].modifiers["CNT Hierarchy"] != undefined and processedMeshes[currentIndex + 1].modifiers["CNT Hierarchy"].NodeType == "NULL" then (
				--format "Converting null node % into mesh node %\n" processedMeshes[currentIndex + 1].name node.name
				local oldProcessedMesh = processedMeshes[currentIndex+1]
				processedMeshes[currentIndex+1] = instance mshses[mshIndex+1]
				processedMeshes[currentIndex+1].transform = oldProcessedMesh.transform
				processedMeshes[currentIndex+1].parent = oldProcessedMesh.parent
				processedMeshes[currentIndex+1].name = oldProcessedMesh.name
				processedMeshes[currentIndex+1].material = currentMaterial
				for child in oldProcessedMesh.children do (
					child.parent = processedMeshes[currentIndex+1]
				)
				delete oldProcessedMesh
			)
			else (
				--format "Creating mesh %\n" node.name
				local newMsh = (instance mshses[mshIndex + 1])
				--format "Adding mesh node % as child of %\n"  mshses[mshIndex + 1].name processedMeshes[currentIndex + 1].name
				newMsh.name = mshses[mshIndex + 1].name
				newMsh.parent = processedMeshes[currentIndex + 1]
				in coordsys parent (
					newMsh.position = [0,0,0]
					newMsh.rotation = quat 1
				)
				newMsh.material = currentMaterial
				append processedMeshes newMsh
				append componentTexts undefined
				currentIndex = processedMeshes.count - 1

			)
		)
		"Texture": (
			if node.Index > -1 then (
				currentMaterial = materials[node.Index + 1]

			)
			else (
				currentMaterial = undefined
			)
		)
		"Material": (

		)
	)

	for c = 0 to node.Children.count - 1 do (
		ProcessHIENode node.Children.Item[c] currentIndex &mshses hie &processedMeshes &materials &componentTexts currentMaterial:currentMaterial
	)
	processedMeshes[currentIndex + 1]
)

fn deleteObjAndChildren obj = (
	for child in obj.children do (
		if child != undefined then
			deleteObjAndChildren child
	)
	delete obj
)

fn instanceObjAndChildren original targetParent = (
	local inst = instance original
	inst.transform = original.transform
	inst.parent = targetParent
	for child in original.children do (
		instanceObjAndChildren child inst
	)

	inst
)

fn ProcessHIE filename hFilename carText carDescriptor = (

	local hieFile = LoadHieFile filename hFilename
	local modelPath = getFilenamePath filename
	local mshs = #()
	local materials = #()
	local processedMeshes = #()



	for m = 0 to hieFile.Meshes.count - 1 do (
		local mshName = hieFile.Meshes.Item[m]
		local mshFile = LoadMshsFile (modelPath + mshName)
		mshs = mshs + (CreateModelFromMshs mshFile)
	)

	for t = 0 to hieFile.Textures.count - 1 do (
		txFile = LoadTxFile (modelPath + hieFile.Textures.Item[t] + ".tx")
		local tex = bitmaptexture()
		local txFileName = txFile.filename

		if(txFileName[txFileName.count] == "8") then
			txFileName = (substring txFileName 1 (txFileName.count - 1))+"32"
		local bmpName = modelPath + txFileName + ".tga"
		 
		tex.filename = bmpName
		local mat = standard diffuseMap:tex
		mat.twosided = true

		bmp =  (openbitmap (bmpName))

		if bmp != undefined and bmp.hasAlpha and ((bit.and txFile.Flags 1) == 1 or (bit.and txFile.Flags 2) == 2) then (
			mat.opacitymap = bitmaptexture filename:bmpName
			mat.opacitymap.filename = bmpName
			mat.opacitymap.monooutput = 1
		)
		showtexturemap mat on
		append materials mat

		--texmap = bitmaptexture()

		--texmap.filename = hieFile.Textures[t]
	)

	componentTexts = #()
	local rootNode = ProcessHIENode hieFile.Root 0 &mshs hieFile &processedMeshes &materials &componentTexts
	rootnode.scale = [1,1,1]
	rootnode.rotation = quat 1
	rootnode.pos = [0,0,0]
	masterWheels = #()
	for w = 0 to carDescriptor.NumWheels - 1 do (
		local masterNodeName = carDescriptor.Wheels.Item[w].MasterNode
		local instanceNodeName = carDescriptor.Wheels.Item[w].InstanceNode

		local wheelMasterNode = (for obj in objects where obj.name == masterNodeName collect obj)[1]
		
		local wheelInstanceNode = (for obj in objects where obj.name == instanceNodeName collect obj)[1]
		if wheelMasterNode != wheelInstanceNode and wheelMasterNode != undefined and wheelInstanceNode != undefined then (
			if (finditem masterwheels wheelMasterNode) == 0 then
			(
			--	format "appending % to masterwheelslist\n" wheelMasterNode.name
				append masterWheels wheelMasterNode
			)
			--format "replacing wheel node % with masterwheel %\n" wheelInstanceNode.name wheelMasterNode.name
			local newWheelInstanceNode = instanceObjAndChildren wheelMasterNode undefined
			newWheelInstanceNode.transform = wheelInstanceNode.transform
			newWheelInstanceNode.parent = wheelInstanceNode.parent
			newWheelInstanceNode.name = wheelInstanceNode.name
			newWheelInstanceNode.material = wheelMasterNode.material
			for child in wheelInstanceNode.children do (
				child.parent = newWheelInstanceNode
			)
			deleteObjAndChildren wheelInstanceNode
		)
	)

	for i = 1 to componentTexts.count do (
		local componentText = componentTexts[i]
		local processedNode = processedMeshes[i]
		local parentIndex = 0

		if processedNode != undefined and (isDeleted processedNode) == false and processedNode.parent != undefined and (isDeleted processedNode.parent) == false then
			parentIndex = finditem processedMeshes processedNode.parent

		if componentText != undefined then 
		case (componentText.ComponentType.ToString()) of (
			"PivotPoints": (
				delete processedNode
			)
			"DeformAndDetach": (
				--processedNode.position = [0,0,0]
				local txFile = LoadTxFile (modelPath + componentText.data.Item[7].value + ".tx")
		
				local tex = bitmaptexture()
				
				local txFileName = txFile.filename
				local oldMat = processedNode.material
				local diffuseMapName = ""
				if oldMat != undefined and oldMat.diffusemap != undefined then diffuseMapName = oldmat.diffuseMap.filename
				--format "Replacing texture % on % with % (%)\n" diffuseMapName processedNode.name txFile.filename componentText.data.Item[7].value

				if(txFileName[txFileName.count] == "8") then
					txFileName = (substring txFileName 1 (txFileName.count - 1))+"32"
				local bmpName = modelPath + txFileName + ".tga"

				tex.filename = bmpName
				local mat = standard diffuseMap:tex
				mat.twosided = true

				bmp =  (openbitmap (bmpName))

				if bmp != undefined and bmp.hasAlpha and ((bit.and txFile.Flags 1) == 1 or (bit.and txFile.Flags 2) == 2) then (
					mat.opacitymap = bitmaptexture filename:bmpName
					mat.opacitymap.filename = bmpName
					mat.opacitymap.monooutput = 1
				)
				showtexturemap mat on
				processedNode.material = mat
			)
			"DeformAndDetach2":(
				if parentIndex > 0 and (length processedNode.pos) > 0.01 then (
					local curParent = processedNode.parent
					local keepLooping = true
					local hasParentDetachAndDeformNodes = false

					while curParent != undefined and parentIndex > 0 and keepLooping do (
						if  componentTexts[parentIndex] != undefined and componentTexts[parentIndex].ComponentType.ToString() == "Rotating" then (
							keeplooping = false
						)
						else (
							if componentTexts[parentIndex] != undefined and (componentTexts[parentIndex].ComponentType.ToString() == "DeformAndDetach" or componentTexts[parentIndex].ComponentType.ToString() == "DeformAndDetach2") then (
								hasParentDetachAndDeformNodes = true
							)
							curParent = curParent.parent
							parentIndex = finditem processedMeshes curParent
						)
					) 

					if hasParentDetachAndDeformNodes then (
						if curParent == undefined then 
						(
							format "Possibly reset % position  ([%,%,%]) to zero\n" processedNode.name processedNode.pos.x processedNode.pos.y processedNode.pos.z
							processedNode.position =[0,0,0]
						)
						else (
							format "Possibly reset % position ([%,%,%]) to axis ([%,%,%])\n" processedNode.name processedNode.pos.x processedNode.pos.y processedNode.pos.z  curParent.pos.x curParent.pos.y curParent.pos.z
							processedNode.position = curparent.position
						)
					)
				)
				local txFile = LoadTxFile (modelPath + componentText.data.Item[7].value + ".tx")
		
				local tex = bitmaptexture()
				
				local txFileName = txFile.filename

				local oldMat = processedNode.material
				local diffuseMapName = ""
				if oldMat != undefined and oldMat.diffusemap != undefined then diffuseMapName = oldmat.diffuseMap.filename
				--format "Replacing texture % on % with % (%)\n" diffuseMapName processedNode.name txFile.filename componentText.data.Item[7].value


				if(txFileName[txFileName.count] == "8") then
					txFileName = (substring txFileName 1 (txFileName.count - 1))+"32"
				local bmpName = modelPath + txFileName + ".tga"

				tex.filename = bmpName
				local mat = standard diffuseMap:tex
				mat.twosided = true

				bmp =  (openbitmap (bmpName))

				if bmp != undefined and bmp.hasAlpha and ((bit.and txFile.Flags 1) == 1 or (bit.and txFile.Flags 2) == 2)  then (
					mat.opacitymap = bitmaptexture filename:bmpName
					mat.opacitymap.filename = bmpName
					mat.opacitymap.monooutput = 1
				)
				showtexturemap mat on
				processedNode.material = mat
			)
		)
	)

	objsToZeroPos =#()

	for obj in objects where obj.parent != undefined and obj.parent.parent != undefined and obj.parent.parent != rootNode do (
		local parentPos = obj.parent.parent.position
		local pos = [0,0,0] 
		in coordsys parent (
			pos = obj.position
		)

		if pos+ parentPos == [0,0,0] then (
			--append objsToZeroPos obj.parent.parent
			append objsToZeroPos obj
		)
	)
	--for obj in objsToZeroPos do obj.position =[0,0,0]
	while mshs.count > 0 do (
		delete mshs[1]
		deleteItem mshs 1
	)

	for wheel in masterWheels do (
		--format "deleting wheeel %\n" wheel.name
		--deleteItem masterWheels (finditem masterwheels wheel)
		if wheel != undefined then 
			deleteObjAndChildren wheel
	)
	--for obj in processedMeshes where obj.material == undefined do delete obj
	for obj in objects where (findstring obj.name "LOD2") != undefined or (findstring obj.name "LOD3") != undefined do (
		if obj != undefined then
			deleteObjAndChildren obj
	)

	rootNode
)

fn ProcessCar carsFolder carName = (
	local carText = (dotnetClass "ToxicRagers.TDR2000.Formats.CarText").Load (carsFolder+carName+"\\"+carName+".txt")
	local carDescriptor = (dotnetClass "ToxicRagers.TDR2000.Formats.CarDescriptor").Load (carsFolder+carName+"\\"+carText.Descriptor)
	local hFilePath = carsFolder+carName+"\\"+ carDescriptor.HeaderFile
	local hieFilePath = carsFolder+carName+"\\"+ carDescriptor.HierarchyFile

	ProcessHIE hieFilePath hFilePath carText carDescriptor
)

fn ProcessCarClean carsFolder carName = (
	select objects
	if $ != undefined then (
		delete $
	)
	ProcessCar carsFolder carName
)
fn ReprocessCar carsFolder = (
	global carNames
	global currentIndex
	ProcessCarClean carsFolder carNames[currentIndex-1]
)
fn ProcessNextCar carsFolder = (
	global carNames
	global currentIndex

	if carNames == undefined then (
		 carNames = #()
		carFolders = getDirectories (carsFolder + "*")
		for carFolder in carFolders do (
			local carName = (GetFolderName carFolder)
			if (getfiles (carFolder+"\\"+carName+".txt")).count != 0 then
				append carNames carName
		)	
	)

	if currentIndex == undefined or currentIndex < 1 or currentIndex > carNames.count then
		currentIndex = 1

	ProcessCarClean carsFolder carNames[currentIndex]
	currentIndex += 1 

)
fn RenderThisCar saveFolder carName carRoot selfIllum:75.0= (
	carroot.rotation = quat 1
	carroot.scale = [1,1,1]
	carroot.position = [0,0,0]
	renderSize = [2560,2560]
	
	local minHeight = carRoot.min.z
	for obj in objects where (IsObjectANullCNT obj) == false do (	if obj.min.Z < minHeight then minHeight = obj.min.z )

	local nomatObjs = for obj in objects where obj.material == undefined and (IsObjectANullCNT obj) == false collect obj
	for obj in nomatObjs do 
	(
		if (isDeleted obj) == false then 
			delete obj
	)
	format "minHeight: %\n"  minHeight
	carRoot.position.Z = minHeight * -1
	RenderThreeQuarterView (saveFolder+carname+".png") outputsize:renderSize selfIllum:selfIllum carroot:carRoot
				
)
fn RenderAllTDRCars saveFolder startIndex:1 = (
	carsFolder = "D:\\TDRAssets\\CARS\\"
	carFolders = getDirectories "D:\\TDRAssets\\CARS\\*"
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = startIndex
	renderSize = [2560,2560]
	while i <= numCars do (
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".txt")).count != 0 then (
			
		--	try (
				carRoot = ProcessCar carsFolder carName
				carroot.rotation = quat 1
				carroot.scale = [1,1,1]
				carroot.position = [0,0,0]
				
				local minHeight = carRoot.min.z
				for obj in objects where (IsObjectANullCNT obj) == false do (	if obj.min.Z < minHeight then minHeight = obj.min.z )

				local nomatObjs = for obj in objects where obj.material == undefined and (IsObjectANullCNT obj) == false collect obj
				for obj in nomatObjs do 
				(
					if (isDeleted obj) == false then 
						delete obj
				)
				carRoot.position.Z = minHeight * -1
				RenderThreeQuarterView (saveFolder+"TDR\\"+carname+".png") outputsize:renderSize selfIllum:75.0 carroot:carRoot
				numConverted = numConverted + 1
		--	)
		/*	catch (
				numErrors = numErrors + 1
				format "Failed to convert %\n" carname to:errors
				KeepMaxAlive()
				CompleteRedraw()
			)
		*/	select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		)
		i = i + 1

		if i > 300 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)
fn TestAllTDRCars startIndex:1 = (
	carsFolder = "D:\\TDRAssets\\CARS\\"
	carFolders = getDirectories "D:\\TDRAssets\\CARS\\*"
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = startIndex
	renderSize = [2560,2560]
	while i <= numCars do (
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".txt")).count != 0 then (
			
		--	try (
				carRoot = ProcessCarClean carsFolder carName
				
				
		--	)
		/*	catch (
				numErrors = numErrors + 1
				format "Failed to convert %\n" carname to:errors
				KeepMaxAlive()
				CompleteRedraw()
			)
		*/	select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		)
		i = i + 1

		if i > 300 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)