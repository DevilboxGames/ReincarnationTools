fn FindAndExtractTexture textureName = (
	
		global CarmaSettings 
		currentScriptFileName = getThisScriptFilename()
		currentScriptFolder = getFilenamePath currentScriptFileName
		outputPath = CarmaSettings.TexturePath
	
		local vtUtils = dotNetObject "ToxicRagers.CarmageddonReincarnation.VirtualTextures.vtUtils" CarmaSettings.GamePath
	
		vtUtils.ExtractTexture textureName outputPath
		--vtUtils.FindTexture texturename
)

fn LoadVT vtPath = (
	local vtUtils = dotNetObject "ToxicRagers.CarmageddonReincarnation.VirtualTextures.vtUtils" CarmaSettings.GamePath
	
	vtUtils.LoadVT(vtPath);
)