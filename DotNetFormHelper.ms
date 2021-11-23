struct DotNetFormItem (
	Width,
	Height,
	X,
	Y,
	MarginTop = 10,
	MarginRight = 10,
	MarginBottom = 10,
	MarginLeft = 10,
	Type,
	Parent,
	Children = #(),
	Control,
	fn NextControlPosition = (
		local nextPosition = [0,0]
		if Children.Count > 0 then (
			local lastChild = Children[Children.count]
			case Type of (
				"VerticalGroup":(
					nextPosition = [lastChild.X, lastChild.Y + lastChild.Height + lastChild.MarginBottom + MarginTop]
				)
				"HorizontalGroup": (
					nextPosition = [lastChild.X + lastChild.Width + lastChild.MarginRight + MarginLeft, lastChild.Y]
				)
				default: (
					nextPosition = [lastChild.X, lastChild.Y + lastChild.Height + lastChild.MarginBottom + MarginTop]
				)
			)
		)
		else (
			nextPosition = [X + MarginLeft, Y + MarginTop]
		)
		nextPosition
	)
)
struct DotNetFormHelper (
	ParentControl,
	OutterMarginTop = 10,
	OutterMarginRight = 10,
	OutterMarginBottom = 10,
	OutterMarginLeft = 10,
	LastControl,
	LastControlPosition,
	NextControlPosition,
	Items = #(),
	CurrentItem,

	fn AddControl controlType size:[200,10] margin:[10,10] = (
		if Items.Count > 0 then (
			local control = dotNetObject controlType
			local controlPosition = CurrentItem.NextControlPosition()

			control.Size = dotnetobject "System.Drawing.Size" size.x size.y
			control.Location = dotnetobject "System.Drawing.Point" controlPosition.x controlPosition.y

			local controlItem = DotNetFormItem Type:"Control" X:controlPosition.X Y:controlPosition.Y Width:size.X Height:size.Y Control:control
			append CurrentItem.Children controlItem
			ParentControl.Controls.Add control
		)
		else (
			format "========================================\n== ERROR: Tried to create a control with no layout group!\n"
		)
		control
	),

	fn BeginVerticalGroup marginTop:10 marginRight:10 marginBottom:10 marginLeft:10 align:"left" = (
		--append GroupStack "Vertical"
		local vGroup = DotNetFormItem Type:"VerticalGroup"
		vGroup.MarginTop = marginTop
		vGroup.MarginRight = marginRight
		vGroup.MarginBottom = marginBottom
		vGroup.MarginLeft = marginLeft
		if CurrentItem == undefined then (
			vGroup.Width = ParentControl.Size.Width - OutterMarginLeft - OutterMarginRight
			vGroup.Height = 0
			vGroup.X = OutterMarginLeft
			vGroup.Y = OutterMarginTop
			vGroup.Parent = undefined
			append Items vGroup
		)
		else (

			local nextPosition = CurrentItem.NextControlPosition()
			vGroup.Width = CurrentItem.Width - OutterMarginRight - nextPosition.x
			vGroup.Height = 0
			vGroup.X = nextPosition.x
			vGroup.Y = nextPosition.y
			vGroup.Parent = CurrentItem
			append CurrentItem.Children vGroup
		)
		CurrentItem = vGroup
	),

	fn EndVerticalGroup = (
		if CurrentItem.Type == "VerticalGroup" then (
			local height = 0
			local width = 0
			for i = 1 to CurrentItem.Children.Count do (
				width = amax width CurrentItem.Children[i].Width
				height += CurrentItem.Children[i].Height +  CurrentItem.Children[i].MarginTop +  CurrentItem.Children[i].MarginBottom
			)
			CurrentItem.Height = height
			CurrentItem.Width = width
			CurrentItem = CurrentItem.Parent
		)
		else (
			format "========================================\n== ERROR: Tried to end vertical group without matching starting group\n"
		)
	),

	fn BeginHorizontalGroup marginTop:10 marginRight:10 marginBottom:10 marginLeft:10 align:"left" = (
		local hGroup = DotNetFormItem Type:"HorizontalGroup"
		hGroup.MarginTop = marginTop
		hGroup.MarginRight = marginRight
		hGroup.MarginBottom = marginBottom
		hGroup.MarginLeft = marginLeft
		if CurrentItem == undefined then (
			hGroup.Width = ParentControl.Size.Width - OutterMarginLeft - OutterMarginRight
			hGroup.Height = 0
			hGroup.X = OutterMarginLeft
			hGroup.Y = OutterMarginTop
			hGroup.Parent = undefined
			append Items hGroup
		)
		else (

			local nextPosition = CurrentItem.NextControlPosition()
			hGroup.Width = CurrentItem.Width - OutterMarginRight - nextPosition.x
			hGroup.Height = 0
			hGroup.X = nextPosition.x
			hGroup.Y = nextPosition.y
			hGroup.Parent = CurrentItem
			append CurrentItem.Children hGroup
		)

		CurrentItem = hGroup
	),

	fn EndHorizontalGroup = (

		if CurrentItem.Type == "HorizontalGroup" then (
			local height = 0
			local width = 0
			for i = 1 to CurrentItem.Children.Count do (
				height = amax height CurrentItem.Children[i].Height
				width += CurrentItem.Children[i].Width +  CurrentItem.Children[i].MarginLeft +  CurrentItem.Children[i].MarginRight
			)
			CurrentItem.Height = height
			CurrentItem.Width = width
			CurrentItem = CurrentItem.Parent
		)
		else (
			format "========================================\n== ERROR: Tried to end horizontal group without matching starting group\n"
		)
	)


)