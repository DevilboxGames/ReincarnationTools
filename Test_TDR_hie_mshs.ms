fn TestHieFile hieFileName hFilename = (
	local hieClass = dotnetClass "ToxicRagers.TDR2000.Formats.HIE"
	local hieFile = hieClass.Load hieFileName hFilename
	
	format "CollisionDataMeshes: \n"
	for i = 0 to hieFile.CollisionDataMeshes.count - 1 do (
		local coldatamsh = hieFile.CollisionDataMeshes.item[i]
		format "\t%\n" coldatamsh
	)
	
	
	format "\nLineNames: \n"
	for i = 0 to hieFile.LineNames.count - 1 do (
		local linename = hieFile.LineNames.item[i]
		format "\t%\n" linename
	)
	
	
	format "\nTextures: \n"
	for i = 0 to hieFile.Textures.count - 1 do (
		local tex = hieFile.Textures.item[i]
		format "\t%\n" tex
	)
	
	
	format "\nMaterials: \n"
	for i = 0 to hieFile.Materials.count - 1 do (
		local mat = hieFile.Materials.item[i]
		format "\t[%,%,%,%] - %\n" mat.V.X mat.V.Y mat.V.Z mat.V.W mat.I
	)
	
	
	format "Matrixes: \n"
	for i = 0 to hieFile.Matrixes.count - 1 do (
		local matrix = hieFile.Matrixes.item[i]
		format "\t%\n" matrix.name
	)
	
	
	format "Meshes: \n"
	for i = 0 to hieFile.Meshes.count - 1 do (
		local msh = hieFile.Meshes.item[i]
		format "\t%\n" msh
	)
	
	
	format "Expressions: \n"
	for i = 0 to hieFile.Expressions.count - 1 do (
		local expr = hieFile.Expressions.item[i]
		format "\t[%,%]\n" expr.X expr.Y
	)
	
	
	format "Nodes: \n"
	for i = 0 to hieFile.Nodes.count - 1 do (
		local nde = hieFile.Nodes.item[i]
		format "\t% / % - % - %\n" nde.id nde.index nde.name (nde.Type.ToString())
			if (nde.Type.ToString()) == "Matrix" then (
				local mat = hieFile.Matrixes.Item[nde.Index]
				format "\t\tMat script: %\n" mat.name
			)
	)
	
	
	
	
)

fn TestMshs mshsFile = (
	local mshsClass = dotnetClass "ToxicRagers.TDR2000.Formats.MSHS"
	local mshsFile = mshsClass.Load mshsFile
	
	format "% meshes in file\n" mshsFile.meshes.count
	
	for i = 0 to mshsFile.meshes.count - 1 do (
		format "Mesh #% - %\n" i (mshsFile.Meshes.Item[i].Mode.ToString())
		format "\tNum Verts: %\n" mshsFile.meshes.Item[i].VertexCount
		format "\tNum Faces: %\n" mshsFile.meshes.Item[i].FaceCount
	)
)