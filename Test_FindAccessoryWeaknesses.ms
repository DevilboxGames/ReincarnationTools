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