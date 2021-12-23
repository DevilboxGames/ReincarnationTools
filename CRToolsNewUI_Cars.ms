

fn AddCarToolsUI parentLayoutHelper = (

	local carSetupLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,30]
	carSetupLabel.text = "Car Setup"
	parentLayoutHelper.SetFont carSetupLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 250]

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(


		local StructureLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[150,20] margin:[0,0]
		StructureLabel.text = "Structure:"

			local setupCarStructureButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[200,20]
			setupCarStructureButton.text = "Setup Car Structure"
			setupCarStructureButton.name = "setupCarStructureButton"
			SetClickHandler setupCarStructureButton SetupCarStructureButton_Pressed


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
	local wheelsLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,30]
	wheelsLabel.text = "Wheels"
	layoutHelper.SetFont wheelsLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 150]

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
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
			setWheelRadiusByPos.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			setWheelRadiusByPos.name = "setWheelRadiusByPos"
			
			
			SetClickHandler setWheelRadiusByPos SetWheelRadiusToPosButton_Pressed


			local setPosByRadius = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			setPosByRadius.text = "Calc Pos From Radius"
			setPosByRadius.tooltip = "Adjusts the wheel's vertical position based on its radius so the bottom of the wheel is on the origin plane"
			setPosByRadius.name = "setPosByRadius"
			
			
			SetClickHandler setPosByRadius SetWheelPosToRadiusButton_Pressed


		)
		layoutHelper.EndHorizontalGroup()
	)

	layoutHelper.EndVerticalGroup()

)