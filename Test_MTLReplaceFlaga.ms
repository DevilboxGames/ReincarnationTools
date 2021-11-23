fn makeAllMTLsPixelated dir = (
	local mtls = (dotnetclass "System.IO.Directory").GetFiles dir "*.mtl" (dotnetclass "System.IO.SearchOption").AllDirectories
	local mtlCount = 0
	for mtlpath in mtls do (
		mtl = mtlfile()
		mtl.Load mtlpath
		mtl.saveflags = bit.set (bit.set mtl.saveflags 30 false) 26 false
		mtl.Save mtlpath
		mtlCount += 1
	)
	format "% mtls processed\n" mtlCount
)