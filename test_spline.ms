fn testmakespline knotPositions:#() = (
	local tstspline = SplineShape()
	addNewSpline  tstspline
	for pos in knotPositions do (
	addKnot tstspline 1 #corner #line pos
	)
	updateShape tstspline
)