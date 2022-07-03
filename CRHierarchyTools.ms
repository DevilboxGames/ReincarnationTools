

fn SetCNTNodeType mdl nodetype =
(
	if (IsObjectACNT mdl) ==false do custAttributes.add mdl CNTAttribute
	
	mdl.modifiers["CNT Hierarchy"].NodeType = nodetype
	mdl.modifiers["CNT Hierarchy"].NodeTypeID= (finditem CNTTypes nodetype)
)

fn SetToCNTNodes_Old mdl nodeType:undefined fileName:undefined =
(
	if (IsObjectACNT mdl) ==false do
	(
		custAttributes.add mdl CNTAttribute
		if fileName != undefined then mdl.CNTCustAttribute.FileName = fileName
		else mdl.CNTCustAttribute.FileName = mdl.name
		
		if (classof mdl) == dummy then 
		(
			SetCNTNodeType mdl "NULL"
			mdl.CNTCustAttribute.FileName = ""
			
		)
		else
		(
			if nodeType != undefined then SetCNTNodeType mdl nodeType
			else SetCNTNodeType mdl "MODL"
		)
		
	)
)

fn SetToCNTNodes mdl nodeType:undefined fileName:undefined =
(
	if (IsObjectACNT mdl)==false then
	(
		--max modify mode
		cntHierarchyModifier = emptyModifier()
		cntHierarchyModifier.name = "CNT Hierarchy"
		addModifier mdl cntHierarchyModifier
		custattributes.add cntHierarchyModifier CNTAttribute baseObject:false
		if fileName != undefined then cntHierarchyModifier.fileName = fileName
		else if mdl.name != undefined and mdl.name != "" then cntHierarchyModifier.fileName = mdl.name
		else cntHierarchyModifier.filename = "Unnamed"
		splitFilename = (FilterString cntHierarchyModifier.filename ".")
		if splitFilename != undefined and splitFilename.count > 1 then (
			cntHierarchyModifier.filename = splitFilename[1]
		)
		if (classof mdl) == dummy then 
		(
			SetCNTNodeType mdl "NULL"
			cntHierarchyModifier.FileName = ""
			
		)
		else if classof mdl == freeSpot or classof mdl == omnilight or classof mdl == Directionallight then
		(
			SetCNTNodeType mdl "LITg"
		)
		else
		(
			if nodeType != undefined then SetCNTNodeType mdl nodeType
			else if mdl.modifiers["Skin"] != undefined then
			(
				SetCNTNodeType mdl "SKIN"
			)
			else SetCNTNodeType mdl "MODL"
		)
		
		
	)
)
fn CreateNewNULLNode trans nodename addAttributes:true selectAndFocus:false nodeType: "NULL" =
(
	global forceDummyNull
	if forceDummyNull == true then 
	(
		m = dummy boxsize:[0.05,0.05,0.05] name:nodename transform:trans

	)
	else (
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
		--setEdgeVis m i 1 false
		--setEdgeVis m i 3 false
		--setEdgeVis m i 2 false
	)
	newmat = undefined
	for mat in scenematerials do
	(
		if mat.name == "crTools_NullNodeMaterial" do 
		(
			newmat = mat
			--exit
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
	
	)
	if addAttributes do
	(
		/*custAttributes.add m CNTAttribute #unique BaseObject:true
		SetCNTNodeType m "NULL"
		m.CNTCustAttribute.FileName = ""*/
		SetToCNTNodes m
		SetCNTNodeType m NodeType
	)
	if selectAndFocus do
	(
		select m
		max zoomext sel all
	)
	
	m.castShadows=false
	m.primaryVisibility=false
	m
)



fn InsertNullAbove target nullName =
(
	newnode = CreateNewNullNode target.transform nullName
	newnode.parent =target.parent
	target.parent = newnode

	newnode
)


fn SetCollectionToCNTNodes collection doChildren:false =
(
	for mdl in collection do
	(
		SetToCNTNodes mdl
		if doChildren and mdl.children.count > 0 then
		(
			SetCollectionToCNTNodes mdl.children doChildren:doChildren
		)
	)
)
fn SetSelectionToCNTNodes doChildren:false =
(
	SetCollectionToCNTNodes (selection as array) doChildren:doChildren
	/*for mdl in (selection as array) do
	(
		SetToCNTNodes mdl
	)*/
)
fn SetAllToCNTNodes =
(
	
	for mdl in ($*) do
	(
		SetToCNTNodes mdl
	)
)

fn SetupHierarchyButton_Pressed sender arg =
(
	undo "Setup Hierarchy" on
	(
		case sender.parent.controls.Item["SetupHierarchyListBox"].selectedIndex of
		(
			0:
			(
				SetSelectionToCNTNodes doChildren:true
			)
			1:
			(
				SetSelectionToCNTNodes doChildren:false
			)
			2:
			(
				SetAllToCNTNodes()
			)
		)
	)
)

fn CreateNullNodeButton_Pressed sender arg =
(
	undo "Create NULL Node" on
	(
		trans = matrix3 1
		if selection[1] != undefined do trans = selection[1].transform
		CreateNewNULLNode trans "NewNullNode" selectAndFocus:true
	)
)

fn ConvertToNullNodeButton_Pressed sender arg =
(
	undo "Convert To Wheel Node" on
	(
		for obj in (selection as array) do
		(
			trans = obj.transform
			newNullNode = CreateNewNULLNode trans "NewNullNode" selectAndFocus:false
			append obj.parent.children newNullNode
			for i=obj.children.count to 1 by -1 do
			(
				child = obj.children[i]
				
				append newNullNode.children child
			)
			delete obj
		)
	)
)

fn UpdateAttributesButton_Pressed sender arg =
(
	ClearListener()
	
	for obj in $* do
	(
		numCustAttribs = custAttributes.count obj
		format "% has % custom attributes\n" obj.name numCustAttribs
		for i=numCustAttribs to 1 by -1 do
		(
			custAttributeDef = custAttributes.getDef obj i
			
			--format "Def for attribute %: %\n" i (custAttributeDef)
			if (custAttributeDef as string) == "<AttributeDef:CNTCustAttribute>" then
			(
				format "This is a CNT attribute\n"
				attrib = custAttributes.get obj i
				fileName = attrib.fileName
				nodetype = attrib.nodetype
				custAttributes.delete obj i
				SetToCNTNodes obj nodeType:nodetype fileName:fileName
			)
			else if (custAttributeDef as string) == "<AttributeDef:CarWheelAttrib>" then
			(
				format "This is a Wheel attribute\n"
			)
		)
	)
)