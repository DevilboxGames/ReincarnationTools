fn convertAINodeToBeelzebub nodeString = (
		local regex = dotnetObject "System.Text.RegularExpressions.Regex" "(?<x>-?[0-9]+\.[0-9]+),[\s]*(?<y>-?[0-9]+\.[0-9]+),[\s]*(?<z>-?[0-9]+\.[0-9]+)[\s]*\/\/ Node #(?<index>[0-9]+)"
	local matches = regex.matches nodeString
	--format "% Matches: %\n" matches.Count Matches.Item
	local match = matches.Item[0]
	--format "% Groups: %\n" match.Groups.count match.Groups
	local x = (-(matches.Item[0].Groups.Item["x"].Value as float) * 6.9) as string
	local y = ((matches.Item[0].Groups.Item["y"].Value as float) * 6.9) as string
	local z = ((matches.Item[0].Groups.Item["z"].Value as float) * 6.9) as string
	local index = matches.Item[0].Groups.Item["index"].Value
	"[AINODE]\n<INDEX>\n"+index+"\n<TYPE>\n0\n<RADIUS>\n0.000\n<POS>\n"+x+","+y+","+z+"\n\n"
)

fn convertAINodesListToBeelzebub nodesList = (
	local nodesSplitList =filterString nodesList "\r\n"
	local outputString = ""
	
	for nodeString in nodesSplitList do (
		outputString = outputString + (convertAINodeToBeelzebub nodeString)
	)
	
	outputString
	
)

fn convertAILinkToBeelzebub linkString = (
		local regex = dotnetObject "System.Text.RegularExpressions.Regex" "(?<node1>[0-9]+),[\s]*(?<node2>[0-9]+),[\s]*(?<foo1>[0-9]+),[\s]*(?<foo2>[0-9]+),[\s]*(?<bar1>[0-9]+),[\s]*(?<bar2>[0-9]+),[\s]*(?<width>-?[0-9\.]+),[\s]*(?<type>[0-9]+)[\s]*\/\/ Section #(?<index>[0-9]+)"
	local matches = regex.matches linkString
	local match = matches.Item[0]
	local node1 = match.Groups.Item["node1"].Value
	local node2 = match.Groups.Item["node2"].Value
	
	
	local width = ((match.Groups.Item["width"].Value as float) * 6.9) as string
	
	local type =match.Groups.Item["type"].Value
	
	"[AILINK]\n<TYPE>\n"+type+"\n<NODES>\n"+node1+"\n"+node2+"\n<WIDTH>\n"+width+"\n\n"
)
fn convertAILinksListToBeelzebub linksList = (
	local linksSplitList =filterString linksList "\r\n"
	local outputString = ""
	
	for linkString in linksSplitList do (
		outputString = outputString + (convertAILinkToBeelzebub linkString)
	)
	
	outputString
	
)

allFunsizePedRefs = #(1,2,3,4,5,6,7,8,9,10,11,99,51,52,53,54,55,56,57,58,59,60,61,99,20,21,12,13,14,15,16,17,18,26,22,24,25,27,28,30,31,29,33,76)
fn ConvertPedPath pedString snapToGround: true pupsNotPeds:false = (
	--format "Input ped:\n%\n" pedString
	local pedRows = filterString pedString "\r\n"
	local pedRef = (filterString pedRows[1] " \t")[1]
	if (pedRef as integer) < 100 and (findItem allFunsizePedRefs (pedRef as integer)) == 0 then (
	--	pedRef = 1 as string
	)
	if (pedRef as integer) > 99 and pupsNotPeds == true or (pedRef as integer) < 100 and pupsNotPeds ==false then (
		local pedInstructions = ((filterString pedRows[2] " \t")[1] as integer) - 1
		local pedInitialInstruction = (filterString pedRows[3] " \t")[1]
		local pedPathPositions = ""
		local instructionRow = 4
		
		local pathPosRay = ray [0,0,0] [0,0,-1]
		for i = 1 to pedInstructions do (
			instructionRow = instructionRow + 1
			local pathPos = execute ("["+pedRows[instructionRow]+"]")
			pathPos = pathPos * 6.9
			if snapToGround then (
				
				pathPosRay.pos = [-pathPos.x, -pathPos.z, pathPos.y]
				local intersectPoint = intersectRay $ pathPosRay 
				if intersectPoint != undefined then (
					pathPos = [-intersectPoint.pos.x, intersectPoint.pos.z,-intersectPoint.pos.y]
				)
				
			)
			
			pedPathPositions = pedPathPositions + ((-pathPos.x) as string) + ", "+(pathPos.y as string)+","+(pathPos.z as string)+"\n"
			
			
			instructionRow = instructionRow + 1
		)
		
		"[PEDESTRIAN]\n\n<TYPE>\nPED_"+pedRef+"\n\n<PATH>\n"+(pedInstructions as string)+"\n"+pedPathPositions+pedInitialInstruction+"\n\n"
	)
	else (
		""
	)
)

fn ConvertAllPedPaths pedString snapToGround:true pupsNotPeds:false = (
	local stringRows = filterstring pedString "\r\n"
	local currentPedString = ""
	local outputPedString = ""
	for row in stringRows do (
		if (substring row 1 2) == "//" then (
			outputPedString = outputPedString + ConvertPedPath currentPedString snapToGround:snapToGround
			currentPedString = ""
		)
		else if (trimLeft (trimRight row)) != "" then (
			currentPedString = currentPedString + row +"\r\n" 
		)
	)
	
	outputPedString
)