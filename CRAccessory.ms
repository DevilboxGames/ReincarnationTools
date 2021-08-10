AccessoryTypes = #(
	"StandardAccessory",
	"RotatingAccessory",
	"AngularDampedAccessory",
	"Checkpoint",
	"ManagedAccessory",
	"Powerup",
	"ConveyorAccessory",
	"CopSpawn",
	"StartingGrid",
	"MultiplayerSpawn",
	"TrailerSpawn",
	"ExplodingAccessory",
	"RockingAccessory",
	"RigidBodyAnimation"
)
struct AccessoryShape
(
	Type,
	Points = #(),
	Radius,
	Part,
	fn Read f = (

		Type = (trimleft (trimright (readline f)))
		case Type of (
			"Sphere": (
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				radius = (readLine f) as float
			)
			"AlignedCuboid": (
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
			)
			"TicTac": (
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				radius = (readLine f) as float
			)
			"Capsule": (
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				radius = (readLine f) as float
			)
			"Polyhedron": (
				numPoints = (readline f) as integer
				for i = 1 to numPoints do 
				(
					append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				)
			)
			"RoundedPolyhedron": (
				radius = (readLine f) as float
				numPoints = (readline f) as integer
				for i = 1 to numPoints do 
				(
					append points (ConvertFromCRSpace (StringAsPoint3 (readline f)))
				)
			)
		)
	),
	fn Write f = (
			format "%\n" type to:f

			if type == "Sphere" then
			(
				pos = ConvertToCRSpace points[1]
				format "%,%,%\n" pos.x pos.y pos.z to:f
				format "%\n" (radius as string) to:f
			)
			else if type == "AlignedCuboid" then
			(
				pos1 = ConvertToCRSpace points[1]
				pos2 = ConvertToCRSpace points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:f
				format "%,%,%\n" pos2.x pos2.y pos2.z to:f
			)
			else if type == "TicTac" then
			(
				pos1 = ConvertToCRSpace points[1]
				pos2 = ConvertToCRSpace points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:f
				format "%,%,%\n" pos2.x pos2.y pos2.z to:f
				format "%\n" (radius as string) to:f
			)
			else if type == "Capsule" then
			(
				pos1 = ConvertToCRSpace points[1]
				pos2 = ConvertToCRSpace points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:f
				format "%,%,%\n" pos2.x pos2.y pos2.z to:f
				format "%\n" (radius as string) to:f
			)
			else if type == "Polyhedron" then
			(
				format "%\n" (points.count as string) to:f
				for v in points do
				(
					pos1 = ConvertToCRSpace v
					format "%,%,%\n" pos1.x pos1.y pos1.z to:f
				)
			)
			else if type == "RoundedPolyhedron" then
			(
				format "%\n" (radius as string) to:f
				format "%\n" (points.count as string) to:f
				for v in points do
				(
					pos1 = ConvertToCRSpace v
					format "%,%,%\n" pos1.x pos1.y pos1.z to:f
				)
			)
				format "\n\n" to:f
			append f  "form_collision_groups\n1\n\n"
	)
)
struct AccessoryJoint_Weakness (
	type,						-- string
	p3_Unknown,					-- point3
	strength,					-- float
	twistStrength,				-- float
	fn Read f = (
		local keepLooping = true
		local curPos = filePos f
		
		curLine = tolower(trimleft (trimright (readline f)))
		type = curLine
		curLine = trimleft (trimright (readline f))
		splitLine = filterstring curLine ", "
		p3_Unknown = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

		curLine = trimleft (trimright (readline f))
		splitLine = filterstring curLine ", "
		strength = splitLine[1]
		if splitLine.count > 1 then (
			twistStrength = splitLine[2]
		)

	),
	fn Write f = (

	)
)
struct AccessoryJoint_Constraint (
	i_Unknown,						-- int
	strength, 						-- float
	f_Unknown1, 					-- float
	minDirection, 					-- point3
	maxDirection, 					-- point3
	f_Unknown2,						-- float
	weakness, 						-- string (none) or BreakJoint/another weakness type
	p3_Unknown1, 					-- point3
	p3_Unknown2, 					-- point3
	fn Read f = (
		local keepLooping = true
		local curPos = filePos f
		
		curLine = tolower(trimleft (trimright (readline f)))
		i_Unknown = curLine as integer
		
		curLine = tolower(trimleft (trimright (readline f)))
		strength = curLine as float
		
		curLine = tolower(trimleft (trimright (readline f)))
		f_Unknown1 = curLine as float

		curLine = trimleft (trimright (readline f))
		splitLine = filterstring curLine ", "
		minDirection = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

		curLine = trimleft (trimright (readline f))
		splitLine = filterstring curLine ", "
		maxDirection = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]
		
		curLine = trimleft (trimright (readline f))
		f_Unknown2 = curLine as float

		curLine = trimleft (trimright (readline f))
		weakness = curLine


		curLine = trimleft (trimright (readline f))
		splitLine = filterstring curLine ", "
		p3_Unknown1 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

		curLine = trimleft (trimright (readline f))
		splitLine = filterstring curLine ", "
		p3_Unknown2 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

	),
	fn Write f = (
		format "%\n" i_Unknown to:f
		format "%\n" strength to:f
		format "%\n" f_Unknown to:f
		format "%,%,%\n" minDirection.x minDirection.y minDirection.z to:f
		format "%,%,%\n" minDirection.x minDirection.y minDirection.z to:f
		format "%\n" maxDirection.x maxDirection.y maxDirection.z to:f
		format "%\n" f_Unknown2 to:f
		format "%\n" weakness to:f
		format "%,%,%\n" p3_Unknown1.x p3_Unknown1.y p3_Unknown1.z to:f
		format "%,%,%\n" p3_Unknown2.x p3_Unknown2.y p3_Unknown2.z to:f
	)
)
struct AccessoryJoint (
	type,							--string: world or child
	label,							--string: e.g. joint
	flags,							-- int
									-- ????   Constraints?  ????    JointAxis?
									--   |		|		____/	______/
									--   |		|	   /	   /
									-- [0000] [0000] [0000] [0000]
									-------------------------------------------
	f_Unknown1,						-- float
	position,						-- point3 - in accessory's local space
	joint_normal,					-- point3
	p3_Unknown1,					-- point3
	p3_Unknown2,					-- point3
	p3_Unknown3,					-- point3
	p3_Unknown4,					-- point3
	p3_Unknown5,					-- point3
	numConstraints,					-- int
	constraints, 					-- AccessoryJoint_Constraint
	hasWeakness, 					-- bool outputs: (no_weakness) or weakness
	weakness1,		     			-- AccessoryJoint_Constraint
	weakness2,		     			-- AccessoryJoint_Constraint
	fn Read f = (
		local keepLooping = true
		local curPos = filePos f
		curLine = tolower(trimleft (trimright (readline f)))
		if curLine == "<world_joint>" then type = "world_joint"
		else if curLine == "<child_joint>" then type="child_joint"
		else if curLine[1] != "[" or curLine[1] != "<" then (
			curLine = trimleft (trimright (readline f))
			label = curLine

			curLine = trimleft (trimright (readline f))
			flags =  curLine as integer

			curLine = trimleft (trimright (readline f))
			f_Unknown1 = curLine as float

			curLine = trimleft (trimright (readline f))
			splitLine = filterstring curLine ", "
			joint_normal = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

			curLine = trimleft (trimright (readline f))
			splitLine = filterstring curLine ", "
			p3_Unknown1 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

			curLine = trimleft (trimright (readline f))
			splitLine = filterstring curLine ", "
			p3_Unknown2 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

			curLine = trimleft (trimright (readline f))
			splitLine = filterstring curLine ", "
			p3_Unknown3 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

			curLine = trimleft (trimright (readline f))
			splitLine = filterstring curLine ", "
			p3_Unknown4 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

			curLine = trimleft (trimright (readline f))
			splitLine = filterstring curLine ", "
			p3_Unknown5 = [splitLine[1] as float,splitLine[2] as float,splitLine[3] as float]

			curLine = trimleft (trimright (readline f))
			numConstraints =  curLine as integer
			constraints = #()

			for i=1 to numConstraints do (
				constraint = AccessoryJoint_Constraint()
				constraint.Read f
				append constraints constraint
			)

			curLine = tolower (trimleft (trimright (readline f)))
			if curLine == "weakness" then (
				hasWeakness = true
				weakness1 = AccessoryJoint_Weakness()
				weakness1.Read f
				weakness2 = AccessoryJoint_Weakness()
				weakness2.Read f

			)
		)
		else (
			seek f curPos
		)
	
	),
	fn Write f = (
		format "<%>\n" type to:f
		format "%\n" label to:f
		format "%\n" flags to:f
		format "%\n" f_Unknown1 to:f
		format "%,%,%\n" joint_normal.x joint_normal.y joint_normal.z to:f
		format "%,%,%\n" p3_Unknown1.x p3_Unknown1.y p3_Unknown1.z to:f
		format "%,%,%\n" p3_Unknown2.x p3_Unknown2.y p3_Unknown2.z to:f
		format "%,%,%\n" p3_Unknown3.x p3_Unknown3.y p3_Unknown3.z to:f
		format "%,%,%\n" p3_Unknown4.x p3_Unknown4.y p3_Unknown4.z to:f
		format "%,%,%\n" p3_Unknown5.x p3_Unknown5.y p3_Unknown5.z to:f
		format "%\n" numConstraints to:f

		for i=1 to numConstraints do (
			constraint.Write f
		)
		if hasWeakness then (
			format "weakness\n" to:f
			weakness1.Write f
			weakness2.Write f
		)
		else (
			format "(no_weakness)\n" to:f
		)
	)
)

struct AccessoryType_RotatingAccessory (
	Speed,								--float

	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				if (tolower splitLine[1]) == "speed" then (
					Speed = splieLine[2] as float
				)
				else (
					format "Unknown value for RotatingAccessory:\n\t\t%\n" curLine
				)
			)
		)
	),
	fn Write f = (
		format "speed %\n" Speed to:f
	)
)
struct AccessoryType_AngularDampedAccessory (
	Damper,								--float
	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				if (tolower splitLine[1]) == "damper" then (
					Damper = splieLine[2] as float
				)
				else (
					format "Unknown value for AngularDampedAccessory:\n\t\t%\n" curLine
				)
			)
		)

	),
	fn Write f = (
		format "damper %\n" Damper to:f
	)
)

struct AccessoryType_Checkpoint (
	radius,								--float
	top,								--float
	bottom,								--Float
	left,								--float
	right,								--float
	deactivated,						--String
	next,								--String
	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				case (tolower splitLine[1]) of (
					"radius": radius = splitLine[2] as float
					"top": top = splitLine[2] as float
					"bottom": bottom = splitLine[2] as float
					"left": left = splitLine[2] as float
					"right": right = splitLine[2] as float
					"deactivated": deactivated = splitLine[2]
					"next": next = splitLine[2]
					default: format "Unknown value for CheckpointAccessory:\n\t\t%\n" curLine
				)
			)
		)
	),
	fn Write f = (
		if radius > 0 then (
			format "radius %\n" radius to:f
		)
		if top != 0 then (
			format "top %\n" top to:f
		)
		if bottom != 0 then (
			format "bottom %\n" bottom to:f
		)
		if left != 0 then (
			format "left %\n" left to:f
		)
		if right != 0 then (
			format "right %\n" right to:f
		)
		if deactivated != undefined and deactivated != "" then (
			format "deactivated %\n" deactivated to:f
		)
		if next != undefined and next != "" then (
			format "next %\n" next to:f
		)
	)

)

struct AccessoryType_ManagedAccessory (
	break_fuse,							--Float
	management_policy,					--String
	trigger_particles,					--String
	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				case (tolower splitLine[1]) of (
					"break_fuse": break_fuse = splitLine[2] as float
					"management_policy": management_policy = splitLine[2]
					"trigger_particles": trigger_particles = true
					default: format "Unknown value for ManagedAccessory:\n\t\t%\n" curLine
				)
			)
		)
	),
	fn Write f = (
		if break_fuse > 0 then (
			format "break_fuse %\n" break_fuse to:f
		)
		if management_policy != undefined and management_policy != "" then (
			format "management_policy %\n" management_policy to:f
		)
		if trigger_particles == true then (
			format "trigger_particles\n" to:f
		)
	)
)

struct AccessoryType_Powerup (
	type,								--String
	respawn_time,						--Float
	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				case (tolower splitLine[1]) of (
					"respawn_time": break_fuse = splitLine[2] as float
					"type": management_policy = splitLine[2]
					default: format "Unknown value for PowerupAccessory:\n\t\t%\n" curLine
				)
			)
		)
	),
	fn Write f = (
		if type != undefined and type != "" then (
			format "type %\n" type to:f
		)
		if respawn_time > 0 then (
			format "respawn_time %\n" respawn_time to:f
		)
	)
)

struct AccessoryType_RigidBodyAnimation (
	anim,								--string
	looping,							--bool
	hit_to_trigger,						--bool
	time_offset,						--float
	max_acceleration,					--float
	max_angular_acceleration,			--float
	max_force,							--float
	max_force_linear,					--float
	break_factor,						--float
	stop_factor,						--float
	message_triggered,					--string
	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				case (tolower splitLine[1]) of (
					"anim": anim = splitLine[2]
					"looping": looping = true
					"hit_to_trigger": hit_to_trigger = true
					"max_acceleration": max_acceleration = splitLine[2] as float
					"max_angular_acceleration": max_angular_acceleration = splitLine[2] as float
					"max_force": max_force = splitLine[2] as float
					"max_force_linear": max_force_linear = splitLine[2] as float
					"break_factor": break_factor = splitLine[2] as float
					"stop_factor": stop_factor = splitLine[2] as float
					"message_triggered": message_triggered = splitLine[2]
					default: format "Unknown value for RigidBodyAnimationAccessory:\n\t\t%\n" curLine
				)
			)
		)

	),
	fn Write f = (
		if anim != undefined and anim != "" then(
			format "anim %\n" anim to:f
		)
		if looping == true then(
			format "looping\n" to:f
		)
		if hit_to_trigger == true then(
			format "hit_to_trigger\n" to:f
		)
		if max_acceleration > 0 then(
			format "max_acceleration %\n" max_acceleration to:f
		)
		if max_angular_acceleration > 0 then(
			format "max_angular_acceleration %\n" max_angular_acceleration to:f
		)
		if max_force > 0 then(
			format "max_force %\n" max_force to:f
		)
		if max_force_linear > 0 then(
			format "max_force_linear %\n" max_force_linear to:f
		)
		if break_factor > 0 then(
			format "break_factor %\n" break_factor to:f
		)
		if stop_factor > 0 then(
			format "stop_factor %\n" stop_factor to:f
		)
		if message_triggered != undefined and message_triggered != "" then(
			format "message_triggered %\n" message_triggered to:f
		)
	)
)
struct Accessory_StandardAppData (
	CollisionAudioEvent,				--string
	CollisionAudioMinTime,				--string
	CollisionAudioLump,					--string
	CollisionAudioEventScrape,			--string
	damage_magnifier,					--float
	damage_magnifier_X,					--float
	damage_magnifier_Y,					--float
	damage_magnifier_Z,					--float
	speed_sensitive_damage_magnifier,	--float
	dont_target,						--bool
	disable_pinball,					--bool
	vehicle_vfx,						--bool
	AccessoryAudio_Sound1,				--String
	AccessoryAudio_Sound2,				--String
	AccessoryAudio_Type,					--String
	AccessoryAudio_LumpName,				--String
	force_target,						--bool
	recovery_exclusion_radius,			--float
	special_flags,						--int
	fn Read f = (
		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				local splitLine = filterstring curLine " \t"
				case (tolower splitLine[1]) of (
					"CollisionAudioEvent": CollisionAudioEvent = splitLine[2]
					"CollisionAudioMinTime": CollisionAudioMinTime = splitLine[2]
					"CollisionAudioEventScrape": CollisionAudioEventScrape = splitLine[2]
					"AccessoryAudio_Sound1": AccessoryAudio_Sound1 = splitLine[2]
					"AccessoryAudio_Sound2": AccessoryAudio_Sound2 = splitLine[2]
					"AccessoryAudio_Type": AccessoryAudio_Type = splitLine[2]
					"AccessoryAudio_LumpName": AccessoryAudio_LumpName = splitLine[2]
					"dont_target": dont_target = true
					"disable_pinball": disable_pinball = true
					"vehicle_vfx": vehicle_vfx = true
					"force_target": force_target = true
					"damage_magnifier": damage_magnifier = splitLine[2] as float
					"damage_magnifier_X": damage_magnifier_X = splitLine[2] as float
					"damage_magnifier_Y": damage_magnifier_Y = splitLine[2] as float
					"damage_magnifier_Z": damage_magnifier_Z = splitLine[2] as float
					"speed_sensitive_damage_magnifier": speed_sensitive_damage_magnifier = splitLine[2] as float
					"recovery_exclusion_radius": recovery_exclusion_radius = splitLine[2] as float
					"message_triggered": message_triggered = splitLine[2]
					"special_flags": special_flags = splitLine[2] as integer
					default: format "Unknown value for StandardAccessory:\n\t\t%\n" curLine
				)
			)
		)
	),
	fn Write f = (

	)
	
)
struct CustomAccessoryBlock
(
	Type,
	Data,
	fn Read f = (

		local keepLooping = true
		while not (eof f) and keepLooping do (
			local curPos = filePos f
			curLine = trimleft (trimright (readline f))
			if curLine[1] == "[" or curLine[1] == "<" then (
				seek f curPos
				keepLooping = false
			)
			else (
				Type = curLine
				case (tolower curLine) of (
					"respawn_time": break_fuse = splitLine[2] as float
					"type": management_policy = splitLine[2]
					default: format "Unknown value for PowerupAccessory:\n\t\t%\n" curLine
				)
			)
		)
	),
	fn Write f = (

	)
)

struct AccessoryBreakableReplacement
(
	Axis, 							--string +x,-x,+y,-y,+z,-z
	Replacement 					--string
)

struct AccessoryBreakableBlock
(
	Breakable,						--bool
	break_impulse,					--float
	replace,						--string
	directional_replacements = #(), --AccessoryBreakableReplacement[]
	explode_force,					--float
	trigger_particles,				--bool
	sound,							--string
	random_rotation,				--point2
	detach_children,				--bool
	destroy_children				--bool
)
struct AccessoryDynamicsShapeBlock
(
	label,							--string
	shapes =#()
)

struct AccessoryDynamicsBlock
(
	lump_name, 						--string
	centre_of_mass,					--point3
	moments,						--point3
	mass, 							--float
	solid,							--bool
	inf_mi,							--bool
	inf_mass,						--bool
	drivable_on,					--bool
	part_of_world,					--bool
	stop_sinking_into_ground,		--bool
	ignore_gravity,				 	--bool
	ignore_world,				 	--bool
	group,							--int
	ignore_group,					--int[]
	buoyant,						--bool
	buoyancy_relative_to_com,		--float?
	sphere_rolling_resistance,		--float
	substance,						--int
	linear_acceleration,			--point3
	regular_acceleration,			--point3
	Shape							--AccessoryDynamicsShapeBlock
)
struct AccessoryFileLump
(
	Joints,								--string	
	DynamicsBlocks = #(),
	BreakableBlocks = #(),
	Accessory_StandardAppData,
	CustomAccessoryBlocks = #(),
	--ManagedAccessory

	--Powerup


	--Rigidbody Animation
	UseRBA,								--bool
	Children = #(),

	Shapes =#(),
	fn CreateShape objects moveToOrigin:false forcePolyhedron:false roundedPolyhedronAmount: =
	(
		for obj in objects do
		(
			oldVis = obj.isHidden
			obj.isHidden = false
			oldPos = obj.pos
			if moveToOrigin then (
				obj.pos = [0,0,0]
			)
			oldRot = obj.rotation
			objType = classof obj

			isAxisAligned = (
				normXAxis = normalize obj.Transform.row1
				normXAxis.x == 1 or normXAxis.y == 1 or normXAxis.z == 1
			)
			isScaled = obj.scale.x != 1 or obj.scale.y != 1 or obj.scale.z != 1
			isUniformScaled = obj.scale.x == obj.scale.y and obj.scale.x == obj.scale.z
			format "%\nisAxisAligned: %\nisScaled: %\nisUniformScaled: %\n" objType isAxisAligned isScaled isUniformScaled
			if forcePolyhedron == false and (objType == Sphere or objType == GeoSphere) and isUniformScaled then
			(
				accShape = AccessoryShape Type:"Sphere"
				append accShape.Points obj.position
				accShape.Radius = obj.radius * obj.scale.x
			)
			else if forcePolyhedron == false and (objType == Box) and isAxisAligned then
			(
				accShape = AccessoryShape Type:"AlignedCuboid"
				append accShape.Points obj.min
				append accShape.Points obj.max
			)
			else if forcePolyhedron == false and objType == Capsule and isUniformScaled then
			(
				accShape = AccessoryShape Type:"TicTac"
				ticTacRadius = obj.scale.x * obj.radius
				ticTacHeight = obj.scale.x * obj.height
				if (obj.heighttype == 0) then ticTacHeight = ticTacHeight - ticTacRadius
				startPos = obj.position + obj.Transform.row3 * ticTacRadius
				endPos = startPos + obj.Transform.row3 * ticTacHeight
				append accShape.points startPos
				append accShape.points endPos
				accShape.radius = ticTacRadius
			)
			else
			(
				msh = snapshotasmesh obj
				accShape = AccessoryShape Type:"Polyhedron"
				if roundedPolyhedronAmount != unsupplied then (
					accShape.type = "RoundedPolyhedron"
					accShape.Radius = RoundedPolyhedronAmount
				)
				numShapeVerts = getNumVerts msh
				for v=1 to numShapeVerts do
				(
					pos = getVert msh v
					appendifunique accShape.points pos
				)
			)
			append Shapes accShape
			obj.pos = oldPos
			obj.rotation = oldRot
			obj.isHidden = oldVis
		)
	),
	fn OutputShapeString =
	(
		strstream = StringStream ""
		append strStream "<Shape>\n"
		append strstream "(default label)\n"
		append strstream (shapes.count as string)
				append strStream "\n"
		for shape in Shapes do
		(
			append strStream shape.type
				append strStream "\n"
			if shape.type == "Sphere" then
			(
				pos = ConvertToCRSpace shape.points[1]
				format "%,%,%\n" pos.x pos.y pos.z to:strStream
				append strStream (shape.radius as string)
				append strStream "\n"
			)
			else if shape.type == "AlignedCuboid" then
			(
				pos1 = ConvertToCRSpace shape.points[1]
				pos2 = ConvertToCRSpace shape.points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				format "%,%,%\n" pos2.x pos2.y pos2.z to:strStream
			)
			else if shape.type == "TicTac" then
			(
				pos1 = ConvertToCRSpace shape.points[1]
				pos2 = ConvertToCRSpace shape.points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				format "%,%,%\n" pos2.x pos2.y pos2.z to:strStream
				append strStream (shape.radius as string)
				append strStream "\n"
			)
			else if shape.type == "Capsule" then
			(
				pos1 = ConvertToCRSpace shape.points[1]
				pos2 = ConvertToCRSpace shape.points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				format "%,%,%\n" pos2.x pos2.y pos2.z to:strStream
				append strStream (shape.radius as string)
				append strStream "\n"
			)
			else if shape.type == "Polyhedron" then
			(
				append strStream (shape.points.count as string)
				append strStream "\n"
				for v in shape.points do
				(
					pos1 = ConvertToCRSpace v
					format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				)
			)
			else if shape.type == "RoundedPolyhedron" then
			(
				append strStream (shape.Radius as string)
				append strStream "\n"
				append strStream (shape.points.count as string)
				append strStream "\n"
				for v in shape.points do
				(
					pos1 = ConvertToCRSpace v
					format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				)
			)
				append strStream "\n"
				append strStream "\n"
			append strStream  "form_collision_groups\n1\n\n"
		)
		--format "%" (strStream as string)
		strStream as string
	),
	
	fn SaveTXT txtFile obj= (
		
		accTxt = "[DYNAMICS]\n\n<lump_name>\n"+obj.name+"\n\n<solid>\n<part_of_world>\n<mass>\n1000.000000\n\n\n<centre_of_mass>\n0.000000,0.000000,0.000000\n<DRIVABLE_ON>\n"
		accTxt = accTxt + OutputShapeString()
		
		fp = openFile txtFile mode:"wt"
		format "%" accText to:fp
		close fp
		
	)
)
fn QuickGetAccessoryShape moveToOrigin:false forcePolyhedron:false =
(
	accessory = AccessoryFileLump()
	accessory.CreateShape $ moveToOrigin:moveToOrigin forcePolyhedron:forcePolyhedron
	format "%\n\n" (accessory.OutputShapeString())

	accessory
)

fn SpawnAccessoryPlaceholder accessoryName pos:[0,0,0] rot:(quat 0 0 0 1) = (
	local newacc = CarmaHelper_AccessoryPlaceholder()
	
	newacc.loadAccessoryMesh ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\DATA\\CONTENT\\TRACKS\\ACCESSORIES\\"+accessoryName+"\\ACCESSORY.CNT")
	newacc.pos = pos
	newacc.rotation = rot
	select newacc
	viewport.zoomtobounds true newacc.min newacc.max
)
fn MakeC1AccessoriesList = (
	outputstring = ""
	for obj in selection  do (
		tm = copy obj.transform
				if dot (normalize (cross tm.row3 tm.row1)) (normalize tm.row2) < 0.9 then tm.row1 = -tm.row1
				--tm.row1 = normalize tm.row1
				--tm.row2 = normalize tm.row2
				--tm.row3 = normalize tm.row3
				tm = matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0] * tm * inverse(matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0])
					tmstring = (tm.row1.x as string)+","+ (tm.row1.y as string)+","+ (tm.row1.z as string)+"\n"+(tm.row2.x as string)+","+ (tm.row2.y as string)+","+ (tm.row2.z as string)+"\n"+(tm.row3.x as string)+","+ (tm.row3.y as string)+","+ (tm.row3.z as string)+"\n"+(tm.row4.x as string)+","+ (tm.row4.y as string)+","+ (tm.row4.z as string)+"\n"
				outputstring = outputstring + "[ACCESSORY]\n\n<NAME>\n"+((filterstring obj.name ".")[1])+"\n\n<POSITION>\n"+tmstring+"\n<INSTANCE_NAME>\n"+((filterstring obj.name ".")[1])+"\n\n<INSTANCE_COLOUR>\n255,255,255\n\n"	
	)
	outputstring
)

fn MakeMatrixFrom3Verts vertO vertX vertY upVector:[0,0,1] = (
	local yAxis = normalize ((getVert $ vertX) - (getVert $ vertO))
	local xAxis = normalize ((getVert $ vertY) - (getVert $ vertO))
	
	(matrix3 xAxis yAxis upVector [0,0,0])
)
fn MakeQuatFrom3Verts vertO vertX vertY upVector:[0,0,1] = (
	local yAxis = normalize ((getVert $ vertX) - (getVert $ vertO))
	local xAxis = normalize ((getVert $ vertY) - (getVert $ vertO))
	
	(matrix3 xAxis yAxis upVector [0,0,0]) as quat
)

CollisionShapeTypes = #("Polyhedron", "RoundedPolyhedron", "TicTac", "Wireframe", "AlignedCuboid", "Sphere")
AccessoryShapeAttribute = attributes AccessoryShapeCustAttrib attribid:#(0x2804a3ce, 0x4f8eec73) version:1
(
	parameters main rollout:mainaccessoryshaperollout (
		CollisionType type:#string default:"Polyhedron"
	)
	rollout mainaccessoryshaperollout "Accessory" (
		dropdownlist dpdn_CollisionType items:CollisionShapeTypes default:1

		on mainaccessoryshaperollout open do (
			dpdn_CollisionType.selection = finditem CollisionShapeTypes CollisionType
		)

		on dpdn_CollisionType selected selectedIndex do (
			CollisionType = CollisionShapeTypes[selectedIndex]
		)

	)
)

fn AddAccessoryShapeModifier obj = (

	accessoryModifier = obj.modifiers["Accessory Shape"]
	if accessoryModifier == undefined then (
		max modify mode
		accessoryModifier = emptyModifier()
		
		accessoryModifier.name = "Accessory Shape"
		addModifier obj accessoryModifier
		custattributes.add accessoryModifier AccessoryShapeAttribute baseObject:false
	)
	accessoryModifier
)
AccessoryJointWeaknessAttribute = attributes AccessoryJointWeaknessCustAttrib attribid:#(0x63937174, 0x79430dbd) version:1
(
	parameters main rollout: accessoryjointweaknessrollout (
		WeaknessType type:#string					-- string
		p3_Unknown type:#point3						-- point3
		strength type:#float ui:spn_strength		-- float
		twistStrength type:#float ui:spn_twistStrength	-- float
	)
	rollout accessoryjointweaknessrollout "Joint Weakness" (
		dropdownlist dpdn_weaknesstype "Type" items:#("(null)","BreakJoint", "RemoveAngularConstraintsForAFrameNoTwist", "RemoveAngularConstraintsForAFrameWithTwistSnap", "ConstraintForceWeaknessCallBack", "ConstraintTorqueWeaknessNoTwistCallBack")

		label lbl_p3_Unknown "Unknown Vector3"
		spinner spn_p3_Unknown_x "X" type:#float across:3
		spinner spn_p3_Unknown_y "Y" type:#float across:3
		spinner spn_p3_Unknown_z "Z" type:#float across:3

		spinner spn_strength "Strength" type:#float
		spinner spn_twistStrength "Twist Strength" type:#float

		on accessoryjointweaknessrollout open do (
			spn_p3_Unknown_x.value = p3_unknown.x
			spn_p3_Unknown_y.value = p3_unknown.y
			spn_p3_Unknown_z.value = p3_unknown.z

			weaknessType = finditem dpdn_weakness.items weaknesstype
			if weaknessType == 0 then weaknessType = 1
			dpdn_weakness.selected = weaknessType
		)
	)
)
AccessoryJointConstraintAttribute = attributes AccesoryJointConstraintCustAttrib attribid:#(0xa212571, 0x7561b882) version:1
(
	parameters main rollout: accessoryjointconstratinrollout (
		i_Unknown type:#integer ui:spn_i_unknown			-- int
		strength type:#float ui:spn_strength 						-- float
		f_Unknown1 type:#float ui:spn_f_unknown1 					-- float
		minDirection type:#point3 					-- point3
		maxDirection type:#point3 					-- point3
		f_Unknown2 type:#float ui:spn_f_unknown2				-- float
		weakness type:#string 						-- string (none) or BreakJoint/another weakness type
		p3_Unknown1 type:#point3 					-- point3
		p3_Unknown2 type:#point3					-- point3
	)
	rollout accessoryjointconstratinrollout "Joint Constraint" (
		spinner spn_i_unknown "Unknown Int" type:#integer
		spinner spn_strength "Strength" type:#float
		spinner spn_f_unknown1 "Unknown Float 1" type:#float

		label lbl_minDirection "Min Direction"
		spinner spn_minDirection_x "X" type:#float across:3
		spinner spn_minDirection_y "Y" type:#float across:3
		spinner spn_minDirection_z "Z" type:#float across:3

		label lbl_maxDirection "Max Direction"
		spinner spn_maxDirection_x "X" type:#float across:3
		spinner spn_maxDirection_y "Y" type:#float across:3
		spinner spn_maxDirection_z "Z" type:#float across:3

		spinner spn_f_unknown2 "Unknown Float 2" type:#float

		dropdownlist dpdn_weakness "Weaknesss" items:#("(null)", "BreakJoint")

		label lbl_p3_unknown1 "Unknown Vector3 1"
		spinner spn_p3_unknown1_x "X" type:#float across:3
		spinner spn_p3_unknown1_y "Y" type:#float across:3
		spinner spn_p3_unknown1_z "Z" type:#float across:3

		label lbl_p3_unknown2 "Unknown Vector3 2"
		spinner spn_p3_unknown2_x "X" type:#float across:3
		spinner spn_p3_unknown2_y "Y" type:#float across:3
		spinner spn_p3_unknown2_z "Z" type:#float across:3

		on accessoryjointconstratinrollout open do (
			spn_minDirection_x.value = minDirection.x
			spn_minDirection_y.value = minDirection.y
			spn_minDirection_z.value = minDirection.z

			spn_maxDirection_x.value = maxDirection.x
			spn_maxDirection_y.value = maxDirection.y
			spn_maxDirection_z.value = maxDirection.z

			spn_p3_unknown1_x.value = p3_unknown1.x
			spn_p3_unknown1_y.value = p3_unknown1.y
			spn_p3_unknown1_z.value = p3_unknown1.z

			spn_p3_unknown2_x.value = p3_unknown2.x
			spn_p3_unknown2_y.value = p3_unknown2.y
			spn_p3_unknown2_z.value = p3_unknown2.z

			case weakness of (
				"(null)":
					dpdn_weakness.selected = 1
				"BreakJoint":
					dpdn_weakness.selected = 2
				default: (
					dpdn_weakness.selected = 1
					format "Unknown constraint weakness type %\n" weakness
				)
			)
		)
		on dpdn_weakness selected selectedIndex do (
			weakness = dpdn_weakness.items[selectedIndex]
		)

		on spn_minDirection_x changed value do (
			minDirection.x = value
		)
		on spn_minDirection_y changed value do (
			minDirection.y = value
		)
		on spn_minDirection_z changed value do (
			minDirection.z = value
		)

		on spn_maxDirection_x changed value do (
			maxDirection.x = value
		)
		on spn_maxDirection_y changed value do (
			maxDirection.y = value
		)
		on spn_maxDirection_z changed value do (
			maxDirection.z = value
		)

		on spn_p3_unknown1_x changed value do (
			p3_unknown1.x = value
		)
		on spn_p3_unknown1_y changed value do (
			p3_unknown1.y = value
		)
		on spn_p3_unknown1_z changed value do (
			p3_unknown1.z = value
		)

		on spn_p3_unknown2_x changed value do (
			p3_unknown2.x = value
		)
		on spn_p3_unknown2_y changed value do (
			p3_unknown2.y = value
		)
		on spn_p3_unknown2_z changed value do (
			p3_unknown2.z = value
		)
	)


)
AccessoryJointAttribute = attributes AccessoryJointCustAttrib attribid:#(0x8a6ad99,0x9ba8ba) version:1
(
	parameters main rollout:accessoryjointrollout
	(
		jointtype type:#string							--string: world or child
		flags type:#booltab tabsize:32 ui: (chk_flag01,chk_flag02,chk_flag03,chk_flag04,chk_flag05,chk_flag06,chk_flag07,chk_flag08,chk_flag09,chk_flag10,chk_flag11,chk_flag12,chk_flag13,chk_flag14,chk_flag15,chk_flag16,chk_flag17,chk_flag18,chk_flag19,chk_flag20,chk_flag21,chk_flag22,chk_flag23,chk_flag24,chk_flag25,chk_flag26,chk_flag27,chk_flag28,chk_flag29,chk_flag30,chk_flag31,chk_flag32)						-- int
										-- ????   Constraints?  ????    JointAxis?
										--   |		|		____/	______/
										--   |		|	   /	   /
										-- [0000] [0000] [0000] [0000]
										-------------------------------------------
		f_Unknown1 type:#float ui:spn_f_unknown1		-- float
		position type:#point3						-- point3 - in accessory's local space
		joint_normal type:#point3					-- point3
		p3_Unknown1 type:#point3					-- point3
		p3_Unknown2 type:#point3					-- point3
		p3_Unknown3 type:#point3					-- point3
		p3_Unknown4 type:#point3					-- point3
		p3_Unknown5 type:#point3					-- point3
		
	)
	rollout accessoryjointrollout "Accessory Joint" (
		dropdownlist dpdn_jointtype "Joint Type" values:#("World", "Child")
		group "Flags" (
			checkbox chk_flag01 "01" across:3
			checkbox chk_flag02 "02" across:3
			checkbox chk_flag03 "03" across:3
			checkbox chk_flag04 "04" across:3
			checkbox chk_flag05 "05" across:3
			checkbox chk_flag06 "06" across:3
			checkbox chk_flag07 "07" across:3
			checkbox chk_flag08 "08" across:3
			checkbox chk_flag09 "09" across:3
			checkbox chk_flag10 "10" across:3
			checkbox chk_flag11 "11" across:3
			checkbox chk_flag12 "12" across:3
			checkbox chk_flag13 "13" across:3
			checkbox chk_flag14 "14" across:3
			checkbox chk_flag15 "15" across:3
			checkbox chk_flag16 "16" across:3
			checkbox chk_flag17 "17" across:3
			checkbox chk_flag18 "18" across:3
			checkbox chk_flag19 "19" across:3
			checkbox chk_flag20 "20" across:3
			checkbox chk_flag21 "21" across:3
			checkbox chk_flag22 "22" across:3
			checkbox chk_flag23 "23" across:3
			checkbox chk_flag24 "24" across:3
			checkbox chk_flag25 "25" across:3
			checkbox chk_flag26 "26" across:3
			checkbox chk_flag27 "27" across:3
			checkbox chk_flag28 "28" across:3
			checkbox chk_flag29 "29" across:3
			checkbox chk_flag30 "30" across:3
			checkbox chk_flag31 "31" across:3
			checkbox chk_flag32 "32" across:3
		)
		spinner spn_f_unknown1 "Unknown Float" type:#float
		label lbl_Position "Position"
		spinner spn_position_x "X" type:#float across:3
		spinner spn_position_y "Y" type:#float across:3
		spinner spn_position_z "Z" type:#float across:3
		label lbl_Normal "Normal"
		spinner spn_Normal_x "X" type:#float across:3
		spinner spn_Normal_y "Y" type:#float across:3
		spinner spn_Normal_z "Z" type:#float across:3
		label lbl_unknown1 "Unknown 1"
		spinner spn_unknown1_x "X" type:#float across:3
		spinner spn_unknown1_y "Y" type:#float across:3
		spinner spn_unknown1_z "Z" type:#float across:3
		label lbl_unknown2 "Unknown 2"
		spinner spn_unknown2_x "X" type:#float across:3
		spinner spn_unknown2_y "Y" type:#float across:3
		spinner spn_unknown2_z "Z" type:#float across:3
		label lbl_unknown3 "Unknown 3"
		spinner spn_unknown3_x "X" type:#float across:3
		spinner spn_unknown3_y "Y" type:#float across:3
		spinner spn_unknown3_z "Z" type:#float across:3
		label lbl_unknown4 "Unknown 4"
		spinner spn_unknown4_x "X" type:#float across:3
		spinner spn_unknown4_y "Y" type:#float across:3
		spinner spn_unknown4_z "Z" type:#float across:3
		label lbl_unknown5 "Unknown 5"
		spinner spn_unknown5_x "X" type:#float across:3
		spinner spn_unknown5_y "Y" type:#float across:3
		spinner spn_unknown5_z "Z" type:#float across:3

		on dpdn_jointtype seleced selectedIndex do (
			joint_type = dpdpn_jointtype.Items[selectedIndex]
		)
		on accessoryjointrollout open do(
			if joint_type == "World" then
			(
				dpdn_jointtype.selection = 1
			)
			else (
				dpdn_jointtype.selection = 2
			)

			spn_position_x.value = position.x
			spn_position_y.value = position.y
			spn_position_z.value = position.z

			spn_normal_x.value = joint_normal.x
			spn_normal_y.value = joint_normal.y
			spn_normal_z.value = joint_normal.z

			spn_unknown1_x.value = p3_unknown1.x
			spn_unknown1_y.value = p3_unknown1.y
			spn_unknown1_z.value = p3_unknown1.z

			spn_unknown2_x.value = p3_unknown2.x
			spn_unknown2_y.value = p3_unknown2.y
			spn_unknown2_z.value = p3_unknown2.z

			spn_unknown3_x.value = p3_unknown3.x
			spn_unknown3_y.value = p3_unknown3.y
			spn_unknown3_z.value = p3_unknown3.z

			spn_unknown4_x.value = p3_unknown4.x
			spn_unknown4_y.value = p3_unknown4.y
			spn_unknown4_z.value = p3_unknown4.z

			spn_unknown5_x.value = p3_unknown5.x
			spn_unknown5_y.value = p3_unknown5.y
			spn_unknown5_z.value = p3_unknown5.z
		)

		on spn_position_x changed value do (
			position.x = value
		)

		on spn_position_y changed value do (
			position.y = value
		)

		on spn_position_z changed value do (
			position.z = value
		)

		on spn_normal_x changed value do (
			joint_normal.x = value
		)

		on spn_normal_y changed value do (
			joint_normal.y = value
		)

		on spn_normal_z changed value do (
			joint_normal.z = value
		)


		on spn_unknown1_x changed value do (
			p3_unknown1.x = value
		)

		on spn_unknown1_y changed value do (
			p3_unknown1.y = value
		)

		on spn_unknown1_z changed value do (
			p3_unknown1.z = value
		)

		on spn_unknown2_x changed value do (
			p3_unknown2.x = value
		)

		on spn_unknown2_y changed value do (
			p3_unknown2.y = value
		)

		on spn_unknown2_z changed value do (
			p3_unknown2.z = value
		)

		on spn_unknown3_x changed value do (
			p3_unknown3.x = value
		)

		on spn_unknown3_y changed value do (
			p3_unknown3.y = value
		)

		on spn_unknown3_z changed value do (
			p3_unknown3.z = value
		)

		on spn_unknown4_x changed value do (
			p3_unknown4.x = value
		)

		on spn_unknown4_y changed value do (
			p3_unknown4.y = value
		)

		on spn_unknown4_z changed value do (
			p3_unknown4.z = value
		)

		on spn_unknown5_x changed value do (
			p3_unknown5.x = value
		)

		on spn_unknown5_y changed value do (
			p3_unknown5.y = value
		)

		on spn_unknown5_z changed value do (
			p3_unknown5.z = value
		)
	)
)

AccessoryCheckpointAttribute = attributes AccessoryCheckpointCustAttrib attribid:#(0x726dec3e, 0x7283fedb) version:1
(
	parameters main rollout:accessorycheckpointrollout
	(
		radius type:#float ui:spn_radius								--Int
		top type:#float ui:spn_top								--Int
		bottom type:#float ui:spn_bottom								--Int
		left type:#float ui:spn_left								--Int
		right type:#float ui:spn_right								--Int
		deactivated type:#string ui:txt_deactivated						--String
		next type:#string ui:txt_next								--String
	)
	rollout accessorycheckpointrollout "Checkpoint Data" 
	(
		group "Offsets" (
			spinner spn_radius "Radius" range:[-50,50,0]
			spinner spn_top "Top" range:[-50,50,0]
			spinner spn_bottom "Bottom" range:[-50,50,0]
			spinner spn_left "Left" range:[-50,50,0]
			spinner spn_right "Right" range:[-50,50,0]
		)
		group "Replacements" (
			edittext txt_deactivated "Deactivated" labelOnTop:true
			edittext txt_next "Next" labelOnTop:true
		)
		
	)
)
AccessoryManagedAccessoryAttribute = attributes AccessoryManagedAccesoryCustAttrib attribid:#(0x3e7f2389, 0x3f9b2a53) version:1
(
	parameters main rollout:managedaccessoryrollout (

		break_fuse type:#float ui:spn_break_fuse						--Float
		management_policy type:#string					--String
		trigger_particles type:#boolean ui:chk_trigger_particles					--String
	)
	rollout managedaccessoryrollout "Managed Accessory Data" (
		spinner spn_break_fuse "Break Fuse" range:[0,100000,0]
		dropdownlist dpdn_management_policy "Management Policy" items:#("disappear_on_rest_after_timer","explode_on_timer","weaponized_every_frame")
		checkbox chk_trigger_particles "Trigger Particles"

		on managedaccessoryrollout open do (
			selectedManagementPolicy = finditem dpdn_management_policy.items management_policy
			if selectedManagementPolicy > 0 then (
				dpdn_management_policy.selected = selectedManagementPolicy
			)
		)
		on dpdn_management_policy changed selectedIndex do (
			management_policy = dpdn_management_policy.items[selectedIndex]
		)
	)
)
AccessoryNoDataAttribute = attributes AccessorynodataCustAttrib attribid:#(0x64193b2,0xbc3e6a8e) version:1
(
	parameters main rollout:nodatarollout (
	)
	rollout nodatarollout "Accessory Data" (
		label lbl_nodata "No settings for this accessory!"
	)
)
AccessoryangulardampedAttribute = attributes AccessoryangulardampedCustAttrib attribid:#(0x64193b2,0xbc3e6a8e) version:1
(
	parameters main rollout:angulardampedrollout (
		damping type:#float ui:spn_damping		--Float
	)
	rollout angulardampedrollout "Angular Damped Accessory Data" (
		spinner spn_damping "Damping" type:#float range:[0,1000000,0]
	)
)
AccessoryRotatingAccessoryAttribute = attributes AccessoryRotatingAccessoryCustAttrib attribid:#(0x64193b2,0xbc3e6a8e) version:1
(
	parameters main rollout:rotatingaccessoryrollout (
		speed type:#float ui:spn_speed		--Float
	)
	rollout rotatingaccessoryrollout "Rotating Accessory Data" (
		spinner spn_speed "Speed" type:#float range:[0,1000000,0]
	)
)
AccessoryPowerUpAccessoryAttribute = attributes AccessoryPowerUpAccessoryCustAttrib attribid:#(0x64193b2,0xbc3e6a8e) version:1
(
	parameters main rollout:powerupaccessoryrollout (
		powerup_type type:#string ui:txt_type		--String
		respawn_time type:#float ui:spn_respawn_time		--Float
	)
	rollout powerupaccessoryrollout "Powerup Accessory Data" (
		edittext txt_type "Powerup Type" labelOnTop:true
		spinner spn_respawn_time "Respawn Time" type:#float range:[0,1000000,0]
	)
)
AccessoryAnimatedAccessoryAttribute = attributes AccesoryAnimatedAccessoryAttribute attribid:#(0x42661b3c,0x82b5a7e1) version:1
(
	parameters main rollout:animatedaccessoryrollout (
		anim type:#string ui:txt_anim											--string
		looping type:#boolean ui:chk_looping									--bool
		hit_to_trigger type:#boolean ui:chk_hit_to_trigger						--bool
		time_offset type:#float ui:spn_time_offset								--float
		max_acceleration type:#float ui:spn_max_acceleration					--float
		max_angular_acceleration type:#float ui:spn_max_angular_acceleration	--float
		max_force type:#float ui:spn_max_force									--float
		max_force_linear type:#float ui:spn_max_force_linear					--float
		break_factor type:#float ui:spn_break_factor							--float
		stop_factor type:#float ui:spn_stop_factor								--float
		message_triggered type:#string ui:txt_message_triggered					--string
	)
	rollout animatedaccessoryrollout "Animated Accessory Data" (
		edittext txt_anim "RBA Filename" labelOnTop:true
		checkbox chk_looping "Looping"
		checkbox chk_hit_to_trigger "Trigger on Hit"
		edittext txt_message_triggered "Trigger on Event"
		spinner spn_time_offset "Time Offset" type:#float range:[0,10000000,0]
		spinner spn_max_acceleration "Max Acceleration" type:#float range:[0,100000000,0]
		spinner spn_max_angular_acceleration "Max Angular Acceleration" type:#float range:[0,10000000,0]
		spinner spn_max_force "Max Force" type:#float range:[0,10000000,0]
		spinner spn_max_force_linear "Max Linear Force" type:#float range:[0,10000000,0]
		spinner spn_break_factor "Break Factor" type:#float range:[0,10000000,0]
		spinner spn_stop_factor "Stop Factor" type:#float range:[0,10000000,0]
	)
)
AccessoryStandardAccessoryAttribute = attributes AccessoryStandardAccessoryCustAttrib attribid:#(0x6d2b4c89,0x2c7e8a93) version:1
(
	parameters main rollout:standardaccessoryrollout (

		CollisionAudioEvent type:#string ui:txt_collisionaudioevent				--string
		CollisionAudioMinTime type:#float ui:spn_collisionaudiomintime			--string
		CollisionAudioLump type:#string ui:txt_collisionaudiolump				--string
		CollisionAudioEventScrape type:#string ui:txt_collisionaudioeventscrape	--string
		damage_magnifier type:#float default:1 ui:spn_damage_magnifier			--float
		damage_magnifier_X type:#float default:1 ui:spn_damage_magnifier_x		--float
		damage_magnifier_Y type:#float default:1 ui:spn_damage_magnifier_y		--float
		damage_magnifier_Z type:#float default:1 ui:spn_damage_magnifier_z		--float
		speed_sensitive_damage_magnifier type:#float default:1 ui:spn_speed_sensitive_damage_magnifier	--float
		dont_target type:#boolean ui:chk_dont_target							--bool
		force_target type:#boolean ui:chk_force_target						--bool
		disable_pinball type:#boolean ui:chk_disable_pinball					--bool
		vehicle_vfx type:#boolean ui:chk_vehicle_vfx						--bool
		AccessoryAudio_Sound1 type:#string ui:txt_AccessoryAudio_Sound1				--String
		AccessoryAudio_Sound2 type:#string ui:txt_AccessoryAudio_Sound2				--String
		AccessoryAudio_Type type:#string ui:txt_AccessoryAudio_Type					--String
		AccessoryAudio_LumpName type:#string ui:txt_AccessoryAudio_LumpName				--String
		recovery_exclusion_radius type:#float ui:spn_recovery_exclusion_radius			--float
		special_flags type:#integer ui:spn_special_flags						--int
	)

	rollout standardaccessoryrollout "Standard Accessory Data" (
		group "Collision Audio" (
			edittext txt_collisionaudioevent "Event" labelOnTop:true
			edittext txt_collisionaudioeventscrape "Scrape Event" labelOnTop:true
			edittext txt_collisionaudiolump "Lump Name"
			spinner spn_collisionaudiomintime "Min Time" type:#float range:[0,10000,0]
		)

		group "Damage Magnifier" (
			spinner spn_damage_magnifier "Magnifier" type:#float range:[0,1000000,0] 
			spinner spn_damage_magnifier_x "Side Magnifier" type:#float range:[0,1000000,0] 
			spinner spn_damage_magnifier_y "Top/Bottom Magnifier" type:#float range:[0,1000000,0] 
			spinner spn_damage_magnifier_z "Front/Back Magnifier" type:#float range:[0,1000000,0] 
			spinner spn_speed_sensitive_damage_magnifier "Speed Sensitive Magnifier" type:#float range:[0,100000,0]
		)

		group "Accessory Audio" (
			edittext txt_AccessoryAudio_Sound1 "Sound 1"
			edittext txt_AccessoryAudio_Sound2 "Sound 2"
			edittext txt_AccessoryAudio_Type "Sound Type"
			edittext txt_AccessoryAudio_LumpName "Lump Name"
		)

		group "Settings" (
			checkbox chk_dont_target "Dont Target"
			checkbox chk_force_target "Always Target"
			checkbox chk_disable_pinball "Disable Pinball"
			checkbox chk_vehicle_vfx "Vehicle VFX"
			spinner spn_recovery_exclusion_radius "Recovery Exclusion Radius" type:#float range:[0,1000,0]
			spinner spn_special_flags "Recovery Exclusion Radius" type:#integer range:[0,1,0]
		)
	)
)
AccessoryBreakableAttribute = attributes AccessoryBreakableCustAttrib attribid:#(0x43628563, 0x36485726) version:1
(
	parameters main rollout:mainbreakablerollout (
		break_impulse type:#float default:100 ui:spn_break_impulse
		replace type:#string ui:txt_replace
		directional_replacements type:#stringtab tabsizevariable:true
		directional_replacements_direction type:#stringtab tabsizevariable:true
		explode_force type:#float default:0 ui:spn_explode_force
		trigger_particles type:#boolean default:false ui:chk_trigger_particles
		collision_with_world_will_break_me type:#boolean default:true ui:chk_collision_with_world_will_break_me
		sound type:#string ui:txt_sound
		random_rotation type:#point3 
		detach_children type:#boolean ui:chk_detach_children
		destroy_children type:#boolean ui:chk_destroy_children
	)
	

	rollout mainbreakablerollout "Breakable" (
		spinner spn_break_impulse "Break Impulse" type:#float
		spinner spn_explode_force "Explode Force" type:#float
		edittext txt_sound "Sound"
		checkbox chk_trigger_particles "Trigger Particles"
		checkbox chk_collision_with_world_will_break_me "Break on world collisions" 
		checkbox chk_detach_children "Detach Children" 
		checkbox chk_destroy_children "Destroy Children"
		group "Replacements" (
			edittext txt_replace "Replacement"
			label lbl_DirectionalReplacements "Directional Replacements"
			dotnetcontrol lv_DirectionReplacements "listview" height:150
			button btn_AddReplacement "Add" across:2 
			button btn_DeleteReplacement "Delete" 

			edittext txt_DirectionalReplacementName "Replacement"
			dropdownlist dpdn_DirectionalReplacementAxis "Hit Direction" items:#("+X", "-X", "+Y", "-Y", "+Z", "-Z") 
		)

		fn RefreshReplacementsList = (
			lv_DirectionReplacements.Items.clear()
			for i =1 to directional_replacements.count do (
				lvitem = dotNetObject "listviewitem" directional_replacements[i]
				lvitem.subitems.add directional_replacements_direction[i]
				lv_DirectionReplacements.Items.add lvitem
			)
		)
		on btn_AddReplacement pressed do (
			append directional_replacements "AccessoryName"
			append directional_replacements_direction "+X"
			RefreshReplacementsList()
		)
		on btn_DeleteShape pressed do (
			if lv_DirectionReplacements.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_DirectionReplacements.SelectedIndices.Item[0]
				deleteItem directional_replacements (selectedIndex+1)
				deleteItem directional_replacements_direction (selectedIndex+1)
				refreshShapesList()
			)
		)
		on txt_DirectionalReplacementName changed value do (
			if lv_DirectionReplacements.SelectedIndices.count > 0 then
			(
				local i = lv_DirectionReplacements.SelectedIndices.Item[0]
				local i2 = i + 1
				directional_replacements[i2] = value
				lv_DirectionReplacements.Items.Item[i].subitems.item[0].Text = value
			)
		)
		on dpdn_DirectionalReplacementAxis selected selectedIndex do (
			if lv_DirectionReplacements.SelectedIndices.count > 0 then (
				local i = lv_DirectionReplacements.SelectedIndices.Item[0]
				local i2 = i + 1
				directional_replacements_direction[i2] = dpdn_DirectionalReplacementAxis.Items[selectedIndex]
				lv_DirectionReplacements.Items.Item[i].subitems.item[1].Text = dpdn_DirectionalReplacementAxis.Items[selectedIndex]
			)
		)

		on lv_DirectionReplacements selectedindexchanged do (

			if lv_DirectionReplacements.SelectedIndices.count > 0 then (
				local i = lv_DirectionReplacements.SelectedIndices.Item[0]
				local i2 = i + 1
				txt_DirectionalReplacementName.text = directional_replacements[i2]
				dpdn_DirectionalReplacementAxis.selection = finditem dpdn_DirectionalReplacementAxis.items directional_replacements_direction[i2]
			)	
		)
		on mainbreakablerollout open do(

			lv_DirectionReplacements.view  = (dotnetclass "view").details
			lv_DirectionReplacements.fullrowselect= true
			lv_DirectionReplacements.gridlines = true
			lv_DirectionReplacements.multiselect =false
			lv_DirectionReplacements.columns.add "Name" 140
			lv_DirectionReplacements.columns.add "Axis" 40

			RefreshReplacementsList()
		)

	)
)
AccessoryDynamicsAttribute = attributes AccessoryDynamicsCustAttrib attribid:#(0x2944a50e, 0x438ecc79) version:1
(
	parameters main rollout:mainacessorydynamicsrollout (
		CentreOfMassHelper type:#maxobject
		moments type:#point3 default:[0,0,0]
		mass type:#float default: 1000 ui:spn_mass
		solid type:#boolean default:false ui:chk_solid
		inf_mi type:#boolean default:false ui:chk_inf_mi
		inf_mass type:#boolean default:false ui:chk_inf_mass
		drivable_on type:#boolean default:true ui:chk_drivable_on
		part_of_world type:#boolean default:false ui:chk_part_of_world
		stop_sinking_into_ground type:#boolean default:false ui:chk_stop_sinking_into_ground
		ignore_gravity type:#boolean default:false ui:chk_ignore_gravity
		ignore_world type:#boolean default:false ui:chk_ignore_world
		ignore_group type:#boolean default:false ui:chk_ignore_group
		group type:#intTab tabsizevariable:true
		buoyant type:#boolean default:false; ui:chk_buoyant
		buoyancy_relative_to_com type:#point3 default:[0,0,0]
		sphere_rolling_resistance type:#float default:0 ui:spn_sphere_rolling_resistance
		substance type:#integer default:0 ui:spn_substance
		linear_acceleration type:#point3
		regular_acceleration type:#point3
		collisionshapes type:#maxObjectTab tabsizevariable:true

	)

	fn GuessMoments = (
		ownerObject = (refs.dependentNodes (custAttributes.getOwner this))[1]
		bounds = nodeGetBoundingBox ownerObject ownerObject.transform

		extents = bounds[2] - bounds[1]
		Moments.x = (1.0/12.0) * (Mass as float) * (extents.y * extents.y + extents.z * extents.z)
		Moments.y = (1.0/12.0) * (Mass as float) * (extents.x * extents.x + extents.z * extents.z)
		Moments.z = (1.0/12.0) * (Mass as float) * (extents.y * extents.y + extents.x * extents.x)

		select ownerObject
	)
	rollout mainacessorydynamicsrollout "Accesory Dynamics" (
		group "Options" (
			checkbox chk_solid "Solid" across:2
			checkbox chk_part_of_world "Part Of World" across:2
			checkbox chk_inf_mass "Infinite Mass" across:2
			checkbox chk_inf_mi "Infinite MI" across:2
			checkbox chk_drivable_on "Drivable On" across:2
			checkbox chk_stop_sinking_into_ground "Dont Sink In Ground" across:2
			checkbox chk_buoyant "Buoyant" across:2
			checkbox chk_ignore_gravity "Ignore Gravity" across:2
			checkbox chk_ignore_world "Ignore World" across:2
			checkbox chk_ignore_group "Ignore Group" across:2
		)

		group "Properties" (

			label lbl_Moments "Moments Of Inertia"
			spinner spn_MomentsX "X" across:1 width:110 type:#float range:[0,100000000,0]
			spinner spn_MomentsY "Y" across:1 width:110 type:#float range:[0,100000000,0]
			spinner spn_MomentsZ "Z" across:1 width:110 type:#float range:[0,100000000,0]
			button btn_GuessMoments "Estimate Moments"
			spinner spn_mass "Mass" type:#float range:[0,10000000,0]
			spinner spn_sphere_rolling_resistance "Sphere Rolling Resistance" type:#float range:[0,1000000,0]
			button btn_SelectCentreOfMassHelper "Select CoM Helper"

			spinner spn_BuoyancyX "X" width:110 type:#float range:[0,100000,0]
			spinner spn_BuoyancyY "Y" width:110 type:#float range:[0,100000,0]
			spinner spn_BuoyancyZ "Z" width:110 type:#float range:[0,100000,0]

			spinner spn_substance "Substance Type" type:#integer range:[0,1000,0]
		)

		group "Collision Shapes" (

			pickbutton pck_AddShape "Add"
			button btn_DeleteShape "Delete"
			dotNetControl lv_shapes	 "listview" height:150
		)

		fn refreshShapesList = (
			if lv_shapes == null or lv_shapes.items == null then (

				lv_shapes.view  = (dotnetclass "view").details
				lv_shapes.fullrowselect= true
				lv_shapes.gridlines = true
				lv_shapes.multiselect =false
				lv_shapes.columns.add "Name" 140
			)
			lv_shapes.Items.clear()
			for shape in collisionshapes do (
				lvItem = dotnetobject "listviewitem" shape.node.name
				lv_shapes.Items.add lvitem
			)
		)
		fn AddCollisionShape obj= (
			
			if obj.modifiers["Accessory Shape"] == undefined then (
				AddAccessoryShapeModifier obj 
				modPanel.setCurrentObject (refs.dependents this)[1]
			)
			existingShape = for oldshape in CollisionShapes where oldshape.node == obj collect oldshape

			if(existingShape == undefined or existingShape.count == 0) then
			(
				append CollisionShapes (NodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
			)
		)

		on pck_AddCollisionShape picked obj do (
			AddCollisionShape obj
			refreshShapesList()
		)
		on btn_SelectCollisionShape pressed do (
			if lv_shapes.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_shapes.SelectedIndices.Item[0]
				select CollisionShapes[selectedIndex+1].node
				
			)
		)
		on btn_DeleteCollisionShape pressed do (
			if lv_shapes.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_shapes.SelectedIndices.Item[0]
				deleteItem CollisionShapes (selectedIndex+1)
				refreshShapesList()
			)
		)
		fn UpdateCoMButtonLabel = (
			if CentreOfMassHelper == undefined or CentreOfMassHelper.node == undefined or isDeleted CentreOfMassHelper.node then (
				btn_SelectCentreOfMassHelper.text="Create CoM Helper"
			)
			else (
				btn_SelectCentreOfMassHelper.text="Select CoM Helper"
			)
		)

		fn CreateCoMHelper = (
			accessoryNode = (refs.dependentNodes (refs.dependents this)[1])[1]
			newDummyPosition = accessoryNode.pos
			newDummy = point prefix:("_CoMHelper") position:newDummyPosition
			newDummy.size = 1
			--newDummy.axistripod = true
			newDummy.axistripod = true
			newDummy.box = true
			CentreOfMassHelper = NodeTransformMonitor node:newDummy forwardtransformchangemsgs:false

			UpdateCoMButtonLabel()

		)
		fn SelectCoMHelper = (
			if CentreOfMassHelper == undefined or CentreOfMassHelper.node == undefined or isDeleted CentreOfMassHelper.node then (
				UpdateCoMButtonLabel()
			)
			else (
				select CentreOfMassHelper.node
			)
		)

		on btn_SelectCentreOfMassHelper pressed do (
			if CentreOfMassHelper == undefined or CentreOfMassHelper.node == undefined or isDeleted CentreOfMassHelper.node then (
				CreateCoMHelper()
			)
			else (
				SelectCoMHelper()
			)
		)
		fn GuessMoments = (
			ownerObject = (refs.dependentNodes (custAttributes.getOwner this))[1]
			bounds = nodeGetBoundingBox ownerObject ownerObject.transform

			extents = bounds[2] - bounds[1]
			Moments.x = (1.0/12.0) * (Mass as float) * (extents.y * extents.y + extents.z * extents.z)
			Moments.y = (1.0/12.0) * (Mass as float) * (extents.x * extents.x + extents.z * extents.z)
			Moments.z = (1.0/12.0) * (Mass as float) * (extents.y * extents.y + extents.x * extents.x)

			select ownerObject
		)

		on btn_GuessMoments pressed do (
			GuessMoments()
		)
		on pck_AddShape picked obj do (
			AddCollisionShape obj
			refreshShapesList()
		)
		on btn_DeleteShape pressed do (
			if lv_shapes.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_shapes.SelectedIndices.Item[0]
				deleteItem collisionshapes (selectedIndex+1)
				refreshShapesList()
			)
		)
		on mainacessorydynamicsrollout open do (
			UpdateCoMButtonLabel()

			lv_shapes.view  = (dotnetclass "view").details
			lv_shapes.fullrowselect= true
			lv_shapes.gridlines = true
			lv_shapes.multiselect =false
			lv_shapes.columns.add "Name" 140
			refreshShapesList()
		)
	)
)
AccessoryTXTAttribute = attributes AccessoryTXTCustAttrib attribid:#(0x7904a50e, 0x438e5c79) version:1
(

	parameters main rollout:mainaccessoryrollout (
		StopSinkingIntoTheGround type:#boolean default:false ui:chk_StopSinking
		DrivableOn type:#boolean default:false ui:chk_DrivableOn
		PartOfWorld type:#boolean default:false ui:chk_PartOfWorld
		Solid type:#boolean default:false ui:chk_Solid
		Moments type:#point3 default:[0,0,0]
		Mass type:#integer default:100 ui:spn_Mass
		CentreOfMassHelper type:#maxobject
		CollisionShapes type:#maxObjectTab tabsizevariable:true
		Joints type:#string ui:txt_Joints
		UseRBA type:#boolean ui:chk_UseRBA default:false
		RBAFilename type:#string ui:txt_RBAFilename 
		RBALooping type:#boolean ui:chk_RBALooping default:false
		HitToTrigger type:#boolean ui:chk_HitToTrigger default:false
		ForceTarget type:#boolean ui:chk_ForceTarget default:false
		MaxAcceleration type:#float ui:spn_MaxAcceleration default:0
		MaxAngularAcceleration type:#float ui:spn_MaxAngularAcceleration default:0
		BreakFactor type:#float ui:spn_BreakFactor default:0
		MessageTriggered type:#string ui:txt_MessageTriggered default:""

	)
	fn GetAccessoryObject = (
		ownerObject = (refs.dependentNodes (custAttributes.getOwner this))[1]

		accessoryObject = AccessoryFileLump()
		accessoryObject.StopSinkingIntoTheGround = StopSinkingIntoTheGround
		accessoryObject.drivable_on = DrivableOn
		accessoryObject.PartOfWorld = PartOfWorld
		accessoryObject.Solid = Solid
		accessoryObject.Moments = Moments
		accessoryObject.Mass = Mass
		in coordsys ownerObject (
			accessoryObject.CentreOfMass = CentreOfMassHelper.node.position
		)
		accessoryObject.Joints = Joints	
		accessoryObject.UseRBA =UseRBA
		accessoryObject.anim =RBAFilename
		accessoryObject.looping =RBALooping
		accessoryObject.hit_to_trigger =HitToTrigger
		accessoryObject.force_target =ForceTarget
		accessoryObject.max_acceleration =MaxAcceleration
		accessoryObject.max_angular_acceleration =MaxAngularAcceleration
		accessoryObject.break_factor =BreakFactor
		accessoryObject.message_triggered =MessageTriggered
		accessoryObject
	)
	fn GuessMoments = (
		ownerObject = (refs.dependentNodes (custAttributes.getOwner this))[1]
		bounds = nodeGetBoundingBox ownerObject ownerObject.transform

		extents = bounds[2] - bounds[1]
		Moments.x = (1.0/12.0) * (Mass as float) * (extents.y * extents.y + extents.z * extents.z)
		Moments.y = (1.0/12.0) * (Mass as float) * (extents.x * extents.x + extents.z * extents.z)
		Moments.z = (1.0/12.0) * (Mass as float) * (extents.y * extents.y + extents.x * extents.x)

		select ownerObject
	)
	fn AddCollisionShape obj= (
		if obj.modifiers["Accessory Shape"] == undefined then (
			AddAccessoryShapeModifier obj 
		)
		existingShape = for oldshape in CollisionShapes where oldshape.node == obj collect oldshape

		if(existingShape == undefined or existingShape.count == 0) then
		(
			append CollisionShapes (NodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
		)
	)
	fn SetDefaultJoint = (
		Joints = "<world_joint>\njoint\n771\n0.000000\n0.917262,-0.400000,-0.000526\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\n1\n1\n0.850000\n0.000000\n0.000000,1.000000,0.000000\n0.000000,1.000000,0.000000\n0.000000\nBreakJoint\n0.000000,0.000000,0.000000\n0.000000,0.000000,0.000000\nweakness\nConstraintForceWeaknessCallBack\n0.000000,0.000000,0.000000\n1000000.000000\nConstraintTorqueWeaknessNoTwistCallBack\n0.000000,0.000000,0.000000\n30000.000000"
	)
	rollout mainaccessoryrollout "Accessory" (
		checkbox chk_StopSinking "Stop Sinking Into Ground"
		checkbox chk_DrivableOn "Drivable On"
		checkbox chk_PartOfWorld "Part Of World"
		checkbox chk_Solid "Solid"
		spinner spn_Mass "Mass" type:#integer range:[0,10000000,0]
		label lbl_Moments "Moments Of Inertia"
		spinner spn_MomentsX "X" across:1 width:110 type:#float range:[0,100000000,0]
		spinner spn_MomentsY "Y" across:1 width:110 type:#float range:[0,100000000,0]
		spinner spn_MomentsZ "Z" across:1 width:110 type:#float range:[0,100000000,0]
		button btn_GuessMoments "Estimate Moments"
		pickbutton pck_CentreOfMassHelper "Centre of Mass"
		button btn_DefaultJoint "Set Default Joint"
		edittext txt_Joints "Joints Data" Labelontop:true  height:200
		pickbutton pck_AddShape "Add Collision Shape"

		Group "RBA" (
			checkbox chk_UseRBA "Use RBA Animation"
			edittext txt_RBAFilename "RBA Filename"
			checkbox chk_RBALooping "Looping"
			checkbox chk_HitToTrigger "Hit To Trigger"
			checkbox chk_ForceTarget "Force Target (?)"
			spinner spn_MaxAcceleration "Max Acceleration" type:#float range:[0,1000000,0]
			spinner spn_MaxAngularAcceleration "Max Angular Acceleration" type:#float range:[0,10000, 0]
			spinner spn_BreakFactor "BreakFactor" type:#float range:[0,10000,0]
			edittext txt_MessageTriggered "Message Trigger"

		)

		on btn_GuessMoments pressed do (
			GuessMoments()
			spn_MomentsX.value = Moments.x
			spn_MomentsY.value = Moments.y
			spn_MomentsZ.value = Moments.z
		)
		on btn_DefaultJoint pressed do (
			SetDefaultJoint()
		)
		on mainaccessoryrollout open do (
			spn_MomentsX.value = Moments.x
			spn_MomentsY.value = Moments.y
			spn_MomentsZ.value = Moments.z

		)

		on spn_MomentsX changed val do (
			Moments.x = val
		)
		on spn_MomentsY changed val do (
			Moments.y = val
		)
		on spn_MomentsZ changed val do (
			Moments.z = val
		)
		on pck_AddShape picked obj do (
			AddCollisionShape obj
		)

	)
)

fn AddAccessoryCheckpointAppData obj = (
	accessoryModifier = AddCustomModifier obj "Checkpoint Accessory Data" AccessoryCheckpointAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryManagedAppData obj = (
	accessoryModifier = AddCustomModifier obj "Managed Accessory Data" AccessoryManagedAccessoryAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryAngularDampedAppData obj = (
	accessoryModifier = AddCustomModifier obj "Angular Damped Accessory Data" AccessoryangulardampedAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryRotatingAppData obj = (
	accessoryModifier = AddCustomModifier obj "Rotating Accessory Data" AccessoryRotatingAccessoryAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryPowerupAppData obj = (
	accessoryModifier = AddCustomModifier obj "Powerup Accessory Data" AccessoryPowerUpAccessoryAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryAnimatedAppData obj = (
	accessoryModifier = AddCustomModifier obj "Animated Accessory Data" AccessoryAnimatedAccessoryAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryRockingAppData obj = (
	accessoryModifier = AddCustomModifier obj "Rocking Accessory Data" AccessoryAnimatedAccessoryAttribute
	custattributes.add accessoryModifier AccessoryStandardAccessoryAttribute baseObject:false
)

fn AddAccessoryExplodingAppData obj = (
	AddCustomModifier obj "Exploding Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryBicycleAppData obj = (
	AddCustomModifier obj "Bicycle Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryConveyorAppData obj = (
	AddCustomModifier obj "Conveyor Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryCopSpawnAppData obj = (
	AddCustomModifier obj "Cop Spawn Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryMultiplaterSpawnAppData obj = (
	AddCustomModifier obj "Multiplayer Spawn Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryTrailerSpawnAppData obj = (
	AddCustomModifier obj "Trailer Spawn Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryStartingGridAppData obj = (
	AddCustomModifier obj "Starting Grid Accessory" AccessoryNoDataAttribute
)
fn AddAccessoryStandardAppData obj = (
	AddCustomModifier obj "Standard Accessory Data" AccessoryStandardAccessoryAttribute
)

fn AddAccessoryDynamicsModifier obj = (

	accessoryModifier = obj.modifiers["Accessory Dynamics"]
	if accessoryModifier == undefined then (
		max modify mode
		accessoryModifier = emptyModifier()
		
		accessoryModifier.name = "Accessory Dynamics"
		addModifier obj accessoryModifier
		custattributes.add accessoryModifier AccessoryDynamicsAttribute baseObject:false
	)
	accessoryModifier
)
fn AddAccessoryBreakableModifier obj = (

	accessoryModifier = obj.modifiers["Accessory Breakable"]
	if accessoryModifier == undefined then (
		max modify mode
		accessoryModifier = emptyModifier()
		
		accessoryModifier.name = "Accessory Breakable"
		addModifier obj accessoryModifier
		custattributes.add accessoryModifier AccessoryBreakableAttribute baseObject:false
	)
	accessoryModifier
)
fn AddAccessoryTXTModifier obj = (

	accessoryModifier = obj.modifiers["Accessory Settings"]
	if accessoryModifier == undefined then (
		max modify mode
		accessoryModifier = emptyModifier()
		
		accessoryModifier.name = "Accessory Settings"
		addModifier obj accessoryModifier
		custattributes.add accessoryModifier AccessoryTXTAttribute baseObject:false
	)
	accessoryModifier
)