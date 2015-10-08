global thread1active = true, thread2active = true
global wtTriMeshes1 = #()
global wtTriMeshes2 = #()
fn WorkThread snd evt = 
(
	print "Starting Work Thread #1\n"
	--result = #()
	for i=1 to 20 do
	(
		--format "Making Mesh % from MainThread\n" i
		local m = trimesh()
		vertices = #([-0.00750644, -0.292164, -0.0157009],[0.00750644, -0.292164, -0.0157009],[-0.0225933, -0.022668, -0.0224066],[0.0225186, -0.0225186, -0.0224066],[-0.00750644, -0.292164, -0.000688014],[0.00750644, -0.292164, -0.000688014],[-0.0225933, -0.022668, 0.0224065],[0.0225186, -0.0225186, 0.0224065],[0.292164, -0.00750644, -0.00750644],[0.292164, 0.00750644, -0.00750644],[0.292164, -0.00750644, 0.00750644],[0.292164, 0.00750644, 0.00750644],[-0.0225933, 0.0225933, -0.0224065],[-0.00750644, 0.00750644, 0.27705],[0.00750644, 0.00750644, 0.27705],[0.022668, 0.0225933, -0.0224065],[0.00750644, -0.00750645, 0.27705],[-0.00750644, -0.00750645, 0.27705],[0.022668, 0.0225933, 0.0224065],[-0.0225933, 0.0225933, 0.0224065])
		setNumVerts m vertices.count
		for i=1 to vertices.count do setVert m i vertices[i]
		faces = #([1.0, 3.0, 4.0],[4.0, 2.0, 1.0],[5.0, 6.0, 8.0],[8.0, 7.0, 5.0],[1.0, 2.0, 6.0],[6.0, 5.0, 1.0],[2.0, 4.0, 8.0],[8.0, 6.0, 2.0],[3.0, 1.0, 5.0],[5.0, 7.0, 3.0],[9.0, 4.0, 16.0],[16.0, 10.0, 9.0],[11.0, 12.0, 19.0],[19.0, 8.0, 11.0],[9.0, 10.0, 12.0],[12.0, 11.0, 9.0],[10.0, 16.0, 19.0],[19.0, 12.0, 10.0],[4.0, 9.0, 11.0],[11.0, 8.0, 4.0],[13.0, 19.0, 16.0],[13.0, 4.0, 3.0],[15.0, 14.0, 18.0],[18.0, 17.0, 15.0],[20.0, 7.0, 18.0],[18.0, 14.0, 20.0],[14.0, 15.0, 19.0],[19.0, 20.0, 14.0],[17.0, 18.0, 7.0],[7.0, 8.0, 17.0],[15.0, 17.0, 8.0],[8.0, 19.0, 15.0],[20.0, 13.0, 7.0],[13.0, 20.0, 19.0],[13.0, 16.0, 4.0],[13.0, 3.0, 7.0])
		setNumFaces m faces.count
		for i=1 to faces.count do setFace m i faces[i]
		
		append wtTriMeshes1 #(m, [i * 2, 0, 0])
	)
	--evt.result = copy result  #nomap
)
fn WorkThread2 snd evt = 
(
	print "Starting Work Thread #2\n"
	--result = #()
	for i=1 to 10 do
	(
		--format "Making Mesh % from SecondaryThread\n" i
		local m = trimesh()
		vertices = #([-0.00750644, -0.292164, -0.0157009],[0.00750644, -0.292164, -0.0157009],[-0.0225933, -0.022668, -0.0224066],[0.0225186, -0.0225186, -0.0224066],[-0.00750644, -0.292164, -0.000688014],[0.00750644, -0.292164, -0.000688014],[-0.0225933, -0.022668, 0.0224065],[0.0225186, -0.0225186, 0.0224065],[0.292164, -0.00750644, -0.00750644],[0.292164, 0.00750644, -0.00750644],[0.292164, -0.00750644, 0.00750644],[0.292164, 0.00750644, 0.00750644],[-0.0225933, 0.0225933, -0.0224065],[-0.00750644, 0.00750644, 0.27705],[0.00750644, 0.00750644, 0.27705],[0.022668, 0.0225933, -0.0224065],[0.00750644, -0.00750645, 0.27705],[-0.00750644, -0.00750645, 0.27705],[0.022668, 0.0225933, 0.0224065],[-0.0225933, 0.0225933, 0.0224065])
		setNumVerts m vertices.count
		for i=1 to vertices.count do setVert m i vertices[i]
		faces = #([1.0, 3.0, 4.0],[4.0, 2.0, 1.0],[5.0, 6.0, 8.0],[8.0, 7.0, 5.0],[1.0, 2.0, 6.0],[6.0, 5.0, 1.0],[2.0, 4.0, 8.0],[8.0, 6.0, 2.0],[3.0, 1.0, 5.0],[5.0, 7.0, 3.0],[9.0, 4.0, 16.0],[16.0, 10.0, 9.0],[11.0, 12.0, 19.0],[19.0, 8.0, 11.0],[9.0, 10.0, 12.0],[12.0, 11.0, 9.0],[10.0, 16.0, 19.0],[19.0, 12.0, 10.0],[4.0, 9.0, 11.0],[11.0, 8.0, 4.0],[13.0, 19.0, 16.0],[13.0, 4.0, 3.0],[15.0, 14.0, 18.0],[18.0, 17.0, 15.0],[20.0, 7.0, 18.0],[18.0, 14.0, 20.0],[14.0, 15.0, 19.0],[19.0, 20.0, 14.0],[17.0, 18.0, 7.0],[7.0, 8.0, 17.0],[15.0, 17.0, 8.0],[8.0, 19.0, 15.0],[20.0, 13.0, 7.0],[13.0, 20.0, 19.0],[13.0, 16.0, 4.0],[13.0, 3.0, 7.0])
		setNumFaces m faces.count
		for i=1 to faces.count do setFace m i faces[i]
		
		append wtTriMeshes2 #(m, [i * 2, 4, 0])
	)
	--evt.result = copy result #nomap
)
fn FinishWorkThread snd evt =
(
	showprops evt
	format "Error: %\nCancel: %\nResult: %\n" (evt.Error as string) (evt.Cancelled as string) (evt.Result as string)
	for i=1 to wtTriMeshes1.count do 
	(
		m = mesh mesh:wtTriMeshes1[i][1] pos:wtTriMeshes1[i][2]
	)
	
	messageBox ("Finished Thread #1 With "+(wtTriMeshes1.count as string)+" results")
	thread1active=false
)
fn FinishWorkThread2 snd evt =
(
	for i=1 to wtTriMeshes2.count do m = mesh mesh:wtTriMeshes2[i][1] pos:wtTriMeshes2[i][2]
	
	messageBox ("Finished Thread #2 With "+(wtTriMeshes2.count as string)+" results")
	thread2active = false
)

	for i=1 to 50 do
	(
--	MainThread = dotnetobject "System.ComponentModel.BackGroundWorker"
MainThread = dotnetobject "system.componentmodel.backgroundworker"

	--	MainThread.WorkerReportsProgress = true
	MainThread.WorkerSupportsCancellation = true		
	dotNet.addEventHandler MainThread "DoWork" WorkThread
	dotNet.addEventHandler MainThread "RunWorkerCompleted" FinishWorkThread
	--dotNet.addEventHandler MainThread "ProgressChanged" UpdateThread

--SecondaryThread = dotnetobject "System.ComponentModel.BackGroundWorker"
SecondaryThread =  dotnetobject "system.componentmodel.backgroundworker"

SecondaryThread.WorkerSupportsCancellation = true
	--	SecondaryThread.WorkerReportsProgress = true
	dotNet.addEventHandler SecondaryThread  "DoWork" WorkThread2
	dotNet.addEventHandler SecondaryThread "RunWorkerCompleted" FinishWorkThread2

		if (not MainThread.IsBusy) and (not SecondaryThread.IsBusy) do
		(
		MainThread.RunWorkerAsync()
		SecondaryThread.RunWorkerAsync()
		)
		--sleep 0.25
	)