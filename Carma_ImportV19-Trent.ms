filesize=0

if mat_CA == undefined do
(
	Mat_CA = attributes mat_data
	attribID:#(0x3304c755, 0x6a003698)
	(
		parameters mat_data rollout:mat_props
		(
			mat_flags type:#booltab tabsize:22 ui:(mat_lit,mat_prelit,mat_smooth,mat_env_mapped_inf,mat_env_mapped_loc,mat_cor_persp,mat_decal,mat_IfromU,mat_IfromV,mat_UfromI,mat_VfromI,mat_allvisib,mat_twosid,mat_forcef,mat_dither,mat_dummy,mat_antialias,mat_mapinterp,mat_mipinterp,mat_fogloc,mat_subdiv,mat_ztransp) autodisplay:true
			mat_ambient type:#float default:0.1 ui:mat_ambient
			mat_directional type:#float default:0.7 ui:mat_directional
			mat_specular type:#float default:0 ui:mat_specular
			mat_power type:#float default:20
		)
		rollout mat_props "Carmageddon material properties"
		(
			group "Flags"
			(
				checkbox mat_lit "Lit" checked:true across:3 align:#left
				checkbox mat_prelit "Pre-lit"checked:false
				checkbox mat_smooth "Smooth" checked:true
				checkbox mat_env_mapped_inf "Env map (inf)"checked:false across:3
				checkbox mat_env_mapped_loc "Env map (loc)"checked:false
				checkbox mat_cor_persp "Correct persp" checked:true
				checkbox mat_decal "Decal" checked:false across:3
				checkbox mat_allvisib "Always visible" checked:false
				checkbox mat_twosid "Two sided" checked:false
				checkbox mat_forcef "Force front" checked:false across:3
				checkbox mat_dither "Dither" checked:false
				checkbox mat_dummy "" checked:false enabled:false visible:false
				checkbox mat_antialias "Map aa" checked:false across:3
				checkbox mat_mapinterp "Map interp" checked:false 
				checkbox mat_mipinterp "Mip interp" checked:false 
				checkbox mat_subdiv "Subdivide" checked:false across:3
				checkbox mat_fogloc "Fog local" checked:false 
				checkbox mat_ztransp "Z transp" checked:false
				label mat_lab_2 ""
				checkbox mat_IfromU "I from U" checked:false across:4
				checkbox mat_IfromV "I from V" checked:false
				checkbox mat_UfromI "U from I" checked:false --across:2
				checkbox mat_VfromI "V from I" checked:false
			)
			group "Lighting"
			(
				label mat_label1 "ambient" across:3 align:#right offset:[-20,10] ticks:10
				slider mat_ambient range:[0,1,0.1] type:#float orient:#horizontal width:150 scale:0.1
				edittext mat_ambient_entry width:50 offset:[0,10] text:(mat_ambient.value as string) align:#right
				
				label mat_label2 "Directional" across:3 align:#right offset:[-20,10]
				slider mat_directional range:[0,1,0.1] type:#float orient:#horizontal width:150 scale:0.1
				edittext mat_directional_entry width:50 offset:[0,10] text:(mat_directional.value as string) align:#right
				
				label mat_label3 "Specular" across:3 align:#right offset:[-20,10]
				slider mat_specular range:[0,1,0.1] type:#float orient:#horizontal width:150 scale:0.1
				edittext mat_specular_entry width:50 offset:[0,10] text:(mat_specular.value as string) align:#right
				
				label mat_label4 "Specular Power" across:2 align:#right offset:[80,10]
				edittext mat_specularpower width:50 offset:[0,10] align:#right text:(mat_power as string)
			)
			on mat_ambient changed val do mat_ambient_entry.text = val as string
			on mat_directional changed val do mat_directional_entry.text = val as string
			on mat_specular changed val do mat_specular_entry.text = val as string
			on mat_ambient_entry changed val do mat_ambient.value = val as float
			on mat_directional_entry changed val do mat_directional.value = val as float
			on mat_specular_entry changed val do mat_specular.value = val as float
			on mat_specularpower changed val do mat_power = val as float
		)
	)
)

fn openbinfile filename filetype=
(
	binfile=fopen filename filetype
	fseek binfile 0 #seek_end
	filesize=ftell binfile 
	fseek binfile 0 #seek_set
	return binfile
)

fn binend binfile=(ftell binfile>=filesize)

fn binstat binfile=(100.*(ftell binfile)/filesize)

fn freadbyte bf =(return readbyte bf #unsigned)

fn freadint bf =((readbyte bf #unsigned * 256)+(readbyte bf #unsigned))

fn freadlong bf =(((readbyte bf #unsigned) * 16777216)+((readbyte bf #unsigned) * 65536)+((readbyte bf #unsigned) * 256)+(readbyte bf #unsigned))

fn freadfloat bf =
(
	bf = readfloat bf
	i = bit.floatasint bf
	h = bit.intashex i
	while h.count < 8 do h = "0" + h
	
	s = (substring h 7 2) + (substring h 5 2) + (substring h 3 2) + (substring h 1 2)
	bit.intAsFloat (bit.hexasint s)
) 

fn freadstring bf =
(
	return readstring bf
)

fn freadhead bf =
(
	val=0
	for i=1 to 16 do
	(
		val=val+(readbyte bf #unsigned)
	)
	return val
)

fn freadchunk bf =
(
	val=freadlong bf
	freadlong bf
	return val
)

fn freadoname bf =
(
	cap=freadint bf
	n=freadstring bf
	return n
)

fn readvlst bf imp_scale69:true =
(
	count=freadlong bf
	val=#()
	for i=1 to count do
	(
		x=freadfloat bf
		y=freadfloat bf
		z=freadfloat bf
		if imp_scale69 then
		(
			x = x * 6.9
			y = y * 6.9
			z = z * 6.9
		)
		append val [-x,z,y]
	)
	return val
)

fn readtvlst bf =
(
	count=freadlong bf
	val=#()
	for i=1 to count do
	(
		u=freadfloat bf
		v=freadfloat bf
		append val [u,-v,0]
	)
	return val
)

fn readflst bf smth edv =
(
	count=freadlong bf
	val=#()
	for i=1 to count do
	(
		a=freadint bf
		b=freadint bf
		c=freadint bf
		s = freadint bf
		f=freadbyte bf
		
		append smth s
		append edv f
		append val [b+1,c+1,a+1]
	)
	return val
)

fn setomaterial o mlst materials materialnames = 
(
	if mlst.count>1 do
	(
		objmtl = multimaterial()
		objmtl.numsubs = mlst.count
		for i=1 to mlst.count do
		(
			try objmtl.materiallist[i] = materials[finditem materialnames mlst[i]] catch()
		)
	)
	if mlst.count==1 do
	(
		try objmtl = materials[finditem materialnames mlst[1]] catch()
	)
	o.material = objmtl
)

fn readmlst bf =
(
	count=freadlong bf
	val=#()
	for i=1 to count do
	(
		append val (readstring bf)
	)
	return val
)

fn readmid bf =
(
	count=freadlong bf
	val=#()
	freadlong bf
	for i=1 to count do
	(
		id = (freadint bf)
		--if id!= 0 then append val id else append val 1
		append val id
	)
	return val
)

fn readmrgb bf=
(
	mr = freadbyte bf
	mg = freadbyte bf
	mb = freadbyte bf
	mf = freadbyte bf
	mrgb = (color mr mg mb)
	return mrgb
)

fn readaname bf=
(
	freadbyte bf
	freadbyte bf
	aname = freadstring bf
	return aname
)

fn readaoname bf=
(
	n = freadstring bf
	return n
)

fn readtm bf tmtab =
(
	x1 = freadfloat bf
	x2 = freadfloat bf
	x3 = freadfloat bf
	y1 = freadfloat bf
	y2 = freadfloat bf
	y3 = freadfloat bf
	z1 = freadfloat bf
	z2 = freadfloat bf
	z3 = freadfloat bf
	t1 = freadfloat bf
	t2 = freadfloat bf
	t3 = freadfloat bf
	amatrix = (matrix3 [x1,x2,x3] [y1,y2,y3] [z1,z2,z3] [-t1,t2,-t3])
	amatrix = matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0] * amatrix * inverse(matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])
	--amatrix = amatrix * (matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])
	if tmtab.count > 0 do
	(
		amatrix = amatrix * tmtab[tmtab.count]
	)
	append tmtab amatrix
	--amatrix = amatrix * (matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
	return amatrix
)

fn readabbox bf=
(
	abbox1 = [freadfloat bf, freadfloat bf, freadfloat bf]
	abbox2 = [freadfloat bf, freadfloat bf, freadfloat bf]
	abbox = #(abbox1,abbox2)
	return abbox
)

fn readamat bf=
(
	amat = freadstring bf
	return amat
)

fn readmtm bf=
(
	x1 = freadfloat bf
	x2 = freadfloat bf
	y1 = freadfloat bf
	y2 = freadfloat bf
	t1 = freadfloat bf
	t2 = freadfloat bf
	mtm = (matrix3 [x1,x2,0] [y1,y2,0] [0,0,0] [t1,t2,0])
	--format "%, % / %, % / %, %\n" x1 x2 y1 y2 t1 t2
	return mtm
)
fn FindBitmap filename =
(
	folder = ""
)
fn setmbtm m mbtm mtm filetype:".tif"=
(
	mbtm = filterstring mbtm "."
	--format "\ttrying to load %" (mbtm[1] + filetype)
	m.diffusemap = bitmaptexture filename:(mbtm[1] + filetype)
	
	--format "loaded diffusemap %\n" m.diffusemap
	bmp =  (openbitmap (mbtm[1] + filetype))
		
	--format "loaded bitmap %\n" bmp
		if(bmp != undefined) then 
		( 
			m.diffusemap.filename = bmp.filename
			
			if bmp.hasAlpha then (
				m.opacitymap = bitmaptexture filename:(mbtm[1] + filetype)
				m.opacitymap.filename = bmp.filename
				m.opacitymap.coords.u_tiling = mtm.scalepart[1]
				m.opacitymap.coords.v_tiling = mtm.scalepart[2]
				m.opacitymap.coords.U_Angle = (mtm as EulerAngles).x
				m.opacitymap.coords.V_Angle = (mtm as EulerAngles).y
				m.opacitymap.coords.W_Angle = (mtm as EulerAngles).z
				m.opacitymap.coords.u_offset = mtm.translationpart[1]
				m.opacitymap.coords.u_offset = mtm.translationpart[2]
				m.opacitymap.monooutput = 1
			)
		)
		else (
			format "ERROR: loaded diffusemap %\n" (mbtm[1] + filetype)
		)
	m.diffusemap.coords.u_tiling = mtm.scalepart[1]
	m.diffusemap.coords.v_tiling = mtm.scalepart[2]
	m.diffusemap.coords.U_Angle = (mtm as EulerAngles).x
	m.diffusemap.coords.V_Angle = (mtm as EulerAngles).y
	m.diffusemap.coords.W_Angle = (mtm as EulerAngles).z
	m.diffusemap.coords.u_offset = mtm.translationpart[1]
	m.diffusemap.coords.u_offset = mtm.translationpart[2]
	showTextureMap m on
)
	
fn fsetedgevis o edv=
(
	for i=1 to o.faces.count do
	(
		edgevis = edv[i]
		if edgevis == 1 do setedgevis o i 1 false
		if edgevis == 2 do setedgevis o i 2 false
		if edgevis == 3 do
		(
			setedgevis o i 1 false
			setedgevis o i 2 false
		)
		if edgevis == 4 do setedgevis o i 3 false
		if edgevis == 5 do 
		(
			setedgevis o i 3 false
			setedgevis o i 1 false
		)
		if edgevis == 6 do
		(
			setedgevis o i 3 false
			setedgevis o i 2 false
		)
		if edgevis == 7 do
		( 
			setedgevis o i 1 false
			setedgevis o i 2 false
			setedgevis o i 3 false
		)
	)			
)

fn fsetsmoothgroups o smth = 
(
	for i=1 to o.faces.count do
	(
		setFaceSmoothGroup o i smth[i]
	)
)

fn setFaceSmoothGroupB obj face sg_bitarray =
(
	local sgroup_val=0
	for i in sg_bitarray do sgroup_val += 2^(i-1)
	setFaceSmoothGroup obj face sgroup_val
	update obj
)

fn keepprocessfocus= if (MaxVersion())[1] >= 9000 do (dotnetClass "Application").doEvents()

fn set_m_flags mfl=
(
	if mfl!= undefined do
	(
		flags = #(false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)
		for i=0 to 21 do
		(
			if (mfl - (2^(21-i))) > -1 do 
			(
				mfl = mfl - (2^(21-i))
				flags[(22-i)] = true
			)
		)
		return flags
	)
)

fn GetLevelMatPixFiles txtpath =
(
	f = openfile txtpath
	matFiles = #()
	pixFiles = #()
	datFiles = #()
	actFiles = #()
	version = 0
	lineNum = 0
	numCheckpoints = 0
	matStartLine = 0
	numMats = 0
	matLowStartLine = 0
	numMatsLow = 0
	pixStartLine = 0
	numPix = 0
	pixLowStartLine = 0
	numPixLow = 0
	tabStartLine = 0
	numTabs = 0
	datStartLine = 0
	numDATs = 0
	datLowStartLine = 0
	numDATsLow = 0
	actLine = 0
	actLowLine = 0
	actExtraLine = 0
	
	do
	(
		ln = readline f
		splitline = filterstring ln " \t" splitEmptyTokens:false
		
		if (splitline.count > 0 and (substring splitline[1] 1 2) == "//") or splitline.count == 0 then continue
		else
		(
			lineNum += 1
			if lineNum == 1 then
			(
				if (tolower splitline[1]) != "version" then
				(
					format "ERROR: Does not start with VERSION: %\n" txtpath
					exit
				)
				version = splitline[2] as integer
				if version < 4 then
				(
					format "ERROR: Is VERSION: %\n" txtpath
					exit
				)
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum == 11 then
			(
				numCheckpoints = splitline[1] as integer
				--format "%:\t\t%\n" lineNum ln
				pixStartLine = lineNum+1+(9*numCheckpoints)
			)
			else if lineNum == pixStartLine then
			(
				numPix = splitline[1] as integer
				--format "%:\t\t%\n" lineNum ln
				pixLowStartLine = lineNum + 1 + numPix
			)
			else if lineNum > pixStartLine and lineNum <= pixStartLine + numPix then
			(
				appendIfUnique pixFiles splitline[1]
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum == pixLowStartLine then
			(
				numPixLow = splitline[1] as integer
			--	format "%:\t\t%\n" lineNum ln
				tabStartLine = lineNum + 1 + numPixLow
			)
			else if lineNum == tabStartLine then
			(
				numTabs = splitline[1] as integer
			--	format "%:\t\t%\n" lineNum ln
				matStartLine = lineNum + 1 + numTabs
			)
			else if lineNum == matStartLine then
			(
				numMats = splitline[1] as integer
			--	format "%:\t\t%\n" lineNum ln
				matLowStartLine = lineNum + 1 + numMats
			)
			else if lineNum > matStartLine and lineNum <= matStartLine + numMats then
			(
				appendIfUnique matFiles splitline[1]
			--	format "%:\t\t%\n" lineNum ln
				
			)
			else if lineNum == matLowStartLine then
			(
				numMatsLow = splitLine[1] as integer
				datStartLine = lineNum + 1 +numMatsLow
			)
			else if lineNum == datStartLine then
			(
				numDATs = splitline[1] as integer
				if version > 5 then datLowStartLine = lineNum + 1 + numDATs
				else
				(
					actLine = lineNum + 1 + numDATs
					if version < 7 then
						actExtraLine = actLine+1
				)
				
			)
			else if lineNum > datStartLine and lineNum <= datStartLine + numDats then
			(
				appendIfUnique datFiles splitLine[1]
			)
			else if lineNum == datLowStartLine then
			(
				numDATsLow = splitline[1] as integer
				actLine = lineNum + 1 + numDATsLow
				actLowLine = actLine+1
				actExtraLine = actLine+2
			)
			else if lineNum == actLine then
			(
				appendIfUnique actFiles splitLine[1]
				if version >= 7 then exit;
			)
			else if lineNum == actExtraLine then
			(
				appendIfUnique actFiles splitLine[1]
				exit;
			)
		)
	)
	while (eof f) == false
	--format "lineNum: %\n" lineNum
	
	return #(pixFiles, matFiles, datFiles, actFiles)
)


fn GetCarDataFiles txtpath =
(
	f = openfile txtpath
	matFiles = #()
	pixFiles = #()
	datFiles = #()
	actFiles = #()
	
	numClauses = 0
	currentClause = 0
	numSystems = 0
	currentImpactSection = 0
	nextImpactSection = 10
	nextClause = 11
	
	pixLowStartLine = 0
	numPixLow = 0
	pixMidStartLine = 0
	numPixMid = 0
	pixHighStartLine = 0
	numPixHigh = 0
	
	shadeTableStartLine = 0
	numShadeTable = 0
	
	matLowStartLine = 0
	numMatLow = 0
	matMidStartLine = 0
	numMatMid = 0
	matHighStartLine = 0
	numMatHigh = 0
	
	datStartLine = 0
	numDats = 0
	actStartLine = 0
	numActs = 0
	lineNum = 0
	do
	(
		ln = readline f
		splitline = filterstring ln " \t" splitEmptyTokens:false
		
		if (substring splitline[1] 1 2) == "//" or splitline.count == 0 then continue
		else
		(
			lineNum += 1
			if lineNum == 1 then
			(
				if (tolower splitline[1]) != (tolower (filenameFromPath txtPath)) then
				(
					format "ERROR: Does not start with %: %\n" (filenameFromPath txtPath) txtpath
					exit
				)
			)
			else if lineNum == nextImpactSection then
			(
				currentImpactSection += 1
				numClauses = splitline[1] as integer
				nextClause = lineNum + 1
				currentClause = 1
				--format "%:\t\t%\n" lineNum ln
				
			)
			else if lineNum == nextClause + 1 then
			(
				numSystems = splitLine[1] as integer
				currentClause += 1
				if currentClause > numClauses then
				(
					nextClause = 0
					if currentImpactSection < 6 then
						nextImpactSection = lineNum + 1 + numSystems
					else
						pixLowStartLine = lineNum + 2 + numSystems
				)
				else
					nextClause = lineNum + 1 + numSystems
			)
			else if lineNum == pixLowStartLine then
			(
				numPixLow = splitLine[1] as integer
				pixMidStartLine = lineNum + 1 + numPixLow
			)
			else if lineNum == pixMidStartLine then
			(
				numPixMid = splitLine[1] as integer
				pixHighStartLine = lineNum + 1 + numPixLow
			)
			else if lineNum == pixHighStartLine then
			(
				numPixHigh = splitLine[1] as integer
				shadeTableStartLine = lineNum + 1 + numPixHigh
			)
			else if lineNum == shadeTableStartLine then
			(
				numShadeTable = splitLine[1] as integer
				matLowStartLine = lineNum + 1 + numShadeTable
			)
			else if lineNum > pixLowStartLine and lineNum <= pixLowStartLine + numPixLow then
			(
				--appendIfUnique pixFiles splitline[1]
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum > pixMidStartLine and lineNum <= pixMidStartLine + numPixMid then
			(
				--appendIfUnique pixFiles splitline[1]
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum > pixHighStartLine and lineNum <= pixHighStartLine + numPixHigh then
			(
				appendIfUnique pixFiles splitline[1]
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum == matLowStartLine then
			(
				numMatLow = splitline[1] as integer
				--format "%:\t\t%\n" lineNum ln
				matMidStartLine = lineNum + 1 + numMatLow
			)
			else if lineNum == matMidStartLine then
			(
				numMatMid = splitline[1] as integer
				--format "%:\t\t%\n" lineNum ln
				matHighStartLine = lineNum + 1 + numMatMid
			)
			else if lineNum == matHighStartLine then
			(
				numMatHigh = splitline[1] as integer
				--format "%:\t\t%\n" lineNum ln
				datStartLine = lineNum + 1 + numMatHigh
			)
			else if lineNum > matLowStartLine and lineNum <= matLowStartLine + numMatLow then
			(
				--appendIfUnique matFiles splitline[1]
			--	format "%:\t\t%\n" lineNum ln
				
			)
			else if lineNum > matMidStartLine and lineNum <= matMidStartLine + numMatMid then
			(
				--appendIfUnique matFiles splitline[1]
			--	format "%:\t\t%\n" lineNum ln
				
			)
			else if lineNum > matHighStartLine and lineNum <= matHighStartLine + numMatHigh then
			(
				appendIfUnique matFiles splitline[1]
			--	format "%:\t\t%\n" lineNum ln
				
			)
			else if lineNum == datStartLine then
			(
				--format "datStartLine\n"
				numDats = splitLine[1] as integer
				actStartLine = lineNum + 1 +numDats
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum == actStartLine then
			(
				--format "actStartLine\n"
				numActs = splitline[1] as integer
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum > datStartLine and lineNum <= datStartLine + numDats then
			(
				--format "reading dat file\n"
				appendIfUnique datFiles splitLine[1]
				--format "%:\t\t%\n" lineNum ln
			)
			else if lineNum > actStartLine and lineNum <= actStartLine + numActs then
			(
				--format "reading act file"
				--format "%:\t\t%\n" lineNum ln
				splitActLine = filterstring splitLine[1] ", "
				if splitActLine[1] as integer == 0 then
					appendIfUnique actFiles splitActLine[2]
			)
		)
	)
	while (eof f) == false
	--format "lineNum: %\n" lineNum
	
	return #(pixFiles, matFiles, datFiles, actFiles)
)

fn ParseAllRaceTXTFiles dir =
(
	textfiles = getFiles (dir+"*.txt")
	for f in textFiles do GetLevelMatPixFiles f
)

fn LoadMATFile mln &progressValue imageExtension:".tif"=
(
	
		global smth
		global edv
		global materials
		global materialnames
		global deletemodels
		global tmtab 
		
		global aname
		global atm 
		global abbox
		global amat 
		global mname 
	bf=openbinfile mln "rb"
	freadhead bf
	do
	(
		chunk=freadchunk bf
		if chunk == 31 then
		(
			freadstring bf
			freadfloat bf
			freadfloat bf
		)
		else if chunk==60 or chunk==4 then
		(
			mrgb = readmrgb bf --4bytes
			mal = freadfloat bf --ambient lighting 4bytes
			mdl = freadfloat bf --directional lighting 4bytes
			msl = freadfloat bf --specular lighting 4bytes
			msp = freadfloat bf --specular power 4bytes
			if chunk==60 do mfl = freadlong bf --flags 4bytes
			if chunk==4 do
			(
				fpos = ftell bf
				mfl1 = freadbyte bf --flag light
				mfl2 = freadbyte bf --flag smooth
				fseek bf -2 #seek_cur
				mfl = freadint bf
			)
			mtm = readmtm bf --tm 24bytes
			if chunk==60 do
			(
				freadhead bf --16 bytes
				freadbyte bf --2 bytes, some kind of flag
			)
			if chunk==4 do
			(
				freadbyte bf
				freadbyte bf --the question mark, some kinf of flag
			)
			mname = freadstring bf
			testchunk = freadchunk bf
			if testchunk == 28 do
			(
				mbtm = freadstring bf
				tchunk = freadchunk bf
				if tchunk == 31 do
				(
					mtab = freadstring bf
					freadchunk bf
				)
			)
			if testchunk == 31 do
			(
				mtab = freadstring bf
				freadchunk bf
			)
			
			m = standard()
			m.diffuse = mrgb
			m.ambient = (color (mal*255) (mal*255) (mal*255))
			m.specular = (color (msl*255) (msl*255) (msl*255))
			m.specularLevel = msp
			m.name = mname
			if mbtm != undefined do
			(
				setmbtm m mbtm mtm filetype:imageExtension
			)
			
			custattributes.add m mat_CA
			m.mat_flags = set_m_flags mfl
			m.mat_ambient = mal
			m.mat_directional = mdl
			m.mat_specular = msl
			m.mat_power = msp
			
			mname = undefined
			mrgb = (color 255 255 255)
			mbtm = undefined
			append materials m
			append materialnames m.name
		)
		progressValue = binstat bf
		keepprocessfocus()
		
	)while binend bf == false
	fclose bf
)

fn LoadDATFile fnm &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true prefix:"" imp_scale69:true imp_onlyNonCars:false =
(
	
		global smth
		global edv
		global materials
		global materialnames
		global deletemodels
		global tmtab 
		
		global aname
		global atm 
		global abbox
		global amat 
		global mname 

		global loadedObjects
		if loadedObjects == undefined then loadedObjects = #()
		firstMesh = undefined
	bf=openbinfile fnm "rb"
			head=freadhead bf
			if (head == 484) do
			(
				progressText = "status: importing DAT..."
				do
				(
					chunk=1
					doneModelName = false
					do
					(
						chunk=freadchunk bf
						if chunk==54 do
						(
							if doneModelName == true then
							(
								fseek bf -8 #seek_cur
								chunk = 0
							)
							else
							(
								oname=freadoname bf
								doneModelName = true
							)
						)
						if chunk==23 do
						(
							vlst=readvlst bf imp_scale69:imp_scale69
						)
						if chunk==24 do
						(
							tvlst=readtvlst bf
							
						)
						if chunk==53 do 
						(
							flst=readflst bf smth edv
							
						)
						if chunk==22 do
						(
							mlst=readmlst bf
						)
						if chunk==26 do 
						(
							--format "% mid pos is %\n" oname (ftell bf)
							mid=readmid bf
							--format "% mid's = %\n\n" oname mid
						)
					)while chunk != 0

					if oname[1] == "&" or imp_onlyNonCars == false then (
 					--Format "% has % verts and % faces\n" oname vlst.count flst.count
						if vlst==undefined do vlst=#()
						if flst==undefined do flst=#()
						if tvlst==undefined do tvlst=#()
						if mlst==undefined then mlst=#()
						if mid==undefined or mid.count!=flst.count do
						(
							mid=for i=1 to flst.count collect 1
						)
						o=mesh vertices:vlst faces:flst materialids:mid name:(prefix+oname) tverts:tvlst
						o.transform = matrix3 1
						mmesh = o.mesh

						for i = 1 to mid.count do (
							setFaceMatID mmesh i mid[i]
						)
						setNumCPVVerts mmesh vlst.count
						buildVCFaces mmesh
						try 
						(
							buildTVFaces mmesh 
							for i = 1 to mmesh.numfaces do (
								setTVFace mmesh i (getFace mmesh i)
								setVCFace mmesh i (getFace mmesh i)
								setEdgeVis mmesh i 1 true
								setEdgeVis mmesh i 2 true
								setEdgeVis mmesh i 3 true
							)
						)
						catch()
						if imp_mat == true do setomaterial o mlst materials materialnames
						if imp_smth == true do fsetsmoothgroups o smth
						if imp_quad == true do fsetedgevis o edv
						update o
						append loadedObjects o
						if firstMesh == undefined then (
							firstMesh = o
						)
					)
					--if imp_act.checked == false do rotate o (angleaxis 90 [1,0,0])
					vlst=undefined
					flst=undefined
					mlst=undefined
					mid=undefined
					tvlst=undefined
					smth = #()
					edv = #()
					progressValue = binstat bf
					keepprocessfocus()
				)while binend bf == false
			)
			fclose bf

			firstMesh
)
fn LoadACTFile acn &progressValue &progressText imp_hier:true imp_group:true imp_other_coord_sys:false prefix:"" imp_scale69:true =
(

		global smth
		global edv
		global materials
		global materialnames
		global deletemodels
		global accessoryModels
		global tmtab 
		
		global aname
		global atm 
		global abbox
		global amat 
		global mname 
		global loadedObjects
	progressText = "status: importing ACT..."
	bf=openbinfile acn "rb"
	head = freadhead bf
	rootmesh = undefined
	if head==29 do
	(
		global prnt = #(undefined)
		global mprnt = undefined
		global addp = true
		global removep = false
		chunk=1
		do
		(
			chunk = freadchunk bf
			if chunk == 35 do 
			(
				global aname = readaname bf
				
				mprnt = prnt[(prnt.count)]
				
				tchunk = 1
				do
				(
					tchunk = freadchunk bf
					if tchunk == 43 do global atm = readtm bf tmtab
					if tchunk == 50 do global abbox = readabbox bf
					if tchunk == 38 do global amat = readamat bf
					if tchunk == 36 do global mname = readaoname bf
					if tchunk == 42 do 
					(
						if tmtab.count != 0 do
						(
							deleteitem tmtab tmtab.count
							addp=false
							if removep==true do
							(
								deleteitem prnt prnt.count
							)
							removep = true
						)
					)
					if tchunk == 35 do
					(
						fseek bf -8 #seek_cur
						tchunk = 0
					)
				)while tchunk!=0
				
				if mname != undefined and aname!= undefined do --write mesh actors
				(
					m = undefined
					model = undefined --getnodebyname (prefix+mname)
					for obj in loadedObjects do (
						if obj.name == (prefix+mname) then
						(
							model = obj
						)
					)
					if model != undefined do
					(
						m = instance model
						
						m.transform = atm
						if imp_scale69 then 
						(
							m.pos = m.pos * [6.9, 6.9, 6.9]
						)

						
						if amat != "" and amat != undefined do
						(
							stdmats = getClassInstances standard
							foundMat = undefined
							for mat in materials do (
								if (toupper mat.name) == (toupper amat) then foundMat = mat
							)
								--format "adding actor mat % to %\n" amat model.name
							if foundMat != undefined then (
								if m.material == undefined then
								(
									--format "\tmodel has no material\n"
									m.material = foundMat
								)
								else (
									if classof m.material == standard then (
										--format "\tmodel has single mat\n"
										material = multimaterial()
										material.numsubs = 2
										material.materiallist[1] = m.material
										material.materiallist[2] = foundMat
										m.material = material
									)
									else (
										if classof m.material == multimaterial then (
										--format "\tmodel has multimat\n"
											material = m.material
											material.numsubs = (material.numsubs + 1)
											material[material.numsubs] = foundMat
											m.material = material
										)
									)
								)
							)
							else (

								format "===============\n=====Fuck, mat % not found!\n" amat
							)
						)
						m.name = prefix+mname
						--format "writing mesh actor: % - % / % - %\n" mname prefix aname m.pos
						setUserProp m "datName" mname
						if addp == true do append prnt m
						if mname[1]!="&" then
						(
							append deletemodels model
						)
						else if mname[1]=="&" then
						(
							append accessoryModels m
						)
					)
				)
				if aname!=undefined and mname==undefined and aname!="" do --write group actors with names
				(
					--format "writing named dummy actors: %\n" mname
					m = dummy boxsize:[0.1,0.1,0.1] select:false
					if imp_group then
					(
						setgrouphead m true
						setGroupOpen m true
					)
				
					m.transform = atm
						if imp_scale69 then 
						(
							m.pos = m.pos * [6.9, 6.9, 6.9]
						)
					m.name = prefix+aname
						--format "writing mesh actor: % - % / % - %\n" mname prefix aname m.pos
					if addp == true do append prnt m
				)
				if aname=="" do --write group actors
				(
					--format "writing blank dummy actors\n"
					m = dummy boxsize:[0.1,0.1,0.1] select:false
					if imp_group then
					(
						setgrouphead m true
						setGroupOpen m true
					)
					m.transform = atm
						if imp_scale69 then 
						(
							m.pos = m.pos * [6.9, 6.9, 6.9]
						)
					m.name = "NO_IDENTIFIER"
						--format "writing mesh actor: % - % / % - %\n" mname prefix m.name m.pos
					if addp==true do append prnt m
				)
				if mprnt != undefined and imp_hier == true then
				(
					--format "======\t\tadding parent \"%\" to \"%\"\n" mprnt m.name
					m.parent = mprnt
					if imp_group and isgrouphead mprnt then setgroupmember m true
				)
				else if mprnt == undefined then (
					rootmesh = m
				)
				--format "finished node %\n\n" aname
				if imp_other_coord_sys and m!= undefined then
				(
					in coordsys world (
						tmpPos = m.pos
						tmpRot = m.rotation
						 )
					m.rotation = tmpRot
					m.pos = tmpPos
				)
				if removep==true do removep=false
			)
			aname = undefined
			atm = undefined
			abbox = undefined
			amat = undefined
			mname = undefined
			mprnt = undefined
			addp=true
			progressvalue = binstat bf
			keepprocessfocus()
		)while chunk!=0 and binend bf==false
		
		if imp_group then (
			for obj in objects do if isgrouphead obj == true do setGroupOpen obj false
		)
		if imp_group then (
			progressText = "status: updating bboxes"
			for i=1 to objects.count do
			(
				obj = objects[i]
				if isgrouphead obj == true do setgroupopen obj true
				progressValue = 100.*(i)/objects.count
				keepprocessfocus()
			)
		)
	)
	fclose bf
	for i=1 to deletemodels.count do
	(
		try delete deletemodels[i] catch()
	)

	rootmesh
)

fn LoadC1TXT fnm &progValue &progText imp_onlyNonCars:false imp_hier:true imp_group:false imp_smth:true imp_mat:true imp_quad:true imp_act:true imp_other_coord_sys: false prefix:"" imageExtension:".tif" imp_onlyMainMeshes:false=
(
		global smth=#()
		global edv=#()
		global materials=#()
		global materialnames=#()
		global deletemodels=#()
		global accessorymodels=#()
		global tmtab = #()
		global loadedObjects = #()
		
		global aname = undefined
		global atm = undefined
		global abbox = undefined
		global amat = undefined
		global mname = undefined
		
		
		rootmesh = undefined
		if fnm != undefined then
		(
			
				textFilePath	= getfilenamepath fnm
				textFileName	= getfilenamefile fnm
				splitPath 		= filterstring textFilePath "\\"
				dataPath 		= ""
				typeOfTextFile	= ""
			
				typeOfTextFile = tolower splitPath[splitPath.count]
				for pathPart = 1 to splitPath.count - 1 do
				(
					dataPath += splitPath[pathPart] +"\\"
					
				)
				pixelMapPath	= dataPath + "pixelmap\\"
				materialPath	= dataPath + "material\\"
				actorsPath		= dataPath + "actors\\"
				modelsPath		= dataPath + "models\\"
				carsPath		= dataPath + "cars\\"
				racePath		= datapath + "races\\"
				
				dataFiles = #()
				if typeOfTextFile == "races" then dataFiles = GetLevelMatPixFiles fnm
				else if typeOfTextFile == "cars" then dataFiles = GetCarDataFiles fnm
				
				--for d in dataFiles do format "%\n" d
					--return 0
				for pixies in dataFiles[1] do
				(
					sessionPaths.add #map (pixelMapPath+(getFilenameFile pixies)+"\\")
				)
				if imp_mat then for mat in dataFiles[2] do
				(
					--format "Loading material: %\n" mat
					matFilename = (materialPath+mat)
					if (doesFileExist  matFilename) == false then
					(
						format "ERROR: can't find material: %\n" matFilename
						continue
					)
					
					progtext = "status: importing MAT..."
					LoadMATFile matFilename &progvalue imageExtension:imageExtension
					
				)
				for dat in dataFiles[3] do
				(
					datFilename = modelsPath + dat
					LoadDATFile datFilename &progvalue &progtext imp_smth: imp_smth imp_mat:imp_mat imp_quad:imp_quad imp_other_coord_sys:imp_other_coord_sys prefix: prefix imp_onlyNonCars:imp_onlyNonCars
				)
				if imp_act then for act in dataFiles[4] do
				(
					actFilename = actorsPath + act
					rootmesh = LoadACTFile actFilename &progvalue &progtext imp_hier:imp_hier imo_group:imp_group prefix: prefix
				)
				if imp_onlyMainMeshes then (
					for obj in loadedObjects do (
						if (isValidNode obj) and obj.parent == undefined and obj != rootmesh then(
							delete obj
						)
					)
				)
		)
		
		globalvars.remove "deletemodels"
		globalvars.remove "smth"
		globalvars.remove "edv"
		globalvars.remove "materials"
		globalvars.remove "materialnames"
		globalvars.remove "deletemodels"
		globalvars.remove "tmtab"
	
		globalvars.remove "aname"
		globalvars.remove "atm"
		globalvars.remove "abbox"
		globalvars.remove "amat"
		globalvars.remove "mname"
		rootmesh
)

fn LoadAllC1TXTFiles dir imp_onlyNonCars:false imp_act:true textfiles:undefined=
(
	if textfiles == undefined then 
		textfiles = getFiles (dir+"*.txt")
	progValue = 0
	progText = ""
	colSpacing = 1
	rowSpacing = 1.5
	numPerRow = sqrt textfiles.count
	--numPerRow = 3
	currentPos = [0,0,0]
	currentCol = 0
	currentRow = 0
	for f in textFiles do
	(
		currentPos = [colSpacing * currentCol, rowSpacing * currentRow, 0]
		--format "currentPos: % \t\tcurrentCol: %\t\t currentRow\n" (transMatrix currentPos) currentCol currentRow
		in coordsys (transMatrix currentPos)
		(
			LoadC1TXT f &progValue &progText prefix:(getFilenameFile f) imp_act:imp_act imageExtension:".png" imp_onlyNonCars:imp_onlyNonCars imp_other_coord_sys:true
		)
		currentCol += 1
		if currentCol >= numPerRow then
		(
			--if currentRow == 2 then exit;
			currentRow += 1
			currentCol = 0
		)
	)
)

fn LoadAllC1LevelTXTFiles dir imp_onlyNonCars:false imp_act:true textfiles:undefined=
(
	if textfiles == undefined then 
		textfiles = getFiles (dir+"*.txt")
	progValue = 0
	progText = ""
	for f in textFiles do
	(
		layerObject = LayerManager.getLayerFromName (getFilenameFile f)
		if layerObject == undefined then
		(
			layerObject= LayerManager.newLayerFromName (getFilenameFile f)
		)
		layerObject.current = true
		LoadC1TXT f &progValue &progText imp_act:imp_act imageExtension:".png" imp_onlyNonCars:imp_onlyNonCars imp_other_coord_sys:true
		
	)
)
fn LoadC2Dat fnm &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true= (

		global smth=#()
		global edv=#()
		global materials=#()
		global materialnames=#()
		global deletemodels=#()
		global accessorymodels=#()
		global tmtab = #()
		global loadedObjects = #()
		
		global aname = undefined
		global atm = undefined
		global abbox = undefined
		global amat = undefined
		global mname = undefined
		rootmesh = undefined
		if fnm==undefined then (
			fnm=getopenfilename types:"Data files(*.dat)|*.dat"
		)
		if (fnm!=undefined)do
		(
			if imp_mat == true do
			(
				global fp=getfilenamepath fnm
				global fm=getfilenamefile fnm
				fe=getfilenametype fnm
				
				tp=fp+"tiffrgb\\"
				
				sessionPaths.add #map tp
				tp2=fp+"tiffrgb\\pixies\\"
				
				sessionPaths.add #map tp2
				splitPath 		= filterstring fp "\\"
				pixPath = ""
				for i=1 to splitPath.count do
				(
					pixPath = pixPath + splitPath[i] + "\\"
					if (toupper splitPath[i]) == "RACES" and splitPath[splitPath.count].count > 4 and doesFileExist (pixPath+ (substring splitPath[splitPath.count] 1 4)+"\\tiffrgb\\pixies\\") then
					(
						sessionPaths.add #map (pixPath+ (substring splitPath[splitPath.count] 1 4)+"\\tiffrgb\\pixies\\")
					)
					if (toupper splitPath[i]) == "RACES" and splitPath[splitPath.count].count > 4 and doesFileExist (pixPath+ (substring splitPath[splitPath.count] 1 4)+"\\tiffrgb\\") then
					(
						sessionPaths.add #map (pixPath+ (substring splitPath[splitPath.count] 1 4)+"\\tiffrgb\\")
					)
					else if (toupper splitPath[i]) == "DATA" and  doesFileExist (pixPath+"Reg\\PIXELMAP\\tiffrgb\\pixies\\") then
					(
						sessionPaths.add #map (pixpath+"Reg\\PIXELMAP\\tiffrgb\\pixies\\")
					)
					else if (toupper splitPath[i]) == "DATA" and  doesFileExist (pixPath+"Reg\\PIXELMAP\\tiffrgb\\") then
					(
						sessionPaths.add #map (pixpath+"Reg\\PIXELMAP\\tiffrgb\\")
					)
					
				)
				
				mln_all = getFiles(fp+"*.mat") --#(fp+fm+".MAT")
				
				
				for mln in mln_all do
				(
					--format "Parsing material: %\n" mln
					if (doesFileExist  mln) == false then
					(
						format "ERROR: can't find material: %\n" mln
						continue
					)
					
					progressText = "status: importing MAT..."
					LoadMATFile mln &progressValue
				)
			)
			
			rootMesh = LoadDATFile fnm &progressValue &progressText imp_smth: imp_smth imp_mat:imp_mat imp_quad:imp_quad imp_scale69:imp_scale69
			
			if imp_act == true do
			(
				fp=getfilenamepath fnm
				fm=getfilenamefile fnm
				
				acn=fp+fm+".ACT"
				act_tree = #()
				if acn!=undefined do
				(
					rootmesh = LoadACTFile acn &progressValue &progressText imp_hier:imp_hier imp_group:imp_group imp_scale69:imp_scale69
				)
			)
			progressText = "import succesfull!"
		)
			globalvars.remove "deletemodels"
			globalvars.remove "smth"
			globalvars.remove "edv"
			globalvars.remove "materials"
			globalvars.remove "materialnames"
			globalvars.remove "deletemodels"
			globalvars.remove "tmtab"
		
			globalvars.remove "aname"
			globalvars.remove "atm"
			globalvars.remove "abbox"
			globalvars.remove "amat"
			globalvars.remove "mname"
			globalvars.remove "loadedObjects"
		gc()
		rootmesh
)
max create mode

rollout datimporter "Import Dat file"
(
	
	group "dat file"
	(
		button dat_file "Locate dat file" width:150 height:30
		button c1level_file "Load C1/SP Level or Car" width:150 height:30
	)
	group "Options"
	(
		checkbox imp_mat "Include MAT:" width:150 checked:true 
		checkbox imp_act "Include ACT:" width:150 checked:true
		checkbox imp_hier "Use hierarchy system:" width:150 checked:true
		checkbox imp_smth "Import smoothing groups." checked:true
		checkbox imp_quad "Polygon import (slower)" checked:true
		checkbox imp_group "Use groups" checked:false
		checkbox imp_scale69 "Scale 6.9" checked:true
	)
	group "progress"
	(
		progressbar imp_prog color:red
		label imp_prog_lab "status:" align:#left
	)
	group "about"
	(
		label lab1 "--Dat importer V19--"
		label lab2 "Modification of Beroc's datconverter"
		label lab3 "by Harmalarm"
	)
	on datimporter open do
	(
		imp_act.checked = true
		imp_mat.checked = true
	)
	
	on dat_file pressed do
	(
		LoadC2Dat undefined  &imp_prog.value &imp_prog_lab.text imp_hier:imp_hier.checked imp_group:imp_group.checked imp_smth:imp_smth.checked imp_mat:imp_mat.checked imp_quad:imp_quad.checked imp_act:imp_act.checked
		
	)
	on c1level_file pressed do
	(
		
		fnm=getopenfilename types:"C1/SP Car or Level Text files(*.txt)|*.txt"
		LoadC1TXT fnm &imp_prog.value &imp_prog_lab.text imp_hier:imp_hier.checked imp_group:imp_group.checked imp_smth:imp_smth.checked imp_mat:imp_mat.checked imp_quad:imp_quad.checked imp_act:imp_act.checked
	)
)

createdialog datimporter 200 330 50 150

