fn RotatePivotOnly obj rotation = (
	local rotValInv=inverse (rotation as quat)
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetpos*=RotValInv
	obj.objectoffsetrot*=RotValInv
)

fn flipWheel obj = (
	oldMods = BeginEditMesh obj
	numVerts = getNumVerts obj
	in coordsys obj (
	for i =1 to numverts do (
		v = getvert obj i
		v.x = -v.x
		setvert obj i v
	)
	
	numfaces = getnumfaces obj
	for i = 1 to numfaces do (
		f = getface obj i
		v1 = f.x
		f.x = f.y
		f.y = v1
		setface obj i f
		tvf = gettvface obj i
		v1 = tvf.x
		tvf.x = tvf.y
		tvf.y = v1
		settvface obj i tvf
	)
	
	)	
	update obj
	EndEditMesh obj oldMods
	
)

fn ConvertToNullNodeAndMakeTyreMesh obj wheelType tyreWidth: 0.335 tyreRadius: 0.709 = (
	obj.pivot = obj.center
	wheelRot = quat 1
	flipWheelNode = false
	if obj.pos.x > 0 then (
		--RotatePivotOnly obj (EulerAngles 0 0 180)
		--obj.scale.x = obj.scale.x * -1
		flipWheelNode = true
		wheelRot = (eulerangles 0 0 180) as quat
		flipWheel obj
		obj.pivot = obj.center
	)
	extents = obj.max - obj.min
	newWheelNode = ConvertToWheelNode obj wheelType deleteOldMesh:false
	newWheelNode.rotation = wheelRot
	newWheelNode.pos = obj.pos
	newWheelNode.scale = [extents.x / tyreWidth, extents.y / tyreRadius, extents.y / tyreRadius]
	obj.rotation = quat 1
	obj.pos = [0,0,0]
	obj.scale = [tyreWidth / extents.x, tyreRadius / extents.y, tyreRadius / extents.y]
	obj.modifiers["CNT Hierarchy"].BakeScaleIntoMesh = true
	obj.parent = undefined
	if flipWheelNode then (
		
	)
)
fn ConvertAllWheels = (
	wheels = for obj in objects where (findstring obj.name "wheel") != undefined collect obj
	for wheel in wheels do (
		wheelType="Wheel_FR"
		if (findstring wheel.name "rr") !=undefined then wheelType="Wheel_RR"
		else if (findstring wheel.name "fr")  !=undefined then wheelType="Wheel_FR"
		else if (findstring wheel.name "rl")  !=undefined then wheelType="Wheel_RL"
		else if (findstring wheel.name "fl")  !=undefined then wheelType="Wheel_FL"
		else (
			wheelType="Wheel_MX"
		)
		
		ConvertToNullNodeAndMakeTyreMesh wheel wheelType
	)
	wheels
)

fn CheckIdentical msh1 msh2 = (
	isIdentical = true
	reason = stringstream ""
	if msh1.material != msh2.material then (
		isIdentical=false
		format "different materials % != %\n" msh1.material.name msh2.material.name to:reason
	)
	if (getnumVerts msh1) != (getnumVerts msh2) then (
		isIdentical=false
		format "number of verts do not match % != %\n" (getnumVerts msh1) (getnumVerts msh2) to:reason
	)
	if (getnumtVerts msh1) != (getnumtVerts msh2) then (
		isIdentical=false
		format "number of tverts do not match % != %\n" (getnumtVerts msh1) (getnumtVerts msh2) to:reason
	)
	if (getnumcpvVerts msh1) != (getnumcpvVerts msh2) then (
		isIdentical=false
		format "number of cpvverts do not match % != %\n" (getnumcpvVerts msh1) (getnumcpvVerts msh2) to:reason
	)
	if (getnumfaces msh1) != (getnumfaces msh2) then (
		isIdentical=false
		format "number of faces do not match % != %\n" (getnumfaces msh1) (getnumfaces msh2) to:reason
	)
	if (getnumfaces msh1) != (getnumfaces msh2) then (
		isIdentical=false
		format "number of faces do not match % != %\n" (getnumfaces msh1) (getnumfaces msh2) to:reason
	)
	else if (getnumVerts msh1) == (getnumVerts msh2) then (
		numVerts1 = getnumverts msh1
		
		for v = 1 to numVerts1 do (
			if (getVert msh1 v) != (getVert msh2 v) then(
				isIdentical = false
				format "vertex % does not match % != %\n" v (getVert msh1 v) (getVert msh2 v)  to:reason
				
				numVerts1 = -1
			)
		)
		numFaces = getnumfaces msh1
		for f = 1 to numFaces do (
			f1 = getFace msh1 f
			f2 = getFace msh2 f
			facesToTest = #(f2, [f2.x, f2.z, f2.y], [f2.y, f2.x, f2.z], [f2.y, f2.z, f2.x], [f2.z, f2.x, f2.y], [f2.z, f2.y, f2.x])
			for facetotest in facestotest do (
				if f1 != facetotest then(
					if isIdentical then (
						format "face % does not match % != %\n" f (getFace msh1 f) (getFace msh2 f)  to:reason
					
						numFaces = -1
					)
					isIdentical = false
					
				)
			)
		)
			
		numTVerts1 = getnumtverts msh1
		
		for v = 1 to numTVerts1 do (
			if (gettVert msh1 v) != (gettVert msh2 v) then(
				isIdentical = false
				format "texture vertex % does not match % != %\n" v (getTVert msh1 v) (getTVert msh2 v)  to:reason
				
				numTVerts1 = -1
			)
		)
		
			
		numCPVVerts1 = getnumcpvverts msh1
		
		for v = 1 to numcpvVerts1 do (
			if (getVertColor msh1 v) != (getVertColor msh2 v) then(
				isIdentical = false
				format "vertex colour % does not match % != %\n" v (getVertColor msh1 v) (getVertColor msh2 v)  to:reason
				
				numcpvVerts1 = -1
			)
		)
	)	

		if isIdentical == false then format "Mesh % is not identical to % because:\n%\n" msh1.name msh2.name reason
			else format  "Mesh % is identical to % \n" msh1.name msh2.name
	isIdentical
)

fn CheckIdenticalMeshes meshes = (
	
	for i = 1 to meshes.count - 1 do (
		msh1 = meshes[i]
		for j = i + 1 to meshes.count do (
			msh2 = meshes[j]
			format "testing % against %\n" msh1 msh2
			CheckIdentical msh1 msh2
			
		)
	)
)

fn LoadAndConvert = (
	convertcar()
	 wheels= convertallwheels()
	
	select wheels
)
