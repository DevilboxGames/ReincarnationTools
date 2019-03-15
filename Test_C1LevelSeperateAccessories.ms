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


Levels = #($Inca1, $Inca2, $Inca3)

BaseLevel = $IncaBase


RemoveGeometryInOtherMesh levels[1] levels[2]
--RemoveGeometryInOtherMesh levels[1] levels[3]
--RemoveGeometryInOtherMesh levels[2] levels[3]
--R8emoveGeometryInOtherMesh levels[2] levels[1]
--RemoveGeometryInOtherMesh levels[3] levels[2]
--RemoveGeometryInOtherMesh levels[3] levels[1]