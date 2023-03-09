

fn AddLevelToolsUI parentLayoutHelper = (

	local panel = parentLayoutHelper.AddControl "System.Windows.Forms.Panel" size:[380, 150]

	parentLayoutHelper.SetBorderStyle panel "FixedSingle"
	local layoutHelper = DotNetFormHelper ParentControl:panel OutterMarginTop:5 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginTop:5
	layoutHelper.BeginVerticalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
	(
		layoutHelper.BeginHorizontalGroup align:"center"  marginTop:3 marginRight:3 marginBottom:3 marginLeft:3
		(
			local pathsToolButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			pathsToolButton.text = "Paths Tool"
			pathsToolButton.name = "pathsToolButton"
			fn OnPathsToolButtonPressed btn ev = (
				OpenAIPathsFloater()
			)
			SetClickHandler pathsToolButton OnPathsToolButtonPressed

			local accessoeiesToolButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[150,20]
			accessoeiesToolButton.text = "Accessry Tool"
			accessoeiesToolButton.name = "accessoeiesToolButton"
			fn OnAccessoryButtonPressed btn ev = (
				OpenAccessoryPlacementFloater()
			)
			SetClickHandler accessoeiesToolButton OnAccessoryButtonPressed
		)
		layoutHelper.EndHorizontalGroup()
	)
	layoutHelper.EndVerticalGroup()
)