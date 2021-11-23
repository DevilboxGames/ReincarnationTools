fn ExtractPak dirFile  = (
	local pakClass = dotnetclass "ToxicRagers.TDR2000.Formats.PAK"
	local pakFile = pakClass.Load dirFile
	local outputDir = getfilenamepath dirFile
	
	for i = 0 to pakFile.Contents.Count - 1 do (
		local pakContent = pakFile.Contents.Item[i]
		pakFile.Extract pakContent outputDir
	)
	
)

fn getFilesRecursive root pattern =
(
dir_array = GetDirectories (root+"/*")
for d in dir_array do
  join dir_array (GetDirectories (d+"/*"))
my_files = #()
for f in dir_array do
  join my_files (getFiles (f + pattern))
my_files
)

fn ExtractAllPaks AssetDir = (
	
	dirFiles = getFilesRecursive AssetDir "*.dir"
	for dirFile in dirFiles do (
		if (getFiles ((getFileNamePath dirFile)+(getFilenameFile dirFile)+".pak")).count > 0 then (
			ExtractPak dirFile
		)
	)
)