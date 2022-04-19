struct DN_ControlLayout
(
	Width,
	Height,
	Left,
	Right,
	Top,
	Bottom,
	Dock,
	AnchorStyles,
	Padding,
	MultiLine,
	SizeMode,
	Disabled,
	BackColor,
	ForeColor
)
fn SetControlLayout ctrl Layout =
(
	
	if Layout.Width != undefined then ctrl.width = Layout.Width
	--else ctrl.width = form.Width-15
	if Layout.Height != undefined then ctrl.height = Layout.Height
	--else ctrl.height = 400
	
	if Layout.AnchorStyles != undefined and Layout.AnchorStyles.count > 0 then
	(
		anchorStyle = -1
		for style in Layout.AnchorStyles do
		(
			actualStyle = case style of 
			(
				"Top":
				(
					ctrl.Anchor.Top
				)
				"Bottom":
				(
					ctrl.Anchor.Bottom
				)
				"Left":
				(
					ctrl.Anchor.Left
				)
				"Right":
				(
					ctrl.Anchor.Right
				)
				"None":
				(
					ctrl.Anchor.None
				)
			)
			if anchorStyle == -1 then anchorStyle = actualStyle
			else anchorStyle = dotnet.combineEnums (anchorStyle) (actualStyle)
		)
		if anchorStyle != -1 then ctrl.Anchor = anchorStyle
	)
	if Layout.Left != undefined then ctrl.left= Layout.Left
	if Layout.Right != undefined then ctrl.right= Layout.Right
	if Layout.Top != undefined then ctrl.top= Layout.Top
	if Layout.Bottom != undefined then ctrl.bottom= Layout.Bottom
	
	if Layout.BackColor != undefined then ctrl.backcolor = Layout.BackColor
	if Layout.ForeColor != undefined then ctrl.forecolor = Layout.ForeColor
)

global controlsWithEvents = #()
fn RemoveEventHandler ctrl eventName func =
(
	local foundcontrols = for item in controlsWithEvents where item[1] == target and item[2] == eventName and item[3] == func collect (findItem controlsWithEvents item)

	for ind in foundcontrols do deleteItem controlsWithEvents ind

	dotNet.removeEventHandler ctrl eventName func
)

fn RemoveAllHandlersOnDispose target ev = (

	global controlsWithEvents
	local foundcontrols = for item in controlsWithEvents where item[1] == target collect (findItem controlsWithEvents item)

	for ind in foundcontrols do deleteItem controlsWithEvents ind

	dotNet.removeAllEventHandlers target
)

fn AddEventHandler ctrl eventName func =
(
	global controlsWithEvents
	dotNet.setLifetimeControl ctrl #dotnet
	dotNet.addEventHandler ctrl eventName func
	if (for item in controlsWithEvents where item[1] == ctrl collect item).count < 1 then (
		dotNet.addEventHandler ctrl "Disposed" RemoveAllHandlersOnDispose
	)
	append controlsWithEvents #(ctrl, eventName, func)

)

fn SetClickHandler ctrl func =
(
	
	AddEventHandler ctrl "Click" func

)

fn SetChangeHandler ctrl func =
(
	AddEventHandler ctrl "Change" func
)