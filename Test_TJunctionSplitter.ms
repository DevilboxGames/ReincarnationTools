--dllpath = GetFilenamePath CarmaSettings.GibbedTools
--maxsScriptHelpersAssembly = dotnet.loadAssembly (dllpath+"MaxScriptTools.dll");
numfaces = getnumfaces $
facesToDetach = #{}
threadNum=0
numThreads = 7
facesPerThread = numFaces / numThreads

fn TJunctionDoWork sender evt = 
(
	thisThreadNum = threadNum
	threadNum += 1
		
	startIndex = thisThreadNum * facesPerThread + 1
	endIndex = startIndex + facesPerThread
	
	if endIndex > numFaces then
		endIndex = numFaces
	else if i == numThreads and endIndex < numFaces then
		endIndex = numFaces
	
	textinfo = (thisThreadNum as string)+": "+(startIndex as string)+" to "+(endIndex as string)+"\n"
	format textinfo
	for i = startIndex to endIndex do
	(
		edges = meshop.GetEdgesUsingFace $ i
		
		--format "\tEdges: %\n" edges
		for edgeNum in edges do
		(
			
			--format "%: \t\tCurrent edge: %\n" thisTheadNum edgeNum
			connectedEdge = meshop.getEdgesReverseEdge $ edgeNum
				--format "%: \t\t\tFirst connected edge: %\n" thisTheadNum connectedEdge
			firstConnection = true
			itterations = 0
			
			while connectedEdge.numberset > 0 and connectedEdge[edgeNum] == false do
			(
				--format "\t\t\tCurrent connected edge: %\n" connectedEdge
				if firstConnection == true then
				(
					firstConnection = false
				)
				else
				(
					--format "%: \t\t\tCurrent connected edge: %\n" thisTheadNum connectedEdge
					facesFound = meshop.getFacesUsingEdge $ connectedEdge
					--format "%: \t\t\tAdding faces to be removed: %\n" thisTheadNum facesFound
					facesToDetach += facesFound
				)
				
				connectedEdge = meshop.getEdgesReverseEdge $ connectedEdge
				
				--format "\t\t\tCurrent connected edge: %\n" connectedEdge
				if connectedEdge[edgeNum] == true  then
				(
					--format "Back to the original edge!\n"
					exit
				)
				itterations += 1
				if itterations > 10 then
				(
					--format "%: Loop going on for fucking ages, breaking!\n" thisTheadNum
					exit
				)
			)
		)
	)
)
fn TJunctionDoWork2 sender evt= 
(
	format "Blah % - % - %\n" sender evt 0
)
fn DoDetachFaces = 
(
	format "Detacing Faces...\n"
	--for face in facesToDetach do
	--(
		--format "%\n" face
	--)
	meshop.detachFaces $ facesToDetach delete:true asMesh:false
)
fn WorkCompleted send evt =
(
	format "Finished a thread!\n"
	threadsStillRunning = false
	for i=1 to threadlist.count do
	(
		threadsStillRunning = threadsStillRunning or threadList[i].IsBusy
	)
	if threadsStillRunning == false then
	(
		DoDetachFaces()
	)
)
(
	format "Num faces: %\n" numfaces
	/*for i=1 to numfaces do
	(
		--format "\tCurrent face: %\n" i
		edges = meshop.GetEdgesUsingFace $ i
		
		--format "\tEdges: %\n" edges
		for edgeNum in edges do
		(
			
			--format "\t\tCurrent edge: %\n" edgeNum
			connectedEdge = meshop.getEdgesReverseEdge $ edgeNum
				--format "\t\t\tCurrent connected edge: %\n" connectedEdge
			firstConnection = true
			itterations = 0
			
			while connectedEdge.numberset > 0 and connectedEdge[edgeNum] == false do
			(
				--format "\t\t\tCurrent connected edge: %\n" connectedEdge
				if firstConnection == true then
				(
					firstConnection = false
				)
				else
				(
					format "\t\t\tCurrent connected edge: %\n" connectedEdge
					facesFound = meshop.getFacesUsingEdge $ connectedEdge
					format "\t\t\tAdding faces to be removed: %\n" facesFound
					facesToDetach += facesFound
				)
				
				connectedEdge = meshop.getEdgesReverseEdge $ connectedEdge
				
				--format "\t\t\tCurrent connected edge: %\n" connectedEdge
				if connectedEdge[edgeNum] == true  then
				(
					--format "Back to the original edge!\n"
					exit
				)
				itterations += 1
				if itterations > 10 then
				(
					format "Loop going on for fucking ages, breaking!\n"
					exit
				)
			)
		)
		
		--if i > 20 then exit
	)
	*/
	global threadList = #()
	
	for i = 1 to numThreads do
	(
		
		thisTheadNum = i-1
		
		startIndex = thisTheadNum * facesPerThread + 1
		endIndex = startIndex + facesPerThread
		
		if endIndex > numFaces then
			endIndex = numFaces
		else if i == numThreads and endIndex < numFaces then
			endIndex = numFaces
		
		bgw = DotNetObject "System.ComponentModel.BackgroundWorker"
		dotnet.AddEventHandler bgw "DoWork" TJunctionDoWork
		dotnet.AddEventHandler bgw "RunWorkerCompleted" WorkCompleted
		bgw.WorkerSupportsCancellation = true
		bgw.RunWorkerAsync()
		append threadList bgw
		
	)
	
	
)