struct  CRSkeletalAnimationFrame
(
	BoneRotations = #(),
	BoneTransforms = #(),
	RootPosition
)

struct CRSkeletalAnimation
(
	FramesPerSecond,
	NumberOfBones,
	BoneNames=#(),
	
	NumberOfFrames,
	Frames=#(),
	
	FileName,
	fn Load FileToLoad:undefined =
	(
		if(FileToLoad != undefined) then FileName = FileToLoad
		
		
		if ((dotnetclass "System.IO.File").exists (FileName)) then
		(
			format "Importing skeletal animation from: %\n" FileName
			--format "Accessory found!\n"
			f = fopen FileName "r"
			
			format "First 4 bytes: % % % %\n" ((readbyte f) as string) ((readbyte f) as string) ((readbyte f) as string) ((readbyte f) as string)
			
			FramesPerSecond = readshort f
			NumberOfFrames = readlong f
			NumberOfBones = readlong f
			format "Number Of Frames: %\nNumber Of Bones: %\n\n" NumberOfFrames NumberOfBones
			for i=1 to NumberOfBones do
			(
				boneName = readstring f
				format "Bone #% - % (length: % remaining: %)\n" i boneName boneName.count (32 - boneName.count)
				append BoneNames boneName
				for x=boneName.count to 30 do readbyte f
			)
			format "\n"
			for i=1 to NumberOfFrames do
			(
				--format "\nReading Frame #%\n" i
				boneFrame = CRSkeletalAnimationFrame()
				px = readfloat f
				py = readfloat f
				pz = readfloat f
				boneFrame.RootPosition = [-px, -pz, py]
				--format "Frame #% - RootPosition = %\n" i boneFrame.RootPosition
				for b=1 to NumberOfBones do
				(
					qx = readfloat f
					qy = readfloat f
					qz = readfloat f
					qw = readfloat f
					parts = #(qx, qy, qz, qw)
					append boneFrame.BoneRotations (quat qy -qx qw qz)-- (quat qy -qx qw qz)--#()
					frm=1
					/*for x=1 to 4 do
						for y=1 to 4 do
							for z=1 to 4 do
								for w=1 to 4 do
								(
									if x == y or x == z or x == w or y == z or y ==w or z == w then 
										continue
									else
									(
										format "Frame % perm: % % % %\n" frm x y z w
										frm +=1
									)
										--append boneFrame.BoneRotations[b] (quat parts[x] -parts[y] parts[z] parts[w])
								)
					*/
					append boneFrame.BoneTransforms ((quat qx qy qz qw) as matrix3)
					--format "\t% (%) - %\n" BoneNames[b] b boneFrame.BoneRotations[b]
				)
				append Frames boneFrame
			)
		)
	),
	fn ApplyFrameToBone boneToTransform Frame useMatrix:false =
	(
		boneNum = 0
		for b=1 to NumberOfBones do
		(
			if(BoneNames[b] == boneToTransform.name) then boneNum = b
		)
		if boneNum != 0 then 
		(
			parent = boneToTransform.parent
			pos = boneToTransform.pos
			--boneToTransform.parent=undefined
			if useMatrix then
			(
				boneToTransform.transform = Frames[Frame].BoneTransforms[boneNum]
			)
			else
			(
			boneToTransform.rotation = Frames[Frame].BoneRotations[boneNum]
			)
			boneToTransform.pos = pos
			--boneToTransform.parent=parent
			for child in boneToTransform.children do
			(
				ApplyFrameToBone child Frame useMatrix:useMatrix
			)
		)
		boneNum
	),
	fn ApplyToCharacter obj=
	(
		--obj.pos = Frames[Frame].RootPosition
		frameRate = FramesPerSecond
		skinMod = obj.Modifiers["Skin"]
		max modify mode
		modPanel.setCurrentObject skinMod
		rootBone = GetRootBoneFromSkin skinMod
		bonesList = GetBonesFromSkin skinMod
		parentBones = #()
		
		
		with animate on
		(
			for t=1 to NumberOfFrames do
			(
				at time t rootBone.pos = Frames[t].RootPosition
				at time t ApplyFrameToBone rootBone t
			)
		)
	),
	fn LoadFromC2 fileToLoad  createSkeleton: false applyAnimation: false=
	(
		
		if(FileToLoad != undefined) then FileName = FileToLoad
		
		createdBones = #()
		boneChildren = #()
		
		if ((dotnetclass "System.IO.File").exists (FileName)) then
		(
			f = fopen FileName "r"
			NumberOfBones = readlong f
			NumberOfFrames = readlong f
			for i = 1 to NumberOfBones do
			(
				boneName = readstring f
				format "Bone #% - % (length: % remaining: %)\n" i boneName boneName.count (32 - boneName.count)
				append BoneNames boneName
				for x=boneName.count to 31 do readbyte f
				
				numChildren = readlong f
				--format "\t Children: %\n" numChildren
				--if (querybox "continue?" beep:false) == false then ( return false)
				childBoneIndices = #()
				for c = 1 to numChildren do 
				(
					childIndex = readlong f
					append childBoneIndices childIndex
					--format "\t\t%: %\n" c childIndex
				)
				append boneChildren childBoneIndices
			)
			for i = 1 to NumberOfFrames do
			(
				
				boneFrame = CRSkeletalAnimationFrame()
				boneFrame.RootPosition = [0,0,0]
				
				for b=1 to NumberOfBones do
				(
					xX = (readfloat f)
					xY = (readfloat f)
					xZ = (readfloat f)
					
					yX = (readfloat f)
					yY = (readfloat f)
					yZ = (readfloat f)
					
					zX = (readfloat f)
					zY = (readfloat f)
					zZ = (readfloat f)
					
					pX = (readfloat f) * 6.9
					pY = (readfloat f) * 6.9
					pZ = (readfloat f) * 6.9
					if b ==1 then boneframe.rootposition = [px,py,pz]
					bonematrix = matrix3 -(normalize [zX, zY, zZ]) (normalize [yX, yY, yZ]) (normalize [xX, xY, xZ]) [pX, pY, pZ]
					append boneFrame.boneRotations (bonematrix as quat)
					append boneFrame.boneTransforms bonematrix
				)
				append Frames boneFrame  
			)
			
			if(createSkeleton) then
			(
				foundBones = for obj in objects where ((finditem boneNames obj.name) > 0) collect obj
				for i= 1 to NumberOfBones do (
					foundbone = undefined
					for j = 1 to foundBones.count do
					(
						if foundbones[j].name == boneNames[i] then
						(
							foundbone = obj
							j = foundBones.count + 1;
						)
					)
					if foundbone == undefined then
					(
						childBone = (Frames[1].boneTransforms[i].row4 - 0.3 * Frames[1].boneTransforms[i].row3)
						targetPos = (Frames[1].boneTransforms[i].row4 - 1.0 * Frames[1].boneTransforms[i].row3)
						for childIndex in boneChildren[i] where substring boneNames[childindex] 1 4 == "Bone" do
						(
							--childindex = boneChildren[i][1]
							childbone = Frames[1].boneTransforms[childindex].row4
							--format "Child Index = %\nChildPos = %\n\n" childindex childbone
						)
						foundbone = bonesys.createbone Frames[1].boneTransforms[i].row4 targetpos Frames[1].boneTransforms[i].row2
						foundbone.length = length (Frames[1].boneTransforms[i].row4 - childBone)
						foundbone.width = 0.3-- foundbone.length * 0.2
						foundbone.height = 0.3-- foundbone.length *  0.2
						foundbone.transform = Frames[1].boneTransforms[i]
						foundbone.name = bonenames[i]
					)
					append CreatedBones foundBone
				)
				for i=1 to createdbones.count do
				(
					for c =1 to boneChildren[i].count do
					(
						CreatedBones[boneChildren[i][c]].parent = CreatedBones[i]
					)
				)
			)
			if(applyAnimation) then
			(
				foundBones = for obj in objects where obj.name == boneNames[1] collect obj
				rootbone = foundbones[1]
				format "Animating from %\n" rootbone.name
				with animate on
				(
					for t=1 to NumberOfFrames do
					(
						at time t rootBone.pos = Frames[t].RootPosition
						at time t ApplyFrameToBone rootBone t useMatrix:true
					)
				)
			)
		)
	),
	fn BuildFromCharacter obj StartFrame:0 EndFrame:100 =
	(
		skinMod = obj.Modifiers["Skin"]
		max modify mode
		modPanel.setCurrentObject skinMod
		rootBone = GetRootBoneFromSkin skinMod
		bonesList = GetBonesFromSkin skinMod
		
		BoneNames = #()
		Frames = #()
		for bn in bonesList do
		(
			append BoneNames bn.Name
		)
		for t=StartFrame to EndFrame do
		(
			at time t 
			(
				boneFrame = CRSkeletalAnimationFrame()
				boneFrame.RootPosition = rootBone.pos
				for bn in bonesList do
				(
					append boneFrame.BoneRotations bn.rotation
				)
				append Frames boneFrame
			)
		)
		
		NumberOfBones = BoneNames.count
		NumberOfFrames = Frames.count
		FramesPerSecond = FrameRate
	),
	fn Save FileName =
	(
		f = fopen FileName "w"
		writebyte f 1
		writebyte f 1
		writebyte f 0
		writebyte f 0
		
		writeshort f FramesPerSecond
		writelong f NumberOfFrames
		writelong f NumberOfBones
		for boneName in boneNames do
		(
			writestring2 f boneName
			for i=boneName.count to 31 do
			(
				writebyte f 0
			)
		)
		for boneFrame in Frames do
		(
			rootPos = ConvertToCRSpace boneFrame.RootPosition
			writefloat f rootPos.x
			writefloat f rootPos.y
			writefloat f rootPos.z
			
			for boneRotation in boneFrame.BoneRotations do
			(
				rot = ConvertQuatToCRSpace boneRotation
				writefloat f rot.x
				writefloat f rot.y
				writefloat f rot.z
				writefloat f rot.w
			)
		)
		fclose f
	)
)

fn TestSkeletalAnimation obj Frame:1=
(
	anim = CRSkeletalAnimation()
	anim.Load FileToLoad:"G:\Steam\SteamApps\common\Carmageddon Max Damage\Data_Core\Content\Peds\animations\m_gen_bike_run.anm"
	if obj != undefined then anim.ApplyToCharacter obj Frame:Frame
)

fn TestSaveSkeletonAnimation obj =
(
	anim = CRSkeletalAnimation()
	anim.BuildFromCharacter $ StartFrame:1 EndFrame:70
	anim.Save "G:\\Steam\\SteamApps\\common\\Carmageddon Max Damage\\Data_Core\\Content\\Peds\\animations\\a_elephant_walk.anm"
)
fn TestC2LoadSkeletalAnimation obj createSkeleton:false applyAnimation:true animName:"ele_walk.bon" =
(
	anim = CRSkeletalAnimation()
	anim.LoadFromC2 ("G:\\Carma2\\data\\PEDS\\MOVES\\"+animName) createSkeleton: createSkeleton applyAnimation:applyAnimation
	--if obj != undefined then anim.ApplyToCharacter obj Frame:Frame
)


fn SetAnimFromMixamoBone boneToTransform boneMap =
	(
	
		parent = boneToTransform.parent
		pos = boneToTransform.pos
		--boneToTransform.parent=undefined
		mixamoboneName = ""
		for bm in boneMap do
		(
			if bm[1] == boneToTransform.name then
			(
				mixamoboneName = bm[2]
				exit
			)
		)
		if mixamoboneName != "" then
		(
			mixamoBone = getNodeByName mixamoboneName
			boneToTransform.rotation = mixamoBone.rotation
			boneToTransform.pos = pos
		)
		--boneToTransform.parent=parent
		for child in boneToTransform.children do
		(
			SetAnimFromMixamoBone child boneMap
		)
	)
fn SetAnimFromMixamoAnim obj startFrame endFrame=
(
		skinMod = obj.Modifiers["Skin"]
		max modify mode
		modPanel.setCurrentObject skinMod
		rootBone = GetRootBoneFromSkin skinMod
		bonesList = GetBonesFromSkin skinMod
	boneNameMap = #(#("hips","mixamorig:Hips"), #("left_leg", "mixamorig:LeftUpLeg"), #("right_leg", "mixamorig:RightUpLeg"), #("left_shin", "mixamorig:LeftLeg"), #("right_shin", "mixamorig:RightLeg"), #("left_foot", "mixamorig:LeftFoot"), #("right_foot", "mixamorig:RightFoot"), #("left_toe", "mixamorig:LeftToeBase"), #("right_toe", "mixamorig:RightToeBase"), #("torso", "mixamorig:Spine"), #("ribs", "mixamorig:Spine2"), #("neck", "mixamorig:Neck"), #("left_collar", "mixamorig:LeftShoulder"), #("right_collar", "mixamorig:RightShoulder"), #("left_arm", "mixamorig:LeftArm"), #("right_arm", "mixamorig:RightArm"), #("left_foreame", "mixamorig:LeftForeArm"), #("right_foreame", "mixamorig:RightForeArm"), #("left_hand", "mixamorig:LeftHand"), #("right_hand", "mixamorig:RightHand"), #("left_fingers", "mixamorig:LeftHandIndex1"), #("right_fingers", "mixamorig:RightHandIndex1"), #("left_thumb", "mixamorig:LeftHandThumb1"), #("right_thumb", "mixamorig:RightHandThumb1"), #("neck", "mixamorig:Neck"), #("head", "mixamorig:Head") )
	with animate on
	(
		for t=startFrame to endFrame do
		(
			at time t
			(
				mixamoRootBone = getNodeByName "mixamorig:Hips"
				rootbone.pos = mixamoRootBone.pos
				--SetAnimFromMixamoBone rootbone bonenamemap
			)
		)
	)
)