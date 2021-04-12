fn TestC1LevelTexts path = (
	
	files = getFiles (path+"*.txt")
	levelClass = dotnetclass "ToxicRagers.Carmageddon.Formats.Level"
	success = 0
	fail = 0
	for file in files do (
		level = levelClass.Load file
		if level == undefined then (
			fail = fail + 1
		)
		else (
			success = success + 1
		)
	)
	format "Parsing % levels\n\t% success\n% failed\n\n" files.count
)