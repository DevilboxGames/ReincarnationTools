fn CR_SetupLevelToolsTab tabPage =
(
	
)

fn CR_SetupCarToolsTab tabPage =
(
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	
	StructureToolsGroup = dotnetobject "groupbox"
	StructureToolsGroup.text = "Structure Tools"
	SetControlLayout StructureToolsGroup (DN_ControlLayout height:255 width:(tabPage.width-10) left:5 top:10 ForeColor:tabPage.forecolor.white)
	tabPage.controls.add StructureToolsGroup
	
	SetupCarStructureButton = dotnetobject "button"
	SetupCarStructureButton.text = "Configure Car Structure"
	SetupCarStructureButton.name = "SetupCarStructureButton"
	SetControlLayout SetupCarStructureButton (DN_ControlLayout height:30 width: 200 left: 10 top: 20)
	StructureToolsGroup.controls.add SetupCarStructureButton
	
	AddStructPartButton = dotnetobject "button"
	AddStructPartButton.text = "Add Structure Part"
	AddStructPartButton.name = "AddStructPartButton"
	SetControlLayout AddStructPartButton (DN_ControlLayout height:30 width:120 left:10 top:(SetupCarStructureButton.bottom+10))
	StructureToolsGroup.controls.add AddStructPartButton
	
	AddWeldButton = dotnetobject "button"
	AddWeldButton.text = "Add Weld"
	AddWeldButton.name = "AddWeldButton"
	SetControlLayout AddWeldButton (DN_ControlLayout height:30 width:120 left:(AddStructPartButton.right+10) top:(SetupCarStructureButton.bottom+10))
	StructureToolsGroup.controls.add AddWeldButton
	
	AddAnimationButton = dotnetobject "button"
	AddAnimationButton.text = "Standard Animation"
	AddAnimationButton.name = "AddAnimationButton"
	SetControlLayout AddAnimationButton (DN_ControlLayout height:30 width:160 left:10 top:(AddWeldButton.bottom+10))
	StructureToolsGroup.controls.add AddAnimationButton
		
	AddPointToPointButton = dotnetobject "button"
	AddPointToPointButton.text = "Point-to-Point Animation"
	AddPointToPointButton.name = "AddPointToPointButton"
	SetControlLayout AddPointToPointButton (DN_ControlLayout height:30 width:160 left:(AddAnimationButton.right+10) top:(AddWeldButton.bottom+10))
	StructureToolsGroup.controls.add AddPointToPointButton
		
	AddWishboneAxle = dotnetobject "button"
	AddWishboneAxle.text = "Set As Axle"
	AddWishboneAxle.name = "AddWisheboneAxle"
	SetControlLayout AddWishboneAxle (DN_ControlLayout height:30 width:160 left:10 top:(AddPointToPointButton.bottom+10))
	StructureToolsGroup.controls.add AddWishboneAxle
		
	AddWishboneMount = dotnetobject "button"
	AddWishboneMount.text = "Set As Mount"
	AddWishboneMount.name = "AddWishboneMount"
	SetControlLayout AddWishboneMount (DN_ControlLayout height:30 width:160 left:(AddWishboneAxle.right+10) top:AddWishboneAxle.top)
	StructureToolsGroup.controls.add AddWishboneMount
		
	AddWishboneHub = dotnetobject "button"
	AddWishboneHub.text = "Set As Hub"
	AddWishboneHub.name = "AddWishboneHub"
	SetControlLayout AddWishboneHub (DN_ControlLayout height:30 width:160 left:10 top:(AddWishboneAxle.bottom+10))
	StructureToolsGroup.controls.add AddWishboneHub
	
	AddTrailingArm = dotnetobject "button"
	AddTrailingArm.text = "Set As Trailing Arm"
	AddTrailingArm.name = "AddTrailingArm"
	SetControlLayout AddTrailingArm (DN_ControlLayout height:30 width:160 left:(AddWishboneHub.right+10) top:AddWishboneHub.top)
	StructureToolsGroup.controls.add AddTrailingArm
		
	CreateJointButton = dotnetobject "button"
	CreateJointButton.text = "Create Joint"
	CreateJointButton.name = "CreateJointButton"
	SetControlLayout CreateJointButton  (DN_ControlLayout height:30 width:160 left:10 top:(AddTrailingArm.bottom+10))
	StructureToolsGroup.controls.add CreateJointButton 
	
	CreateHelperPoint = dotnetobject "button"
	CreateHelperPoint.text = "Create Position Helper"
	CreateHelperPoint.name="CreateHelperPoint"
	SetControlLayout CreateHelperPoint (DN_ControlLayout height: 30 width: 160 left:(CreateJointButton.right+10) top:CreateJointButton.top)
	StructureToolsGroup.controls.add CreateHelperPoint
	
	SetClickHandler AddStructPartButton AddStructPartButton_Pressed
	SetClickHandler SetupCarStructureButton SetupCarStructureButton_Pressed
	SetClickHandler AddWeldButton AddWeldButton_Pressed
	SetClickHandler AddAnimationButton AddAnimationButton_Pressed
	SetClickHandler AddPointToPointButton AddPointToPointButton_Pressed
	SetClickHandler AddWishboneAxle AddWishboneAxle_Pressed
	SetClickHandler AddWishboneMount AddWishboneMount_Pressed
	SetClickHandler AddWishboneHub AddWishboneHub_Pressed
	SetClickHandler AddTrailingArm AddTrailingArm_Pressed
	SetClickHandler CreateHelperPoint CreateHelperPoint_Pressed
	SetClickHandler CreateJointButton CreateJointButton_Pressed
		
	WheelToolsGroup = (dotNetObject "system.windows.forms.groupbox")
	WheelToolsGroup.Text = "Wheel Tools"
	SetControlLayout WheelToolsGroup (DN_ControlLayout Height:150 Width: (tabPage.width-10) Left:5 Top: (StructureToolsGroup.bottom+10) ForeColor:tabPage.ForeColor.white)
	tabPage.controls.Add WheelToolsGroup
	
	WheelSelectBox = dotnetobject "combobox"
	WheelSelectBox.name="WheelSelectBox"
	WheelSelectBox.Items.Add "Front Right"
	WheelSelectBox.Items.Add "Front Left"
	WheelSelectBox.Items.Add "Rear Right"
	WheelSelectBox.Items.Add "Rear Left"
	WheelSelectBox.SelectedIndex=0
	WheelSelectBox.backColor = tabPage.backColor.FromARGB 255 70 70 70
	WheelSelectBox.foreColor = tabPage.foreColor.white
	WheelSelectBox.AutoCompleteMode = WheelSelectBox.AutoCompleteMode.Append
	WheelSelectBox.DropDownStyle = WheelSelectBox.DropDownStyle.DropDownList
	SetControlLayout WheelSelectBox (DN_ControlLayout Left: 10 Top: 20)
	WheelToolsGroup.controls.Add WheelSelectBox
	
	CreateWheelButton = dotnetobject "button"
	CreateWheelButton.name="CreateWheelButton"
	CreateWheelButton.Text = "Create"
	SetControlLayout CreateWheelButton (DN_ControlLayout Left: (WheelSelectBox.Right+5) Top: (WheelSelectBox.Top-2) Width: 100 Height:25)
	WheelToolsGroup.controls.Add CreateWheelButton
	
	ConvertToWheelButton = dotnetobject "button"
	ConvertToWheelButton.name="ConvertToWheelButton"
	ConvertToWheelButton.Text = "Convert To"
	SetControlLayout ConvertToWheelButton (DN_ControlLayout Left: (CreateWheelButton.Right+5) Top: (WheelSelectBox.Top-2) Width: 100 Height:25)
	WheelToolsGroup.controls.Add ConvertToWheelButton
	
	
	Create4WheelsButton = dotnetobject "button"
	Create4WheelsButton.name="Create4WheelsButton"
	Create4WheelsButton.Text = "Create Set Of 4 Wheels"
	SetControlLayout Create4WheelsButton (DN_ControlLayout Left: ((WheelToolsGroup.width-200)/2) Top: (WheelSelectBox.Bottom+10) Width: 200 Height:30)
	WheelToolsGroup.controls.Add Create4WheelsButton
	
	
	SetWheelRadiusToPos = dotnetobject "button"
	SetWheelRadiusToPos.name="SetWheelRadiusToPos"
	SetWheelRadiusToPos.Text = "Set Wheel Radius To Position"
	SetControlLayout SetWheelRadiusToPos (DN_ControlLayout Left: (5) Top: (Create4WheelsButton.Bottom+10) Width: 170 Height:30)
	WheelToolsGroup.controls.Add SetWheelRadiusToPos
	
	SetWheelPosToRadius = dotnetobject "button"
	SetWheelPosToRadius.name="SetWheelPosToRadius"
	SetWheelPosToRadius.Text = "Set Wheel Position To Radius"
	SetControlLayout SetWheelPosToRadius (DN_ControlLayout Left: (180 ) Top: (Create4WheelsButton.Bottom+10) Width: 170 Height:30)
	WheelToolsGroup.controls.Add SetWheelPosToRadius
	
	SetClickHandler CreateWheelButton CreateWheelButton_Pressed
	SetClickHandler ConvertToWheelButton ConvertToWheelButton_Pressed
	SetClickHandler Create4WheelsButton Create4WheelsButton_Pressed
	SetClickHandler SetWheelRadiusToPos SetWheelRadiusToPosButton_Pressed
	SetClickHandler SetWheelPosToRadius SetWheelPosToRadiusButton_Pressed
	
	SettingsButton = (dotNetObject "system.windows.forms.button")
)

fn SettingsButton_Pressed sender arg =
(
	parentDialog = windows.getChildHWND 0 "Carmageddon Reincarnation Tools"
	createDialog carma_reincarnation_settings 300 350 parent:parentDialog[1]
)

fn CR_SetupCommonToolsTab tabPage =
(
	
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	SettingsButton = (dotNetObject "system.windows.forms.button")
	SettingsButton.Text = "Settings"
	SettingsButton.Name = "SettingsButton"
	SetControlLayout SettingsButton (DN_ControlLayout Width:200 Height:50 Left: ((tabPage.width - 200)/2) Top: 20 ForeColor:tabPage.ForeColor.white)
	tabPage.controls.Add SettingsButton
	
	HierarchyToolsGroup = (dotNetObject "system.windows.forms.groupbox")
	HierarchyToolsGroup.Text="Hierarchy Tools"
	HierarchyToolsGroup.Name = "HierarchyToolsGroup"
	SetControlLayout HierarchyToolsGroup (DN_ControlLayout Width:(tabPage.width - 10) Left: 5 Top:(SettingsButton.bottom + 5) ForeColor:tabPage.ForeColor.white)
		tabPage.controls.Add HierarchyToolsGroup
	
	SetupHierarchyButton = dotnetobject "button"
	SetupHierarchyButton.text = "Setup Hierarchy"
	SetupHierarchyButton.Name = "SetupHierarchyButton"
	SetControlLayout SetupHierarchyButton (DN_ControlLayout Height: 30 Left: 15 Top: 20 Width: 160)
	HierarchyToolsGroup.controls.Add SetupHierarchyButton
	
	SetupHierarchyListBox = dotnetobject "combobox"
	SetupHierarchyListBox.name = "SetupHierarchyListBox"
	SetupHierarchyListBox.Items.Add "Selection (+Children)"
	SetupHierarchyListBox.Items.Add "Selection (no Children)"
	SetupHierarchyListBox.Items.Add "All Objects In Scene"
	SetupHierarchyListBox.SelectedIndex=0
	SetupHierarchyListBox.backColor = tabPage.backColor.FromARGB 255  70 70 70
	SetupHierarchyListBox.foreColor = tabPage.foreColor.white
	SetupHierarchyListBox.AutoCompleteMode = SetupHierarchyListBox.AutoCompleteMode.Append
	SetupHierarchyListBox.DropDownStyle=SetupHierarchyListBox.DropDownStyle.DropDownList
	SetupHierarchyListBox.ItemHeight = 25
	SetControlLayout SetupHierarchyListBox (DN_ControlLayout Left:(SetupHierarchyButton.right+5) Top:(SetupHierarchyButton.Top+5) Width: 160)
	HierarchyToolsGroup.controls.Add SetupHierarchyListBox
	
	CreateNullNodeButton = dotnetobject "button"
	CreateNullNodeButton.text = "Create Null Node"
	CreateNullNodeButton.Name = "CreateNullNodeButton"
	SetControlLayout CreateNullNodeButton (DN_ControlLayout Height: 30 Left: 15 Top: (SetupHierarchyButton.bottom+5) Width: 160)
	HierarchyToolsGroup.controls.Add CreateNullNodeButton
	
	ConvertToNullNodeButton = dotnetobject "button"
	ConvertToNullNodeButton.text = "Convert To Null Node"
	ConvertToNullNodeButton.Name = "ConvertToNullNodeButton"
	SetControlLayout ConvertToNullNodeButton (DN_ControlLayout Height: 30 Left: (CreateNullNodeButton.right+5) Top: (SetupHierarchyButton.bottom+5) Width: 160)
	HierarchyToolsGroup.controls.Add ConvertToNullNodeButton
	
	SetClickHandler SettingsButton SettingsButton_Pressed
	SetClickHandler SetupHierarchyButton SetupHierarchyButton_Pressed
	SetClickHandler CreateNullNodeButton CreateNullNodeButton_Pressed
	SetClickHandler ConvertToNullNodeButton ConvertToNullNodeButton_Pressed
	
	ModelingTools = dotnetobject "groupbox"
	ModelingTools.Text = "Modeling Tools"
	SetControlLayout ModelingTools (DN_ControlLayout Width:(tabPage.width - 10) Left: 5 Top:(HierarchyToolsGroup.bottom + 5) ForeColor:tabPage.ForeColor.white)
	tabPage.controls.add ModelingTools
	
	FixMirrorButton = dotnetobject "button"
	FixMirrorButton.text = "Fix Mirrored Geometry"
	SetControlLayout FixMirrorButton (DN_ControlLayout Height: 30 Left: (15) Top: (20) Width: 160)
	ModelingTools.controls.add FixMirrorButton
	SetClickHandler FixMirrorButton FixMirrorButton_Pressed

	ConverToCRLightButton = dotnetobject "button"
	ConverToCRLightButton.text = "Convert Light to CRLight"
	SetControlLayout ConverToCRLightButton (DN_ControlLayout Height: 30 Left: (FixMirrorButton.right+5) Top: (20) Width: 160)
	ModelingTools.controls.add ConverToCRLightButton
	SetClickHandler ConverToCRLightButton ConverToCRLightButton_Pressed
	
	DebugToolsGroup = dotnetobject "groupbox"
	DebugToolsGroup.Text = "Trent's Debug Tools (DON'T USE THESE!)"
	SetControlLayout DebugToolsGroup (DN_ControlLayout Height: 150 Width:(tabPage.width - 10) Left: 5 Top:(ModelingTools.bottom + 5) ForeColor:tabPage.ForeColor.white)
	
	UpdateAttributesButton = dotnetobject "button"
	UpdateAttributesButton.text = "Update Attributes"
	UpdateAttributesButton.name= "UpdateAttributesButton"
	SetClickHandler UpdateAttributesButton UpdateAttributesButton_Pressed
	SetControlLayout UpdateAttributesButton (DN_ControlLayout Height: 30 Left: 10 Top: 20 Width: 160)
	DebugToolsGroup.controls.add UpdateAttributesButton
	
	ReloadButton = dotnetobject "button"
	ReloadButton.text = "Reload Scripts"
	ReloadButton.name= "UpdateAttributesButton"
	SetClickHandler ReloadButton ReloadButton_Pressed
	SetControlLayout ReloadButton (DN_ControlLayout Height: 30 Left:  (UpdateAttributesButton.right+5) Top: 20 Width: 160)
	DebugToolsGroup.controls.add ReloadButton
	
	BatchCarSetupLOLsButton = dotnetobject "button"
	BatchCarSetupLOLsButton.text = "Batch Process Car Setup.lol files"
	BatchCarSetupLOLsButton.name= "BatchCarSetupLOLsButton"
	SetClickHandler BatchCarSetupLOLsButton BatchCarSetupLOLsButton_Pressed
	SetControlLayout BatchCarSetupLOLsButton (DN_ControlLayout Height: 30 Left: 10 Top:(UpdateAttributesButton.bottom +5) Width: 160)
	DebugToolsGroup.controls.add BatchCarSetupLOLsButton
	
	BatchCarStructuresButton = dotnetobject "button"
	BatchCarStructuresButton.text = "Batch Process Structure.xml files"
	BatchCarStructuresButton.name= "BatchCarStructuresButton"
	SetClickHandler BatchCarStructuresButton BatchCarStructuresButton_Pressed
	SetControlLayout BatchCarStructuresButton (DN_ControlLayout Height: 30 Left: (BatchCarSetupLOLsButton.right+5) Top:(UpdateAttributesButton.bottom +5) Width: 160)
	DebugToolsGroup.controls.add BatchCarStructuresButton
	
	BatchLevelRoutesButton = dotnetobject "button"
	BatchLevelRoutesButton.text = "Batch Process routes.txt files"
	BatchLevelRoutesButton.name= "BatchLevelRoutesButton"
	SetClickHandler BatchLevelRoutesButton BatchLevelRoutesButton_Pressed
	SetControlLayout BatchLevelRoutesButton (DN_ControlLayout Height: 30 Left: (10) Top:(BatchCarSetupLOLsButton.bottom +5) Width: 160)
	DebugToolsGroup.controls.add BatchLevelRoutesButton
	
	CloseButton = dotnetobject "button"
	CloseButton.text = "Close"
	CloseButton.name= "CloseButton"
	SetClickHandler CloseButton Close_Pressed
	SetControlLayout CloseButton (DN_ControlLayout Height: 30 Left: 10 Top:(BatchLevelRoutesButton.bottom +5) Width: 160)
	DebugToolsGroup.controls.add CloseButton
	tabPage.controls.add DebugToolsGroup
)
fn CR_SetupToolsTab tabPage =
(
	global CRToolsUI
	
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	
	tabPage.AutoScroll =true
	toolsTabs = SetupTabs tabPage labels:#("Common", "Car", "Wheel", "Level", "Accessory","Ped") Layout:(DN_ControlLayout SizeMode:(dotnetclass "system.windows.forms.TabSizeMode").Fixed AnchorStyles:#("Top", "Bottom") Disabled:#(true, true, false, false, false) MultiLine: true Top: 15 Height:(tabPage.Height-16)  Left: 5 Width: (tabPage.Width-8) )
	toolsTabs.backColor = toolsTabs.backcolor.white
	CR_SetupCommonToolsTab toolsTabs.tabPages.Item[0]
	CR_SetupCarToolsTab toolsTabs.tabPages.Item[1]
)