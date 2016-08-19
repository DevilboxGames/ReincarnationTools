struct PedType (Bodyform, Type, BaseBodyTexture, BodyTexture, Weight)

fn GetPedTypesFromLol fileName =
(
	lolScript = (DecodeLOLFile fileName) as StringStream

	bodyform = "template"
	ReadingVariations = false
	ReadingBodyVariations = false
	ReadingNonBodyVariations = false
	ReadingParameters = false
	DoingAVariation = false
	BaseBodyTextureSet = false
	BaseBodyTexture = ""
	Variations = #()
	currentVariation = undefined

		splitDir = filterstring fileName "\\/."
		pedName = splitDir[splitDir.count-1]
	while (eof lolscript) == false do
	(
		curLine = trimright (trimleft (readline lolscript))
		if(curLine == "") then continue
		splitLine = filterString curline " ="
		case (toLower splitLine[1]) of
		(
			"parameters.bodyformname":
			(
				bodyform = (filterstring splitLine[2] "\",")[1]
			)
			"parameters":
			(
				if ReadingVariations == false then ReadingParameters = true
			)
			"bodyformname":
			(
				if ReadingParameters then bodyform = (filterstring splitLine[2] "\",")[1]
			)
			"variations":
			(
				ReadingVariations = true
				ReadingBodyVariations = false
				DoingAVariation = false
			)
			"body":
			(
				if ReadingVariations then
				(
					ReadingBodyVariations = true
					BaseBodyTextureSet = false
					BaseBodyTexture=""
				)
			)
			"{":
			(
				if ReadingVariations and ReadingBodyVariations then
				(
					DoingAVariation = true

					currentVariation = PedType Bodyform:bodyform Type:(bodyform+"\\"+pedName) BodyTexture:"" BaseBodyTexture:BaseBodyTexture Weight:1
				)
				else if ReadingVariations and ReadingNonBodyVariations then
				(
					DoingAVariation = true

				)
			)
			"name":
			(

				if ReadingBodyVariations and DoingAVariation then
				(
					currentVariation.BodyTexture = (filterstring splitLine[2] "\",")[1]
					if BaseBodyTextureSet == false then
					(
						BaseBodyTexture = currentVariation.BodyTexture
						currentVariation.BaseBodyTexture = BaseBodyTexture
						BaseBodyTextureSet = true
					)
				)
			)
			"weight":
			(

				if ReadingBodyVariations and DoingAVariation then
				(
					currentVariation.Weight = (filterstring splitLine[2] "\",")[1]
				)
			)
			"},":
			(
				if ReadingParameters then
				(
					ReadingParameters = false
				)
				else if DoingAVariation and ReadingBodyVariations then
				(
					DoingAVariation = false
					if currentVariation != undefined and (currentVariation.Weight == undefined or currentVariation.Weight != "0") then append Variations currentVariation
					free currentVariation
					currentVariation = undefined
				)
				else if DoingAVariation and ReadingNonBodyVariations then
				(
					DoingAVariation = false
				)
				else if ReadingBodyVariations then
				(
					ReadingBodyVariations = false
				)
				else if ReadingNonBodyVariations then
				(
					ReadingNonBodyVariations = false
				)
				else if ReadingVariations then
				(
					ReadingVariations = false
				)
			)
			"}":
			(
				if ReadingParameters then
				(
					ReadingParameters = false
				)
				else if DoingAVariation and ReadingBodyVariations then
				(
					DoingAVariation = false
					if currentVariation != undefined and (currentVariation.Weight == undefined or currentVariation.Weight != "0") then append Variations currentVariation
					free currentVariation
					currentVariation = undefined
				)
				else if DoingAVariation and ReadingNonBodyVariations then
				(
					DoingAVariation = false
				)
				else if ReadingBodyVariations then
				(
					ReadingBodyVariations = false
				)
				else if ReadingNonBodyVariations then
				(
					ReadingNonBodyVariations = false
				)
				else if ReadingVariations then
				(
					ReadingVariations = false
				)
			)
			default:
			(
				if ReadingVariations then
				(
					if splitLine[2] == "{" then ReadingNonBodyVariations = true
				)
			)
		)
	)
	if Variations.count == 0 then
	(
		append Variations (PedType Bodyform:bodyform Type:pedName BodyTexture:"" BaseBodyTexture:"")
	)
	return Variations
)
fn CollectAllTypes filter:""=
(
	PedsTypesFolder = CarmaSettings.DataCorePath+"\\Content\\Peds\\Types\\"

	PedTypesDirsList = getDirectories(PedsTypesFolder+"*")
	PedTypes = #()
	for i=1 to PedTypesDirsList.count do
	(
		pedTypeScripts = getFiles(PedTypesDirsList[i]+"*.lol")
		for j=1 to pedTypeScripts.count do
		(
			PedTypes = PedTypes + (GetPedTypesFromLol pedTypeScripts[j])
		)
	)
	pedTypeScripts = getFiles(PedsTypesFolder+"*.lol")
	for j=1 to pedTypeScripts.count do
	(
		PedTypes = PedTypes +(GetPedTypesFromLol pedTypeScripts[j])
	)

		if filter != "" then
		(
			numTypes = PedTypes.count
			newTypes = #()
			for i=1 to PedTypes.count do
			(
				if (matchPattern PedTypes[i].Bodyform pattern:(filter)) then
				(
					append newTypes PedTypes[i]
				)
			)
			return newTypes
		)
	return PedTypes
)



fn ImportAllPeds MaxPeds:16 StartPeds: 0 filter:""=
(
	PedsFolder = CarmaSettings.DataCorePath+"\\Content\\Peds\\Bodyforms\\"
	PedDirsList = getDirectories(PedsFolder+"*")
	Bodyforms = #()

	for i=1 to PedDirsList.count do
	(
		
		if (dotnetclass "System.IO.File").exists (PedDirsList[i]+"bodyform.cnt") then
		(

			append Bodyforms PedDirsList[i]
		)
	)

	PedTypes = CollectAllTypes filter:filter
	NumPeds = PedTypes.count - StartPeds
	if MaxPeds > 0 and  NumPeds > MaxPeds then
	(
		NumPeds = MaxPeds
	)
	if NumPeds + StartPeds > PedTypes.Count then
	(
		NumPeds = PedTypes.Count - StartPeds

	)

	NumPedsPerRow = ceil (sqrt NumPeds)
	PedSize = [3,3]
	StartPos = [-PedSize.x * (NumPedsPerRow * 0.5) + (PedSize.x * 0.5), 0, PedSize.y * (NumPedsPerRow * 0.5) - (PedSize.y * 0.5)]
	
	CurCol = 0
	CurRow = 0

	--PrintArrayInFull PedsList "PedsList"

	for i=(StartPeds+1) to NumPeds + StartPeds do
	(
		
		Pos = [StartPos.x + CurCol * PedSize.x, 0, StartPos.y - CurRow * PedSize.y]
		pedMesh = ImportCNT (PedsFolder+PedTypes[i].Bodyform+"\\bodyform.cnt") importTextures:true forcePREP:true origin:Pos
		if PedTypes[i].BaseBodyTexture != "" then
		(
			if classof pedMesh.material == multimaterial then
			(
				newMat = multimaterial numsubs:pedMesh.material.materiallist.count
				for j=1 to pedMesh.material.materiallist.count do
				(
					if pedMesh.material.materiallist[j].name == PedTypes[i].BaseBodyTexture then
					(
						texmap = GetMDLTexture (PedsFolder+PedTypes[i].Bodyform+"\\") PedTypes[i].BodyTexture importTextures:true

						subMat = StandardMaterial()
						subMat.shaderType = 1

						
						--format "\nAbout To Call GetMDLTexture for %\n" materialName
						subMat.diffuseMap = texmap
						--format "Just Called GetMDLTexture for \n\n" materialName
						subMat.name = PedTypes[i].BodyTexture
						showtexturemap subMat subMat.diffuseMap true
						newMat[j] = submat
					)
					else newMat[j] = pedMesh.material[j]
				)
				pedMesh.material = newMat
			)
			else if pedMesh.material.name == PedTypes[i].BaseBodyTexture then 
			(
				texmap = GetMDLTexture (PedsFolder+PedTypes[i].Bodyform+"\\") PedTypes[i].BodyTexture importTextures:true
				subMat = StandardMaterial()
				subMat.shaderType = 1

				
				--format "\nAbout To Call GetMDLTexture for %\n" materialName
				subMat.diffuseMap = texmap
				--format "Just Called GetMDLTexture for \n\n" materialName
				subMat.name = PedTypes[i].BodyTexture
				showtexturemap subMat subMat.diffuseMap true
				
				pedMesh.material = submat
			)
		)

		pedName = PedTypes[i].Type
		
		pedText = text text:pedName size: 0.2 alignment:2
		pedText.rotation = eulerToQuat (eulerAngles -90 0 0)
		pedText.pos = [Pos.x, 0, Pos.z - 0.15] 
		addModifier pedText (Extrude amount:0.02)

		CurCol = CurCol + 1
		if CurCol >= NumPedsPerRow then
		(
			CurCol = 0
			CurRow = CurRow + 1
		)
		
	)
)