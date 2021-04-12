fn InvLerp a b v = (
	va = v - a
	ba = b - a
	t = va / ba
	t
)

fn Lerp a b t = (
	it = 1.0 - t
	v = it * a + b * t
	v
)

fn GetCamPosForBounds size = (
	t = InvLerp 6.57049 11.0073 size
	Lerp [6.19895,-7.84599,4.3273] [10.0652,-12.4536,6.51653] t
)
fn SetInkMat  = (
	for obj in objects where (classof obj) == editable_mesh do (
		 if classof obj.mat == multimaterial then (
			for i =1 to obj.material.material.count do (
				diffusebmp = obj.material.material[i].diffusemap
				obj.material.material[i] = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_map_on:true paint_map:diffusebmp paint_on:true color1:(color 0 0 0)
				obj.material.material[i].paint_map = diffusebmp
			)
		)
		else if classof obj.mat == standardmaterial then (
			diffusebmp = obj.material.diffusemap
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_map_on:true paint_map:diffusebmp paint_on:true color1:(color 0 0 0)
			obj.material.paint_map = diffusebmp
		)
	)
)
fn SetAmMat  = (
	for obj in objects where (classof obj) == editable_mesh do (
		 if classof obj.mat == multimaterial then (
			for i =1 to obj.material.material.count do (
				diffusebmp = obj.material.material[i].diffusemap
				obj.material.material[i].selfillumination = 100.0
			)
		)
		else if classof obj.mat == standardmaterial then (
			diffusebmp = obj.material.diffusemap
			obj.material.selfillumination = 100.0
		)
	)
)
fn mockcamlit = (
		select $carbody

	for obj in selection do (selectmore obj.children )
	carSize  = distance $.min $.max

	
	t = InvLerp 6.57049 11.0073 carSize
	
	cam = Freecamera()
	cam.rotation = (quat 0.538985 0.196175 0.280167 0.769751)
	cam.pos = Lerp [6.19895,-7.84599,4.3273] [10.0652,-12.4536,6.51653] t --[6.19895,-7.84599,4.3273]
	lit = Directionallight pos:[0,0,0] rotation:(EulerAngles 25 5 0) castshadows:true raytracedShadows:true
	lit.shadowGenerator = Adv__Ray_Traced()
	lit.pos = [-10,50,50]
	lit.shadow_density = 0.25
	lit2 = Omnilight pos:[3.2,-5,5] multiplier:0.25
	ground = plane width:1000 length:1000 material:(MatteShadow())

)