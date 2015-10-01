fn CR_SetupExportLevelTab tabPage =
(
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	tabPage.foreColor = tabPage.foreColor.White
	tabPage.AutoScroll =true
	ExportLevelButton = (dotNetObject "system.windows.forms.button")
	ExportLevelButton.Text = "Export Complete Level"
	SetControlLayout ExportLevelButton (DN_ControlLayout Width:150 Height:30 Left: ((tabPage.Width - 150)/2) Top: 20)
	tabPage.controls.Add ExportLevelButton
	
	ExportTexturesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ExportTexturesCheckbox.Text = "Convert Textures To TDX"
	ExportTexturesCheckbox.name = "ExportTexturesCheckbox"
	SetControlLayout ExportTexturesCheckbox (DN_ControlLayout Top:(ExportLevelButton.bottom+5) Width: 250 Left: 10)
	tabPage.controls.Add ExportTexturesCheckbox
	
	CreateMaterialsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	CreateMaterialsCheckbox.Text = "Create Materials"
	CreateMaterialsCheckbox.name="CreateMaterialsCheckbox"
	SetControlLayout CreateMaterialsCheckbox (DN_ControlLayout Top:(ExportTexturesCheckbox.bottom+1) Width: 250 Left: 10)
	tabPage.controls.Add CreateMaterialsCheckbox
	
	
	
	ExportPaperworkButton = (dotNetObject "system.windows.forms.button")
	ExportPaperworkButton.Text = "Export All Paperwork"
	SetControlLayout ExportPaperworkButton (DN_ControlLayout Width:150 Height:30 Left: ((tabPage.Width - 150)/2) Top: (CreateMaterialsCheckbox.bottom+5))
	tabPage.controls.Add ExportPaperworkButton
	
	ExportAccessoriesButton = (dotNetObject "system.windows.forms.button")
	ExportAccessoriesButton.Text = "Export Accessories"
	SetControlLayout ExportAccessoriesButton (DN_ControlLayout Width:120 Height:30 Left: (5) Top: (ExportPaperworkButton.bottom+1))
	tabPage.controls.Add ExportAccessoriesButton
		
	ExportPowerupsButton = (dotNetObject "system.windows.forms.button")
	ExportPowerupsButton.Text = "Export Powerups"
	SetControlLayout ExportPowerupsButton (DN_ControlLayout Width:120 Height:30 Left: (ExportAccessoriesButton.Right + 5) Top: (ExportPaperworkButton.bottom+1))
	tabPage.controls.Add ExportPowerupsButton
		
	ExportSetupButton = (dotNetObject "system.windows.forms.button")
	ExportSetupButton.Text = "Export Setup"
	SetControlLayout ExportSetupButton (DN_ControlLayout Width:120 Height:30 Left: (5) Top: (ExportPowerupsButton.bottom+1))
	tabPage.controls.Add ExportSetupButton
		
	ExportPathsButton = (dotNetObject "system.windows.forms.button")
	ExportPathsButton.Text = "Export AI Paths"
	SetControlLayout ExportPathsButton (DN_ControlLayout Width:120 Height:30 Left: (ExportSetupButton.Right + 5) Top: (ExportPowerupsButton.bottom+1))
	tabPage.controls.Add ExportPathsButton
	
	
	setclickhandler ExportLevelButton ExportLevelButtonPressed
	setclickhandler ExportPaperworkButton ExportLevelPaperworkButtonPressed
)
fn CR_SetupExportCarTab tabPage =
(
	
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	tabPage.foreColor = tabPage.foreColor.White
	tabPage.AutoScroll =true
	
	ExportCarButton = (dotNetObject "system.windows.forms.button")
	ExportCarButton.Text = "Export Complete Car"
	SetControlLayout ExportCarButton (DN_ControlLayout Width:150 Height:30 Left: ((tabPage.Width - 150)/2) Top: 20)
	tabPage.controls.Add ExportCarButton
	
	ExportTexturesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ExportTexturesCheckbox.Text = "Convert Textures To TDX"
	ExportTexturesCheckbox.name = "ExportTexturesCheckbox"
	SetControlLayout ExportTexturesCheckbox (DN_ControlLayout Top:(ExportCarButton.bottom+10) Width: 250 Left: 10)
	tabPage.controls.Add ExportTexturesCheckbox
	
	CreateMaterialsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	CreateMaterialsCheckbox.Text = "Create Materials"
	CreateMaterialsCheckbox.name="CreateMaterialsCheckbox"
	SetControlLayout CreateMaterialsCheckbox (DN_ControlLayout Top:(ExportTexturesCheckbox.bottom+5) Width: 250 Left: 10)
	tabPage.controls.Add CreateMaterialsCheckbox
	
	
	ExportPaperworkButton = (dotNetObject "system.windows.forms.button")
	
	setclickhandler ExportCarButton ExportCarButtonPressed
	setclickhandler ExportPaperWorkButton ExportCarPaperworkButtonPressed
	
	ExportPaperworkButton.Text = "Export Paperwork Only"
	SetControlLayout ExportPaperworkButton (DN_ControlLayout Width:150 Height:30 Left: ((tabPage.Width - 150)/2) Top: (CreateMaterialsCheckbox.bottom+5))
	tabPage.controls.Add ExportPaperworkButton
	
	ExportStructureCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ExportStructureCheckbox.Text = "Export Structure.xml Data (WIP)"
	ExportStructureCheckbox.name = "ExportStructureCheckbox"
	SetControlLayout ExportStructureCheckbox (DN_ControlLayout Top:(ExportPaperworkButton.bottom+5) Width: 250 height: 30 Left: 10)
	tabPage.controls.Add ExportStructureCheckbox
	
	ExportSystemDamageCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ExportSystemDamageCheckbox.Text = "Export SystemDamage.xml (WIP)"
	ExportSystemDamageCheckbox.name = "ExportSystemDamageCheckbox"
	SetControlLayout ExportSystemDamageCheckbox (DN_ControlLayout Top:(ExportStructureCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add ExportSystemDamageCheckbox
	
	ExportCFGAndLOLCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ExportCFGAndLOLCheckbox.Text = "Export Vehicle_Setup.cfg && Setup.lol (WIP)"
	ExportCFGAndLOLCheckbox.name = "ExportCFGAndLOLCheckbox"
	SetControlLayout ExportCFGAndLOLCheckbox (DN_ControlLayout Top:(ExportSystemDamageCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add ExportCFGAndLOLCheckbox
	
)
fn CR_SetupExportTab tabPage =
(
	global CRToolsUI
	
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	
	GenericExportGroup = (dotNetObject "system.windows.forms.GroupBox")
	GenericExportGroup.Text = "Basic Export"
	GenericExportGroup.ForeColor = GenericExportGroup.ForeColor.LightGray
	SetControlLayout GenericExportGroup (DN_ControlLayout Width:(CRToolsUI.Width-110) Height: 150 Left: 45)
	
	
	ExportCNTButton = (dotNetObject "system.windows.forms.button")
	ExportCNTButton.Text = "Export CNT"
	SetControlLayout ExportCNTButton (DN_ControlLayout Width:((GenericExportGroup.Width - 15)/2) Height:30 Left: 5 Top: 20)
	GenericExportGroup.controls.Add ExportCNTButton
	
	ExportMDLButton = (dotNetObject "system.windows.forms.button")
	ExportMDLButton.Text = "Export MDL"
	SetControlLayout ExportMDLButton (DN_ControlLayout Width:((GenericExportGroup.Width - 15)/2) Height:30 Left: (ExportCNTButton.Right+5) Top: 20)
	GenericExportGroup.controls.Add ExportMDLButton
	
	ExportFullHierarchyButton = (dotNetObject "system.windows.forms.button")
	ExportFullHierarchyButton.Text = "Exprt Full CNT && MDL Hierarchy"
	SetControlLayout ExportFullHierarchyButton (DN_ControlLayout Width: ((GenericExportGroup.Width - 10)) Height:30 Left: 5 Top:(ExportCNTButton.Bottom+5))
	GenericExportGroup.controls.Add ExportFullHierarchyButton
		
	SetClickHandler ExportCNTButton ExportCNTButtonPressed
	SetClickHandler ExportMDLButton ExportMDLButtonPressed
	SetClickHandler ExportFullHierarchyButton ExportFullHierarchyButtonPressed
	
	ExportTexturesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ExportTexturesCheckbox.Text = "Convert Textures To TDX"
	ExportTexturesCheckbox.Name = "ExportTexturesCheckbox"
	SetControlLayout ExportTexturesCheckbox (DN_ControlLayout Top:(ExportFullHierarchyButton.bottom+10) Width: 250 Left: 10)
	GenericExportGroup.controls.Add ExportTexturesCheckbox
	
	CreateMaterialsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	CreateMaterialsCheckbox.Text = "Create Materials"
	CreateMaterialsCheckbox.Name="CreateMaterialsCheckbox"
	SetControlLayout CreateMaterialsCheckbox (DN_ControlLayout Top:(ExportTexturesCheckbox.bottom+5) Width: 250 Left: 10)
	GenericExportGroup.controls.Add CreateMaterialsCheckbox
	
	tabPage.controls.Add GenericExportGroup
	
	AdvancedExportGroup = (dotNetObject "system.windows.forms.GroupBox")
	AdvancedExportGroup.Text = "Advanced Export"
	AdvancedExportGroup.ForeColor = AdvancedExportGroup.ForeColor.LightGray
	SetControlLayout AdvancedExportGroup (DN_ControlLayout Width:(CRToolsUI.Width-110) Left: 45 AnchorStyles:#("Top", "Bottom")  Top: (GenericExportGroup.bottom + 10) Left: 40 Height:256 Width:(CRToolsUI.Width-100))
	tabPage.controls.Add AdvancedExportGroup
	
	
	exportTabs = SetupTabs AdvancedExportGroup labels:#("Car", "Wheel", "Level", "Accessory","Ped") Layout:(DN_ControlLayout SizeMode:(dotnetclass "system.windows.forms.TabSizeMode").Fixed AnchorStyles:#("Top", "Bottom") Disabled:#(true, true, true, false, false) MultiLine: true Top: 15 Height:(AdvancedExportGroup.Height-16)  Left: 5 Width: (AdvancedExportGroup.Width-8) )
	exportTabs.backColor = exportTabs.backcolor.white
	CR_SetupExportCarTab exportTabs.tabPages.Item[0]
	CR_SetupExportLevelTab exportTabs.tabPages.Item[2]
)