fn DoRenderCarUIAsssets carname skins materialFolder DamageHud:true MiniMap:true GridIcon:true SideView:true ThreeQuarters:true ThreeQuartersHighRes:true = (
	folderSelectDialog = dotnetobject "CMDControls.FolderSelectDialog"
	if folderSelectDialog.ShowDialog() and folderSelectDialog.FileName != undefined then (
		local outputfolder = folderSelectDialog.FileName
		local cfgMod = GetVehilceCFGModifier selection[1]
		local carRoot = selection[1]
		ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
		makedir outputfolder
		if DamageHud then (
			RenderHUDDamage (outputfolder+"\\hud_damage_backing.png")
			RenderHUDOutline (outputfolder+"\\hud_damage_outline.png")
			ConvertTDX.Convert (outputfolder+"\\hud_damage_backing.png") outputFolder 5
			ConvertTDX.Convert (outputfolder+"\\hud_damage_outline.png") outputFolder 5
		)

		for i in skins do (
			local oldMats = #()
			local skinName = cfgMod.PaintJobNames[i]
			local matReplacements = filterstring cfgMod.MatReplacements[i] ";"
			for matReplacement in matReplacements do (
				local matPair = filterstring matReplacement ":"
				append oldMats scenematerials[matPair[1]]
				local newMat = (GetMaterialFromMT2 materialFolder matPair[2] importTextures:true)
				for mat in scenematerials where (classof mat) == Multimaterial do (
					for i = 1 to mat.material.count do (
						if (tolower mat.material[i].name) == (tolower matPair[1]) then (
							mat.material[i] = newMat
						)
					)
				)
				for obj in objects where obj.material != undefined and (tolower obj.material.name) == (tolower matPair[1]) do (
					obj.material = newMat
				)
			)
			
			if GridIcon then (
				RenderTopView (outputfolder+"\\"+carname+"_"+skinname+"_top.png")
				ConvertTDX.Convert (outputfolder+"\\"+carname+"_"+skinname+"_top.png") outputFolder 5
			)
			if MiniMap then (
				RenderMiniMap (outputfolder+"\\"+carname+"_"+skinname+"_minimap.png")
				ConvertTDX.Convert (outputfolder+"\\"+carname+"_"+skinname+"_minimap.png") outputFolder 5
			)
			if SideView then (
				RenderSideView (outputfolder+"\\"+carname+"_"+skinname+"_side.png")
				ConvertTDX.Convert (outputfolder+"\\"+carname+"_"+skinname+"_side.png") outputFolder 5
			)

			if ThreeQuarters then (
				RenderThreeQuarterView  (outputfolder+"\\"+carname+"_"+skinname+"_3Qs.png") closeup:true carRoot:carRoot selfIllum:0 light1Value:255 light2Value:255 light1Multiplier:1.0 light2Multiplier:1.0
				select carRoot
			)
			if ThreeQuartersHighRes then (
				RenderThreeQuarterView  (outputfolder+"\\"+carname+"_"+skinname+"_3Qs_highres.png") closeUp:true outputsize:[1024,1024] carRoot:carRoot selfIllum:0 light1Value:255 light2Value:255 light1Multiplier:1.0 light2Multiplier:1.0
				select carRoot
			)
			for matReplacement in matReplacements do (
				local matPair = filterstring matReplacement ":"
				local oldMat = (for m in oldMats where (tolower m.name) == (tolower matPair[1]) collect m)[1]
				for mat in scenematerials where (classof mat) == Multimaterial do (
					for i = 1 to mat.material.count do (
						if (tolower mat.material[i].name) == (tolower matPair[2]) then (
							mat.material[i] = oldMat
						)
					)
				)
				for obj in objects where obj.material != undefined and (tolower obj.material.name) == (tolower matPair[2]) do (
					obj.material = oldMat
				)
				
			)
		)
	)
)

fn RenderCarUIAssetsDialog = (
	global CarmaSettings

	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else if (GetVehilceCFGModifier selection[1]) == undefined then (
		messageBox "No Vehicle Confic found, are you sure this is a car?" title:"Vehicle Config Not Found"
	)
	else (
		 local cfgMod = GetVehilceCFGModifier selection[1]
		 renderDialog = dotNetObject "System.Windows.Forms.Form"
		 renderDialog.width = 350
		 renderDialog.height = 700

		renderDialog.text = "Render Car UI Assets"
		local layoutHelper = DotNetFormHelper ParentControl:renderDialog OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
		layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
		(
			local renderSetupLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27]
			renderSetupLabel.text = "Car Setup"
			layoutHelper.SetFont renderSetupLabel "Segoe UI" 12 bold:true underline:false

			layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
			(
					local carNameLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[100,27]
					carNameLabel.text = "Car Name"
					layoutHelper.SetFont carNameLabel "Segoe UI" 8 bold:false underline:false
					local renderCarNameInput = layoutHelper.AddControl "System.Windows.Forms.TextBox" size:[150,20]
					renderCarNameInput.text = cfgMod.CarName
					--renderCarNameInput.tooltip = "The name of the car, it must match the folder name of the car."
					renderCarNameInput.name = "renderCarNameInput"
			)
			layoutHelper.EndHorizontalGroup()
			local matFolderLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[100,27]
			matFolderLabel.text = "Material Folder"
			layoutHelper.SetFont matFolderLabel "Segoe UI" 8 bold:false underline:false
			
			layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
			(
					local renderMatFolderInput = layoutHelper.AddControl "System.Windows.Forms.TextBox" size:[150,20]
					renderMatFolderInput.text = CarmaSettings.DataCorePath+"\\Content\\Vehicles\\" + cfgmod.carName+"\\"
					--renderMatFolderInput.tooltip = "The name of the car, it must match the folder name of the car."
					renderMatFolderInput.name = "renderMatFolderInput"

					local pickMatFolderButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[100,20]
					pickMatFolderButton.name = "pickMatFolderButton"
					pickMatFolderButton.text = "Browse"

					fn onPickMatButtonClicked btn arg = (
						local folderInput = btn.parent.controls.Item["renderMatFolderInput"]
						local folderSelectDialog = dotnetobject "CMDControls.FolderSelectDialog"
						folderSelectDialog.InitialDirectory = folderInput.text
						if folderSelectDialog.ShowDialog() and folderSelectDialog.FileName != undefined then (
							folderInput.text = folderSelectDialog.FileName
						)
					)
					SetClickHandler pickMatFolderButton onPickMatButtonClicked
			)
			layoutHelper.EndHorizontalGroup()
			local renderOptionSelectLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[330,27]
			renderOptionSelectLabel.text = "Render Options"
			layoutHelper.SetFont renderOptionSelectLabel "Segoe UI" 12 bold:true underline:false
			local renderOptionsListPanel = layoutHelper.AddControl "System.Windows.Forms.Panel" size:[320, 110]
			renderOptionsListPanel.autoscroll=true
			renderOptionsListPanel.name="renderOptionsListPanel"
			layoutHelper.SetBorderStyle renderOptionsListPanel "FixedSingle"
			local renderOptionsLayoutHelper = DotNetFormHelper ParentControl:renderOptionsListPanel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
			renderOptionsLayoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
			(
				renderOptionsLayoutHelper.BeginHorizontalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
				(
					local renderDamageHudCheckbox = renderOptionsLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[130,20]
					renderDamageHudCheckbox.text = "Damage HUD"
					renderDamageHudCheckbox.name = "renderDamageHudCheckbox"
					renderDamageHudCheckbox.checked = true

					local renderMiniMapCheckbox = renderOptionsLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[130,20]
					renderMiniMapCheckbox.text = "Mini Map Icon"
					renderMiniMapCheckbox.name = "renderMiniMapCheckbox"
					renderMiniMapCheckbox.checked = true
				
				)
				renderOptionsLayoutHelper.EndHorizontalGroup()
				renderOptionsLayoutHelper.BeginHorizontalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
				(
					local renderGridCheckbox = renderOptionsLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[130,20]
					renderGridCheckbox.text = "Grid Icon"
					renderGridCheckbox.name = "renderGridCheckbox"
					renderGridCheckbox.checked = true

					local renderSideViewCheckbox = renderOptionsLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[130,20]
					renderSideViewCheckbox.text = "Scoreboard Icon"
					renderSideViewCheckbox.name = "renderSideViewCheckbox"
					renderSideViewCheckbox.checked = true
				
				)
				renderOptionsLayoutHelper.EndHorizontalGroup()
				renderOptionsLayoutHelper.BeginHorizontalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
				(
					local renderThreeQuartersCheckbox = renderOptionsLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[130,20]
					renderThreeQuartersCheckbox.text = "3/4 view"
					renderThreeQuartersCheckbox.name = "renderThreeQuartersCheckbox"
					renderThreeQuartersCheckbox.checked = true

					local renderThreeQuartersHighResCheckbox = renderOptionsLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[130,20]
					renderThreeQuartersHighResCheckbox.text = "3/4 view (high res)"
					renderThreeQuartersHighResCheckbox.name = "renderThreeQuartersHighResCheckbox"
					renderThreeQuartersHighResCheckbox.checked = true
				
				)
				renderOptionsLayoutHelper.EndHorizontalGroup()
			)
			renderOptionsLayoutHelper.EndVerticalGroup()

			local skinSelectLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[330,27]
			skinSelectLabel.text = "Select skins to render"
			layoutHelper.SetFont skinSelectLabel "Segoe UI" 12 bold:true underline:false
			local skinsListPanel = layoutHelper.AddControl "System.Windows.Forms.Panel" size:[320, 230]
			skinsListPanel.autoscroll=true
			skinsListPanel.name="skinsListPanel"
			layoutHelper.SetBorderStyle skinsListPanel "FixedSingle"
			local skinListLayoutHelper = DotNetFormHelper ParentControl:skinsListPanel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginRight:5
			skinListLayoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
			(
				for i = 1 to  cfgMod.PaintJobNames.Count do (
					local skinName = cfgMod.PaintJobNames[i]
					local skinCheckbox = skinListLayoutHelper.AddControl "System.Windows.Forms.CheckBox" size:[200,20]
					skinCheckbox.text = skinName
					skinCheckbox.tag = i
					skinCheckbox.checked = true
				)
			)
			skinListLayoutHelper.EndVerticalGroup()

			layoutHelper.BeginHorizontalGroup()
			(
				local okButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
				--okButton.Location = dotnetobject "System.Drawing.Point" 10 130 
				okButton.text = "Render"
				fn RenderDialogOkClicked okButton ev = (
					local carname = okButton.parent.controls.Item["renderCarNameInput"].text
					local skins = #()
					local skinPanelControls = okButton.parent.controls.Item["skinsListPanel"].controls
					for i = 0 to skinPanelControls.count - 1 do (
						local chkItem = skinPanelControls.Item[i]
						if chkItem.checked == true then (
							append skins chkItem.tag
						)
					)

					local matFolder = okButton.parent.controls.Item["renderMatFolderInput"].text
					local optionsPanelControls = okButton.parent.controls.Item["renderOptionsListPanel"].controls
					local renderDamageHud = optionsPanelControls.Item["renderDamageHudCheckbox"].checked
					local renderMiniMap = optionsPanelControls.Item["renderMiniMapCheckbox"].checked
					local renderGrid = optionsPanelControls.Item["renderGridCheckbox"].checked
					local renderSide = optionsPanelControls.Item["renderSideViewCheckbox"].checked
					local renderThreeQuarters = optionsPanelControls.Item["renderThreeQuartersCheckbox"].checked
					local renderThreeQuartersHighRes = optionsPanelControls.Item["renderThreeQuartersHighResCheckbox"].checked
					local cfgMod = GetVehilceCFGModifier selection[1]
					for i in skins do (
						format "skin \"%\" ticked with replacemrnts %\n" cfgMod.PaintJobNames[i] cfgMod.MatReplacements[i]
					)

					DoRenderCarUIAsssets carname skins matFolder DamageHud:renderDamageHud MiniMap:renderMiniMap GridIcon:renderGrid SideView:renderSide ThreeQuarters:renderThreeQuarters ThreeQuartersHighRes:renderThreeQuartersHighRes
					okButton.parent.Close()
				)
				SetClickHandler okButton RenderDialogOkClicked

				local cancelButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
				cancelButton.Text = "Cancel"
				fn RenderDialogCancelClicked cancelButton ev = (
					cancelButton.parent.Close()
				)
				SetClickHandler cancelButton RenderDialogCancelClicked
			)
			layoutHelper.EndHorizontalGroup()
		)
		layoutHelper.EndVerticalGroup()

		renderDialog.ShowDialog()
	)
)

fn AddCarToolsUI parentLayoutHelper = (

	local carSetupLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	carSetupLabel.text = "Car Setup"
	parentLayoutHelper.SetFont carSetupLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 100] margin:[10,0]
	panel.name = "CarSetupPanel"

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		local setupCarStructureButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[200,20]
		setupCarStructureButton.text = "Setup Car"
		setupCarStructureButton.name = "setupCarStructureButton"
		SetClickHandler setupCarStructureButton SetupCarStructureButton_Pressed


		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:1 marginBottom:3 marginLeft:1
		(
			local addVehicleCFGButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[178,20]
			addVehicleCFGButton.text = "Add Vehicle Setup CFG"
			addVehicleCFGButton.name = "addVehicleCFGButton"
			
			fn addVehicleCFGButton_Pressed sender arg = (
				if selection.count > 0 then (
					AddVehilceCFGModifier selection[1]
				)
			)
			SetClickHandler addVehicleCFGButton addVehicleCFGButton_Pressed


			local addVehicleLUAButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[178,20]
			addVehicleLUAButton.text = "Add Vehicle Setup LUA"
			addVehicleLUAButton.name = "addVehicleLUAButton"
			
			fn addVehicleLUAButton_Pressed sender arg = (
				if selection.count > 0 then (
					AddVehilceLUAModifier selection[1]
				)
			)
			SetClickHandler addVehicleLUAButton addVehicleLUAButton_Pressed
		)
		layoutHelper.EndHorizontalGroup()
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:1 marginBottom:3 marginLeft:1
		(
			local addHandlingSetup_Button = layoutHelper.AddControl "System.Windows.Forms.Button" size:[178,20]
			addHandlingSetup_Button.text = "Add Handling Setup LUA"
			addHandlingSetup_Button.name = "addHandlingSetup_Button"
			
			fn addHandlingSetup_Button_Pressed sender arg = (
				if selection.count > 0 then (
					AddHandlingSetupLUAModifier selection[1]
				)
			)
			SetClickHandler addHandlingSetup_Button addHandlingSetup_Button_Pressed


			local addVehicleCharacteristics = layoutHelper.AddControl "System.Windows.Forms.Button" size:[178,20]
			addVehicleCharacteristics.text = "Add Vehicle Characteristics"
			addVehicleCharacteristics.name = "addVehicleCharacteristics"
			
			fn addVehicleCharacteristics_Pressed sender arg = (
				if selection.count > 0 then (
					AddStructureCharacteristicsModifier selection[1]
				)
			)
			SetClickHandler addVehicleCharacteristics addVehicleCharacteristics_Pressed
		)
		layoutHelper.EndHorizontalGroup()
	)

	layoutHelper.EndVerticalGroup()
	local systemsDamageLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	systemsDamageLabel.text = "Structure"
	layoutHelper.SetFont systemsDamageLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 250] margin:[10,0]
	panel.name = "CarStructurePanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		local StructureLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		StructureLabel.text = "General Structure:"

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local addStructPartButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addStructPartButton.text = "Add Struct Part"
			addStructPartButton.name = "addStructPartButton"
			
			SetClickHandler addStructPartButton AddStructPartButton_Pressed


			local addWeldButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addWeldButton.text = "Add Weld"
			addWeldButton.name = "addWeldButton"
			SetClickHandler addWeldButton AddWeldButton_Pressed
		)
		layoutHelper.EndHorizontalGroup()
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local addVfxAnchorButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addVfxAnchorButton.text = "Add VFX Anchor"
			addVfxAnchorButton.name = "addVfxAnchorButton"
			fn addVfxAnchorButton_Pressed sender arg = (
				if selection.count > 0 then (
					AddVFXAnchor selection[1] groupname:"Exhaust" anchorid:(selection[1].name+"_vfx") offset:[0,0,0] rot:(quat 1) scale:[1,1,1]
				)
			)
			SetClickHandler addVfxAnchorButton addVfxAnchorButton_Pressed

		)
		layoutHelper.EndHorizontalGroup()

		local animlabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		animlabel.text = "Animation & Joints:"

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local addAnimationButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addAnimationButton.text = "Animated Part"
			addAnimationButton.name = "addAnimationButton"
			
			SetClickHandler addAnimationButton AddAnimationButton_Pressed


			local addPointToPointButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addPointToPointButton.text = "Point-to-Point Animation"
			addPointToPointButton.name = "addPointToPointButton"
			SetClickHandler addPointToPointButton AddPointToPointButton_Pressed
		)
		layoutHelper.EndHorizontalGroup()

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local addJointButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addJointButton.text = "Create Joint"
			addJointButton.name = "addJointButton"
			
			SetClickHandler addJointButton CreateJointButton_Pressed


			local CreatePointHelperButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			CreatePointHelperButton.text = "Create Point Helper"
			CreatePointHelperButton.name = "CreatePointHelperButton"
			SetClickHandler CreatePointHelperButton CreateHelperPoint_Pressed
		)
		layoutHelper.EndHorizontalGroup()

		local suspensionLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		suspensionLabel.text = "Suspension:"

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local setAsAxleButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setAsAxleButton.text = "Set as Axle"
			setAsAxleButton.name = "setAsAxleButton"
			
			SetClickHandler setAsAxleButton AddWishboneAxle_Pressed


			local setAsMount = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setAsMount.text = "Set as Mount"
			setAsMount.name = "setAsMount"
			SetClickHandler setAsMount AddWishboneMount_Pressed
		)
		layoutHelper.EndHorizontalGroup()

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local setAsHubButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setAsHubButton.text = "Set as Hub"
			setAsHubButton.name = "setAsHubButton"
			
			SetClickHandler setAsHubButton AddWishboneHub_Pressed


			local setAsTrailingArmButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setAsTrailingArmButton.text = "Set as Trailing Arm"
			setAsTrailingArmButton.name = "setAsTrailingArmButton"
			SetClickHandler setAsTrailingArmButton AddTrailingArm_Pressed
		)
		layoutHelper.EndHorizontalGroup()

	)

	layoutHelper.EndVerticalGroup()
	local wheelsLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	wheelsLabel.text = "Wheels"
	layoutHelper.SetFont wheelsLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 200] margin:[10,0]
	panel.name = "CarWheelsPanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(


		local wheelSetLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		wheelSetLabel.text = "Create wheel set:"

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local numWheelsDropdown = layoutHelper.AddControl "System.Windows.Forms.Combobox" size:[75,20]
			numWheelsDropdown.name = "numWheelsDropdown"
			numWheelsDropdown.Items.Add 4
			numWheelsDropdown.Items.Add 6
			numWheelsDropdown.Items.Add 8
			numWheelsDropdown.Items.Add 10
			numWheelsDropdown.Items.Add 12



			local addWheelSetButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addWheelSetButton.text = "Create Wheel Set"
			addWheelSetButton.name = "addWheelSetButton"
			
			fn addWheelSetButton_Clicked sender ev = (
				local numWheelsDpdn = sender.parent.Controls.Find "numWheelsDropdown"
				local numWheelsIndex = numWh.selectedindex
				local numWheels = numWheelsDpdn.Items.Item[numWheelsIndex] as integer

				undo "Make All Wheel Nodes" on
				(
					local trans = matrix3 1
					local whl = CreateNewWheelNode trans "Wheel_FL" selectAndFocus:false
					whl.rotation = (angleaxis 180 [0,0,1]) as quat
					whl.position = [1,-0.83895,0.3591]
					whl = CreateNewWheelNode trans "Wheel_FR" selectAndFocus:false
					whl.position = [-1,-0.83895,0.3591]
					whl = CreateNewWheelNode trans "Wheel_RL" selectAndFocus:false
					whl.rotation = (angleaxis 180 [0,0,1]) as quat
					whl.position = [1,2.16105,0.3591]
					whl = CreateNewWheelNode trans "Wheel_RR" selectAndFocus:false
					whl.position = [-1,2.16105,0.3591]

					if numWheels >= 6 then (
						local whl = CreateNewWheelNode trans "Wheel_RL001" selectAndFocus:false
						whl.rotation = (angleaxis 180 [0,0,1]) as quat
						whl.position = [1,1.83895,0.3591]
						whl = CreateNewWheelNode trans "Wheel_RR001" selectAndFocus:false
						whl.position = [-1,1.83895,0.3591]

					)
					if numWheels >= 8 then (
						local whl = CreateNewWheelNode trans "Wheel_RL002" selectAndFocus:false
						whl.rotation = (angleaxis 180 [0,0,1]) as quat
						whl.position = [1,1.03895,0.3591]
						whl = CreateNewWheelNode trans "Wheel_RR002" selectAndFocus:false
						whl.position = [-1,1.03895,0.3591]

					)
					if numWheels >= 10 then (
						local whl = CreateNewWheelNode trans "Wheel_RL003" selectAndFocus:false
						whl.rotation = (angleaxis 180 [0,0,1]) as quat
						whl.position = [1,0.53895,0.3591]
						whl = CreateNewWheelNode trans "Wheel_RR003" selectAndFocus:false
						whl.position = [-1,0.53895,0.3591]

					)
					if numWheels >= 12 then (
						local whl = CreateNewWheelNode trans "Wheel_RL004" selectAndFocus:false
						whl.rotation = (angleaxis 180 [0,0,1]) as quat
						whl.position = [1,-0.23895,0.3591]
						whl = CreateNewWheelNode trans "Wheel_RR004" selectAndFocus:false
						whl.position = [-1,-0.23895,0.3591]

					)
				)
			)
			SetClickHandler addWheelSetButton addWheelSetButton_Clicked


		)
		layoutHelper.EndHorizontalGroup()
		local createWheelLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		createWheelLabel.text = "Create wheel:"

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local wheelTypeLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[75,20] margin:[0,0]
			wheelTypeLabel.text = "Wheel type"
			local WheelSelectBox = layoutHelper.AddControl "System.Windows.Forms.Combobox" size:[125,20]
			WheelSelectBox.name = "WheelSelectBox"
			WheelSelectBox.Items.Add "Front Left"
			WheelSelectBox.Items.Add "Front Right"
			WheelSelectBox.Items.Add "Rear Left"
			WheelSelectBox.Items.Add "Rear Right"
			WheelSelectBox.Items.Add "Mid Left 1"
			WheelSelectBox.Items.Add "Mid Right 1"
			WheelSelectBox.Items.Add "Mid Left 2"
			WheelSelectBox.Items.Add "Mid Right 2"
			WheelSelectBox.Items.Add "Mid Left 3"
			WheelSelectBox.Items.Add "Mid Right 3"
			WheelSelectBox.Items.Add "Mid Left 4"
			WheelSelectBox.Items.Add "Mid Right 4"
			WheelSelectBox.selectedindex = 0

		)
		layoutHelper.EndHorizontalGroup()
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addWheelButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addWheelButton.text = "Create Wheel"
			addWheelButton.name = "addWheelButton"
			
			
			SetClickHandler addWheelButton CreateWheelButton_Pressed


			local convertToWheelButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			convertToWheelButton.text = "Create Wheel"
			convertToWheelButton.name = "convertToWheelButton"
			
			
			SetClickHandler convertToWheelButton ConvertToWheelButton_Pressed


		)
		layoutHelper.EndHorizontalGroup()
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local setWheelRadiusByPos = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setWheelRadiusByPos.text = "Calc Radius From Pos"
			--setWheelRadiusByPos.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			setWheelRadiusByPos.name = "setWheelRadiusByPos"
			
			
			SetClickHandler setWheelRadiusByPos SetWheelRadiusToPosButton_Pressed


			local setPosByRadius = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setPosByRadius.text = "Calc Pos From Radius"
			--setPosByRadius.tooltip = "Adjusts the wheel's vertical position based on its radius so the bottom of the wheel is on the origin plane"
			setPosByRadius.name = "setPosByRadius"
			
			
			SetClickHandler setPosByRadius SetWheelPosToRadiusButton_Pressed


		)
		layoutHelper.EndHorizontalGroup()
	)

	layoutHelper.EndVerticalGroup()
	local systemsDamageLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	systemsDamageLabel.text = "Damage"
	layoutHelper.SetFont systemsDamageLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 100] margin:[10,0]
	panel.name = "CarDamagePanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(
		local addStdDamageSystemsButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[200,20]
		addStdDamageSystemsButton.text = "Add standard damage units"
		--addStdDamageSystemsButton.tooltip = "Adds the standard damage units to a car. Select the car's root object then press this button."
		addStdDamageSystemsButton.name = "addStdDamageSystemsButton"
		fn addStdDamageSystemsButton_OnClick sender arg = (
			if selection.count > 0 then
				AddStandardDamageUnits selection[1]
		)
			
		SetClickHandler addStdDamageSystemsButton addStdDamageSystemsButton_OnClick	


		local addDamageUnitLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		addDamageUnitLabel.text = "Add Damage Unit:"

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local damageUnitSelectBox = layoutHelper.AddControl "System.Windows.Forms.Combobox" size:[125,20]
			damageUnitSelectBox.name = "damageUnitSelectBox"
			damageUnitSelectBox.Items.Add "Engine"
			damageUnitSelectBox.Items.Add "Joint"
			damageUnitSelectBox.Items.Add "bodywork"
			damageUnitSelectBox.Items.Add "engine"
			damageUnitSelectBox.Items.Add "fl_wheel"
			damageUnitSelectBox.Items.Add "fl_wheel_001"
			damageUnitSelectBox.Items.Add "fl_wheel_002"
			damageUnitSelectBox.Items.Add "fr_wheel"
			damageUnitSelectBox.Items.Add "fr_wheel_001"
			damageUnitSelectBox.Items.Add "fr_wheel_002"
			damageUnitSelectBox.Items.Add "generator"
			damageUnitSelectBox.Items.Add "left_front_track"
			damageUnitSelectBox.Items.Add "left_rear_track"
			damageUnitSelectBox.Items.Add "left_track"
			damageUnitSelectBox.Items.Add "right_front_track"
			damageUnitSelectBox.Items.Add "right_rear_track"
			damageUnitSelectBox.Items.Add "right_track"
			damageUnitSelectBox.Items.Add "rl_wheel"
			damageUnitSelectBox.Items.Add "rl_wheel_001"
			damageUnitSelectBox.Items.Add "rl_wheel_002"
			damageUnitSelectBox.Items.Add "rl_wheel_003"
			damageUnitSelectBox.Items.Add "rl_wheel_004"
			damageUnitSelectBox.Items.Add "rr_wheel"
			damageUnitSelectBox.Items.Add "rr_wheel_001"
			damageUnitSelectBox.Items.Add "rr_wheel_002"
			damageUnitSelectBox.Items.Add "rr_wheel_003"
			damageUnitSelectBox.Items.Add "rr_wheel_004"
			damageUnitSelectBox.Items.Add "steering"
			damageUnitSelectBox.Items.Add "transmission"
			damageUnitSelectBox.selectedindex = 0
			local addDamageUnitButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addDamageUnitButton.text = "Add Dmg Unit"
			addDamageUnitButton.name = "addDamageUnitButton"
			
			fn AddDamageUnitButton_Pressed sender arg = (
				if selection.count > 0 then (
					local unitSelectBox = sender.parent.controls.Item["damageUnitSelectBox"]
					local selectedUnitIndex = unitSelectBox.selectedindex
					local unit = unitSelectBox.Items.Item[selectedUnitIndex]
					AddSystemDamageUnit selection[1] unitname:unit
				)
			)
			
			SetClickHandler addDamageUnitButton AddDamageUnitButton_Pressed

		)
		layoutHelper.EndHorizontalGroup()

	)

	layoutHelper.EndVerticalGroup()
	local systemsDamageLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	systemsDamageLabel.text = "UI Assets"
	layoutHelper.SetFont systemsDamageLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 150] margin:[10,0]
	panel.name = "UIAssetsPanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local renderAllUIAssetsButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			renderAllUIAssetsButton.text = "Render UI Assets"
			--renderAllUIAssetsButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			renderAllUIAssetsButton.name = "renderAllUIAssetsButton"
			
			fn renderAllUIAssetsButton_pressed sender arg = (

				RenderCarUIAssetsDialog()
			)
			
			SetClickHandler renderAllUIAssetsButton renderAllUIAssetsButton_pressed

		)
		layoutHelper.EndHorizontalGroup()
	)

	layoutHelper.EndVerticalGroup()

)