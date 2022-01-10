
fn AddModeButtons layoutHelper selectedMode = (

	local currentScriptFileName = getThisScriptFilename()
	local currentScriptFolder = getFilenamePath currentScriptFileName
	layoutHelper.BeginHorizontalGroup margintop:0 marginbottom:0 marginright:10 marginLeft:10
	(
		local carModeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[50,50]
		carModeButton.text = ""
		carModeButton.backgroundimagelayout = (dotnetclass "ImageLayout").Stretch
		if selectedMode == "Car" then (
			carModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\CarIcon-selected.png")
		)
		else (
			carModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\CarIcon.png")
		)
		carModeButton.name = "carModeButton"

		SetClickHandler carModeButton SetToolMode_Car

		local WheelModeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[50,50]
		WheelModeButton.text = ""
		WheelModeButton.backgroundimagelayout = (dotnetclass "ImageLayout").Stretch
		if selectedMode == "Wheel" then (
		WheelModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\WheelIcon-selected.png")
		)
		else (
		WheelModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\WheelIcon.png")
		)
		WheelModeButton.name = "WheelModeButton"

		SetClickHandler WheelModeButton SetToolMode_Wheel

		local LevelModeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[50,50]
		LevelModeButton.text = ""
		LevelModeButton.backgroundimagelayout = (dotnetclass "ImageLayout").Stretch
		if selectedMode == "Level" then (
		LevelModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\LevelIcon-selected.png")
		)
		else (
		LevelModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\LevelIcon.png")
		)
		LevelModeButton.name = "LevelModeButton"

		SetClickHandler LevelModeButton SetToolMode_Level

		local AccessoryModeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[50,50]
		AccessoryModeButton.text = ""
		AccessoryModeButton.backgroundimagelayout = (dotnetclass "ImageLayout").Stretch
		if selectedMode == "Accessory" then (
		AccessoryModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\AccessoryIcon-selected.png")
		)
		else (
		AccessoryModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\AccessoryIcon.png")
		)
		AccessoryModeButton.name = "AccessoryModeButton"

		SetClickHandler AccessoryModeButton SetToolMode_Accessory

		local PedModeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[50,50]
		PedModeButton.text = ""
		PedModeButton.backgroundimagelayout = (dotnetclass "ImageLayout").Stretch
		if selectedMode == "Ped" then (
		PedModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\PedIcon-selected.png")
		)
		else (
		PedModeButton.backgroundImage = (dotnetclass "System.Drawing.Image").FromFile (currentScriptFolder+"\\UI\\PedIcon.png")
		)
		PedModeButton.name = "PedModeButton"

		SetClickHandler PedModeButton SetToolMode_Ped
	)
	layoutHelper.EndHorizontalGroup()
)
fn AddHierarchyToolsUI parentLayoutHelper = (

	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 150]

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		local SetupHierarchyLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		SetupHierarchyLabel.text = "NULL Nodes:"
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(
			local createNullButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			createNullButton.text = "Create NULL"
			createNullButton.name = "createNullButton"
			fn OnCreateNullClicked btn ev = (
				undo "Create NULL Node" on
				(
					trans = matrix3 1
					if selection[1] != undefined do trans = selection[1].transform
					CreateNewNULLNode trans "NewNullNode" selectAndFocus:true
				)
			)
			SetClickHandler createNullButton OnCreateNullClicked


			local convertToNullButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			convertToNullButton.text = "Convert To NULL"
			convertToNullButton.name = "convertToNullButton"
			fn OnConvertToNullClicked btn ev = (
				undo "Convert To Wheel Node" on
				(
					for obj in (selection as array) do
					(
						trans = obj.transform
						newNullNode = CreateNewNULLNode trans "NewNullNode" selectAndFocus:false
						append obj.parent.children newNullNode
						for i=obj.children.count to 1 by -1 do
						(
							child = obj.children[i]
							
							append newNullNode.children child
						)
						delete obj
					)
				)
			)
			SetClickHandler convertToNullButton OnConvertToNullClicked
		)
		layoutHelper.EndHorizontalGroup()

		local SetupHierarchyLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		SetupHierarchyLabel.text = "Setup Hierarchy on:"
		layoutHelper.BeginHorizontalGroup align:"center" margintop:0 marginbottom:0 marginright:10 marginLeft:10
		(
			local setupHierarchySelectionButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[110,40] margin:[0,0]
			setupHierarchySelectionButton.text = "Selection"
			setupHierarchySelectionButton.name = "setupHierarchySelectionButton"
			fn OnSetupHierarchySelectionClicked btn ev = (
				undo "Setup Hierarchy" on
				(
					SetSelectionToCNTNodes doChildren:false
				)
			)
			SetClickHandler setupHierarchySelectionButton OnSetupHierarchySelectionClicked

			local setupHierarchySelectionWithChildrenButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[110,40] margin:[0,0]
			setupHierarchySelectionWithChildrenButton.text = "Selection\n + Children"
			setupHierarchySelectionWithChildrenButton.name = "setupHierarchySelectionWithChildrenButton"
			fn OnSetupHierarchySelectionWithChildrenClicked btn ev = (
				undo "Setup Hierarchy" on
				(
					SetSelectionToCNTNodes doChildren:true
				)
			)
			SetClickHandler setupHierarchySelectionWithChildrenButton OnSetupHierarchySelectionWithChildrenClicked

			local setupHierarchyEntireSceneButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[110,40] margin:[0,0]
			setupHierarchyEntireSceneButton.text = "Entire Scene"
			setupHierarchyEntireSceneButton.name = "setupHierarchyEntireSceneButton"
			fn OnSetupHierarchyEntireSceneClicked btn ev = (
				undo "Setup Hierarchy" on
				(
					SetAllToCNTNodes()
				)
			)
			SetClickHandler setupHierarchyEntireSceneButton OnSetupHierarchyEntireSceneClicked
		)
		layoutHelper.EndHorizontalGroup()
		
	)

	layoutHelper.EndVerticalGroup()

)
