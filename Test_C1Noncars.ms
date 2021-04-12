fn LoadAllNonCarTXTs = (
	noncarTXTs = getFiles (c1datafolder+"noncars\\*.txt")
	
	noncarClass = dotnetclass "ToxicRagers.Carmageddon.Formats.Noncar"
	noncars = #()
	for noncarTXT in noncarTXTs do (
		noncar = noncarClass.load noncartxt
		format "noncar #% % loaded\n" noncar.Number noncar.Name
		
		append noncars noncar
	)
	
	noncars
)