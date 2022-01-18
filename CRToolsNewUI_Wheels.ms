

fn AddWheelToolsUI parentLayoutHelper = (

	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 150]

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(
		local addWheelModifierButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
		addWheelModifierButton.text = "Add Wheel Modifier"
		addWheelModifierButton.name = "addWheelModifierButton"
		fn OnCreateNullClicked btn ev = (
			undo "Add Wheel Modifier" on
			(
				if selection.count > 0 then GetComplicatedWheel selection[1]
			)
		)
		SetClickHandler addWheelModifierButton OnCreateNullClicked

	)
	layoutHelper.BeginVerticalGroup()
)