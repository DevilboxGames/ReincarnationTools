fn tstgas = (
	
	f = openfile "D:\\Steam\\steamapps\\common\\Carmageddon Max Damage\\Data_Core\\Content\\Levels\\C1CityA\\Accessories\\00GAS\\accessory.txt" mode:"r"
	seek f 243
	format "1 - %\n" (ReadNonBlankLine f)
	seek f 243
	format "1 - %\n" (ReadNonBlankLine f)
	seek f 243
	format "1 - %\n" (ReadNonBlankLine f)
	format "2 - %\n" (ReadNonBlankLine f)
	format "3 - %\n" (ReadNonBlankLine f)
	seek f 243
	format "1 - %\n" (ReadNonBlankLine f)
	format "2 - %\n" (ReadNonBlankLine f)
	format "3 - %\n" (ReadNonBlankLine f)
	fclose f
)
fn tstgas2 = (
	f = dotnetobject "ToxicRagers.Carmageddon.Helpers.DocumentParser" "D:\\Steam\\steamapps\\common\\Carmageddon Max Damage\\Data_Core\\Content\\Levels\\C1CityA\\Accessories\\00GAS\\accessory.txt"
	f.seek 243
	format "1 - %\n" (f.readline())
	f.seek 243
	format "1 - %\n" (f.readline())
	f.seek 243
	format "1 - %\n" (f.readline())
	format "2 - %\n" (f.readline())
	format "3 - %\n" (f.readline())
	f.seek 243
	format "1 - %\n" (f.readline())
	format "2 - %\n" (f.readline())
	format "3 - %\n" (f.readline())
	
)
tstgas()
tstgas2()