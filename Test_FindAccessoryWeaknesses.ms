fn getFilesRecursive root pattern =
(
dir_array = GetDirectories (root+"/*")
for d in dir_array do
  join dir_array (GetDirectories (d+"/*"))
my_files = #()
for f in dir_array do
  join my_files (getFiles (f + pattern))
my_files
)

fn FindWeaknessesInAccessory filename = (
	f = openfile filename
	seek f #eof
	endOfFile = filePos f
	seek f 0
	weaknesses = #()
	while (filePos f) != endOfFile and (eof f) == false do
	(
		curLine = trimLeft (trimRight (readline f))
		 if (tolower curline) == "weakness" then (
			curLine = trimLeft (trimRight (readline f))
			
			--while curLine == "" and (filePos f) != endOfFile do curLine = trimLeft (trimRight (readline f))
			if (filePos f) != endOfFile then (
				appendIfUnique weaknesses curLine
				curLine = trimLeft (trimRight (readline f))
				if (filePos f) != endOfFile then (
					curLine = trimLeft (trimRight (readline f))
						if (filePos f) != endOfFile then (
						curLine = trimLeft (trimRight (readline f))
							
							if (filePos f) != endOfFile then (
							--while (curLine == "") and (filePos f) != endOfFile do curLine = trimLeft (trimRight (readline f))
								
								if (filePos f) != endOfFile then (
									appendIfUnique weaknesses curLine
								)
							)
						)
				)
			)
		)
	)
	weaknesses
)
fn FindAllWeaknessTypes dataDir:"D:\\Carmageddon Max Damage\\Data_Core\\Content\\" = (
	accessoryTXTs = getFilesRecursive dataDir "accessory.txt"
	weaknesses = #()
	
	for accFile in accessoryTXTs do (
		accWeaknesses = FindWeaknessesInAccessory accFile
		for weakness in accWeaknesses do (
			appendIfUnique weaknesses weakness
		)
	)
	
	for weakness in weaknesses do (
		format "%\n" weakness
	)
)


fn FindCustomTypesInAccessory filename = (
	f = openfile filename
	seek f #eof
	endOfFile = filePos f
	seek f 0
	customTypes = #()
	while (filePos f) != endOfFile and (eof f) == false do
	(
		curLine = trimLeft (trimRight (readline f))
		 if (tolower curline) == "<customaccessorytype>" then (
			curLine = trimLeft (trimRight (readline f))
			while curLine == "" and (filePos f) != endOfFile and (eof f) == false do
			(
				curLine = trimLeft (trimRight (readline f))
			)
			appendIfUnique customTypes curLine
		)
	)
	customTypes
)
fn FindAllCustomTypess dataDir:"D:\\Carmageddon Max Damage\\Data_Core\\Content\\" = (
	accessoryTXTs = getFilesRecursive dataDir "accessory.txt"
	customTypes = #()
	
	for accFile in accessoryTXTs do (
		accCustomTypes = FindCustomTypesInAccessory accFile
		for customType in accCustomTypes do (
			appendIfUnique customTypes customType
		)
	)
	
	for customType in customTypes do (
		format "%\n" customType
	)
)


fn FindShapeTypesInAccessory filename = (
	f = openfile filename
	seek f #eof
	endOfFile = filePos f
	seek f 0
	shapeTypes = #()
	collisonGroups = #()
	while (filePos f) != endOfFile and (eof f) == false do
	(
		curLine = trimLeft (trimRight (readline f))

		 if (tolower curline) == "<shape>" then (

			shapeName = trimLeft (trimRight (readline f))

				while shapeName == "" and (filePos f) != endOfFile and (eof f) == false do
				(
					shapeName = trimLeft (trimRight (readline f))
				)
			if shapeName != "(no_shape)" then (
				curLine = trimLeft (trimRight (readline f))
				while curLine == "" and (filePos f) != endOfFile and (eof f) == false do
				(
					curLine = trimLeft (trimRight (readline f))
				)

				numShapes = curLine as integer
				--format "% shapes to parse\n" curLine
				for i = 1 to numShapes do (
					--format "\tParsing shaoetype: "
					skippedLines = 0
					curLine = trimLeft (trimRight (readline f))
					while curLine == "" and (filePos f) != endOfFile and (eof f) == false do
					(
						skippedLines = skippedLines + 1
						curLine = trimLeft (trimRight (readline f))
					)
					--format "% (skipped % lines)\n" curLine skippedLines
					appendIfUnique shapeTypes curLine
					
					--format "\tSkipping "
					skippedLines = 0
					lastlinestart = filepos f
					curLine = trimLeft (trimRight (readline f))
					--skippedLinesData = stringstream ""
					while (curLine == "" or ((filterstring curLine ", ")[1] as integer) != undefined or curLine[1] == "-" ) and (filePos f) != endOfFile and (eof f) == false do
					(
					lastlinestart = filepos f
						skippedLines = skippedLines + 1
					  -- format "\t\t%:\t%\n" skippedLines curLine
						curLine = trimLeft (trimRight (readline f))
					)
					--format "% lines of data & blank lines\n" skippedLines
					if curLine == "form_collision_groups" then (
						--format "\tFound collisonGroups (#"
						curLine = trimLeft (trimRight (readline f))
						--format "%)\n" curLine
						appendIfUnique collisonGroups curLine
					)
					else if i < numShapes then (
						--format "stepping back % lines\n" curLine.count
						seek f lastlinestart
					)
				)
			)

		)
	)
	#(shapeTypes, collisonGroups)
)
fn FindAllShapeTypes dataDir:"D:\\Carmageddon Max Damage\\Data_Core\\Content\\" = (
	accessoryTXTs = getFilesRecursive dataDir "accessory.txt"
	shapeTypes = #()
	collisionGroups = #()
	
	for accFile in accessoryTXTs do (
		shapeDetails = FindShapeTypesInAccessory accFile
		for shapeType in shapeDetails[1] do (
			appendIfUnique shapeTypes shapeType
		)
		for collisionGroup in shapeDetails[2] do (
			appendIfUnique collisionGroups collisionGroup
		)
	)
	
	format "Collision shaped:\n"
	for shapeType in shapeTypes do (
		format "\t%\n" shapeType
	)
	format "Collision griups:\n"
	for collisionGroup in collisionGroups do (
		format "\t%\n" collisionGroup
	)
)