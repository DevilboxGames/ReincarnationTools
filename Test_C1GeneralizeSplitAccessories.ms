/*for f = 1 to (getnumfaces $) do (
	face = getface $ f
	format "%, %, %\n" (getvert $ face[1]) (getvert $ face[2]) (getvert $ face[3])
)*/

fn calculateRotation obj faceToUse:1 = (
	v1 = getvert obj (getface obj faceToUse)[1]
	v2 = getvert obj (getface obj faceToUse)[2]
	v3 = getvert obj (getface obj faceToUse)[3]
	
	v1v3 = normalize (v1 - v3)
	v2v3 = normalize (v2 - v3)
	xAxis = normalize (cross v2v3 v1v3)
	zAxis = normalize (cross xAxis v2v3)
	yAxis = normalize (cross zAxis xAxis)
	
	(Matrix3 xAxis yAxis zAxis [0,0,0]).rotationpart
)

fn NormalizeScale target objs positionAtBase:true = (
	targetBounds = nodeGetBoundingBox  target (matrix3 1)
	target.pivot= target.center
	targetPos = target.pos
	target.pos=[0,0,0]
	targetRot = target.rotation
	target.rotation = quat 0 0 0 1
	xExtents =  targetBounds[2].x - targetBounds[1].x
	yExtents =  targetBounds[2].y - targetBounds[1].y
	zExtents =  targetBounds[2].z - targetBounds[1].z
	for obj in objs do (
		obj.pivot= obj.center
		objPos = obj.pos
		obj.pos=[0,0,0]
		objRot = obj.rotation
		obj.rotation = quat 0 0 0 1
		objBounds = nodeGetBoundingBox  obj (matrix3 1)
		xExtents2 =  objBounds[2].x - objBounds[1].x
		yExtents2 =  objBounds[2].y - objBounds[1].y
		zExtents2 =  objBounds[2].z - objBounds[1].z
		xScale =  xExtents / xExtents2
		yScale =  yExtents / yExtents2
		zScale =  zExtents / zExtents2
		obj.scale = [xScale, yScale, zScale]
		ResetScale obj
		
		xScale =  xExtents2 / xExtents
		yScale =  yExtents2 / yExtents
		zScale =  zExtents2 / zExtents
		obj.scale = [xScale, yScale, zScale]
		obj.rotation = objRot
		obj.pos = objPos
		
			
			if positionAtBase then (
				obj.pivot.z = objBounds[1].z
				obj.pos.z = 0
			)
	)
	target.pos = targetPos
	target.rotation=targetRot
			
			if positionAtBase then (
				obj.pivot.z = objBounds[1].z
				obj.pos.z = 0
			)
)
fn resetRotation objs: faceToUse:1 positionAtBase:true = (
		if objs == unsupplied then objs = selection as array
		
		for obj in objs do (
			objPos = obj.pos
			obj.pos = [0,0,0]
			RotatePivotOnly obj (calculateRotation obj faceToUse:faceToUse)
			obj.pos = objPos
			--obj.rotation = quat 0 0 0 1
			
			if positionAtBase then (
				objBounds = nodeGetBoundingBox  obj (matrix3 1)
				obj.pivot.z = objBounds[1].z
				obj.pos.z = 0
			)
		)
)

fn DuplicateAndGeneraliseAccessories positionAtBase:true objs: = (
	if objs == unsupplied then objs = selection as array
	generalizedObjects = #()
	for obj in objs do obj.pivot = obj.center
	for obj in objs do (
		obj1 = copy obj
		obj1.name = obj.name+"_copy"
		append generalizedObjects obj1
	)
	resetRotation objs:generalizedObjects positionAtBase:positionAtBase
	NormalizeScale generalizedObjects[1] generalizedObjects
)
