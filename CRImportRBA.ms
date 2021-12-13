
struct  RBAFramePos
(
	Time,
	Pos1,
	Pos2,
	Pos3
)
struct RBAPositionalTrack
(
	NumFrames,
	Frames=#()
)
struct  RBAFrameRot
(
	Time,
	F,
	Rot1,
	Rot2,
	Rot3,
	F2,
	F3
)
struct RBARotationalTrack
(
	NumFrames,
	Frames=#()
)
struct RBAObject
(
	Name,
	PositionalTrack,
	RotationalTrack
)
struct RBAFile
(
	MinorVersion,
	MajorVersion,
	Unknown,
	AnimLength,
	NumObjects,
	RBAObjects=#(),
	fn SaveRBA file =
	(
		f = fopen file "w"
		
		writebyte f MinorVersion
		writebyte f MajorVersion
		writeshort f Unknown
		writefloat f AnimLength
		writelong f RBAObjects.count
		for i=1 to RBAObjects.count do
		(
			posTrack = RBAObjects[i].PositionalTrack
			rotTrack = RBAObjects[i].RotationalTrack
			writeshort f 1
			writeshort f 2
			if posTrack.Frames.count < 1 then
				append posTrack.Frames (RBAFramePos Time:0 Pos1:[0,0,0] Pos2:[0,0,0] Pos3:[0,0,0])
			writeshort f posTrack.Frames.count
			
			for n=1 to posTrack.Frames.count do
			(
				writefloat f posTrack.Frames[n].Time
				pos1 = ConvertToCRSpace posTrack.Frames[n].Pos1
				pos2 = ConvertToCRSpace posTrack.Frames[n].Pos2
				pos3 = ConvertToCRSpace posTrack.Frames[n].Pos3
				writefloat f pos1.x
				writefloat f Pos1.y
				writefloat f Pos1.z
				writefloat f pos2.x
				writefloat f Pos2.y
				writefloat f pos2.z
				writefloat f pos3.x
				writefloat f pos3.y
				writefloat f pos3.z
			)
			writeshort f 2
			writeshort f 3
			if rotTrack.Frames.count < 1 then
				append rotTrack.Frames (RBAFrameRot Time:0 F:0 F2:0 F3:0 Rot1: (quat 0 [1,0,0]) Rot2: (quat 0 [1,0,0]) Rot3: (quat 0 [1,0,0]))
			writeshort f rotTrack.Frames.count
			
			for n=1 to rotTrack.Frames.count do
			(
				writefloat f rotTrack.Frames[n].Time
				writefloat f rotTrack.Frames[n].F
				
				v2 = quat rotTrack.Frames[n].Rot1.x -rotTrack.Frames[n].Rot1.z rotTrack.Frames[n].Rot1.y rotTrack.Frames[n].Rot1.w
				v3 = quat rotTrack.Frames[n].Rot2.x -rotTrack.Frames[n].Rot2.z rotTrack.Frames[n].Rot2.y rotTrack.Frames[n].Rot2.w
				v4 = quat rotTrack.Frames[n].Rot3.x -rotTrack.Frames[n].Rot3.z rotTrack.Frames[n].Rot3.y rotTrack.Frames[n].Rot3.w
				writefloat f V2.x
				writefloat f V2.y
				writefloat f V2.z
				writefloat f V2.w
				
				writefloat f V3.x
				writefloat f V3.y
				writefloat f V3.z
				writefloat f V3.w
				
				writefloat f V4.x
				writefloat f V4.y
				writefloat f V4.z
				writefloat f V4.w

				writefloat f rotTrack.Frames[n].F2
				writefloat f rotTrack.Frames[n].F3
			)
			writeshort f 0
		)
		writelong f RBAObjects.count
		for i=1 to RBAObjects.count do
		(
			writestring2 f RBAObjects[i].name
			for x=RBAObjects[i].name.count to 31 do
			(
				writebyte f 0
			)
		)
		fclose f
	),
	fn SaveAs =
	(

	rba_name = GetSaveFileName caption:"Save RBA File" types:"RBA(*.RBA)|*.rba"
		if rba_name != undefined do
		(
			SaveRBA rba_name
		)
	)
)

fn PrintRBA rba =
(
	format "Version: %.%\nUnknown: %\AnimLength: %\nNumObjects: %\n\n" rba.MajorVersion rba.MinorVersion rba.Unknown rba.AnimLength rba.NumObjects
	for obj in rba.RBAObjects do
	(
		format "\"%\":\n" obj.Name
		format "Position Frames: %\n" obj.PositionalTrack.NumFrames
		for fr in obj.PositionalTrack.Frames do
		(
			format "\tTime: %\n\t%\n\t%\n\t%\n\n" fr.Time fr.Pos1 fr.Pos2 fr.Pos3
		)
		format "Rotation Frames: %\n" obj.RotationalTrack.NumFrames
		for fr in obj.RotationalTrack.Frames do
		(
			format "\tTime: %\n\t%\n\t%\n\t%\n\t%, %, %\n\n" fr.Time fr.Rot1 fr.Rot2 fr.Rot3 fr.F fr.F2 fr.F3 
		)
	)
)
fn CreateRBAObjects obj =
(
	RBAObjects = #()
	select obj
	curTime = 0f
	
	at time curTime nextFrame = trackbar.GetNextKeyTime()
	if nextFrame == undefined then
	(
		at time -1 curtime = trackbar.GetNextKeyTime()
	)
	if curTime == undefined then
	(
		format "\n----\n\t% has no key frames\n" obj.name
	)
	if curTime != undefined then
	(
		at time curTime nextFrame = trackbar.GetNextKeyTime()
		at time curTime lastFrame = trackbar.GetPreviousKeyTime()
			
		rbaObj = RBAObject Name:obj.name PositionalTrack:(RBAPositionalTrack()) RotationalTrack:(RBARotationalTrack())
		
		posframes = #()
		rotFrames = #()
		--format "\n----\nMaking RBA Object for: \"%\"\n" obj.name
		if nextFrame != undefined then
		(
			at time nextFrame prevFrame = trackbar.GetPreviousKeyTime()
			if prevFrame.frame > curTime.frame then prevFrame = curTime
			--format "% <= % and % >= %\n" curtime.frame lastFrame.frame curtime.frame prevFrame.frame
			while curTime.frame <= lastFrame.frame and curTime.frame >= prevFrame.frame do
			(
				timeinseconds = curtime.frame / frameRate
				in coordsys parent
				(
					at time curTime append posFrames (RBAFramePos Time:timeinseconds Pos1: obj.pos Pos2: [0,0,0] Pos3: [0,0,0])
				)
				in coordsys parent 
				(
					at time curTime rot = obj.rotation
					if rotframes.count > 0 then
					(
						prevRot = rotFrames[rotframes.count].rot1
						if (quatdot rot prevrot) < 0 then  rot = -rot
					)
					append rotFrames (RBAFrameRot Time:timeinseconds Rot1: rot F:0 F2:0 F3:0 Rot2: rot Rot3: rot)
				)
				--format "\t% / %s: " curtime timeinseconds
				--at time curTime format "pos = %\t\t rot = %\n" obj.pos obj.rotation
				curTime = nextFrame
				at time curTime prevFrame = trackbar.GetPreviousKeyTime()
				at time curTime nextFrame = trackbar.GetNextKeyTime()
			)
		)
		else
		(
			--format "% only has 1 key frame\n" obj.name
				timeinseconds = 0
				in coordsys parent
				(
					at time curTime append posFrames (RBAFramePos Time:timeinseconds Pos1: obj.pos Pos2: [0,0,0] Pos3: [0,0,0])
				)
				in coordsys parent 
				(
					at time curTime append rotFrames (RBAFrameRot Time:timeinseconds Rot1: (obj.rotation) F:0 F2:0 F3:0 Rot2: obj.rotation Rot3: obj.rotation)
				)
		)
		--format "\tPos Frames: %\n\tRot Frames: %\n" posFrames.count rotFrames.count
		for i=1 to posFrames.count do
		(
			prevRBAFrame = undefined
			nextRBAFrame = undefined
			crntRBAFrame = posFrames[i]

			if i == 1 then prevRBAFrame = posFrames[posFrames.count]
			else prevRBAFrame = posFrames[i-1]

			if i==posFrames.count then nextRBAFrame = posFrames[1]
			else nextRBAFrame = posFrames[i+1]
			if prevRBAFrame.Pos1 != crntRBAFrame.Pos1 then
			(
				if abs (prevRBAFrame.Pos1.x - crntRBAFrame.Pos1.x) < 1.0e-6 then crntRBAFrame.Pos1.x = prevRBAFrame.Pos1.x
				if abs (prevRBAFrame.Pos1.y - crntRBAFrame.Pos1.Y) < 1.0e-6 then crntRBAFrame.Pos1.y = prevRBAFrame.Pos1.y
				if abs (prevRBAFrame.Pos1.z - crntRBAFrame.Pos1.z) < 1.0e-6 then crntRBAFrame.Pos1.z = prevRBAFrame.Pos1.z
			)
			if nextRBAFrame.Pos1 != crntRBAFrame.Pos1 then
			(
				if abs (crntRBAFrame.Pos1.x - nextRBAFrame.Pos1.x) < 1.0e-6 then nextRBAFrame.Pos1.x = crntRBAFrame.Pos1.x
				if abs (crntRBAFrame.Pos1.y - nextRBAFrame.Pos1.y) < 1.0e-6 then nextRBAFrame.Pos1.y = crntRBAFrame.Pos1.y
				if abs (crntRBAFrame.Pos1.z - nextRBAFrame.Pos1.z) < 1.0e-6 then nextRBAFrame.Pos1.z = crntRBAFrame.Pos1.z
			)

			if i == 1 then crntRBAFrame.Time = 0
			if i == 1 or i == posFrames.count then
			(
				--format "%:\tPos1: % - LerpPos: %" i crntRBAFrame.Pos1 "[none]"
				if i== 1 or posFrames.count > 1 then
				(
					append rbaObj.PositionalTrack.Frames crntRBAFrame
					--format " (appended)"
				)
				--format "\n"
			)
			else if crntRBAFrame.Pos1 != prevRBAFrame.Pos1 and crntRBAFrame.pos1 != nextRBAFrame.pos1 then
			(
				lerpPos = prevRBAFrame.Pos1 + (nextRBAFrame.pos1 - prevRBAFrame.Pos1) * ( (crntRBAFrame.Time - prevRBAFrame.Time) / (nextRBAFrame.Time - prevRBAFrame.Time))
				--format "%:\tPos1: % - LerpPos: %" i crntRBAFrame.Pos1 lerpPos
				if lerpPos != crntRBAFrame.Pos1 then
				(
					append rbaObj.PositionalTrack.Frames crntRBAFrame
					--format " (appended)"
				)
				--format "\n"
			)
		)
		for i = 1 to rbaObj.PositionalTrack.Frames.count do
		(
			prevRBAFrame = undefined
			nextRBAFrame = undefined
			crntRBAFrame = rbaObj.PositionalTrack.Frames[i]

			if i == 1 then 
			(
				prevRBAFrame = rbaObj.PositionalTrack.Frames[rbaObj.PositionalTrack.Frames.count]

			)
			else prevRBAFrame = rbaObj.PositionalTrack.Frames[i-1]

			if i==rbaObj.PositionalTrack.Frames.count then nextRBAFrame = rbaObj.PositionalTrack.Frames[1]
			else nextRBAFrame = rbaObj.PositionalTrack.Frames[i+1]

			crntRBAFrame.Pos2 = crntRBAFrame.Pos1 - prevRBAFrame.Pos1
			crntRBAFrame.Pos3 = nextRBAFrame.Pos1 - crntRBAFrame.Pos1

		)
		for i=1 to rotFrames.count do
		(
			prevRBAFrame = undefined
			nextRBAFrame = undefined
			crntRBAFrame = rotFrames[i]

			if i == 1 then prevRBAFrame = rotFrames[rotFrames.count]
			else prevRBAFrame = rotFrames[i-1]

			if i==rotFrames.count then nextRBAFrame = rotFrames[1]
			else nextRBAFrame = rotFrames[i+1]
			/*if (quatdot prevRBAFrame.rot1 crntRBAFrame.rot1) < 0 then 
			(
				format "Frame % (%) of % is inverse (%)\n" i crntRBAFrame.time obj.name (quatdot prevRBAFrame.rot1 crntRBAFrame.rot1)
				crntRBAFrame.rot1 = -crntRBAFrame.rot1
				crntRBAFrame.rot2 = -crntRBAFrame.rot2
				crntRBAFrame.rot3 = -crntRBAFrame.rot3
			)*/
			if i == 1 then crntRBAFrame.Time = 0
			if i == 1 or i == rotFrames.count then
			(
				--format "%:\tRot1: % - LerpPos: %" i crntRBAFrame.Rot1 "[none]"
				if i== 1 or rbaObj.RotationalTrack.Frames.count > 1 then
				(
					append rbaObj.RotationalTrack.Frames crntRBAFrame
					--format " (appended)"
				)
				--format "\n"
			)
			else -- if crntRBAFrame.Rot1 != prevRBAFrame.Rot1 and crntRBAFrame.Rot1 != nextRBAFrame.Rot1 then
			(
				lerpPos = slerp prevRBAFrame.Rot1 nextRBAFrame.Rot1 ( (crntRBAFrame.Time - prevRBAFrame.Time) / (nextRBAFrame.Time - prevRBAFrame.Time))
				--format "%:\tRot1: % - LerpPos: %" i crntRBAFrame.Rot1 lerpPos
				--if lerpPos != crntRBAFrame.Rot1  then
				(
					append rbaObj.RotationalTrack.Frames crntRBAFrame
					--format " (appended)"
				)
				--format "\n"
			)
		)
		--format "Pos Frames: %\n" rbaObj.PositionalTrack.Frames.count
		--for fr in rbaObj.PositionalTrack.Frames do
		(
			--format "\t%: %\n" fr.time fr.pos1
		)
		--format "Rot Frames:%\n" rbaObj.RotationalTrack.Frames.count
		--for fr in rbaObj.RotationalTrack.Frames do
		(
			--format "\t%: %\n" fr.time fr.Rot1
		)
		rbaobj.RotationalTrack.NumFrames = rbaobj.RotationalTrack.Frames.count
		rbaobj.PositionalTrack.NumFrames = rbaobj.PositionalTrack.Frames.count
		if rbaobj.PositionalTrack.Frames.Count >= 1 or  rbaobj.RotationalTrack.Frames.Count >= 1 then append RBAObjects rbaobj
	)
	for child in obj.children do
	(
		join RBAObjects (CreateRBAObjects child)
	)
	RBAObjects
)
fn ApplyRBA rbaobj suffix:""=
(
	animationrange = interval 0 ((rbaobj.animlength as integer) * frameRate)
	for obj in rbaobj.rbaobjects do
	(
		node = getNodeByName2 (obj.name+suffix)
		if node == undefined then 
		(
			format "node \"%\" not found\n" obj.name
			continue
		)
		
		originalTM = node.transform
		with animate on 
		(
			firstFrame = true
			for posframe in obj.PositionalTrack.Frames do
			(
				if firstFrame then in coordsys parent node.pos = posframe.pos1
				in coordsys parent at time (posframe.time * frameRate) node.pos = posframe.pos1
				firstFrame = false
			)
			firstFrame = true
			local prevFrame = undefined
			local q = undefined
			for rotframe in obj.RotationalTrack.Frames do
			(
				local prevQ = undefined
				local q = rotframe.Rot1 --quat rotframe.V2.w rotframe.V2.z rotframe.V2.y rotframe.V2.x
				local frameTime = (rotframe.time * frameRate)
				local prevframeTime = undefined
				--oldPos = node.pos
				
				
					if firstFrame == false then (
						prevQ = prevFrame.Rot1
						prevframeTime = (prevFrame.time * frameRate)
						at time (lerp prevFrameTime frameTime 0.5)
						(
							oldPosAnim = node.pos

							in coordsys parent node.rotation = slerp prevQ q 0.5
							
							node.pos = oldPosAnim
					 	)
					)
					--if firstFrame then node.rotation = q
					at time frameTime
					(
						oldPosAnim = node.pos

						
						in coordsys parent node.rotation = q
						
						 node.pos = oldPosAnim
				 	)
				
				--node.pos = oldPos
				--node.rotation = q * node.parent.rotation 
				firstFrame=false
				prevFrame = rotFrame
			)
		)
	)
)

fn CreateRBA =
(
	rba = RBAFile MinorVersion:0 MajorVersion:3 Unknown:0 AnimLength:0 NumObjects:0
	selectedObjects = for obj in $ collect obj
	format "creating RBA from % objects\n" selectedObjects.count
	selectedObj = $
	rba.RBAObjects = CreateRBAObjects $
	select selectedObj
	rba.NumObjects = rba.RBAObjects.count
	AnimLength = 0.0
	for obj in rba.RBAObjects do
	(
		if obj.PositionalTrack.Frames[obj.PositionalTrack.Frames.count].Time > AnimLength then AnimLength = obj.PositionalTrack.Frames[obj.PositionalTrack.Frames.count].Time
		if obj.RotationalTrack.Frames[obj.RotationalTrack.Frames.count].Time > AnimLength then AnimLength = obj.RotationalTrack.Frames[obj.RotationalTrack.Frames.count].Time
	)
	rba.AnimLength = AnimLength
	return rba
)
fn ImportRBA file =
(
	f = fopen file "r"

	minorversion = readbyte f
	majorversion = readbyte f
	pad = readshort f
	AnimLength = readfloat f
	numObjects = readlong f #unsigned

	rba = RBAFile MinorVersion:minorVersion MajorVersion:majorVersion Unknown:pad AnimLength:AnimLength NumObjects:numObjects
	for i=1 to numObjects do
	(
		a = readshort f #unsigned
		b = readshort f #unsigned
		c = readshort f #unsigned

		obj = RBAObject name:(i as string)
		obj.PositionalTrack = RBAPositionalTrack NumFrames:c

		for n = 1 to c do
		(
			
			if a == 1 and b == 2 then
			(
				t = readfloat f
				r1 = ConvertFromCRSpace [readfloat f, readfloat f, readfloat f]
				r2 = ConvertFromCRSpace [readfloat f, readfloat f, readfloat f]
				r3 = ConvertFromCRSpace [readfloat f, readfloat f, readfloat f]
				frame = RBAFramePos Time: t Pos1:r1 Pos2:r2 Pos3:r3
				append obj.PositionalTrack.Frames frame
			)
		)
		a = readshort f #unsigned
		b = readshort f #unsigned
		c = readshort f #unsigned


		obj.RotationalTrack = RBARotationalTrack NumFrames:c
		for n = 1 to c do
		(
			

			if a == 2 and b == 3 then
			(
				t = readfloat f
				f1= readfloat f
				x = (readfloat f)
				y = (readfloat f)
				z = (readfloat f)
				w = (readfloat f)
				r2 = ( Quat x z -y w)
				x = (readfloat f)
				y = (readfloat f)
				z = (readfloat f)
				w = (readfloat f)
				r3 = (Quat x z -y w)
				x = (readfloat f)
				y = (readfloat f)
				z = (readfloat f)
				w = (readfloat f)
				r4 =  ( Quat x z -y w)
				f2 = readfloat f
				f3 = readfloat f
				--r5 = [readfloat f, readfloat f, readfloat f]
				frame = RBAFrameRot Time: t F:f1 Rot1:r2 Rot2:r3 Rot3:r4 F2: f2 F3: f3
				append obj.RotationalTrack.Frames frame
			)
		)
		readshort f
		append rba.RBAObjects obj
	)
	numObjects2 = readlong f #unsigned
	
	for i=1 to numObjects2 do
	(
		rba.RBAObjects[i].Name = readstring2 f 32
		format "\t%: % (%)\n" i rba.RBAObjects[i].Name rba.RBAObjects[i].Name.count
		for posFrame in rba.RBAObjects[i].PositionalTrack.Frames do (
			format "\t\t%: [%,%,%] - [%,%,%] - [%,%,%]\n" posFrame.Time posFrame.Pos1.x posFrame.Pos1.y posFrame.Pos1.z posFrame.Pos2.x posFrame.Pos2.y posFrame.Pos2.z posFrame.Pos3.x posFrame.Pos3.y posFrame.Pos3.z
		)
		for rotFrame in rba.RBAObjects[i].RotationalTrack.Frames do (
			format "\t\t%: % - [%,%,%,%] - [%,%,%,%] - [%,%,%,%] - % - %\n" rotFrame.Time rotFrame.F rotFrame.Rot1.x rotFrame.Rot1.y rotFrame.Rot1.z rotFrame.Rot1.w rotFrame.Rot2.x rotFrame.Rot2.y rotFrame.Rot2.z rotFrame.Rot2.w rotFrame.Rot3.x rotFrame.Rot3.y rotFrame.Rot3.z rotFrame.Rot3.w rotFrame.F2 rotFrame.F3
		)
	)
	fclose f
	rba
)
fn LoadRBA debugPrint:false autoApply:false =
(
	rba = undefined
	rba_name = GetOpenFileName caption:"Open RBA File" types:"RBA(*.RBA)|*.rba"
		if rba_name != undefined do
		(
			rba = ImportRBA rba_name
			if debugPrint then PrintRBA rba
			if autoApply then
			(
				ApplyRBA rba
			)
		)
		rba
)