C1Folder = "g:\\Carma1\\"
C1DataFolder = C1Folder+"data\\"
LevelsFolder = "races\\"
fn cleanImportedC1Level removeAccessories:false deleteDummies:true mergeGeometry:true ignore:#() =
(
	if deleteDummies then (
		objList = for obj in objects where classof obj == Dummy and (findItem ignore obj) < 1 collect obj
		format "%\n" objList
		for obj in objList do
		(
			delete obj
		)
	)

	if removeAccessories then (
		objList = for obj in objects where (substring obj.name 1 1) == "&" and (findItem ignore obj) < 1 collect obj

		for obj in objList do
		(
			delete obj
		)
	)
	if mergeGeometry then (
		targetObj = undefined
		objList = #()
		objList = for obj in objects where (substring obj.name 1 1) != "&" and (findItem ignore obj) < 1 collect obj
		format "%\n" objList
		for obj in objList where classof obj != Dummy do
		(
			if targetObj == undefined then targetObj = obj
			else attach targetObj obj
		)
		targetObj
	)
)
fn cleanCarma1Name matname =
(
	
			matname = substituteString matname "!" "_"
			matname = substituteString matname "#" "_"
			matname = substituteString matname "\\" "_"
			matname = substituteString matname "&" "_"
			matname = substituteString matname ".MAT" ""
			matname = substituteString matname ".mat" ""
	return matname
)
fn cleanCarma1TextureNames filename=
(
	filenameOnly = filenamefrompath filename
	pathtofile = getFilenamePath filename
	if (findstring filenameonly "&") != undefined then
	(
		newFilename = substitutestring filenameonly "&" "_and_"
		copyfile filename (pathtofile + newfilename)
		return pathtofile + newfilename
	)
	else return filename
)
fn cleanImportedCarma1materials =
(
	for obj in geometry do
	(
		if classof obj.mat == Standardmaterial then
		(
			obj.mat.name = cleanCarma1Name obj.mat.name
			if obj.mat.diffusemap != undefined and obj.mat.diffusemap.filename != undefined then
			(
				fullpath = mapPaths.getFullFilePath obj.mat.diffusemap.filename
				if fullpath != "" then
				(
					obj.mat.diffusemap.filename = fullpath
					obj.mat.diffusemap.filename = cleanCarma1TextureNames fullpath
				)
			) 
		)
		else if classof obj.mat == multimaterial then
		for mat in obj.mat do
		(
			mat.name = cleanCarma1Name mat.name
			if mat.diffusemap != undefined and mat.diffusemap.filename != undefined then
			(
				fullpath = mapPaths.getFullFilePath mat.diffusemap.filename
				if fullpath != "" then
				(
					mat.diffusemap.filename = fullpath
					mat.diffusemap.filename = cleanCarma1TextureNames fullpath
				)
			) 
		)
	)
)

fn RemoveGeometryInOtherMesh base target = (
	
	baseMesh = snapshotasmesh base
	targetMesh = snapshotasmesh target
	
	numBaseVerts = getnumverts basemesh
	numTargetVerts = getnumverts targetmesh
	
	numBaseFaces = getnumfaces basemesh
	numTargetFaces = getnumfaces targetmesh
	
	targetFacesToDelete = #()
	targetFacesToKeep = #()
	
	--numBaseFaces = 4000
	--numTargetFaces = 4000
	facesDeleted =0
	for i = 1 to numBaseFaces do (
		baseFace = getface basemesh i
		baseV1 = getvert basemesh baseFace[1]
		baseV2 = getvert basemesh baseFace[2]
		baseV3 = getvert basemesh baseFace[3]
		currentTargetFaces = numTargetFaces
		k = 1
		while k < currentTargetFaces do (
			targetFace = getface targetmesh k
			targetV1 = getvert targetmesh targetFace[1]
			targetV2 = getvert targetmesh targetFace[2]
			targetV3 = getvert targetmesh targetFace[3]
			if  (targetv1 == basev1 and targetv2 == basev2 and targetv3 == basev3) or
				(targetv1 == basev2 and targetv2 == basev3 and targetv3 == basev1) or
				(targetv1 == basev3 and targetv2 == basev1 and targetv3 == basev2)			then (
				--append targetFacesToDelete k
					deleteface targetMesh k
					numTargetFaces = numTargetFaces - 1
					facesDeleted = facesDeleted + 1
					k = currentTargetFaces
			)
			k = k + 1
		)
		percent = 100 * ((i as float) / (numBaseFaces as float))
		if(mod percent 1) == 0 then (
			format "%\%...\n" percent
		)
		if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()
	)
	target.mesh = targetMesh
	format "\nBase: % (% faces) Target> % (% faces) % faces to remove\n" base.name numBaseFaces target.name numTargetFaces targetFacesToDelete.count
)


fn LoadLevel levelName:"CASTLE" cleanAccessories:false dontCleanObjects:#() = (
	level = LoadC1TXT  (C1DataFolder+LevelsFolder+levelName+".txt") &progressValue &progressText imp_onlyMainMeshes:true imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
	level = cleanImportedC1Level removeAccessories:cleanAccessories ignore:dontCleanObjects
	level.name = levelName
	cleanImportedCarma1materials()

	level
)

fn ExtractAccessories levelNames:#("CASTLE","CASTLE2","CASTLE3") = (
	loadedLevels = #()
	for levelName in levelNames do (
		level = LoadLevel levelName:levelName cleanAccessories:true dontCleanObjects:loadedLevels
		append loadedLevels level
	)

	accessoryMeshes = #()
	for level in loadedLevels do (
		levelCopy1 = copy level
		levelCopy1.name = level.name+"_accessories"
		append accessoryMeshes levelCopy1

		for otherLevel in loadedLevels do (
			if level != otherLevel then (
				RemoveGeometryInOtherMesh otherLevel levelCopy1
			)
		)

		levelCopy2 = copy level
		levelCopy2.name = level.name+"_stripped"
		RemoveGeometryInOtherMesh levelCopy1 levelCopy2
	)
)
global nonCarsList = #()
fn LoadNonCarIntoAccessory obj = (
	global nonCarsList

			obj.layer.current = true
	if nonCarsList.count < 1 then (
		nonCarClass = dotNetClass "ToxicRagers.Carmageddon.Formats.NonCar"
		noncarFiles = getFiles (C1DataFolder+"noncars\\*.txt")
		for noncarFile in noncarFiles do (
			append nonCarsList (nonCarClass.load noncarFile)
		)
	)
	noncarForObj = undefined

	for nc in nonCarsList do (
		if nc.number as string == substring obj.name 2 2 then (
			noncarForObj = nc
		)
	)

	if noncarForObj != undefined then (
		accMod = AddAccessoryTXTModifier obj
		accMod.Mass = noncarForObj.Mass.x * 1000
		centerOfMassPos =  [-noncarForObj.CentreOfMass.x, noncarForObj.CentreOfMass.z, noncarForObj.CentreOfMass.y]
		in coordsys obj (
			if accMod.CentreOfMassHelper == undefined or accMod.CentreOfMassHelper.node != undefined then (
				newDummy = point prefix:("COM_"+obj.name) position:centerOfMassPos						
				newDummy.size = 1
				--newDummy.axistripod = true
				newDummy.cross = true
				accMod.CentreOfMassHelper == NodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false
			)
			else (
				accMod.CentreOfMassHelper.node.pos = centerOfMassPos
			)
		)


	)

)