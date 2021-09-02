fn ParseStructurePartCData cData obj carroot:undefined =
(
	--format "Part CData: %\n\n" cData
	splitCData = filterstring cdata "\n"
	structMod = obj.modifiers["Car Structure Part"]
	for i =1 to splitcdata.count do
	(
		--format "\nline #% of cdata: %\n" i splitcdata[i]
		splitLine = filterstring splitcdata[i] ":()"
		
		if splitline.count > 1 then
		(
			objectType = (filterstring splitLine[1] "\t ")
			if objectType[1][1] == "-" and objectType[1][2]=="-" then
			(
				--format "This line is a comment: %\n" splitcdata[i]
				continue
			)
			 case (tolower splitline[2]) of
			(
				"set_crushability":
				(
					--format "value %\n" ((filterstring splitline[3] " ")[1] as float)
					obj.modifiers["Car Structure Part"].Crushability = ((filterstring splitline[3] " ")[1] as float)
					obj.modifiers["Car Structure Part"].Crushability_Set = true
				)
				"set_stiffness":
				(
					obj.modifiers["Car Structure Part"].Stiffness = ((filterstring splitline[3] " ")[1] as float)
					obj.modifiers["Car Structure Part"].Stiffness_Set = true
				)
				"set_resiliance":
				(
					obj.modifiers["Car Structure Part"].Resiliance_Set = true
					obj.modifiers["Car Structure Part"].Resiliance =  ((filterstring splitline[3] " ")[1] as float)
				)
				"set_restitution":
				(
					obj.modifiers["Car Structure Part"].Restitution_set = true
					obj.modifiers["Car Structure Part"].Restitution = ((filterstring splitline[3] " ")[1] as float)
				)
				"set_mass":
				(
					obj.modifiers["Car Structure Part"].Mass_set=true
					obj.modifiers["Car Structure Part"].mass = ((filterstring splitline[3] " ")[1] as float)
				)
				"set_centreofmass":
				(
					Format "Fuck this shit: not implemented yet\n"
				)
				"add_physicsproperty":
				(
					--format "%: add physics property %\n" obj.name splitline[3]
					physPropString = (filterstring splitline[3] "\" ")[1]
					if (finditem obj.modifiers["Car Structure Part"].PhysicsProperties physPropString) < 1 then (
						append obj.modifiers["Car Structure Part"].PhysicsProperties physPropString
						append obj.modifiers["Car Structure Part"].PhysicsPropertyIndices 0
						append obj.modifiers["Car Structure Part"].PhysicsPropertyIsIndexed false
					)
				)
				"add_indexedphysicsproperty":
				(
					--format "%: add indexed physics property %\n" obj.name splitline[3]
					
					physPropString = (filterstring splitline[3] "\", ")
					local physPropertyIndex = finditem obj.modifiers["Car Structure Part"].PhysicsProperties physPropString[1]
					if (physPropertyIndex) < 1 then (
						append obj.modifiers["Car Structure Part"].PhysicsProperties physPropString[1]
						append obj.modifiers["Car Structure Part"].PhysicsPropertyIndices (physPropString[2] as integer)
						append obj.modifiers["Car Structure Part"].PhysicsPropertyIsIndexed true
						--format "\t%: physics props set to %, %\n" obj.name obj.modifiers["Car Structure Part"].PhysicsProperties[obj.modifiers["Car Structure Part"].PhysicsProperties.count] obj.modifiers["Car Structure Part"].PhysicsPropertyIndices[obj.modifiers["Car Structure Part"].PhysicsPropertyIndices.count]
					)
					else (
						obj.modifiers["Car Structure Part"].PhysicsPropertyIndices[physPropertyIndex] = (physPropString[2] as integer)
					)
				)
				"set_shapetype":
				(
					obj.modifiers["Car Structure Part"].ShapeType = (filterstring splitline[3] " \"")[1]
					
				)
				"set_alwaysjointed":
				(
					isJointed = (filterstring splitline[3] " ")[1]
					if isJointed=="true" then obj.modifiers["Car Structure Part"].AlwaysJointed = true
					else obj.modifiers["Car Structure Part"].AlwaysJointed = false
				)
				"set_crushdamagesoundsubcat":
				(
					obj.modifiers["Car Structure Part"].CrushDamageSoundSubCat = (filterstring splitline[3] " \"")[1]
				)
				"set_soundconfigfile":
				(
					obj.modifiers["Car Structure Part"].SoundConfigFile = (filterstring splitline[3] " \"")[1]
				)
				"add_crushdamagematerial":
				(
					splitArguments = filterstring splitline[3] ", \""
					append obj.modifiers["Car Structure Part"].CrushDamageMaterialLevel (splitArguments[1] as integer)
					append obj.modifiers["Car Structure Part"].CrushDamageMaterialOriginalMaterial splitArguments[2]
					append obj.modifiers["Car Structure Part"].CrushDamageMaterialTargetMaterial splitArguments[3]
				)
				"add_crushdamageemitter":
				(
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_CrushEmitterPoint"
					newDummyPosition =  ( (ConvertFromCRSpace [splitArguments[3] as float,splitArguments[4] as float,splitArguments[5] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					append obj.modifiers["Car Structure Part"].CrushDamageEmitterLevel (splitArguments[1] as integer)
					append obj.modifiers["Car Structure Part"].CrushDamageEmitterName splitArguments[2]
					append obj.modifiers["Car Structure Part"].CrushDamageEmitterPosition (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"add_detachpartemitter":
				(
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_DetachPartEmitterPoint"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					append obj.modifiers["Car Structure Part"].DetachPartEmitterName splitArguments[1]
					append obj.modifiers["Car Structure Part"].DetachPartEmitterPosition (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					append obj.modifiers["Car Structure Part"].DetachPartEmitterFactor (splitArguments[5] as float)
				)
				"add_detachparentemitter":
				(
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_DetachParentEmitterPoint"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.parent.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					append obj.modifiers["Car Structure Part"].DetachParentEmitterName splitArguments[1]
					append obj.modifiers["Car Structure Part"].DetachParentEmitterPosition (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					append obj.modifiers["Car Structure Part"].DetachParentEmitterFactor (splitArguments[5] as float)
				)
				"add_functionallight":
				(
					splitArguments = filterstring splitline[3] ", \""
					append obj.modifiers["Car Structure Part"].FunctionalLightType splitArguments[1]
					
					append obj.modifiers["Car Structure Part"].FunctionalLightObject (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[2]) forwardTransformChangeMsgs:false)
				)
				"set_driverejectionsmash":
				(
					isTrue = (filterstring splitline[3] " ")[1]
					--format "Driver Ejection Smash isTrue: \"%\"\n" isTrue
					if isTrue=="true" then obj.modifiers["Car Structure Part"].DriverEjectionSmash = true
					else obj.modifiers["Car Structure Part"].DriverEjectionSmash = false
				)
				"add_vehiclesimpleweapon":
				(
					splitArguments = filterstring splitline[3] ", \""
					obj.modifiers["Car Structure Part"].VehicleSimpleWeapon_Set = true
					obj.modifiers["Car Structure Part"].VehicleSimpleWeapon = splitArguments[1] as float
				)
				"add_vehicleweapon":
				(
					splitArguments = filterstring splitline[3] ", \""
					append obj.modifiers["Car Structure Part"].WeaponType "Vehicle"
					append obj.modifiers["Car Structure Part"].WeaponName splitArguments[1]
					append obj.modifiers["Car Structure Part"].WeaponDmgType splitArguments[2]
					append obj.modifiers["Car Structure Part"].WeaponVector [splitArguments[3] as float, splitArguments[4] as float, splitArguments[5] as float]
				)
				"add_accessoryweapon":
				(
					splitArguments = filterstring splitline[3] ", \""
					append obj.modifiers["Car Structure Part"].WeaponType "Accessory"
					append obj.modifiers["Car Structure Part"].WeaponName splitArguments[1]
					append obj.modifiers["Car Structure Part"].WeaponDmgType  splitArguments[2]
					append obj.modifiers["Car Structure Part"].WeaponVector [splitArguments[3] as float, splitArguments[4] as float, splitArguments[5] as float]
				)
				"add_pedweapon":
				(
					splitArguments = filterstring splitline[3] ", \""
					append obj.modifiers["Car Structure Part"].WeaponType "Ped"
					append obj.modifiers["Car Structure Part"].WeaponName splitArguments[1]
					append obj.modifiers["Car Structure Part"].WeaponDmgType splitArguments[2]
					append obj.modifiers["Car Structure Part"].WeaponVector [splitArguments[3] as float, splitArguments[4] as float, splitArguments[5] as float]
				)
				"add_driverboxvertexcolour":
				(
					colourParts = filterstring splitline[3] ", "
					r = colourParts[1] as integer
					g = colourParts[2] as integer
					b = colourParts[3] as integer
					a = colourParts[4] as integer
					append obj.modifiers["Car Structure Part"].DriverBoxVertexColour_R r
					append obj.modifiers["Car Structure Part"].DriverBoxVertexColour_G g
					append obj.modifiers["Car Structure Part"].DriverBoxVertexColour_B b
					append obj.modifiers["Car Structure Part"].DriverBoxVertexColour_A a
					
				)
				"set_gangedwheelrotation":
				(
					format "===setting ganged rotation % / %\n" splitline[3] (filterstring splitline[3] ", \"")[1]
					obj.modifiers["Car Structure Part"].GangedRotation = (filterstring splitline[3] ", \"")[1]
				)
				"set_gangedwheelsuspension":
				(
					format "===setting ganged suspension % / %\n" splitline[3] (filterstring splitline[3] ", \"")[1]
					obj.modifiers["Car Structure Part"].GangedSuspension = (filterstring splitline[3] ", \"")[1]
				)
				"set_gangedwheelsteering":
				(
					format "===setting ganged steering % / %\n" splitline[3] (filterstring splitline[3] ", \"")[1]
					obj.modifiers["Car Structure Part"].GangedSteering = (filterstring splitline[3] ", \"")[1]
				)
				"set_steeringproportion":
				(
					obj.modifiers["Car Structure Part"].SteeringProportion = (filterstring splitline[3] ", \"")[1] as float
				)
				"set_caterpillartrack_roadwheel":
				(

					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelType = "Road Wheel"
					local values = filterstring splitline[3] ", "
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelIndex = values[1] as integer
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelRadius = values[2] as float
				)
				"set_caterpillartrack_drivewheel":
				(

					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelType = "Drive Wheel"
					local values = filterstring splitline[3] ", "
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelIndex = values[1] as integer
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelRadius = values[2] as float
				)
				"set_caterpillartrack_idler":
				(

					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelType = "Idler"
					local values = filterstring splitline[3] ", "
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelIndex = values[1] as integer
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelRadius = values[2] as float
				)
				"set_caterpillartrack_returnroller":
				(

					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelType = "Return Roller"
					local values = filterstring splitline[3] ", "
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelIndex = values[1] as integer
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelRadius = values[2] as float
				)
				"set_caterpillartrack_definesspeed":
				(

					obj.modifiers["Car Structure Part"].CaterpillarTrackContributeSpeed = true
					local values = filterstring splitline[3] ", "
					obj.modifiers["Car Structure Part"].CaterpillarTrackWheelIndex = values[1] as integer
					obj.modifiers["Car Structure Part"].CaterpillarTrackSpeedContribution = values[2] as float
				)
				"set_renderlevel":
				(
					splitArguments = filterstring splitline[3] ", \""
					obj.modifiers["Car Structure Part"].RenderLevel_Set = true
					obj.modifiers["Car Structure Part"].RenderLevel = splitArguments[1] as integer
					
				)
				"add_lumprenderlevel":
				(
					splitArguments = filterstring splitline[3] ", \""
					targetNode = GetDescendantByName carRoot splitArguments[1]
					if targetNode != undefined then
					(
						append obj.modifiers["Car Structure Part"].LumpRenderLevel_Node (nodeTransformMonitor node:targetNode forwardTransformChangeMsgs:false)
						append obj.modifiers["Car Structure Part"].LumpRenderLevel_Value (splitArguments[2] as integer)
					)
				)
				"set_collisionboundsmultiplier":
				(
					splitArguments = filterstring splitline[3] ", \""
					obj.modifiers["Car Structure Part"].CollisionBoundsMultiplier_X = splitArguments[1] as float
					obj.modifiers["Car Structure Part"].CollisionBoundsMultiplier_Y = splitArguments[3] as float
					obj.modifiers["Car Structure Part"].CollisionBoundsMultiplier_Z = splitArguments[2] as float
					obj.modifiers["Car Structure Part"].CollisionBoundsMultiplier_Set = true
				)
				"set_preik_rotateinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 1
					animMod.PreIK = true
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_preik_rotateiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 2
					animMod.PreIK = true
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_preik_rotateinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 3
					animMod.PreIK = true
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_rotateinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_rotateiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_rotateinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_slideinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Slide"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Slide"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_slideiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Slide"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Slide"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_slideinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Slide"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Slide"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
				)
				"set_postik_oscillateinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Oscillate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Oscillate"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
				)
				"set_postik_oscillateiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Oscillate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Oscillate"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
				)
				"set_postik_oscillateinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Oscillate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Oscillate"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
				)
				"set_postik_rockinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rock"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rock"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					
					newDummyName= obj.name+"_PostIKRockCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[4] as float,splitArguments[5] as float,splitArguments[6] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_postik_rockiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rock"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rock"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					
					newDummyName= obj.name+"_PostIKRockCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[4] as float,splitArguments[5] as float,splitArguments[6] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
				)
				"set_postik_rockinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rock"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rock"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					
					newDummyName= obj.name+"_PostIKRockCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[4] as float,splitArguments[5] as float,splitArguments[6] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_postik_rotatevibratex":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Vibrate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Vibrate"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.minfreq = splitarguments[2] as float
					animMod.maxfreq = splitarguments[3] as float
					animMod.randomfreq = splitarguments[4] as float
					animMod.minamp = splitarguments[5] as float
					animMod.maxamp = splitarguments[6] as float
					animMod.randomamp = splitarguments[7] as float
					
					newDummyName= obj.name+"_PostIKRotateVibrateCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_postik_rotatevibratey":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Vibrate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Vibrate"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.minfreq = splitarguments[2] as float
					animMod.maxfreq = splitarguments[3] as float
					animMod.randomfreq = splitarguments[4] as float
					animMod.minamp = splitarguments[5] as float
					animMod.maxamp = splitarguments[6] as float
					animMod.randomamp = splitarguments[7] as float
					
					newDummyName= obj.name+"_PostIKRotateVibrateCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
				)
				"set_postik_rotatevibratez":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Vibrate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Vibrate"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.minfreq = splitarguments[2] as float
					animMod.maxfreq = splitarguments[3] as float
					animMod.randomfreq = splitarguments[4] as float
					animMod.minamp = splitarguments[5] as float
					animMod.maxamp = splitarguments[6] as float
					animMod.randomamp = splitarguments[7] as float
					
					newDummyName= obj.name+"_PostIKRotateVibrateCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrotateinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[3]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrotateiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[3]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrotateinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rotate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rotate"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[3]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedslideinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Slide"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Slide"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[3]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedslideiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Slide"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Slide"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[3]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedslideinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Slide"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Slide"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[3]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedoscillateinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Oscillate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Oscillate"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[4]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedoscillateiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Oscillate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Oscillate"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[4]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedoscillateinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Oscillate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Oscillate"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[4]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrockinx":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rock"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rock"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					
					newDummyName= obj.name+"_PostIKRockCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[4] as float,splitArguments[5] as float,splitArguments[6] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummyy forwardTransformChangeMsgs:false)
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[7]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrockiny":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rock"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rock"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					
					newDummyName= obj.name+"_PostIKRockCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[4] as float,splitArguments[5] as float,splitArguments[6] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[7]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrockinz":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Rock"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Rock"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.amount = splitarguments[2] as float
					animMod.amount2 = splitarguments[3] as float
					
					newDummyName= obj.name+"_PostIKRockCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[4] as float,splitArguments[5] as float,splitArguments[6] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[7]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrotatevibratex":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Vibrate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Vibrate"
					animMod.Axis = 1
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.minfreq = splitarguments[2] as float
					animMod.maxfreq = splitarguments[3] as float
					animMod.randomfreq = splitarguments[4] as float
					animMod.minamp = splitarguments[5] as float
					animMod.maxamp = splitarguments[6] as float
					animMod.randomamp = splitarguments[7] as float
					
					newDummyName= obj.name+"_PostIKRotateVibrateCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[11]) forwardTransformChangeMsgs:false)
				)
				"add_postik_namedrotatevibratey":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Vibrate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Vibrate"
					animMod.Axis = 2
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.minfreq = splitarguments[2] as float
					animMod.maxfreq = splitarguments[3] as float
					animMod.randomfreq = splitarguments[4] as float
					animMod.minamp = splitarguments[5] as float
					animMod.maxamp = splitarguments[6] as float
					animMod.randomamp = splitarguments[7] as float
					
					newDummyName= obj.name+"_PostIKRotateVibrateCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[11]) forwardTransformChangeMsgs:false)
					
				)
				"add_postik_namedrotatevibratez":
				(
					animMod = AddStructureAnimationModifer obj
					animMod.AnimationType = "Vibrate"
					animMod.AnimationTypeSelection = finditem StructureAnimationTypes "Vibrate"
					animMod.Axis = 3
					animMod.PreIK = false
					
					splitArguments = filterstring splitline[3] ", \""
					animMod.controlledby = toupper splitArguments[1]
					animMod.controlledbyselection = finditem StructureAnimationControllers animMod.controlledby
					animMod.minfreq = splitarguments[2] as float
					animMod.maxfreq = splitarguments[3] as float
					animMod.randomfreq = splitarguments[4] as float
					animMod.minamp = splitarguments[5] as float
					animMod.maxamp = splitarguments[6] as float
					animMod.randomamp = splitarguments[7] as float
					
					newDummyName= obj.name+"_PostIKRotateVibrateCentre"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					animMod.CentreOfRotation =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					animMod.UseNamedObject=true
					animMod.NamedObject= (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[11]) forwardTransformChangeMsgs:false)
				)
				"set_preik_snappointtopointonotherpart":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[1]
					p2pMod.TypeOfPointToPoint_Selection = 1
					p2pMod.PreIK=true
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_SnapPointToPoint_ThisPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj =  (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[4]) forwardTransformChangeMsgs:false)
					p2pMod.OtherObject = nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false
					
					newDummyName= obj.name+"_SnapPointToPoint_OtherPart"
										
					newDummyPosition2 = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float])  * otherObj.transform)
					newDummy2= FindObjectByPosition newDummyPosition2 notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition2						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_preik_rotatepointtolineonotherpart":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[2]
					p2pMod.TypeOfPointToPoint_Selection = 2
					p2pMod.PreIK=true
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_RotatePointToLine_ThisPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject =  (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj =  (nodeTransformMonitor node:(GetDescendantByName carRoot splitArguments[4]) forwardTransformChangeMsgs:false)
					p2pMod.OtherObject = otherObj -- nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false
					
					newDummyName= obj.name+"_RotatePointToLine_OtherPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * otherObj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject =   (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_RotatePointToLine_LineTarget"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[9] as float,splitArguments[10] as float,splitArguments[11] as float]) * otherObj.transform.rotationpart) + newDummyPosition
					newDummy3= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy3==undefined or newDummy3 == obj or newDummy3 == p2pMod.OtherObject then 
					(
						newDummy3 = point prefix:newDummyName position:newDummyPosition						
						newDummy3.size = 1
						--newDummy.axistripod = true
						newDummy3.cross = true
					)
					p2pMod.LineTargetObject =   (nodeTransformMonitor node:newDummy3 forwardTransformChangeMsgs:false)
				)
				"set_preik_rotatepointtopointonotherpart":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[3]
					p2pMod.TypeOfPointToPoint_Selection = 3
					p2pMod.PreIK=true
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_RotatePointToPoint_ThisPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject =   (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj =   GetDescendantByName carRoot splitArguments[4]
					p2pMod.OtherObject = nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false
					
					newDummyName= obj.name+"_RotatePointToPoint_OtherPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * otherObj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_postik_snappointtopointonotherpart":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[1]
					p2pMod.TypeOfPointToPoint_Selection = 1
					p2pMod.PreIK=false
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_SnapPointToPoint_ThisPart"
					posRot = (ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform
					newDummyPosition = posRot -- + obj.position -- (pretranslate obj.transform (ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float])).translation
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj = GetDescendantByName carRoot splitArguments[4]
					p2pMod.OtherObject = nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false

					--format "this obj: % - %\notherobj: % - %\n" obj obj.transform otherObj otherObj.transform
					--format "% - OtherPartPosition: % - Converted: %\n" obj.name [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float] (ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float])
					--format "Other Part: % - %\n" otherObj otherObj.position
					posRot = (ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * otherObj.transform
					--format "Rotated Positition: % - With translation: %" posRot (posRot+otherObj.position)
					
					newDummyName= obj.name+"_SnapPointToPoint_OtherPart"
					newDummyPosition2 = posRot --+ otherObj.position --(pretranslate p2pMod.OtherObject.node.transform (ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float])).translation
					--format "New Dummy 1: %\n New Dummy 2: %\n\n" newDummyPosition newDummyPosition2
					newDummy2= FindObjectByPosition newDummyPosition2 notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition2						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_postik_rotatepointtolineonotherpart":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[2]
					p2pMod.TypeOfPointToPoint_Selection = 2
					p2pMod.PreIK=false
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_RotatePointToLine_ThisPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform) -- + obj.position
					--format "% - matrix: %\n" obj obj.transform
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj =GetDescendantByName carRoot splitArguments[4]
					p2pMod.OtherObject = nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false
					
					newDummyName= obj.name+"_RotatePointToLine_OtherPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * otherObj.transform) --+ otherObj.position
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_RotatePointToLine_LineTarget"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[8] as float,splitArguments[9] as float,splitArguments[10] as float]) * otherObj.transform.rotationpart ) + newDummyPosition
					newDummy3= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy3==undefined or newDummy3 == obj or newDummy3 == p2pMod.OtherObject then 
					(
						newDummy3 = point prefix:newDummyName position:newDummyPosition						
						newDummy3.size = 1
						--newDummy.axistripod = true
						newDummy3.cross = true
					)
					p2pMod.LineTargetObject = (nodeTransformMonitor node:newDummy3 forwardTransformChangeMsgs:false)
				)
				"set_postik_rotatepointtopointonotherpart":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[3]
					p2pMod.TypeOfPointToPoint_Selection = 3
					p2pMod.PreIK=false
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_RotatePointToPoint_ThisPart"
					newDummyPosition = (ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj =GetDescendantByName carRoot splitArguments[4]
					p2pMod.OtherObject = nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false
					
					newDummyName= obj.name+"_RotatePointToPoint_OtherPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * otherObj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_postik_rotatepointtopointonotherpartwithscaling":
				(
					p2pMod = AddStructurePointToPointModifer obj
					p2pMod.TypeOfPointToPoint = StructurePointToPointValues[4]
					p2pMod.TypeOfPointToPoint_Selection = 4
					p2pMod.PreIK=false
					
					splitArguments = filterstring splitline[3] ", \""
					newDummyName= obj.name+"_RotatePointToPointWithScaling_ThisPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[1] as float,splitArguments[2] as float,splitArguments[3] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					p2pMod.PointOnThisObject = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					otherObj = GetDescendantByName carRoot splitArguments[4]
					p2pMod.OtherObject = nodeTransformMonitor node:otherObj forwardTransformChangeMsgs:false
					
					newDummyName= obj.name+"_RotatePointToPointWithScaling_OtherPart"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * otherObj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj, p2pMod.OtherObject)
					if newDummy2==undefined or newDummy2 == obj or newDummy2 == p2pMod.OtherObject then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					p2pMod.PointOnOtherObject = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_preik_wishboneupper":
				(
					wbMod = AddStructureAxleModifer obj
					wbMod.WishboneAxleType = WishboneAxelTypes[1]
					wbMod.WishboneAxleType_Selection = 1
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelNumber = splitArguments[1] as integer
					wbMod.WheelNumber_Selection = (splitArguments[1] as integer) + 1
					wbMod.PivotAxis = splitArguments[2] as integer
					wbMod.PivotAxis_Selection = (splitArguments[2] as integer) + 1
					
					newDummyName= obj.name+"_WishboneUpper_InboardPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[3] as float,splitArguments[4] as float,splitArguments[5] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.InboardPivotPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_WishboneUpper_OutboardPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[6] as float,splitArguments[7] as float,splitArguments[8] as float]) * obj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy2==undefined or newDummy2 == obj then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					wbMod.OutboardPivotPoint = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonelower":
				(
					wbMod = AddStructureAxleModifer obj
					wbMod.WishboneAxleType = WishboneAxelTypes[2]
					wbMod.WishboneAxleType_Selection = 2
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelNumber = splitArguments[1] as integer
					wbMod.WheelNumber_Selection = (splitArguments[1] as integer) + 1
					wbMod.PivotAxis = splitArguments[2] as integer
					wbMod.PivotAxis_Selection = (splitArguments[2] as integer) + 1
					
					newDummyName= obj.name+"_WishboneLower_InboardPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[3] as float,splitArguments[4] as float,splitArguments[5] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.InboardPivotPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_WishboneLower_OutboardPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[6] as float,splitArguments[7] as float,splitArguments[8] as float]) * obj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy2==undefined or newDummy2 == obj then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					wbMod.OutboardPivotPoint = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_preik_strutwishbone":
				(
					wbMod = AddStructureAxleModifer obj
					wbMod.WishboneAxleType = WishboneAxelTypes[3]
					wbMod.WishboneAxleType_Selection = 3
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelNumber = splitArguments[1] as integer
					wbMod.WheelNumber_Selection = (splitArguments[1] as integer) + 1
					wbMod.PivotAxis = splitArguments[2] as integer
					wbMod.PivotAxis_Selection = (splitArguments[2] as integer) + 1
					
					newDummyName= obj.name+"_WishboneStrut_InboardPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[3] as float,splitArguments[4] as float,splitArguments[5] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.InboardPivotPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_WishboneStrut_OutboardPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[6] as float,splitArguments[7] as float,splitArguments[8] as float]) * obj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy2==undefined or newDummy2 == obj then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					wbMod.OutboardPivotPoint = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				"set_preik_liveaxle":
				(
					wbMod = AddStructureAxleModifer obj
					wbMod.WishboneAxleType = WishboneAxelTypes[4]
					wbMod.WishboneAxleType_Selection = 4
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelNumber = splitArguments[1] as integer
					wbMod.WheelNumber_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneLiveAxle_TrailingArmMountPivot"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.InboardPivotPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountupperfl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[2]
					wbMod.MountType_Selection = 2
					wbMod.MountWheel = 0
					wbMod.MountWheel_Selection = 1
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneUpperMountPivot_FL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountupperfr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[2]
					wbMod.MountType_Selection = 2
					wbMod.MountWheel = 1
					wbMod.MountWheel_Selection = 2
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneUpperMountPivot_FR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountupperrl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[2]
					wbMod.MountType_Selection = 2
					wbMod.MountWheel = 2
					wbMod.MountWheel_Selection = 3
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneUpperMountPivot_RL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountupperrr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[2]
					wbMod.MountType_Selection = 2
					wbMod.MountWheel = 3
					wbMod.MountWheel_Selection = 4
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneUpperMountPivot_RR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountlowerfl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[1]
					wbMod.MountType_Selection = 1
					wbMod.MountWheel = 0
					wbMod.MountWheel_Selection = 1
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneLowerMountPivot_FL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountlowerfr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[1]
					wbMod.MountType_Selection = 1
					wbMod.MountWheel = 1
					wbMod.MountWheel_Selection = 2
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneLowerMountPivot_FR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountlowerrl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[1]
					wbMod.MountType_Selection = 1
					wbMod.MountWheel = 2
					wbMod.MountWheel_Selection = 3
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneLowerMountPivot_RL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_wishbonemountlowerrr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[1]
					wbMod.MountType_Selection = 1
					wbMod.MountWheel = 3
					wbMod.MountWheel_Selection = 4
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_WishboneLowerMountPivot_RR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutwishbonemountfl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[3]
					wbMod.MountType_Selection = 3
					wbMod.MountWheel = 0
					wbMod.MountWheel_Selection = 1
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutWishboneMountPivot_FL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutwishbonemountfr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[3]
					wbMod.MountType_Selection = 3
					wbMod.MountWheel = 1
					wbMod.MountWheel_Selection = 2
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutWishboneMountPivot_FR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutwishbonemountrl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[3]
					wbMod.MountType_Selection = 3
					wbMod.MountWheel = 2
					wbMod.MountWheel_Selection = 3
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutWishboneMountPivot_RL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutwishbonemountrr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[3]
					wbMod.MountType_Selection = 3
					wbMod.MountWheel = 3
					wbMod.MountWheel_Selection = 4
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutWishboneMountPivot_RR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutuppermountfl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[4]
					wbMod.MountType_Selection = 4
					wbMod.MountWheel = 0
					wbMod.MountWheel_Selection = 1
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutUpperMountPivot_FL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutuppermountfr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[4]
					wbMod.MountType_Selection = 4
					wbMod.MountWheel = 1
					wbMod.MountWheel_Selection = 2
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutUpperMountPivot_FR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutuppermountrl":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[4]
					wbMod.MountType_Selection = 4
					wbMod.MountWheel = 2
					wbMod.MountWheel_Selection = 3
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutUpperMountPivot_RL"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_strutuppermountrr":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[4]
					wbMod.MountType_Selection = 4
					wbMod.MountWheel = 3
					wbMod.MountWheel_Selection = 4
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountAxis = splitArguments[1] as integer
					wbMod.MountAxis_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_StrutUpperMountPivot_RR"
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_liveaxle_trailingarmmount":
				(
					wbMod = AddStructureWishboneMountModifer obj
					wbMod.MountType = WishboneMountTypes[5]
					wbMod.MountType_Selection =5
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.MountWheel = splitArguments[1] as integer
					wbMod.MountWheel_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_LiveAxle_TrailingArmMountPivot_"
					case wbMod.MountWheel of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
				"set_preik_liveaxle_trailingarm":
				(
					wbMod = AddStructureWishboneTrailingArmModifer obj
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelIndex = splitArguments[1] as integer
					wbMod.WheelIndex_Selection = (splitArguments[1] as integer) + 1
					
					newDummyName= obj.name+"_LiveAxle_TrailingArm_MountPivot_"
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.MountPivot = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_LiveAxle_TrailingArm_AxlePivot_"
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[5] as float,splitArguments[6] as float,splitArguments[7] as float]) * obj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy2==undefined or newDummy2 == obj then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					wbMod.AxlePivot = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
				)
				
				"set_preik_wishbonehub":
				(
					wbMod = AddStructureWishboneHubModifer obj
					wbMod.HubType = WishboneHubType[1]
					wbMod.HubType_Selection =1
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelIndex = splitArguments[1] as integer
					wbMod.WheelIndex_Selection = (splitArguments[1]  as integer) + 1
					
					wbMod.PivotAxis = splitArguments[2] as integer
					wbMod.PivotAxis_Selection = (splitArguments[2] as integer) + 1
					
					newDummyName= obj.name+"_WishboneHub_UpperPivot_"
					
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[3] as float,splitArguments[4] as float,splitArguments[5] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.UpperPivotPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_WishboneHub_LowerPivot_"
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[6] as float,splitArguments[7] as float,splitArguments[8] as float]) * obj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy2==undefined or newDummy2 == obj then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					wbMod.LowerPivotPoint = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_WishboneHub_WheelPosition_"
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[9] as float,splitArguments[10] as float,splitArguments[11] as float]) * obj.transform)
					newDummy3= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy3==undefined or newDummy3 == obj then 
					(
						newDummy3 = point prefix:newDummyName position:newDummyPosition						
						newDummy3.size = 1
						--newDummy.axistripod = true
						newDummy3.cross = true
					)
					wbMod.WheelPoint = (nodeTransformMonitor node:newDummy3 forwardTransformChangeMsgs:false)
				)
				"set_preik_struthub":
				(
					wbMod = AddStructureWishboneHubModifer obj
					wbMod.HubType = WishboneHubType[2]
					wbMod.HubType_Selection =2
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelIndex = (splitArguments[1] as integer)
					wbMod.WheelIndex_Selection = (splitArguments[1] as integer) + 1
					
					wbMod.PivotAxis = splitArguments[2] as integer
					wbMod.PivotAxis_Selection = (splitArguments[2] as integer) + 1
					
					newDummyName= obj.name+"_WishboneHub_UpperPivot_"
					
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[3] as float,splitArguments[4] as float,splitArguments[5] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.UpperPivotPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_WishboneHub_LowerPivot_"
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[6] as float,splitArguments[7] as float,splitArguments[8] as float]) * obj.transform)
					newDummy2= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy2==undefined or newDummy2 == obj then 
					(
						newDummy2 = point prefix:newDummyName position:newDummyPosition						
						newDummy2.size = 1
						--newDummy.axistripod = true
						newDummy2.cross = true
					)
					wbMod.LowerPivotPoint = (nodeTransformMonitor node:newDummy2 forwardTransformChangeMsgs:false)
					
					newDummyName= obj.name+"_StrutHub_WheelPosition_"
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[9] as float,splitArguments[10] as float,splitArguments[11] as float]) * obj.transform)
					newDummy3= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy3==undefined or newDummy3 == obj then 
					(
						newDummy3 = point prefix:newDummyName position:newDummyPosition						
						newDummy3.size = 1
						--newDummy.axistripod = true
						newDummy3.cross = true
					)
					wbMod.WheelPoint = (nodeTransformMonitor node:newDummy3 forwardTransformChangeMsgs:false)
				)
				"set_preik_liveaxle_hub":
				(
					wbMod = AddStructureWishboneHubModifer obj
					wbMod.HubType = WishboneHubType[3]
					wbMod.HubType_Selection =3
					
					splitArguments = filterstring splitline[3] ", \""
					
					wbMod.WheelIndex = splitArguments[1] as integer
					wbMod.WheelIndex_Selection = (splitArguments[1] as integer) + 1
					
					
					newDummyName= obj.name+"_LiveAxleHub_WheelPosition_"
					
					case wbMod.WheelIndex of
					(
						0: newDummyName += "FL"
						1: newDummyName += "FR"
						2: newDummyName += "RL"
						3: newDummyName += "RR"
					)
					newDummyPosition = ((ConvertFromCRSpace [splitArguments[2] as float,splitArguments[3] as float,splitArguments[4] as float]) * obj.transform)
					newDummy= FindObjectByPosition newDummyPosition notTheseObjs:#(obj)
					if newDummy==undefined or newDummy == obj then 
					(
						newDummy = point prefix:newDummyName position:newDummyPosition						
						newDummy.size = 1
						--newDummy.axistripod = true
						newDummy.cross = true
					)
					wbMod.WheelPoint = (nodeTransformMonitor node:newDummy forwardTransformChangeMsgs:false)
				)
			)
		)
		for j = 1 to splitline.count do
		(
			--format "component #%: %\n" j splitline[j]
		)
	)
)
fn ParseStructureWeldCData cData obj weldModifier =
(
	splitCData = filterstring cdata "\n"
	
	for i =1 to splitcdata.count do
	(
		--format "\nline #% of cdata: %\n" i splitcdata[i]
		splitLine = filterstring splitcdata[i] ":()"
		--format "before Splitline.count = % \n" splitLine.count
		splitLine = for i=1 to splitLine.count where (skipSpace splitLine[i]) != "" collect splitLine[i]
		
		--format "after Splitline.count = % \n\n\n" splitLine.count
		if splitline.count > 1 then
		(
			objectType = (filterstring splitLine[1] "\t ")
			if objectType[1][1] == "-" and objectType[1][2]=="-" then
			(
				--format "This line is a comment: %\n" splitcdata[i]
				continue
			)
			 case (tolower splitline[2]) of
			(
				"add_carspacevertex":
				(
					splitArguments = filterstring splitline[3] ", \""
					append weldModifier.WeldVertexType "Car"
					append weldModifier.WeldVertexPosition (ConvertFromCRSpace [splitArguments[1] as float, splitArguments[2] as float, splitArguments[3] as float])
				)
				"add_partspacevertex":
				(
					splitArguments = filterstring splitline[3] ", \""
					append weldModifier.WeldVertexType "Part"
					append weldModifier.WeldVertexPosition (ConvertFromCRSpace [splitArguments[1] as float, splitArguments[2] as float, splitArguments[3] as float])
				)
				"set_vertexcolour":
				(
					splitArguments = filterstring splitline[3] ", \""
					r = splitArguments[1] as integer
					g = splitArguments[2] as integer
					b = splitArguments[3] as integer
					a = splitArguments[4] as integer
					weldModifier.VertexColourR = r
					weldModifier.VertexColourG = g
					weldModifier.VertexColourB = b
					weldModifier.VertexColourA = a
				)
				"set_weakness":
				(
					splitArguments = filterstring splitline[3] ", \""
					weldModifier.Weakness = splitArguments[1] as float
					weldModifier.Weakness_Set = true
				)
				"set_absolutelimit":
				(
					splitArguments = filterstring splitline[3] ", \""
					weldModifier.AbsoluteLimit = splitArguments[1] as float
					weldModifier.AbsoluteLimit_Set = true
				)
				"set_break":
				(
					splitArguments = filterstring splitline[3] ", \""
					weldModifier.WeldBreak = splitArguments[1] as float
					weldModifier.WeldBreak_Set = true
				)
				"set_chanceoffailure":
				(
					splitArguments = filterstring splitline[3] ", \""
					weldModifier.ChanceOfFailure = splitArguments[1] as float
					weldModifier.ChanceOfFailure_Set = true
				)
				"add_gangedbreak":
				(
					splitArguments = filterstring splitline[3] ", \""
					weldModifier.GangedBreak = splitArguments[1]
				)
			)
		)
	)
)
fn ParseStructureJointNode xmlNode obj WeldModifier =
(
	JointObj = CreateJointHelper obj
	append WeldModifier.joints jointobj
	for i=1 to xmlnode.childnodes.count do
	(
		child = xmlnode.childnodes.item ( i-1)
		if child.nodetype == child.nodetype.cdata then
		(
			cdata = child.value
			splitCData = filterstring cdata "\n"
			
			for i =1 to splitcdata.count do
			(
				--format "\nline #% of cdata: %\n" i splitcdata[i]
				splitLine = filterstring splitcdata[i] ":()"
				
				if splitline.count > 1 then
				(
					objectType = (filterstring splitLine[1] "\t ")
					if objectType[1][1] == "-" and objectType[1][2]=="-" then
					(
						--format "This line is a comment: %\n" splitcdata[i]
						continue
					)
					case (tolower splitline[2]) of
					(
						"set_hinge":
						(
							
							isTrue = (filterstring splitline[3] " ")[1]
							--format "% Hinge Joint: %\n" jointObj.name isTrue
							if isTrue=="true" then
							(
								JointObj.JointType=1
								JointObj.JointType_Hinge=true
							)
							else JointObj.JointType_Hinge=false
							
						)
						"set_balljoint":
						(
							isTrue = (filterstring splitline[3] " ")[1]
							--format "% Ball Joint: %\n" jointObj.name  isTrue
							if isTrue=="true" then
							(
								JointObj.JointType=2
								JointObj.JointType_Ball=true
							)
							else JointObj.JointType_Ball=false
						)
						"set_uj":
						(
							isTrue = (filterstring splitline[3] " ")[1]
							--format "% UJ Joint: %\n" jointObj.name  isTrue
							if isTrue=="true" then
							(
								JointObj.JointType=3
								JointObj.JointType_UJ=true
							)
							else JointObj.JointType_UJ=false
						)
						"set_slide":
						(
							isTrue = (filterstring splitline[3] " ")[1]
							--format "% Slide Joint: %\n" jointObj.name  isTrue
							if isTrue=="true" then
							(
								JointObj.JointType=4
								JointObj.JointType_Slide=true
							)
							else JointObj.JointType_Slide=false
						)
						"set_jointlocation":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.pos = ConvertFromCRSpace [splitArguments[1] as float, splitArguments[2] as float, splitArguments[3] as float]
							JointObj.UseLocation = true
						)
						"set_jointaxis":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.JointAxis = ConvertFromCRSpace [splitArguments[1] as float, splitArguments[2] as float, splitArguments[3] as float]
							JointObj.AxisIsSet = true
							JointObj.SetTransformFromAxisAndNormal()
						)
						"set_jointnormal":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.JointNormal = ConvertFromCRSpace [splitArguments[1] as float, splitArguments[2] as float, splitArguments[3] as float]
							JointObj.UseNormal = true
							JointObj.SetTransformFromAxisAndNormal()
						)
						"set_weakness":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.weakness = splitArguments[1] as float
						)
						"set_minlimit":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.UseLimit = true
							JointObj.minLimit = splitArguments[1] as float
						)
						"set_maxlimit":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.UseLimit = true
							JointObj.maxLimit = splitArguments[1] as float
						)
						"set_minlimit2":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.UseLimit2 = true
							JointObj.minLimit2 = splitArguments[1] as float
						)
						"set_maxlimit2":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.UseLimit2 = true
							JointObj.maxLimit2 = splitArguments[1] as float
						)
						"set_mintwistlimit":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.UseTwist = true
							JointObj.minTwist = splitArguments[1] as float
						)
						"set_maxtwistlimit":
						(
							splitArguments = filterstring splitline[3] ", \""
							JointObj.UseTwist = true
							JointObj.minTwist = splitArguments[1] as float
						)
						"add_flapspring":
						(
							splitArguments = filterstring splitline[3] ", \""
							append JointObj.FlapSprings [splitArguments[1] as float,splitArguments[2] as float,0]
						)
					)
				)
			)
		)
	)
	if JointObj.UseLocation == false then JointObj.pos = obj.pos
	if JointObj.AxisIsSet == false then JointObj.JointAxis = GetJointAxisByVertexColour obj (color 255 0 0)
)
fn ParseStructureWeldNode xmlNode obj carRoot:undefined=
(
	WeldModifier = AddStructureWeldModifier obj
	
	for atr=1 to xmlnode.Attributes.count do
	(
		 attrib = xmlnode.attributes.item (atr-1)
		--format "attribute name: %\nattribute value: %\n" attrib.name attrib.value
		if (tolower (attrib.name)) == "name" then
		(
			--format "found the name attribute\n"
			weldmodifier.WeldName = attrib.value
		)
		if (tolower (attrib.name)) == "partner" then
		(
			--format "found the partner attribute: %\n" attrib.value
			partnerName = attrib.value
			partnerNode = GetDescendantByName carRoot partnerName
			weldmodifier.WeldPartner =  (nodeTransformMonitor node:partnerNode forwardTransformChangeMsgs:false)
		)
	)
	jointNum=1
	
	for i=1 to xmlnode.childnodes.count do
	(
		child = xmlnode.childnodes.item ( i-1)
		if child.nodetype == child.nodetype.cdata then
		(
			ParseStructureWeldCData child.value obj WeldModifier
		)
		else if child.name == "JOINT" then
		(
			ParseStructureJointNode child obj WeldModifier
		)
	)
)
fn ParseStructurePartNode xmlNode obj carroot:undefined =
(
	AddStructurePartModifier obj doChildren:false
	
	--format "node data:%\n\n" xmlNode.value
	
	for i=1 to xmlnode.childnodes.count do
	(
		child = xmlnode.childnodes.item ( i-1)
		if child.nodetype == child.nodetype.cdata then
		(
			ParseStructurePartCData child.value obj carroot:carroot
		)
		else
		(
			--format "childnod type: %\nchildnode data:%\n\n" child.nodetype child.value
			if child.name == "PART" then
			(
				partname=undefined
				for atr=1 to child.Attributes.count do
				(
					 attrib = child.attributes.item (atr-1)
					--format "attribute name: %\nattribute value: %\n" attrib.name attrib.value
					if (tolower (attrib.name)) == "name" then
					(
						--format "found the name attribute\n"
					partname = attrib.value
					)
				)
				--format "partname: %\n" partname
				childObj = undefined
				for i=1 to obj.children.count do
				(
					if (tolower obj.children[i].name) == (tolower partname) then
					(
						childObj = obj.children[i]
						break
					)
				)
				if childObj != undefined then
				(
					ParseStructurePartNode child childObj carroot:carroot
				)
			)
			else if child.name == "WELD" then
			(
				ParseStructureWeldNode child obj carRoot:carRoot
			)
		)

	)
)

fn MakeSureThereAreEnoughTracks obj trackCount = (
	while obj.modifiers["Car Characteristics"].SegmentDefinition_Name.count < trackCount do (
		append obj.modifiers["Car Characteristics"].SegmentDefinition_Name "Track"
		append obj.modifiers["Car Characteristics"].SegmentDefinition_SegmentPitch 0
		append obj.modifiers["Car Characteristics"].SegmentDefinition_XOffset 0
		append obj.modifiers["Car Characteristics"].SagHeight_AmbientLowestPoint 0
		append obj.modifiers["Car Characteristics"].SagHeight_LowestAllowablePoint 0
		append obj.modifiers["Car Characteristics"].DamageMode_NumParts 0
		append obj.modifiers["Car Characteristics"].DamageMode_Restitution 0
		append obj.modifiers["Car Characteristics"].DamageMode_MassPerSegment 0
		append obj.modifiers["Car Characteristics"].DamageWobble_SpeedForMaxWobble 0
		append obj.modifiers["Car Characteristics"].DamageWobble_FreqOfMaxWobble 0
		append obj.modifiers["Car Characteristics"].DamageWobble_AmpOfMaxWobble 0
		append obj.modifiers["Car Characteristics"].DamageWobble_RandomVariance 0
		append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_Enabled false
		append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_VolumeAtZero 0
		append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_SpeedAtSlopeChange 0
		append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_VolumeAtSlopeChange 0
		append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_SpeedAtMaxVolume 0
		append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_MaxVolume 0
		append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_Enabled false
		append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtZero 0
		append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_SpeedAtSlopeChange 0
		append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtSlopeChange 0
		append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_SpeedAtMaxVolume 0
		append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_MaxVolume 0
	)
)

fn ParseStructureCharacteristicsCData CData obj carRoot:carRoot =
(
	splitCData = filterstring cdata "\n"
	structMod = obj.modifiers["Car Structure Part"]
	for i =1 to splitcdata.count do
	(
		--format "\nline #% of cdata: %\n" i splitcdata[i]
		splitLine = filterstring splitcdata[i] ":()"
		if splitline.count > 1 then 
		(
			objectType = (filterstring splitLine[1] "\t ")
			if objectType[1][1] == "-" and objectType[1][2]=="-" then
			(
				--format "This line is a comment: %\n" splitcdata[i]
				continue
			)
			format "\t%\n" splitline
			case (tolower splitline[2]) of
			(
				"set_defenceagainstcars":
				(
					obj.modifiers["Car Characteristics"].DefenceAgainstCars_Active = true
					obj.modifiers["Car Characteristics"].DefenceAgainstCars = (filterstring splitline[3] " \",")[1] as float
				)
				"set_defencegeneral":
				(
					obj.modifiers["Car Characteristics"].DefenceGeneral_Active = true
					obj.modifiers["Car Characteristics"].DefenceGeneral = (filterstring splitline[3] " \",")[1] as float
				)
				"set_offence":
				(
					obj.modifiers["Car Characteristics"].Offence_Active = true
					obj.modifiers["Car Characteristics"].Offence = (filterstring splitline[3] " \",")[1] as float
				)
				"set_valuefactor":
				(
					obj.modifiers["Car Characteristics"].ValueFactor_Active = true
					obj.modifiers["Car Characteristics"].ValueFactor = (filterstring splitline[3] " \",")[1] as float
				)
				"set_wholebodydeformationfactor":
				(
					obj.modifiers["Car Characteristics"].WholeBodyDeformationFactor_Active = true
					obj.modifiers["Car Characteristics"].WholeBodyDeformationFactor = (filterstring splitline[3] " \",")[1] as float
				)
				"add_permanentpowerup":
				(
					append obj.modifiers["Car Characteristics"].PermanentPowerups (filterstring splitline[3] " \",")[1]
				)
				"set_extrafallingdamagethreshold":
				(
					obj.modifiers["Car Characteristics"].ExtraFallingDamageThreshold_Active = true
					obj.modifiers["Car Characteristics"].ExtraFallingDamageThreshold = (filterstring splitline[3] " \",")[1] as float
				)
				"set_extrafallingdamagefactor":
				(
					obj.modifiers["Car Characteristics"].ExtraFallingDamageFactor_Active = true
					obj.modifiers["Car Characteristics"].ExtraFallingDamageFactor = (filterstring splitline[3] " \",")[1] as float
				)
				"set_airbrakeminspeed":
				(
					obj.modifiers["Car Characteristics"].AirBrakeMinSpeed_Active = true
					obj.modifiers["Car Characteristics"].AirBrakeMinSpeed = (filterstring splitline[3] " \",")[1] as float
				)
				"set_airbrakemaxspeed":
				(
					obj.modifiers["Car Characteristics"].AirBrakeMaxSpeed_Active = true
					obj.modifiers["Car Characteristics"].AirBrakeMaxSpeed = (filterstring splitline[3] " \",")[1] as float
				)
				"set_airbrakeminparametric":
				(
					obj.modifiers["Car Characteristics"].AirBrakeMinParametric_Active = true
					obj.modifiers["Car Characteristics"].AirBrakeMinParametric = (filterstring splitline[3] " \",")[1] as float
				)
				"set_airbrakemovementuptime":
				(
					obj.modifiers["Car Characteristics"].AirBrakeMovementUpTime_Active = true
					obj.modifiers["Car Characteristics"].AirBrakeMovementUpTime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_airbrakemovementdowntime":
				(
					obj.modifiers["Car Characteristics"].AirBrakeMovementDownTime_Active = true
					obj.modifiers["Car Characteristics"].AirBrakeMovementDownTime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_airbrakedroptime":
				(
					obj.modifiers["Car Characteristics"].AirBrakeDropTime_Active = true
					obj.modifiers["Car Characteristics"].AirBrakeDropTime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoilupspeed":
				(
					obj.modifiers["Car Characteristics"].aerofoilupspeed_Active = true
					obj.modifiers["Car Characteristics"].aerofoilupspeed = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoildownspeed":
				(
					obj.modifiers["Car Characteristics"].aerofoildownspeed_Active = true
					obj.modifiers["Car Characteristics"].aerofoildownspeed = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoilmovementuptime":
				(
					obj.modifiers["Car Characteristics"].aerofoilmovementuptime_Active = true
					obj.modifiers["Car Characteristics"].aerofoilmovementuptime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoilmovementdowntime":
				(
					obj.modifiers["Car Characteristics"].aerofoilmovementdowntime_Active = true
					obj.modifiers["Car Characteristics"].aerofoilmovementdowntime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoil2upspeed":
				(
					obj.modifiers["Car Characteristics"].aerofoil2upspeed_Active = true
					obj.modifiers["Car Characteristics"].aerofoil2upspeed = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoil2downspeed":
				(
					obj.modifiers["Car Characteristics"].aerofoil2downspeed_Active = true
					obj.modifiers["Car Characteristics"].aerofoil2downspeed = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoil2movementuptime":
				(
					obj.modifiers["Car Characteristics"].aerofoil2movementuptime_Active =true
					obj.modifiers["Car Characteristics"].aerofoil2movementuptime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoil2movementdowntime":
				(
					obj.modifiers["Car Characteristics"].aerofoil2movementdowntime_Active = true
					obj.modifiers["Car Characteristics"].aerofoil2movementdowntime = (filterstring splitline[3] " \",")[1] as float
				)
				"set_aerofoilopensound":
				(
					obj.modifiers["Car Characteristics"].aerofoilopensound_Active = true
					obj.modifiers["Car Characteristics"].aerofoilopensound = (filterstring splitline[3] " \",")[1] 
				)
				"set_aerofoilclosesound":
				(
					obj.modifiers["Car Characteristics"].aerofoilclosesound_Active = true
					obj.modifiers["Car Characteristics"].aerofoilclosesound = (filterstring splitline[3] " \",")[1] 
				)
				"set_aerofoilsoundlump":
				(
					lumpName = (filterstring splitline[3] " \",")[1] 
					--format "===============\nAerofoilsoundlump: %\n===========\n" (GetDescendantByName carRoot lumpName)
					obj.modifiers["Car Characteristics"].aerofoilsoundlump = (nodeTransformMonitor node:(GetDescendantByName carRoot lumpName) forwardTransformChangeMsgs:false)
				)
				"set_downwardcrushingextraoffence":
				(
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].DownwardCrushingExtraOffence_Active = true
					obj.modifiers["Car Characteristics"].DownwardCrushingExtraOffence_0mph = params[1] as float
					obj.modifiers["Car Characteristics"].DownwardCrushingExtraOffence_MaxMultSpeed = params[2] as float
					obj.modifiers["Car Characteristics"].DownwardCrushingExtraOffence_MaxMult = params[3] as float
				)
				"set_damage_randomcrumplingrandommax":
				(
					obj.modifiers["Car Characteristics"].RandomCrumplingRandomMax_Active = true
					obj.modifiers["Car Characteristics"].RandomCrumplingRandomMax =  (filterstring splitline[3] " \",")[1]  as float
				)
				"set_damage_wbdrandomcrumplingrandommax":
				(
					obj.modifiers["Car Characteristics"].WBDRandomCrumplingRandomMax_Active = true
					obj.modifiers["Car Characteristics"].WBDRandomCrumplingRandomMax =  (filterstring splitline[3] " \",")[1]  as float
				)
				"set_damage_maxdeflectionfordamagetexture":
				(
					obj.modifiers["Car Characteristics"].MaxDeflectionForDamageTexture_Active = true
					obj.modifiers["Car Characteristics"].MaxDeflectionForDamageTexture =  (filterstring splitline[3] " \",")[1]  as float
				)
				"set_immunetowheldamage":
				(
					isTrue = (filterstring splitline[3] " ")[1]
					if isTrue == true then
						obj.modifiers["Car Characteristics"].ImmuneToWheelDamage_Active = true
					else
						obj.modifiers["Car Characteristics"].ImmuneToWheelDamage_Active = false
				)
				"set_cannotbesplit":
				(
					isTrue = (filterstring splitline[3] " ")[1]
					if isTrue == "true" then
						obj.modifiers["Car Characteristics"].CannotBeSplit_Active = true
					else
						obj.modifiers["Car Characteristics"].CannotBeSplit_Active = false
				)
				"set_allowcomzoutsideofwheelbase":
				(
					isTrue = (filterstring splitline[3] " ")[1]
					if isTrue == true then
						obj.modifiers["Car Characteristics"].AllowCOMZOutsideOfWheelbase_Active = true
					else
						obj.modifiers["Car Characteristics"].AllowCOMZOutsideOfWheelbase_Active = true
				)
				"set_wheelradius":
				(
					obj.modifiers["Car Characteristics"].WheelRadius_Active = true
					obj.modifiers["Car Characteristics"].WheelRadius = (filterstring splitline[3] " \",")[1] as float
					obj.modifiers["Car Characteristics"].WheelRadius_UseFactor = false
				)
				"set_wheelradiusfactor":
				(
					obj.modifiers["Car Characteristics"].WheelRadius_Active = true
					obj.modifiers["Car Characteristics"].WheelRadius = (filterstring splitline[3] " \",")[1] as float
					obj.modifiers["Car Characteristics"].WheelRadius_UseFactor = true
				)
				"set_gridextraspace":
				(

					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].GridExtraSpace_Active = true
					obj.modifiers["Car Characteristics"].GridExtraSpace_x = params[1] as float
					obj.modifiers["Car Characteristics"].GridExtraSpace_y = params[2] as float
					obj.modifiers["Car Characteristics"].GridExtraSpace_z = params[3] as float
				)
				"set_towingpowermultiplier":
				(
					obj.modifiers["Car Characteristics"].TowingPowerMultiplier_Active = true
					obj.modifiers["Car Characteristics"].TowingPowerMultiplier =  (filterstring splitline[3] " \",")[1]  as float
				)
				"set_towingtractionmultiplier":
				(
					obj.modifiers["Car Characteristics"].TowingTractionMultiplier_Active = true
					obj.modifiers["Car Characteristics"].TowingTractionMultiplier =  (filterstring splitline[3] " \",")[1]  as float
				)
				"set_towingsteerspeedmultiplier":
				(
					obj.modifiers["Car Characteristics"].TowingSteerSpeedMultiplier_Active = true
					obj.modifiers["Car Characteristics"].TowingSteerSpeedMultiplier =  (filterstring splitline[3] " \",")[1]  as float
				)
				/*"set_caterpillartrack_segmentdefinition":
				(
					params = (filterstring splitline[3] " \",")
					append obj.modifiers["Car Characteristics"].SegmentDefinition_Name params[2]
					append obj.modifiers["Car Characteristics"].SegmentDefinition_SegmentPitch (params[3] as float)
					append obj.modifiers["Car Characteristics"].SegmentDefinition_XOffset (params[4] as float)
				)
				
				"set_caterpillartrack_sagheights":
				(
					params = (filterstring splitline[3] " \",")
					append obj.modifiers["Car Characteristics"].SagHeight_AmbientLowestPoint (params[2] as float)
					append obj.modifiers["Car Characteristics"].SagHeight_LowestAllowablePoint (params[3] as float)
				)
				"set_caterpillartrack_damagemode":
				(
					params = (filterstring splitline[3] " \",")
					append obj.modifiers["Car Characteristics"].DamageMode_NumParts (params[2] as int)
					append obj.modifiers["Car Characteristics"].DamageMode_Restitution (params[3] as float)
					append obj.modifiers["Car Characteristics"].DamageMode_MassPerSegment (params[4] as float)
				)
				"set_caterpillartrack_damagewobble":
				(
					params = (filterstring splitline[3] " \",")
					append obj.modifiers["Car Characteristics"].DamageWobble_SpeedForMaxWobble (params[2] as float)
					append obj.modifiers["Car Characteristics"].DamageWobble_FreqOfMaxWobble (params[3] as float)
					append obj.modifiers["Car Characteristics"].DamageWobble_AmpOfMaxWobble (params[4] as float)
					append obj.modifiers["Car Characteristics"].DamageWobble_RandomVariance (params[5] as float)
				)*/ 
				"set_damage_caterpillartrack_damaged_frictionfactor":
				(
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].Damaged_FrictionFactor_active = true
					obj.modifiers["Car Characteristics"].Damaged_FrictionFactor = (params[1] as float)
				)
				"set_damage_caterpillartrack_damaged_rollingresistance":
				(
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].Damaged_RollingResistance_active = true
					obj.modifiers["Car Characteristics"].Damaged_RollingResistance = (params[1] as float)
				)
				"set_damage_caterpillartrack_alldamaged_frictionfactor":
				(
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].DamagedAll_FrictionFactor_active = true
					obj.modifiers["Car Characteristics"].DamagedAll_FrictionFactor = (params[1] as float)
				)
				"set_damage_caterpillartrack_alldamaged_rollingresistance":
				(
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].DamagedAll_RollingResistance_active = true
					obj.modifiers["Car Characteristics"].DamagedAll_RollingResistance = (params[1] as float)
				)

				"set_damage_caterpillartrack_soundwhinevolume":
				(

					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_Active = true
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_VolumeAtZero = params[1] as float
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_SpeedAtSlopeChange = params[2] as float
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_VolumeAtSlopeChange = params[3] as float
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_SpeedAtMaxVolume = params[4] as float
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_MaxVolume = params[5] as float
				)
				"set_damage_caterpillartrack_soundwhinepitch":
				(

					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].Sound_WhineVolume_Active = true
					obj.modifiers["Car Characteristics"].Sound_WhinePitch_PitchAtZero = params[1] as float
					obj.modifiers["Car Characteristics"].Sound_WhinePitch_MaxSpeed = params[2] as float
					obj.modifiers["Car Characteristics"].Sound_WhinePitch_PitchAtMaxSpeed = params[3] as float
				)
/*
				"set_damage_caterpillartrack_soundclunkvolume":
				(
					params = (filterstring splitline[3] " \",")
					append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_VolumeAtZero (params[2] as float)
					append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_SpeedAtSlopeChange (params[3] as float)
					append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_VolumeAtSlopeChange (params[4] as float)
					append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_SpeedAtMaxVolume (params[5] as float)
					append obj.modifiers["Car Characteristics"].Sound_ClunkVolume_MaxVolume (params[6] as float)
				) 
				"set_damage_caterpillartrack_soundhighspeedclunkvolume":
				(
					params = (filterstring splitline[3] " \",")
					append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtZero (params[2] as float)
					append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtZero (params[2] as float)
					append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_SpeedAtSlopeChange (params[3] as float)
					append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtSlopeChange (params[4] as float)
					append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_SpeedAtMaxVolume (params[5] as float)
					append obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_MaxVolume (params[6] as float)
				) */
				"set_damage_maxdeflectionfordamagetexture": (

					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].MaxDeflectionForDamageTexture_Active  = true
					obj.modifiers["Car Characteristics"].MaxDeflectionForDamageTexture  = params[1] as float
				)
				"add_caterpillartrack_segmentdefinition": (
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].CaterpillarTracks_Enabled = true
					local trackIndex = params[1] as integer + 1
					MakeSureThereAreEnoughTracks obj trackIndex	
					obj.modifiers["Car Characteristics"].SegmentDefinition_Name[trackIndex] = params[2]
					obj.modifiers["Car Characteristics"].SegmentDefinition_SegmentPitch[trackIndex] = params[3] as float
					obj.modifiers["Car Characteristics"].SegmentDefinition_XOffset[trackIndex] = params[4] as float

				)
				"add_caterpillartrack_damagemode": (
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].CaterpillarTracks_Enabled = true
					local trackIndex = params[1] as integer + 1
					MakeSureThereAreEnoughTracks obj trackIndex	
					obj.modifiers["Car Characteristics"].DamageMode_NumParts[trackIndex] = params[2] as integer
					obj.modifiers["Car Characteristics"].DamageMode_Restitution[trackIndex] = params[3] as float
					obj.modifiers["Car Characteristics"].DamageMode_MassPerSegment[trackIndex] = params[4] as float
				)

				"add_caterpillartrack_sagheights": (
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].CaterpillarTracks_Enabled = true
					local trackIndex = params[1] as integer + 1
					MakeSureThereAreEnoughTracks obj trackIndex	
					
					obj.modifiers["Car Characteristics"].SagHeight_AmbientLowestPoint[trackIndex] = params[2] as float
					obj.modifiers["Car Characteristics"].SagHeight_LowestAllowablePoint[trackIndex] = params[3] as float
				)

				"add_caterpillartrack_damagewobble": (
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].CaterpillarTracks_Enabled = true
					local trackIndex = params[1] as integer + 1
					MakeSureThereAreEnoughTracks obj trackIndex	
					
					obj.modifiers["Car Characteristics"].DamageWobble_SpeedForMaxWobble[trackIndex] = params[2] as float
					obj.modifiers["Car Characteristics"].DamageWobble_FreqOfMaxWobble[trackIndex] = params[3] as float
					obj.modifiers["Car Characteristics"].DamageWobble_AmpOfMaxWobble[trackIndex] = params[4] as float
					obj.modifiers["Car Characteristics"].DamageWobble_RandomVariance[trackIndex] = params[5] as float
				)

				"add_damage_caterpillartrack_soundclunkvolume": (
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].CaterpillarTracks_Enabled = true
					local trackIndex = params[1] as integer + 1
					MakeSureThereAreEnoughTracks obj trackIndex	
					
					obj.modifiers["Car Characteristics"].Sound_ClunkVolume_Enabled[trackIndex] = true
					obj.modifiers["Car Characteristics"].Sound_ClunkVolume_VolumeAtZero[trackIndex] = params[2] as float
					obj.modifiers["Car Characteristics"].Sound_ClunkVolume_SpeedAtSlopeChange[trackIndex] = params[3] as float
					obj.modifiers["Car Characteristics"].Sound_ClunkVolume_VolumeAtSlopeChange[trackIndex] = params[4] as float
					obj.modifiers["Car Characteristics"].Sound_ClunkVolume_SpeedAtMaxVolume[trackIndex] = params[5] as float
					obj.modifiers["Car Characteristics"].Sound_ClunkVolume_MaxVolume[trackIndex] = params[6] as float
				)


				"add_damage_caterpillartrack_soundhighspeedclunkvolume": (
					params = (filterstring splitline[3] " \",")
					obj.modifiers["Car Characteristics"].CaterpillarTracks_Enabled = true
					local trackIndex = params[1] as integer + 1
					MakeSureThereAreEnoughTracks obj trackIndex	
					
					obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_Enabled[trackIndex] = true
					obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtZero[trackIndex] = params[2] as float
					obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_SpeedAtSlopeChange[trackIndex] = params[3] as float
					obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_VolumeAtSlopeChange[trackIndex] = params[4] as float
					obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_SpeedAtMaxVolume[trackIndex] = params[5] as float
					obj.modifiers["Car Characteristics"].Sound_HighSpeedClunkVolume_MaxVolume[trackIndex] = params[6] as float
				)

				default:
				(
					format "Vehicle Characteristic: Not Yet Implemented \"%:%(%)\"\n" splitline[1] splitline[2] splitline[3]
				)
			)
		)
	)
)
fn ParseStructureCharacteristicsNode xmlNode obj carRoot:undefined =
(
		format "Parsing Structure Characteristics node\n"
	AddStructureCharacteristicsModifier obj
	--format "node data:%\n\n" xmlNode.value
	
	for i=1 to xmlnode.childnodes.count do
	(
		child = xmlnode.childnodes.item ( i-1)
		
		if child.nodetype == child.nodetype.cdata then
		(
			ParseStructureCharacteristicsCData child.value obj carRoot:carRoot
			break
		)
		--format "childnod type: %\nchildnode data:%\n\n" child.nodetype child.value
	)
)
fn LoadStructureXML file rootMesh =
(
	format "Loading structure.xml\n"
	--clearlistener()
	dotnet.loadAssembly "system.xml"
		xmlDoc=dotNetObject "system.xml.xmlDocument"
		--clearListener()
		--format "Properties\n"
		--showProperties xmlDoc
		--format "\nMethods\n"
		--showMethods xmlDoc
	--format "filename: %\n\n" file
		xmlDoc.load (file)
	select rootMesh
	clearSelection()
	characteristicsBlock = (xmlDoc.GetElementsByTagName "CHARACTERISTICS").item 0
	
	ParseStructureCharacteristicsNode characteristicsBlock rootMesh carRoot:rootMesh
	
	xmlRootNode = (xmlDoc.GetElementsByTagName "ROOT").item 0
	
	ParseStructurePartNode xmlRootNode rootMesh carroot:rootMesh
)

fn ParseSystemsDamageUnitCData CData systemDamageMod carRoot:carRoot =
(
	format "Parsing Systems Damage unit\n"
	splitCData = filterstring cdata "\n"

	for i =1 to splitcdata.count do
	(
		--format "\nline #% of cdata: %\n" i splitcdata[i]
		splitLine = filterstring splitcdata[i] ":()"
		if splitline.count > 1 then 
		(
			objectType = (filterstring splitLine[1] "\t ")
			if objectType[1][1] == "-" and objectType[1][2]=="-" then
			(
				--format "This line is a comment: %\n" splitcdata[i]
				continue
			)
			case (tolower splitline[2]) of
			(
				"set_damageeffect_drive": (
					params = (filterstring splitline[3] " \",")
					systemDamageMod.DamageEffect_DriveActive = true
					systemDamageMod.DamageEffect_Drive = params[1] as float
				)
				"set_damageeffect_steering": (
					params = (filterstring splitline[3] " \",")
					systemDamageMod.DamageEffect_SteeringActive = true
					systemDamageMod.DamageEffect_Steering = params[1] as float
				)
				"set_damageeffect_brakes": (
					params = (filterstring splitline[3] " \",")
					systemDamageMod.DamageEffect_BrakesActive = true
					systemDamageMod.DamageEffect_Brakes = params[1] as float
				)
				"set_wastedcontribution": (
					params = (filterstring splitline[3] " \",")
					systemDamageMod.WastedContributionActive = true
					systemDamageMod.WastedContribution = params[1] as float
				)
				"add_wastedlinearcontribution": (
					params = (filterstring splitline[3] " \",")
					systemDamageMod.WastedLinearContributionActive = true
					systemDamageMod.WastedLinearContributionStartDamage = params[1] as float
					systemDamageMod.WastedLinearContributionPartialDamage = params[2] as float
					systemDamageMod.WastedLinearContributionFullDamage = params[3] as float
				)
				"add_vulnerability": (
					params = (filterstring splitline[3] " \",")
					append systemDamageMod.Vulnerability params[1]
					append systemDamageMod.VulnerabilityValue (params[2] as float)
				)
				"add_crushablepart": (
					params = (filterstring splitline[3] " \",")
					append systemDamageMod.PartObjectType "Crushable"
					append systemDamageMod.PartObjectName params[1]
					append systemDamageMod.PartValue1 (params[2] as float)
					append systemDamageMod.PartValue2 (params[3] as float)

				)
				"add_solidpart": (
					params = (filterstring splitline[3] " \",")
					append systemDamageMod.PartObjectType "Solid"
					append systemDamageMod.PartObjectName params[1]
					append systemDamageMod.PartValue1 (params[2] as float)
					append systemDamageMod.PartValue2 (params[3] as float)

				)
				"add_complicatedwheel": (
					params = (filterstring splitline[3] " \",")
					append systemDamageMod.PartObjectType "Wheel"
					append systemDamageMod.PartObjectName params[1]
					append systemDamageMod.PartValue1 (params[2] as float)
					append systemDamageMod.PartValue2 0
				)
				"add_indexedcomplicatedwheel": (
					params = (filterstring splitline[3] " \",")
					append systemDamageMod.PartObjectType "Indexed Wheel"
					append systemDamageMod.PartObjectName params[1]
					append systemDamageMod.PartValue1 (params[2] as float)
					append systemDamageMod.PartValue2 0

				)
				"add_caterpillartrack": (
					params = (filterstring splitline[3] " \",")
					append systemDamageMod.PartObjectType "Tank Track"
					append systemDamageMod.PartObjectName params[1]
					append systemDamageMod.PartValue1 (params[2] as float)
					append systemDamageMod.PartValue2 0
				)
				"set_trailer": (
					params = (filterstring splitline[3] " \",")
					if (toLower params[1]) then (
						systemDamageMod.IsTrailer = true
					)
				)
			)
		)
	)
)
fn LoadSystemDamageXML file rootmesh =
(
	format "Loading Systems Damage xml file\n"

	dotnet.loadAssembly "system.xml"
		xmlDoc=dotNetObject "system.xml.xmlDocument"
		--clearListener()
		--format "Properties\n"
		--showProperties xmlDoc
		--format "\nMethods\n"
		--showMethods xmlDoc
	--format "filename: %\n\n" file
		xmlDoc.load (file)
	select rootMesh
	clearSelection()
	unitBlocks = xmlDoc.GetElementsByTagName "UNIT"
	for i = unitBlocks.count to 1 by -1 do (
		unitTag = unitBlocks.item (i - 1)
		unitName = "undefined"
		for attr = 1 to unitTag.Attributes.count do (
			attribute = unitTag.Attributes.item (attr - 1)
			if (tolower attribute.name) == "name" then (
				unitName = attribute.value
			)
		)
		unitMod =  AddSystemDamageUnit rootMesh unitname:unitName
		for c=1 to unitTag.childnodes.count do
		(
			child = unitTag.childnodes.item ( c-1)
			
			if child.nodetype == child.nodetype.cdata then
			(
				ParseSystemsDamageUnitCData child.value unitMod carRoot:carRoot
				break
			)
			--format "childnod type: %\nchildnode data:%\n\n" child.nodetype child.value
		)
	
	)
)
fn RecurseCarHierarchyToFindWheels obj =
(
	outputArray = #()
	case (tolower obj.name) of
	(
		"wheel_fr":
		(
			 append outputArray obj
		)
		"wheel_fl":
		(
			append outputArray obj
		)
		"wheel_rr":
		(
			append outputArray obj
		)
		"wheel_rl":
		(
			append outputArray obj
		)
		"wheel_rr001":
		(
			append outputArray obj
		)
		"wheel_rl001":
		(
			append outputArray obj
		)
		"wheel_rr002":
		(
			append outputArray obj
		)
		"wheel_rl002":
		(
			append outputArray obj
		)
		"wheel_rr003":
		(
			append outputArray obj
		)
		"wheel_rl003":
		(
			append outputArray obj
		)
		"wheel_rr004":
		(
			append outputArray obj
		)
		"wheel_rl004":
		(
			append outputArray obj
		)
	)
	for i=1 to obj.children.count do
	(
		outputArray += RecurseCarHierarchyToFindWheels obj.children[i]
	)
	outputArray
)
fn ReplaceWheels rootMesh =
(
	wheels = RecurseCarHierarchyToFindWheels rootMesh
	for wheel in wheels do
	(
		local wheelFolderName =case (tolower wheel.name) of
		(
			"wheel_fr":rootMesh.modifiers["vehicle_setup.cfg"].FRWheelFolderNames[1]
			"wheel_fl":rootMesh.modifiers["vehicle_setup.cfg"].FLWheelFolderNames[1]
			"wheel_rr":rootMesh.modifiers["vehicle_setup.cfg"].RRWheelFolderNames[1]
			"wheel_rl": rootMesh.modifiers["vehicle_setup.cfg"].RLWheelFolderNames[1]
			"wheel_rl001":rootMesh.modifiers["vehicle_setup.cfg"].d4wheelFolderNames[1]
			"wheel_rr001": rootMesh.modifiers["vehicle_setup.cfg"].d5wheelFolderNames[1]
			"wheel_rl002":rootMesh.modifiers["vehicle_setup.cfg"].d6wheelFolderNames[1]
			"wheel_rr002": rootMesh.modifiers["vehicle_setup.cfg"].d7wheelFolderNames[1]
			"wheel_rl003":rootMesh.modifiers["vehicle_setup.cfg"].d8wheelFolderNames[1]
			"wheel_rr003": rootMesh.modifiers["vehicle_setup.cfg"].d9wheelFolderNames[1]
			"wheel_rl004":rootMesh.modifiers["vehicle_setup.cfg"].d10wheelFolderNames[1]
			"wheel_rr004": rootMesh.modifiers["vehicle_setup.cfg"].d11wheelFolderNames[1]
		)
		ConvertToWheelNode wheel wheel.name wheelName:wheelFolderName

		
	)
)
fn LoadVehicleConfig obj folderName =
(
	format "Loading vehicle congif\n"
	f = undefined
	try 
	(
		f = openfile (folderName+"vehicle_setup.cfg")
		seek f #eof
		endOfFile = filePos f
		seek f 0
		mode = ""
		submode = ""
		--format "Starting to read Vehicle_Setup.cfg\n"
		while (filePos f) != endOfFile do
		(
			curLine = trimLeft (trimRight (readline f))
			case tolower(curLine) of
			(
				"[wheel_map]":
				(
					--format "Attachment node\n"
					mode="wheel_map"
				)
				"default":
				(
					--format "ComplicatedWheels Node\n"
					submode="default"
				)
				default:
				(
					if mode == "wheel_map" and submode=="default" then
					(
						--format "this is an attachment node for complicatedwheels\n"
						splitLine = filterstring curLine " \t"
						typeToDo = splitline[1] --readtoken curLine
						--format "read typeToDo: %\n" typeToDo
						wheelFolder = splitline[2] --readtoken curLine
						--format "read wheelFolder: %\n" wheelFolder
						if typeToDo != undefined then 
						case tolower(typeToDo) of
						(
							"wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSame=true
								--obj.modifiers["vehicle_setup.cfg"].WheelFolderName = wheelFolder
								append obj.modifiers["vehicle_setup.cfg"].FRWheelFolderNames  wheelFolder
								append obj.modifiers["vehicle_setup.cfg"].FLWheelFolderNames  wheelFolder
								append obj.modifiers["vehicle_setup.cfg"].RRWheelFolderNames  wheelFolder
								append obj.modifiers["vehicle_setup.cfg"].RLWheelFolderNames  wheelFolder
							)
							"fr_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].FRWheelFolderNames  wheelFolder
							)
							"fl_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].FLWheelFolderNames  wheelFolder
							)
							"rr_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].RRWheelFolderNames  wheelFolder
							)
							"rl_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].RLWheelFolderNames  wheelFolder
							)
							"d4_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D4WheelFolderNames  wheelFolder
							)
							"d5_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D5WheelFolderNames  wheelFolder
							)
							"d6_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D6WheelFolderNames  wheelFolder
							)
							"d7_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D7WheelFolderNames  wheelFolder
							)
							"d8_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D8WheelFolderNames  wheelFolder
							)
							"d9_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D9WheelFolderNames  wheelFolder
							)
							"d10_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D10WheelFolderNames  wheelFolder
							)
							"d11_wheel_folder_name":
							(
								--obj.modifiers["vehicle_setup.cfg"].WheelsAllSetToSamefalse
								append obj.modifiers["vehicle_setup.cfg"].D11WheelFolderNames  wheelFolder
							)
						)
					)
					else format "this line is: %\n\n" curLine
				)
			)
		)
		close f
	)
	catch
	(
		format "There was a fucking error!\n%\n" (getCurrentException())
		if f != undefined then close f
		throw()
	)
)

fn ParseSetupLOL lolFileName =
(
	lolscript = DecodeLOLFile lolFileName
	
	format "The Setup.lol file: %\n" lolscript
)
fn ImportCarButtonPressed sender arg=
(

	undo "Import C:R Car" on
	(
		--CreateNewNULLNode [1,1,0] 1
		cnt_name = GetOpenFileName caption:"Open Car.CNT File" types:"Car.CNT(Car.CNT)|car.cnt"
		if cnt_name != undefined do
		(
			with redraw off
			(
				--ImportCNT cnt_name importTextures:imp_textures.checked forcePREP:(imp_forcePREP.checked or imp_forceTriStrips.checked) useTriStrips:imp_forceTriStrips.checked
				rootMesh = ImportCNT cnt_name importTextures:sender.parent.controls.Item["ImportTexturesCheckbox"].checked forcePREP:sender.parent.controls.Item["ForcePrepCheckbox"].checked useTriStrips:sender.parent.controls.Item["UseTriStripsCheckbox"].checked
				AddVehilceCFGModifier rootMesh
				LoadVehicleConfig rootMesh (getFilenamePath cnt_name)
				SetAllCNTsToBakeScale rootMesh
				ReplaceWheels rootmesh
				
				structureXmlFile = (getFilenamePath cnt_name)+"structure.xml"
				LoadStructureXML structureXmlFile rootMesh
				
				setupLOLFile = (getFilenamePath cnt_name)+"setup.lol"
				ParseSetupLOL setupLOLfile
			)
		)
		
	)
	gc()
)