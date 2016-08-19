for obj in objects do
(
	select obj
	curTime = 0f
	at time curTime nextFrame = trackbar.GetNextKeyTime()
	at time curTime lastFrame = trackbar.GetPreviousKeyTime()
	
	if nextFrame == undefined do continue
	format "\nObject: %\nNext Time: %\nLast Time: %\n" obj.name nextFrame.frame lastFrame.frame
	while curTime.frame <= lastFrame.frame and nextFrame.frame > curTime.frame do
	(
		timeinsecond = curtime.frame * frameRate
		at time curTime format "\t% / %s: pos = %\t\t rot = %\n" curtime.frame timeinsecond obj.pos obj.rotation
		curTime = nextFrame
		at time curTime nextFrame = trackbar.GetNextKeyTime()
		
		
	)
)