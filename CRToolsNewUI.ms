fn SetToolMode_Car args = ()
fn SetToolMode_Wheel args = ()
fn SetToolMode_Level args = ()
fn SetToolMode_Accessory args = ()
fn SetToolMode_Ped args = ()

fileIn "DotNetFormHelper.ms"
fileIn "CRToolsSettings.ms"
fileIn "CRToolsNewUI_Common.ms"
fileIn "CRToolsNewUI_Cars.ms"
fileIn "CRToolsNewUI_Wheels.ms"
fileIn "CRToolsNewUI_Import.ms"
fileIn "CRToolsNewUI_Export.ms"


fn FindMaxWindow windowTitle:"Autodesk 3ds Max" = (


WindowFinder = dotnetclass "CMDControls.FindWindow"
local wnd = WindowFinder.SearchForWindow windowTitle
local childWindows = WindowFinder.GetChildWindows wnd
--format "%\n" WindowFinder.ChildLog
wnd
)
fn SetToolMode_Car args = (
	global CRToolsUI
	CRToolsUI.controls.clear()
	local layoutHelper = DotNetFormHelper ParentControl:CRToolsUI OutterMarginTop:0 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup marginTop:10 marginBottom:20
	AddModeButtons layoutHelper "Car"
	--local uicontent = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,30]
	--uicontent.text = "Car Mode"
	--layoutHelper.SetFont uicontent "Segoe UI" 16 bold:true underline:true
	AddHierarchyToolsUI layoutHelper
	AddCarToolsUI layoutHelper
	
	layoutHelper.EndVerticalGroup()
	layoutHelper.PrintDebugTree()
)
fn SetToolMode_Wheel args = (
	global CRToolsUI
	CRToolsUI.controls.clear()
	local layoutHelper = DotNetFormHelper ParentControl:CRToolsUI OutterMarginTop:0 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup  marginTop:10 marginBottom:20
	AddModeButtons layoutHelper "Wheel"
	--local uicontent = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,30]
	--uicontent.text = "Wheel Mode"
	--layoutHelper.SetFont uicontent "Segoe UI" 16 bold:true underline:true

	AddHierarchyToolsUI layoutHelper
	AddWheelToolsUI layoutHelper
	
	layoutHelper.EndVerticalGroup()

)
fn SetToolMode_Level args = (
	global CRToolsUI
	CRToolsUI.controls.clear()
	local layoutHelper = DotNetFormHelper ParentControl:CRToolsUI OutterMarginTop:0 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup  marginTop:10 marginBottom:20

	AddModeButtons layoutHelper "Level"
	--local uicontent = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,30]
	--uicontent.text = "Level Mode"
	--layoutHelper.SetFont uicontent "Segoe UI" 16 bold:true underline:true
	AddHierarchyToolsUI layoutHelper

	
	layoutHelper.EndVerticalGroup()

)
fn SetToolMode_Accessory args = (
	global CRToolsUI
	CRToolsUI.controls.clear()
	local layoutHelper = DotNetFormHelper ParentControl:CRToolsUI OutterMarginTop:0 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup  marginTop:10 marginBottom:20

	AddModeButtons layoutHelper "Accessory"
	--local uicontent = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,30]
	--uicontent.text = "Accessory Mode"
	--layoutHelper.SetFont uicontent "Segoe UI" 16 bold:true underline:true

	AddHierarchyToolsUI layoutHelper
	
	layoutHelper.EndVerticalGroup()

)
fn SetToolMode_Ped args = (
	global CRToolsUI
	CRToolsUI.controls.clear()
	local layoutHelper = DotNetFormHelper ParentControl:CRToolsUI OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup  marginTop:10 marginBottom:20

	AddModeButtons layoutHelper "Ped"
	--local uicontent = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,20]
	--uicontent.text = "Ped Mode"
	AddHierarchyToolsUI layoutHelper

	
	layoutHelper.EndVerticalGroup()

)

fn ShowImportOptions = (
	global CarmaSettings
	local importSettingsDialog = dotNetObject "System.Windows.Forms.Form"
	importSettingsDialog.text = "Import Settings"
	importSettingsDialog.name = "ImportSettings"
	--importSettingsDialog.AutoSize = true
	--importSettingsDialog.AutoSizeMode = (dotnetclass "System.Windows.Forms.AutoSizeMode").GrowAndShrink
	local layoutHelper = DotNetFormHelper ParentControl:importSettingsDialog
	layoutHelper.BeginVerticalGroup()
	local importTexturesCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
	importTexturesCheckbox.text = "Import Textures"
	importTexturesCheckbox.checked = CarmaSettings.ImportSettings.ImportTextures
	importTexturesCheckbox.name = "ImportTexturesCheckbox"

	local importUsePrepDataCheckbox = layoutHelper.AddControl  "System.Windows.Forms.Checkbox" size:[200,20]
	importUsePrepDataCheckbox.text = "Use MDL Prep Data"
	importUsePrepDataCheckbox.name = "ImportUsePrepDataCheckbox"
	importUsePrepDataCheckbox.checked = CarmaSettings.ImportSettings.UsePrepData

	local importUseTriStripsCheckbox = layoutHelper.AddControl  "System.Windows.Forms.Checkbox" size:[200,20]
	importUseTriStripsCheckbox.text = "Use MDL Tri Strips"
	importUseTriStripsCheckbox.name ="ImportUseTriStripsCheckbox"
	importUseTriStripsCheckbox.checked = CarmaSettings.ImportSettings.UseTriStrips

	local importMergeSplitsCheckbox = layoutHelper.AddControl  "System.Windows.Forms.Checkbox" size:[200,20]
	importMergeSplitsCheckbox.text = "Merge Splits"
	importMergeSplitsCheckbox.name = "ImportMergeSplitsCheckbox"
	importMergeSplitsCheckbox.checked = CarmaSettings.ImportSettings.MergeSplits

	layoutHelper.BeginHorizontalGroup()
	local okButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
	--okButton.Location = dotnetobject "System.Drawing.Point" 10 130 
	okButton.text = "Save"
	fn ImportSettingsOkClicked okButton ev = (
		global CarmaSettings
		local importSettingsDialog = okButton.parent
		local importTexturesCheckbox = importSettingsDialog.Controls.Find "ImportTexturesCheckbox" false
		local importUsePrepDataCheckbox = importSettingsDialog.Controls.Find "ImportUsePrepDataCheckbox" false
		local importUseTriStripsCheckbox = importSettingsDialog.Controls.Find "ImportUseTriStripsCheckbox" false
		local importMergeSplitsCheckbox = importSettingsDialog.Controls.Find "ImportMergeSplitsCheckbox" false
		CarmaSettings.ImportSettings.ImportTextures = importTexturesCheckbox[1].checked
		CarmaSettings.ImportSettings.UsePrepData = importUsePrepDataCheckbox[1].checked
		CarmaSettings.ImportSettings.UseTriStrips = importUseTriStripsCheckbox[1].checked
		CarmaSettings.ImportSettings.MergeSplits = importMergeSplitsCheckbox[1].checked
		CarmaSettings.Save()
		importSettingsDialog.Close()
	)
	SetClickHandler okButton ImportSettingsOkClicked

	local cancelButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
	cancelButton.Text = "Cancel"
	fn ImportSettingsCancelClicked okButton ev = (
		okButton.parent.Close()
	)
	SetClickHandler cancelButton ImportSettingsCancelClicked
	layoutHelper.EndHorizontalGroup()
	layoutHelper.EndVerticalGroup()
	importSettingsDialog.ShowDialog()
)

fn ShowExportOptions = (
	global CarmaSettings
	local importSettingsDialog = dotNetObject "System.Windows.Forms.Form"
	exportSettingsDialog.text = "Export Settings"
	exportSettingsDialog.name = "ExportSettings"
	--exportSettingsDialog.AutoSize = true
	--exportSettingsDialog.AutoSizeMode = (dotnetclass "System.Windows.Forms.AutoSizeMode").GrowAndShrink
	local layoutHelper = DotNetFormHelper ParentControl:exportSettingsDialog
	layoutHelper.BeginVerticalGroup()

	local exportTexturesCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
	exportTexturesCheckbox.text = "Export Textures"
	exportTexturesCheckbox.checked = CarmaSettings.ExportSettings.ExportTextures
	exportTexturesCheckbox.name = "ExportTexturesCheckbox"

	local exportMaterialsCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
	exportMaterialsCheckbox.text = "Export Materials"
	exportMaterialsCheckbox.checked = CarmaSettings.ExportSettings.ExportMaterials
	exportMaterialsCheckbox.name = "ExportMaterialsCheckbox"

	local exportMTLFilesCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
	exportMTLFilesCheckbox.text = "Export MTL Files"
	exportMTLFilesCheckbox.checked = CarmaSettings.ExportSettings.ExportMTLFiles
	exportMTLFilesCheckbox.name = "ExportMTLFilesCheckbox"

	local exportOldCNTCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
	exportOldCNTCheckbox.text = "Export Old CNT Format"
	exportOldCNTCheckbox.checked = CarmaSettings.ExportSettings.ExportOldCNT
	exportOldCNTCheckbox.name = "ExportOldCNTCheckbox"
	
	layoutHelper.BeginHorizontalGroup()
	local okButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
	--okButton.Location = dotnetobject "System.Drawing.Point" 10 130 
	okButton.text = "Save"
	fn ExportSettingsOkClicked okButton ev = (
		global CarmaSettings
		local exportSettingsDialog = okButton.parent
		local exportTexturesCheckbox = exportSettingsDialog.Controls.Find "ExportTexturesCheckbox" false
		local exportMaterialsCheckbox = exportSettingsDialog.Controls.Find "ExportMaterialsCheckbox" false
		local exportMTLFilesCheckbox = exportSettingsDialog.Controls.Find "ExportMTLFilesCheckbox" false
		local exportOldCNTCheckbox = exportSettingsDialog.Controls.Find "ExportOldCNTCheckbox" false
		CarmaSettings.ExportSettings.ExportTextures = exportTexturesCheckbox[1].checked
		CarmaSettings.ExportSettings.UsePrepData = exportMaterialsCheckbox[1].checked
		CarmaSettings.ExportSettings.UseTriStrips = exportMTLFilesCheckbox[1].checked
		CarmaSettings.ExportSettings.MergeSplits = exportOldCNTCheckbox[1].checked
		CarmaSettings.Save()
		exportSettingsDialog.Close()
	)
	SetClickHandler okButton ExportSettingsOkClicked

	local cancelButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
	cancelButton.Text = "Cancel"
	fn ExportSettingsCancelClicked okButton ev = (
		okButton.parent.Close()
	)
	SetClickHandler cancelButton ExportSettingsCancelClicked
	layoutHelper.EndHorizontalGroup()
	layoutHelper.EndVerticalGroup()

	exportSettingsDialog.ShowDialog()
)

fn CreateMenu uiForm = (

	local crMenu = dotnetobject "System.Windows.Forms.MainMenu"
	uiForm.Menu = crMenu
	local fileMenu = crMenu.MenuItems.Add("&File")
	local importSubMenu = fileMenu.MenuItems.Add("&Import")

	local importMdl = importSubMenu.MenuItems.Add("Import &MDL")
	SetClickHandler importMdl ImportMDLMenuClicked

	local importLight = importSubMenu.MenuItems.Add("Import L&ight")
	SetClickHandler importLight ImportLightMenuClicked

	local importRba = importSubMenu.MenuItems.Add("Import &RBA")
	SetClickHandler importRba ImportRBAMenuClicked

	local importCnt = importSubMenu.MenuItems.Add("Import &CNT")
	SetClickHandler importCnt ImportCNTMenuClicked

	local importSettings = importSubMenu.MenuItems.Add("Import &Settings")
	SetClickHandler importSettings ShowImportOptions

	importSubMenu.MenuItems.Add("-")
	
	local importCar = importSubMenu.MenuItems.Add("Import Ca&r")
	local importCarFull = importCar.MenuItems.Add("Import Full Car")
	SetClickHandler importCarFull ImportFullCarClicked
	local importCarStructure = importCar.MenuItems.Add("Load Structure XML")
	SetClickHandler importCarStructure ImportCarStructureClicked
	local importCarSystemsDamage = importCar.MenuItems.Add("Load SystemsDamage XML")
	SetClickHandler importCarSystemsDamage ImportCarSystemsDamageClicked
	local importCarSetupLUA = importCar.MenuItems.Add("Load Dynamics Setup")
	SetClickHandler importCarSetupLUA ImportCarSetupLUAClicked
	local importCarVehicleSetupCFG = importCar.MenuItems.Add("Load Vehicle Setup Config")
	SetClickHandler importCarVehicleSetupCFG ImportCarVehicleSetupCFGClicked
	local importCarVehicleSetupLUA = importCar.MenuItems.Add("Load  Vehicle Setup LUA")
	SetClickHandler importCarVehicleSetupLUA importCarVehicleSetupLUAClicked
	local importCarVFXAnchorsLUA = importCar.MenuItems.Add("Load VFX Anchors")
	SetClickHandler importCarVFXAnchorsLUA ImportCarVFXAnchorsLUAClicked
	local importCarCrashSoundsConfig = importCar.MenuItems.Add("Load CrashSoundsConfig XML")
	SetClickHandler importCarCrashSoundsConfig ImportCarCrashSoundsConfigClicked

	local importWheel = importSubMenu.MenuItems.Add("Import &Wheel")
	SetClickHandler importWheel ImportWheelClicked

	local importLevel = importSubMenu.MenuItems.Add("Import &Level")
	local importFullLevel = importLevel.MenuItems.Add("&Import Full Level")
	SetClickHandler importFullLevel ImportFullLevelClicked
	local importLevelConfig = importLevel.MenuItems.Add("&Load Level Config")
	SetClickHandler importLevelConfig ImportLevelConfigClicked
	local importLevelSetup = importLevel.MenuItems.Add("&Load Level Environment Setup")
	SetClickHandler importLevelSetup ImportLevelSetupClicked
	local importLevelAccessories = importLevel.MenuItems.Add("&Load Level Accessories")
	SetClickHandler importLevelAccessories ImportLevelAccessoriesClicked
	local importLevelPeds = importLevel.MenuItems.Add("&Load Level Peds")
	SetClickHandler importLevelPeds ImportLevelPedsClicked
	local importLevelRoutes = importLevel.MenuItems.Add("&Load Level Paths")
	SetClickHandler importLevelRoutes ImportLevelRoutesClicked
	local importLevelMinimapDefs = importLevel.MenuItems.Add("&Load Level Minimap Definition")
	SetClickHandler importLevelMinimapDefs ImportMinimapDefsClicked
	local importLevelIntroCam = importLevel.MenuItems.Add("&Load Level Intro Cam")
	SetClickHandler importLevelIntroCam ImportLevelIntroCamClicked
	local importLevelAudio = importLevel.MenuItems.Add("&Load Level Audio")
	SetClickHandler importLevelAudio ImportLevelAudioClicked
	local importLevelZones = importLevel.MenuItems.Add("&Load Level Zones")
	SetClickHandler importLevelZones ImportLevelZonesClicked
	local importLevelPostProcessScripts = importLevel.MenuItems.Add("&Load Level Post Process Scripts")
	SetClickHandler importLevelPostProcessScripts ImportLevelPostProcessScriptsClicked

	local importAccessory = importSubMenu.MenuItems.Add("Import &Accessory")
	SetClickHandler importAccessory ImportAccessoryClicked

	local importPed = importSubMenu.MenuItems.Add("Import &Ped")
	local importPedToDo = importPed.MenuItems.Add("===ToDo===")


	local exportSubMenu = fileMenu.MenuItems.Add("&Export")
	local exportMdl = exportSubMenu.MenuItems.Add("Export &MDL")
	SetClickHandler exportMdl ExportMDLMenuClicked

	local exportLight = exportSubMenu.MenuItems.Add("Export L&ight")
	SetClickHandler exportlight ExportLightMenuClicked

	local exportRba = exportSubMenu.MenuItems.Add("Export &RBA")
	SetClickHandler exportRba ExportRbaMenuClicked

	local exportCnt = exportSubMenu.MenuItems.Add("Export &CNT")
	SetClickHandler exportCnt ExportCntMenuClicked
	
	local exportFullCnt = exportSubMenu.MenuItems.Add("Export &CNT && MDLs")
	SetClickHandler exportFullCnt ExportFullHierarchyMenuClicked

	local exportSettings = exportSubMenu.MenuItems.Add("Export &Settings")
	

	exportSubMenu.MenuItems.Add("-")
	local exportCar = exportSubMenu.MenuItems.Add("Export Ca&r")
	local exportCarFull = exportCar.MenuItems.Add("Export Full Car")
	SetClickHandler exportCarFull ExportCarFullClicked
	local exportCarStructure = exportCar.MenuItems.Add("Save Structure XML")
	SetClickHandler exportCarStructure ExportCarStructureClicked
	local exportCarSystemsDamage = exportCar.MenuItems.Add("Save SystemsDamage XML")
	SetClickHandler exportCarSystemsDamage ExportCarSystemsDamageClicked
	local exportCarSetupLUA = exportCar.MenuItems.Add("Save Dynamics Setup")
	SetClickHandler exportCarSetupLUA ExportCarSetupLUAClicked
	local exportCarVehicleSetupCFG = exportCar.MenuItems.Add("Save Vehicle Setup Config")
	SetClickHandler exportCarVehicleSetupCFG ExportCarVehicleSetupCFGClicked
	local exportCarVehicleSetupLUA = exportCar.MenuItems.Add("Save  Vehicle Setup LUA")
	SetClickHandler exportCarVehicleSetupLUA ExportCarVehicleSetupLUAClicked
	local exportCarVFXAnchorsLUA = exportCar.MenuItems.Add("Save VFX Anchors")
	SetClickHandler exportCarVFXAnchorsLUA ExportCarVFXAnchorsLUAClicked
	local exportCarCrashSoundsConfig = exportCar.MenuItems.Add("Save CrashSoundsConfig XML")
	SetClickHandler exportCarCrashSoundsConfig ExportCarCrashSoundsConfigClicked

	local exportWheel = exportSubMenu.MenuItems.Add("Export &Wheel")
	SetClickHandler exportWheel ExportWheelClicked
	
	local exportLevel = exportSubMenu.MenuItems.Add("Export &Level")
	local exportLevelFull = exportLevel.MenuItems.Add("&Export Full Level")
	SetClickHandler exportLevelFull ExportLevelFullClicked
	local exportLevelConfig = exportLevel.MenuItems.Add("&Save Level Config")
	SetClickHandler exportLevelConfig ExportLevelConfigClicked
	local exportLevelSetup = exportLevel.MenuItems.Add("&Save Level Environment Setup")
	SetClickHandler exportLevelSetup ExportLevelSetupClicked
	local exportLevelAccessories = exportLevel.MenuItems.Add("&Save Level Accessories")
	SetClickHandler exportLevelAccessories ExportLevelAccessoriesClicked
	local exportLevelPeds = exportLevel.MenuItems.Add("&Save Level Peds")
	SetClickHandler exportLevelPeds ExportLevelPedsClicked
	local exportLevelRoutes = exportLevel.MenuItems.Add("&Save Level Paths")
	SetClickHandler exportLevelRoutes ExportLevelRoutesClicked
	local exportLevelMinimapDefs = exportLevel.MenuItems.Add("&Save Level Minimap Definition")
	SetClickHandler exportLevelMinimapDefs ExportLevelMinimapDefsClicked
	local exportLevelIntroCam = exportLevel.MenuItems.Add("&Save Level Intro Cam")
	SetClickHandler exportLevelIntroCam ExportLevelIntroCamClicked
	local exportLevelAudio = exportLevel.MenuItems.Add("&Save Level Audio")
	SetClickHandler exportLevelAudio ExportLevelAudioClicked
	local exportLevelZones = exportLevel.MenuItems.Add("&Save Level Zones")
	SetClickHandler exportLevelZones ExportLevelZonesClicked
	local exportLevelPostProcessScripts = exportLevel.MenuItems.Add("&Save Level Post Process Scripts")
	SetClickHandler exportLevelPostProcessScripts ExportLevelPostProcessScriptsClicked

	local exportAccessory = exportSubMenu.MenuItems.Add("Export &Accessory")
	local exportFullAccessory = exportAccessory.MenuItems.Add("Export Fiull&Accessory")
	local exportAccessoryTXT = exportAccessory.MenuItems.Add("Save &Accessory.TXT")
	SetClickHandler exportFullAccessory ExportFullAccessoryClicked
	SetClickHandler exportAccessoryTXT ExportAccessoryClicked

	local exportPed = exportSubMenu.MenuItems.Add("Export &Ped")
	local exportPedToDo = exportPed.MenuItems.Add("===ToDo===")


	local modeMenu = crMenu.MenuItems.Add("&Edit Mode")
	local modeCar = modeMenu.MenuItems.Add("&Car Creation") 
	SetClickHandler modeCar SetToolMode_Car
	modeCar.Shortcut = (dotnetclass "System.Windows.Forms.Shortcut").CtrlShift1
	
	local modeWheel = modeMenu.MenuItems.Add("&Wheel Creation")
	SetClickHandler modeWheel SetToolMode_Wheel
	modeWheel.Shortcut = (dotnetclass "System.Windows.Forms.Shortcut").CtrlShift2

	local modeLevel = modeMenu.MenuItems.Add("&Level Creation")
	SetClickHandler modeLevel SetToolMode_Level
	modeLevel.Shortcut = (dotnetclass "System.Windows.Forms.Shortcut").CtrlShift3

	local modeAccessory = modeMenu.MenuItems.Add("&Accessory Creation")
	SetClickHandler modeAccessory SetToolMode_Accessory
	modeAccessory.Shortcut = (dotnetclass "System.Windows.Forms.Shortcut").CtrlShift4

	local modePed = modeMenu.MenuItems.Add("&Ped Creation")
	SetClickHandler modePed SetToolMode_Ped
	modePed.Shortcut = (dotnetclass "System.Windows.Forms.Shortcut").CtrlShift5
	
	local helpMenu = crMenu.MenuItems.Add("&Help")
	local aboutMenuLink = helpMenu.MenuItems.Add("About")
)
fn SelectedNodeChangeHandler = (
	global CRToolsUI

	if selection.count == 1 then  (
		--format "select changed: %\n" $.name
		if CRToolsUI != undefined and $.isSelected then (
			if $.modifiers["Car Structure Part"] != undefined then (
				SetToolMode_Car undefined
				--format "Car mode\n"
			)
			else if $.modifiers["Complicated Wheel"] != undefined then (
				--format "Wheel mode\n"
				SetToolMode_Wheel undefined
			)
			else if $.modifiers["Accessory Settings"] != undefined then (
				--format "Accessory mode\n"
				SetToolMode_Accessory undefined
			)
		)
	)
)
fn CreateNewUI =
(
	global CRToolsUI
	global CRToolsFloater
	global ToolModeChangeHandler
	--if CRToolsUI != undefined then
	--(
		--CRToolsUI = undefined
		--CRToolsUI.close()
		--CRToolsUI.dispose()
		--gc()
	--)
	--try(
	--	if carma_reincarnation_dockfloater.dialogbar then cui.UnRegisterDialogBar carma_reincarnation_dockfloater
	--) catch()
	--destroydialog carma_reincarnation_dockfloater
	--CRToolsFloater = createDialog carma_reincarnation_dockfloater style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
	--cui.RegisterDialogBar carma_reincarnation_dockfloater style:#(#cui_floatable,#cui_dock_left,#cui_handles) minSize:[470,500] maxSize:[-1,-1]
	--cui.DockDialogBar carma_reincarnation_dockfloater #cui_dock_left
	--CRToolsUI	= dotNetObject "maxCustomControls.maxForm"
	--CRToolsUI.Width = 405
	--CRToolsUI.Height = 500
	--CRToolsUI.Text = "Carmageddon Reincarnation Tools"
	
	maxHandlePointer= FindMaxWindow()-- (Windows.GetMAXHWND())
	sysPointer = DotNetObject "System.IntPtr" maxHandlePointer
		
	--maxHwnd = (dotnetclass "System.Windows.Forms.Control").fromHandle sysPointer --DotNetObject "MaxCustomControls.Win32HandleWrapper" sysPointer
	--CRToolsUI.show(maxHwnd)
		
		--tabs = SetupTabs CRToolsUI labels:#("Generic", "Car", "Level", "Accessory") Layout:(DN_ControlLayout AnchorStyles:#("Left","Right","Top","Bottom") BackColor:(CRToolsUI.backColor.FromARGB 255  60 60 60) Height:500 Width:(CRToolsUI.Width))
		--showProps tabs doClearListener:true
	--CR_SetupImportTab tabs.tabPages.Item[0]
	--CR_SetupExportTab tabs.tabPages.Item[1]
	--CR_SetupToolsTab tabs.tabPages.Item[2]
			
	--ToolsStartup()
			
	CRToolsUI = dotNetObject "System.Windows.Forms.Form"

	CRToolsUi.width = 420
	CRToolsUI.height = 600
	CRToolsUI.autosize = true
	CRToolsUI.autoscroll = true
	--local tooltip = dotNetObject "System.Windows.Forms.ToolTip"
	--tooltip.name = "fornToolTip"
	--CRToolsUI.Controls.Add tooltip
	local currentScriptFileName = getThisScriptFilename()
	local currentScriptFolder = getFilenamePath currentScriptFileName
	local iconBmp = dotnetobject "System.Drawing.Bitmap" (currentScriptFolder + "\\UI\\ToolsIcon.png") 
	CRToolsUI.Text = "Carmageddon: 3DSMax Damage"
	CRToolsUI.Icon = (dotnetclass "System.Drawing.Icon").FromHandle (iconBmp.GetHicon())
	CreateMenu CRToolsUI

	local controlClass = dotnetclass "System.Windows.Forms.Control"
	CRToolsUI.show (controlClass.FromHandle maxHandlePointer)
--CRToolsUI.Owner = (controlClass.FromHandle maxHandlePointer)
	callbacks.removeScripts #selectionSetChanged id:#crtoolschangehandler
	callbacks.addScript #selectionSetChanged "SelectedNodeChangeHandler()" id:#crtoolschangehandler
	SetToolMode_Car undefined
	CRToolsUI
)