
fn CR_SetupImportLevelTab tabPage =
(
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	tabPage.foreColor = tabPage.foreColor.White
	tabPage.AutoScroll =true
	ImportLevelButton = (dotNetObject "system.windows.forms.button")
	ImportLevelButton.Text = "Import Level"
	SetControlLayout ImportLevelButton (DN_ControlLayout Width:150 Height:30 Left: ((tabPage.Width - 150)/2) Top: 20)
	tabPage.controls.Add ImportLevelButton
	
	SetClickHandler ImportLevelButton ImportLevelButtonPressed
	
	LoadGeometryCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadGeometryCheckbox.checked = true
	LoadGeometryCheckbox.Text = "Load Geometry"
	LoadGeometryCheckbox.Name = "LoadGeometryCheckbox"
	SetControlLayout LoadGeometryCheckbox (DN_ControlLayout Top:(ImportLevelButton.bottom+5) Width: 250 height: 30 Left: 10)
	tabPage.controls.Add LoadGeometryCheckbox

	LoadAccessoriesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadAccessoriesCheckbox.Text = "Load Accessories (WIP)"
	LoadAccessoriesCheckbox.Name = "LoadAccessoriesCheckbox"
	SetControlLayout LoadAccessoriesCheckbox (DN_ControlLayout Top:(LoadGeometryCheckbox.bottom+5) Width: 250 height: 30 Left: 10)
	tabPage.controls.Add LoadAccessoriesCheckbox
	
	LoadPowerupsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadPowerupsCheckbox.Text = "Load Powerups"
	LoadPowerupsCheckbox.Name = "LoadPowerupsCheckbox"
	SetControlLayout LoadPowerupsCheckbox (DN_ControlLayout Top:(LoadAccessoriesCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add LoadPowerupsCheckbox
	
	LoadPathsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadPathsCheckbox.Text = "Load Opponent Paths (Not Working)"
	LoadPathsCheckbox.Name="LoadPathsCheckbox"
	SetControlLayout LoadPathsCheckbox (DN_ControlLayout Top:(LoadPowerupsCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add LoadPathsCheckbox
	
	ImportTexturesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ImportTexturesCheckbox.Text = "Import Textures (Not Working With VTs)"
	ImportTexturesCheckbox.Name="ImportTexturesCheckbox"
	SetControlLayout ImportTexturesCheckbox (DN_ControlLayout Top:(LoadPathsCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add ImportTexturesCheckbox
	
	ForcePrepCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ForcePrepCheckbox.Checked = true
	ForcePrepCheckbox.Text = "Use PREP Data"
	ForcePrepCheckbox.Name = "ForcePrepCheckbox"
	SetControlLayout ForcePrepCheckbox (DN_ControlLayout Top:(ImportTexturesCheckbox.bottom+2) height: 30 Width: 125 Left: 10)
	tabPage.controls.Add ForcePrepCheckbox
	
	UseTriStripsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	UseTriStripsCheckbox.Text = "Use Tri Strips"
	UseTriStripsCheckbox.Name = "UseTriStripsCheckbox"
	SetControlLayout UseTriStripsCheckbox (DN_ControlLayout Top:(ImportTexturesCheckbox.bottom+2) height: 30 Width: 100 Left: 150)
	tabPage.controls.Add UseTriStripsCheckbox
)
fn CR_SetupImportWheelTab tabPage =
(
)
fn CR_SetupImportCarTab tabPage =
(
	
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	tabPage.foreColor = tabPage.foreColor.White
	tabPage.AutoScroll =true
	ImportCarButton = (dotNetObject "system.windows.forms.button")
	ImportCarButton.Text = "Import Car"
	SetControlLayout ImportCarButton (DN_ControlLayout Width:150 Height:30 Left: ((tabPage.Width - 150)/2) Top: 20)
	tabPage.controls.Add ImportCarButton
	
	SetClickHandler ImportCarButton ImportCarButtonPressed
	
	LoadStructureCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadStructureCheckbox.Text = "Load Structure.xml Data (WIP)"
	LoadStructureCheckbox.Name = "LoadStructureCheckbox"
	SetControlLayout LoadStructureCheckbox (DN_ControlLayout Top:(ImportCarButton.bottom+5) Width: 250 height: 30 Left: 10)
	tabPage.controls.Add LoadStructureCheckbox
	
	LoadSystemDamageCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadSystemDamageCheckbox.Text = "Load System Damage (Not Working)"
	LoadSystemDamageCheckbox.Name = "LoadSystemDamageCheckbox"
	SetControlLayout LoadSystemDamageCheckbox (DN_ControlLayout Top:(LoadStructureCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add LoadSystemDamageCheckbox
	
	LoadCFGAndLOLCheckbox = (dotnetobject "system.windows.forms.checkbox")
	LoadCFGAndLOLCheckbox.Text = "Load Vehicle_Setup.cfg && Setup.lol (Not Working)"
	LoadCFGAndLOLCheckbox.Name="LoadCFGAndLOLCheckbox"
	SetControlLayout LoadCFGAndLOLCheckbox (DN_ControlLayout Top:(LoadSystemDamageCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add LoadCFGAndLOLCheckbox
	
	ImportTexturesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ImportTexturesCheckbox.Text = "Import Textures"
	ImportTexturesCheckbox.Name="ImportTexturesCheckbox"
	SetControlLayout ImportTexturesCheckbox (DN_ControlLayout Top:(LoadCFGAndLOLCheckbox.bottom+2) height: 30 Width: 250 Left: 10)
	tabPage.controls.Add ImportTexturesCheckbox
	
	ForcePrepCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ForcePrepCheckbox.Checked = true
	ForcePrepCheckbox.Text = "Use PREP Data"
	ForcePrepCheckbox.Name = "ForcePrepCheckbox"
	SetControlLayout ForcePrepCheckbox (DN_ControlLayout Top:(ImportTexturesCheckbox.bottom+2) height: 30 Width: 125 Left: 10)
	tabPage.controls.Add ForcePrepCheckbox
	
	UseTriStripsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	UseTriStripsCheckbox.Text = "Use Tri Strips"
	UseTriStripsCheckbox.Name = "UseTriStripsCheckbox"
	SetControlLayout UseTriStripsCheckbox (DN_ControlLayout Top:(ImportTexturesCheckbox.bottom+2) height: 30 Width: 100 Left: 150)
	tabPage.controls.Add UseTriStripsCheckbox
	
)
fn CR_SetupImportTab tabPage =
(
	global CRToolsUI
	
	tabPage.backColor = tabPage.backColor.FromARGB 255  70 70 70
	
	GenericImportGroup = (dotNetObject "system.windows.forms.GroupBox")
	GenericImportGroup.Text = "Basic Import"
	GenericImportGroup.ForeColor = GenericImportGroup.ForeColor.LightGray
	SetControlLayout GenericImportGroup (DN_ControlLayout Width:(CRToolsUI.Width-110) Height: 150 Left: 45)
	
	
	ImportMDLButton = (dotNetObject "system.windows.forms.button")
	ImportMDLButton.Text = "Import MDL or Light"
	SetControlLayout ImportMDLButton (DN_ControlLayout Width:150 Height:30 Left: ((GenericImportGroup.Width - 150)/2) Top: 20)
	GenericImportGroup.controls.Add ImportMDLButton
	
	
	ImportCNTButton = (dotNetObject "system.windows.forms.button")
	ImportCNTButton.Text = "Import CNT"
	GenericImportGroup.controls.Add ImportCNTButton
	SetControlLayout ImportCNTButton (DN_ControlLayout Width: 150 Height:30 Left: ((GenericImportGroup.Width - 150)/2) Top:(ImportMDLButton.Bottom+5))
	
	ImportTexturesCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ImportTexturesCheckbox.Text = "Import Textures"
	ImportTexturesCheckbox.Name = "ImportTexturesCheckbox"
	SetControlLayout ImportTexturesCheckbox (DN_ControlLayout Top:(ImportCNTButton.bottom+10) Width: 120 Left: 10)
	GenericImportGroup.controls.Add ImportTexturesCheckbox
	
	ImportMergeCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ImportMergeCheckbox.Checked = true
	ImportMergeCheckbox.Text = "Merge Splits"
	ImportMergeCheckbox.Name = "ImportMergeCheckbox"
	SetControlLayout ImportMergeCheckbox (DN_ControlLayout Top:(ImportCNTButton.bottom+10) Width: 120 Left: 160)
	GenericImportGroup.controls.Add ImportMergeCheckbox
	
	
	ForcePrepCheckbox = (dotnetobject "system.windows.forms.checkbox")
	ForcePrepCheckbox.Checked = true
	ForcePrepCheckbox.Text = "Use PREP Data"
	ForcePrepCheckbox.Name = "ForcePrepCheckbox"
	SetControlLayout ForcePrepCheckbox (DN_ControlLayout Top:(ImportTexturesCheckbox.bottom+5) Width: 120 Left: 10)
	GenericImportGroup.controls.Add ForcePrepCheckbox
	
	
	UseTriStripsCheckbox = (dotnetobject "system.windows.forms.checkbox")
	UseTriStripsCheckbox.Text = "Use Tri Strips"
	UseTriStripsCheckbox.Name = "UseTriStripsCheckbox"
	SetControlLayout UseTriStripsCheckbox (DN_ControlLayout Top:(ImportTexturesCheckbox.bottom+5) Width: 120 Left: 160)
	GenericImportGroup.controls.Add UseTriStripsCheckbox
	
	SetClickHandler ImportMDLButton ImportMDLButtonPressed
	SetClickHandler ImportCNTButton ImportCNTButtonPressed
	/*dotNet.setLifetimeControl ImportMDLButton #dotnet
	dotNet.setLifetimeControl ImportCNTButton #dotnet
	dotNet.addEventHandler ImportMDLButton "Click" ImportMDLButtonPressed
	dotNet.addEventHandler ImportCNTButton "Click" ImportCNTButtonPressed*/
	
	tabPage.controls.Add GenericImportGroup
	
	AdvancedImportGroup = (dotNetObject "system.windows.forms.GroupBox")
	AdvancedImportGroup.Text = "Advanced Import"
	AdvancedImportGroup.ForeColor = GenericImportGroup.ForeColor.LightGray
	SetControlLayout AdvancedImportGroup (DN_ControlLayout Width:(CRToolsUI.Width-110) Left: 45 AnchorStyles:#("Top", "Bottom")  Top: (GenericImportGroup.bottom + 10) Left: 40 Height:256 Width:(CRToolsUI.Width-100))
	tabPage.controls.Add AdvancedImportGroup
	
	
	importTabs = SetupTabs AdvancedImportGroup labels:#("Car", "Wheel", "Level", "Accessory","Ped") Layout:(DN_ControlLayout SizeMode:(dotnetclass "system.windows.forms.TabSizeMode").Fixed AnchorStyles:#("Top", "Bottom") Disabled:#(true, true, true, false, false) MultiLine: true Top: 15 Height:(AdvancedImportGroup.Height-16)  Left: 5 Width: (AdvancedImportGroup.Width-8) )
	importTabs.backColor = importtabs.backcolor.white
	CR_SetupImportCarTab importTabs.tabPages.Item[0]
	CR_SetupImportLevelTab importTabs.tabPages.Item[2]
)