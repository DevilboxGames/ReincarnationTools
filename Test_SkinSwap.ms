fn TestSkinSwap skinIndex materialFolder revert:false = (

	local cfgMod = GetVehilceCFGModifier selection[1]
	local carRoot = selection[1]

	local oldMats = #()
	local skinName = cfgMod.PaintJobNames[skinIndex]
	local matReplacements = filterstring cfgMod.MatReplacements[skinIndex] ";"
	if revert == false then (
		for matReplacement in matReplacements do (
			local matPair = filterstring matReplacement ":"
			append oldMats scenematerials[matPair[1]]
			local newMat = (GetMaterialFromMT2 materialFolder matPair[2] importTextures:true)
			format "replacing % with %\n" scenematerials[matPair[1]].name newMat.name
			for mat in scenematerials where (classof mat) == Multimaterial do (
				for i = 1 to mat.material.count do (
					if (toLower mat.material[i].name) == (tolower matPair[1]) then (
						mat.material[i] = newMat
					)
				)
			)
			for obj in objects where obj.material != undefined and (tolower obj.material.name) == (tolower matPair[1]) do (
				obj.material = newMat
			)
		)
	)
	else (
		for matReplacement in matReplacements do (
			local matPair = filterstring matReplacement ":"
			append oldMats scenematerials[matPair[1]]
			local newMat = (GetMaterialFromMT2 materialFolder matPair[1] importTextures:true)
			for mat in scenematerials where (classof mat) == Multimaterial do (
				for i = 1 to mat.material.count do (
					if (toLower mat.material[i].name) == (tolower matPair[2]) then (
						mat.material[i] = newMat
					)
				)
			)
			for obj in objects where obj.material != undefined and (tolower obj.material.name) == (tolower matPair[2]) do (
				obj.material = newMat
			)
		)
	)

)

fn RunTestSkinSwap skinIndex:2 revert:false = (
	global CarmaSettings

	local materialFolder = CarmaSettings.DataCorePath+ "\\Content\\Vehicles\\Eagle_R\\"

	TestSkinSwap skinIndex materialFolder revert:revert
)