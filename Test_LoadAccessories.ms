fn TestAllAccessories datafolder = (
	local accessoryFolders = getDirectories (datafolder+"Accessories\\*")
	accessoryFolders = accessoryFolders + (getDirectories (datafolder+"Pickups\\*"))
	accessoryFolders = accessoryFolders + (getDirectories (datafolder+"Peds\\props\\*"))
	local levelFolders = getDirectories (datafolder+"Levels\\*")
	for levelFolder in levelFolders do (
		accessoryFolders = accessoryFolders + (getDirectories (levelFolder+"Accessories\\*"))
	)
	
	for accessoryFolder in accessoryFolders do (
		splitPath = (filterstring accessoryFolder "\\")
		accessoryName = splitPath[splitPath.count]
		accessory=AccessoryFileLump()
		accessory.Read (accessoryFolder+"accessory.txt")
		--format "Parsed % with % customblocks and % dyamicsblocks\n" accessoryName accessory.CustomBlocks.count accessory.DynamicsBlocks.count
	)
)