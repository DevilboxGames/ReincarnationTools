fn tstgas = (
	
	f = openfile "D:\\Steam\\steamapps\\common\\Carmageddon Max Damage\\Data_Core\\Content\\Levels\\C1CityA\\Accessories\\00GAS\\accessory.txt" mode:"r"
	seek f 243
	format "1 - %\n" (readline f)
	seek f 243
	format "1 - %\n" (readline f)
	seek f 243
	format "1 - %\n" (readline f)
	format "2 - %\n" (readline f)
	format "3 - %\n" (readline f)
	seek f 243
	format "1 - %\n" (readline f)
	format "2 - %\n" (readline f)
	format "3 - %\n" (readline f)
	fclose f
)
fn tstgas2 = (
	f = dotnetobject "ToxicRagers.Carmageddon.Helpers.DocumentParser"
	
)
tstgas()