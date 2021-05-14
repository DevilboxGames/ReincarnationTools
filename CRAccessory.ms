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
struct AccessoryJoiny_Weakness (
	Type,						-- string
	p3_Unknown,					-- point3
	strength,					-- float
	twistStrength				-- float
)
struct AccessoryShape
(
	Type,
	Points = #(),
	Radius,
	Part
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
	p3_Unknown2 					-- point3
)
struct AccessoryJoint (
	type,							--string: world or child
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
	weakness2		     			-- AccessoryJoint_Constraint
)

struct AccessoryType_RotatingAccessory (
	Speed								--float
)
struct AccessoryType_AngularDampedAccessory (
	Damper								--float
)

struct AccessoryType_Checkpoint (
	top,								--Int
	bottom,								--Int
	left,								--Int
	right,								--Int
	deactivated,						--String
	next								--String

)

struct AccessoryType_ManagedAccessory (
	break_fuse,							--Float
	management_policy,					--String
	trigger_particles					--String
)

struct AccessoryType_Powerup (
	type,								--String
	respawn_time						--Float
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
	message_triggered					--string
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
	special_flags						--int
	
)
struct CustomAccessoryBlock
(
	Type,
	Data
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
AccessoryBreakableAttribute = attributes AccessoryBreakableCustAttrib attribid:#(0x43628563, 0x36485726) version:1
(
	parameters main rollout:mainbreakablerollout (
		break_impulse type:#float default:100 ui:spn_break_impulse
		replace type:#string ui:txt_replace
		directional_replacements type:#stringtab tabsizevariable:true
		directional_replacements_direction type:#stringtab tabsizevariable:true
		explode_force type:#float default:0 ui:spn_explode_force
		trigger_particles type:#boolean default:false ui:chk_trigger_particles
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
		checkbox chk_detach_children "Detach Children" 
		checkbox chk_destroy_children "Destroy Children"
		edittext txt_replace "Replacement"

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

		fn UpdateCoMButtonLabel = (
			if CentreOfMassHelper == undefined or CentreOfMassHelper.node == undefined or isDeleted CentreOfMassHelper.node then (
				btn_SelectCentreOfMassHelper.text="Create CoM Helper"
			)
			else (
				btn_SelectCentreOfMassHelper.text="Select CoM Helper"
			)
		)

		fn CreateCoMHelper = (
			UpdateCoMButtonLabel()
			newDummy = point prefix:("_CoMHelper") position:newDummyPosition scale:scale rotation:((EulerAngles rot.x rot.y rot.z) as quat)					
			newDummy.size = 1
			--newDummy.axistripod = true
			newDummy.cross = true

		)
		fn SelectCoMHelper = (
			select CentreOfMassHelper
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
		fn refreshShapesList = (
			lv_shapes.Items.clear()
			for shape in collisionshapes do (
				lvItem = dotnetobject "listviewitem" shape.name
				lv_Layers.Items.add lvitem
			)
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
				deleteItem lv_shapes (selectedIndex+1)
				refreshShapesList()
			)
		)
		on mainacessorydynamicsrollout open do (
			UodateCoMButtonLabel()

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