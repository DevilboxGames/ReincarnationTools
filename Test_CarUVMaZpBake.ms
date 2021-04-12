function CookIt obj size filepath = (

	format "Cooking diffuse texture for % to %\n" obj.name filepath
	obj.iNodeBakeProperties.removeAllBakeElements()

	bakeDiffuse = diffuseMap()
	bakeDiffuse.outputszx = size
	bakeDiffuse.outputszy = size
	bakeDiffuse.fileType = filepath
	bakeDiffuse.fileName = filenameFromPath filepath
	bakeDiffuse.filteron = false
	bakeDiffuse.lightingon = false
	bakeDiffuse.shadowson = false
	bakeDiffuse.enabled = true

	obj.iNodeBakeProperties.addBakeElement bakeDiffuse
	obj.iNodeBakeProperties.bakeEnabled = true
	obj.iNodeBakeProperties.bakeChannel = 2
	obj.iNodeBakeProperties.nDilations = 1
	select obj
	render rendertype:#bakeSelected vfb:off progressBar:true outputsize:[size,size]
)

function TestUVMapBake obj outputPath = (
	select obj
	meshop.setNumMaps obj 3
	numTFaces = (meshop.getNumMapFaces obj 0)
	numTVerts = (meshop.getNumMapVerts obj 0)
	meshop.setNumMapFaces obj 2 numTFaces
	meshop.setNumMapVerts obj 2 numTVerts

	for i = 1 to numTVerts do (
		tvert = meshop.getMapVert obj 0 i
		meshop.setMapVert obj 2 i tvert
	)

	for f = 1 to numTFaces do (
		tface = meshop.getMapFace obj 0 f
		meshop.setMapFace obj 2 f tface
	)

	uvmap = Unwrap_UVW()
	addModifier obj uvmap

	uvmap.unwrap.setmapchannel 2
	uvmap.pack 1 0.01 true true true
	collapseStack obj

	size = 512
	if obj.parent == undefined then size =1024

	CookIt obj size  (outputpath + obj.name + "_d.png")
)

function UVMapBake meshes:undefined = (
	-- Function UVMapBake body

	if meshes == undefined then  (
		meshes = objects
	)

	for obj in meshes do (
		if (classof obj) == Editable_mesh then
		(
			format "Packing UVs for %\n" obj.name
			TestUVMapBake obj (GetDir #image + "\\")
		)
	)
)