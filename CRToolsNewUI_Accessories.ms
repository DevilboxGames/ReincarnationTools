

fn AddAccessoryToolsUI parentLayoutHelper = (

	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 40]

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(
		local addAccessoryModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
		addAccessoryModifierButton.text = "Add Accessory Modifier"
		addAccessoryModifierButton.name = "addAccessoryModifierButton"
		fn OnAddAccessoryModifierClicked btn ev = (
			undo "Accessory Modifier" on
			(
				if selection.count > 0 then AddAccessoryTXTModifier selection[1]
			)
		)
		SetClickHandler addAccessoryModifierButton OnAddAccessoryModifierClicked

	)
	layoutHelper.EndVerticalGroup()

	local dynamicsLabelLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	dynamicsLabelLabel.text = "Dynamics"
	layoutHelper.SetFont dynamicsLabelLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 160] margin:[10,0]
	panel.name = "DynamicsPanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addDynamicsModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addDynamicsModifierButton.text = "Dynamics Modifier"
			--addDynamicsModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addDynamicsModifierButton.name = "addDynamicsModifierButton"
			
			fn OnAddDynamicsModifierClicked sender arg = (
				undo "Add Dynamics Modifier" on
				(
					if selection.count > 0 then AddAccessoryDynamicsModifier selection[1]
				)
			)
			
			SetClickHandler addDynamicsModifierButton OnAddDynamicsModifierClicked

			local addBreakableModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addBreakableModifierButton.text = "Breakable Modifier"
			--addBreakableModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addBreakableModifierButton.name = "addBreakableModifierButton"
			
			fn OnAddBreakableModifierClicked sender arg = (
				undo "Add Breakable Modifier" on
				(
					if selection.count > 0 then AddAccessoryBreakableModifier selection[1]
				)
			)
			
			SetClickHandler addBreakableModifierButton OnAddBreakableModifierClicked

		)
		layoutHelper.EndHorizontalGroup()

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addWorldJointModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addWorldJointModifierButton.text = "World Joint"
			--addWorldJointModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addWorldJointModifierButton.name = "addWorldJointModifierButton"
			
			fn OnAddWorldJointModifierClicked sender arg = (
				undo "Add World Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryJoint selection[1] jointType:"world_joint"
				)
			)
			
			SetClickHandler addWorldJointModifierButton OnAddWorldJointModifierClicked

			local addChildJointModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addChildJointModifierButton.text = "Child Joint"
			--addChildJointModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addChildJointModifierButton.name = "addChildJointModifierButton"
			
			fn OnAddChildJointModifierClicked sender arg = (
				undo "Add Child Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryJoint selection[1] jointType:"child_joint"
				)
			)
			
			SetClickHandler addChildJointModifierButton OnAddChildJointModifierClicked

		)
		layoutHelper.EndHorizontalGroup()

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addWorldConstraintModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addWorldConstraintModifierButton.text = "World Constraint"
			--addWorldConstraintModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addWorldConstraintModifierButton.name = "addWorldConstraintModifierButton"
			
			fn OnAddWorldConstraintModifierClicked sender arg = (
				undo "Add World Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryJointConstraint selection[1] jointType:"world_joint"
				)
			)
			
			SetClickHandler addWorldConstraintModifierButton OnAddWorldConstraintModifierClicked

			local addChildConstraintModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addChildConstraintModifierButton.text = "Child Constaint"
			--addChildConstraintModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addChildConstraintModifierButton.name = "addChildConstraintModifierButton"
			
			fn OnAddChildConstraintModifierClicked sender arg = (
				undo "Add Child Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryJointConstraint selection[1] jointType:"child_joint"
				)
			)
			
			SetClickHandler addChildConstraintModifierButton OnAddChildConstraintModifierClicked

		)
		layoutHelper.EndHorizontalGroup()

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addWorldWeaknessModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addWorldWeaknessModifierButton.text = "World Weakness"
			--addWorldWeaknessModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addWorldWeaknessModifierButton.name = "addWorldWeaknessModifierButton"
			
			fn OnAddWorldWeaknessModifierClicked sender arg = (
				undo "Add World Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryJointWeakness selection[1] jointType:"world_joint"
				)
			)
			
			SetClickHandler addWorldWeaknessModifierButton OnAddWorldWeaknessModifierClicked

			local addChildWeaknessModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addChildWeaknessModifierButton.text = "Child Weakness"
			--addChildWeaknessModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addChildWeaknessModifierButton.name = "addChildWeaknessModifierButton"
			
			fn OnAddChildWeaknessModifierClicked sender arg = (
				undo "Add Child Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryJointWeakness selection[1] jointType:"child_joint"
				)
			)
			
			SetClickHandler addChildWeaknessModifierButton OnAddChildWeaknessModifierClicked

		)
		layoutHelper.EndHorizontalGroup()

		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addBreakableModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addBreakableModifierButton.text = "Make Breakable"
			--addBreakableModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addBreakableModifierButton.name = "addBreakableModifierButton"
			
			fn OnAddBreakableModifierClicked sender arg = (
				undo "Add World Joint Modifier" on
				(
					if selection.count > 0 then AddAccessoryBreakableModifier selection[1] jointType:"world_joint"
				)
			)
			
			SetClickHandler addBreakableModifierButton OnAddBreakableModifierClicked

		)
		layoutHelper.EndHorizontalGroup()
	)
	layoutHelper.EndVerticalGroup()

	local shapeDataLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	shapeDataLabel.text = "Shapes"
	layoutHelper.SetFont shapeDataLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 200] margin:[10,0]
	panel.name = "AppDataPanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addShapeModifier = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addShapeModifier.text = "Set as Shape"
			--addShapeModifier.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addShapeModifier.name = "addShapeModifier"
			
			fn OnAddShapeModifierClicked sender arg = (
				undo "Add Shape Modifier" on
				(
					if selection.count > 0 then (
						local shapeModifier = AddAccessoryShapeModifier selection[1]
						shapeModifier.CollisionType = case (classof selection[1]) of (
							"Sphere": "Sphere"
							"Box": (
								if selection[1].rotation == quat 1 then "AlignedCuboid"
								else "Cuboid"
							)
							"Capsule": "TicTac"
							default: "Polyhedron"
						)
						 
					)
				)
			)
			
			SetClickHandler addShapeModifier OnAddShapeModifierClicked

			local createSphereShapeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			createSphereShapeButton.text = "Create Sphere"
			--createSphereShapeButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			createSphereShapeButton.name = "createSphereShapeButton"
			
			fn OnCreateSphereShapeClickedClicked sender arg = (
				undo "Create Sphere Shape" on
				(
					local sphereShape = Sphere()
					local shapeModifier = AddAccessoryShapeModifier sphereShape
					shapeModifier.CollisionType = "Sphere"
					
					if selection.count > 0 then (
						sphereShape.pos = selection[1].center
						local extents = selection[1].max - selection[1].min

						sphereShape.radius = (distance selection[1].max selection[1].min) * 0.5
					)
				)
			)
			
			SetClickHandler createSphereShapeButton OnCreateSphereShapeClickedClicked

		)
		layoutHelper.EndHorizontalGroup()
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local createBoxShapeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			createBoxShapeButton.text = "Create Box"
			--createBoxShapeButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			createBoxShapeButton.name = "createBoxShapeButton"
			
			fn OnCreateBoxShapeClickedClicked sender arg = (
				undo "Create Box Shape" on
				(
					local BoxShape = Box()
					local shapeModifier = AddAccessoryShapeModifier BoxShape
					shapeModifier.CollisionType = "Cuboid"
					
					if selection.count > 0 then (
						local extents = selection[1].max - selection[1].min
						BoxShape.pos = selection[1].center - [0,0,extents.z * 0.5]
						BoxShape.length = extents.y
						BoxShape.width = extents.x
						BoxShape.height = extents.z
					)
				)
			)
			
			SetClickHandler createBoxShapeButton OnCreateBoxShapeClickedClicked

			local createCapsuleShapeButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			createCapsuleShapeButton.text = "Create Capsule"
			--createCapsuleShapeButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			createCapsuleShapeButton.name = "createCapsuleShapeButton"
			
			fn OnCreateCapsuleShapeClickedClicked sender arg = (
				undo "Create Capsule Shape" on
				(
					local CapsuleShape = Capsule()
					local shapeModifier = AddAccessoryShapeModifier CapsuleShape
					shapeModifier.CollisionType = "Cuboid"
					
					if selection.count > 0 then (
						CapsuleShape.pos = selection[1].center
						local extents = selection[1].max - selection[1].min
						CapsuleShape.height = amax extents.x extents.y extents.z
						if(CapsuleShape.height == extents.x) then (
							CapsuleShape.radius = (amax extents.y extents.z) * 0.5
							CapsuleShape.height -= CapsuleShape.radius * 2
							CapsuleShape.rotation = (eulerToQuat (eulerAngles 0 90 0)) * selection[1].rotation
							CapsuleShape.pos  += [extents.x * 0.5 + CapsuleShape.radius *0.5, 0, CapsuleShape.radius * 0.5]
						)
						else if(CapsuleShape.height == extents.y) then (
							CapsuleShape.radius = (amax extents.x extents.z) * 0.5
							CapsuleShape.height -= CapsuleShape.radius * 2
							CapsuleShape.rotation = (eulerToQuat (eulerAngles 90 0 0)) * selection[1].rotation
							CapsuleShape.pos  -= [0,extents.y * 0.5 + CapsuleShape.radius * 0.5, -CapsuleShape.radius * 0.5]
						)
						else (
							CapsuleShape.radius = (amax extents.y extents.x) * 0.5

							CapsuleShape.height -= CapsuleShape.radius * 2
							CapsuleShape.pos  -= [0,0,extents.z * 0.5 ]
							
						)
					)
				)
			)
			
			SetClickHandler createCapsuleShapeButton OnCreateCapsuleShapeClickedClicked

		)
		layoutHelper.EndHorizontalGroup()

	)

	layoutHelper.EndVerticalGroup()


	local AccessoryDataLabel = parentLayoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
	AccessoryDataLabel.text = "Accessory Data Types"
	layoutHelper.SetFont AccessoryDataLabel "Segoe UI" 12 bold:true underline:false
	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 200] margin:[10,0]
	panel.name = "AppDataPanel"
	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:0 OutterMarginBottom:0 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(

		
		layoutHelper.BeginHorizontalGroup align:"center" marginTop:3 marginRight:15 marginBottom:3 marginLeft:15
		(

			local addDynamicsModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addDynamicsModifierButton.text = "Dynamics Modifier"
			--addDynamicsModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addDynamicsModifierButton.name = "addDynamicsModifierButton"
			
			fn OnAddDynamicsModifierClicked sender arg = (
				undo "Add Dynamics Modifier" on
				(
					if selection.count > 0 then AddAccessoryDynamicsModifier selection[1]
				)
			)
			
			SetClickHandler addDynamicsModifierButton OnAddDynamicsModifierClicked

			local addBreakableModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			addBreakableModifierButton.text = "Breakable Modifier"
			--addBreakableModifierButton.tooltip = "Adjusts the wheel's radius based on its radius so the bottom of the wheel is on the origin plane"
			addBreakableModifierButton.name = "addBreakableModifierButton"
			
			fn OnAddBreakableModifierClicked sender arg = (
				undo "Add Breakable Modifier" on
				(
					if selection.count > 0 then AddAccessoryBreakableModifier selection[1]
				)
			)
			
			SetClickHandler addBreakableModifierButton OnAddBreakableModifierClicked

		)
		layoutHelper.EndHorizontalGroup()

	)

	layoutHelper.EndVerticalGroup()
)