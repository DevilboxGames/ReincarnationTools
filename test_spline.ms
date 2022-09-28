fn testmakespline knotPositions:#() = (
	local tstspline = SplineShape()
	addNewSpline  tstspline
	for pos in knotPositions do (
	addKnot tstspline 1 #corner #line pos
	)
	updateShape tstspline
)

fn testGroundSpline tstspline = (

	local knitCount = numKnots tstspline
	for i = 1 to knitCount do (
		local knotPos = getKnotPoint tstspline 1 i

		if knotPos.z > 4830 then (
			local tmpRay = ray knotPos [0, 0, -1]
			local rayhit =  (intersectrayscene tmpray)
			local hitobj = rayhit[1]
			local hitpos = hitobj[2].pos
			setknotpoint tstspline 1 i hitpos
		)
	)

)