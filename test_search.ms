
	fn searchfn targetval val = (
	
		if targetval[1] > val then -1
		else if targetval[1] < val then 1
		else 0
	)
fn dossearchtest = (
	stopwatch = dotNetObject "system.diagnostics.stopwatch"
	frequency = stopwatch.frequency
	nanosecspertick = (1000 * 1000 * 1000) / frequency
	stopwatch.start()
	
	
	format "smaller: %\n" (searchfn #(10001) 100)
	format "equal: %\n" (searchfn #(10001) 10001)
	format "bigger: %\n" (searchfn #(10001) 100001)
	
	arr = for i =1 to 100000 collect (i as string) -- ((random 0 10000) as string)
	arr[687] = "10001"
	foundindex = undefined
	foundval = bsearch #("10001") arr searchfn index:&foundindex
	stopwatch.stop()
	format "found index % in %ms\n" foundindex stopwatch.ElapsedMilliseconds
	
	stopwatch.reset()
	stopwatch.start()
	for i = 1 to arr.count do (
		if arr[i] == "10001" then (
			foundindex = i
			i=arr.count + 1
			
		)
	)
	stopwatch.stop()
	format "found index % in %ms\n" foundindex stopwatch.ElapsedMilliseconds
)
dossearchtest()
