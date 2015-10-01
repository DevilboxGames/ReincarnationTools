if printArrayInFull== undefined then
(
	filein "CRHelpsFunctions.ms"
)
fn IsObjectACNT obj =
(
	return (obj.modifiers["CNT Hierarchy"] != undefined)
)
fn IsObjectAStructurePart obj =
(
	return (obj.modifiers["Car Structure Part"] != undefined)
)
fn IsObjectAStructureCharacteristic obj =
(
	return (obj.modifiers["Car Characteristics"] != undefined)
)
fn IsObjectAWheel obj =
(
	if (obj.modifiers["Car Structure Part"] != undefined) then
	(
		if (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_LEFT_WHEEL") > 0 or  (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_RIGHT_WHEEL") > 0 or  (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "REAR_LEFT_WHEEL") > 0 or  (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "REAR_RIGHT_WHEEL") > 0 then
		(
			return true
		)
		else return false
	)
	else return false
)

fn CustAttsTests =
(
	obj = selection[1]
	
	attrib = isProperty obj "CNTCustAttribute"
	
	format "Object customer attribute: %\n" attrib
)

fn target_helper_filter obj = ( IsObjectACNT obj == true or (classof obj) == Point)
	
fn target_cnt_filter obj = (IsObjectACNT obj == true )
	
fn pickJointFilter obj = (
	classof obj == CarmaHelper_JointHelper
)
	
/*********************************
***** CNT ATTRIBUTES
*********************************/

CNTTypes = #("MODL","NULL","LITg","SKIN","EMT2","VFXI")
CNTAttribute = attributes CNTCustAttribute attribID:#(0x7a3a974d, 0x58ce73ad) version:1
(
	parameters main rollout:CNTAttributeParams
	(
		
		NodeTypeID type:#integer default:1
		NodeType type:#string default:"MODL"
		FileName type:#string ui:uiFileName default:""
		BakeScaleIntoMesh type:#boolean ui:uiBakeScaleIntoMesh default: false
		
	)
	rollout CNTAttributeParams "CNT Hierarchy Params"
	(
		dropdownlist uiNodeType "Node Type" items:CNTTypes selection:NodeTypeID
		--edittext uiNodeType2 "Node Type (string)" labelOnTop:true
		edittext uiFileName "Content Filename" labelOnTop:true
		checkbox uiBakeScaleIntoMesh "Bake Scale into Mesh"
		on uiNodeType selected i do 
		(
			NodeTypeID = uiNodeType.selection
			NodeType = uiNodeType.items[i]
		)
	)
)


/*********************************
***** CAR VEHICLE_SETUP.CFG ATTRIBUTES
*********************************/
VehicleSetupCFGAttribute = attributes VehicleSetupCFG_Def attribID:#(0x340cef1c, 0x6f4b7c3d) version:1
(
	parameters main rollout:VehicleCFGMainRollout
	(
		SkidMarksImage type:#string default:""
		TyreParticlesVFX type:#string default:""
		MaxSteeringLock type:#integer detault:20
		ExhaustParticlesVFX type:#string default:""
		ExhaustAnchor type:#maxObject
		SkidNoise type:#stringTab tabSizeVariable:true
		WheelsAllSetToSame type:#boolean default: true ui:chk_AllWheelsTheSame
		WheelFolderName type:#string default:"default_eagle_R" ui:txt_wheelFolderName
		FRWheelFolderName type:#string default:"default_eagle_R" ui:txt_frwheelFolderName
		FLWheelFolderName type:#string default:"default_eagle_R" ui:txt_flwheelFolderName
		RRWheelFolderName type:#string default:"default_eagle_R" ui:txt_rrwheelFolderName
		RLWheelFolderName type:#string default:"default_eagle_R" ui:txt_rkwheelFolderName
	)
	rollout VehicleCFGMainRollout "Vehicle CFG"
	(
		checkbox chk_AllWheelsTheSame "All Wheels Use Same Model" default: true
		edittext txt_wheelFolderName "Wheel Folder Name" labelOntop:true
		
		edittext txt_frwheelFolderName "Wheel FR Folder Name" labelOntop:true
		edittext txt_flwheelFolderName "Wheel FL Folder Name" labelOntop:true
		edittext txt_rrwheelFolderName "Wheel RR Folder Name" labelOntop:true
		edittext txt_rkwheelFolderName "Wheel RL Folder Name" labelOntop:true
	)
)

/*********************************
***** CAR STRUCT CHARACTERISTICS ATTRIBUTES
*********************************/
StructureCharacteristicsAttribute = attributes StructureCharacteristics_Def attribID:#(0x384aa405, 0x32e1fc9) version:1
(
	parameters main rollout:BasicCharacteristicsRollout
	(
		DefenceAgainstCars_Active type:#boolean default:false ui:chk_DefenceAgainstCars_Active
		DefenceAgainstCars type:#float default:1.0 ui: spn_DefenceAgainstCars
		
		DefenceGeneral_Active type:#boolean default:false ui:chk_DefenceGeneral_Active
		DefenceGeneral type:#float default:1.0 ui: spn_DefenceGeneral
		
		Offence_Active type:#boolean default:false ui:chk_Offence_Active
		Offence type:#float default:1.0 ui: spn_Offence
	
		ValueFactor_Active type:#boolean default:false ui:chk_ValueFactor_Active
		ValueFactor type:#float default:1.0 ui: spn_ValueFactor
		
		WholeBodyDeformationFactor_Active type:#boolean default:false ui:chk_WholeBodyDeformationFactor_Active
		WholeBodyDeformationFactor type:#float default:1.0 ui: spn_WholeBodyDeformationFactor
		
		ExtraFallingDamageThreshold_Active type:#boolean default:false ui:chk_ExtraFallingDamageThreshold_Active
		ExtraFallingDamageThreshold type:#float default:30 ui:spn_ExtraFallingDamageThreshold
		
		ExtraFallingDamageFactor_Active type:#boolean default:false ui:chk_ExtraFallingDamageFactor_Active
		ExtraFallingDamageFactor type:#float default:800 ui:spn_ExtraFallingDamageFactor
		PermanentPowerups type:#stringTab tabSizeVariable:true
	)
	rollout BasicCharacteristicsRollout "Basic Characteristics"
	(
		checkbox chk_DefenceAgainstCars_Active "" default:false across:2
		spinner spn_DefenceAgainstCars "Defence Against Cars" range:[0,100,1] type:#float fieldwidth:40
		
		checkbox chk_DefenceGeneral_Active "" default:false across:2
		spinner spn_DefenceGeneral "Defence (General)" range:[0,100,1] type:#float fieldwidth:40
		
		checkbox chk_Offence_Active "" default:false across:2
		spinner spn_Offence "Offence" range:[0,100,1] type:#float fieldwidth:40
		
		checkbox chk_ValueFactor_Active "" default:false across:2
		spinner spn_ValueFactor "Value Factor" range:[0,100,1] type:#float fieldwidth:40
		
		checkbox chk_WholeBodyDeformationFactor_Active "" default:false across:2
		spinner spn_WholeBodyDeformationFactor "Deform Factor" range:[0,100,1] type:#float fieldwidth:40
		
		checkbox chk_ExtraFallingDamageThreshold_Active "" default:false across:2
		spinner spn_ExtraFallingDamageThreshold "Extra Fall Damage Threshold" range:[0,1000,1] type:#float fieldwidth:40
		
		checkbox chk_ExtraFallingDamageFactor_Active "" default:false across:2
		spinner spn_ExtraFallingDamageFactor "Extra Fall Damage Factor" range:[0,10000,1] type:#float fieldwidth:40
		
		edittext txt_PowerupName "Permenant Powerup" labelOnTop:true fieldwidth: 100 across:2
		button but_AddToPowerups "Add"
		dotnetcontrol lv_Powerups "listview" height: 100
		button but_DeleteFromPowerups "Delete Selected"
		
		on BasicCharacteristicsRollout open do
		(			
			
			chk_DefenceAgainstCars_Active.pos = [chk_DefenceAgainstCars_Active.pos.x-7, chk_DefenceAgainstCars_Active.pos.y]
			chk_DefenceGeneral_Active.pos = [chk_DefenceGeneral_Active.pos.x-7, chk_DefenceGeneral_Active.pos.y]
			chk_Offence_Active.pos = [chk_Offence_Active.pos.x-7, chk_Offence_Active.pos.y]
			chk_ValueFactor_Active.pos = [chk_ValueFactor_Active.pos.x-7, chk_ValueFactor_Active.pos.y]
			chk_WholeBodyDeformationFactor_Active.pos = [chk_WholeBodyDeformationFactor_Active.pos.x-7, chk_WholeBodyDeformationFactor_Active.pos.y]
			chk_ExtraFallingDamageThreshold_Active.pos = [chk_ExtraFallingDamageThreshold_Active.pos.x-7, chk_ExtraFallingDamageThreshold_Active.pos.y]
			chk_ExtraFallingDamageFactor_Active.pos = [chk_ExtraFallingDamageFactor_Active.pos.x-7, chk_ExtraFallingDamageFactor_Active.pos.y]
			
			if DefenceAgainstCars_Active then spn_DefenceAgainstCars.enabled = true
			else spn_DefenceAgainstCars.enabled = false
			
			if DefenceGeneral_Active then spn_DefenceGeneral.enabled = true
			else spn_DefenceGeneral.enabled = false
			
			if Offence_Active then spn_Offence.enabled = true
			else spn_Offence.enabled = false
			
			if ValueFactor_Active then spn_ValueFactor.enabled = true
			else spn_ValueFactor.enabled = false
			
			if WholeBodyDeformationFactor_Active then spn_WholeBodyDeformationFactor.enabled = true
			else spn_WholeBodyDeformationFactor.enabled = false

			if ExtraFallingDamageThreshold_Active then spn_ExtraFallingDamageThreshold.enabled = true
			else spn_ExtraFallingDamageThreshold.enabled = false
			
			if ExtraFallingDamageFactor_Active then spn_ExtraFallingDamageFactor.enabled = true
			else spn_ExtraFallingDamageFactor.enabled = false
			
			but_AddToPowerups.pos = [120, but_AddToPowerups.pos.y+15]
			lv_Powerups.view  = (dotnetclass "view").details
			lv_Powerups.fullrowselect= true
			lv_Powerups.gridlines = true
			lv_Powerups.multiselect =false
			lv_Powerups.columns.add "Powerup" 110
			for i=1 to PermanentPowerups.count do
			(
				lv_Powerups.Items.add PermanentPowerups[i]
			)
		)
		
		on chk_DefenceAgainstCars_Active changed state do
		(
			spn_DefenceAgainstCars.enabled = state
		)
		on chk_DefenceGeneral_Active changed state do
		(
			spn_DefenceGeneral.enabled = state
		)
		on chk_Offence_Active changed state do
		(
			spn_Offence.enabled = state
		)
		on chk_ValueFactor_Active changed state do
		(
			spn_ValueFactor.enabled = state
		)
		on chk_WholeBodyDeformationFactor_Active changed state do
		(
			spn_WholeBodyDeformationFactor.enabled = state
		)
		on chk_ExtraFallingDamageThreshold_Active changed state do
		(
			spn_ExtraFallingDamageThreshold.enabled = state
		)
		on chk_ExtraFallingDamageFactor_Active changed state do
		(
			spn_ExtraFallingDamageFactor.enabled = state
		)
		on BasicCharacteristicsRollout close do
		(
			
		)
		on but_DeleteFromPowerups pressed do
		(
			if lv_Powerups.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_Powerups.SelectedIndices.Item[0]
				lv_Powerups.Items.removeat selectedIndex
				deleteItem PermanentPowerups (selectedIndex+1)
			)
		)
		on but_AddToPowerups pressed do
		(
			lv_Powerups.Items.add (txt_PowerupName.text)
			append PermanentPowerups txt_PowerupName.text
		)
	)
	
	parameters airBrakeSpoiler rollout:AirBrakeSpoilerRollout
	(
		AirBrakeMinSpeed_Active type:#boolean default:false ui:chk_AirBrakeMinSpeed_Active
		AirBrakeMinSpeed type:#float default: 1.0 ui: spn_AirBrakeMinSpeed
		
		AirBrakeMaxSpeed_Active type:#boolean default:false ui:chk_AirBrakeMaxSpeed_Active
		AirBrakeMaxSpeed type:#float default: 1.0 ui: spn_AirBrakeMaxSpeed
		
		AirBrakeMinParametric_Active type:#boolean default:false ui:chk_AirBrakeMinParametric_Active
		AirBrakeMinParametric type:#float default: 1.0 ui:spn_AirBrakeMinParametric 
		
		AirBrakeMovementUpTime_Active type:#boolean default:false ui:chk_AirBrakeMovementUpTime_Active
		AirBrakeMovementUpTime type:#float default: 1.0 ui:spn_AirBrakeMovementUpTime 
		
		AirBrakeMovementDownTime_Active type:#boolean default:false ui:chk_AirBrakeMovementDownTime_Active
		AirBrakeMovementDownTime type:#float default: 1.0 ui:spn_AirBrakeMovementDownTime 
		
		AirBrakeDroptime_Active type:#boolean default:false ui:chk_AirBrakeDroptime_Active
		AirBrakeDroptime type:#float default:1.0 ui:spn_AirBrakeDroptime 
		
		AerofoilUpSpeed_Active type:#boolean default:false ui:chk_AerofoilUpSpeed_Active
		AerofoilUpSpeed type:#float default: 1.0	ui:spn_AerofoilUpSpeed 
		
		AerofoilDownSpeed_Active type:#boolean default:false ui:chk_AerofoilDownSpeed_Active
		AerofoilDownSpeed type:#float default: 1.0 ui:spn_AerofoilDownSpeed 
		
		AerofoilMovementUpTime_Active type:#boolean default:false ui:chk_AerofoilMovementUpTime_Active
		AerofoilMovementUpTime type:#float default: 1.0 ui:spn_AerofoilMovementUpTime 
		
		AerofoilMovementDownTime_Active type:#boolean default:false ui:chk_AerofoilMovementDownTime_Active
		AerofoilMovementDownTime type:#float default: 1.0 ui:spn_AerofoilMovementDownTime 
		
		
		Aerofoil2UpSpeed_Active type:#boolean default:false ui:chk_Aerofoil2UpSpeed_Active
		Aerofoil2UpSpeed type:#float default: 1.0 ui:spn_Aerofoil2UpSpeed 
		
		Aerofoil2DownSpeed_Active type:#boolean default:false ui:chk_Aerofoil2DownSpeed_Active
		Aerofoil2DownSpeed type:#float default: 1.0 ui:spn_Aerofoil2DownSpeed
		
		Aerofoil2MovementUpTime_Active type:#boolean default:false ui:chk_Aerofoil2MovementUpTime_Active
		Aerofoil2MovementUpTime type:#float default: 1.0 ui:spn_Aerofoil2MovementUpTime 
		
		Aerofoil2MovementDownTime_Active type:#boolean default:false ui:chk_Aerofoil2MovementDownTime_Active
		Aerofoil2MovementDownTime type:#float default: 1.0 ui:spn_Aerofoil2MovementDownTime 
		
		AerofoilOpenSound_Active type:#boolean default:false ui:chk_AerofoilOpenSound_Active
		AerofoilOpenSound type:#string default:"eagle_flaps_open" ui:txt_AerofoilOpenSound 
		AerofoilCloseSound_Active type:#boolean default:false ui:chk_AerofoilCloseSound_Active
		AerofoilCloseSound type:#string default:"eagle_flaps_open" ui:txt_AerofoilCloseSound 
		
		AerofoilSoundLump type:#maxObject
	)
	rollout AirBrakeSpoilerRollout "Air Brake & Spoiler Settings"
	(
		group "Air Brake"
		(
			checkbox chk_AirBrakeMinSpeed_Active "" default:false across:2
			spinner spn_AirBrakeMinSpeed "Activation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMaxSpeed_Active "" default:false across:2
			spinner spn_AirBrakeMaxSpeed "Deactivation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMinParametric_Active "" default:false across:2
			spinner spn_AirBrakeMinParametric "Min Parametric" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMovementUpTime_Active "" default:false across:2
			spinner spn_AirBrakeMovementUpTime "Activation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMovementDownTime_Active "" default:false across:2
			spinner spn_AirBrakeMovementDownTime "Deactivation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeDroptime_Active "" default:false across:2
			spinner spn_AirBrakeDropTime "Drop Time" range:[0,1000,1] type:#float fieldwidth:40
		)
		group "Aerofoil 1"
		(
			checkbox chk_AerofoilUpSpeed_Active "" default:false across:2
			spinner spn_AerofoilUpSpeed "Activation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AerofoilDownSpeed_Active "" default:false across:2
			spinner spn_AerofoilDownSpeed "Deactivation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AerofoilMovementUpTime_Active "" default:false across:2
			spinner spn_AerofoilMovementUpTime "Activation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AerofoilMovementDownTime_Active "" default:false across:2
			spinner spn_AerofoilMovementDownTime "Deactivation Time" range:[0,1000,1] type:#float fieldwidth:40
			
		)
		group "Aerofoil 2"
		(
			checkbox chk_Aerofoil2UpSpeed_Active "" default:false across:2
			spinner spn_Aerofoil2UpSpeed "Activation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_Aerofoil2DownSpeed_Active "" default:false across:2
			spinner spn_Aerofoil2DownSpeed "Deactivation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_Aerofoil2MovementUpTime_Active "" default:false across:2
			spinner spn_Aerofoil2MovementUpTime "Activation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_Aerofoil2MovementDownTime_Active "" default:false across:2
			spinner spn_Aerofoil2MovementDownTime "Deactivation Time" range:[0,1000,1] type:#float fieldwidth:40
			
		)
		group "Sounds"
		(
			
			checkbox chk_AerofoilOpenSound_Active "" default:false across:2
			edittext txt_AerofoilOpenSound "Open Sound" labelOnTop:true width: 120 fieldwidth:120
			checkbox chk_AerofoilCloseSound_Active "" default:false across:2
			edittext txt_AerofoilCloseSound "Close Sound" labelOnTop:true width: 120 fieldwidth:120
			
			label lbl_AerofoilSoundLump "Aerofoil Sound Node"
			pickbutton pck_AerofoilSoundLump "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
			button but_ClearAerofoilSoundLump "Clear" across:2
			button but_SelectAerofoilSoundLump "Select" across:2
			
		)
		
		on AirBrakeSpoilerRollout open do
		(
			
			chk_AirBrakeMinSpeed_Active.pos = [chk_AirBrakeMinSpeed_Active.pos.x-7, chk_AirBrakeMinSpeed_Active.pos.y]
			chk_AirBrakeMaxSpeed_Active.pos = [chk_AirBrakeMaxSpeed_Active.pos.x-7, chk_AirBrakeMaxSpeed_Active.pos.y]
			chk_AirBrakeMinParametric_Active.pos = [chk_AirBrakeMinParametric_Active.pos.x-7, chk_AirBrakeMinParametric_Active.pos.y]
			chk_AirBrakeMovementUpTime_Active.pos = [chk_AirBrakeMovementUpTime_Active.pos.x-7, chk_AirBrakeMovementUpTime_Active.pos.y]
			chk_AirBrakeMovementDownTime_Active.pos = [chk_AirBrakeMovementDownTime_Active.pos.x-7, chk_AirBrakeMovementDownTime_Active.pos.y]
			chk_AirBrakeDroptime_Active.pos = [chk_AirBrakeDroptime_Active.pos.x-7, chk_AirBrakeDroptime_Active.pos.y]
			
			chk_AerofoilUpSpeed_Active.pos = [chk_AerofoilUpSpeed_Active.pos.x-7, chk_AerofoilUpSpeed_Active.pos.y]
			chk_AerofoilDownSpeed_Active.pos = [chk_AerofoilDownSpeed_Active.pos.x-7, chk_AerofoilDownSpeed_Active.pos.y]
			chk_AerofoilMovementUpTime_Active.pos = [chk_AerofoilMovementUpTime_Active.pos.x-7, chk_AerofoilMovementUpTime_Active.pos.y]
			chk_AerofoilMovementDownTime_Active.pos = [chk_AerofoilMovementDownTime_Active.pos.x-7, chk_AerofoilMovementDownTime_Active.pos.y]
			
			chk_Aerofoil2UpSpeed_Active.pos = [chk_Aerofoil2UpSpeed_Active.pos.x-7, chk_Aerofoil2UpSpeed_Active.pos.y]
			chk_Aerofoil2DownSpeed_Active.pos = [chk_Aerofoil2DownSpeed_Active.pos.x-7, chk_Aerofoil2DownSpeed_Active.pos.y]
			chk_Aerofoil2MovementUpTime_Active.pos = [chk_Aerofoil2MovementUpTime_Active.pos.x-7, chk_Aerofoil2MovementUpTime_Active.pos.y]
			chk_Aerofoil2MovementDownTime_Active.pos = [chk_Aerofoil2MovementDownTime_Active.pos.x-7, chk_Aerofoil2MovementDownTime_Active.pos.y]
			
			chk_AerofoilOpenSound_Active.pos = [chk_AerofoilOpenSound_Active.pos.x-7, chk_AerofoilOpenSound_Active.pos.y]
			chk_AerofoilCloseSound_Active.pos = [chk_AerofoilCloseSound_Active.pos.x-7, chk_AerofoilCloseSound_Active.pos.y]
			
			txt_AerofoilOpenSound.pos = [txt_AerofoilOpenSound.pos.x-50, txt_AerofoilOpenSound.pos.y]
			txt_AerofoilCloseSound.pos = [txt_AerofoilCloseSound.pos.x-50, txt_AerofoilCloseSound.pos.y]
			
			if AirBrakeMinSpeed_Active then spn_AirBrakeMinSpeed.enabled = true
			else spn_AirBrakeMinSpeed.enabled = false
			if AirBrakeMaxSpeed_Active then spn_AirBrakeMaxSpeed.enabled = true
			else spn_AirBrakeMaxSpeed.enabled = false
			if AirBrakeMinParametric_Active then spn_AirBrakeMinParametric.enabled = true
			else spn_AirBrakeMinParametric.enabled = false
			if AirBrakeMovementUpTime_Active then spn_AirBrakeMovementUpTime.enabled = true
			else spn_AirBrakeMovementUpTime.enabled = false
			if AirBrakeMovementDownTime_Active then spn_AirBrakeMovementDownTime.enabled = true
			else spn_AirBrakeMovementDownTime.enabled = false
			if AirBrakeDroptime_Active then spn_AirBrakeDroptime.enabled = true
			else spn_AirBrakeDroptime.enabled = false
			
			if AerofoilUpSpeed_Active then spn_AerofoilUpSpeed.enabled = true
			else spn_AerofoilUpSpeed.enabled = false
			if AerofoilDownSpeed_Active then spn_AerofoilDownSpeed.enabled = true
			else spn_AerofoilDownSpeed.enabled = false
			if AerofoilMovementUpTime_Active then spn_AerofoilMovementUpTime.enabled = true
			else spn_AerofoilMovementUpTime.enabled = false
			if AerofoilMovementDownTime_Active then spn_AerofoilMovementDownTime.enabled = true
			else spn_AerofoilMovementDownTime.enabled = false
			
			if Aerofoil2UpSpeed_Active then spn_Aerofoil2UpSpeed.enabled = true
			else spn_Aerofoil2UpSpeed.enabled = false
			if Aerofoil2DownSpeed_Active then spn_Aerofoil2DownSpeed.enabled = true
			else spn_Aerofoil2DownSpeed.enabled = false
			if Aerofoil2MovementUpTime_Active then spn_Aerofoil2MovementUpTime.enabled = true
			else spn_Aerofoil2MovementUpTime.enabled = false
			if Aerofoil2MovementDownTime_Active then spn_Aerofoil2MovementDownTime.enabled = true
			else spn_Aerofoil2MovementDownTime.enabled = false
			
			if AerofoilOpenSound_Active then txt_AerofoilOpenSound.enabled = true
			else txt_AerofoilOpenSound.enabled = false
			if AerofoilCloseSound_Active then txt_AerofoilCloseSound.enabled = true
			else txt_AerofoilCloseSound.enabled = false
			
			if AerofoilSoundLump != undefined then 
			(
				pck_AerofoilSoundLump.object= AerofoilSoundLump.node
			)
		)
		
		on chk_AirBrakeMinSpeed_Active changed state do
		(
			spn_AirBrakeMinSpeed.enabled = state
		)
		on chk_AirBrakeMaxSpeed_Active changed state do
		(
			spn_AirBrakeMaxSpeed.enabled = state
		)
		on chk_AirBrakeMinParametric_Active changed state do
		(
			spn_AirBrakeMinParametric.enabled = state
		)
		on chk_AirBrakeMovementUpTime_Active changed state do
		(
			spn_AirBrakeMovementUpTime.enabled = state
		)
		on chk_AirBrakeMovementDownTime_Active changed state do
		(
			spn_AirBrakeMovementDownTime.enabled = state
		)
		on chk_AirBrakeDroptime_Active changed state do
		(
			spn_AirBrakeDroptime.enabled = state
		)
		
		
		on chk_AerofoilUpSpeed_Active changed state do
		(
			spn_AerofoilUpSpeed.enabled = state
		)
		on chk_AerofoilDownSpeed_Active changed state do
		(
			spn_AerofoilDownSpeed.enabled = state
		)
		on chk_AerofoilMovementUpTime_Active changed state do
		(
			spn_AerofoilMovementUpTime.enabled = state
		)
		on chk_AerofoilMovementDownTime_Active changed state do
		(
			spn_AerofoilMovementDownTime.enabled = state
		)
		
		
		on chk_Aerofoil2UpSpeed_Active changed state do
		(
			spn_Aerofoil2UpSpeed.enabled = state
		)
		on chk_Aerofoil2DownSpeed_Active changed state do
		(
			spn_Aerofoil2DownSpeed.enabled = state
		)
		on chk_Aerofoil2MovementUpTime_Active changed state do
		(
			spn_Aerofoil2MovementUpTime.enabled = state
		)
		on chk_Aerofoil2MovementDownTime_Active changed state do
		(
			spn_Aerofoil2MovementDownTime.enabled = state
		)
		
		on chk_AerofoilOpenSound_Active changed state do
		(
			txt_AerofoilOpenSound.enabled = state
		)
		on chk_AerofoilCloseSound_Active changed state do
		(
			txt_AerofoilCloseSound.enabled = state
		)
		on pck_AerofoilSoundLump picked obj do
		(
			AerofoilSoundLump = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		
		on but_ClearAerofoilSoundLump pressed do
		(
			AerofoilSoundLump = undefined
			pck_AerofoilSoundLump.object = undefined
		)
		on but_SelectAerofoilSoundLump pressed do
		(
			if AerofoilSoundLump != undefined then undo "Select Aerofoil Sound Lump" on select AerofoilSoundLump.node
		)
	)
)
/*********************************
***** CAR STRUCT PreIK/PostIK ATTRIBUTES
*********************************/

StructureAnimationTypes = #("Rotate", "Slide", "Oscillate", "Rock", "Vibrate")
StructureAnimationControllers = #(	"CONSTANT",
												"CONSTANT_OVER_TIME",
												"SPEED",
												"SPEED_OVER_TIME",
												"WHEEL_SPEED",
												"WHEEL_SPEED_OVER_TIME",
												"WHEEL_ROTATION_FR",
												"WHEEL_ROTATION_FL",
												"WHEEL_ROTATION_RR",
												"WHEEL_ROTATION_RL",
												"STEERING",
												"STEERING_OVER_TIME",
												"ENGINE_NORMALISED_RPM",
												"ENGINE_NORMALISED_RPM_OVER_TIME",
												"ENGINE_RPM",
												"ENGINE_RPM_OVER_TIME",
												"ENGINE_CRANK_ANGLE",
												"GEARBOX_OUTPUT_ANGLE",
												"SPEED_DEPENDENT_AEROFOIL",
												"SPEED_DEPENDENT_AEROFOIL_2",
												"AIR_BRAKE")
StructurePointToPointValues = #(	"Snap Point To Other Part",
												"Rotate Point To Line On Other Part",
												"Rotate Point To Point On Other Part",
												"Rotate Point To Point On Other Part With Scaling"
)
WishboneAxelTypes = #("Wishbone Upper", "Wishbone Lower", "Strut Wishbone", "Live Axle")
WishboneWheelTypes = #("Front Left", "Front Right", "Rear Left", "Rear Right")
WishboneMountTypes = #("Wishbone Lower","Wishbone Upper", "Strut Lower", "Strut Upper", "Trailing Arm")
WishboneHubType = #("Wishbone Hub", "Strut Hub", "Live Axle Hub")
WishbonePivotAxis = #("X", "Y", "Z")


StructureTrailingArm = attributes  StructureTrailingArm_Def attribID:#(0x71611dc1, 0x11650f9f) version:1
(
	parameters main rollout:StructTrailingArm
	(
		WheelIndex type:#integer default:0
		WheelIndex_Selection type:#integer ui:dpdn_WheelIndex default:1
		MountPivot type:#maxObject
		AxlePivot type:#maxObject
	)
	rollout StructTrailingArm "Live Axle Trailing Arm"
	(
		dropdownlist dpdn_WheelIndex "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		
		label lbl_MountPivotPoint "Mount Pivot Point"
		pickbutton pck_MountPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearMountPivotPoint "Clear" across:2
		button but_SelectMountPivotPoint "Select" across:2
		
		label lbl_AxlePivotPoint "Axle Pivot Point"
		pickbutton pck_AxlePivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearAxlePivotPoint "Clear" across:2
		button but_SelectAxlePivotPoint "Select" across:2
		
		on pck_MountPivotPoint picked obj do
		(
			MountPivot = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_AxlePivotPoint picked obj do
		(
			AxlePivot = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_WheelIndex selected selectedIndex do
		(
			WheelIndex = selectedIndex-1
		)
		on but_SelectMountPivotPoint pressed do
		(
			if MountPivot != undefined then undo "Select Mount Pivot" on select MountPivot.node
		)
		on but_SelectAxlePivotPoint pressed do
		(
			if AxlePivot != undefined then undo "Select Axle Pivot" on select AxlePivot.node
		)
		on but_ClearMountPivotPoint pressed do
		(
			MountPivot = undefined
			pck_MountPivotPoint.object = undefined
		)
		on but_ClearAxlePivotPoint pressed do
		(
			AxlePivot = undefined
			pck_AxlePivotPoint.object = undefined
		)
		
		on StructTrailingArm open do
		(
			if MountPivot != undefined then pck_MountPivotPoint.object = MountPivot.node
			if AxlePivot != undefined then pck_AxlePivotPoint.object = AxlePivot.node
		)
	)
)
StructureWishboneHub = attributes StructureWishboneHubt_Def attribID:#(0xf8ff3af, 0x32cc6f09) version:1
(
	parameters main rollout:StructWishboneHub
	(
		HubType type:#string default:WishboneHubType[1]
		HubType_Selection type:#integer ui:dpdn_HubType default:1
		WheelIndex type:#integer default:0
		WheelIndex_Selection type:#integer ui:dpdn_WheelIndex default:1
		PivotAxis type:#integer default:0
		PivotAxis_Selection type:#integer ui: dpdn_PivotAxis default:1
		UpperPivotPoint type:#maxObject ui:pck_UpperPivotPoint
		LowerPivotPoint type:#maxObject ui:pck_LowerPivotPoint
		WheelPoint type:#maxObject ui:pck_Wheel
	)
	rollout StructWishboneHub "Wishbone Hub"
	(
		dropdownlist dpdn_HubType "Hub Type" items:WishboneHubType default:1 labelontop:true
		dropdownlist dpdn_PivotAxis "Pivot Axis" items:WishbonePivotAxis default:1 labelontop:true
		dropdownlist dpdn_WheelIndex "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		
		label lbl_Wheel "Wheel Position"
		pickbutton pck_Wheel "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearWheel "Clear"
		button but_SelectWheel "Select"
		label lbl_UpperPivotPoint "Upper Pivot Point"
		pickbutton pck_UpperPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearUpperPivotPoint "Clear" across:2
		button but_SelectUpperPivotPoint "Select"
		label lbl_LowerPivotPoint "Lower Pivot Point"
		pickbutton pck_LowerPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearLowerPivotPoint "Clear" across:2
		button but_SelectLowerPivotPoint "Select"
		
		fn InitFields = 
		(
			WheelIndex = WheelIndex_Selection - 1
			if HubType_Selection == 3 then
			(
				--if WheelIndex == 1 then WheelIndex = 0
				--else if WheelIndex == 3 then WheelIndex = 2
				dpdn_PivotAxis.enabled = false
				lbl_UpperPivotPoint.enabled = false
				pck_UpperPivotPoint.enabled = false
				but_ClearUpperPivotPoint.enabled = false
				but_SelectUpperPivotPoint.enabled = false
				lbl_LowerPivotPoint.enabled = false
				pck_LowerPivotPoint.enabled = false
				but_ClearLowerPivotPoint.enabled = false
				but_SelectLowerPivotPoint.enabled = false
			)
			else
			(
				dpdn_PivotAxis.enabled = true
				lbl_UpperPivotPoint.enabled = true
				pck_UpperPivotPoint.enabled = true
				but_ClearUpperPivotPoint.enabled = true
				but_SelectUpperPivotPoint.enabled = true
				lbl_LowerPivotPoint.enabled = true
				pck_LowerPivotPoint.enabled = true
				but_ClearLowerPivotPoint.enabled = true
				but_SelectLowerPivotPoint.enabled = true
			)
		)
		on pck_UpperPivotPoint picked obj do
		(
			UpperPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_LowerPivotPoint picked obj do
		(
			LowerPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_Wheel picked obj do
		(
			WheelPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_HubType selected selectedIndex do
		(
			HubType = WishboneHubType[selectedIndex]
			InitFields()
		)
		on dpdn_PivotAxis selected selectedIndex do
		(
			PivotAxis = selectedIndex-1
		)
		on dpdn_WheelIndex selected selectedIndex do
		(
			WheelIndex = selectedIndex-1
			
			if HubType_Selection == 3 then
			(
				--if WheelIndex == 1 then WheelIndex = 0
				--else if WheelIndex == 3 then WheelIndex = 2
			)
		)
		on but_SelectWheel pressed do
		(
			if WheelPoint != undefined then undo "Select Wheel Point" on select WheelPoint.node
		)
		on but_SelectUpperPivotPoint pressed do
		(
			if UpperPivotPoint != undefined then undo "Select Upper Pivot Point" on select UpperPivotPoint.node
		)
		on but_SelectLowerPivotPoint pressed do
		(
			if LowerPivotPoint != undefined then undo "Select Lower Pivot Point" on select LowerPivotPoint.node
		)
		on but_ClearWheel pressed do
		(
			WheelPoint = undefined
			pck_Wheel.object = undefined
		)
		on but_ClearUpperPivotPoint pressed do
		(
			UpperPivotPoint = undefined
			pck_UpperPivotPoint.object = undefined
		)
		on but_ClearLowerPivotPoint pressed do
		(
			LowerPivotPoint = undefined
			pck_LowerPivotPoint.object = undefined
		)
		on StructWishboneHub open do
		(
			if UpperPivotPoint != undefined then pck_UpperPivotPoint.object = UpperPivotPoint.node
			if LowerPivotPoint != undefined then pck_LowerPivotPoint.object = LowerPivotPoint.node
			if WheelPoint != undefined then pck_Wheel.object = WheelPoint.node
			InitFields()
		)
	)
)
StructureWishboneMount = attributes StructureWishboneMount_Def attribid:#(0x175ecb79, 0x72a043db) version:1
(
	parameters main rollout:StructWishboneMountRollout
	(
		MountType type:#string default:WishboneMountTypes[1]
		MountType_Selection type:#integer ui:dpdn_WishboneMountType default:1
		MountWheel type:#integer default:0
		MountWheel_Selection type:#integer ui:dpdn_WheelNumber default:1
		MountAxis type:#integer default:0
		MountAxis_Selection type:#integer ui:dpdn_MountAxis default:1
		MountPoint type:#maxObject ui:pck_MountPoint
	)
	rollout StructWishboneMountRollout "Wishbone Mount"
	(
		dropdownlist dpdn_WishboneMountType "Axel Type" items:WishboneMountTypes default:1 labelontop:true
		dropdownlist dpdn_WheelNumber "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		dropdownlist dpdn_MountAxis "Wishbone Pivot" items:WishbonePivotAxis default:1 labelontop:true
		label lbl_MountPoint "Mount Point"
		pickbutton pck_MountPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearMountPoint "Clear" across:2
		button but_SelectMountPoint "Select"
		
		fn InitFields =
		(
			if MountType_Selection == 5 then
			(
				dpdn_MountAxis.enabled = false
			)
			else 
			(
				dpdn_MountAxis.enabled = true
			)
		)
		on pck_MountPoint picked obj do
		(
			MountPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_WishboneMountType selected selectedIndex do
		(
			MountType = WishboneMountTypes[selectedIndex]
			InitFields()
		)
		on dpdn_WheelNumber selected selectedIndex do
		(
			MountWheel = selectedIndex-1
		)
		on dpdn_MountAxis selected selectedIndex do
		(
			MountAxis = selectedIndex-1
		)
		on but_SelectMountPoint pressed do
		(
			if MountPoint != undefined then undo "Select Mount Point" on select MountPoint.node
		)
		on but_ClearMountPoint pressed do
		(
			MountPoint = undefined
			pck_MountPoint.object = undefined
		)
		on StructWishboneMountRollout open do
		(
			if MountPoint != undefined then pck_MountPoint.object = MountPoint.node
			InitFields()
		)
	)
)
StructureWishboneAxleAttributes = attributes StructureWishboneAxle_Def attribId:#(0x554a6e27, 0x293d07d) version:1
(
	parameters main rollout:StructWishboneRollout
	(
		WishboneAxleType type:#string default:WishboneAxelTypes[1]
		WishboneAxleType_Selection type:#integer ui:dpdn_WishboneAxleType default:1
		WheelNumber type:#integer default:0
		WheelNumber_Selection type:#integer ui:dpdn_WheelNumber default:1
		PivotAxis type:#integer default:0
		PivotAxis_Selection type:#integer ui:dpdn_PivotAxis default:1
		InboardPivotPoint type:#maxObject ui:pck_InboardPivotPoint
		OutboardPivotPoint type:#maxObject ui:pck_OutboardPivotPoint
	)
	rollout StructWishboneRollout "Wishbone Axle"
	(
		dropdownlist dpdn_WishboneAxleType "Axel Type" items:WishboneAxelTypes default:1 labelontop:true
		dropdownlist dpdn_WheelNumber "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		dropdownlist dpdn_PivotAxis "Wishbone Pivot" items:WishbonePivotAxis default:1 labelontop:true
		label lbl_InboardPivot "Inboard Pivot Point"
		pickbutton pck_InboardPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearInboardPoint "Clear" across:2
		button but_SelectInboardPoint "Select"
		label lbl_OutboardPivot "Outboard Pivot Point"
		pickbutton pck_OutboardPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearOutboardPoint "Clear" across:2
		button but_SelectOutboardPoint "Select"
		
		fn InitFields =
		(
			WheelNumber = WheelNumber_Selection - 1
			
			if WishboneAxleType_Selection == 4 then
			(
				dpdn_PivotAxis.enabled = false
				lbl_InboardPivot.enabled = false
				--pck_InboardPivotPoint.enabled = false
				--but_ClearInboardPoint.enabled  = false
				--but_SelectInboardPoint.enabled = false
				
				lbl_OutboardPivot.enabled = false
				pck_OutboardPivotPoint.enabled = false
				but_ClearOutboardPoint.enabled= false
				but_SelectOutboardPoint.enabled = false
				if WheelNumber==1 then WheelNumber = 0
				if WheelNumber==3 then WheelNumber = 2
				
			)
			else
			(
				dpdn_PivotAxis.enabled = true
				lbl_InboardPivot.enabled = true
				pck_InboardPivotPoint.enabled = true
				but_ClearInboardPoint.enabled  = true
				but_SelectInboardPoint.enabled = true
				
				lbl_OutboardPivot.enabled = true
				pck_OutboardPivotPoint.enabled = true
				but_ClearOutboardPoint.enabled= true
				but_SelectOutboardPoint.enabled = true
			)
		)
		on pck_InboardPivotPoint picked obj do
		(
			InboardPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_OutboardPivotPoint picked obj do
		(
			OutboardPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on StructWishboneRollout open do
		(
			if InboardPivotPoint != undefined then pck_InboardPivotPoint.object = InboardPivotPoint.node
			if OutboardPivotPoint != undefined then pck_OutboardPivotPoint.object = OutboardPivotPoint.node
				
			InitFields()
		)
		
		on dpdn_WishboneAxleType selected selectedIndex do
		(
			WishboneAxleType = WishboneAxelTypes[WishboneAxleType_Selection]
			
			InitFields()
		)
		on dpdn_WheelNumber selected selectedIndex do
		(
			WheelNumber = WheelNumber_Selection - 1
			if WishboneAxleType_Selection== 4 then 
			(
				if WheelNumber==1 then WheelNumber = 0
				if WheelNumber==3 then WheelNumber = 2
			)
		)
		on dpdn_PivotAxis selected selectedIndex do
		(
			PivotAxis = PivotAxis_Selection - 1
		)
		on but_SelectInboardPoint pressed do
		(
			if InboardPivotPoint != undefined then undo "Select Inboard Pivot Point" on select InboardPivotPoint.node
		)
		on but_ClearInboardPoint pressed do
		(
			InboardPivotPoint = undefined
			pck_InboardPivotPoint.object = undefined
		)
		on but_SelectOutboardPoint pressed do
		(
			if OutboardPivotPoint != undefined then undo "Select Outboard Pivot Point" on select OutboardPivotPoint.node
		)
		on but_ClearOutboardPoint pressed do
		(
			OutboardPivotPoint = undefined
			pck_OutboardPivotPoint.object = undefined
		)
	)
)
StructureRotatePointToPointAttribute = attributes StructureRotatePointToPoint_Def attribID:#(0x1256a6ee, 0x7bda5c62) version:1
(
	parameters main rollout:MainPointToPointRollout
	(
		TypeOfPointToPoint_Selection type:#integer ui:dpdn_TypeOfPointToPoint default:1
		TypeOfPointToPoint type:#string default:StructurePointToPointValues[1]
		PreIK type:#boolean ui:chk_PreIK default: false
		PointOnThisObject type:#maxObject ui:pck_PointOnThisObject
		OtherObject type:#maxObject
		PointOnOtherObject type:#maxObject ui:pck_PointOnOtherObject
		LineTargetObject type:#maxObject ui:pck_LineTargetObject
	)
	rollout MainPointToPointRollout "Point To Point Settings"
	(
		dropdownlist dpdn_TypeOfPointToPoint items:StructurePointToPointValues labelOnTop:true
		checkbox chk_PreIK "Perform Before IK" default: false
		label lbl_PointOnThisObject "Point On This Object"
		pickbutton pck_PointOnThisObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearThisPoint "Clear" across:2
		button but_SelectThisPoint "Select"
		label lbl_OtherObject "Other Object"
		pickbutton pck_OtherObject "Pick Object" filter:target_cnt_filter autodisplay:true labelOnTop:true
		button but_ClearOtherObject "Clear" across:2
		button but_SelectOtherObject "Select"
		label lbl_PointOnOtherObject "Point On Other Object"
		pickbutton pck_PointOnOtherObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearOtherPoint "Clear" across:2
		button but_SelectOtherPoint "Select"
		label lbl_LineTargetObject "Line Target"
		pickbutton pck_LineTargetObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearLineTarget "Clear" across:2
		button but_SelectLineTarget "Select"
		
		on but_SelectThisPoint pressed do
		(
			if PointOnThisObject != undefined then undo "Select Point On This Object" on select PointOnThisObject.node
		)
		on but_ClearThisPoint pressed do
		(
			PointOnThisObject = undefined
			pck_PointOnThisObject.object = undefined
		)
		on but_SelectOtherObject pressed do
		(
			if OtherObject != undefined and OtherObject.node != undefined then undo "Select Other Object" on select OtherObject.node
		)
		on but_ClearOtherObject pressed do
		(
			OtherObject = undefined
			pck_OtherObject.object = undefined
		)
		on but_SelectOtherPoint pressed do
		(
			if PointOnOtherObject != undefined then undo "Select Point On Other Object" on select PointOnOtherObject.node
		)
		on but_ClearOtherPoint pressed do
		(
			PointOnOtherObject = undefined
			pck_PointOnOtherObject.object = undefined
		)
		on but_SelectLineTarget pressed do
		(
			if LineTargetObject != undefined then undo "Select Line Target Point" on select LineTargetObject.node
		)
		on but_ClearLineTarget pressed do
		(
			LineTargetObject = undefined
			pck_LineTargetObject.object = undefined
		)
		
		on pck_PointOnThisObject picked obj do
		(
			PointOnThisObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_OtherObject picked obj do
		(
			OtherObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_PointOnOtherObject picked obj do
		(
			PointOnOtherObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_LineTargetObject picked obj do
		(
			LineTargetObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_TypeOfPointToPoint selected selectedIndex do
		(
			TypeOfPointToPoint=StructurePointToPointValues[selectedIndex]
		)
		fn InitFields =
		(
			if PointOnThisObject != undefined then pck_PointOnThisObject.object = PointOnThisObject.node
			if OtherObject != undefined then pck_OtherObject.object = OtherObject.node
			if PointOnOtherObject != undefined then pck_PointOnOtherObject.object = PointOnOtherObject.node
			if LineTargetObject != undefined then pck_LineTargetObject.object = LineTargetObject.node
				
			if TypeOfPointToPoint_Selection == 2 then
			(
				pck_LineTargetObject.enabled = true
			)
			else
			(
				pck_LineTargetObject.enabled = false
			)
			if TypeOfPointToPoint_Selection == 4 then
			(
				chk_PreIK.enabled = false
			)
			else 
			(
				chk_PreIK.enabled = true
			)
		)
		on MainPointToPointRollout open do
		(
			InitFields()
		)
	)
)

StructureAnimationAttributes = attributes StructureAnimation_Def attribID:#(0x42fd67ae, 0x76e6282d) version:1
(
	local VibrateRollout
	parameters main rollout:MainAnimationRollout
	(
		AnimationTypeSelection type:#integer default:1 ui:dpdn_AnimationType
		AnimationType type:#string default:"Rotate"
		
		PreIK type:#boolean default:false ui:chk_PreIK
		Axis type:#integer default:1 ui:dpdn_Axis
		
		ControlledBySelection type:#integer default:1 ui:dpdn_ControlledBy
		ControlledBy type:#string default:"CONSTANT"
		Amount type:#float default:1.0 ui:spn_Amount
		Amount2 type:#float default:1.0 ui:spn_Amount2
		CentreOfRotation type:#maxObject ui:pck_CentreOfRotation
		UseNamedObject type:#boolean default:false ui:chk_UseNamedObject
		NamedObject type:#maxObject ui:pck_NamedObject
	)
	parameters vibrateSettings rollout:VibrateRollout
	(
		MinFreq type:#float default:1.0 ui:spn_MaxFreq
		MaxFreq type:#float default:2.0 ui:spn_MaxFreq
		RandomFreq type:#float default:0.5 ui:spn_RandomFreq
		MinAmp type:#float default:1.0 ui:spn_MinAmp
		MaxAmp type:#float default:10.0 ui:spn_MaxAmp
		RandomAmp type:#float default:0.5 ui:spn_RandomAmp
	)
	rollout MainAnimationRollout "Animation Settings"
	(
		dropdownlist dpdn_AnimationType "Animation Type" labelOnTop:true items:StructureAnimationTypes
		checkbox chk_PreIK "Perform Before IK" labelOnTop:true
		dropdownlist dpdn_Axis "Local Axis" labelOnTop:true items:#("X","Y","Z")
		
		
		dropdownlist dpdn_ControlledBy "Controller" labelOnTop:true items:StructureAnimationControllers
		
		spinner spn_Amount "Amount" range:[-1000,1000,1]
		spinner spn_Amount2 "Amount 2" range:[-1000,1000,1]
		
		label lbl_CentreOfRotation "Centre Of Rotation"
		pickbutton pck_CentreOfRotation "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearCoR "Clear" across:2
		button but_SelectCoR "Select"
		checkbox chk_UseNamedObject "Use Named Object"
		pickbutton pck_NamedObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearNamed "Clear" across:2
		button but_SelectNamed "Select"
		
		on pck_CentreOfRotation picked obj do
		(
			CentreOfRotation = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_NamedObject picked obj do
		(
			NamedObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on but_SelectCoR pressed do
		(
			if CentreOfRotation != undefined then undo "Select Centre Of Rotation" on select CentreOfRotation.node
		)
		on but_SelectNamed pressed do
		(
			if NamedObject != undefined then undo "Select Named Object" on select NamedObject.node
		)
		on but_ClearCoR pressed do
		(
			CentreOfRotation = undefined
			pck_CentreOfRotation.object = undefined
		)
		on but_ClearNamed pressed do
		(
			NamedObject = undefined
			pck_NamedObject.object = undefined
		)
		fn InitFields =
		(
			if CentreOfRotation != undefined then pck_CentreOfRotation.object = CentreOfRotation.node
			if NamedObject != undefined then pck_NamedObject.object = NamedObject.node
			
			if chk_PreIK.checked then
			(
				chk_UseNamedObject.enabled = false
				pck_NamedObject.enabled = false
			)
			else
			(
				chk_UseNamedObject.enabled = true
				if chk_UseNamedObject.checked then
				(
					pck_NamedObject.enabled = true
				)
				else
				(
					pck_NamedObject.enabled = false
				)
			)
			chk_PreIK.enabled = false
				
			case AnimationType of
			(
				"Rotate":
				(
					spn_Amount.enabled = true
					spn_Amount.caption = "Degrees"
					spn_Amount2.enabled = false
					spn_Amount2.caption = "Amount 2"
					pck_CentreOfRotation.enabled = false
					chk_PreIK.enabled = true
				)
				"Slide":
				(
					spn_Amount.enabled = true
					spn_Amount.caption = "Distance"
					spn_Amount2.enabled = false
					spn_Amount2.caption="Amount 2"
					pck_CentreOfRotation.enabled = false
				)
				"Oscillate":
				(
					spn_Amount.enabled = true
					spn_Amount.caption = "Minimum"
					spn_Amount2.enabled = true
					spn_Amount2.caption="Maximum"
					pck_CentreOfRotation.enabled = false
				)
				"Rock":
				(
					spn_Amount.enabled =true
					spn_Amount.caption="Speed"
					spn_Amount2.caption = "Degrees"
					spn_Amount2.enabled=true
					pck_CentreOfRotation.enabled = true
				)
				"Vibrate":
				(
					pck_CentreOfRotation.enabled = true
					spn_Amount.enabled =false
					spn_Amount2.enabled =false
					spn_Amount.caption = "Amount"
					spn_Amount2.caption = "Amount 2"

				)
			)
		)
		on MainAnimationRollout open do
		(
			InitFields()
		)
		on dpdn_ControlledBy selected selectedIndex do
		(
			ControlledBy = StructureAnimationControllers[selectedIndex]
		)
		on dpdn_AnimationType selected selectedIndex do
		(
			AnimationType = StructureAnimationTypes[selectedIndex]
			--VibrateRollout.InitFields()
			InitFields()
			
			case AnimationType of
			(
				"Vibrate":
				(
					VibrateRollout.spn_MinFreq.enabled = true
					VibrateRollout.spn_MaxFreq.enabled = true
					VibrateRollout.spn_RandomFreq.enabled = true
					VibrateRollout.spn_MinAmp.enabled = true
					VibrateRollout.spn_MaxAmp.enabled = true
					VibrateRollout.spn_RandomAmp.enabled = true
				)
				default:
				(
					VibrateRollout.spn_MinFreq.enabled = false
					VibrateRollout.spn_MaxFreq.enabled = false
					VibrateRollout.spn_RandomFreq.enabled = false
					VibrateRollout.spn_MinAmp.enabled = false
					VibrateRollout.spn_MaxAmp.enabled = false
					VibrateRollout.spn_RandomAmp.enabled = false
				)
			)	
		)
		on chk_UseNamedObject changed thestate do
		(
			if thestate then 
			(
				pck_NamedObject.enabled = true
			)
			else
			(
				pck_NamedObject.enabled = false
			)
		)
	)
	rollout VibrateRollout "Vibration Settings"
	(
		spinner spn_MinFreq "Min Frequency" range:[0,100000,1]
		spinner spn_MaxFreq "Max Frequency" range:[0,100000,2]
		spinner spn_RandomFreq "Random Freq" randge:[0,1,0.5]
		spinner spn_MinAmp "Min Amplitude" range:[0,100000,1]
		spinner spn_MaxAmp "Max Amplitude" range:[0,100000,2]
		spinner spn_RandomAmp "Random Amp" randge:[0,1,0.5]
		
		fn InitFields =
		(
			case AnimationType of
			(
				"Vibrate":
				(
					spn_MinFreq.enabled = true
					spn_MaxFreq.enabled = true
					spn_RandomFreq.enabled = true
					spn_MinAmp.enabled = true
					spn_MaxAmp.enabled = true
					spn_RandomAmp.enabled = true
				)
				default:
				(
					spn_MinFreq.enabled = false
					spn_MaxFreq.enabled = false
					spn_RandomFreq.enabled = false
					spn_MinAmp.enabled = false
					spn_MaxAmp.enabled = false
					spn_RandomAmp.enabled = false
				)
			)
		)
		on VibrateRollout open do
		(
			InitFields()
		)
	)
)
/*********************************
***** CAR STRUCT WELD ATTRIBUTES
*********************************/

StructureWeldAttribute = attributes StructureWeld_Def attribID: #(0x102e05ef, 0x426da9ad) version:1
(
	parameters main rollout:MainWeldRollout
	(
		WeldName type:#string ui:txt_WeldName default:""
		WeldPartner type:#maxObject
		--VertexColour type:#color ui:colpick_VertexColour default:(color 0 255 0 0)
		VertexColourR type:#integer ui:spn_colour_r default:0
		VertexColourG type:#integer ui:spn_colour_g default:255
		VertexColourB type:#integer ui:spn_colour_b default:0
		VertexColourA type:#integer ui:spn_colour_a default:0
		WeldVertexType type:#stringTab tabSizeVariable:true
		WeldVertexPosition type:#point3Tab tabSizeVariable:true
		
		Weakness_Set type:#boolean default:false ui:chk_Weakness_Set
		Weakness type:#float default: 1.0 ui:spn_Weakness
		AbsoluteLimit_Set type:#boolean default:false ui:chk_AbsoluteLimit_Set
		AbsoluteLimit type:#float default:1.0 ui:spn_AbsoluteLimit
		ChanceOfFailure_Set type:#boolean default:false ui:chk_ChanceOfFailure_Set
		ChanceOfFailure type:#float default:1.0 ui:spn_ChanceOfFailure
		WeldBreak_Set type:#boolean default:false ui:chk_WeldBreak_Set
		WeldBreak type:#float default:1.0 ui:spn_WeldBreak
		GangedBreak type:#string ui:txt_GangedBreak default:""
	)
	parameters joints rollout:JointsRollout
	(
		Joints type:#nodeTab tabSizeVariable: true
	)
	
	rollout MainWeldRollout "Weld Parameters"
	(
		edittext txt_WeldName "Weld Name" labelOnTop:true
		pickbutton objpick_WeldPartner "Weld Partner" filter:target_cnt_filter autodisplay:true labelOnTop:true
		button but_ClearWeldPartner "Clear" across:2
		button but_SelectWeldPartner "Select" across:2
		
		checkbox chk_Weakness_Set "" across:2
		spinner spn_Weakness "Weakness" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_AbsoluteLimit_Set "" across:2
		spinner spn_AbsoluteLimit "Absolute Limit" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_ChanceOfFailure_Set "" across:2
		spinner spn_ChanceOfFailure "Chance Of Fail" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_WeldBreak_Set "" across:2
		spinner spn_WeldBreak "Break" range:[-10,100,1] type:#float fieldwidth: 40
		
		edittext txt_GangedBreak "Ganged Break" labelOnTop:true
		label lbl_colour_r "R" across: 4
		label lbl_colour_g "G" across: 4
		label lbl_colour_b "B" across: 4
		label lbl_colour_a "A" across: 4
		spinner spn_colour_r "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_g "" across:4 range:[0, 255,255] type:#integer fieldwidth: 30
		spinner spn_colour_b "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_a "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		
		--colorpicker colpick_VertexColour "Weld Vertex Colour"
		
		
		group "Weld Vertices"
		(
			checkbutton chkbut_CarSpace "Car Space" default:false across:2
			checkbutton chkbut_PartSpace "Part Space" default:false across:2
			spinner spn_WeldVertX "" type:#worldunits range:[-10000, 10000, 0] across:4 fieldwidth:30
			spinner spn_WeldVertY "" type:#worldunits range:[-10000, 10000, 0] across:4 fieldwidth:30
			spinner spn_WeldVertZ "" type:#worldunits range:[-10000, 10000, 0] across:4 fieldwidth:30
			button but_AddVertToWeld "Add" across:4
			dotnetcontrol lv_WeldVertices "listview" height: 100
			button but_DelVertFromWeld "Delete"
		)
		
		on objpick_WeldPartner picked obj do
		(
			WeldPartner = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on but_SelectWeldPartner pressed do
		(
			if WeldPartner != undefined then ( undo "Select Weld Partner" on ( select WeldPartner.node ) )
		)
		on but_CleaWeldPartner pressed do
		(
			WeldPartner = undefined
			objpick_WeldPartner.object = undefined
		)
		
		on chkbut_CarSpace changed state do
		(
			if state==true then
			(
				chkbut_PartSpace.checked = false
			)
		)
		on chkbut_CarSpace changed state do
		(
			if state==true then
			(
				chkbut_PartSpace.checked = false
			)
		)
		on chkbut_PartSpace changed state do
		(
			if state==true then
			(
				chkbut_CarSpace.checked = false
			)
		)
		fn InitFields =
		(
			chk_Weakness_Set.pos = [chk_Weakness_Set.pos.x-7, chk_Weakness_Set.pos.y]
			chk_AbsoluteLimit_Set.pos = [chk_AbsoluteLimit_Set.pos.x-7, chk_AbsoluteLimit_Set.pos.y]
			chk_ChanceOfFailure_Set.pos = [chk_ChanceOfFailure_Set.pos.x-7, chk_ChanceOfFailure_Set.pos.y]
			chk_WeldBreak_Set.pos = [chk_WeldBreak_Set.pos.x-7, chk_WeldBreak_Set.pos.y]
			
			spn_Weakness.pos = [spn_Weakness.pos.x+4, spn_Weakness.pos.y]
			spn_AbsoluteLimit.pos = [spn_AbsoluteLimit.pos.x+4, spn_AbsoluteLimit.pos.y]
			spn_ChanceOfFailure.pos = [spn_ChanceOfFailure.pos.x+4, spn_ChanceOfFailure.pos.y]
			spn_WeldBreak.pos = [spn_WeldBreak.pos.x+4, spn_WeldBreak.pos.y]
			
			if Weakness_Set then spn_Weakness.enabled = true
			else spn_Weakness.enabled = false
			
			if AbsoluteLimit_Set then spn_AbsoluteLimit.enabled = true
			else spn_AbsoluteLimit.enabled = false
			
			if ChanceOfFailure_Set then spn_ChanceOfFailure.enabled = true
			else spn_ChanceOfFailure.enabled = false
			
			if WeldBreak_Set then spn_WeldBreak.enabled  = true
			else spn_WeldBreak.enabled = false
		)
		on chk_Weakness_Set changed state do
		(
			spn_Weakness.enabled = state
		)
		on chk_AbsoluteLimit_Set changed state do
		(
			spn_AbsoluteLimit.enabled = state
		)
		on chk_ChanceOfFailure_Set changed state do
		(
			spn_ChanceOfFailure.enabled = state
		)
		on chk_WeldBreak_Set changed state do
		(
			spn_WeldBreak.enabled = state
		)
		on MainWeldRollout open do
		(			
			InitFields()
			if WeldPartner != undefined then objpick_WeldPartner.object = WeldPartner.node
			
			but_AddVertToWeld.pos = [120, but_AddVertToWeld.pos.y]
			lv_WeldVertices.view  = (dotnetclass "view").details
			lv_WeldVertices.fullrowselect= true
			lv_WeldVertices.gridlines = true
			lv_WeldVertices.multiselect =false
			lv_WeldVertices.columns.add "Space" 35
			lv_WeldVertices.columns.add "X" 25
			lv_WeldVertices.columns.add "Y" 25
			lv_WeldVertices.columns.add "Z" 25
			for i=1 to WeldVertexPosition.count do
			(
				lvItem = dotnetobject "listviewitem" WeldVertexType[i]
				lvitem.subitems.add (WeldVertexPosition[i].x as string)
				lvitem.subitems.add (WeldVertexPosition[i].y as string)
				lvitem.subitems.add (WeldVertexPosition[i].z as string)
				lv_WeldVertices.Items.add lvitem
			)
			lbl_colour_r.pos = [15,lbl_colour_r.pos.y]
			spn_colour_r.pos = [spn_colour_r.pos.x - 8,spn_colour_r.pos.y]
			
			lbl_colour_g.pos = [spn_colour_r.pos.x+25,lbl_colour_g.pos.y]
			spn_colour_g.pos = [spn_colour_g.pos.x - 1,spn_colour_r.pos.y]
			
			lbl_colour_b.pos = [spn_colour_g.pos.x+25,lbl_colour_b.pos.y]
			spn_colour_b.pos = [spn_colour_b.pos.x+6,spn_colour_r.pos.y]
			
			lbl_colour_a.pos = [spn_colour_b.pos.x+25,lbl_colour_a.pos.y]
			spn_colour_a.pos = [spn_colour_a.pos.x + 13,spn_colour_r.pos.y]
		)
		on but_DelVertFromWeld pressed do
		(
			if lv_WeldVertices.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_WeldVertices.SelectedIndices.Item[0]
				lv_WeldVertices.Items.removeat selectedIndex
				deleteItem WeldVertexType (selectedIndex+1)
				deleteItem WeldVertexPosition (selectedIndex+1)
			)
		)
		on but_AddVertToWeld pressed do
		(
			
			weldType = undefined
			if chkbut_CarSpace.checked == true then weldType="Car"
			else if chkbut_PartSpace.checked then weldType="Part"
			if weldType!= undefined then
			(				
				lvItem = dotnetobject "listviewitem" weldType
				lvItem.subitems.add (spn_WeldVertX.value as string)
				lvItem.subitems.add (spn_WeldVertY.value as string)
				lvItem.subitems.add (spn_WeldVertZ.value as string)
				lv_WeldVertices.Items.add lvItem
				append WeldVertexType weldType
				append WeldVertexPosition [spn_WeldVertX.value, spn_WeldVertY.value, spn_WeldVertZ.value]
			)
		)
	)
	rollout jointsrollout "Joints"
	(
		group "Joints"
		(
			pickbutton pckbut_WeldJoint "Pick Joint" filter:pickJointFilter autodisplay:true
			button but_AddJoint "Add Joint"
			
			dotnetcontrol lv_Joints "listview" height: 100
			button but_DeleteJoint "Delete Joint"
		)
		
		on jointsrollout open do
		(
			lv_Joints.view  = (dotnetclass "view").details
			lv_Joints.fullrowselect= true
			lv_Joints.gridlines = true
			lv_Joints.multiselect =false
			lv_Joints.columns.add "Joint Name" 110
			for i=1 to Joints.count do
			(
				lv_Joints.Items.add joints[i].name
			)
		)
		on but_AddJoint pressed do
		(
			if pckbut_WeldJoint.object != undefined then
			(
				append joints pckbut_WeldJoint.object
				lv_Joints.Items.add pckbut_WeldJoint.object.name
				pckbut_WeldJoint.object = undefined
			)
		)
		on but_DeleteJoint pressed do
		(
			if lv_Joints.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_Joints.SelectedIndices.Item[0]
				lv_Joints.Items.removeat selectedIndex
				deleteItem Joints (selectedIndex+1)
			)
		)
	)
)
/*********************************
***** CAR STRUCT PART ATTRIBUTES
*********************************/
StructPhysProps = #(
	"NONE",
	"FRONT_LEFT_WHEEL",
	"FRONT_RIGHT_WHEEL",
	"REAR_LEFT_WHEEL",
	"REAR_RIGHT_WHEEL",
	"FRONT_LEFT_POINT_OF_ROTATION",
	"FRONT_RIGHT_POINT_OF_ROTATION",
	"REAR_LEFT_POINT_OF_ROTATION",
	"REAR_RIGHT_POINT_OF_ROTATION",
	"FRONT_LEFT_POINT_OF_SUSPENSION",
	"REAR_LEFT_POINT_OF_SUSPENSION",
	"FRONT_RIGHT_POINT_OF_SUSPENSION",
	"REAR_RIGHT_POINT_OF_SUSPENSION",
	"FRONT_LEFT_POINT_OF_STEERING",
	"REAR_LEFT_POINT_OF_STEERING",
	"FRONT_RIGHT_POINT_OF_STEERING",
	"REAR_RIGHT_POINT_OF_STEERING",
	"LEFT_STEERING",
	"RIGHT_STEERING",
	"STEERING_WHEEL"
)

StructFunctionalLightTypes = #(
	"HEAD_LIGHT",
	"SIDE_LIGHT",
	"REVERSE_LIGHT",
	"BRAKE_LIGHT",
	"TAIL_LIGHT",
	"SIREN_LIGHT",
	"STROBE1_LIGHT",
	"STROBE2_LIGHT"
)

StructurePartAttribute = attributes StructurePart_Def attribID:#(0x70f93a7a, 0x40afe183) version:1
(
	
	parameters renderLevel rollout:RenderLevelParams
	(
		RenderLevel_Set type:#boolean default:true ui:chk_RenderLevel_Set
		RenderLevel type:#integer default:1 ui:spn_RenderLevel
		LumpRenderLevel_Node type:#maxobjectTab tabSizeVariable:true
		LumpRenderLevel_Value type:#intTab tabSizeVariable:true
	)
	
	rollout RenderLevelParams "Render Level"
	(
		checkbox chk_RenderLevel_Set "" across:2
		spinner spn_RenderLevel "Render Level" range:[1,100,1] type:#integer fieldwidth: 40
		
		label lbl_LumpRenderLevel "Named Render Level"
		pickbutton pck_LumpRenderLevel_Node "Pick Object" filter:target_helper_filter autodisplay:true across:3
		spinner spn_LumpRenderLevel_Value "" range:[1,100,1] type:#integer fieldwidth:40 across:3
		button but_AddLumpRenderLevel "Add"
		dotnetcontrol lv_LumpRenderLevel "listview" height: 100
		button but_DeleteLumpRenderLevel "Delete Selected"
		
		on RenderLevelParams open do
		(			
			but_AddLumpRenderLevel.pos = [125, but_AddLumpRenderLevel.pos.y]
			spn_LumpRenderLevel_Value.pos = [spn_LumpRenderLevel_Value.pos.x+18, but_AddLumpRenderLevel.pos.y+3]
			lv_LumpRenderLevel.view  = (dotnetclass "view").details
			lv_LumpRenderLevel.fullrowselect= true
			lv_LumpRenderLevel.gridlines = true
			lv_LumpRenderLevel.multiselect =false
			lv_LumpRenderLevel.columns.add "Object" 70
			lv_LumpRenderLevel.columns.add "Level" 40
			for i=1 to LumpRenderLevel_Node.count do
			(
				if LumpRenderLevel_Node[i] == undefined or LumpRenderLevel_Node[i].node == undefined then
				(
					deleteitem LumpRenderLevel_Node i
					i = i - 1;
				)
				else
				(
					lvItem = dotnetobject "listviewitem" LumpRenderLevel_Node[i].node.name
					lvitem.subitems.add (LumpRenderLevel_Value[i] as string)
					lv_LumpRenderLevel.Items.add lvitem
				)
			)
		)
		on but_AddLumpRenderLevel pressed do
		(
			if pck_LumpRenderLevel_Node.object != undefined then
			(
				append LumpRenderLevel_Node (nodeTransformMonitor node:pck_LumpRenderLevel_Node.object forwardTransformChangeMsgs:false)
				append LumpRenderLevel_Value spn_LumpRenderLevel_Value.value
				lvItem = dotnetobject "listviewitem" pck_LumpRenderLevel_Node.object.name
				lvitem.subitems.add (spn_LumpRenderLevel_Value.value as string)
				lv_LumpRenderLevel.Items.add lvitem
			)
		)
		on but_DeleteLumpRenderLevel pressed do
		(
			if lv_LumpRenderLevel.SelectedIndices.count > 0 then
			(
				if LumpRenderLevel_Node.count > 0 then deleteItem LumpRenderLevel_Node (lv_LumpRenderLevel.SelectedIndices.Item[0] + 1)
				if LumpRenderLevel_Value.count > 0 then deleteItem LumpRenderLevel_Value (lv_LumpRenderLevel.SelectedIndices.Item[0] + 1)
				lv_LumpRenderLevel.Items.removeat lv_LumpRenderLevel.SelectedIndices.Item[0]
			)
		)
	)
	parameters main rollout:StructurePartParams
	(
		Crushability_Set type:#boolean default:false ui:chk_Crushability_set
		Crushability type:#float default:1 ui:spn_Crushability
		Stiffness_Set type:#boolean default:false ui:chk_Stiffness_Set
		Stiffness type:#float default: 0.3 ui:spn_Stiffness
		Resiliance_Set type:#boolean default:false ui:chk_Resiliance_Set
		Resiliance type:#float default:5 ui:spn_Resiliance
		Mass_Set type:#boolean default:false ui:chk_Mass_Set
		Mass type:#float default:100 ui:spn_Mass
		Restitution_Set type:#boolean default:false ui:chk_Restitution_Set
		Restitution type:#float default:100 ui:spn_Restitution
		
		--ShapeType_Set type:#boolean default:false ui:chk_ShapeType
		
		
		
	)
	rollout StructurePartParams "Basic Settings"
	(
		checkbox chk_Crushability_set "" across:2
		spinner spn_Crushability "Crushability" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_Stiffness_Set "" across:2
		spinner spn_Stiffness "Stiffness" range:[0,1,0.3] fieldwidth: 40
		checkbox chk_Resiliance_Set "" across:2
		spinner spn_Resiliance "Resiliance" range:[0,100,5] fieldwidth: 40
		checkbox chk_Mass_Set "" across:2
		spinner spn_Mass "Mass" range:[0,10000,100] fieldwidth: 40
		checkbox chk_Restitution_Set "" across:2
		spinner spn_Restitution "Restitution" range:[0,100,2] fieldwidth: 40
		
		
		on StructurePartParams open do
		(
			spn_Crushability.enabled =Crushability_Set
			spn_Stiffness.enabled =Stiffness_Set
			spn_Resiliance.enabled =Resiliance_Set
			spn_Mass.enabled =Mass_Set
		)
		on StructurePartParams close do
		(
		)
		
		on chk_Crushability_set changed state do
		(
			spn_Crushability.enabled = state
		)
		on chk_Stiffness_Set changed state do
		(
			spn_Stiffness.enabled = state
		)
		on chk_Resiliance_Set changed state do
		(
			spn_Resiliance.enabled = state
		)
		on chk_Mass_Set changed state do
		(
			spn_Mass.enabled = state
		)
	)
	
	
	parameters physicsProps rollout:PhysicsPropertiesParams
	(
		
		AlwaysJointed type:#boolean default:false ui:chk_AlwaysJointed
		PhysicsProperties type:#stringTab tabSizeVariable:true
		ShapeType type:#string ui:txt_ShapeType default: ""
		CollisionBoundsMultiplier_Set type:#boolean default: false ui:chk_CollisionBoundsMultiplier_Set
		CollisionBoundsMultiplier_X type:#float ui:spn_CollisionBoundsMultiplier_X default:1.0
		CollisionBoundsMultiplier_Y type:#float ui:spn_CollisionBoundsMultiplier_Y default:1.0
		CollisionBoundsMultiplier_Z type:#float ui:spn_CollisionBoundsMultiplier_Z default:1.0
	)
	rollout PhysicsPropertiesParams "Physics Properties"
	(
		checkbox chk_AlwaysJointed "Always Jointed"
		
		--checkbox chk_ShapeType "" across:2 width: 5
		edittext txt_ShapeType "Shape Type" fieldwidth:100 labelontop:true
		
		checkbox chk_CollisionBoundsMultiplier_Set "" default: false across: 2
		label lbl_chk_CollisionBoundsMultiplier "Collision Bounds Multiplier"
		spinner spn_CollisionBoundsMultiplier_X "" range:[1,100,1] across:3 fieldwidth:30
		spinner spn_CollisionBoundsMultiplier_Y "" range:[1,100,1] across:3 fieldwidth:30
		spinner spn_CollisionBoundsMultiplier_Z "" range:[1,100,1] across:3 fieldwidth:30
		
		label lbl_PhysicsProperties "Manage Physics Properties"
		dropdownlist dpdn_PhysicsProperty "" items:StructPhysProps width: 100 across:2
		button AddToPhysprops "Add" across:2
		dotnetcontrol lv_PhysicsProperties "listview" height: 100
		button DeleteFromPhysProps "Delete Selected"
		
		on lv_PhysicsProperties selectedindexchanged do
		(
			if lv_PhysicsProperties.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_PhysicsProperties.Items.item[lv_PhysicsProperties.SelectedIndices.Item[0]].text
				dpdn_PhysicsProperty.selection = finditem StructPhysProps selectedItem
			)
		)
		on PhysicsPropertiesParams open do
		(			
			AddToPhysprops.pos = [120, AddToPhysprops.pos.y]
			lv_PhysicsProperties.view  = (dotnetclass "view").details
			lv_PhysicsProperties.fullrowselect= true
			lv_PhysicsProperties.gridlines = true
			lv_PhysicsProperties.multiselect =false
			lv_PhysicsProperties.columns.add "Physics Property" 110
			for i=1 to PhysicsProperties.count do
			(
				lv_PhysicsProperties.Items.add PhysicsProperties[i]
			)
		)
		on PhysicsPropertiesParams close do
		(
			PhysicsProperties = #()
			for i=1 to lv_PhysicsProperties.Items.count do
			(
				append PhysicsProperties lv_PhysicsProperties.Items.Item[i-1].Text
			)
		)
		on DeleteFromPhysProps pressed do
		(
			if lv_PhysicsProperties.SelectedIndices.count > 0 then lv_PhysicsProperties.Items.removeat lv_PhysicsProperties.SelectedIndices.Item[0]
		)
		on AddToPhysprops pressed do
		(
			lv_PhysicsProperties.Items.add (dpdn_PhysicsProperty.selected)
		)
	)
	
	
	parameters driverBox rollout:DriverBoxParams
	(
		DriverBoxVertexColour_R type:#intTab tabSizeVariable:true
		DriverBoxVertexColour_G type:#intTab tabSizeVariable:true
		DriverBoxVertexColour_B type:#intTab tabSizeVariable:true
		DriverBoxVertexColour_A type:#intTab tabSizeVariable:true
	)
	rollout DriverBoxParams "Driver Box"
	(
		dotnetcontrol lv_DriverBox "listview" height: 100
		--colorpicker colpick_DriverBox "Add Driver Box Vertex Colour"
		spinner spn_colour_r "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_g "" across:4 range:[0, 255,255] type:#integer fieldwidth: 30
		spinner spn_colour_b "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_a "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		button but_AddDriverBox "Add" across:2
		button but_RemoveDriverBox "Remove" across:2
		
		on DriverBoxParams open do
		(
			
			lv_DriverBox.view  = (dotnetclass "view").details
			lv_DriverBox.fullrowselect= true
			lv_DriverBox.gridlines = true
			lv_DriverBox.multiselect =false
			lv_DriverBox.columns.add "Driver Box Colour" 130
			for i=1 to DriverBoxVertexColour_R.count do
			(
				lv_DriverBox.Items.add ((DriverBoxVertexColour_R[i] as string)+", "+(DriverBoxVertexColour_G[i] as string)+", "+(DriverBoxVertexColour_B[i] as string)+", "+(DriverBoxVertexColour_A[i] as string))
			)
		)
		on but_AddDriverBox pressed do
		(
			append DriverBoxVertexColour_R spn_colour_r.value
			append DriverBoxVertexColour_G spn_colour_g.value
			append DriverBoxVertexColour_B spn_colour_b.value
			append DriverBoxVertexColour_A spn_colour_a.value
			
			lv_DriverBox.Items.add (( spn_colour_r.value as string)+", "+( spn_colour_g.value as string)+", "+( spn_colour_b.value as string)+", "+( spn_colour_a.value as string))
		)
		on but_RemoverDriverBox pressed do
		(
			if lv_DriverBox.SelectedIndices.count > 0 then 
			(
				selectedIndex = lv_DriverBox.SelectedIndices.Item[0]
				lv_DriverBox.Items.removeat selectedIndex --lv_FunctionalLights.SelectedIndices.Item[0]
				deleteItem DriverBoxVertexColour_R (selectedIndex+1)
				deleteItem DriverBoxVertexColour_G (selectedIndex+1)
				deleteItem DriverBoxVertexColour_B (selectedIndex+1)
				deleteItem DriverBoxVertexColour_A (selectedIndex+1)
				
			)
		)
	)
	
	
	parameters functionalLight rollout:FunctionalLightParams
	(
		FunctionalLightType type:#stringTab tabSizeVariable:true
		FunctionalLightObject type:#maxObjectTab tabSizeVariable:true
	)
	rollout FunctionalLightParams "Functional Lights"
	(
		
		dropdownlist dpdn_FunctionalLightTypes "Light Type" items:StructFunctionalLightTypes width: 130
		--label lbl_FunctionalLightObject "Light Object" across:2
		pickbutton pickbut_FunctionalLightObject "Pick Object" filter:target_helper_filter autodisplay:true across:2
		button AddToFuncLights "Add" 
		dotnetcontrol lv_FunctionalLights "listview" height: 100
		button DeleteFromFuncLights "Delete" across:2
		button SelectLights "Select Object"
		
		on FunctionalLightParams open do
		(
			lv_FunctionalLights.view  = (dotnetclass "view").details
			lv_FunctionalLights.fullrowselect= true
			lv_FunctionalLights.gridlines = true
			lv_FunctionalLights.multiselect =false
			lv_FunctionalLights.columns.add "Type" 55
			lv_FunctionalLights.columns.add "Object" 55
			for i=1 to FunctionalLightType.count do
			(
				lvItem = dotnetobject "listviewitem" FunctionalLightType[i]
				lvitem.subitems.add FunctionalLightObject[i].node.name
				lv_FunctionalLights.Items.add lvitem
			)
		)
		on FunctionalLightParams close do
		(
			
		)
		on lv_FunctionalLights selectedindexchanged do
		(
			/*if lv_FunctionalLights.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_FunctionalLights.SelectedIndices.Item[0]
				lightType = FunctionalLightType[selectedItem+1] --lv_FunctionalLights.Items.item[selectedItem].text
				lightObject = FunctionalLightObject[selectedItem+1]
				dpdn_FunctionalLightTypes.selection = finditem StructFunctionalLightTypes lightType
				pickbut_FunctionalLightObject.object = lightObject
			)*/
		)
		on SelectLights pressed do
		(
			if lv_FunctionalLights.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_FunctionalLights.SelectedIndices.Item[0]
				undo "Select Functional Light" on select FunctionalLightObject[selectedItem+1].node
			)
		)
		on DeleteFromFuncLights pressed do
		(
			if lv_FunctionalLights.SelectedIndices.count > 0 then 
			(
				selectedIndex = lv_FunctionalLights.SelectedIndices.Item[0]
				lv_FunctionalLights.Items.removeat selectedIndex --lv_FunctionalLights.SelectedIndices.Item[0]
				deleteItem FunctionalLightType (selectedIndex+1)
				deleteItem FunctionalLightObject (selectedIndex+1)
				
			)
		)
		on AddToFuncLights pressed do
		(
			if pickbut_FunctionalLightObject.object != undefined then
			(
				lvItem = dotnetobject "listviewitem" dpdn_FunctionalLightTypes.selected
				lvitem.subitems.add pickbut_FunctionalLightObject.object.name
				lv_FunctionalLights.Items.add lvitem
				append FunctionalLightType dpdn_FunctionalLightTypes.selected
				append FunctionalLightObject (nodeTransformMonitor node:pickbut_FunctionalLightObject.object forwardTransformChangeMsgs:false)
				pickbut_FunctionalLightObject.object = undefined
				dpdn_FunctionalLightTypes.selection=1
			)
			else messageBox "Please select an object for the light." Title:"No Object Selected"
		)
	)
	
	parameters crushDamage rollout:CrushDamageParams
	(
		
		DriverEjectionSmash type:#boolean default:false ui:chk_DriverEjectionSmash
		
		CrushDamageMaterialLevel type:#intTab tabSizeVariable:true
		CrushDamageMaterialOriginalMaterial type:#stringTab tabSizeVariable:true
		CrushDamageMaterialTargetMaterial type:#stringTab tabSizeVariable:true
		
		CrushDamageEmitterLevel type:#intTab tabSizeVariable:true
		CrushDamageEmitterName type:#stringTab tabSizeVariable:true
		CrushDamageEmitterPosition type:#maxObjectTab tabSizeVariable:true
		
	)
	rollout CrushDamageParams "Advanced Crush Damage"
	(
		
		checkbox chk_DriverEjectionSmash "Driver Ejection Smash"
		dropdownlist dpdn_CrushDamageMaterialLevel "Crush Damage Materials" labelontop:true items:#("New...")
		group "Crush Damage Material Settings"
		(
			--spinner spn_CrushDamageMaterialLevel "Damage Level" range:[-10,-1,-1] fieldwidth:30 type:#integer
			checkbutton chkbut_CurshDamageMaterialLevel1 "-1" across:5
			checkbutton chkbut_CurshDamageMaterialLevel2 "-2" across:5
			checkbutton chkbut_CurshDamageMaterialLevel3 "-3" across:5
			checkbutton chkbut_CurshDamageMaterialLevel4 "-4" across:5
			checkbutton chkbut_CurshDamageMaterialLevel5 "-5" across:5
			--dropdownlist dpdn_CrushDamageMaterialOriginalMaterial "Material To Change" items:#()
			edittext txt_CrushDamageMaterialOriginalMaterial "Original Material Name" labelontop:true
			edittext txt_CrushDamageMaterialTargetMaterial "Damaged Material Name" labelontop:true
			button but_AddCrushDamageMaterial "Set" across:2
			button but_DeleteCrushDamageMaterial "Delete" across:2
		)
		
		on chkbut_CurshDamageMaterialLevel1 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel2 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel1.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel3 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel1.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel4 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel1.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel5 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel1.checked=false
			)
		)
		fn UpdateCrushDamageMaterial selectedIndex =
		(
			
			if selectedIndex > 1 then
			(
				dmgLevel = CrushDamageMaterialLevel[selectedIndex-1]
				if dmgLevel == -1 then 
				(
					chkbut_CurshDamageMaterialLevel1.checked = true
					chkbut_CurshDamageMaterialLevel1.changed true
				)
				else if dmgLevel == -2 then 
				(
					chkbut_CurshDamageMaterialLevel2.checked = true
					chkbut_CurshDamageMaterialLevel2.changed true
				)
				else if dmgLevel == -3 then
				(
					chkbut_CurshDamageMaterialLevel3.checked = true
					chkbut_CurshDamageMaterialLevel3.changed true
				)
				else if dmgLevel == -4 then
				(
					chkbut_CurshDamageMaterialLevel4.checked = true
					chkbut_CurshDamageMaterialLevel4.changed true
				)
				else if dmgLevel == -5 then
				(
					chkbut_CurshDamageMaterialLevel5.checked = true
					chkbut_CurshDamageMaterialLevel5.changed true
				)
				txt_CrushDamageMaterialOriginalMaterial.text = CrushDamageMaterialOriginalMaterial[selectedIndex-1]
				txt_CrushDamageMaterialTargetMaterial.text = CrushDamageMaterialTargetMaterial[selectedIndex-1]
			)
			else
			(
				chkbut_CurshDamageMaterialLevel1.checked = false
				chkbut_CurshDamageMaterialLevel2.checked = false
				chkbut_CurshDamageMaterialLevel3.checked = false
				chkbut_CurshDamageMaterialLevel4.checked = false
				chkbut_CurshDamageMaterialLevel5.checked = false
				txt_CrushDamageMaterialOriginalMaterial.text = ""
				txt_CrushDamageMaterialTargetMaterial.text = ""
			)
		)
		on but_DeleteCrushDamageMaterial pressed do
		(
			if dpdn_CrushDamageMaterialLevel.selection > 1 then
			(
				selectedIndex = dpdn_CrushDamageMaterialLevel.selection - 1
				deleteItem CrushDamageMaterialLevel selectedIndex
				deleteItem CrushDamageMaterialOriginalMaterial selectedIndex
				deleteItem CrushDamageMaterialTargetMaterial selectedIndex
				crushDamageMaterialListItems =  dpdn_CrushDamageMaterialLevel.items
				deleteItem crushDamageMaterialListItems dpdn_CrushDamageMaterialLevel.selection
				dpdn_CrushDamageMaterialLevel.items = crushDamageMaterialListItems
				
				if selectedIndex + 1 > dpdn_CrushDamageMaterialLevel.items.count then
				(
					dpdn_CrushDamageMaterialLevel.selection = dpdn_CrushDamageMaterialLevel.items.count
				)
					UpdateCrushDamageMaterial dpdn_CrushDamageMaterialLevel.items.count
			)
		)
		on but_AddCrushDamageMaterial pressed do
		(
			dmgLevel = 0
			if chkbut_CurshDamageMaterialLevel1.checked then dmgLevel=-1
			else if chkbut_CurshDamageMaterialLevel2.checked then dmgLevel=-2
			else if chkbut_CurshDamageMaterialLevel3.checked then dmgLevel=-3
			else if chkbut_CurshDamageMaterialLevel4.checked then dmgLevel=-4
			else if chkbut_CurshDamageMaterialLevel5.checked then dmgLevel=-5
			if dmgLevel != 0 and txt_CrushDamageMaterialOriginalMaterial.text != "" and txt_CrushDamageMaterialTargetMaterial.text != "" then
			(
				crushDamageMaterialListItems =  dpdn_CrushDamageMaterialLevel.items 
				if dpdn_CrushDamageMaterialLevel.selection == 1 then
				(
					append CrushDamageMaterialLevel dmgLevel
					append CrushDamageMaterialOriginalMaterial txt_CrushDamageMaterialOriginalMaterial.text
					append CrushDamageMaterialTargetMaterial txt_CrushDamageMaterialTargetMaterial.text
					i = CrushDamageMaterialLevel.count
					append crushDamageMaterialListItems ((CrushDamageMaterialLevel[i] as string)+": "+(CrushDamageMaterialOriginalMaterial[i] as string)+" -> "+(CrushDamageMaterialTargetMaterial[i] as string))
					--dpdn_CrushDamageMaterialLevel.selection = dpdn_CrushDamageMaterialLevel.items.count
				)
				else
				(
					i = dpdn_CrushDamageMaterialLevel.selection-1
					CrushDamageMaterialLevel[i] = dmgLevel
					CrushDamageMaterialOriginalMaterial[i] = txt_CrushDamageMaterialOriginalMaterial.text
					CrushDamageMaterialTargetMaterial[i] = txt_CrushDamageMaterialTargetMaterial.text
					crushDamageMaterialListItems[i+1] = ((CrushDamageMaterialLevel[i] as string)+": "+(CrushDamageMaterialOriginalMaterial[i] as string)+" -> "+(CrushDamageMaterialTargetMaterial[i] as string))
				)
				dpdn_CrushDamageMaterialLevel.items  = crushDamageMaterialListItems
				dpdn_CrushDamageMaterialLevel.selection = i+1
				printArrayInFull CrushDamageMaterialLevel "CrushDamageMaterialLevel"
				printArrayInFull CrushDamageMaterialOriginalMaterial "CrushDamageMaterialOriginalMaterial"
				printArrayInFull CrushDamageMaterialTargetMaterial "CrushDamageMaterialTargetMaterial"
			)
			else
			(
				msg = ""
				if dmgLevel == 0 then msg += "Please select a damage level.\n"
				if txt_CrushDamageMaterialOriginalMaterial.text == "" then msg += "Please add the original material name.\n"
				if txt_CrushDamageMaterialTargetMaterial.text == "" then msg += "Please add a target material name.\n"
				messageBox msg title:"Error Adding Crush Damage Material"
			)
			
		)
		on dpdn_CrushDamageMaterialLevel selected selectedIndex do
		(
			UpdateCrushDamageMaterial selectedIndex
		)
		dropdownlist dpdn_CrushDamageEmitterLevel "Crush Damage Emitters" labelontop:true items:#("New...")
		group "Crush Damage Emitter Settings"
		(
			
			--spinner spn_CrushDamageEmitterLevel  "Damage Level" range:[-10,-1,-1] fieldwidth:30 type:#integer
			
			checkbutton chkbut_CurshDamageEmitterLevel1 "-1" across:5
			checkbutton chkbut_CurshDamageEmitterLevel2 "-2" across:5
			checkbutton chkbut_CurshDamageEmitterLevel3 "-3" across:5
			checkbutton chkbut_CurshDamageEmitterLevel4 "-4" across:5
			checkbutton chkbut_CurshDamageEmitterLevel5 "-5" across:5
			edittext txt_CrushDamageEmitterName "Emitter Name"
			label lbl_CrushDamageEmitterTarget "Spawn Point" across:2
			pickbutton pickbut_CrushDamageEmitterTarget "Pick Point" filter:target_helper_filter autodisplay:true
			
			button but_AddCrushDamageEmitter "Set" across:3
			button but_DeleteCrushDamageEmitter "Delete" across:3
			button but_SelectCrushDamageEmitter "Select" across:3
		)
		
		on chkbut_CurshDamageEmitterLevel1 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel2 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel1.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel3 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel1.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel4 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel1.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel5 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel1.checked=false
			)
		)
		fn UpdateCrushDamageEmitter selectedIndex =
		(
			--format "blach %\n" dpdn_CrushDamageEmitterLevel.selection
			if selectedIndex > 1 then
			(
				dmgLevel = CrushDamageEmitterLevel[selectedIndex-1]
				if dmgLevel == -1 then 
				(
					chkbut_CurshDamageEmitterLevel1.checked = true
					chkbut_CurshDamageEmitterLevel1.changed true
				)
				else if dmgLevel == -2 then 
				(
					chkbut_CurshDamageEmitterLevel2.checked = true
					chkbut_CurshDamageEmitterLevel2.changed true
				)
				else if dmgLevel == -3 then
				(
					chkbut_CurshDamageEmitterLevel3.checked = true
					chkbut_CurshDamageEmitterLevel3.changed true
				)
				else if dmgLevel == -4 then
				(
					chkbut_CurshDamageEmitterLevel4.checked = true
					chkbut_CurshDamageEmitterLevel4.changed true
				)
				else if dmgLevel == -5 then
				(
					chkbut_CurshDamageEmitterLevel5.checked = true
					chkbut_CurshDamageEmitterLevel5.changed true
				)
				txt_CrushDamageEmitterName.text = CrushDamageEmitterName[selectedIndex-1]
				pickbut_CrushDamageEmitterTarget.object = CrushDamageEmitterPosition[selectedIndex-1].node
			)
			else
			(
				chkbut_CurshDamageEmitterLevel1.checked = false
				chkbut_CurshDamageEmitterLevel2.checked = false
				chkbut_CurshDamageEmitterLevel3.checked = false
				chkbut_CurshDamageEmitterLevel4.checked = false
				chkbut_CurshDamageEmitterLevel5.checked = false
				txt_CrushDamageEmitterName.text = ""
				pickbut_CrushDamageEmitterTarget.object = undefined
			)
		)
		on but_SelectCrushDamageEmitter pressed do
		(
			if dpdn_CrushDamageEmitterLevel.selection > 1 then
			(
				undo "Select Crush Damage Emitter Point" on select CrushDamageEmitterPosition[dpdn_CrushDamageEmitterLevel.selection - 1].node
			)
		)
		on but_DeleteCrushDamageEmitter pressed do
		(
			/*for i = CrushDamageEmitterLevel.count to 1 by -1 do deleteItem CrushDamageEmitterLevel i
			for i = CrushDamageEmitterName.count to 1 by -1 do deleteItem CrushDamageEmitterName i
			for i = CrushDamageEmitterPosition.count to 1 by -1 do deleteItem CrushDamageEmitterPosition i
				
			return 0*/
			if dpdn_CrushDamageEmitterLevel.selection > 1 then
			(
				selectedIndex = dpdn_CrushDamageEmitterLevel.selection - 1
				deleteItem CrushDamageEmitterLevel selectedIndex
				deleteItem CrushDamageEmitterName selectedIndex
				deleteItem CrushDamageEmitterPosition selectedIndex
				crushDamageEmitterListItems =  dpdn_CrushDamageEmitterLevel.items
				deleteItem crushDamageEmitterListItems dpdn_CrushDamageEmitterLevel.selection
				dpdn_CrushDamageEmitterLevel.items = crushDamageEmitterListItems
				if selectedIndex + 1 > dpdn_CrushDamageEmitterLevel.items.count then
				(
					dpdn_CrushDamageEmitterLevel.selection = dpdn_CrushDamageEmitterLevel.items.count
					--dpdn_CrushDamageEmitterLevel.selected true
				)
				UpdateCrushDamageEmitter dpdn_CrushDamageEmitterLevel.selection
			)
		)
		on but_AddCrushDamageEmitter pressed do
		(
			dmgLevel = 0
			if chkbut_CurshDamageEmitterLevel1.checked then dmgLevel=-1
			else if chkbut_CurshDamageEmitterLevel2.checked then dmgLevel=-2
			else if chkbut_CurshDamageEmitterLevel3.checked then dmgLevel=-3
			else if chkbut_CurshDamageEmitterLevel4.checked then dmgLevel=-4
			else if chkbut_CurshDamageEmitterLevel5.checked then dmgLevel=-5
			if dmgLevel != 0 and txt_CrushDamageEmitterName.text != "" and pickbut_CrushDamageEmitterTarget.object != undefined then
			(
				crushDamageEmitterListItems =  dpdn_CrushDamageEmitterLevel.items 
				if dpdn_CrushDamageEmitterLevel.selection == 1 then
				(
					append CrushDamageEmitterLevel dmgLevel
					append CrushDamageEmitterName txt_CrushDamageEmitterName.text
					append CrushDamageEmitterPosition (nodeTransformMonitor node:pickbut_CrushDamageEmitterTarget.object forwardTransformChangeMsgs:false)
					i = CrushDamageEmitterLevel.count
					append crushDamageEmitterListItems ((CrushDamageEmitterLevel[i] as string)+": "+(CrushDamageEmitterName[i] as string)+" -> "+(CrushDamageEmitterPosition[i].name as string))
					--dpdn_CrushDamageMaterialLevel.selection = dpdn_CrushDamageMaterialLevel.items.count
				)
				else
				(
					i = dpdn_CrushDamageEmitterLevel.selection-1
					CrushDamageEmitterLevel[i] = dmgLevel
					CrushDamageEmitterName[i] = txt_CrushDamageEmitterName.text
					if CrushDamageEmitterPosition==undefined then format "CrushDamageEmitterPosition is undefined\n"
					if pickbut_CrushDamageEmitterTarget==undefined then format "pickbut_CrushDamageEmitterTarget is undefined\n"
					if pickbut_CrushDamageEmitterTarget.object ==undefined then format "pickbut_CrushDamageEmitterTarget.object is undefined\n"
					CrushDamageEmitterPosition[i] =  (nodeTransformMonitor node:pickbut_CrushDamageEmitterTarget.object forwardTransformChangeMsgs:false)
					crushDamageEmitterListItems[i+1] = ((CrushDamageEmitterLevel[i] as string)+": "+(CrushDamageEmitterName[i] as string)+" -> "+(CrushDamageEmitterPosition[i].name as string))
				)
				dpdn_CrushDamageEmitterLevel.items  = crushDamageEmitterListItems
				dpdn_CrushDamageEmitterLevel.selection = i+1
				--printArrayInFull CrushDamageEmitterLevel "CrushDamageEmitterLevel"
				--printArrayInFull CrushDamageEmitterName "CrushDamageEmitterName"
				--printArrayInFull CrushDamageEmitterPosition "CrushDamageEmitterPosition"
			)
			else
			(
				msg = ""
				if dmgLevel == 0 then msg += "Please select a damage level.\n"
				if txt_CrushDamageEmitterName.text == "" then msg += "Please enter an Emitter name.\n"
				if pickbut_CrushDamageEmitterTarget.object == undefined then msg += "Please select the object where the emitter will spawn.\n"
				messageBox msg title:"Error Adding Crush Damage Emitter"
			)
			
		)
		on dpdn_CrushDamageEmitterLevel selected selectedIndex do
		(
			UpdateCrushDamageEmitter selectedIndex
		)
		fn GetCrushDamageMaterials mat =
		(
			if classof mat == multimaterial then
			(
				mats = #()
				for submat in mat do
				(
					mats += GetCrushDamageMaterials submat
				)
				return mats
			)
			else if classof mat == standardmaterial then
			(
				return #(mat)
			)
		)
		on CrushDamageParams open do
		(
			crushDamageMaterialItems = dpdn_CrushDamageMaterialLevel.items
			for i=1 to CrushDamageMaterialLevel.count do
			(
				append crushDamageMaterialItems ((CrushDamageMaterialLevel[i] as string)+": "+(CrushDamageMaterialOriginalMaterial[i] as string)+" -> "+(CrushDamageMaterialTargetMaterial[i] as string))
			)
			dpdn_CrushDamageMaterialLevel.items = crushDamageMaterialItems
			
			crushDamageEmitterItems =  dpdn_CrushDamageEmitterLevel.items
			
			for i=1 to CrushDamageEmitterLevel.count do
			(
				append crushDamageEmitterItems ((CrushDamageEmitterLevel[i] as string)+": "+(CrushDamageEmitterName[i] as string)+" -> "+(CrushDamageEmitterPosition[i].node.name as string))
			)
			dpdn_CrushDamageEmitterLevel.items = crushDamageEmitterItems
		)
	)
	
	
	parameters detachEmitter rollout:DetachEmitterParams
	(
		
		DetachPartEmitterName type:#stringTab tabSizeVariable:true
		DetachPartEmitterPosition type:#maxObjectTab tabSizeVariable:true
		DetachPartEmitterFactor type:#floatTab tabSizeVariable:true
		
		DetachParentEmitterName type:#stringTab tabSizeVariable:true
		DetachParentEmitterPosition type:#maxObjectTab tabSizeVariable:true
		DetachParentEmitterFactor type:#floatTab tabSizeVariable:true
		
	)
	rollout DetachEmitterParams "Detach Emitters"
	(
		dropdownlist dpdn_DetachPartEmitterName "Detach Part Emitters" labelontop:true items:#("New...")
		group "Detach Part Emitter Properties"
		(
			edittext txt_DetachPartEmitterName "Emitter Name"
			label lbl_DetachPartEmitterTarget "Spawn Point" across:2
			pickbutton pickbut_DetachPartEmitterTarget "Pick Point" filter:target_helper_filter autodisplay:true
			spinner spn_DetachPartEmitterFactor  "Snap-Force Factor" range:[0,1,1] fieldwidth:30 type:#float
			button but_AddDetachPartEmitter "Add" across:3
			button but_DeleteDetachPartEmitter "Delete" across:3
			button but_SelectDetachPartEmitter "Select" across:3
		)
		fn UpdateDetachPartEmitterTarget selectedIndex =
		(
			if selectedIndex > 1 then
			(
				txt_DetachPartEmitterName.text = DetachPartEmitterName[selectedIndex-1]
				pickbut_DetachPartEmitterTarget.object = DetachPartEmitterPosition[selectedIndex-1].node
				spn_DetachPartEmitterFactor.value = DetachPartEmitterFactor[selectedIndex-1]
			)
			else
			(
				txt_DetachPartEmitterName.text=""
				pickbut_DetachPartEmitterTarget.object = undefined
				spn_DetachPartEmitterFactor.value=1.0
			)
		)
		on but_SelectDetachPartEmitter pressed do
		(
			if dpdn_DetachPartEmitterName.selection > 1 then
			(
				undo "Select Detach Part Emitter Point" on select DetachPartEmitterPosition[dpdn_DetachPartEmitterName.selection-1].node
			)
		)
		on but_DeleteDetachPartEmitter pressed do
		(
			if dpdn_DetachPartEmitterName.selection > 1 then
			(
				selectedIndex = dpdn_DetachPartEmitterName.selection - 1
				deleteItem DetachPartEmitterName selectedIndex
				deleteItem DetachPartEmitterPosition selectedIndex
				deleteItem DetachPartEmitterFactor selectedIndex
				
				dpdnListItems = dpdn_DetachPartEmitterName.items
				deleteItem dpdnListItems (selectedIndex+1)
				dpdn_DetachPartEmitterName.items = dpdnListItems
				if selectedIndex +1 > dpdn_DetachPartEmitterName.items.count then
				(
					dpdn_DetachPartEmitterName.selection = dpdn_DetachPartEmitterName.items.count
				)
				UpdateDetachPartEmitterTarget dpdn_DetachPartEmitterName.items.count
			)
		)
		on but_AddDetachPartEmitter pressed do
		(
			if txt_DetachPartEmitterName != "" and pickbut_DetachPartEmitterTarget.object !=undefined then
			(
				if dpdn_DetachPartEmitterName.selection == 1 then
				(
					append DetachPartEmitterName txt_DetachPartEmitterName.text
					append DetachPartEmitterPosition (nodeTransformMonitor node:pickbut_DetachPartEmitterTarget.object forwardTransformChangeMsgs:false)
					append DetachPartEmitterFactor spn_DetachPartEmitterFactor.value
					i = DetachPartEmitterName.count
					dpdnListItems = dpdn_DetachPartEmitterName.items
					append dpdnListItems  (DetachPartEmitterName[i]+": "+DetachPartEmitterPosition[i].node.name+" ("+(DetachPartEmitterFactor[i] as string)+")")
					dpdn_DetachPartEmitterName.items = dpdnListItems
				)
				else
				(
					i = dpdn_DetachPartEmitterName.selection-1
					
					DetachPartEmitterName[i] = txt_DetachPartEmitterName.text
					DetachPartEmitterPosition[i] = (nodeTransformMonitor node:pickbut_DetachPartEmitterTarget.object forwardTransformChangeMsgs:false)
					DetachPartEmitterFactor[i] = spn_DetachPartEmitterFactor.value
					
					dpdnListItems = dpdn_DetachPartEmitterName.items
					dpdnListItems[i+1] = (DetachPartEmitterName[i]+": "+DetachPartEmitterPosition[i].name+" ("+(DetachPartEmitterFactor[i] as string)+")")
					dpdn_DetachPartEmitterName.items = dpdnListItems
				)
				
				dpdn_DetachPartEmitterName.selection = i+1
				UpdateDetachPartEmitterTarget (i+1)
			)
			else
			(
				msg = ""
				if txt_DetachPartEmitterName.text == "" then msg += "Please enter an Emitter name.\n"
				if pickbut_DetachPartEmitterTarget.object == undefined then msg += "Please select the object where the emitter will spawn.\n"
				messageBox msg title:"Error Adding Detach Part Emitter"
			)
		)
		on dpdn_DetachPartEmitterName selected selectedIndex do
		(
			UpdateDetachPartEmitterTarget selectedIndex
		)
		
		dropdownlist dpdn_DetachParentEmitterName "Detach Parent Emitters" labelontop:true items:#("New...")
		group "Detach Parent Emitter Properties"
		(
			edittext txt_DetachParentEmitterName "Emitter Name"
			label lbl_DetachParentEmitterTarget "Spawn Point" across:2
			pickbutton pickbut_DetachParentEmitterTarget "Pick Point" filter:target_helper_filter autodisplay:true
			spinner spn_DetachParentEmitterFactor  "Snap-Force Factor" range:[0,1,1] fieldwidth:30 type:#float
			button but_AddDetachParentEmitter "Add" across:3
			button but_DeleteDetachParentEmitter "Delete" across:3
			button but_SelectDetachParentEmitter "Select" across:3
		)
		
		fn UpdateDetachParentEmitterTarget selectedIndex =
		(
			if selectedIndex > 1 then
			(
				txt_DetachParentEmitterName.text = DetachParentEmitterName[selectedIndex-1]
				pickbut_DetachParentEmitterTarget.object = DetachParentEmitterPosition[selectedIndex-1].node
				spn_DetachParentEmitterFactor.value = DetachParentEmitterFactor[selectedIndex-1]
			)
			else
			(
				txt_DetachParentEmitterName.text=""
				pickbut_DetachParentEmitterTarget.object = undefined
				spn_DetachParentEmitterFactor.value=1.0
			)
		)
		on but_SelectDetachParentEmitter pressed do
		(
			if dpdn_DetachParentEmitterName.selection > 1 then
			(
				undo "Select Detach Parent Emitter Point" on select DetachParentEmitterPosition[dpdn_DetachParentEmitterName.selection-1].node
			)
		)
		on but_DeleteDetachParentEmitter pressed do
		(
			if dpdn_DetachParentEmitterName.selection > 1 then
			(
				selectedIndex = dpdn_DetachParentEmitterName.selection - 1
				deleteItem DetachParentEmitterName selectedIndex
				deleteItem DetachParentEmitterPosition selectedIndex
				deleteItem DetachParentEmitterFactor selectedIndex
				
				dpdnListItems = dpdn_DetachParentEmitterName.items
				deleteItem dpdnListItems (selectedIndex+1)
				dpdn_DetachParentEmitterName.items = dpdnListItems
				if selectedIndex +1 > dpdn_DetachParentEmitterName.items.count then
				(
					dpdn_DetachParentEmitterName.selection = dpdn_DetachParentEmitterName.items.count
				)
				UpdateDetachParentEmitterTarget dpdn_DetachParentEmitterName.items.count
			)
		)
		on but_AddDetachParentEmitter pressed do
		(
			if txt_DetachParentEmitterName != "" and pickbut_DetachParentEmitterTarget.object !=undefined then
			(
				if dpdn_DetachParentEmitterName.selection == 1 then
				(
					append DetachParentEmitterName txt_DetachParentEmitterName.text
					append DetachParentEmitterPosition (nodeTransformMonitor node:pickbut_DetachParentEmitterTarget.object forwardTransformChangeMsgs:false)
					append DetachParentEmitterFactor spn_DetachParentEmitterFactor.value
					i = DetachParentEmitterName.count
					dpdnListItems = dpdn_DetachParentEmitterName.items
					append dpdnListItems  (DetachParentEmitterName[i]+": "+DetachParentEmitterPosition[i].node.name+" ("+(DetachParentEmitterFactor[i] as string)+")")
					dpdn_DetachParentEmitterName.items = dpdnListItems
				)
				else
				(
					i = dpdn_DetachParentEmitterName.selection-1
					
					DetachParentEmitterName[i] = txt_DetachParentEmitterName.text
					DetachParentEmitterPosition[i] = (nodeTransformMonitor node:pickbut_DetachParentEmitterTarget.object forwardTransformChangeMsgs:false)
					DetachParentEmitterFactor[i] = spn_DetachParentEmitterFactor.value
					
					dpdnListItems = dpdn_DetachParentEmitterName.items
					dpdnListItems[i+1] = (DetachParentEmitterName[i]+": "+DetachParentEmitterPosition[i].node.name+" ("+(DetachParentEmitterFactor[i] as string)+")")
					dpdn_DetachParentEmitterName.items = dpdnListItems
				)
				
				dpdn_DetachParentEmitterName.selection = i+1
				UpdateDetachParentEmitterTarget (i+1)
			)
			else
			(
				msg = ""
				if txt_DetachParentEmitterName.text == "" then msg += "Please enter an Emitter name.\n"
				if pickbut_DetachParentEmitterTarget.object == undefined then msg += "Please select the object where the Emitter will spawn.\n"
				messageBox msg title:"Error Adding Detach Parent Emitter"
			)
		)
		on dpdn_DetachParentEmitterName selected selectedIndex do
		(
			UpdateDetachParentEmitterTarget selectedIndex
		)
		on DetachEmitterParams open do
		(
			detachPartEmitterList = dpdn_DetachPartEmitterName.items
			for i=1 to DetachPartEmitterName.count do
			(
				append detachPartEmitterList (DetachPartEmitterName[i]+": "+DetachPartEmitterPosition[i].node.name+" ("+(DetachPartEmitterFactor[i] as string)+")")
			)
			dpdn_DetachPartEmitterName.items = detachPartEmitterList
			
			detachParentEmitterList = dpdn_DetachParentEmitterName.items
			for i=1 to DetachParentEmitterName.count do
			(
				append detachParentEmitterList (DetachParentEmitterName[i]+": "+DetachParentEmitterPosition[i].node.name+" ("+(DetachParentEmitterFactor[i] as string)+")")
			)
			dpdn_DetachParentEmitterName.items = detachParentEmitterList
		)
	)
	
	parameters weaponsInfo rollout:WeaponsInfoParams
	(
		VehicleSimpleWeapon_Set type:#boolean default:false ui:chk_VehicleSimpleWeapon_Set
		VehicleSimpleWeapon type:#float default:0.0 ui:spn_VehicleSimpleWeapon
		
		WeaponType type:#stringTab tabSizeVariable:true
		WeaponName type:#stringTab tabSizeVariable:true
		WeaponDmgType type:#stringTab tabSizeVariable:true
		WeaponVector type:#point3Tab tabSizeVariable:true
		
	)
	
	rollout WeaponsInfoParams "Weapons"
	(
		
		checkbox chk_VehicleSimpleWeapon_Set "" across:2
		spinner spn_VehicleSimpleWeapon "Simple Weapon" range:[0,100000,1] type:#float fieldwidth: 40
		
		
		
		on chk_VehicleSimpleWeapon_Set changed state do
		(
			spn_VehicleSimpleWeapon.enabled = state
		)
		
		dropdownlist dpdn_Weapons "Vehicle Weapons" labelontop:true items:#("New...")
		group "Weapon Properties"
		(
			checkbutton chkbut_VehicleWeapon "Vehicle" across:3
			checkbutton chkbut_PedWeapon "Ped" across:3
			checkbutton chkbut_AccessoryWeapon "Accessory" across:3
			
			edittext txt_WeaponName "Weapon Name" labelOnTop:true
			label lbl_SomeValues "Values"
			spinner spn_WeaponValues1  "" range:[0,1000,1] fieldwidth:30 type:#float across:3
			spinner spn_WeaponValues2  "" range:[0,1000,1] fieldwidth:30 type:#float across:3
			spinner spn_WeaponValues3  "" range:[0,1000,1] fieldwidth:30 type:#float across:3
			button but_AddWeapon "Set" across:2
			button but_DeleteWeapon "Delete" across:2
		)
		
		on chkbut_VehicleWeapon changed state do
		(
			if state == true then
			(
				chkbut_PedWeapon.checked=false
				chkbut_AccessoryWeapon.checked=false
			)
		)
		on chkbut_PedWeapon changed state do
		(
			if state == true then
			(
				chkbut_VehicleWeapon.checked=false
				chkbut_AccessoryWeapon.checked=false
			)
		)
		on chkbut_AccessoryWeapon changed state do
		(
			if state == true then
			(
				chkbut_PedWeapon.checked=false
				chkbut_VehicleWeapon.checked=false
			)
		)
		
		fn UpdateWeapons selectedIndex =
		(
			if selectedIndex > 1 then
			(
				txt_WeaponName.text = WeaponName[selectedIndex-1]
				chkbut_VehicleWeapon.checked = false
				chkbut_PedWeapon.checked = false
				chkbut_AccessoryWeapon.checked = false
				if WeaponType[selectedIndex-1] == "Vehicle" then chkbut_VehicleWeapon.checked =true
				else if WeaponType[selectedIndex-1] == "Ped" then chkbut_PedWeapon.checked =true
				else if WeaponType[selectedIndex-1] == "Accessory" then chkbut_AccessoryWeapon.checked =true
				spn_WeaponValues1.value = WeaponVector[selectedIndex-1].x
				spn_WeaponValues2.value = WeaponVector[selectedIndex-1].y
				spn_WeaponValues3.value = WeaponVector[selectedIndex-1].z
			)
			else
			(
				txt_WeaponName.text=""
				chkbut_VehicleWeapon.checked = false
				chkbut_PedWeapon.checked = false
				chkbut_AccessoryWeapon.checked = false
				spn_WeaponValues1.value = 0.0
				spn_WeaponValues2.value = 0.0
				spn_WeaponValues3.value = 0.0
				
			)
		)
		
		on but_DeleteWeapon pressed do
		(
			if dpdn_Weapons.selection > 1 then
			(
				selectedIndex = dpdn_Weapons.selection - 1
				deleteItem WeaponType selectedIndex
				deleteItem WeaponName selectedIndex
				deleteItem WeaponDmgType selectedIndex
				deleteItem WeaponVector selectedIndex
				
				dpdnListItems = dpdn_Weapons.items
				deleteItem dpdnListItems (selectedIndex+1)
				dpdn_Weapons.items = dpdnListItems
				if selectedIndex +1 > dpdn_Weapons.items.count then
				(
					dpdn_Weapons.selection = dpdn_Weapons.items.count
				)
				UpdateWeapons dpdn_Weapons.items.count
			)
		)
		on but_AddWeapon pressed do
		(
			typeOfWeapon = undefined
			if chkbut_VehicleWeapon.checked==true then typeOfWeapon="Vehicle"
			else if chkbut_PedWeapon.checked==true then typeOfWeapon="Ped"
			else if chkbut_AccessoryWeapon.checked==true then typeOfWeapon="Accessory"
				
			if typeOfWeapon != undefined and (filterstring txt_WeaponName.text ", \"'[]@=+-_").count > 0 then
			(
				selectedIndex = 0
				weaponIndex= 0
				if dpdn_Weapons.selection > 1 then
				(
					selectedIndex = dpdn_Weapons.selection
					weaponIndex = selectedIndex - 1
					WeaponType[weaponIndex] = typeOfWeapon
					WeaponName[weaponIndex] = txt_WeaponName.text
					WeaponDmgType[weaponIndex] = "CONSTANT"
					WeaponVector[weaponIndex] = [spn_WeaponValues1.value,spn_WeaponValues2.value,spn_WeaponValues3.value]
				)
				else
				(
					append WeaponType typeOfWeapon
					append WeaponName txt_WeaponName.text
					append WeaponDmgType "CONSTANT"
					append WeaponVector [spn_WeaponValues1.value,spn_WeaponValues2.value,spn_WeaponValues3.value]
					weaponIndex = WeaponType.count
					selectedIndex = weaponIndex+1
				)
				
				weaponsList = dpdn_Weapons.items
				weaponsList[selectedIndex] = WeaponType[weaponIndex]+": "+WeaponName[weaponIndex]
				dpdn_Weapons.items = weaponsList
				dpdn_Weapons.selection = selectedIndex
			)

		)
		on dpdn_Weapons selected selectedIndex do
		(
			UpdateWeapons selectedIndex
		)
		on WeaponsInfoParams open do
		(
			spn_VehicleSimpleWeapon.pos = [ spn_VehicleSimpleWeapon.pos.x+10, spn_VehicleSimpleWeapon.pos.y]
			spn_VehicleSimpleWeapon.enabled =VehicleSimpleWeapon_Set
			
			weaponsList = dpdn_Weapons.items
			for i=1 to WeaponName.count do
			(
				append weaponsList (WeaponType[i]+": "+WeaponName[i])
			)
			dpdn_Weapons.items = weaponsList
		)
		on WeaponsInfoParams close do
		(
		)
	)
	
	
	parameters soundInfo rollout:SoundInfoParams
	(
		SoundConfigFile type:#string default:"" ui:txt_SoundConfigFile
		
		CrushDamageSoundSubCat type:#string default:"" ui:txt_CrushDamageSoundSubCat
	)
	rollout SoundInfoParams "Sound Configuration"
	(
			edittext txt_SoundConfigFile "Sound Config File" labelOnTop:true
			edittext txt_CrushDamageSoundSubCat "Crush Damage Sound Sub Cat" labelOnTop:true
	)
)

WheelTypes = #("Wheel_FR","Wheel_FL","Wheel_RR","Wheel_RL")
WheelTypesDisplay = #("Front Right", "Front Left", "Rear Right", "Rear Left")
CarWheelAttribute = attributes CarWheelAttrib
(
	parameters main rollout:CarWheelAttribRollout
	(
		WheelTypeID type:#integer default:1
		WheelType type:#string default:"Wheel_FR"
	)
	rollout CarWheelAttribRollout "Car Wheel Params"
	(
		dropdownlist uiWheelType "Wheel Type" items:WheelTypesDisplay selection:WheelTypeID
		
		on uiWheelType selected i do
		(
			WheelTypeID = uiWheelType.selection
			WheelType = uiWheelType.items[i]
		)
	)
)

CarSystemDamageUnitAttribute = attributes CarSysDamageUnit attribID:#(0x1a22add2, 0x6414275c) version:1
(
	parameters main rollout:SysDamageAttribRollout
	(
		UnitName type:#string default:"Bodywork"
		WastedLinearContribution type:#point3 default:[1.0, 0.5, 1.0]
		WastedLinearContributionActive type:#boolean default:false
		WastedContribution type:#float default:1.0
		WastedContributionActive type:#boolean default:false
		DamageEffect_Drive type:#float default:1.0
		DamageEffect_DriveActive type:#boolean default:false
		DamageEffect_Steering type:#float default:1.0
		DamageEffect_SteeringActive type:#boolean default:false
		DamageEffect_Brakes type:#float default:1.0
		DamageEffect_BrakesActive type:#boolean default:false
		Vulnerability type:#stringTab
		ComplicatedWheelObject type:#maxObjectTab
		ComplicatedWheelValue type:#floatTab
		SolidPartObject type:#maxObjectTab
		SolidPartValue type:#point3Tab
		CrushablePartObject type:#maxObjectTab
		CrushablePartValue type:#point3Tab
	)
	rollout SysDamageAttribRollout "System Damage Rollout"
	(
		
	)
)
