
	stopwatch = dotNetObject "system.diagnostics.stopwatch"
	frequency = stopwatch.frequency
	nanosecspertick = (1000 * 1000 * 1000) / frequency
	stopwatch.start()
	
	t =1
	for i = 1 to 10000 do
	(
		t = t + 1
	)
	stopwatch.stop()
	stopwatch.reset()
	stopwatch.start()
	format "%\n" stopwatch.ElapsedMilliseconds
	t =1
	for i = 1 to 10000 do
	(
		t = t + 1
	
		for j = 1 to 10000 do
		(
			t = t + 1
		)
	)
	
	stopwatch.stop()
	format "%\n" stopwatch.ElapsedMilliseconds