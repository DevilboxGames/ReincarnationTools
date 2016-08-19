for obj in objects do 
(
	if classof obj == editable_poly then
	(
		vertList = #{1 .. (polyop.getnumverts obj)}
		polyop.breakverts obj vertList
		obj.weldThreshold = 0.001
		polyop.weldvertsbythreshold obj #{1 .. (polyop.getnumverts obj)}
	)
	else if classof obj == editable_mesh then
	(
		vertList = #{1..(meshop.getnumverts obj)}
		meshop.breakVerts  obj vertList
		meshop.weldvertsbythreshold obj #{1..(meshop.getnumverts obj)} 0.001
	)
)