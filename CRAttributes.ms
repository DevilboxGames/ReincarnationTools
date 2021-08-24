
if printArrayInFull== undefined then
(
	filein "CRHelpsFunctions.ms"
)
fn IsObjectACNT obj =
(
	 (obj.modifiers["CNT Hierarchy"] != undefined)
)
fn IsObjectANullCNT obj =
(
	 (obj.modifiers["CNT Hierarchy"] != undefined and obj.modifiers["CNT Hierarchy"].NodeTypeID == 2)
)


fn ReplaceNullsWithDummy = (
	
		for i = objects.count to 1 by -1  do (
			obj = objects[i]
			if (IsObjectANullCNT obj) then (
				newdummy = Dummy name:obj.name transform: obj.transform
				if obj.parent != undefined then newdummy.parent = obj.parent
				if CarmaSettings.SetupForUE4 then
					newdummy.boxsize = [50,50,50]
				else
					newdummy.boxsize = [0.5,0.5,0.5]
				for child in obj.children do (
					child.parent = newdummy
				)
				delete obj
			)
		)
	
)


fn IsObjectAStructurePart obj =
(
	 (obj.modifiers["Car Structure Part"] != undefined)
)
fn IsObjectAStructureCharacteristic obj =
(
	 (obj.modifiers["Car Characteristics"] != undefined)
)
fn IsObjectAWheel obj =
(
	result = false
	if (obj.modifiers["Car Structure Part"] != undefined) then
	(
		if (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_LEFT_WHEEL") > 0 or  (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_RIGHT_WHEEL") > 0 or  (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "REAR_LEFT_WHEEL") > 0 or  (finditem obj.modifiers["Car Structure Part"].PhysicsProperties "REAR_RIGHT_WHEEL") > 0 then
		(
			result = true
		)
		
	)
	result
)

fn CustAttsTests =
(
	obj = selection[1]
	
	attrib = isProperty obj "CNTCustAttribute"
	
	format "Object customer attribute: %\n" attrib
)

fn target_helper_filter obj = ( IsObjectACNT obj == true or (classof obj) == Point)
	
fn target_cnt_filter obj = (IsObjectACNT obj == true )
	
fn pickJointFilter obj = (
	classof obj == CarmaHelper_JointHelper
)

MTLSaveFlags = #("USE_LUMP_COLOUR",	--States to use the colour value in the lump as the materials diffuse.
"FORCE_ALPHA_BLEND",	--This forces the material to be rendered as an alpha mesh. Even if alpha is 1.0f
"USE_MATERIAL_COLOUR",	--Modulate the colour value in the lump against the materials diffuse.
"GLOW",	
"HARDWARE_SPECULAR",	-- If true and the hardware can do vertex specular then its done. No fallback is given.
"DOES_NOT_RECIEVE_SHADOWS",	-- If true then it can't be shadowed.
"LIGHT_FLARE",	-- Makes the polys rendered with this material face the camera and freek with there material.
"DOES_NOT_CAST_SHADOWS",	-- If true then the material will be ignored when we are doing a shadow map pass
"LIGHT_PER_PIXEL",	-- If true then the material will use per pixel lighting other wise it will be lit per vertex
"POST_SORT",	
"LIT",	--TRUE if it's lit, or false if not.
"USE_VERTEX_COLOUR",	--If true take the diffuse form the vertices and not the material.
"GRASS_ANIMATION",	
"TREE_ANIMATION",	
"FREE14",	
"NOT_LIT_OBSOLETE",	-- Still here for old file versions.TRUE=Dont light this material, FALSE=light as normal
"NO_SORT_ALPHA",	-- TRUE=Dont sort if alpha component, FALSE=Sort if contains alpha
"FREE17",	
"DOUBLE_SIDED",	-- TRUE=Don't perform backface culling on this face
"UNPICKABLE",	-- TRUE=Cannot be picked,FALSE=Can be
"PRELIT_OBSOLETE",	-- Still here for old file versions.TRUE=use the pre-lighting values in the vertices.
"FREE21",	
"FREE22",	
"IGNORE",	
"FREE24",	
"MIPMAPPED",	
"FREE26",	
"ALPHA_FOGGED",	-- Fades out in a similar fasion as fog is applied to objects
"FOGGED",	-- TRUE=Accepts any fogging in the viewport
"FILTERED",	-- TRUE=Smooth filtering, FALSE=Nearest pixel
"FREE30",	
"FREE31"	)

MTLUVMappingModes =#("INVALID",
"WRAP",
"MIRROR",
"CLAMP",
"BORDER")

MTLBlendModes = #("NORMAL",
"ADDITIVE",
"MODULATE",
"SUBTRACTIVE",
"SHADOWMAP",
"SPECULARMAP",
"MODULATEX2",
"VERTEXALPHA",
"ENVMAPMASK",
"NONE")

MTLLayerFlags = #("NO_MIPMAP",
	"FLIP_BOOK_ANIM",
	"UV_SCROLL",
	"USE_VERTEX_ALPHA",
	"FREE4",
	"FREE5",
	"FREE6",
	"FREE7")

MTLLayerEffects = #("NORMAL",			--// OBSOLETE.Standard chrome map
	"SHINY_OBSOLETE",			--// OBSOLETE.Specular reflection map
	"BUMPMAP",			--// Bump-map and/or per pixel lighting.
	"ENVMAP_OBSOLETE",			--// OBSOLETE.Copies the model x/z to u v then applies if set the texture transform jobby.
	"SPHERICAL_OBSOLETE",			--// OBSOLETE.Apply spherical mapping (useful for fake dynamic envmaps)
	"ALTERNATE_OBSOLETE",			--// OBSOLETE.(This is now obsolet, has to stay for legacy.)Same as NORMAL, but use the secondary u/v set for rendering
	"DECAL",			--// Render using D3DTOP_MODULATEINVALPHA_ADDCOLOR for decals.
	"FREE8",			--// OBSOLETE. Causes an untexture lighting poly to be drawn in a subsequant lighting pass/stage.
	"THRESHOLD",			--// Generates UV's by puting the verts xy screen pos in to the uv's and then apply a texture transform matrix. The matrix is by default a x90 degree rot or the material matrix.
	"REFLECTION_VECTOR"			--// Generates UV's by grabbing the reflection vectors x and z cords and doing a texture look up with them
	)

MTLLayerType = #("NOT_USED",			-- Lit untextured polys.
	"SOLID_COLOUR",			-- Lit untextured polys.
	"SOLID_TEX",			-- OBSOLETE. Was used of non-lit textured polys, now material passed with TFACTOR, use 'BZ_TEXTURE_LAYER_SOLID_TEX_COLOUR' insted.
	"SOLID_TEX_COLOUR",			-- Lit textured polys.
	"TRANSPARENT_TEX",			-- Lit transparent texture polys.
	"TRANSLUCENT_COLOUR",			-- Textured alpha poly with alpha controled by alpha value in layer.
	"TRANSLUCENT_TEX",			-- Textured alpha poly with alpha controled by alpha channel in texture.
	"TRANSLUCENT_TEX_COLOUR",			-- Textured alpha poly with alpha controled by alpha value in layer and by alpha channel in texture.
	"TRANSLUCENT_COLOUR_SOLID_TEX"			-- Textured alpha poly with alpha controled by alpha value in layer.
)

MTLSubstances = #("DEFAULT",
"SOFT_WOOD",
"PAINTED_SOFT_WOOD",
"HARD_WOOD",
"CARPETED_FLOOR",
"PLANT",
"FLESH",
"RUBBER",
"TEXTILE_LOOSE",
"TEXTILE_TAUT",
"CARBON_FIBRE",
"PLASTIC",
"GLASS",
"BRICKS",
"SMOOTH_CONCRETE",
"ROUGH_CONCRETE",
"STONE",
"WATER",
"OIL",
"GREASE",
"STAIRS",
"STICKY",
"ASTROTURF",
"LONG_GRASS",
"SOFT_MUD",
"SOFT_TARMAC",
"GOLD",
"STEEL",
"FIBRE_GLASS",
"PERSPEX",
"ALUMINIUM",
"GOOP",
"ROAD_TARMAC",
"RACE_TARMAC",
"SAND",
"ROCK",
"DIRT_TRACK",
"MUD",
"SHORT_GRASS",
"GRAVEL_TRAP",
"ICE")
format "Defining MTL CA - struct is %\n" mtlfile
--if mtlmat_CA == undefined do
fn testeventhandler sender ev = (
	$.name = "pressed the buttons"
	format "Event handler triggered for %\n" sender.name
)

	MtlMat_CA = attributes mtlmat_data
	attribID:#(0x371d0fa1, 0x1de32116)
	(
		parameters mtlmat_data rollout:mtlmat_props
		(
			mat_substance type:#integer default:0 ui:mat_ui_substance
			mat_flags type:#booltab tabsize:32 ui:(mat_USE_LUMP_COLOUR, mat_FORCE_ALPHA_BLEND, mat_USE_MATERIAL_COLOUR, mat_GLOW, mat_HARDWARE_SPECULAR, mat_DOES_NOT_RECIEVE_SHADOWS, mat_LIGHT_FLARE, mat_DOES_NOT_CAST_SHADOWS, mat_LIGHT_PER_PIXEL, mat_POST_SORT, mat_LIT, mat_USE_VERTEX_COLOUR, mat_GRASS_ANIMATION, mat_TREE_ANIMATION, mat_FREE14, mat_NOT_LIT_OBSOLETE, mat_NO_SORT_ALPHA, mat_FREE17, mat_DOUBLE_SIDED, mat_UNPICKABLE, mat_PRELIT_OBSOLETE, mat_FREE21, mat_FREE22, mat_IGNORE, mat_FREE24, mat_MIPMAPPED, mat_FREE26, mat_ALPHA_FOGGED, mat_FOGGED, mat_FILTERED, mat_FREE30, mat_FREE3) autodisplay:true
			mat_PS2MipDistance type:#float default:1 ui:mat_ui_PS2MipDistance
			mat_PS2MipValue type:#integer default:1 ui:mat_ui_PS2MipValue
			mat_FlareSpec type:#integer default:1 ui:mat_ui_FlareSpec
			mat_red type:#float default:1 ui:mat_ui_red
			mat_green type:#float default:1 ui:mat_ui_green
			mat_blue type:#float default:1 ui:mat_ui_blue
			
			mat_emissive_red type:#float default:0 ui:mat_ui_emissive_red
			mat_emissive_green type:#float default:0 ui:mat_ui_emissive_green
			mat_emissive_blue type:#float default:0 ui:mat_ui_emissive_blue
			
			mat_specular_red type:#float default:1 ui:mat_ui_specular_red
			mat_specular_green type:#float default:1 ui:mat_ui_specular_green
			mat_specular_blue type:#float default:1 ui:mat_ui_specular_blue
			mat_specular_power type:#float default:20 ui:mat_ui_specular_power
			layer_name type:#stringtab tabSizeVariable:true
			layer_blend_mode type:#inttab tabSizeVariable:true
	       	layer_alpha_opacity type:#floatTab tabsizevariable:true
			layer_specialfx type:#intTab tabsizevariable:true
			layer_flipbook_fps type:#floatTab tabsizevariable:true
			layer_scrollspeed_u type:#floatTab tabsizevariable:true
			layer_scrollspeed_v type:#floatTab tabsizevariable:true
			layer_mappingmode_u type:#intTab tabsizevariable:true
			layer_mappingmode_v type:#intTab tabsizevariable:true
			layer_uv_slot type:#intTab tabsizevariable:true
			layer_numframes_u type:#intTab tabsizevariable:true
			layer_numframes_v type:#intTab tabsizevariable:true
			layer_layerflags type:#intTab tabsizevariable:true

		)
		rollout mtlmat_props "Carmageddon material properties"
		(
			
			local selectedLayer, layerProperties,layerSaveButton
			group "Substance" 
			(
				dropdownlist mat_ui_substance "Substance Type" items:MTLSubstances selection:mat_substance
			)
			group "Flags"
			(
				checkbox mat_USE_LUMP_COLOUR "USE_LUMP_COLOUR" checked:false across:2 align:#left
				checkbox mat_FORCE_ALPHA_BLEND "FORCE_ALPHA_BLEND" checked:false
				checkbox mat_USE_MATERIAL_COLOUR "USE_MATERIAL_COLOUR" checked:false across:2
				checkbox mat_GLOW "GLOW" checked:false
				checkbox mat_HARDWARE_SPECULAR "HARDWARE_SPECULAR" checked:false across:2
				checkbox mat_DOES_NOT_RECIEVE_SHADOWS "DOES_NOT_RECIEVE_SHADOWS" checked:false
				checkbox mat_LIGHT_FLARE "LIGHT_FLARE" checked:false across:2
				checkbox mat_DOES_NOT_CAST_SHADOWS "DOES_NOT_CAST_SHADOWS" checked:false
				checkbox mat_LIGHT_PER_PIXEL "LIGHT_PER_PIXEL" checked:false across:2
				checkbox mat_POST_SORT "POST_SORT" checked:false
				checkbox mat_LIT "LIT" checked:false across:2
				checkbox mat_USE_VERTEX_COLOUR "USE_VERTEX_COLOUR" checked:false
				checkbox mat_GRASS_ANIMATION "GRASS_ANIMATION" checked:false across:2
				checkbox mat_TREE_ANIMATION "TREE_ANIMATION" checked:false
				checkbox mat_FREE14 "FREE14" checked:false across:2
				checkbox mat_NOT_LIT_OBSOLETE "NOT_LIT_OBSOLETE" checked:false
				checkbox mat_NO_SORT_ALPHA "NO_SORT_ALPHA" checked:false across:2
				checkbox mat_FREE17 "FREE17" checked:false
				checkbox mat_DOUBLE_SIDED "DOUBLE_SIDED" checked:false across:2
				checkbox mat_UNPICKABLE "UNPICKABLE" checked:false
				checkbox mat_PRELIT_OBSOLETE "PRELIT_OBSOLETE" checked:false across:2
				checkbox mat_FREE21 "FREE21" checked:false
				checkbox mat_FREE22 "FREE22" checked:false across:2
				checkbox mat_IGNORE "IGNORE" checked:false
				checkbox mat_FREE24 "FREE24" checked:false across:2
				checkbox mat_MIPMAPPED "MIPMAPPED" checked:false
				checkbox mat_FREE26 "FREE26" checked:false across:2
				checkbox mat_ALPHA_FOGGED "ALPHA_FOGGED" checked:false
				checkbox mat_FOGGED "FOGGED" checked:false across:2
				checkbox mat_FILTERED "FILTERED" checked:false
				checkbox mat_FREE30 "FREE30" checked:false across:2
				checkbox mat_FREE3 "FREE3" checked:false
			)
			group "Ambient"
			(
				
				spinner mat_ui_red "R" range:[0,1,1] type:#float across:3
				spinner mat_ui_green "G" range:[0,1,1] type:#float
				spinner mat_ui_blue "B" range:[0,1,1] type:#float
			)
			group "Emmissive"
			(
				spinner mat_ui_emissive_red "R" range:[0,1,1] type:#float across:3
				spinner mat_ui_emissive_green "G" range:[0,1,1] type:#float 
				spinner mat_ui_emissive_blue "B" range:[0,1,1] type:#float 
			)
			group "Specular"
			(
				spinner mat_ui_specular_red "R" range:[0,1,1] type:#float across:3
				spinner mat_ui_specular_green "G" range:[0,1,1] type:#float
				spinner mat_ui_specular_blue "B" range:[0,1,1] type:#float 
				spinner mat_ui_specular_power "Power" range:[0,1,1] type:#float across:1
			)
			group "Misc" (
				spinner mat_ui_PS2MipDistance "PS2 Mip Distance" range:[0,100000000,1] type:#float across:2
				spinner mat_ui_PS2MipValue "PS2 Mip Value" range:[0,1000,0] type:#integer align:#left
				
				spinner mat_ui_FlareSpec "Flare Spec" range:[0,1000000000,0] type:#integer align:#left
			)
			group "Layers"
			(
				dotnetcontrol lv_Layers "listview" height: 100
				button but_MoveLayerUp "^" across:2 
				button but_MoveLayerDown "v" across:2 
				edittext txt_LayerName "Layer Name"
				
				dropdownlist dpdn_LayerBlendMode "Blend Mode" items:MTLBlendModes selection:1  across:2
				dropdownlist dpdn_LayerSpecialFX "FX" items:MTLLayerEffects selection:1 

				spinner spn_AlphaOpacity "Alpha Opacity" range:[0,1,1] type:#float align:#left
				spinner spn_FlipbookFPS "Flipbook FPS" range:[0,100,30] type:#float align:#left
				spinner spn_ScrollSpeedU "ScrollSpeed U" range:[0,100,30] type:#float fieldWidth:60 align:#left across:2
				spinner spn_ScrollSpeedV "ScrollSpeed V" range:[0,100,30] type:#float fieldWidth:60 align:#left

				
				dropdownlist dpdn_LayerMappingModeU "MappingMode U" items:MTLUVMappingModes selection:2  across:2
				dropdownlist dpdn_LayerMappingModeV "MappingMode V" items:MTLUVMappingModes selection:2

				spinner spn_UVSlot "UV Slot" range:[0,3,0] type:#integer align:#left
				spinner spn_NumFramesU "Num Frames U" range:[0,200,8] type:#integer align:#left across:2
				spinner spn_NumFramesV "Num Frames V" range:[0,200,8] type:#integer align:#left
				checkbox chk_NO_MIPMAP "NO_MIPMAP" checked:false across:2 align:#left
				checkbox chk_FLIP_BOOK_ANIM "FLIP_BOOK_ANIM" checked:false across:2 align:#left
				checkbox chk_UV_SCROLL "UV_SCROLL" checked:false across:2 align:#left
				checkbox chk_USE_VERTEX_ALPHA "USE_VERTEX_ALPHA" checked:false across:2 align:#left
				checkbox chk_FREE4 "FREE4" checked:false across:2 align:#left
				checkbox chk_FREE5 "FREE5" checked:false across:2 align:#left
				checkbox chk_FREE6 "FREE6" checked:false across:2 align:#left
				checkbox chk_FREE7 "FREE7" checked:false across:2 align:#left

				button but_SaveLayer "Save" across:3 width:100
				button but_DeleteLayer "Delete" width:100
				button but_AddLayer "Add" width: 100
			)	
			local doRefresh = true
			
			fn refreshLayerList = (
				lv_Layers.Items.Clear()
				for i=1 to layer_name.count do
				(
					if(layer_name[i] != undefined) then(
					lvItem = dotnetobject "listviewitem" layer_name[i]
					blendmodeID = layer_blend_mode[i]
					layerfxID = layer_specialfx[i]
					lvitem.subitems.add (MTLBlendModes[blendmodeID])
					lvitem.subitems.add (MTLLayerEffects[layerfxID])
					lv_Layers.Items.add lvitem
					)
				)
			)

			fn updateLayer sender ev = (
				format "Event handler called\n"
				if(layerProperties != undefined) then (
					
					i = lv_Layers.selectedIndices.Item[0] + 1
					
					format "Updating layer info %\n" i

					layer_name[i] = layerProperties.controls["LayerName"].Text
					layer_blend_mode[i] = layerProperties.controls["LayerBlendMode"].selectedIndex
					RefreshLayersList()
				)
			)
			on lv_Layers selectedindexchanged do (
				
				selectedLayer = 0
				but_SaveLayer.enabled = false
				but_DeleteLayer.enabled = false
				if lv_Layers.selectedIndices.count > 0  then (
					
					i = lv_Layers.selectedIndices.Item[0] + 1
					selectedLayer = i
					but_SaveLayer.enabled = true
					but_DeleteLayer.enabled = true
					
					txt_LayerName.text= layer_name[selectedLayer]
					dpdn_LayerBlendMode.selection = layer_blend_mode[selectedLayer]
					dpdn_LayerSpecialFX.selection = layer_specialfx[selectedLayer]
					spn_AlphaOpacity.value = layer_alpha_opacity[selectedLayer]
					spn_FlipbookFPS.value = layer_flipbook_fps[selectedLayer]
					spn_ScrollSpeedU.value = layer_scrollspeed_u[selectedLayer]
					spn_ScrollSpeedV.value = layer_scrollspeed_v[selectedLayer]
					dpdn_LayerMappingModeU.selection = layer_mappingmode_u[selectedLayer]
					dpdn_LayerMappingModeV.selection = layer_mappingmode_v[selectedLayer]
					spn_UVSlot.value = layer_uv_slot[selectedLayer]
					spn_NumFramesU.value = layer_numframes_u[selectedLayer]
					spn_NumFramesV.value = layer_numframes_v[selectedLayer]
					chk_No_MipMap.checked = (bit.and layer_layerflags[selectedLayer] 1) == 1
					chk_FLIP_BOOK_ANIM.checked = (bit.and layer_layerflags[selectedLayer] 2) == 2
					chk_UV_SCROLL.checked = (bit.and layer_layerflags[selectedLayer] 4) == 4
					chk_USE_VERTEX_ALPHA.checked = (bit.and layer_layerflags[selectedLayer] 8) == 8
					chk_FREE4.checked = (bit.and layer_layerflags[selectedLayer] 16) == 16
					chk_FREE5.checked = (bit.and layer_layerflags[selectedLayer] 32) == 32
					chk_FREE6.checked = (bit.and layer_layerflags[selectedLayer] 64) == 64
					chk_FREE7.checked = (bit.and layer_layerflags[selectedLayer] 128) == 128
				)
			)
			on mtlmat_props open do
			(
				
				 selectedLayer = 0
				
				lv_Layers.view  = (dotnetclass "view").details
				lv_Layers.fullrowselect= true
				lv_Layers.gridlines = true
				lv_Layers.multiselect =false
				lv_Layers.columns.add "Name" 140
				lv_Layers.columns.add "Blend Mode" 70
				lv_Layers.columns.add "FX" 70
				refreshLayerList()

				
			)

			on txt_LayerName changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_name.count) then (
					layer_name[selectedLayer] = val
					refreshLayerList()
				)
			)
			on dpdn_LayerBlendMode selected  val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_blend_mode.count) then (
					layer_blend_mode[selectedLayer] = val
					refreshLayerList()
				)
			)
			on dpdn_LayerSpecialFX selected val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_specialfx.count) then (
					layer_specialfx[selectedLayer] = val
					refreshLayerList()
				)
			)
			on spn_AlphaOpacity changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_alpha_opacity.count) then (
					layer_alpha_opacity[selectedLayer] = val
				)
			)
			on spn_FlipbookFPS changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_flipbook_fps.count) then (
					layer_flipbook_fps[selectedLayer] = val
				)
			)
			on spn_ScrollSpeedU changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_scrollspeed_u.count) then (
					layer_scrollspeed_u[selectedLayer] = val
				)
			)
			on spn_NumFramesV changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_scrollspeed_v.count) then (
					layer_scrollspeed_v[selectedLayer] = val
				)
			)
			on dpdn_LayerMappingModeU selected  val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_mappingmode_u.count) then (
					layer_mappingmode_u[selectedLayer] = val
				)
			)
			on dpdn_LayerMappingModeV selected  val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_mappingmode_v.count) then (
					layer_mappingmode_v[selectedLayer] = val
				)
			)



			fn SetLayerFlags = (
				flags = 0
				if(chk_NO_MIPMAP.checked) then (
					flags = bit.or flags 1
				)

				if(chk_FLIP_BOOK_ANIM.checked) then (
					flags = bit.or flags 2
				)

				if(chk_UV_SCROLL.checked) then (
					flags = bit.or flags 4
				)

				if(chk_USE_VERTEX_ALPHA.checked) then (
					flags = bit.or flags 8
				)

				if(chk_FREE4.checked) then (
					flags = bit.or flags 16
				)

				if(chk_FREE5.checked) then (
					flags = bit.or flags 32
				)

				if(chk_FREE6.checked) then (
					flags = bit.or flags 64
				)

				if(chk_FREE7.checked) then (
					flags = bit.or flags 128
				)
				layer_layerflags[selectedLayer] = flags

			)

			on chk_NO_MIPMAP changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			on chk_FLIP_BOOK_ANIM changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			on chk_UV_SCROLL changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			on chk_USE_VERTEX_ALPHA changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			
			on chk_FREE4 changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			on chk_FREE5 changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			on chk_FREE6 changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			on chk_FREE7 changed val do (
				if (selectedLayer > 0 )and (selectedLayer <= layer_layerflags.count) then (
					SetLayerFlags()
				)
			)
			
			on but_AddLayer pressed do (
				append layer_name "NewLayer"
				append layer_blend_mode 1
				append layer_alpha_opacity 1
				append layer_specialfx 1
				append layer_flipbook_fps 1
				append layer_scrollspeed_u 0
				append layer_scrollspeed_v 0
				append layer_mappingmode_u 2
				append layer_mappingmode_v 2
				append layer_uv_slot 0
				append layer_numframes_u 1
				append layer_numframes_v 1
				append layer_layerflags 0
refreshLayerList()
			)

			on but_DeleteLayer pressed do (

				if  (selectedLayer > 0 )and (selectedLayer <= layer_name.count) then (
					deleteItem layer_name selectedLayer
					deleteItem layer_blend_mode selectedLayer
					deleteItem layer_alpha_opacity selectedLayer
					deleteItem layer_specialfx selectedLayer
					deleteItem layer_flipbook_fps selectedLayer
					deleteItem layer_scrollspeed_u selectedLayer
					deleteItem layer_scrollspeed_v selectedLayer
					deleteItem layer_mappingmode_u selectedLayer
					deleteItem layer_mappingmode_v selectedLayer
					deleteItem layer_uv_slot selectedLayer
					deleteItem layer_numframes_u selectedLayer
					deleteItem layer_numframes_v selectedLayer
					deleteItem layer_layerflags selectedLayer
					lv_Layers.items.RemoveAt (selectedLayer - 1)
				)
			)

			on mtlmat_props close do
			(
			)
			
			on mtlmat_props resized size do
			(
				--format "Rollout size: %\n" size
				eh.width = size.x - 100
				eh.height = 300
			)
			on eh Paint args do
			(
				if doRefresh then
				(
					doRefresh = false
					eh.refresh()
					doRefresh = true
				)
			)
		)
	)


/*********************************
***** CNT ATTRIBUTES
*********************************/

CNTTypes = #("MODL","NULL","LITg","SKIN","shrb","VFXI")
CNTAttribute = attributes CNTCustAttribute attribID:#(0x7a3a974d, 0x58ce73ad) version:1
(
	parameters main rollout:CNTAttributeParams
	(
		
		NodeTypeID type:#integer default:1
		NodeType type:#string default:"MODL"
		FileName type:#string ui:uiFileName default:""
		BakeScaleIntoMesh type:#boolean ui:uiBakeScaleIntoMesh default: false
		
	)
	rollout CNTAttributeParams "CNT Hierarchy Params"
	(
		dropdownlist uiNodeType "Node Type" items:CNTTypes selection:NodeTypeID
		--edittext uiNodeType2 "Node Type (string)" labelOnTop:true
		edittext uiFileName "Content Filename" labelOnTop:true
		checkbox uiBakeScaleIntoMesh "Bake Scale into Mesh"
		on uiNodeType selected i do 
		(
			NodeTypeID = uiNodeType.selection
			NodeType = uiNodeType.items[i]
			if NodeType == "SKIN" then
			(
				
				if $.modifiers["Ped Bones List"] == undefined then
				(
					
					AddPedBonesListMod $
				)
			)
		)
	)
)

HandlingSetupLUAAttribute = attributes HandlingSetupLUA_Def attribID:#(0x34f73ea1, 0x5e4ac92) version:1
(
	parameters main rollout:HandlingSetupLUAMainRollout
	(
		CollisionEffect_Name type:#string default:"effects.f_carsharpnel06" ui:txt_CollisionEffect_Name
		CollisionEffect_Strength type:#float default:10.5 ui:spn_CollisionEffect_Strength  range:[0,100000,10.5]
		Mass type:#float default:1300 ui:spn_Mass  range:[0,100000,1300]
		WheelMass type:#float default:10 ui:spn_WheelMass  range:[0,100000,10]
		CMPosY type:#float default:0.52 ui:spn_CMPosY  range:[0,100000,0.52]
		CMPosZ type:#float default:0 ui:spn_CMPosZ  range:[0,100000,0]
	)

	parameters handling rollout:HandlingSetupLUAHandlingRollout
	(
		TractionFactor type:#float default:1.2 ui:spn_TractionFactor range:[0,1000,0]  range:[0,100000,1.2]
		RearGrip type:#float default:1.6 ui:spn_RearGrip  range:[0,100000,1.6]
		FrontGrip type:#float default:1.7 ui:spn_FrontGrip  range:[0,100000,1.7]
		FrontDownforce type:#float default:20 ui:spn_FrontDownforce  range:[0,100000,20]
		RearDownforce type:#float default:20 ui:spn_RearDownforce  range:[0,100000,20]
		FrontRoll type:#float default:0.4 ui:spn_FrontRoll  range:[0,100000,0.4]
		RearRoll type:#float default:0.3 ui:spn_RearRoll  range:[0,100000,0.3]
		FrontCriticalAngle type:#float default:6 ui:spn_FrontCriticalAngle  range:[0,100000,6]
		RearCriticalAngle type:#float default:6 ui:spn_RearCriticalAngle  range:[0,100000,6]
		FrontSuspGive type:#float default:0.1 ui:spn_FrontSuspGive  range:[0,100000,0.1]
		RearSuspGive type:#float default:0.08 ui:spn_RearSuspGive  range:[0,100000,0.08]
		SuspDamping type:#float default:1 ui:spn_SuspDamping  range:[0,100000,1]
		SuspensionRollFactor type:#float default:1 ui:spn_SuspensionRollFactor  range:[0,100000,1]
		SuspensionPitchFactor type:#float default:1 ui:spn_SuspensionPitchFactor  range:[0,100000,1]
		MomentOfInertiaMultiplier type:#float default:1 ui:spn_MomentOfInertiaMultiplier  range:[0,100000,1]
		SteerSpeed1 type:#float default:1 ui:spn_SteerSpeed1  range:[0,100000,1]
		SteerSpeed2 type:#float default:0.5 ui:spn_SteerSpeed2  range:[0,100000,0.5]
		SteerSpeedVel type:#float default:150 ui:spn_SteerSpeedVel  range:[0,100000,150]
		SteerCentreMultiplier type:#float default:2 ui:spn_SteerCentreMultiplier  range:[0,100000,2]
		StabilityGripChange type:#float default:0.4 ui:spn_StabilityGripChange  range:[0,100000,0.4]
		StabilityThreshold type:#float default:0.5 ui:spn_StabilityThreshold  range:[0,100000,0.5]
		MaxSteeringAngle type:#float default:40 ui:spn_MaxSteeringAngle  range:[0,100000,40]
		BrakeBalance type:#float default:60 ui:spn_BrakeBalance  range:[0,100000,60]
		BrakeForce type:#float default:60 ui:spn_BrakeForce  range:[0,100000,60]
		HandBrakeStrength type:#float default:10 ui:spn_HandBrakeStrength  range:[0,100000,10]
		TorqueSplit type:#float default:65 ui:spn_TorqueSplit  range:[0,100000,65]
		LSDThresholdF type:#float default:10 ui:spn_LSDThresholdF  range:[0,100000,10]
		LSDThresholdR type:#float default:10 ui:spn_LSDThresholdR  range:[0,100000,10]
		LSDThresholdM type:#float default:10 ui:spn_LSDThresholdM  range:[0,100000,10]
		ReversePowerMulitplier type:#float default:1 ui:spn_ReversePowerMulitplier  range:[0,100000,1]
		DragCoefficient type:#float default:0.4 ui:spn_DragCoefficient  range:[0,100000,0.4]
		SteerLimit1 type:#float default:0 ui:spn_SteerLimit1  range:[0,100000,0]
		SteerLimit2 type:#float default:0 ui:spn_SteerLimit2  range:[0,100000,0]
		SteerLimitSpeed type:#float default:0 ui:spn_SteerLimitSpeed  range:[0,100000,0]
		CastorSpeed1 type:#float default:0 ui:spn_CastorSpeed1  range:[0,100000,0]
		CastorSpeed2 type:#float default:1 ui:spn_CastorSpeed2  range:[0,100000,1]
		CastorSpeedVel type:#float default:100 ui:spn_CastorSpeedVel  range:[0,100000,100]
		SteerGyroscope type:#float default:1 ui:spn_SteerGyroscope  range:[0,100000,1]
		BrakeAttack type:#float default:1 ui:spn_BrakeAttack  range:[0,100000,1]
		HandBrakeAttack type:#float default:0.1 ui:spn_HandBrakeAttack  range:[0,100000,0.1]
		SlideSpinRecovery type:#float default:1 ui:spn_SlideSpinRecovery  range:[0,100000,1]
		RollingResistance type:#float default:0.018 ui:spn_RollingResistance  range:[0,100000,0.018]
	)

	parameters engine rollout:HandlingSetupLUAEngineRollout
	(
		PowerMultiplier type:#float default:1.5 ui:spn_PowerMultiplier  range:[0,100000,1.5]
		FinalDrive type:#float default:1 ui:spn_FinalDrive  range:[0,100000,1]
		DriveMI type:#float default:2.2 ui:spn_DriveMI  range:[0,100000,2.2]
		EngineMI type:#float default:0.06 ui:spn_EngineMI  range:[0,100000,0.06]
		RedLine type:#float default:6500 ui:spn_RedLine  range:[0,100000,6500]
		MaxRevs type:#float default:8000 ui:spn_MaxRevs  range:[0,100000,8000]
		LimitRevs type:#boolean default:true ui:chk_LimitRevs
		ConstantEngineFriction type:#float default:833 ui:spn_ConstantEngineFriction  range:[0,100000,833]
		LinearEngineFriction type:#float default:0 ui:spn_LinearEngineFriction  range:[0,100000,0]
		QuadraticEngineFriction type:#float default:0.0023 ui:spn_QuadraticEngineFriction  range:[0,100000,0.0023]
		ConstantDriveFriction type:#float default:9.1 ui:spn_ConstantDriveFriction  range:[0,100000,9.1]
		LinearDriveFriction type:#float default:0 ui:spn_LinearDriveFriction  range:[0,100000,0]
		QuadraticDriveFriction type:#float default:0.0008 ui:spn_QuadraticDriveFriction  range:[0,100000,0.0008]
		EngineBrakeDelay type:#float default:0.5 ui:spn_EngineBrakeDelay  range:[0,100000,0.5]
		EngineBrakeAttack type:#float default:0.28 ui:spn_EngineBrakeAttack  range:[0,100000,0.28]
		ClutchDelay type:#float default:0 ui:spn_ClutchDelay  range:[0,100000,0]
		NumGears type:#float default:5 ui:spn_NumGears
		GearRatios type:#floattab tabsizevariable:true
		TorqueCurve type:#floattab tabsizevariable:true
		GearRatiosPopup type:#boolean default:false ui:chk_GearRatiosPopup
		TorqueCurvePopup type:#boolean default:false ui:chk_TorqueCurvePopup
	)
	rollout HandlingSetupLUAMainRollout "General Setup" (
		edittext txt_CollisionEffect_Name "Collision Effect Name" default:"effects.f_carsharpnel06" 
		spinner spn_CollisionEffect_Strength "Collision Effect Strength" type:#float default:10.5 range:[0,100000,10.5]
		spinner spn_Mass "Mass" type:#float default:1300 range:[0,100000,1300]
		spinner spn_WheelMass "WheelMass" type:#float default:10 range:[0,100000,10]
		spinner spn_CMPosY "CMPosY" type:#float default:0.52 range:[0,100000,0.52]
		spinner spn_CMPosZ "CMPosZ" type:#float default:0 range:[0,100000,0]
	)

	rollout HandlingSetupLUAHandlingRollout "Handling Setup" (
		spinner spn_TractionFactor "TractionFactor" type:#float default:1.2 range:[0,100000, 1.2]
		spinner spn_RearGrip "RearGrip" type:#float default:1.6 range:[0,100000, 1.6]
		spinner spn_FrontGrip "FrontGrip" type:#float default:1.7 range:[0,100000, 1.7]
		spinner spn_FrontDownforce "FrontDownforce" type:#float default:20 range:[0,100000, 20]
		spinner spn_RearDownforce "RearDownforce" type:#float default:20 range:[0,100000, 20]
		spinner spn_FrontRoll "FrontRoll" type:#float default:0.4 range:[0,100000, 0.4]
		spinner spn_RearRoll "RearRoll" type:#float default:0.3 range:[0,100000, 0.3]
		spinner spn_FrontCriticalAngle "FrontCriticalAngle" type:#float default:6 range:[0,100000, 6]
		spinner spn_RearCriticalAngle "RearCriticalAngle" type:#float default:6 range:[0,100000, 6]
		spinner spn_FrontSuspGive "FrontSuspGive" type:#float default:0.1 range:[0,100000, 0.1]
		spinner spn_RearSuspGive "RearSuspGive" type:#float default:0.08 range:[0,100000, 0.08]
		spinner spn_SuspDamping "SuspDamping" type:#float default:1 range:[0,100000, 1]
		spinner spn_SuspensionRollFactor "SuspensionRollFactor" type:#float default:1 range:[0,100000, 1]
		spinner spn_SuspensionPitchFactor "SuspensionPitchFactor" type:#float default:1 range:[0,100000, 1]
		spinner spn_StabilityGripChange "StabilityGripChange" type:#float default:0.4 range:[0,100000, 0.4]
		spinner spn_StabilityThreshold "StabilityThreshold" type:#float default:0.5 range:[0,100000, 0.5]
		spinner spn_MomentOfInertiaMultiplier "MomentOfInertiaMultiplier" type:#float default:1 range:[0,100000, 1]
		spinner spn_SteerSpeed1 "SteerSpeed1" type:#float default:1 range:[0,100000, 1]
		spinner spn_SteerSpeed2 "SteerSpeed2" type:#float default:0.5 range:[0,100000, 0.5]
		spinner spn_SteerSpeedVel "SteerSpeedVel" type:#float default:150 range:[0,100000, 150]
		spinner spn_SteerCentreMultiplier "SteerCentreMultiplier" type:#float default:2 range:[0,100000, 2]
		spinner spn_MaxSteeringAngle "MaxSteeringAngle" type:#float default:40 range:[0,100000, 40]
		spinner spn_BrakeBalance "BrakeBalance" type:#float default:60 range:[0,100000, 60]
		spinner spn_BrakeForce "BrakeForce" type:#float default:60 range:[0,100000, 60]
		spinner spn_HandBrakeStrength "HandBrakeStrength" type:#float default:10 range:[0,100000, 10]
		spinner spn_TorqueSplit "TorqueSplit" type:#float default:65 range:[0,100000, 65]
		spinner spn_LSDThresholdF "LSDThresholdF" type:#float default:10 range:[0,100000, 10]
		spinner spn_LSDThresholdR "LSDThresholdR" type:#float default:10 range:[0,100000, 10]
		spinner spn_LSDThresholdM "LSDThresholdM" type:#float default:10 range:[0,100000, 10]
		spinner spn_ReversePowerMulitplier "ReversePowerMulitplier" type:#float default:1 range:[0,100000, 1]
		spinner spn_DragCoefficient "DragCoefficient" type:#float default:0.4 range:[0,100000, 0.4]
		spinner spn_SteerLimit1 "SteerLimit1" type:#float default:0 range:[0,100000, 0]
		spinner spn_SteerLimit2 "SteerLimit2" type:#float default:0 range:[0,100000, 0]
		spinner spn_SteerLimitSpeed "SteerLimitSpeed" type:#float default:0 range:[0,100000, 0]
		spinner spn_CastorSpeed1 "CastorSpeed1" type:#float default:0 range:[0,100000, 0]
		spinner spn_CastorSpeed2 "CastorSpeed2" type:#float default:1 range:[0,100000, 1]
		spinner spn_CastorSpeedVel "CastorSpeedVel" type:#float default:100 range:[0,100000, 100]
		spinner spn_SteerGyroscope "SteerGyroscope" type:#float default:1 range:[0,100000, 1]
		spinner spn_BrakeAttack "BrakeAttack" type:#float default:1 range:[0,100000, 1]
		spinner spn_HandBrakeAttack "HandBrakeAttack" type:#float default:0.1 range:[0,100000, 0.1]
		spinner spn_SlideSpinRecovery "SlideSpinRecovery" type:#float default:1 range:[0,100000, 1]
		spinner spn_RollingResistance "RollingResistance" type:#float default:0.018 range:[0,100000, 0.018]
	)
	rollout HandlingSetupLUAEngineRollout "Engine Setup" (
		spinner spn_PowerMultiplier "PowerMultiplier" type:#float default:1.5 range:[0,100000, 1.5]
		spinner spn_FinalDrive "FinalDrive" type:#float default:1 range:[0,100000, 1]
		spinner spn_DriveMI "DriveMI" type:#float default:2.2 range:[0,100000, 2.2]
		spinner spn_EngineMI "EngineMI" type:#float default:0.06 range:[0,100000, 0.06]
		spinner spn_RedLine "RedLine" type:#float default:6500 range:[0,100000, 6500]
		spinner spn_MaxRevs "MaxRevs" type:#float default:8000 range:[0,100000, 8000]
		checkbox chk_LimitRevs "Limit Revs" default:true
		spinner spn_ConstantEngineFriction "ConstantEngineFriction" type:#float default:833 range:[0,100000, 833]
		spinner spn_LinearEngineFriction "LinearEngineFriction" type:#float default:0 range:[0,100000, 0]
		spinner spn_QuadraticEngineFriction "QuadraticEngineFriction" type:#float default:0.0023 range:[0,100000, 0.0023]
		spinner spn_ConstantDriveFriction "ConstantDriveFriction" type:#float default:9.1 range:[0,100000, 9.1]
		spinner spn_LinearDriveFriction "LinearDriveFriction" type:#float default:0 range:[0,100000, 0]
		spinner spn_QuadraticDriveFriction "QuadraticDriveFriction" type:#float default:0.0008 range:[0,100000, 0.0008]
		spinner spn_EngineBrakeDelay "EngineBrakeDelay" type:#float default:0.5 range:[0,100000, 0.5]
		spinner spn_EngineBrakeAttack "EngineBrakeAttack" type:#float default:0.28 range:[0,100000, 0.28]
		spinner spn_ClutchDelay "ClutchDelay" type:#float default:0 range:[0,100000, 0]
		spinner spn_NumGears "NumGears" type:#float default:5 range:[0,100000, 5]
		group "Gear Ratios" (
			checkbox chk_GearRatiosPopup "Open In Popup Next Time" default:false
			curvecontrol crv_GearRatios numCurves:1 x_range:[0,10] y_range:[0,1000] rcmFlags:#(#move_y) asPopup:GearRatiosPopup uiFlags:#(#drawBG, #drawgrid,#lowerToolbar, #scrollBars, #xvalue)
			button btn_ResetGearRatios "Reset Gear Ratios"
		)
		group "Torque Curve" (
			checkbox chk_TorqueCurvePopup "Open In Popup Next Time" default:false
			curvecontrol crv_TorqueCurve numCurves:1 x_range:[0,20] y_range:[0,1000] rcmFlags:#(#move_y) asPopup:TorqueCurvePopup  uiFlags:#(#drawBG, #drawgrid,#lowerToolbar, #scrollBars, #xvalue)
			button btn_ResetTorqueCurve "Reset Torque Curve"
		)

		fn ResetGearRatios = (
			GearRatios = #(13.86,8.2193,5.7005,4.2327,3.2277,2.6775,2.1616,1.7157,1.3752,1.1346)
		)
		fn ResetTorqueCurve = (
			TorqueCurve = #(150,232,264,280,264,240,208,160,0,0,0,0,0,0,0,0,0,0,0,0)
			
		)
		on chk_GearRatiosPopup changed val do (
			select $
			modPanel.setCurrentObject $.modifiers["setup.lua"]
		)
		on chk_TorqueCurvePopup changed val do (
			select $
			modPanel.setCurrentObject $.modifiers["setup.lua"]
		)
		on btn_ResetGearRatios pressed do (
			updatingCurve = true
			ResetGearRatios()
			GearCrv = crv_GearRatios.curves[1]
			
			for i = GearCrv.Points.count to 2 by -1 do (
				--deletePoint GearCrv i
			)
			--GearCrv.numPoints = GearRatios.count
			for i=1 to GearRatios.count do (
				cp = GearCrv.points[i]

				cp.value.y = GearRatios[i]
				GearCrv.points[i].value.y = GearRatios[i]
			)
			--crv_GearRatios.curves[1] = GearCrv
			zoom crv_GearRatios #all

			updatingCurve = false
		)
		on btn_ResetTorqueCurve pressed do (
			updatingCurve = true
			ResetTorqueCurve()

			TorqueCrv = crv_TorqueCurve.curves[1]
			for i = TorqueCrv.Points.count to  2 by -1 do (
				--deletePoint  TorqueCrv i
			)
			--TorqueCrv.numPoints = TorqueCurve.count
			for i=1 to TorqueCurve.count do (
				cp = TorqueCrv.points[i]
				cp.value.y = TorqueCurve[i]

				TorqueCrv.points[i].value.y = TorqueCurve[i]
			)
			--crv_TorqueCurve.curves[1] = TorqueCrv
			zoom crv_TorqueCurve #all
			crv_TorqueCurve.zoomValues = [crv_TorqueCurve.zoomValues.x * 2, crv_TorqueCurve.zoomValues.y]
			
			updatingCurve = false
		)
		local updatingCurve = true
		on HandlingSetupLUAEngineRollout open do (
			updatingCurve = true
			if GearRatios.count < 1 then (
				ResetGearRatios()
			)
			if TorqueCurve.count < 1 then (
				ResetTorqueCurve()
			)
			print TorqueCurve
			print GearRatios

			GearCrv = crv_GearRatios.curves[1]
			GearCrv.numPoints = GearRatios.count
			for i=1 to GearRatios.count do (
				cp = GearCrv.points[i]
				cp.value = [i,GearRatios[i]]
				cp.lock_x =true
				GearCrv.points[i] = cp
			)
			crv_GearRatios.curves[1] = GearCrv
			zoom crv_GearRatios #all


			TorqueCrv = crv_TorqueCurve.curves[1]
			TorqueCrv.numPoints = TorqueCurve.count
			for i=1 to TorqueCurve.count do (
				cp = TorqueCrv.points[i]
				cp.value = [i,TorqueCurve[i]]

				cp.lock_x =true
				TorqueCrv.points[i] = cp
			)
			crv_TorqueCurve.curves[1] = TorqueCrv
			zoom crv_TorqueCurve #all
			crv_TorqueCurve.zoomValues = [crv_TorqueCurve.zoomValues.x * 2, crv_TorqueCurve.zoomValues.y]
			
			updatingCurve = false
		)
		on HandlingSetupLUAEngineRollout close do (
			
		)
		on crv_GearRatios ptChanged c p do (
			if updatingCurve == false and GearRatios.count > 0 then (
				
				newVal = crv_GearRatios.curves[c].points[p].value.y
				GearRatios[p] = newVal
			)
		)
		on crv_TorqueCurve ptChanged c p do (
			if updatingCurve == false and TorqueCurve.count > 0 then (
				
				newVal = crv_TorqueCurve.curves[c].points[p].value.y
				TorqueCurve[p] = newVal
			)
		)
	)
)
/*********************************
***** CAR VEHICLE_SETUP.LOL ATTRIBUTES
*********************************/
VehicleSetupLUAAttribute = attributes VehicleSetupLUA_Def attribID:#(0x1b9d3ae4, 0x1a44f0c1) version:1
(
	parameters main rollout:VehicleLUAMainRollout
	(
		default type:#Boolean ui:chk_default
        camera_distance type:#Integer ui:spn_camera_distance default:18
        camera_extra_tilt_angle type:#Integer ui:spn_camera_extra_tilt_angle deflect:0
        dev type:#Boolean ui:chk_dev
        cop type:#Boolean ui:chk_cop
        eagle type:#Boolean ui:chk_eagle
        tier type:#Integer ui:spn_tier
        progress type:#Integer ui:spn_progress
        shipped type:#Boolean ui:chk_shipped
        leaderboard_id type:#Integer ui:spn_leaderboard_id
        unlock_node type:#Integer ui:spn_unlock_node
        class_rounded type:#Boolean ui:chk_class_rounded
        class_speedy type:#Boolean ui:chk_class_speedy
        class_smashy type:#Boolean ui:chk_class_smashy
        barred_from_easy_on_ramp type:#Boolean ui:chk_barred_from_easy_on_ramp
        hawk type:#Boolean ui:chk_hawk
        suppressor type:#Boolean ui:chk_suppressor
        product_id type:#Integer ui:spn_product_id
        consider_in_stats type:#Boolean ui:chk_consider_in_stats
        override_vehicle_name type:#String ui:txt_override_vehicle_name
        override_driver_name type:#String ui:txt_override_driver_name
        override_bio type:#String ui:txt_override_bio
        hud_damage_levels type:#Floattab tabsizevariable:true
	)
	rollout VehicleLUAMainRollout "Vehicle Setup LUA"
	(
		group "Car Info" (
			edittext txt_override_vehicle_name "Vehicle Name"
			edittext txt_override_driver_name "Driver Name"
			edittext txt_override_bio "Bio"
		)
		group "Camera Details" (
			spinner spn_camera_distance "Camera Distance" range:[0,100,10] type:#integer
			spinner spn_camera_extra_tilt_angle "Camera Tilt Angle" range:[0,60,0]  type:#integer

		)
		group "HUD Damage Levels" (
			spinner spn_HUDDamageLevel "" range:[0,1,0] type:#float across:2
			button but_AddToDamageLevels "Add"
			dotnetcontrol lv_HUDDamageLevels "listview" height: 100
			button but_DeleteFromDamageLevels "Delete Selected"
		)
		group "Vehicle Type" (
			checkbox chk_default "Default"
			checkbox chk_dev "Dev"
			checkbox chk_shipped "Shipped"
			checkbox chk_cop "Cop"
			checkbox chk_eagle "Eagle"
			checkbox chk_hawk "Hawk"
			checkbox chk_suppressor "Suppressor"
			checkbox chk_class_rounded "Class: Rounded"
			checkbox chk_class_speedy "Class: Speedy"
			checkbox chk_class_smashy "Class: Smashy"
			checkbox chk_barred_from_easy_on_ramp "Barred From Easy On Ramp"
			checkbox chk_consider_in_stats "Considered In Stats"
		)
		group "Career Settings" (
			spinner spn_tier "Tier" range:[0,100,0] type:#integer
			spinner spn_progress "Progress" range:[0,100,0] type:#integer
			spinner spn_unlock_node "Unlock Node" range:[0,100,0] type:#integer
			spinner spn_leaderboard_id "Leaderboard ID" range:[0,100,0] type:#integer
			spinner spn_product_id "Product ID" range:[0,100000,0] type:#integer

		)
		on VehicleLUAMainRollout open  do (

			--but_AddToDamageLevels.pos = [120, but_AddToDamageLevels.pos.y+15]
			lv_HUDDamageLevels.view  = (dotnetclass "view").details
			lv_HUDDamageLevels.fullrowselect= true
			lv_HUDDamageLevels.gridlines = true
			lv_HUDDamageLevels.multiselect =false
			lv_HUDDamageLevels.columns.add "Damage Level" 110

			if hud_damage_levels.count == 0 then (
				append hud_damage_levels 0.05
				append hud_damage_levels 0.3
				append hud_damage_levels 0.55
				append hud_damage_levels 0.8
				append hud_damage_levels 1
			)



			for i=1 to hud_damage_levels.count do
			(
				lv_HUDDamageLevels.Items.add (hud_damage_levels[i] as string)
			)
		)
		on but_DeleteFromDamageLevels pressed do
		(
			if lv_HUDDamageLevels.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_HUDDamageLevels.SelectedIndices.Item[0]
				lv_HUDDamageLevels.Items.removeat selectedIndex
				deleteItem hud_damage_levels (selectedIndex+1)
			)
		)
		on but_AddToDamageLevels pressed do
		(
			lv_HUDDamageLevels.Items.add (txt_DriverName.text)
			append hud_damage_levels txt_DriverName.text
		)
	)
)

/*********************************
***** CAR VEHICLE_SETUP.CFG ATTRIBUTES
*********************************/
VehicleSetupCFGAttribute = attributes VehicleSetupCFG_Def attribID:#(0x340cef1c, 0x6f4b7c3d) version:1
(
	parameters main rollout:VehicleCFGMainRollout
	(
		AIScript type:#string ui:txt_AIScript default:""
		MaxCompression type:#float ui:spn_MaxCompression
		MaxExtension type:#float ui:spn_MaxExtension
		RideHeight type:#float ui:spn_RideHeight
		MaxSteeringLock type:#integer detault:20 ui:spn_MaxSteeringLock
		MaxCompression_Active type:#boolean ui:chk_MaxCompression_Active
		MaxExtension_Active type:#boolean ui:chk_MaxExtension_Active
		RideHeight_Active type:#boolean ui:chk_RideHeight_Active
		MaxSteeringLock_Active type:#boolean ui:chk_MaxSteeringLock_Active
		TopSpeed type:#integer 	default:155	ui:spn_TopSpeed
		To60Time type:#float 	default:3.1 ui:spn_To60Time
		Weight type:#float 		default:1.3 ui:spn_Weight
		Toughness type:#float 	default:1.1 ui:spn_Toughness
		UnlockLevel type:#integer default:0	ui:spn_UnlockLevel
	)
	rollout VehicleCFGMainRollout "Vehicle CFG"
	(

		edittext txt_AIScript "AI Script" labelOnTop:true
		spinner spn_TopSpeed "Top Speed" range:[0,500,1] type:#integer
		spinner spn_To60Time "0-60 Time (secs)" range:[0,50,0.1] type:#float
		spinner spn_Weight "Weight (tons)" range:[0,50,0.1] type:#float
		spinner spn_Toughness "Toughness" range:[0,50,0.1] type:#float
		spinner spn_UnlockLevel "Unlock Level" range:[-1,50,1] type:#integer
		label lbl_Suspension "Suspension"
		label lbl_MaxCompression "Max Compression" across:1 align:#right
		checkbox chk_MaxCompression_Active "" default:false  across:2 width:15
		spinner spn_MaxCompression "" range:[0,100,1] type:#float fieldwidth:40 align:#right
		label lbl_MaxExtension "Max Extension" across:1 align:#right
		checkbox chk_MaxExtension_Active "" default:false  across:2 width:15
		spinner spn_MaxExtension "" range:[0,100,1] type:#float fieldwidth:40 align:#right
		label lbl_MaxSteeringLock "Max SteeringLock" across:1 align:#right
		checkbox chk_MaxSteeringLock_Active "" default:false  across:2 width:15
		spinner spn_MaxSteeringLock "" range:[0,100,1] type:#float fieldwidth:40 align:#right
		label lbl_RideHeight "Ride Height" across:1 align:#right
		checkbox chk_RideHeight_Active "" default:false  across:2 width:15
		spinner spn_RideHeight "" range:[0,100,1] type:#float fieldwidth:40 align:#right
	)

	parameters wheels rollout:VehicleCFGWheelsRollout
	(
		WheelNames type:#stringTab tabSizeVariable:true
		WheelLocalisedNames type:#stringTab tabSizeVariable:true
		FRWheelFolderNames type:#stringTab tabSizeVariable:true
		FLWheelFolderNames type:#stringTab tabSizeVariable:true
		RRWheelFolderNames type:#stringTab tabSizeVariable:true
		RLWheelFolderNames type:#stringTab tabSizeVariable:true
		D4WheelFolderNames type:#stringTab tabSizeVariable:true
		D5WheelFolderNames type:#stringTab tabSizeVariable:true
		D6WheelFolderNames type:#stringTab tabSizeVariable:true
		D7WheelFolderNames type:#stringTab tabSizeVariable:true
		D8WheelFolderNames type:#stringTab tabSizeVariable:true
		D9WheelFolderNames type:#stringTab tabSizeVariable:true
		D10WheelFolderNames type:#stringTab tabSizeVariable:true
		D11WheelFolderNames type:#stringTab tabSizeVariable:true
		GarageSetFolderNames type:#stringTab tabSizeVariable:true
	)
	rollout VehicleCFGWheelsRollout "Wheels"
	(
		button but_AddToWheels "Add" across:2
		button but_DeleteFromWheels "Delete" across:2
		dotnetcontrol lv_Wheels "listview" height: 100
		checkbox chk_AllWheelsTheSame "All Wheels Use Same Model" default: true


		edittext txt_wheelName "Wheel Name" labelOntop:true
		edittext txt_wheelLocalisedName "Localised Name" labelOntop:true
		
		edittext txt_frwheelFolderName "Wheel FR Folder Name" labelOntop:true
		edittext txt_flwheelFolderName "Wheel FL Folder Name" labelOntop:true
		edittext txt_rrwheelFolderName "Wheel RR Folder Name" labelOntop:true
		edittext txt_rlwheelFolderName "Wheel RL Folder Name" labelOntop:true
		checkbox chk_showExtraWheels "Show extra wheels?" visible:false
		edittext txt_d4wheelFolderName "Wheel 5 Folder Name" labelOntop:true
		edittext txt_d5wheelFolderName "Wheel 6 Folder Name" labelOntop:true
		edittext txt_d6wheelFolderName "Wheel 7 Folder Name" labelOntop:true
		edittext txt_d7wheelFolderName "Wheel 8 Folder Name" labelOntop:true
		edittext txt_d8wheelFolderName "Wheel 9 Folder Name" labelOntop:true
		edittext txt_d9wheelFolderName "Wheel 10 Folder Name" labelOntop:true
		edittext txt_d10wheelFolderName "Wheel 11 Folder Name" labelOntop:true
		edittext txt_d11wheelFolderName "Wheel 12 Folder Name" labelOntop:true
		edittext txt_garageSetFolderNames "Garage Set Folder Name" labelOntop:true

		fn AddWheel wheelName:undefined localisedName:undefined folderName:"default_eagle_R" = (
			if wheelName == undefined then (
				wheelName = "set"+((WheelNames.count + 1) as string )
			)
			if localisedName == undefined then (
				localisedName = "Wheel Set "+((WheelNames.count + 1) as string )
			)
			append WheelNames wheelName
			append WheelLocalisedNames localisedName
			append FRWheelFolderNames folderName
			append FLWheelFolderNames folderName
			append RRWheelFolderNames folderName
			append RLWheelFolderNames folderName
			append D4WheelFolderNames ""
			append D5WheelFolderNames ""
			append D6WheelFolderNames ""
			append D7WheelFolderNames ""
			append D8WheelFolderNames ""
			append D9WheelFolderNames ""
			append D10WheelFolderNames ""
			append D11WheelFolderNames ""
			append GarageSetFolderNames ""
				lv_Wheels.Items.add wheelName
		)
		fn UpdateWheel =  (
			if lv_Wheels.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_Wheels.Items.item[lv_Wheels.SelectedIndices.Item[0]].text
				wheelIndex = finditem WheelNames selectedItem

				WheelNames[wheelIndex] = txt_wheelName.text
				WheelLocalisedNames[wheelIndex] = txt_wheelLocalisedName.text
				FRWheelFolderNames[wheelIndex] = txt_frwheelFolderName.text
				FLWheelFolderNames[wheelIndex] = txt_flwheelFolderName.text
				RRWheelFolderNames[wheelIndex] = txt_rrwheelFolderName.text
				RLWheelFolderNames[wheelIndex] = txt_rlwheelFolderName.text
				D4WheelFolderNames[wheelIndex] = txt_d4wheelFolderName.text
				D5WheelFolderNames[wheelIndex] = txt_d5wheelFolderName.text
				D6WheelFolderNames[wheelIndex] = txt_d6wheelFolderName.text
				D7WheelFolderNames[wheelIndex] = txt_d7wheelFolderName.text
				D8WheelFolderNames[wheelIndex] = txt_d8wheelFolderName.text
				D9WheelFolderNames[wheelIndex] = txt_d9wheelFolderName.text
				D10WheelFolderNames[wheelIndex] = txt_d10wheelFolderName.text
				D11WheelFolderNames[wheelIndex] = txt_d11wheelFolderName.text
				GarageSetFolderNames[wheelIndex] = txt_garageSetFolderNames.text
				lv_Wheels.Items.item[lv_Wheels.SelectedIndices.Item[0]].text = txt_wheelName.text
			)	
		)
		fn ToggleExtraWheels state = (

			if state or true then (
				txt_d4wheelFolderName.visible = true
				txt_d5wheelFolderName.visible = true
				txt_d6wheelFolderName.visible = true
				txt_d7wheelFolderName.visible = true
				txt_d8wheelFolderName.visible = true
				txt_d9wheelFolderName.visible = true
				txt_d10wheelFolderName.visible = true
				txt_d11wheelFolderName.visible = true
				txt_garageSetFolderNames.visible = true

			)
			else (
				txt_d4wheelFolderName.visible = false
				txt_d5wheelFolderName.visible = false
				txt_d6wheelFolderName.visible = false
				txt_d7wheelFolderName.visible = false
				txt_d8wheelFolderName.visible = false
				txt_d9wheelFolderName.visible = false
				txt_d10wheelFolderName.visible = false
				txt_d11wheelFolderName.visible = false
				txt_garageSetFolderNames.visible = false

			)
		)
		on VehicleCFGWheelsRollout open do (

			lv_Wheels.view  = (dotnetclass "view").details
			lv_Wheels.fullrowselect= true
			lv_Wheels.gridlines = true
			lv_Wheels.multiselect =false
			lv_Wheels.columns.add "Wheel" 110
			for i=1 to WheelNames.count do
			(
				lv_Wheels.Items.add WheelNames[i]
			)
			if WheelNames.count < 1 then (
				AddWheel wheelName:"default" localisedName:"Default"
			)
			ToggleExtraWheels chk_showExtraWheels.checked
				
		)

		on txt_wheelLocalisedName changed val do ( UpdateWheel() )
		on txt_frwheelFolderName changed val do ( UpdateWheel() )
		on txt_flwheelFolderName changed val do ( UpdateWheel() )
		on txt_rrwheelFolderName changed val do ( UpdateWheel() )
		on txt_rlwheelFolderName changed val do ( UpdateWheel() )
		on txt_d4wheelFolderName changed val do ( UpdateWheel() )
		on txt_d5wheelFolderName changed val do ( UpdateWheel() )
		on txt_d6wheelFolderName changed val do ( UpdateWheel() )
		on txt_d7wheelFolderName changed val do ( UpdateWheel() )
		on txt_d8wheelFolderName changed val do ( UpdateWheel() )
		on txt_d9wheelFolderName changed val do ( UpdateWheel() )
		on txt_d10wheelFolderName changed val do ( UpdateWheel() )
		on txt_d11wheelFolderName changed val do ( UpdateWheel() )
		on txt_garageSetFolderNames changed val do ( UpdateWheel() )

		on lv_Wheels selectedindexchanged do
		(
			if lv_Wheels.SelectedIndices.count > 0 then 
			(
				but_DeleteFromWheels.enabled = true
				selectedItem = lv_Wheels.Items.item[lv_Wheels.SelectedIndices.Item[0]].text
				wheelIndex = finditem WheelNames selectedItem
				txt_wheelName.text = WheelNames[wheelIndex]
				txt_wheelLocalisedName.text = WheelLocalisedNames[wheelIndex]
				txt_frwheelFolderName.text = FRWheelFolderNames[wheelIndex]
				txt_flwheelFolderName.text = FLWheelFolderNames[wheelIndex]
				txt_rrwheelFolderName.text = RRWheelFolderNames[wheelIndex]
				txt_rlwheelFolderName.text = RLWheelFolderNames[wheelIndex]
				chk_showExtraWheels.checked = D4WheelFolderNames[wheelIndex] != ""
				ToggleExtraWheels chk_showExtraWheels.checked
				
				txt_d4wheelFolderName.text = D4WheelFolderNames[wheelIndex]
				txt_d5wheelFolderName.text = D5WheelFolderNames[wheelIndex]
				txt_d6wheelFolderName.text = D6WheelFolderNames[wheelIndex]
				txt_d7wheelFolderName.text = D7WheelFolderNames[wheelIndex]
				txt_d8wheelFolderName.text = D8WheelFolderNames[wheelIndex]
				txt_d9wheelFolderName.text = D9WheelFolderNames[wheelIndex]
				txt_d10wheelFolderName.text = D10WheelFolderNames[wheelIndex]
				txt_d11wheelFolderName.text = D11WheelFolderNames[wheelIndex]
				txt_garageSetFolderNames.text = GarageSetFolderNames[wheelIndex]
			)
			else (
				but_DeleteFromWheels.enabled = false
			)
		)
		on chk_showExtraWheels changed state do (
			ToggleExtraWheels state
		)
		on but_AddToWheels pressed do (
			AddWheel()
		)
		on but_DeleteFromWheels pressed do (
			if lv_Wheels.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_Wheels.Items.item[lv_Wheels.SelectedIndices.Item[0]].text
				selectedIndex  = finditem WheelNames selectedItem
				deleteitem WheelNames selectedIndex
				deleteitem WheelLocalisedNames selectedIndex
				deleteitem FRWheelFolderNames selectedIndex
				deleteitem FLWheelFolderNames selectedIndex
				deleteitem RRWheelFolderNames selectedIndex
				deleteitem RLWheelFolderNames selectedIndex
				deleteitem D4WheelFolderNames selectedIndex
				deleteitem D5WheelFolderNames selectedIndex
				deleteitem D6WheelFolderNames selectedIndex
				deleteitem D7WheelFolderNames selectedIndex
				deleteitem D8WheelFolderNames selectedIndex
				deleteitem D9WheelFolderNames selectedIndex
				deleteitem D10WheelFolderNames selectedIndex
				deleteitem D11WheelFolderNames selectedIndex
				deleteitem GarageSetFolderNames selectedIndex 
				lv_Wheels.Item.removeAt lv_Wheels.selectedIndices.Item[0]
			)
		)
	)

	parameters wheelModules rollout:VehicleCFGWheelModulesRollout
	(

		SkidMarksImage type:#string default:"skidmark" ui:txt_SkidMarksImage
		TyreParticlesVFX type:#string default:"effects.drift" ui:txt_TyreParticlesVFX
		OnlyTrails type:#boolean default:false ui:chk_OnlyTrails
		SkidNoises type:#string default:"sounds\\tyre\\skid1,sounds\\tyre\\skid2" ui:txt_SkidNoises
		UseScrapeSounds type:#boolean default: false ui:chk_UseScrapeSounds
		ScrapeIndex type:#integer default:1 ui:spn_ScrapeIndex
		volume type:#integer default:10 ui:spn_Volume
	)
	rollout VehicleCFGWheelModulesRollout "Wheel Module Settings"
	(
		group "Skid marks"
		(
			edittext txt_SkidMarksImage "Skid Marks Image" labelontop:true
		)
		group "Tyre Particles"
		(
			edittext txt_TyreParticlesVFX "Tyre Particle VFX" labelontop:true
			checkbox chk_OnlyTrails "Use Only Trails"
		)
		group "Wheel Sounds"
		(
			edittext txt_SkidNoises "Skid Noises" labelontop:true
			checkbox chk_UseScrapeSounds "Use Scrape Sounds"
			spinner spn_ScrapeIndex "Scrape Index" type:#integer range: [0,1000,1]
			spinner spn_Volume "Scrape Volume" type:#integer range: [0,1000,1]
		)
	)

	parameters attachements rollout:VehicleCFGAttachmentRollout
	(
		ExhaustParticleVFX type:#string default:"effects.f_yankv8_exhaustsmoke02" ui:txt_ExhaustParticleVFX
		ExhaustParticleUnderwaterVFX type:#string default:"effects.f_underwaterexhaust" ui:txt_ExhaustParticleUnderwaterVFX
		ExhaustAnchor type:#string default:"Exhaust" ui:txt_ExhaustAnchor
		ExhaustMultiplier type:#float default:0 ui:spn_ExhaustMultiplier
		ExhaustNeutralMultiplier type:#float default:0 ui:spn_ExhaustNeutralMultiplier
		HornSound type:#string default:"generic02_horn" ui:txt_HornSound
		ReverseLightSound type:#string default:"" ui:txt_ReverseLightSound
		ContinuousSound type:#string default:"" ui:txt_ContinuousSound
		ContinuousSound_Lump type:#string default:"" ui:txt_ContinuousSound_Lump

		FMODEngine type:#string default:"Euro_V8" ui:txt_FMODEngine
		FMODEngine_RPMSmooth type:#float default:0.35 ui:spn_FMODEngine_RPMSmooth
		FMODEngine_OnLoadSmooth type:#float default:0.45 ui:spn_FMODEngine_OnLoadSmooth
		FMODEngine_OffLoadSmooth type:#float default:15 ui:spn_FMODEngine_OffLoadSmooth
		FMODEngine_LoadMin type:#float default:0 ui:spn_FMODEngine_LoadMin
		FMODEngine_MaxSpeed type:#float default:0 ui:spn_FMODEngine_MaxSpeed
		FMODEngine_MaxRevs type:#float default:0 ui:spn_FMODEngine_MaxRevs
		FMODEngine_MinRevs type:#float default:0 ui:spn_FMODEngine_MinRevs

	)

	rollout VehicleCFGAttachmentRollout "Attachment Settings"
	(
		group "Exhaust" (
			edittext txt_ExhaustParticleVFX "Exhaust Particle VFX" labelontop:true
			edittext txt_ExhaustParticleUnderwaterVFX "Exhaust Underwater Particle VFX" labelontop:true
			edittext txt_ExhaustAnchor "Exhaust Anchor" labelontop:true
			spinner spn_ExhaustMultiplier "Exhaust Multiplier" type:#float
			spinner spn_ExhaustNeutralMultiplier "Exhaust Neutral Multiplier" type:#float

		)
		group "Sounds" (
			edittext txt_HornSound "Horn Sound" labelontop:true
			edittext txt_ReverseLightSound "Reverse Sound" labelontop:true
			edittext txt_ContinuousSound "Continuous Sound" labelontop:true
			edittext txt_ContinuousSound_Lump "Continuous Sound Object" labelontop:true

		)
		group "Engine Sound" (
		    edittext txt_FMODEngine "Engine Type" labelontop:true
		    spinner spn_FMODEngine_RPMSmooth "RPM Smooth" range:[0, 100, 0.35] type:#float
		    spinner spn_FMODEngine_OnLoadSmooth "On Load Smooth" range:[0, 100, 0.45] type:#float
		    spinner spn_FMODEngine_OffLoadSmooth "Off Load Smooth" range:[0, 100, 15] type:#float
		    spinner spn_FMODEngine_LoadMin "Load Min" range:[0, 300, 0] type:#float
		    spinner spn_FMODEngine_MaxSpeed "Max Speed" range:[0, 300, 0] type:#float
		    spinner spn_FMODEngine_MinRevs "Min Revs" range:[0, 300, 0] type:#float
		    spinner spn_FMODEngine_MaxRevs "Max Revs" range:[0, 300, 0] type:#float
		)
	)
	parameters cams rollout:VehicleCFGCameraRollout 
	(

		UseGarageCameraOffset type:#boolean default: false ui:chk_GarageCamera
		GarageCameraOffset_x type:#float ui:spn_GarageCamera_x
		GarageCameraOffset_y type:#float ui:spn_GarageCamera_y
		GarageCameraOffset_z type:#float ui:spn_GarageCamera_z
		InCarCameraPos_x type:#float ui:spn_InCarCamera_x
		InCarCameraPos_y type:#float ui:spn_InCarCamera_y
		InCarCameraPos_z type:#float ui:spn_InCarCamera_z
	)
	rollout VehicleCFGCameraRollout "Camera" (

		checkbox chk_GarageCamera "Garage Camera Offset" acrosss:1 default:false
		spinner spn_GarageCamera_x "" range:[-100,100,0] type:#float fieldwidth:40 across:3
		spinner spn_GarageCamera_y "" range:[-100,100,0] type:#float fieldwidth:40 across:3
		spinner spn_GarageCamera_z "" range:[-100,100,0] type:#float fieldwidth:40 across:3
		button btn_GarageCamera "Get Position From Selected Object"
		label lbl_InCarCamera "In Car Camera Position" acrosss:1
		spinner spn_InCarCamera_x "" range:[-100,100,0] type:#float fieldwidth:40 across:3
		spinner spn_InCarCamera_y "" range:[-100,100,0] type:#float fieldwidth:40 across:3
		spinner spn_InCarCamera_z "" range:[-100,100,0] type:#float fieldwidth:40 across:3
		button btn_InCarCamera "Get Position From Selected Object"
	)

	parameters driver rollout:VehicleCFGDriverRollout (
		EjectDriver type:#boolean default: true ui:chk_EjectDriver
		SmallDriver type:#boolean default: false ui:chk_SmallDriver
		Drivers type:#stringTab tabSizeVariable:true
		DriverSuffix type:#string default:"" ui:txt_DriverSuffix
	)

	rollout VehicleCFGDriverRollout "Drivers" (

		checkbox chk_EjectDriver "Eject Driver" acrosss:1 default:true
		checkbox chk_SmallDriver "Small Driver" acrosss:1 default:true
		edittext txt_DriverName "Drivers" labelOnTop:true fieldwidth: 100 across:2
		button but_AddToDrivers "Add"
		dotnetcontrol lv_Drivers "listview" height: 100
		button but_DeleteFromDrivers "Delete Selected"
		edittext txt_DriverSuffix "Driver Suffix" labelOntop:true

		on VehicleCFGDriverRollout open  do (

			but_AddToDrivers.pos = [120, but_AddToDrivers.pos.y+15]
			lv_Drivers.view  = (dotnetclass "view").details
			lv_Drivers.fullrowselect= true
			lv_Drivers.gridlines = true
			lv_Drivers.multiselect =false
			lv_Drivers.columns.add "Driver" 110
			for i=1 to Drivers.count do
			(
				lv_Drivers.Items.add Drivers[i]
			)
		)
		on but_DeleteFromDrivers pressed do
		(
			if lv_Drivers.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_Drivers.SelectedIndices.Item[0]
				lv_Drivers.Items.removeat selectedIndex
				deleteItem Drivers (selectedIndex+1)
			)
		)
		on but_AddToDrivers pressed do
		(
			lv_Drivers.Items.add (txt_DriverName.text)
			append Drivers txt_DriverName.text
		)
	)

	parameters materialMap rollout:VehicleCFGMaterialMapRollout (
		PaintJobNames type:#stringTab tabSizeVariable:true
		PaintJobLocalisedNames type:#stringTab tabSizeVariable:true
		ShrapneColours type:#point3Tab tabSizeVariable:true
		MatReplacements type:#stringTab tabSizeVariable:true
	)
	rollout VehicleCFGMaterialMapRollout "Paint Jobs" (

		button but_AddToMatMap "Add" across:2
		button but_DeleteFromMatMap "Delete" across:2
		dotnetcontrol lv_MatMaps "listview" height: 100
		

		edittext txt_paintJobName "Paint Job Name" labelOntop:true
		edittext txt_paintJobLocalisedName "Localised Name" labelOntop:true
		label lbl_ShrapnelColor "Shrapnel Colour"
		spinner spn_Shrapnel_R "" range:[0, 255, 1] across:3 type:#integer	
		spinner spn_Shrapnel_G "" range:[0, 255, 1] across:3 type:#integer	
		spinner spn_Shrapnel_B "" range:[0, 255, 1] across:3 type:#integer	
		
		label lbl_Replacements "Material Replacements"
		button but_AddToMatToReplace "Add" across:2
		button but_DeleteFromMatToReplace "Delete" across:2
		dotnetcontrol lv_Replacement "listview" height: 100
		edittext txt_matToReplace "Source Material"		
		edittext txt_matToUse "Target Material"		


		fn AddPaintJob paintJobName:undefined localisedName:undefined sourceMat:"" targetMat:"" = (
			if paintJobName == undefined then (
				paintJobName = "paint"+((paintJobNames.count + 1) as string )
			)
			if localisedName == undefined then (
				localisedName = "Paint Job Set "+((paintJobNames.count + 1) as string )
			)
			append paintJobNames paintJobName
			append paintJobLocalisedNames localisedName
			append MatReplacements	sourceMat
			append ShrapneColours [255,0,255]
			lv_MatMaps.Items.add paintJobName

		)

		fn UpdatePaintJob = (
			if lv_MatMaps.SelectedIndices.count > 0 then (
				selectedItem = lv_MatMaps.Items.item[lv_MatMaps.SelectedIndices.Item[0]].text

				PaintJobNames[selectedIndex] = txt_paintJobName.text
				PaintJobLocalisedNames[selectedIndex] = txt_paintJobLocalisedName.text
				ShrapneColours[selectedIndex] = [spn_Shrapnel_R.value,spn_Shrapnel_G.value,spn_Shrapnel_B.value]
			)
		)

		fn SetReplacement source target = (

			if lv_MatMaps.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_MatMaps.Items.item[lv_MatMaps.SelectedIndices.Item[0]].text
				paintJobIndex = finditem PaintJobNames selectedItem
				replacements = filterstring MatReplacements[paintJobIndex] ";"
				MatReplacements[paintJobIndex] = ""

				for replacement in replacements do (
					splitReplacement = FilterString replacement ":"
					if (toupper splitReplacement[1]) == (touppper source) then (
						splitReplacement[2] = target
					)
					MatReplacements[paintJobIndex] = MatReplacements[paintJobIndex] + splitReplacement[1]+":"+splitReplacement[2]+";"
				)
			)
		)
		fn DeleteReplacement source = (
			
			if lv_MatMaps.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_MatMaps.Items.item[lv_MatMaps.SelectedIndices.Item[0]].text
				paintJobIndex = finditem WheelNames selectedItem
				replacements = filterstring MatReplacements[paintJobIndex] ";"
				MatReplacements[paintJobIndex] = ""

				for replacement in replacements do (
					splitReplacement = FilterString replacement ":"
					if (toupper splitReplacement[1]) == (touppper source) then (
						splitReplacement[2] = target
					)
					MatReplacements[paintJobIndex] = MatReplacements[paintJobIndex] + splitReplacement[1]+":"+splitReplacement[2]+";"
				)
			)
		)
		fn SetupReplacementsList replacementString = (
			lv_Replacement.Items.clear()
			replacements = filterstring replacementString ";"
			for repalacement in replacements do (
				splitReplacement = filterstring replacement ":"
				lvItem = dotnetobject "listviewitem" splitReplacement[1]
				lvItem.subitems.add splitReplacement[2]
				lv_Replacement.Items.add lvItem
			)

		)
		
		on VehicleCFGMaterialMapRollout open do (

			lv_MatMaps.view  = (dotnetclass "view").details
			lv_MatMaps.fullrowselect= true
			lv_MatMaps.gridlines = true
			lv_MatMaps.multiselect =false
			lv_MatMaps.columns.add "Paint Job" 110
			for i=1 to PaintJobNames.count do
			(
				lv_MatMaps.Items.add PaintJobNames[i]
			)
			if PaintJobNames.count < 1 then (
				AddPaintJob paintJobName:"default" localisedName:"Default Paint Job"
			)
			lv_Replacement.view  = (dotnetclass "view").details
			lv_Replacement.fullrowselect= true
			lv_Replacement.gridlines = true
			lv_Replacement.multiselect =false
			lv_Replacement.columns.add "Source" 55
			lv_Replacement.columns.add "Target" 55
			
		)
		on lv_MatMaps selectedindexchanged do
		(
			if lv_MatMaps.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_MatMaps.Items.item[lv_MatMaps.SelectedIndices.Item[0]].text
				paintJobIndex = finditem PaintJobNames selectedItem
				txt_paintJobName.text = PaintJobNames[paintJobIndex]
				txt_paintJobLocalisedName.text = PaintJobLocalisedNames[paintJobIndex]
				spn_Shrapnel_R.value = ShrapneColours[paintJobIndex].x
				spn_Shrapnel_G.value = ShrapneColours[paintJobIndex].y
				spn_Shrapnel_B.value = ShrapneColours[paintJobIndex].z

				SetupReplacementsList MatReplacements[paintJobIndex]
				
			)
			else(
				lv_Replacement.Items.clear()
			)
		) 
		on lv_Replacement selectedindexchanged do (
			if lv_Replacement.SelectedIndices.count >0 then (
					replacements = filterstring replacementString ";"
					splitReplacement = filterstring replacement[replacements[lv_Replacement.SelectedIndices[0]]] ":"
					txt_matToReplace.text = splitReplacement[1]
					txt_matToUse.text = splitReplacement[2]
			)
		)

		on but_AddToMatMap pressed do (
			AddPaintJob()
		)
		on but_DeleteFromMatMap pressed do (
			if lv_MatMaps.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_MatMaps.Items.item[lv_MatMaps.SelectedIndices.Item[0]].text
				selectedIndex  = finditem PaintJobNames selectedItem
				deleteitem PaintJobNames selectedIndex
				deleteitem PaintJobLocalisedNames selectedIndex
				deleteitem ShrapneColours selectedIndex
				deleteitem MatReplacements selectedIndex
				deleteitem PaintJobNames selectedIndex
				lv_MatMaps.Item.removeAt lv_MatMaps.selectedIndices.Item[0]
			)
		)
		on txt_paintJobName changed val do ( UpdatePaintJob() )
		on txt_paintJobLocalisedName changed val do ( UpdatePaintJob() )
		on spn_Shrapnel_R changed val do ( UpdatePaintJob() )
		on spn_Shrapnel_G changed val do ( UpdatePaintJob() )
		on spn_Shrapnel_B changed val do ( UpdatePaintJob() )
		on txt_matToUse changed val do ( SetReplacement txt_matToReplace.text val)
		on txt_matToReplace changed val do ( SetReplacement val txt_matToUse.text)
	)

	parameters trailers rollout: VehicleCFGTrailersRollout
	(
		HumanTrailers type:#stringTab tabSizeVariable:true
		AITrailers type:#stringTab tabSizeVariable:true
		MPTrailers type:#stringTab tabSizeVariable:true
	)
	rollout VehicleCFGTrailersRollout "Trailers" (
		group "Human Trailers" (
			edittext txt_HumanTrailerName "" fieldwidth: 100 across:2
			button but_AddToHumanTrailers "Add"
			dotnetcontrol lv_HumanTrailers "listview" height: 100
			button but_DeleteFromHumanTrailers "Delete Selected"
		)
		group "MP Trailers" (
			edittext txt_MPTrailerName "" fieldwidth: 100 across:2
			button but_AddToMPTrailers "Add"
			dotnetcontrol lv_MPTrailers "listview" height: 100
			button but_DeleteFromMPTrailers "Delete Selected"
		)
		group "AI Trailers" (
			edittext txt_AITrailerName "" fieldwidth: 100 across:2
			button but_AddToAITrailers "Add"
			dotnetcontrol lv_AITrailers "listview" height: 100
			button but_DeleteFromAITrailers "Delete Selected"
		)

		on VehicleCFGTrailersRollout open do (
			lv_HumanTrailers.view  = (dotnetclass "view").details
			lv_HumanTrailers.fullrowselect= true
			lv_HumanTrailers.gridlines = true
			lv_HumanTrailers.multiselect =false
			lv_HumanTrailers.columns.add "Trailer" 110
			for i=1 to HumanTrailers.count do
			(
				lv_HumanTrailers.Items.add HumanTrailers[i]
			)

			lv_MPTrailers.view  = (dotnetclass "view").details
			lv_MPTrailers.fullrowselect= true
			lv_MPTrailers.gridlines = true
			lv_MPTrailers.multiselect =false
			lv_MPTrailers.columns.add "Trailer" 110
			for i=1 to MPTrailers.count do
			(
				lv_MPTrailers.Items.add MPTrailers[i]
			)

			lv_AITrailers.view  = (dotnetclass "view").details
			lv_AITrailers.fullrowselect= true
			lv_AITrailers.gridlines = true
			lv_AITrailers.multiselect =false
			lv_AITrailers.columns.add "Trailer" 110
			for i=1 to AITrailers.count do
			(
				lv_AITrailers.Items.add AITrailers[i]
			)
		)

		on but_AddToHumanTrailers pressed do (
			if txt_HumanTrailerName.text != "" then (
				append HumanTrailers txt_HumanTrailerName.text
				lv_HumanTrailers.Items.add txt_HumanTrailerName.text
			)
		)
		on but_AddToMPTrailers pressed do (
			if txt_MPTrailerName.text != "" then (
				append MPTrailers txt_MPTrailerName.text
				lv_MPTrailers.Items.add txt_MPTrailerName.text
			)
		)
		on but_AddToAITrailers pressed do (
			if txt_AITrailerName.text != "" then (
				append AITrailers txt_AITrailerName.text
				lv_AITrailers.Items.add txt_AITrailerName.text
			)
		)

		on but_DeleteFromHumanTrailers pressed do (
			if lv_HumanTrailers.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_HumanTrailers.Items.item[lv_HumanTrailers.SelectedIndices.Item[0]].text
				trailerIndex = finditem HumanTrailers selectedItem

				deleteItem HumanTrailers (trailerIndex + 1)
				lv_HumanTrailers.Item.removeAt lv_HumanTrailers.selectedIndices.Item[0]
			)
		)
		on but_DeleteFromMPTrailers pressed do (
			if lv_MPTrailers.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_MPTrailers.Items.item[lv_MPTrailers.SelectedIndices.Item[0]].text
				trailerIndex = finditem MPTrailers selectedItem

				deleteItem MPTrailers (trailerIndex + 1)
				lv_MPTrailers.Item.removeAt lv_MPTrailers.selectedIndices.Item[0]
			)
		)
		on but_DeleteFromAITrailers pressed do (
			if lv_AITrailers.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_AITrailers.Items.item[lv_AITrailers.SelectedIndices.Item[0]].text
				trailerIndex = finditem AITrailers selectedItem

				deleteItem AITrailers (trailerIndex + 1)
				lv_AITrailers.Item.removeAt lv_AITrailers.selectedIndices.Item[0]
			)
		)
	)
)

/*********************************
***** Complicated Wheel ATTRIBUTES
*********************************/
ComplicatedWheelAttribute = attributes ComplicatedWheel_Def attribID:#(0x3f78e276, 0x54cd3c7) version:1
(
	parameters main rollout:ComplicatedWheelRollout
	(
		RotateTyre type:#boolean default:false ui:chk_RotateTyre
		ScrollTyreTiles type:#integer default:1 ui:spn_ScrollTyreTiles
		UseSkidmarkWidth type:#boolean default:false ui:chk_UseSkidmarkWidth
		SkidmarkWidth type:#float default:1.0 ui:spn_SkidmarkWidth
		PunctureStage_Value type:#inttab tabSizeVariable:true
		PunctureStage_Mesh type:#stringtab tabSizeVariable:true
		TyreMaterial type:#string default:"TYRE" ui:txt_TyreMaterial
		TyrePuncturedMaterial type:#string default:"TYRE_PUNCTURED" ui:txt_TyrePuncturedMaterial
		TyreDerimmedMaterial type:#string default:"TYRE_PUNCTURED" ui:txt_TyreDerimmedMaterial
		TyreDetachedMaterial type:#string default:"TYRE_PUNCTURED" ui:txt_TyreDetachedMaterial
	)

	parameters weapons rollout:ComplicatedWheelWeaponsRollout
	(
		HasBlades type:#boolean default:false ui:chk_HasBlades
		HasDistinctBlades type:#boolean default:false ui:chk_HasDistinctBlades
		BladeRadius type:#float default:1 ui:spn_BladeRadius

		HasSimpleWeapon type:#boolean default:false ui:chk_HasSimpleWeapon
		SimpleWeapon type:#float default:1 ui:spn_SimpleWeapon

		HasVehicleWeapon type:#boolean default:false ui:chk_HasVehicleWeapon
		VehicleWeaponScript type:#string default:"Vehicle_TyreRipper" ui:txt_VehicleWeaponScript
		VehicleWeaponVariable type:#string default:"WHEEL_SPEED" ui:txt_VehicleWeaponVariable
		VehicleWeaponMultiplier type:#float default:0.1 ui:spn_VehicleWeaponMultiplier
		VehicleWeaponMin type:#float default:1 ui:spn_VehicleWeaponMin
		VehicleWeaponMax type:#float default:3.0 ui:spn_VehicleWeaponMax

		HasPedWeapon type:#boolean default:false ui:chk_HasPedWeapon
		PedWeaponScript type:#string default:"Ped_Explode" ui:txt_PedWeaponScript
		PedWeaponVariable type:#string default:"WHEEL_SPEED" ui:txt_PedWeaponVariable
		PedWeaponMultiplier type:#float default:0.1 ui:spn_PedWeaponMultiplier
		PedWeaponMin type:#float default:1 ui:spn_PedWeaponMin
		PedWeaponMax type:#float default:3.0 ui:spn_PedWeaponMax

		HasAccessoryWeapon type:#boolean default:false ui:chk_HasAccessoryWeapon
		AccessoryWeaponScript type:#string default:"Accessory_Rip_X" ui:txt_AccessoryWeaponScript
		AccessoryWeaponVariable type:#string default:"WHEEL_SPEED" ui:txt_AccessoryWeaponVariable
		AccessoryWeaponMultiplier type:#float default:0.1 ui:spn_AccessoryWeaponMultiplier
		AccessoryWeaponMin type:#float default:1 ui:spn_AccessoryWeaponMin
		AccessoryWeaponMax type:#float default:3.0 ui:spn_AccessoryWeaponMax
	)

	parameters forcefactors rollout:ComplicatedWheelForceFactorsRollout
	(
		WheelBoundsXFactor type:#float default:1.2 ui:spn_WheelBoundsXFactor
		WheelBoundsYZFactor type:#float default:1.1 ui:spn_WheelBoundsYZFactor
		WheelDamageMaxRandom type:#float default:5.0 ui:spn_WheelDamageMaxRandom
		WheelDamageWeldThreshold type:#float default:0.1 ui:spn_WheelDamageWeldThreshold
		TyreDamageWeldThreshold type:#float default:0.01 ui:spn_TyreDamageWeldThreshold
		TyreDamageWeldMax type:#float default:0.7 ui:spn_TyreDamageWeldMax
	)

	parameters positionalfactors rollout:ComplicatedWheelPositionalFactorsRollout
	(
		PuncturedHeightPercentage type:#float default:20.0 ui:spn_PuncturedHeightPercentage
		DerimmedHeightPercentage type:#float default:60.0 ui:spn_DerimmedHeightPercentage
		DerimmedTyrePenetrationPercentage type:#float default:20.0 ui:spn_DerimmedTyrePenetrationPercentage
		DerimmedTyreTopPenetrationPercentage type:#float default:20.0 ui:spn_DerimmedTyreTopPenetrationPercentage
	)

	parameters physicsfactors rollout:ComplicatedWheelPhysicsFactorsRollout
	(
		-- Rolling resistance caused by punctures (higher number means more resistance)
			Punctured_RollingResistance type:#float default:0.1 ui:spn_Punctured_RollingResistance
-- Grip attenuator caused by punctures (lower number means less grip)
			Punctured_FrictionFactor type:#float default:0.8 ui:spn_Punctured_FrictionFactor
-- Rolling resistance caused by de-rimmed tyres (higher number means more resistance)
			Derimmed_RollingResistance type:#float default:0.1 ui:spn_Derimmed_RollingResistance
-- Grip attenuator caused by de-rimmed tyres (lower number means less grip)
			Derimmed_FrictionFactor type:#float default:0.6 ui:spn_Derimmed_FrictionFactor
-- Rolling resistance caused by detached tyres (higher number means more resistance)
			TyreDetached_RollingResistance type:#float default:0.1 ui:spn_TyreDetached_RollingResistance
-- Grip attenuator caused by detached tyres (lower number means less grip)
			TyreDetached_FrictionFactor type:#float default:0.4 ui:spn_TyreDetached_FrictionFactor
-- Additional rolling resistance added to the above if the steering linkage is broken
			SteeringBroken_RollingResistance type:#float default:0.05 ui:spn_SteeringBroken_RollingResistance
-- Additional grip attenuator that multiplies the above if the steering linkage is broken
			SteeringBroken_FrictionFactor type:#float default:0.75 ui:spn_SteeringBroken_FrictionFactor
-- General Y-offset for damaged tyres to make sure they perfectly align with the ground
			Damaged_Tyre_Rim_Offset type:#float default:0.01 ui:spn_Damaged_Tyre_Rim_Offset
-- The time in seconds before a broken wheel returns to the car that the car is lifted
-- in order to make the wheel more likely to fit without intersecting the ground
			Damage_WheelOnTime type:#float default:0.5 ui:spn_Damage_WheelOnTime
	)

	parameters derimmedtyeeffects rollout:ComplicatedWheelPhysicsDerimmedTyreEffectsRollout
	(
		-- Minimum spin-speed (in revolutions per second) of wheel before rim starts spinning 
-- inside a de-rimmed tye
			Derimmed_MaxSpinSpeedBeforeSlipping type:#float default:1.0 ui:spn_Derimmed_MaxSpinSpeedBeforeSlipping
-- The power (in the mathematical sense) that the rim's speed is risen to in order
-- to determine the diminished spinning of a derimmed tyre. So 0.33333 means that it
-- spins at the cube root of the rim speed. The smaller the number, the more a
-- derimmed tyre will lag behind the spinning of its rim.
			Derimmed_SpinSpeedSlipPower type:#float default:0.3333 ui:spn_Derimmed_SpinSpeedSlipPower
-- The fraction of the steering angle that a de-rimmed tyre steers at. 1 would mean that
-- it turns with the rim; 0 that it doesn't turn at all. 0.5 would mean that with the rim
-- at, say, 20 degrees, the tyre turns at 10 degrees.
			Derimmed_SlipAngleFactor type:#float default:0.75 ui:spn_Derimmed_SlipAngleFactor
-- The speed (in MPH) of the car at which derimmed tyres start to wobble in the Y axis
			Derimmed_MinSpeedForYWobble type:#float default:3.0 ui:spn_Derimmed_MinSpeedForYWobble
-- The speed (in MPH) of the car at which derimmed tyres are at max wobbliness in the Y axis
			Derimmed_MaxSpeedForYWobble type:#float default:30.0 ui:spn_Derimmed_MaxSpeedForYWobble
-- The maximum amount of wobbliness, in degrees of wobble around the Y axis, of de-rimmed tyres
-- (This will be at the speed defined above)
			Derimmed_YWobbleMaxAmplitude type:#float default:10.0 ui:spn_Derimmed_YWobbleMaxAmplitude
-- The maximum speed of wobbliness (in wobbles per second), of de-rimmed tyres
-- (This will be at the speed defined above)
			Derimmed_YWobbleMaxRate type:#float default:10.0 ui:spn_Derimmed_YWobbleMaxRate
-- The absolute maximum angle that a de-rimmed tyre can deflect in the Y axis, due to wobbling,
-- splip and any other combined factors. This prevents the tyre from cutting into the
-- rim too much.
			Derimmed_YWobbleMaxAngle type:#float default:20.0 ui:spn_Derimmed_YWobbleMaxAngle
-- The speed (in MPH) of the car at which a de-rimmed tyre shifts completely in the Z
-- axis (i.e. is dragged into the rim by the car's forward or backward movement)
			Derimmed_MaxZSpeed type:#float default:10.0 ui:spn_Derimmed_MaxZSpeed
-- The fraction of the tyre's radius that a de-rimmed tyre shifts completely in the Z
-- axis at the max speed given above
			Derimmed_ZShiftFactor type:#float default:0.3 ui:spn_Derimmed_ZShiftFactor
-- The sideways speed (in MPH) of the car at which a de-rimmed tyre shifts completely in the X
-- axis (i.e. is dragged across the inside or outside of the rim as car steers or slides)
			Derimmed_MaxXSpeed type:#float default:3.0 ui:spn_Derimmed_MaxXSpeed
-- The minimum amount as a fraction of the tyre's width that a de-rimmed tyre shifts in the X
-- axis. This is in order to make it 'hook' on either the inside or outside of the rim without
-- any mesh intersections
			Derimmed_MinXShift type:#float default:0.3 ui:spn_Derimmed_MinXShift
-- The maximum amount as a fraction of the tyre's width that a de-rimmed tyre shifts in the X
-- axis. This is in order to make it not move too far inside or outside of the rim and thus
-- cause mesh intersections
			Derimmed_MaxXShift type:#float default:0.7 ui:spn_Derimmed_MaxXShift
	)
	parameters bentaxles rollout:ComplicatedWheelBentAxlesRollout
	(
		-- The maximum angle that an axle can bend at
			BentAxle_MaxAngle type:#float default:10.0 ui:spn_BentAxle_MaxAngle
-- The X offset from the origin of the point in the rim that the axle bends
-- around. This is typically quite outboard in order to make it bend on the face where the wheel
-- bolts to the hub. Note that this is something that is quite likely to be overridden in a
-- particular wheel's folder.
			BentAxle_XOffset type:#float default:0.05 ui:spn_BentAxle_XOffset
-- The fraction of the bent axle angle that a de-rimmed tyre on a bent axle follows the wobbling
-- of the rim. So 1 would make it perfectly follow it; 0 would make the tyre not following the
-- wobbling axle at all.
			BentAxle_DerimmedTyreFactor type:#float default:0.5 ui:spn_BentAxle_DerimmedTyreFactor
	)

	parameters damagedwheelphysics rollout: ComplicatedWheelDamagedWheelPhysics
	(
		-- The mass of a detached tyre
			Physics_TyreMass type:#float default:5.0 ui:spn_Physics_TyreMass
-- The coefficient of restitution of a detached tyre (i.e. how bouncy it is)
			Physics_TyreRestitution type:#float default:1.5 ui:spn_Physics_TyreRestitution
-- The instant jump that a detaching tyre is given in order to make sure that it clears the
-- ground as it comes off the car
			Physics_TyreDetachUpOffset type:#float default:0.25 ui:spn_Physics_TyreDetachUpOffset
-- The speed (in m/s) upwards that a detaching tyre is given (on top of the car's velocity)
			Physics_TyreDetachUpThrust type:#float default:3.0 ui:spn_Physics_TyreDetachUpThrust
-- The speed (in m/s) outwardswards that a detaching tyre is given (on top of the car's velocity)
			Physics_TyreDetachOutThrust type:#float default:3.0 ui:spn_Physics_TyreDetachOutThrust
-- The mass of a detached rim
			Physics_RimMass type:#float default:15.0 ui:spn_Physics_RimMass
-- WHEEL ANIMATION SMOOTHING (Not really damage)
			Wheels_MaxCompressionRate type:#float default:4.0 ui:spn_Wheels_MaxCompressionRate
			Wheels_MaxExtensionRate type:#float default:2.0 ui:spn_Wheels_MaxExtensionRate
	)
	
	rollout ComplicatedWheelRollout "ComplicatedWheelRollout"
	(
		checkbox chk_RotateTyre "RotateTyre" default:false
		spinner spn_ScrollTyreTiles "ScrollTyreTiles" type:#integer default:false
		checkbox chk_UseSkidmarkWidth "" default:false across:2
		spinner spn_SkidmarkWidth "SkidmarkWidth" type:#float default:false

		group "Puncture Stages" (
			spinner spn_PunctureStage_Value "Stage" labelOnTop:true fieldwidth: 70 across:2
			edittext txt_PunctureStage_Mesh "CNT" labelOnTop:true fieldwidth: 130 across:2
			button but_AddToPunctureStage "Add"
			dotnetcontrol lv_PunctureStages "listview" height: 100
			button but_DeleteFromPunctureStage "Delete Selected"
		)
		edittext txt_TyreMaterial "TyreMaterial" type:#string default:"default_tyre"
		edittext txt_TyrePuncturedMaterial "TyrePuncturedMaterial" type:#string default:"default_tyre"
		edittext txt_TyreDerimmedMaterial "TyreDerimmedMaterial" type:#string default:"default_tyre"
		edittext txt_TyreDetachedMaterial "TyreDetachedMaterial" type:#string default:"default_tyre"

		on ComplicatedWheelRollout open do (

			lv_PunctureStages.view  = (dotnetclass "view").details
			lv_PunctureStages.fullrowselect= true
			lv_PunctureStages.gridlines = true
			lv_PunctureStages.multiselect =false
			lv_PunctureStages.columns.add "Stage" 35
			lv_PunctureStages.columns.add "CNT" 135
			for i=1 to PunctureStage_Value.count do
			(
				lvItem = dotnetobject "listviewitem" PunctureStage_Value[i]
				lvitem.subitems.add PunctureStage_Mesh[i]
				lv_PunctureStages.Items.add lvitem
			)
		)

		on but_AddToPunctureStage pressed do (
			stage = spn_PunctureStage_Value.value
			cnt = txt_PunctureStage_Mesh.text
			stageIndex = 0
			for i = 1 to PunctureStage_Value.count do (
				if PunctureStage_Value[i] > stage and stageIndex == 0 then (
					stageIndex = i
				)
			)
			if stageIndex == 0 then (
				append PunctureStage_Value stage
				append PunctureStage_Mesh cnt
			)
			else (
				insertItem stage PunctureStage_Value stageIndex
				insertItem cnt PunctureStage_Mesh stageIndex
			)
		)
		on but_DeleteFromPunctureStage pressed do (
			if lv_PunctureStages.SelectedIndices.count > 0 then (
				selectedIndex = lv_PunctureStages.SelectedIndices[0]
				lv_PunctureStages.Items.removeat selectedIndex
				deleteItem PunctureStage_Mesh (selectedIndex + 1)
				deleteItem PunctureStage_Value (selectedIndex + 1)
			)
		)
	)
	rollout ComplicatedWheelWeaponsRollout "ComplicatedWheelWeaponsRollout"
	(
		checkbox chk_HasBlades "HasBlades" default:false
		checkbox chk_HasDistinctBlades "HasDistinctBlades" default:false
		spinner spn_BladeRadius "BladeRadius" type:#float default:1
		checkbox chk_HasSimpleWeapon "HasSimpleWeapon" default:false
		spinner spn_SimpleWeapon "SimpleWeapon" type:#float default:1
		checkbox chk_HasVehicleWeapon "HasVehicleWeapon" default:false
		edittext txt_VehicleWeaponScript "VehicleWeaponScript" type:#string default:"Vehicle_TyreRipper"
		edittext txt_VehicleWeaponVariable "VehicleWeaponVariable" type:#string default:"WHEEL_SPEED"
		spinner spn_VehicleWeaponMultiplier "VehicleWeaponMultiplier" type:#float default:0.1
		spinner spn_VehicleWeaponMin "VehicleWeaponMin" type:#float default:1
		spinner spn_VehicleWeaponMax "VehicleWeaponMax" type:#float default:3.0
		checkbox chk_HasPedWeapon "HasPedWeapon" default:false
		edittext txt_PedWeaponScript "PedWeaponScript" type:#string default:"Ped_Explode"
		edittext txt_PedWeaponVariable "PedWeaponVariable" type:#string default:"WHEEL_SPEED"
		spinner spn_PedWeaponMultiplier "PedWeaponMultiplier" type:#float default:0.1
		spinner spn_PedWeaponMin "PedWeaponMin" type:#float default:1
		spinner spn_PedWeaponMax "PedWeaponMax" type:#float default:3.0
		checkbox chk_HasAccessoryWeapon "HasAccessoryWeapon" default:false
		edittext txt_AccessoryWeaponScript "AccessoryWeaponScript" type:#string default:"Accessory_Rip_X"
		edittext txt_AccessoryWeaponVariable "AccessoryWeaponVariable" type:#string default:"WHEEL_SPEED"
		spinner spn_AccessoryWeaponMultiplier "AccessoryWeaponMultiplier" type:#float default:0.1
		spinner spn_AccessoryWeaponMin "AccessoryWeaponMin" type:#float default:1
		spinner spn_AccessoryWeaponMax "AccessoryWeaponMax" type:#float default:3.0
	)
	rollout ComplicatedWheelForceFactorsRollout "ComplicatedWheelForceFactorsRollout"
	(
		spinner spn_WheelBoundsXFactor "WheelBoundsXFactor" type:#float default:1.2
		spinner spn_WheelBoundsYZFactor "WheelBoundsYZFactor" type:#float default:1.1
		spinner spn_WheelDamageMaxRandom "WheelDamageMaxRandom" type:#float default:5.0
		spinner spn_WheelDamageWeldThreshold "WheelDamageWeldThreshold" type:#float default:0.1
		spinner spn_TyreDamageWeldThreshold "TyreDamageWeldThreshold" type:#float default:0.01
		spinner spn_TyreDamageWeldMax "TyreDamageWeldMax" type:#float default:0.7
	)
	rollout ComplicatedWheelPositionalFactorsRollout "ComplicatedWheelPositionalFactorsRollout"
	(
		spinner spn_PuncturedHeightPercentage "PuncturedHeightPercentage" type:#float default:20.0
		spinner spn_DerimmedHeightPercentage "DerimmedHeightPercentage" type:#float default:60.0
		spinner spn_DerimmedTyrePenetrationPercentage "DerimmedTyrePenetrationPercentage" type:#float default:20.0
		spinner spn_DerimmedTyreTopPenetrationPercentage "DerimmedTyreTopPenetrationPercentage" type:#float default:20.0
	)
	rollout ComplicatedWheelPhysicsFactorsRollout "ComplicatedWheelPhysicsFactorsRollout"
	(
		
			spinner spn_Punctured_RollingResistance "Punctured_RollingResistance" type:#float default:0.1
			spinner spn_Punctured_FrictionFactor "Punctured_FrictionFactor" type:#float default:0.8
			spinner spn_Derimmed_RollingResistance "Derimmed_RollingResistance" type:#float default:0.1
			spinner spn_Derimmed_FrictionFactor "Derimmed_FrictionFactor" type:#float default:0.6
			spinner spn_TyreDetached_RollingResistance "TyreDetached_RollingResistance" type:#float default:0.1
			spinner spn_TyreDetached_FrictionFactor "TyreDetached_FrictionFactor" type:#float default:0.4
			spinner spn_SteeringBroken_RollingResistance "SteeringBroken_RollingResistance" type:#float default:0.05
			spinner spn_SteeringBroken_FrictionFactor "SteeringBroken_FrictionFactor" type:#float default:0.75
			spinner spn_Damaged_Tyre_Rim_Offset "Damaged_Tyre_Rim_Offset" type:#float default:0.01
			spinner spn_Damage_WheelOnTime "Damage_WheelOnTime" type:#float default:0.5
	)
	rollout ComplicatedWheelPhysicsDerimmedTyreEffectsRollout "ComplicatedWheelPhysicsDerimmedTyreEffectsRollout"
	(
		
			spinner spn_Derimmed_MaxSpinSpeedBeforeSlipping "Derimmed_MaxSpinSpeedBeforeSlipping" type:#float default:1.0
			spinner spn_Derimmed_SpinSpeedSlipPower "Derimmed_SpinSpeedSlipPower" type:#float default:0.3333
			spinner spn_Derimmed_SlipAngleFactor "Derimmed_SlipAngleFactor" type:#float default:0.75
			spinner spn_Derimmed_MinSpeedForYWobble "Derimmed_MinSpeedForYWobble" type:#float default:3.0
			spinner spn_Derimmed_MaxSpeedForYWobble "Derimmed_MaxSpeedForYWobble" type:#float default:30.0
			spinner spn_Derimmed_YWobbleMaxAmplitude "Derimmed_YWobbleMaxAmplitude" type:#float default:10.0
			spinner spn_Derimmed_YWobbleMaxRate "Derimmed_YWobbleMaxRate" type:#float default:10.0
			spinner spn_Derimmed_YWobbleMaxAngle "Derimmed_YWobbleMaxAngle" type:#float default:20.0
			spinner spn_Derimmed_MaxZSpeed "Derimmed_MaxZSpeed" type:#float default:10.0
			spinner spn_Derimmed_ZShiftFactor "Derimmed_ZShiftFactor" type:#float default:0.3
			spinner spn_Derimmed_MaxXSpeed "Derimmed_MaxXSpeed" type:#float default:3.0
			spinner spn_Derimmed_MinXShift "Derimmed_MinXShift" type:#float default:0.3
			spinner spn_Derimmed_MaxXShift "Derimmed_MaxXShift" type:#float default:0.7
	)
	rollout ComplicatedWheelBentAxlesRollout "ComplicatedWheelBentAxlesRollout"
	(
		
			spinner spn_BentAxle_MaxAngle "BentAxle_MaxAngle" type:#float default:10.0
			spinner spn_BentAxle_XOffset "BentAxle_XOffset" type:#float default:0.05
			spinner spn_BentAxle_DerimmedTyreFactor "BentAxle_DerimmedTyreFactor" type:#float default:0.5
	)
	rollout ComplicatedWheelDamagedWheelPhysics "ComplicatedWheelDamagedWheelPhysics"
	(
		
			spinner spn_Physics_TyreMass "Physics_TyreMass" type:#float default:5.0
			spinner spn_Physics_TyreRestitution "Physics_TyreRestitution" type:#float default:1.5
			spinner spn_Physics_TyreDetachUpOffset "Physics_TyreDetachUpOffset" type:#float default:0.25
			spinner spn_Physics_TyreDetachUpThrust "Physics_TyreDetachUpThrust" type:#float default:3.0
			spinner spn_Physics_TyreDetachOutThrust "Physics_TyreDetachOutThrust" type:#float default:3.0
			spinner spn_Physics_RimMass "Physics_RimMass" type:#float default:15.0
			spinner spn_Wheels_MaxCompressionRate "Wheels_MaxCompressionRate" type:#float default:4.0
			spinner spn_Wheels_MaxExtensionRate "Wheels_MaxExtensionRate" type:#float default:2.0
	)
)

/*********************************
***** CAR STRUCT CHARACTERISTICS ATTRIBUTES
*********************************/
StructureCharacteristicsAttribute = attributes StructureCharacteristics_Def attribID:#(0x384aa405, 0x32e1fc9) version:2
(
	parameters main rollout:BasicCharacteristicsRollout
	(
		DefenceAgainstCars_Active type:#boolean default:false ui:chk_DefenceAgainstCars_Active
		DefenceAgainstCars type:#float default:1.0 ui: spn_DefenceAgainstCars
		
		DefenceGeneral_Active type:#boolean default:false ui:chk_DefenceGeneral_Active
		DefenceGeneral type:#float default:1.0 ui: spn_DefenceGeneral
		
		Offence_Active type:#boolean default:false ui:chk_Offence_Active
		Offence type:#float default:1.0 ui: spn_Offence
	
		ValueFactor_Active type:#boolean default:false ui:chk_ValueFactor_Active
		ValueFactor type:#float default:1.0 ui: spn_ValueFactor
		
		WholeBodyDeformationFactor_Active type:#boolean default:false ui:chk_WholeBodyDeformationFactor_Active
		WholeBodyDeformationFactor type:#float default:1.0 ui: spn_WholeBodyDeformationFactor
		
		ExtraFallingDamageThreshold_Active type:#boolean default:false ui:chk_ExtraFallingDamageThreshold_Active
		ExtraFallingDamageThreshold type:#float default:30 ui:spn_ExtraFallingDamageThreshold
		
		ExtraFallingDamageFactor_Active type:#boolean default:false ui:chk_ExtraFallingDamageFactor_Active
		ExtraFallingDamageFactor type:#float default:800 ui:spn_ExtraFallingDamageFactor
		
		
		DownwardCrushingExtraOffence_Active type:#boolean default:false ui:chk_DownwardCrushingExtraOffence_Active
		DownwardCrushingExtraOffence_0mph type:#float default:10.0 ui:spn_DownwardCrushingExtraOffence_0mph
		DownwardCrushingExtraOffence_MaxMultSpeed type:#float default:5.0 ui:spn_DownwardCrushingExtraOffence_MaxMultSpeed
		DownwardCrushingExtraOffence_MaxMult type:#float default:2.0 ui:spn_DownwardCrushingExtraOffence_MaxMult
		
		
		RandomCrumplingRandomMax_Active type:#boolean default:false ui:chk_RandomCrumplingRandomMax_Active
		RandomCrumplingRandomMax type:#float default:0.0375 ui:spn_RandomCrumplingRandomMax
		
		WBDRandomCrumplingRandomMax_Active type:#boolean default:false ui:chk_WBDRandomCrumplingRandomMax_Active
		WBDRandomCrumplingRandomMax type:#float default:0.01 ui:spn_WBDRandomCrumplingRandomMax
		
		MaxDeflectionForDamageTexture_Active type:#boolean default:false ui:chk_MaxDeflectionForDamageTexture_Active
		MaxDeflectionForDamageTexture type:#float default:0.05 ui:spn_MaxDeflectionForDamageTexture


		ImmuneToWheelDamage_Active type:#boolean default:false ui:chk_ImmuneToWheelDamage_Active
		CannotBeSplit_Active type:#boolean default:false ui:chk_CannotBeSplit_Active
		AllowCOMZOutsideOfWheelbase_Active type:#boolean default:false ui:chk_AllowCOMZOutsideOfWheelbase_Active
		
		WheelRadius_Active type:#boolean default:false ui:chk_WheelRadius_Active
		WheelRadius type:#float default:0.05 ui:spn_WheelRadius
		WheelRadius_UseFactor type:#boolean default:false ui:chk_WheelRadius_UseFactor


		TowingPowerMultiplier_Active type:#boolean default:false ui:chk_TowingPowerMultiplier_Active
		TowingPowerMultiplier type:#float default:2.5 ui:spn_TowingPowerMultiplier

		TowingTractionMultiplier_Active type:#boolean default:false ui:chk_TowingTractionMultiplier_Active
		TowingTractionMultiplier type:#float default:2.0 ui:spn_TowingTractionMultiplier

		TowingSteerSpeedMultiplier_Active type:#boolean default:false ui:chk_TowingSteerSpeedMultiplier_Active
		TowingSteerSpeedMultiplier type:#float default:0.5 ui:spn_TowingSteerSpeedMultiplier



		GridExtraSpace_Active type:#boolean default:false ui:chk_GridExtraSpace_Active
		GridExtraSpace_x type:#float default:0 ui:spn_GridExtraSpace_x
		GridExtraSpace_y type:#float default:0 ui:spn_GridExtraSpace_y
		GridExtraSpace_z type:#float default:0 ui:spn_GridExtraSpace_z

		
		PermanentPowerups type:#stringTab tabSizeVariable:true
	)
	rollout BasicCharacteristicsRollout "Basic Characteristics"
	(
		label lbl_DefenceAgainstCars "Defence Against Cars" across:1 align:#right
		checkbox chk_DefenceAgainstCars_Active "" default:false  across:2 width:15
		spinner spn_DefenceAgainstCars "" range:[0,100,1] type:#float fieldwidth:40 align:#right
		
		label lbl_DefenceGeneral "Defence (General)" across:1 align:#right
		checkbox chk_DefenceGeneral_Active "" default:false across:2 width:15
		spinner spn_DefenceGeneral "" range:[0,100,1] type:#float fieldwidth:40
		
		label lbl_Offence "Offence" across:1 align:#right
		checkbox chk_Offence_Active "" default:false across:2 width:15
		spinner spn_Offence "" range:[0,100,1] type:#float fieldwidth:40
		
		label lbl_ValueFactor "Value Factor" across:1 align:#right
		checkbox chk_ValueFactor_Active "" default:false across:2 width:15
		spinner spn_ValueFactor "" range:[0,100,1] type:#float fieldwidth:40
		
		label lbl_WholeBodyDeformationFactor "Deform Factor" across:1 align:#right
		checkbox chk_WholeBodyDeformationFactor_Active "" default:false across:2 width:15
		spinner spn_WholeBodyDeformationFactor "" range:[0,100,1] type:#float fieldwidth:40
		
		label lbl_ExtraFallingDamageThreshold "Extra Fall Damage Threshold" across:1 align:#right
		checkbox chk_ExtraFallingDamageThreshold_Active "" default:false across:2 width:15
		spinner spn_ExtraFallingDamageThreshold "" range:[0,1000,1] type:#float fieldwidth:40 
		
		label lbl_ExtraFallingDamageFactor "Extra Fall Damage Factor" across:1 align:#right
		checkbox chk_ExtraFallingDamageFactor_Active "" default:false across:2 width:15
		spinner spn_ExtraFallingDamageFactor "" range:[0,1000,1] type:#float fieldwidth:40
		
		group "Downward Crushing Force"
		(
			checkbox chk_DownwardCrushingExtraOffence_Active "Enabled" default:false across:1 align:#center --width:15
			--label lbl_DownwardCrushingExtraOffence "Downward Crushing Force" acrosss:2
			label lbl_DownwardCrushingExtraOffence_0mph "Multiplier At 0mph" align:#right
			spinner spn_DownwardCrushingExtraOffence_0mph "" range:[0,10000,1] type:#float fieldwidth:40

			label lbl_DownwardCrushingExtraOffence_MaxMultSpeed "Max Downward Speed" align:#right
			spinner spn_DownwardCrushingExtraOffence_MaxMultSpeed "" range:[0,10000,1] type:#float fieldwidth:40

			label lbl_DownwardCrushingExtraOffence_MaxMult "Multiplier At That Speed" align:#right
			spinner spn_DownwardCrushingExtraOffence_MaxMult "" range:[0,10000,1] type:#float fieldwidth:40
		)

		label lbl_RandomCrumplingRandomMax "Random Crumpling Max" across:1 align:#right
		checkbox chk_RandomCrumplingRandomMax_Active "" default:false across:2 width:15
		spinner spn_RandomCrumplingRandomMax "" range:[0,1000,1] type:#float fieldwidth:40

		label lbl_WBDRandomCrumplingRandomMax "WBD Random Crumpling Max" across:1 align:#right
		checkbox chk_WBDRandomCrumplingRandomMax_Active "" default:false across:2 width:15
		spinner spn_WBDRandomCrumplingRandomMax "" range:[0,1000,1] type:#float fieldwidth:40

		label lbl_MaxDeflectionForDamageTexture "Dmg Texture Max Deflection" across:1 align:#right
		checkbox chk_MaxDeflectionForDamageTexture_Active "" default:false across:2 width:15
		spinner spn_MaxDeflectionForDamageTexture "" range:[0,1000,1] type:#float fieldwidth:40
		

		checkbox chk_ImmuneToWheelDamage_Active "Immune To Wheel Damage" default:false 
		checkbox chk_CannotBeSplit_Active "Cannot Be Split" default:false
		checkbox chk_AllowCOMZOutsideOfWheelbase_Active "Allow COM Z Outside Wheelbase" default:false

		checkbox chk_WheelRadius_Active "" default:false across:2
		spinner spn_WheelRadius "Wheel Radius" range:[0,1000,1] type:#float fieldwidth:40
		checkbox chk_WheelRadius_UseFactor "Radius is a %?" default:false 


		checkbox chk_GridExtraSpace_Active "" default:false across:2
		label lbl_GridExtraSpace "Extra Grid Space" acrosss:2
		spinner spn_GridExtraSpace_x "" range:[0,10000,1] type:#float fieldwidth:40 across:3
		spinner spn_GridExtraSpace_y "" range:[0,10000,1] type:#float fieldwidth:40 across:3
		spinner spn_GridExtraSpace_z "" range:[0,10000,1] type:#float fieldwidth:40 across:3


		checkbox chk_TowingPowerMultiplier_Active "" default:false across:2
		spinner spn_TowingPowerMultiplier "Towing Power Multiplier" range:[0,1000,1] type:#float fieldwidth:40

		checkbox chk_TowingTractionMultiplier_Active "" default:false across:2
		spinner spn_TowingTractionMultiplier "Towing Traction Multiplier" range:[0,1000,1] type:#float fieldwidth:40

		checkbox chk_TowingSteerSpeedMultiplier_Active "" default:false across:2
		spinner spn_TowingSteerSpeedMultiplier "Towing Steer Speed Multiplier" range:[0,1000,1] type:#float fieldwidth:40

		edittext txt_PowerupName "Permenant Powerup" labelOnTop:true fieldwidth: 100 across:2
		button but_AddToPowerups "Add"
		dotnetcontrol lv_Powerups "listview" height: 100
		button but_DeleteFromPowerups "Delete Selected"
		
		on BasicCharacteristicsRollout open do
		(			
			
			chk_DefenceAgainstCars_Active.pos = [chk_DefenceAgainstCars_Active.pos.x-7, chk_DefenceAgainstCars_Active.pos.y]
			--lbl_DefenceAgainstCars.pos = [25, lbl_DefenceAgainstCars.pos.y]

			chk_DefenceGeneral_Active.pos = [chk_DefenceGeneral_Active.pos.x-7, chk_DefenceGeneral_Active.pos.y]
			--lbl_DefenceGeneral.pos = [25, lbl_DefenceGeneral.pos.y]

			chk_Offence_Active.pos = [chk_Offence_Active.pos.x-7, chk_Offence_Active.pos.y]
			--lbl_Offence.pos = [25, lbl_Offence.pos.y]
			
			chk_ValueFactor_Active.pos = [chk_ValueFactor_Active.pos.x-7, chk_ValueFactor_Active.pos.y]
			--lbl_ValueFactor.pos = [25, lbl_ValueFactor.pos.y]
			
			chk_WholeBodyDeformationFactor_Active.pos = [chk_WholeBodyDeformationFactor_Active.pos.x-7, chk_WholeBodyDeformationFactor_Active.pos.y]
			--lbl_WholeBodyDeformationFactor.pos = [25, lbl_WholeBodyDeformationFactor.pos.y]
			
			chk_ExtraFallingDamageThreshold_Active.pos = [chk_ExtraFallingDamageThreshold_Active.pos.x-7, chk_ExtraFallingDamageThreshold_Active.pos.y]
			--lbl_ExtraFallingDamageThreshold.pos = [25, lbl_ExtraFallingDamageThreshold.pos.y]
			
			chk_ExtraFallingDamageFactor_Active.pos = [chk_ExtraFallingDamageFactor_Active.pos.x-7, chk_ExtraFallingDamageFactor_Active.pos.y]
			--lbl_ExtraFallingDamageFactor.pos = [25, lbl_ExtraFallingDamageFactor.pos.y]
			
			
			--chk_DownwardCrushingExtraOffence_Active.pos = [chk_DownwardCrushingExtraOffence_Active.pos.x-7, chk_DownwardCrushingExtraOffence_Active.pos.y]
			--lbl_DownwardCrushingExtraOffence.pos = [25, chk_DownwardCrushingExtraOffence_Active.pos.y]

			chk_RandomCrumplingRandomMax_Active.pos = [chk_RandomCrumplingRandomMax_Active.pos.x-7, chk_RandomCrumplingRandomMax_Active.pos.y]
			chk_WBDRandomCrumplingRandomMax_Active.pos = [chk_WBDRandomCrumplingRandomMax_Active.pos.x-7, chk_WBDRandomCrumplingRandomMax_Active.pos.y]
			chk_MaxDeflectionForDamageTexture_Active.pos = [chk_MaxDeflectionForDamageTexture_Active.pos.x-7, chk_MaxDeflectionForDamageTexture_Active.pos.y]
			chk_WheelRadius_Active.pos = [chk_WheelRadius_Active.pos.x-7, chk_WheelRadius_Active.pos.y]
			
			chk_GridExtraSpace_Active.pos = [chk_GridExtraSpace_Active.pos.x-7, chk_GridExtraSpace_Active.pos.y]
			chk_TowingPowerMultiplier_Active.pos = [chk_TowingPowerMultiplier_Active.pos.x-7, chk_TowingPowerMultiplier_Active.pos.y]
			chk_TowingTractionMultiplier_Active.pos = [chk_TowingTractionMultiplier_Active.pos.x-7, chk_TowingTractionMultiplier_Active.pos.y]
			chk_TowingSteerSpeedMultiplier_Active.pos = [chk_TowingSteerSpeedMultiplier_Active.pos.x-7, chk_TowingSteerSpeedMultiplier_Active.pos.y]
			
			if DefenceAgainstCars_Active then spn_DefenceAgainstCars.enabled = true
			else spn_DefenceAgainstCars.enabled = false
			
			if DefenceGeneral_Active then spn_DefenceGeneral.enabled = true
			else spn_DefenceGeneral.enabled = false
			
			if Offence_Active then spn_Offence.enabled = true
			else spn_Offence.enabled = false
			
			if ValueFactor_Active then spn_ValueFactor.enabled = true
			else spn_ValueFactor.enabled = false
			
			if WholeBodyDeformationFactor_Active then spn_WholeBodyDeformationFactor.enabled = true
			else spn_WholeBodyDeformationFactor.enabled = false

			if ExtraFallingDamageThreshold_Active then spn_ExtraFallingDamageThreshold.enabled = true
			else spn_ExtraFallingDamageThreshold.enabled = false
			
			if ExtraFallingDamageFactor_Active then spn_ExtraFallingDamageFactor.enabled = true
			else spn_ExtraFallingDamageFactor.enabled = false
			
			if DownwardCrushingExtraOffence_Active then 
			(
				spn_DownwardCrushingExtraOffence_0mph.enabled = true
				spn_DownwardCrushingExtraOffence_MaxMult.enabled = true
				spn_DownwardCrushingExtraOffence_MaxMultSpeed.enabled = true
			)
			else
			(
				spn_DownwardCrushingExtraOffence_0mph.enabled = false
				spn_DownwardCrushingExtraOffence_MaxMult.enabled = false
				spn_DownwardCrushingExtraOffence_MaxMultSpeed.enabled = false
			)

			if RandomCrumplingRandomMax_Active then spn_RandomCrumplingRandomMax.enabled = true
			else spn_RandomCrumplingRandomMax.enabled = false
			
			if WBDRandomCrumplingRandomMax_Active then spn_WBDRandomCrumplingRandomMax.enabled = true
			else spn_WBDRandomCrumplingRandomMax.enabled = false
			
			if MaxDeflectionForDamageTexture_Active then spn__MaxDeflectionForDamageTexture.enabled = true
			else spn_MaxDeflectionForDamageTexture.enabled = false
			
			if WheelRadius_Active then
			(
				spn_WheelRadius.enabled = true
				chk_WheelRadius_UseFactor.enabled = true
			)
			else
			(
				spn_WheelRadius.enabled = false
				chk_WheelRadius_UseFactor.enabled = false
			)
			
			if GridExtraSpace_Active then
			(
				spn_GridExtraSpace_x.enabled = true
				spn_GridExtraSpace_y.enabled = true
				spn_GridExtraSpace_z.enabled = true
			)
			else
			(
				spn_GridExtraSpace_x.enabled = false
				spn_GridExtraSpace_y.enabled = false
				spn_GridExtraSpace_z.enabled = false
			)
			
			if TowingPowerMultiplier_Active then spn_TowingPowerMultiplier.enabled = true
			else spn_TowingPowerMultiplier.enabled = false

			if TowingTractionMultiplier_Active then spn_TowingTractionMultiplier.enabled = true
			else spn_TowingTractionMultiplier.enabled = false

			if TowingSteerSpeedMultiplier_Active then spn_TowingSteerSpeedMultiplier.enabled = true
			else spn_TowingSteerSpeedMultiplier.enabled = false

			
			but_AddToPowerups.pos = [120, but_AddToPowerups.pos.y+15]
			lv_Powerups.view  = (dotnetclass "view").details
			lv_Powerups.fullrowselect= true
			lv_Powerups.gridlines = true
			lv_Powerups.multiselect =false
			lv_Powerups.columns.add "Powerup" 110
			for i=1 to PermanentPowerups.count do
			(
				lv_Powerups.Items.add PermanentPowerups[i]
			)
		)
		
		on chk_DefenceAgainstCars_Active changed state do
		(
			spn_DefenceAgainstCars.enabled = state
		)
		on chk_DefenceGeneral_Active changed state do
		(
			spn_DefenceGeneral.enabled = state
		)
		on chk_Offence_Active changed state do
		(
			spn_Offence.enabled = state
		)
		on chk_ValueFactor_Active changed state do
		(
			spn_ValueFactor.enabled = state
		)
		on chk_WholeBodyDeformationFactor_Active changed state do
		(
			spn_WholeBodyDeformationFactor.enabled = state
		)
		on chk_ExtraFallingDamageThreshold_Active changed state do
		(
			spn_ExtraFallingDamageThreshold.enabled = state
		)
		on chk_ExtraFallingDamageFactor_Active changed state do
		(
			spn_ExtraFallingDamageFactor.enabled = state
		)
		on chk_DownwardCrushingExtraOffence_Active changed state do
		(
			spn_DownwardCrushingExtraOffence_0mph.enabled = state
			spn_DownwardCrushingExtraOffence_MaxMult.enabled = state
			spn_DownwardCrushingExtraOffence_MaxMultSpeed.enabled = state
		)
		on chk_RandomCrumplingRandomMax_Active changed state do
		(
			spn_RandomCrumplingRandomMax.enabled = state
		)
		on chk_WBDRandomCrumplingRandomMax_Active changed state do
		(
			spn_WBDRandomCrumplingRandomMax.enabled = state
		)
		on chk_MaxDeflectionForDamageTexture_Active changed state do
		(
			spn_MaxDeflectionForDamageTexture.enabled = state
		)
		on chk_WheelRadius_Active changed state do
		(
			spn_WheelRadius.enabled = state
			chk_WheelRadius_UseFactor.enabled = state
		)
		on chk_GridExtraSpace_Active changed state do
		(
			spn_GridExtraSpace_x.enabled = state
			spn_GridExtraSpace_y.enabled = state
			spn_GridExtraSpace_z.enabled = state
		)
		on chk_TowingPowerMultiplier_Active changed state do
		(
			spn_TowingPowerMultiplier.enabled = state
		)
		on chk_TowingTractionMultiplier_Active changed state do
		(
			spn_TowingTractionMultiplier.enabled = state
		)
		on chk_TowingSteerSpeedMultiplier_Active changed state do
		(
			spn_TowingSteerSpeedMultiplier.enabled = state
		)
		on BasicCharacteristicsRollout close do
		(
			
		)
		on but_DeleteFromPowerups pressed do
		(
			if lv_Powerups.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_Powerups.SelectedIndices.Item[0]
				lv_Powerups.Items.removeat selectedIndex
				deleteItem PermanentPowerups (selectedIndex+1)
			)
		)
		on but_AddToPowerups pressed do
		(
			lv_Powerups.Items.add (txt_PowerupName.text)
			append PermanentPowerups txt_PowerupName.text
		)
	)
	
	parameters airBrakeSpoiler rollout:AirBrakeSpoilerRollout
	(
		AirBrakeMinSpeed_Active type:#boolean default:false ui:chk_AirBrakeMinSpeed_Active
		AirBrakeMinSpeed type:#float default: 1.0 ui: spn_AirBrakeMinSpeed
		
		AirBrakeMaxSpeed_Active type:#boolean default:false ui:chk_AirBrakeMaxSpeed_Active
		AirBrakeMaxSpeed type:#float default: 1.0 ui: spn_AirBrakeMaxSpeed
		
		AirBrakeMinParametric_Active type:#boolean default:false ui:chk_AirBrakeMinParametric_Active
		AirBrakeMinParametric type:#float default: 1.0 ui:spn_AirBrakeMinParametric 
		
		AirBrakeMovementUpTime_Active type:#boolean default:false ui:chk_AirBrakeMovementUpTime_Active
		AirBrakeMovementUpTime type:#float default: 1.0 ui:spn_AirBrakeMovementUpTime 
		
		AirBrakeMovementDownTime_Active type:#boolean default:false ui:chk_AirBrakeMovementDownTime_Active
		AirBrakeMovementDownTime type:#float default: 1.0 ui:spn_AirBrakeMovementDownTime 
		
		AirBrakeDroptime_Active type:#boolean default:false ui:chk_AirBrakeDroptime_Active
		AirBrakeDroptime type:#float default:1.0 ui:spn_AirBrakeDroptime 
		
		AerofoilUpSpeed_Active type:#boolean default:false ui:chk_AerofoilUpSpeed_Active
		AerofoilUpSpeed type:#float default: 1.0	ui:spn_AerofoilUpSpeed 
		
		AerofoilDownSpeed_Active type:#boolean default:false ui:chk_AerofoilDownSpeed_Active
		AerofoilDownSpeed type:#float default: 1.0 ui:spn_AerofoilDownSpeed 
		
		AerofoilMovementUpTime_Active type:#boolean default:false ui:chk_AerofoilMovementUpTime_Active
		AerofoilMovementUpTime type:#float default: 1.0 ui:spn_AerofoilMovementUpTime 
		
		AerofoilMovementDownTime_Active type:#boolean default:false ui:chk_AerofoilMovementDownTime_Active
		AerofoilMovementDownTime type:#float default: 1.0 ui:spn_AerofoilMovementDownTime 
		
		
		Aerofoil2UpSpeed_Active type:#boolean default:false ui:chk_Aerofoil2UpSpeed_Active
		Aerofoil2UpSpeed type:#float default: 1.0 ui:spn_Aerofoil2UpSpeed 
		
		Aerofoil2DownSpeed_Active type:#boolean default:false ui:chk_Aerofoil2DownSpeed_Active
		Aerofoil2DownSpeed type:#float default: 1.0 ui:spn_Aerofoil2DownSpeed
		
		Aerofoil2MovementUpTime_Active type:#boolean default:false ui:chk_Aerofoil2MovementUpTime_Active
		Aerofoil2MovementUpTime type:#float default: 1.0 ui:spn_Aerofoil2MovementUpTime 
		
		Aerofoil2MovementDownTime_Active type:#boolean default:false ui:chk_Aerofoil2MovementDownTime_Active
		Aerofoil2MovementDownTime type:#float default: 1.0 ui:spn_Aerofoil2MovementDownTime 
		
		AerofoilOpenSound_Active type:#boolean default:false ui:chk_AerofoilOpenSound_Active
		AerofoilOpenSound type:#string default:"eagle_flaps_open" ui:txt_AerofoilOpenSound 
		AerofoilCloseSound_Active type:#boolean default:false ui:chk_AerofoilCloseSound_Active
		AerofoilCloseSound type:#string default:"eagle_flaps_open" ui:txt_AerofoilCloseSound 
		
		AerofoilSoundLump type:#maxObject
	)
	rollout AirBrakeSpoilerRollout "Air Brake & Spoiler Settings"
	(
		group "Air Brake"
		(
			checkbox chk_AirBrakeMinSpeed_Active "" default:false across:2
			spinner spn_AirBrakeMinSpeed "Activation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMaxSpeed_Active "" default:false across:2
			spinner spn_AirBrakeMaxSpeed "Deactivation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMinParametric_Active "" default:false across:2
			spinner spn_AirBrakeMinParametric "Min Parametric" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMovementUpTime_Active "" default:false across:2
			spinner spn_AirBrakeMovementUpTime "Activation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeMovementDownTime_Active "" default:false across:2
			spinner spn_AirBrakeMovementDownTime "Deactivation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AirBrakeDroptime_Active "" default:false across:2
			spinner spn_AirBrakeDropTime "Drop Time" range:[0,1000,1] type:#float fieldwidth:40
		)
		group "Aerofoil 1"
		(
			checkbox chk_AerofoilUpSpeed_Active "" default:false across:2
			spinner spn_AerofoilUpSpeed "Activation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AerofoilDownSpeed_Active "" default:false across:2
			spinner spn_AerofoilDownSpeed "Deactivation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AerofoilMovementUpTime_Active "" default:false across:2
			spinner spn_AerofoilMovementUpTime "Activation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_AerofoilMovementDownTime_Active "" default:false across:2
			spinner spn_AerofoilMovementDownTime "Deactivation Time" range:[0,1000,1] type:#float fieldwidth:40
			
		)
		group "Aerofoil 2"
		(
			checkbox chk_Aerofoil2UpSpeed_Active "" default:false across:2
			spinner spn_Aerofoil2UpSpeed "Activation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_Aerofoil2DownSpeed_Active "" default:false across:2
			spinner spn_Aerofoil2DownSpeed "Deactivation Speed" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_Aerofoil2MovementUpTime_Active "" default:false across:2
			spinner spn_Aerofoil2MovementUpTime "Activation Time" range:[0,1000,1] type:#float fieldwidth:40
			
			checkbox chk_Aerofoil2MovementDownTime_Active "" default:false across:2
			spinner spn_Aerofoil2MovementDownTime "Deactivation Time" range:[0,1000,1] type:#float fieldwidth:40
			
		)
		group "Sounds"
		(
			
			checkbox chk_AerofoilOpenSound_Active "" default:false across:2
			edittext txt_AerofoilOpenSound "Open Sound" labelOnTop:true width: 120 fieldwidth:120
			checkbox chk_AerofoilCloseSound_Active "" default:false across:2
			edittext txt_AerofoilCloseSound "Close Sound" labelOnTop:true width: 120 fieldwidth:120
			
			label lbl_AerofoilSoundLump "Aerofoil Sound Node"
			pickbutton pck_AerofoilSoundLump "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
			button but_ClearAerofoilSoundLump "Clear" across:2
			button but_SelectAerofoilSoundLump "Select" across:2
			
		)
		
		on AirBrakeSpoilerRollout open do
		(
			
			chk_AirBrakeMinSpeed_Active.pos = [chk_AirBrakeMinSpeed_Active.pos.x-7, chk_AirBrakeMinSpeed_Active.pos.y]
			chk_AirBrakeMaxSpeed_Active.pos = [chk_AirBrakeMaxSpeed_Active.pos.x-7, chk_AirBrakeMaxSpeed_Active.pos.y]
			chk_AirBrakeMinParametric_Active.pos = [chk_AirBrakeMinParametric_Active.pos.x-7, chk_AirBrakeMinParametric_Active.pos.y]
			chk_AirBrakeMovementUpTime_Active.pos = [chk_AirBrakeMovementUpTime_Active.pos.x-7, chk_AirBrakeMovementUpTime_Active.pos.y]
			chk_AirBrakeMovementDownTime_Active.pos = [chk_AirBrakeMovementDownTime_Active.pos.x-7, chk_AirBrakeMovementDownTime_Active.pos.y]
			chk_AirBrakeDroptime_Active.pos = [chk_AirBrakeDroptime_Active.pos.x-7, chk_AirBrakeDroptime_Active.pos.y]
			
			chk_AerofoilUpSpeed_Active.pos = [chk_AerofoilUpSpeed_Active.pos.x-7, chk_AerofoilUpSpeed_Active.pos.y]
			chk_AerofoilDownSpeed_Active.pos = [chk_AerofoilDownSpeed_Active.pos.x-7, chk_AerofoilDownSpeed_Active.pos.y]
			chk_AerofoilMovementUpTime_Active.pos = [chk_AerofoilMovementUpTime_Active.pos.x-7, chk_AerofoilMovementUpTime_Active.pos.y]
			chk_AerofoilMovementDownTime_Active.pos = [chk_AerofoilMovementDownTime_Active.pos.x-7, chk_AerofoilMovementDownTime_Active.pos.y]
			
			chk_Aerofoil2UpSpeed_Active.pos = [chk_Aerofoil2UpSpeed_Active.pos.x-7, chk_Aerofoil2UpSpeed_Active.pos.y]
			chk_Aerofoil2DownSpeed_Active.pos = [chk_Aerofoil2DownSpeed_Active.pos.x-7, chk_Aerofoil2DownSpeed_Active.pos.y]
			chk_Aerofoil2MovementUpTime_Active.pos = [chk_Aerofoil2MovementUpTime_Active.pos.x-7, chk_Aerofoil2MovementUpTime_Active.pos.y]
			chk_Aerofoil2MovementDownTime_Active.pos = [chk_Aerofoil2MovementDownTime_Active.pos.x-7, chk_Aerofoil2MovementDownTime_Active.pos.y]
			
			chk_AerofoilOpenSound_Active.pos = [chk_AerofoilOpenSound_Active.pos.x-7, chk_AerofoilOpenSound_Active.pos.y]
			chk_AerofoilCloseSound_Active.pos = [chk_AerofoilCloseSound_Active.pos.x-7, chk_AerofoilCloseSound_Active.pos.y]
			
			txt_AerofoilOpenSound.pos = [txt_AerofoilOpenSound.pos.x-50, txt_AerofoilOpenSound.pos.y]
			txt_AerofoilCloseSound.pos = [txt_AerofoilCloseSound.pos.x-50, txt_AerofoilCloseSound.pos.y]
			
			if AirBrakeMinSpeed_Active then spn_AirBrakeMinSpeed.enabled = true
			else spn_AirBrakeMinSpeed.enabled = false
			if AirBrakeMaxSpeed_Active then spn_AirBrakeMaxSpeed.enabled = true
			else spn_AirBrakeMaxSpeed.enabled = false
			if AirBrakeMinParametric_Active then spn_AirBrakeMinParametric.enabled = true
			else spn_AirBrakeMinParametric.enabled = false
			if AirBrakeMovementUpTime_Active then spn_AirBrakeMovementUpTime.enabled = true
			else spn_AirBrakeMovementUpTime.enabled = false
			if AirBrakeMovementDownTime_Active then spn_AirBrakeMovementDownTime.enabled = true
			else spn_AirBrakeMovementDownTime.enabled = false
			if AirBrakeDroptime_Active then spn_AirBrakeDroptime.enabled = true
			else spn_AirBrakeDroptime.enabled = false
			
			if AerofoilUpSpeed_Active then spn_AerofoilUpSpeed.enabled = true
			else spn_AerofoilUpSpeed.enabled = false
			if AerofoilDownSpeed_Active then spn_AerofoilDownSpeed.enabled = true
			else spn_AerofoilDownSpeed.enabled = false
			if AerofoilMovementUpTime_Active then spn_AerofoilMovementUpTime.enabled = true
			else spn_AerofoilMovementUpTime.enabled = false
			if AerofoilMovementDownTime_Active then spn_AerofoilMovementDownTime.enabled = true
			else spn_AerofoilMovementDownTime.enabled = false
			
			if Aerofoil2UpSpeed_Active then spn_Aerofoil2UpSpeed.enabled = true
			else spn_Aerofoil2UpSpeed.enabled = false
			if Aerofoil2DownSpeed_Active then spn_Aerofoil2DownSpeed.enabled = true
			else spn_Aerofoil2DownSpeed.enabled = false
			if Aerofoil2MovementUpTime_Active then spn_Aerofoil2MovementUpTime.enabled = true
			else spn_Aerofoil2MovementUpTime.enabled = false
			if Aerofoil2MovementDownTime_Active then spn_Aerofoil2MovementDownTime.enabled = true
			else spn_Aerofoil2MovementDownTime.enabled = false
			
			if AerofoilOpenSound_Active then txt_AerofoilOpenSound.enabled = true
			else txt_AerofoilOpenSound.enabled = false
			if AerofoilCloseSound_Active then txt_AerofoilCloseSound.enabled = true
			else txt_AerofoilCloseSound.enabled = false
			
			if AerofoilSoundLump != undefined then 
			(
				pck_AerofoilSoundLump.object= AerofoilSoundLump.node
			)
		)
		
		on chk_AirBrakeMinSpeed_Active changed state do
		(
			spn_AirBrakeMinSpeed.enabled = state
		)
		on chk_AirBrakeMaxSpeed_Active changed state do
		(
			spn_AirBrakeMaxSpeed.enabled = state
		)
		on chk_AirBrakeMinParametric_Active changed state do
		(
			spn_AirBrakeMinParametric.enabled = state
		)
		on chk_AirBrakeMovementUpTime_Active changed state do
		(
			spn_AirBrakeMovementUpTime.enabled = state
		)
		on chk_AirBrakeMovementDownTime_Active changed state do
		(
			spn_AirBrakeMovementDownTime.enabled = state
		)
		on chk_AirBrakeDroptime_Active changed state do
		(
			spn_AirBrakeDroptime.enabled = state
		)
		
		
		on chk_AerofoilUpSpeed_Active changed state do
		(
			spn_AerofoilUpSpeed.enabled = state
		)
		on chk_AerofoilDownSpeed_Active changed state do
		(
			spn_AerofoilDownSpeed.enabled = state
		)
		on chk_AerofoilMovementUpTime_Active changed state do
		(
			spn_AerofoilMovementUpTime.enabled = state
		)
		on chk_AerofoilMovementDownTime_Active changed state do
		(
			spn_AerofoilMovementDownTime.enabled = state
		)
		
		
		on chk_Aerofoil2UpSpeed_Active changed state do
		(
			spn_Aerofoil2UpSpeed.enabled = state
		)
		on chk_Aerofoil2DownSpeed_Active changed state do
		(
			spn_Aerofoil2DownSpeed.enabled = state
		)
		on chk_Aerofoil2MovementUpTime_Active changed state do
		(
			spn_Aerofoil2MovementUpTime.enabled = state
		)
		on chk_Aerofoil2MovementDownTime_Active changed state do
		(
			spn_Aerofoil2MovementDownTime.enabled = state
		)
		
		on chk_AerofoilOpenSound_Active changed state do
		(
			txt_AerofoilOpenSound.enabled = state
		)
		on chk_AerofoilCloseSound_Active changed state do
		(
			txt_AerofoilCloseSound.enabled = state
		)
		on pck_AerofoilSoundLump picked obj do
		(
			AerofoilSoundLump = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		
		on but_ClearAerofoilSoundLump pressed do
		(
			AerofoilSoundLump = undefined
			pck_AerofoilSoundLump.object = undefined
		)
		on but_SelectAerofoilSoundLump pressed do
		(
			if AerofoilSoundLump != undefined then undo "Select Aerofoil Sound Lump" on select AerofoilSoundLump.node
		)
	)

	parameters caterpillarTracks rollout:CaterpillarTracksRollout
	(
		CaterpillerTracks_Enabled type:#boolean default:false ui:chk_CaterpillerTracks_Enabled

		SegmentDefinition_Name type:#stringTab  tabSizeVariable:true
		SegmentDefinition_SegmentPitch type:#floatTab tabSizeVariable:true
		SegmentDefinition_XOffset type:#floatTab tabSizeVariable:true

		SagHeight_AmbientLowestPoint type:#floattab tabSizeVariable:true
		SagHeight_LowestAllowablePoint type:#floattab tabSizeVariable:true

		DamageMode_NumParts type:#inttab tabSizeVariable:true
		DamageMode_Restitution type:#floatTab tabSizeVariable:true
		DamageMode_MassPerSegment type:#floatTab tabSizeVariable:true

		DamageWobble_SpeedForMaxWobble type:#floatTab tabSizeVariable:true
		DamageWobble_FreqOfMaxWobble type:#floatTab tabSizeVariable:true
		DamageWobble_AmpOfMaxWobble type:#floatTab tabSizeVariable:true
		DamageWobble_RandomVariance type:#floatTab tabSizeVariable:true

		Sound_ClunkVolume_VolumeAtZero type:#floatTab tabSizeVariable:true
		Sound_ClunkVolume_SpeedAtSlopeChange type:#floatTab tabSizeVariable:true
		Sound_ClunkVolume_VolumeAtSlopeChange type:#floatTab tabSizeVariable:true
		Sound_ClunkVolume_SpeedAtMaxVolume type:#floatTab tabSizeVariable:true
		Sound_ClunkVolume_MaxVolume type:#floatTab tabSizeVariable:true

		Sound_HighSpeedClunkVolume_VolumeAtZero type:#floatTab tabSizeVariable:true
		Sound_HighSpeedClunkVolume_SpeedAtSlopeChange type:#floatTab tabSizeVariable:true
		Sound_HighSpeedClunkVolume_VolumeAtSlopeChange type:#floatTab tabSizeVariable:true
		Sound_HighSpeedClunkVolume_SpeedAtMaxVolume type:#floatTab tabSizeVariable:true
		Sound_HighSpeedClunkVolume_MaxVolume type:#floatTab tabSizeVariable:true

		Damaged_FrictionFactor_Active type:#boolean default:false ui:chk_Damaged_FrictionFactor_Active
		Damaged_FrictionFactor type:#float default: 1.0 ui:spn_Damaged_FrictionFactor 

		Damaged_RollingResistance_Active type:#boolean default:false ui:chk_Damaged_RollingResistance_Active
		Damaged_RollingResistance type:#float default: 1.0 ui:spn_Damaged_RollingResistance

		DamagedAll_FrictionFactor_Active type:#boolean default:false ui:chk_DamagedAll_FrictionFactor_Active
		DamagedAll_FrictionFactor type:#float default: 1.0 ui:spn_DamagedAll_FrictionFactor 

		DamagedAll_RollingResistance_Active type:#boolean default:false ui:chk_DamagedAll_RollingResistance_Active
		DamagedAll_RollingResistance type:#float default: 1.0 ui:spn_DamagedAll_RollingResistance 

		Sound_WhineVolume_Active type:#boolean default:false ui:chk_Sound_WhineVolume_Active
		Sound_WhineVolume_VolumeAtZero type:#float default:-30.0 ui:spn_Sound_WhineVolume_VolumeAtZero
		Sound_WhineVolume_SpeedAtSlopeChange type:#float default:25 ui:spn_Sound_WhineVolume_SpeedAtSlopeChange
		Sound_WhineVolume_VolumeAtSlopeChange type:#float default:-3.0 ui:spn_Sound_WhineVolume_VolumeAtSlopeChange
		Sound_WhineVolume_SpeedAtMaxVolume type:#float default:80 ui:spn_Sound_WhineVolume_SpeedAtMaxVolume
		Sound_WhineVolume_MaxVolume type:#float default:80 ui:spn_Sound_WhineVolume_MaxVolume


		Sound_WhinePitch_Active type:#boolean default:false ui:chk_Sound_WhinePitch_Active
		Sound_WhinePitch_PitchAtZero type:#float default:-3.0 ui:spn_Sound_WhinePitch_PitchAtZero
		Sound_WhinePitch_MaxSpeed type:#float default:80 ui:spn_Sound_WhinePitch_MaxSpeed
		Sound_WhinePitch_PitchAtMaxSpeed type:#float default:3.0 ui:spn_Sound_WhinePitch_PitchAtMaxSpeed

	)

	Rollout CaterpillarTracksRollout "Caterpillar Track Settings"
	(
		checkbox chk_CaterpillerTracks_Enabled "Enable Caterpillar Tracks" default:false

		button btn_AddNewTrack "Add New Track" across:2
		button btn_DeleteTrack "Delete Track" across:2
		dropdownlist drpdn_CaterpillerTracksList "Track Number" items:#() tooltip:"List of Caterpillar Tracks"

		group "Segment Definition"
		(
			edittext txt_SegmentDefinition_Name "Segment CNT Name" labelOnTop:true
			spinner spn_SegmentDefinition_Pitch "Seg Pitch" range:[-100,100,0]
			spinner spn_SegmentDefinition_XOffset "X Offset" range:[-10,10,0]
		)

		on txt_SegmentDefinition_Name changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			SegmentDefinition_Name[index] = val
			items = drpdn_CaterpillerTracksList.items
			items[index] = (((index-1) as String ) + ": " + val)
			drpdn_CaterpillerTracksList.items = items
		)
		on spn_SegmentDefinition_Pitch changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			SegmentDefinition_SegmentPitch[index] = val
		)
		on spn_SegmentDefimition_XOffset changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			SegmentDefinition_XOffset[index] = val
		)

		group "Track Sagging"
		(
			spinner spn_SagHeight_Ambient "Lowest Ambient Point" labelOnTop:true
			spinner spn_SagHeight_Lowest "Lowest Allowable Point"
		)

		on spn_SagHeight_Ambient changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			SagHeight_AmbientLowestPoint[index] = val
		)
		on spn_SagHeight_Lowest changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			SagHeight_LowestAllowablePoint[index] = val
		)

		group "Segment Damage"
		(
			spinner spn_DamageNumParts "Num Parts" range:[-1,100,-1] type:#integer
			spinner spn_DamageRestitution "Restitution" range:[0,100,0]
			spinner spn_DamageMassPerSegment "Mass Per Segment" range:[0,10000,0]
		)
		on spn_DamageNumParts changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageMode_NumParts[index]=val
		)
		on spn_DamageRestitution changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageMode_Restitution[index]=val
		)
		
		on spn_DamageMassPerSegment changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageMode_MassPerSegment[index]=val
		)
		
		group "Wobble"
		(
			spinner spn_DamageWobble_SpeedForMaxWobble "Speed (MPH)" range:[0,100,20]
			spinner spn_DamageWobble_FreqOfMaxWobble "Frequency" range:[0,10000,20]
			spinner spn_DamageWobble_AmpOfMaxWobble "Amplitude" range:[0,10000,20]
			spinner spn_DamageWobble_RandomVariance "Random Variance" range:[0,10000,20]
		)

		on spn_DamageWobble_SpeedForMaxWobble changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageWobble_SpeedForMaxWobble[index] = val
		)
		on spn_DamageWobble_FreqOfMaxWobble changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageWobble_FreqOfMaxWobble[index] = val
		)
		on spn_DamageWobble_AmpOfMaxWobble changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageWobble_AmpOfMaxWobble[index] = val
		)
		on spn_DamageWobble_RandomVariance changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			DamageWobble_RandomVariance[index] = val
		)
		group "Clunk Volume"
		(
			spinner spn_ClunkVolume_VolumeAtZero "Volume At Zero" range:[-100,100,-6]
			spinner spn_ClunkVolume_SpeedAtSlopeChange "Speed At Slope Change" range:[0,300,20]
			spinner spn_ClunkVolume_VolumeAtSlopeChange "Volume At Slope Change" range:[-100,100,-3]
			spinner spn_ClunkVolume_SpeedAtMaxVolume "Max Speed" range:[0,300,80]
			spinner spn_ClunkVolume_MaxVolume "Volume At Max Speed" range:[-100,100,0]
		)
		on spn_ClunkVolume_VolumeAtZero changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_ClunkVolume_VolumeAtZero[index] = val
		)
		on spn_ClunkVolume_SpeedAtSlopeChange changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_ClunkVolume_SpeedAtSlopeChange[index] = val
		)
		on spn_ClunkVolume_VolumeAtSlopeChange changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_ClunkVolume_VolumeAtSlopeChange[index] = val
		)
		on spn_ClunkVolume_SpeedAtMaxVolume changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_ClunkVolume_SpeedAtMaxVolume[index] = val
		)
		on spn_ClunkVolume_MaxVolume changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_ClunkVolume_MaxVolume[index] = val
		)

		group "High Speed Clunk Volume"
		(
			spinner spn_HighSpeedClunkVolume_VolumeAtZero "Volume At Zero" range:[-100,100,-6]
			spinner spn_HighSpeedClunkVolume_SpeedAtSlopeChange "Speed At Slope Change" range:[0,300,20]
			spinner spn_HighSpeedClunkVolume_VolumeAtSlopeChange "Volume At Slope Change" range:[-100,100,-3]
			spinner spn_HighSpeedClunkVolume_SpeedAtMaxVolume "Max Speed" range:[0,300,80]
			spinner spn_HighSpeedClunkVolume_MaxVolume "Volume At Max Speed" range:[-100,100,0]
		)
		on spn_HighSpeedClunkVolume_VolumeAtZero changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_HighSpeedClunkVolume_VolumeAtZero[index] = val
		)
		on spn_HighSpeedClunkVolume_SpeedAtSlopeChange changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_HighSpeedClunkVolume_SpeedAtSlopeChange[index] = val
		)
		on spn_HighSpeedClunkVolume_VolumeAtSlopeChange changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_HighSpeedClunkVolume_VolumeAtSlopeChange[index] = val
		)
		on spn_HighSpeedClunkVolume_SpeedAtMaxVolume changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_HighSpeedClunkVolume_SpeedAtMaxVolume[index] = val
		)
		on spn_HighSpeedClunkVolume_MaxVolume changed val do
		(
			index = drpdn_CaterpillerTracksList.selection
			Sound_HighSpeedClunkVolume_MaxVolume[index] = val
		)

		group "Track Whine"
		(

			checkbox chk_Sound_WhineVolume_Active "" default:false across:2
			spinner spn_Sound_WhineVolume_VolumeAtZero "Volume At Zero" range:[-100,100,-6]
			spinner spn_Sound_WhineVolume_SpeedAtSlopeChange "Speed At Slope Change" range:[0,300,20]
			spinner spn_Sound_WhineVolume_VolumeAtSlopeChange "Volume At Slope Change" range:[-100,100,-3]
			spinner spn_Sound_WhineVolume_SpeedAtMaxVolume "Max Speed" range:[0,300,80]
			spinner spn_Sound_WhineVolume_MaxVolume "Volume At Max Speed" range:[-100,100,0]


			checkbox chk_Sound_WhinePitch_Active "" default:false across:2
			spinner spn_Sound_WhinePitch_PitchAtZero "Pitch At Zero" range:[-100,100,-6]
			spinner spn_Sound_WhinePitch_MaxSpeed "Max Speed" range:[0,300,80]
			spinner spn_Sound_WhinePitch_PitchAtMaxSpeed "Pitch At Max Speed" range:[-100,100,0]

		)

		group "Misc Settings"
		(
			checkbox chk_Damaged_FrictionFactor_Active "" default: false across:2
			spinner spn_Damaged_FrictionFactor "Damaged Friction Factor" range:[0,100,0]
			checkbox chk_Damaged_RollingResistance_Active "" default: false across:2
			spinner spn_Damaged_RollingResistance "Damaged Rolling Resistance" range:[0,100,0]

			checkbox chk_DamagedAll_FrictionFactor_Active "" default: false across:2
			spinner spn_DamagedAll_FrictionFactor "All Damaged Friction Factor" range:[0,100,0]
			checkbox chk_DamagedAll_RollingResistance_Active "" default: false across:2
			spinner spn_DamagedAll_RollingResistance "All Damaged Rolling Resistance" range:[0,100,0]
		)

		fn ChangeSelectedTrack index =
		(
			if SegmentDefinition_Name.count >= index then
			(
				txt_SegmentDefinition_Name.text = SegmentDefinition_Name[index]
				spn_SegmentDefinition_Pitch.value = SegmentDefinition_SegmentPitch[index]
				spn_SegmentDefinition_XOffset.value = SegmentDefinition_XOffset[index]

				spn_SagHeight_Lowest.value = SagHeight_LowestAllowablePoint[index]
				spn_SagHeight_Ambient.value = SagHeight_AmbientLowestPoint[index]

				spn_DamageNumParts.value = DamageMode_NumParts[index]
				spn_DamageRestitution.value = DamageMode_Restitution[index]
				spn_DamageMassPerSegment.value = DamageMode_MassPerSegment[index]

				spn_DamageWobble_SpeedForMaxWobble.value = DamageWobble_SpeedForMaxWobble[index]
				spn_DamageWobble_FreqOfMaxWobble.value = DamageWobble_FreqOfMaxWobble[index]
				spn_DamageWobble_AmpOfMaxWobble.value = DamageWobble_AmpOfMaxWobble[index]
				spn_DamageWobble_RandomVariance.value = DamageWobble_RandomVariance[index]

				spn_ClunkVolume_VolumeAtZero.value = Sound_ClunkVolume_VolumeAtZero[index]
				spn_ClunkVolume_SpeedAtSlopeChange.value = Sound_ClunkVolume_SpeedAtSlopeChange[index]
				spn_ClunkVolume_VolumeAtSlopeChange.value = Sound_ClunkVolume_VolumeAtSlopeChange[index]
				spn_ClunkVolume_SpeedAtMaxVolume.value = Sound_ClunkVolume_SpeedAtMaxVolume[index]
				spn_ClunkVolume_MaxVolume.value = Sound_ClunkVolume_MaxVolume[index]

				spn_HighSpeedClunkVolume_VolumeAtZero.value = Sound_HighSpeedClunkVolume_VolumeAtZero[index]
				spn_HighSpeedClunkVolume_SpeedAtSlopeChange.value = Sound_HighSpeedClunkVolume_SpeedAtSlopeChange[index]
				spn_HighSpeedClunkVolume_VolumeAtSlopeChange.value = Sound_HighSpeedClunkVolume_VolumeAtSlopeChange[index]
				spn_HighSpeedClunkVolume_SpeedAtMaxVolume.value = Sound_HighSpeedClunkVolume_SpeedAtMaxVolume[index]
				spn_HighSpeedClunkVolume_MaxVolume.value = Sound_HighSpeedClunkVolume_MaxVolume[index]
			)

		)
		fn CreateNewCaterpillarTrack trackname addToDropDown:true=
		(
			append SegmentDefinition_Name trackname
			append SegmentDefinition_SegmentPitch 0.175
			append SegmentDefinition_XOffset 0.0

			append SagHeight_AmbientLowestPoint 0.9
			append SagHeight_LowestAllowablePoint 0.72

			append DamageMode_NumParts -1
			append DamageMode_Restitution 0
			append DamageMode_MassPerSegment 2.0

			append DamageWobble_SpeedForMaxWobble 10.0
			append DamageWobble_FreqOfMaxWobble 5.0
			append DamageWobble_AmpOfMaxWobble 0.02
			append DamageWobble_RandomVariance 1.0

			append Sound_ClunkVolume_VolumeAtZero -6.0
			append Sound_ClunkVolume_SpeedAtSlopeChange 20
			append Sound_ClunkVolume_VolumeAtSlopeChange -3.0
			append Sound_ClunkVolume_SpeedAtMaxVolume 80
			append Sound_ClunkVolume_MaxVolume 0.0

			append Sound_HighSpeedClunkVolume_VolumeAtZero -30.0
			append Sound_HighSpeedClunkVolume_SpeedAtSlopeChange 40
			append Sound_HighSpeedClunkVolume_VolumeAtSlopeChange -6.0
			append Sound_HighSpeedClunkVolume_SpeedAtMaxVolume 80
			append Sound_HighSpeedClunkVolume_MaxVolume 0.0

			if addToDropDown then
			(
				append drpdn_CaterpillerTracksList.items (((SegmentDefinition_Name.count-1) as String ) + ": " + trackname)
				drpdn_CaterpillerTracksList.items = drpdn_CaterpillerTracksList.items
				drpdn_CaterpillerTracksList.selection = SegmentDefinition_Name.count
				ChangeSelectedTrack SegmentDefinition_Name.count
			)
		)
		fn DeleteCaterpillarTrack index =
		(
			if index > 0 then
			(
				deleteItem SegmentDefinition_Name index --name
				deleteItem SegmentDefinition_SegmentPitch index --0.175
				deleteItem SegmentDefinition_XOffset index --0.0

				deleteItem SagHeight_AmbientLowestPoint index --0.9
				deleteItem SagHeight_LowestAllowablePoint index --0.72

				deleteItem DamageMode_NumParts index ---1
				deleteItem DamageMode_Restitution index --0
				deleteItem DamageMode_MassPerSegment index --2.0

				deleteItem DamageWobble_SpeedForMaxWobble index --10.0
				deleteItem DamageWobble_FreqOfMaxWobble index --5.0
				deleteItem DamageWobble_AmpOfMaxWobble index --0.02
				deleteItem DamageWobble_RandomVariance index --1.0

				deleteItem Sound_ClunkVolume_VolumeAtZero index ---6.0
				deleteItem Sound_ClunkVolume_SpeedAtSlopeChange index --20
				deleteItem Sound_ClunkVolume_VolumeAtSlopeChange index ---3.0
				deleteItem Sound_ClunkVolume_SpeedAtMaxVolume index --80
				deleteItem Sound_ClunkVolume_MaxVolume index --0.0

				deleteItem Sound_HighSpeedClunkVolume_VolumeAtZero index ---30.0
				deleteItem Sound_HighSpeedClunkVolume_SpeedAtSlopeChange index --40
				deleteItem Sound_HighSpeedClunkVolume_VolumeAtSlopeChange index ---6.0
				deleteItem Sound_HighSpeedClunkVolume_SpeedAtMaxVolume index --80
				deleteItem Sound_HighSpeedClunkVolume_MaxVolume index --0.0
				drpdn_CaterpillerTracksList.items = deleteItem drpdn_CaterpillerTracksList.items index
				items = drpdn_CaterpillerTracksList.items
				for i=index to items.count do
				(
					items[i] = (((i-1) as String) + ": "+ SegmentDefinition_Name[i])
				)
				drpdn_CaterpillerTracksList.items = items

				ChangeSelectedTrack index
			)
			if SegmentDefinition_Name.count == 0 then CreateNewCaterpillarTrack "Track"
		)

		fn EnableTracks state =
		(

			btn_DeleteTrack.enabled = state
			btn_AddNewTrack.enabled = state
			txt_SegmentDefinition_Name.enabled = state
			spn_SegmentDefinition_Pitch.enabled =  state
			spn_SegmentDefinition_XOffset.enabled =  state

			spn_SagHeight_Lowest.enabled = state
			spn_SagHeight_Ambient.enabled = state

			spn_DamageNumParts.enabled =  state
			spn_DamageRestitution.enabled = state
			spn_DamageMassPerSegment.enabled = state

			spn_DamageWobble_SpeedForMaxWobble.enabled = state
			spn_DamageWobble_FreqOfMaxWobble.enabled =  state
			spn_DamageWobble_AmpOfMaxWobble.enabled =  state
			spn_DamageWobble_RandomVariance.enabled =  state

			spn_ClunkVolume_VolumeAtZero.enabled = state
			spn_ClunkVolume_SpeedAtSlopeChange.enabled = state
			spn_ClunkVolume_VolumeAtSlopeChange.enabled =  state
			spn_ClunkVolume_SpeedAtMaxVolume.enabled =  state
			spn_ClunkVolume_MaxVolume.enabled =  state

			spn_HighSpeedClunkVolume_VolumeAtZero.enabled = state
			spn_HighSpeedClunkVolume_SpeedAtSlopeChange.enabled =  state
			spn_HighSpeedClunkVolume_VolumeAtSlopeChange.enabled = state
			spn_HighSpeedClunkVolume_SpeedAtMaxVolume.enabled =  state
			spn_HighSpeedClunkVolume_MaxVolume.enabled = state


		)

		on CaterpillarTracksRollout open do
		(

			chk_Damaged_FrictionFactor_Active.pos = [chk_Damaged_FrictionFactor_Active.pos.x-7, chk_Damaged_FrictionFactor_Active.pos.y]
			chk_Damaged_RollingResistance_Active.pos = [chk_Damaged_RollingResistance_Active.pos.x-7, chk_Damaged_RollingResistance_Active.pos.y]
			chk_DamagedAll_FrictionFactor_Active.pos = [chk_DamagedAll_FrictionFactor_Active.pos.x-7, chk_DamagedAll_FrictionFactor_Active.pos.y]
			chk_DamagedAll_RollingResistance_Active.pos = [chk_DamagedAll_RollingResistance_Active.pos.x-7, chk_DamagedAll_RollingResistance_Active.pos.y]

			chk_Sound_WhineVolume_Active.pos = [chk_Sound_WhineVolume_Active.pos.x-7, chk_Sound_WhineVolume_Active.pos.y]
			chk_Sound_WhinePitch_Active.pos = [chk_Sound_WhinePitch_Active.pos.x-7, chk_Sound_WhinePitch_Active.pos.y]

			if SegmentDefinition_Name.count < 1 then
			(
				CreateNewCaterpillarTrack "Track" addToDropDown:false
				CaterpillerTracks_Enabled = false
			)
			else
			(
				CaterpillerTracks_Enabled = true
			)

			for i=1 to SegmentDefinition_Name.count do
			(
				drpdn_CaterpillerTracksList.items = append drpdn_CaterpillerTracksList.items (((i-1) as String ) + ": " + SegmentDefinition_Name[i])
			)
			drpdn_CaterpillerTracksList.selection = 1
			ChangeSelectedTrack 1
			EnableTracks chk_CaterpillerTracks_Enabled.checked
		)

		on btn_AddNewTrack pressed do
		(
			CreateNewCaterpillarTrack "Track"
			ChangeSelectedTrack SegmentDefinition_Name.count
		)

		on btn_DeleteTrack pressed do
		(
			DeleteCaterpillarTrack drpdn_CaterpillerTracksList.selection
		)

		on chk_CaterpillerTracks_Enabled changed state do
		(
			EnableTracks state
		)

		on drpdn_CaterpillerTracksList selected index do
		(
			ChangeSelectedTrack index
		)
	)
)

/*********************************
***** CAR STRUCT PreIK/PostIK ATTRIBUTES
*********************************/

StructureAnimationTypes = #("Rotate", "Slide", "Oscillate", "Rock", "Vibrate")
StructureAnimationControllers = #(	"CONSTANT",
												"CONSTANT_OVER_TIME",
												"SPEED",
												"SPEED_OVER_TIME",
												"WHEEL_SPEED",
												"WHEEL_SPEED_OVER_TIME",
												"WHEEL_ROTATION_FR",
												"WHEEL_ROTATION_FL",
												"WHEEL_ROTATION_RR",
												"WHEEL_ROTATION_RL",
												"STEERING",
												"STEERING_OVER_TIME",
												"ENGINE_NORMALISED_RPM",
												"ENGINE_NORMALISED_RPM_OVER_TIME",
												"ENGINE_RPM",
												"ENGINE_RPM_OVER_TIME",
												"ENGINE_CRANK_ANGLE",
												"GEARBOX_OUTPUT_ANGLE",
												"SPEED_DEPENDENT_AEROFOIL",
												"SPEED_DEPENDENT_AEROFOIL_2",
												"AIR_BRAKE")
StructurePointToPointValues = #(	"Snap Point To Other Part",
												"Rotate Point To Line On Other Part",
												"Rotate Point To Point On Other Part",
												"Rotate Point To Point On Other Part With Scaling"
)
WishboneAxelTypes = #("Wishbone Upper", "Wishbone Lower", "Strut Wishbone", "Live Axle")
WishboneWheelTypes = #("Front Left", "Front Right", "Rear Left", "Rear Right")
WishboneMountTypes = #("Wishbone Lower","Wishbone Upper", "Strut Lower", "Strut Upper", "Trailing Arm")
WishboneHubType = #("Wishbone Hub", "Strut Hub", "Live Axle Hub")
WishbonePivotAxis = #("X", "Y", "Z")


StructureTrailingArm = attributes  StructureTrailingArm_Def attribID:#(0x71611dc1, 0x11650f9f) version:1
(
	parameters main rollout:StructTrailingArm
	(
		WheelIndex type:#integer default:0
		WheelIndex_Selection type:#integer ui:dpdn_WheelIndex default:1
		MountPivot type:#maxObject
		AxlePivot type:#maxObject
	)
	rollout StructTrailingArm "Live Axle Trailing Arm"
	(
		dropdownlist dpdn_WheelIndex "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		
		label lbl_MountPivotPoint "Mount Pivot Point"
		pickbutton pck_MountPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearMountPivotPoint "Clear" across:2
		button but_SelectMountPivotPoint "Select" across:2
		
		label lbl_AxlePivotPoint "Axle Pivot Point"
		pickbutton pck_AxlePivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearAxlePivotPoint "Clear" across:2
		button but_SelectAxlePivotPoint "Select" across:2
		
		on pck_MountPivotPoint picked obj do
		(
			MountPivot = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_AxlePivotPoint picked obj do
		(
			AxlePivot = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_WheelIndex selected selectedIndex do
		(
			WheelIndex = selectedIndex-1
		)
		on but_SelectMountPivotPoint pressed do
		(
			if MountPivot != undefined then undo "Select Mount Pivot" on select MountPivot.node
		)
		on but_SelectAxlePivotPoint pressed do
		(
			if AxlePivot != undefined then undo "Select Axle Pivot" on select AxlePivot.node
		)
		on but_ClearMountPivotPoint pressed do
		(
			MountPivot = undefined
			pck_MountPivotPoint.object = undefined
		)
		on but_ClearAxlePivotPoint pressed do
		(
			AxlePivot = undefined
			pck_AxlePivotPoint.object = undefined
		)
		
		on StructTrailingArm open do
		(
			if MountPivot != undefined then pck_MountPivotPoint.object = MountPivot.node
			if AxlePivot != undefined then pck_AxlePivotPoint.object = AxlePivot.node
		)
	)
)
StructureWishboneHub = attributes StructureWishboneHubt_Def attribID:#(0xf8ff3af, 0x32cc6f09) version:1
(
	parameters main rollout:StructWishboneHub
	(
		HubType type:#string default:WishboneHubType[1]
		HubType_Selection type:#integer ui:dpdn_HubType default:1
		WheelIndex type:#integer default:0
		WheelIndex_Selection type:#integer ui:dpdn_WheelIndex default:1
		PivotAxis type:#integer default:0
		PivotAxis_Selection type:#integer ui: dpdn_PivotAxis default:1
		UpperPivotPoint type:#maxObject ui:pck_UpperPivotPoint
		LowerPivotPoint type:#maxObject ui:pck_LowerPivotPoint
		WheelPoint type:#maxObject ui:pck_Wheel
	)
	rollout StructWishboneHub "Wishbone Hub"
	(
		dropdownlist dpdn_HubType "Hub Type" items:WishboneHubType default:1 labelontop:true
		dropdownlist dpdn_PivotAxis "Pivot Axis" items:WishbonePivotAxis default:1 labelontop:true
		dropdownlist dpdn_WheelIndex "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		
		label lbl_Wheel "Wheel Position"
		pickbutton pck_Wheel "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearWheel "Clear"
		button but_SelectWheel "Select"
		label lbl_UpperPivotPoint "Upper Pivot Point"
		pickbutton pck_UpperPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearUpperPivotPoint "Clear" across:2
		button but_SelectUpperPivotPoint "Select"
		label lbl_LowerPivotPoint "Lower Pivot Point"
		pickbutton pck_LowerPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearLowerPivotPoint "Clear" across:2
		button but_SelectLowerPivotPoint "Select"
		
		fn InitFields = 
		(
			WheelIndex = WheelIndex_Selection - 1
			if HubType_Selection == 3 then
			(
				--if WheelIndex == 1 then WheelIndex = 0
				--else if WheelIndex == 3 then WheelIndex = 2
				dpdn_PivotAxis.enabled = false
				lbl_UpperPivotPoint.enabled = false
				pck_UpperPivotPoint.enabled = false
				but_ClearUpperPivotPoint.enabled = false
				but_SelectUpperPivotPoint.enabled = false
				lbl_LowerPivotPoint.enabled = false
				pck_LowerPivotPoint.enabled = false
				but_ClearLowerPivotPoint.enabled = false
				but_SelectLowerPivotPoint.enabled = false
			)
			else
			(
				dpdn_PivotAxis.enabled = true
				lbl_UpperPivotPoint.enabled = true
				pck_UpperPivotPoint.enabled = true
				but_ClearUpperPivotPoint.enabled = true
				but_SelectUpperPivotPoint.enabled = true
				lbl_LowerPivotPoint.enabled = true
				pck_LowerPivotPoint.enabled = true
				but_ClearLowerPivotPoint.enabled = true
				but_SelectLowerPivotPoint.enabled = true
			)
		)
		on pck_UpperPivotPoint picked obj do
		(
			UpperPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_LowerPivotPoint picked obj do
		(
			LowerPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_Wheel picked obj do
		(
			WheelPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_HubType selected selectedIndex do
		(
			HubType = WishboneHubType[selectedIndex]
			InitFields()
		)
		on dpdn_PivotAxis selected selectedIndex do
		(
			PivotAxis = selectedIndex-1
		)
		on dpdn_WheelIndex selected selectedIndex do
		(
			WheelIndex = selectedIndex-1
			
			if HubType_Selection == 3 then
			(
				--if WheelIndex == 1 then WheelIndex = 0
				--else if WheelIndex == 3 then WheelIndex = 2
			)
		)
		on but_SelectWheel pressed do
		(
			if WheelPoint != undefined then undo "Select Wheel Point" on select WheelPoint.node
		)
		on but_SelectUpperPivotPoint pressed do
		(
			if UpperPivotPoint != undefined then undo "Select Upper Pivot Point" on select UpperPivotPoint.node
		)
		on but_SelectLowerPivotPoint pressed do
		(
			if LowerPivotPoint != undefined then undo "Select Lower Pivot Point" on select LowerPivotPoint.node
		)
		on but_ClearWheel pressed do
		(
			WheelPoint = undefined
			pck_Wheel.object = undefined
		)
		on but_ClearUpperPivotPoint pressed do
		(
			UpperPivotPoint = undefined
			pck_UpperPivotPoint.object = undefined
		)
		on but_ClearLowerPivotPoint pressed do
		(
			LowerPivotPoint = undefined
			pck_LowerPivotPoint.object = undefined
		)
		on StructWishboneHub open do
		(
			if UpperPivotPoint != undefined then pck_UpperPivotPoint.object = UpperPivotPoint.node
			if LowerPivotPoint != undefined then pck_LowerPivotPoint.object = LowerPivotPoint.node
			if WheelPoint != undefined then pck_Wheel.object = WheelPoint.node
			InitFields()
		)
	)
)
StructureWishboneMount = attributes StructureWishboneMount_Def attribid:#(0x175ecb79, 0x72a043db) version:1
(
	parameters main rollout:StructWishboneMountRollout
	(
		MountType type:#string default:WishboneMountTypes[1]
		MountType_Selection type:#integer ui:dpdn_WishboneMountType default:1
		MountWheel type:#integer default:0
		MountWheel_Selection type:#integer ui:dpdn_WheelNumber default:1
		MountAxis type:#integer default:0
		MountAxis_Selection type:#integer ui:dpdn_MountAxis default:1
		MountPoint type:#maxObject ui:pck_MountPoint
	)
	rollout StructWishboneMountRollout "Wishbone Mount"
	(
		dropdownlist dpdn_WishboneMountType "Axel Type" items:WishboneMountTypes default:1 labelontop:true
		dropdownlist dpdn_WheelNumber "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		dropdownlist dpdn_MountAxis "Wishbone Pivot" items:WishbonePivotAxis default:1 labelontop:true
		label lbl_MountPoint "Mount Point"
		pickbutton pck_MountPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearMountPoint "Clear" across:2
		button but_SelectMountPoint "Select"
		
		fn InitFields =
		(
			if MountType_Selection == 5 then
			(
				dpdn_MountAxis.enabled = false
			)
			else 
			(
				dpdn_MountAxis.enabled = true
			)
		)
		on pck_MountPoint picked obj do
		(
			MountPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on dpdn_WishboneMountType selected selectedIndex do
		(
			MountType = WishboneMountTypes[selectedIndex]
			InitFields()
		)
		on dpdn_WheelNumber selected selectedIndex do
		(
			MountWheel = selectedIndex-1
		)
		on dpdn_MountAxis selected selectedIndex do
		(
			MountAxis = selectedIndex-1
		)
		on but_SelectMountPoint pressed do
		(
			if MountPoint != undefined then undo "Select Mount Point" on select MountPoint.node
		)
		on but_ClearMountPoint pressed do
		(
			MountPoint = undefined
			pck_MountPoint.object = undefined
		)
		on StructWishboneMountRollout open do
		(
			if MountPoint != undefined then pck_MountPoint.object = MountPoint.node
			InitFields()
		)
	)
)
StructureWishboneAxleAttributes = attributes StructureWishboneAxle_Def attribId:#(0x554a6e27, 0x293d07d) version:1
(
	parameters main rollout:StructWishboneRollout
	(
		WishboneAxleType type:#string default:WishboneAxelTypes[1]
		WishboneAxleType_Selection type:#integer ui:dpdn_WishboneAxleType default:1
		WheelNumber type:#integer default:0
		WheelNumber_Selection type:#integer ui:dpdn_WheelNumber default:1
		PivotAxis type:#integer default:0
		PivotAxis_Selection type:#integer ui:dpdn_PivotAxis default:1
		InboardPivotPoint type:#maxObject ui:pck_InboardPivotPoint
		OutboardPivotPoint type:#maxObject ui:pck_OutboardPivotPoint
	)
	rollout StructWishboneRollout "Wishbone Axle"
	(
		dropdownlist dpdn_WishboneAxleType "Axel Type" items:WishboneAxelTypes default:1 labelontop:true
		dropdownlist dpdn_WheelNumber "Axle Wheel" items:WishboneWheelTypes default:1 labelontop:true
		dropdownlist dpdn_PivotAxis "Wishbone Pivot" items:WishbonePivotAxis default:1 labelontop:true
		label lbl_InboardPivot "Inboard Pivot Point"
		pickbutton pck_InboardPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearInboardPoint "Clear" across:2
		button but_SelectInboardPoint "Select"
		label lbl_OutboardPivot "Outboard Pivot Point"
		pickbutton pck_OutboardPivotPoint "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true 
		button but_ClearOutboardPoint "Clear" across:2
		button but_SelectOutboardPoint "Select"
		
		fn InitFields =
		(
			WheelNumber = WheelNumber_Selection - 1
			
			if WishboneAxleType_Selection == 4 then
			(
				dpdn_PivotAxis.enabled = false
				lbl_InboardPivot.enabled = false
				--pck_InboardPivotPoint.enabled = false
				--but_ClearInboardPoint.enabled  = false
				--but_SelectInboardPoint.enabled = false
				
				lbl_OutboardPivot.enabled = false
				pck_OutboardPivotPoint.enabled = false
				but_ClearOutboardPoint.enabled= false
				but_SelectOutboardPoint.enabled = false
				if WheelNumber==1 then WheelNumber = 0
				if WheelNumber==3 then WheelNumber = 2
				
			)
			else
			(
				dpdn_PivotAxis.enabled = true
				lbl_InboardPivot.enabled = true
				pck_InboardPivotPoint.enabled = true
				but_ClearInboardPoint.enabled  = true
				but_SelectInboardPoint.enabled = true
				
				lbl_OutboardPivot.enabled = true
				pck_OutboardPivotPoint.enabled = true
				but_ClearOutboardPoint.enabled= true
				but_SelectOutboardPoint.enabled = true
			)
		)
		on pck_InboardPivotPoint picked obj do
		(
			InboardPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_OutboardPivotPoint picked obj do
		(
			OutboardPivotPoint = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on StructWishboneRollout open do
		(
			if InboardPivotPoint != undefined then pck_InboardPivotPoint.object = InboardPivotPoint.node
			if OutboardPivotPoint != undefined then pck_OutboardPivotPoint.object = OutboardPivotPoint.node
				
			InitFields()
		)
		
		on dpdn_WishboneAxleType selected selectedIndex do
		(
			WishboneAxleType = WishboneAxelTypes[WishboneAxleType_Selection]
			
			InitFields()
		)
		on dpdn_WheelNumber selected selectedIndex do
		(
			WheelNumber = WheelNumber_Selection - 1
			if WishboneAxleType_Selection== 4 then 
			(
				if WheelNumber==1 then WheelNumber = 0
				if WheelNumber==3 then WheelNumber = 2
			)
		)
		on dpdn_PivotAxis selected selectedIndex do
		(
			PivotAxis = PivotAxis_Selection - 1
		)
		on but_SelectInboardPoint pressed do
		(
			if InboardPivotPoint != undefined then undo "Select Inboard Pivot Point" on select InboardPivotPoint.node
		)
		on but_ClearInboardPoint pressed do
		(
			InboardPivotPoint = undefined
			pck_InboardPivotPoint.object = undefined
		)
		on but_SelectOutboardPoint pressed do
		(
			if OutboardPivotPoint != undefined then undo "Select Outboard Pivot Point" on select OutboardPivotPoint.node
		)
		on but_ClearOutboardPoint pressed do
		(
			OutboardPivotPoint = undefined
			pck_OutboardPivotPoint.object = undefined
		)
	)
)
StructureRotatePointToPointAttribute = attributes StructureRotatePointToPoint_Def attribID:#(0x1256a6ee, 0x7bda5c62) version:1
(
	parameters main rollout:MainPointToPointRollout
	(
		TypeOfPointToPoint_Selection type:#integer ui:dpdn_TypeOfPointToPoint default:1
		TypeOfPointToPoint type:#string default:StructurePointToPointValues[1]
		PreIK type:#boolean ui:chk_PreIK default: false
		PointOnThisObject type:#maxObject ui:pck_PointOnThisObject
		OtherObject type:#maxObject
		PointOnOtherObject type:#maxObject ui:pck_PointOnOtherObject
		LineTargetObject type:#maxObject ui:pck_LineTargetObject
	)
	rollout MainPointToPointRollout "Point To Point Settings"
	(
		dropdownlist dpdn_TypeOfPointToPoint items:StructurePointToPointValues labelOnTop:true
		checkbox chk_PreIK "Perform Before IK" default: false
		label lbl_PointOnThisObject "Point On This Object"
		pickbutton pck_PointOnThisObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearThisPoint "Clear" across:2
		button but_SelectThisPoint "Select"
		label lbl_OtherObject "Other Object"
		pickbutton pck_OtherObject "Pick Object" filter:target_cnt_filter autodisplay:true labelOnTop:true
		button but_ClearOtherObject "Clear" across:2
		button but_SelectOtherObject "Select"
		label lbl_PointOnOtherObject "Point On Other Object"
		pickbutton pck_PointOnOtherObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearOtherPoint "Clear" across:2
		button but_SelectOtherPoint "Select"
		label lbl_LineTargetObject "Line Target"
		pickbutton pck_LineTargetObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearLineTarget "Clear" across:2
		button but_SelectLineTarget "Select"
		
		on but_SelectThisPoint pressed do
		(
			if PointOnThisObject != undefined then undo "Select Point On This Object" on select PointOnThisObject.node
		)
		on but_ClearThisPoint pressed do
		(
			PointOnThisObject = undefined
			pck_PointOnThisObject.object = undefined
		)
		on but_SelectOtherObject pressed do
		(
			if OtherObject != undefined and OtherObject.node != undefined then undo "Select Other Object" on select OtherObject.node
		)
		on but_ClearOtherObject pressed do
		(
			OtherObject = undefined
			pck_OtherObject.object = undefined
		)
		on but_SelectOtherPoint pressed do
		(
			if PointOnOtherObject != undefined then undo "Select Point On Other Object" on select PointOnOtherObject.node
		)
		on but_ClearOtherPoint pressed do
		(
			PointOnOtherObject = undefined
			pck_PointOnOtherObject.object = undefined
		)
		on but_SelectLineTarget pressed do
		(
			if LineTargetObject != undefined then undo "Select Line Target Point" on select LineTargetObject.node
		)
		on but_ClearLineTarget pressed do
		(
			LineTargetObject = undefined
			pck_LineTargetObject.object = undefined
		)
		
		on pck_PointOnThisObject picked obj do
		(
			PointOnThisObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			pck_PointOnThisObject.object = obj
		)
		on pck_OtherObject picked obj do
		(
			OtherObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			pck_OtherObject.object = obj
		)
		on pck_PointOnOtherObject picked obj do
		(
			PointOnOtherObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			pck_PointOnOtherObject.object = obj
		)
		on pck_LineTargetObject picked obj do
		(
			LineTargetObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
			pck_LineTargetObject.object = obj
		)
		on dpdn_TypeOfPointToPoint selected selectedIndex do
		(
			TypeOfPointToPoint=StructurePointToPointValues[selectedIndex]

			if selectedIndex == 2 then
			(
				pck_LineTargetObject.enabled = true
			)
			else
			(
				pck_LineTargetObject.enabled = false
			)
		)
		fn InitFields =
		(
			if PointOnThisObject != undefined then pck_PointOnThisObject.object = PointOnThisObject.node
			if OtherObject != undefined then pck_OtherObject.object = OtherObject.node
			if PointOnOtherObject != undefined then pck_PointOnOtherObject.object = PointOnOtherObject.node
			if LineTargetObject != undefined then pck_LineTargetObject.object = LineTargetObject.node
				
			if TypeOfPointToPoint_Selection == 2 then
			(
				pck_LineTargetObject.enabled = true
			)
			else
			(
				pck_LineTargetObject.enabled = false
			)
			if TypeOfPointToPoint_Selection == 4 then
			(
				chk_PreIK.enabled = false
			)
			else 
			(
				chk_PreIK.enabled = true
			)
		)
		on MainPointToPointRollout open do
		(
			InitFields()
		)
	)
)

StructureAnimationAttributes = attributes StructureAnimation_Def attribID:#(0x42fd67ae, 0x76e6282d) version:1
(
	local VibrateRollout
	parameters main rollout:MainAnimationRollout
	(
		AnimationTypeSelection type:#integer default:1 ui:dpdn_AnimationType
		AnimationType type:#string default:"Rotate"
		
		PreIK type:#boolean default:false ui:chk_PreIK
		Axis type:#integer default:1 ui:dpdn_Axis
		
		ControlledBySelection type:#integer default:1 ui:dpdn_ControlledBy
		ControlledBy type:#string default:"CONSTANT"
		Amount type:#float default:1.0 ui:spn_Amount
		Amount2 type:#float default:1.0 ui:spn_Amount2
		CentreOfRotation type:#maxObject ui:pck_CentreOfRotation
		UseNamedObject type:#boolean default:false ui:chk_UseNamedObject
		NamedObject type:#maxObject ui:pck_NamedObject
	)
	parameters vibrateSettings rollout:VibrateRollout
	(
		MinFreq type:#float default:1.0 ui:spn_MaxFreq
		MaxFreq type:#float default:2.0 ui:spn_MaxFreq
		RandomFreq type:#float default:0.5 ui:spn_RandomFreq
		MinAmp type:#float default:1.0 ui:spn_MinAmp
		MaxAmp type:#float default:10.0 ui:spn_MaxAmp
		RandomAmp type:#float default:0.5 ui:spn_RandomAmp
	)
	rollout MainAnimationRollout "Animation Settings"
	(
		dropdownlist dpdn_AnimationType "Animation Type" labelOnTop:true items:StructureAnimationTypes
		checkbox chk_PreIK "Perform Before IK" labelOnTop:true
		dropdownlist dpdn_Axis "Local Axis" labelOnTop:true items:#("X","Y","Z")
		
		
		dropdownlist dpdn_ControlledBy "Controller" labelOnTop:true items:StructureAnimationControllers
		
		spinner spn_Amount "Amount" range:[-1000,1000,1]
		spinner spn_Amount2 "Amount 2" range:[-1000,1000,1]
		
		label lbl_CentreOfRotation "Centre Of Rotation"
		pickbutton pck_CentreOfRotation "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearCoR "Clear" across:2
		button but_SelectCoR "Select"
		checkbox chk_UseNamedObject "Use Named Object"
		pickbutton pck_NamedObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
		button but_ClearNamed "Clear" across:2
		button but_SelectNamed "Select"
		
		on pck_CentreOfRotation picked obj do
		(
			CentreOfRotation = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on pck_NamedObject picked obj do
		(
			NamedObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on but_SelectCoR pressed do
		(
			if CentreOfRotation != undefined then undo "Select Centre Of Rotation" on select CentreOfRotation.node
		)
		on but_SelectNamed pressed do
		(
			if NamedObject != undefined then undo "Select Named Object" on select NamedObject.node
		)
		on but_ClearCoR pressed do
		(
			CentreOfRotation = undefined
			pck_CentreOfRotation.object = undefined
		)
		on but_ClearNamed pressed do
		(
			NamedObject = undefined
			pck_NamedObject.object = undefined
		)
		fn InitFields =
		(
			if CentreOfRotation != undefined then pck_CentreOfRotation.object = CentreOfRotation.node
			if NamedObject != undefined then pck_NamedObject.object = NamedObject.node
			
			if chk_PreIK.checked then
			(
				chk_UseNamedObject.enabled = false
				pck_NamedObject.enabled = false
			)
			else
			(
				chk_UseNamedObject.enabled = true
				if chk_UseNamedObject.checked then
				(
					pck_NamedObject.enabled = true
				)
				else
				(
					pck_NamedObject.enabled = false
				)
			)
			chk_PreIK.enabled = false
				
			case AnimationType of
			(
				"Rotate":
				(
					spn_Amount.enabled = true
					spn_Amount.caption = "Degrees"
					spn_Amount2.enabled = false
					spn_Amount2.caption = "Amount 2"
					pck_CentreOfRotation.enabled = false
					chk_PreIK.enabled = true
				)
				"Slide":
				(
					spn_Amount.enabled = true
					spn_Amount.caption = "Distance"
					spn_Amount2.enabled = false
					spn_Amount2.caption="Amount 2"
					pck_CentreOfRotation.enabled = false
				)
				"Oscillate":
				(
					spn_Amount.enabled = true
					spn_Amount.caption = "Minimum"
					spn_Amount2.enabled = true
					spn_Amount2.caption="Maximum"
					pck_CentreOfRotation.enabled = false
				)
				"Rock":
				(
					spn_Amount.enabled =true
					spn_Amount.caption="Speed"
					spn_Amount2.caption = "Degrees"
					spn_Amount2.enabled=true
					pck_CentreOfRotation.enabled = true
				)
				"Vibrate":
				(
					pck_CentreOfRotation.enabled = true
					spn_Amount.enabled =false
					spn_Amount2.enabled =false
					spn_Amount.caption = "Amount"
					spn_Amount2.caption = "Amount 2"

				)
			)
		)
		on MainAnimationRollout open do
		(
			InitFields()
		)
		on dpdn_ControlledBy selected selectedIndex do
		(
			ControlledBy = StructureAnimationControllers[selectedIndex]
		)
		on dpdn_AnimationType selected selectedIndex do
		(
			AnimationType = StructureAnimationTypes[selectedIndex]
			--VibrateRollout.InitFields()
			InitFields()
			
			case AnimationType of
			(
				"Vibrate":
				(
					VibrateRollout.spn_MinFreq.enabled = true
					VibrateRollout.spn_MaxFreq.enabled = true
					VibrateRollout.spn_RandomFreq.enabled = true
					VibrateRollout.spn_MinAmp.enabled = true
					VibrateRollout.spn_MaxAmp.enabled = true
					VibrateRollout.spn_RandomAmp.enabled = true
				)
				default:
				(
					VibrateRollout.spn_MinFreq.enabled = false
					VibrateRollout.spn_MaxFreq.enabled = false
					VibrateRollout.spn_RandomFreq.enabled = false
					VibrateRollout.spn_MinAmp.enabled = false
					VibrateRollout.spn_MaxAmp.enabled = false
					VibrateRollout.spn_RandomAmp.enabled = false
				)
			)	
		)
		on chk_UseNamedObject changed thestate do
		(
			if thestate then 
			(
				pck_NamedObject.enabled = true
			)
			else
			(
				pck_NamedObject.enabled = false
			)
		)
	)
	rollout VibrateRollout "Vibration Settings"
	(
		spinner spn_MinFreq "Min Frequency" range:[0,100000,1]
		spinner spn_MaxFreq "Max Frequency" range:[0,100000,2]
		spinner spn_RandomFreq "Random Freq" randge:[0,1,0.5]
		spinner spn_MinAmp "Min Amplitude" range:[0,100000,1]
		spinner spn_MaxAmp "Max Amplitude" range:[0,100000,2]
		spinner spn_RandomAmp "Random Amp" randge:[0,1,0.5]
		
		fn InitFields =
		(
			case AnimationType of
			(
				"Vibrate":
				(
					spn_MinFreq.enabled = true
					spn_MaxFreq.enabled = true
					spn_RandomFreq.enabled = true
					spn_MinAmp.enabled = true
					spn_MaxAmp.enabled = true
					spn_RandomAmp.enabled = true
				)
				default:
				(
					spn_MinFreq.enabled = false
					spn_MaxFreq.enabled = false
					spn_RandomFreq.enabled = false
					spn_MinAmp.enabled = false
					spn_MaxAmp.enabled = false
					spn_RandomAmp.enabled = false
				)
			)
		)
		on VibrateRollout open do
		(
			InitFields()
		)
	)
)
/*********************************
***** CAR STRUCT WELD ATTRIBUTES
*********************************/

StructureWeldAttribute = attributes StructureWeld_Def attribID: #(0x102e05ef, 0x426da9ad) version:1
(
	parameters main rollout:MainWeldRollout
	(
		WeldName type:#string ui:txt_WeldName default:""
		WeldPartner type:#maxObject
		--VertexColour type:#color ui:colpick_VertexColour default:(color 0 255 0 0)
		VertexColourR type:#integer ui:spn_colour_r default:0
		VertexColourG type:#integer ui:spn_colour_g default:255
		VertexColourB type:#integer ui:spn_colour_b default:0
		VertexColourA type:#integer ui:spn_colour_a default:0
		WeldVertexType type:#stringTab tabSizeVariable:true
		WeldVertexPosition type:#point3Tab tabSizeVariable:true
		
		Weakness_Set type:#boolean default:false ui:chk_Weakness_Set
		Weakness type:#float default: 1.0 ui:spn_Weakness
		AbsoluteLimit_Set type:#boolean default:false ui:chk_AbsoluteLimit_Set
		AbsoluteLimit type:#float default:1.0 ui:spn_AbsoluteLimit
		ChanceOfFailure_Set type:#boolean default:false ui:chk_ChanceOfFailure_Set
		ChanceOfFailure type:#float default:1.0 ui:spn_ChanceOfFailure
		WeldBreak_Set type:#boolean default:false ui:chk_WeldBreak_Set
		WeldBreak type:#float default:1.0 ui:spn_WeldBreak
		GangedBreak type:#string ui:txt_GangedBreak default:""
	)
	parameters joints rollout:JointsRollout
	(
		Joints type:#nodeTab tabSizeVariable: true
	)
	
	rollout MainWeldRollout "Weld Parameters"
	(
		edittext txt_WeldName "Weld Name" labelOnTop:true
		pickbutton objpick_WeldPartner "Weld Partner" filter:target_cnt_filter autodisplay:true labelOnTop:true
		button but_ClearWeldPartner "Clear" across:2
		button but_SelectWeldPartner "Select" across:2
		
		checkbox chk_Weakness_Set "" across:2
		spinner spn_Weakness "Weakness" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_AbsoluteLimit_Set "" across:2
		spinner spn_AbsoluteLimit "Absolute Limit" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_ChanceOfFailure_Set "" across:2
		spinner spn_ChanceOfFailure "Chance Of Fail" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_WeldBreak_Set "" across:2
		spinner spn_WeldBreak "Break" range:[-10,100,1] type:#float fieldwidth: 40
		
		edittext txt_GangedBreak "Ganged Break" labelOnTop:true
		label lbl_colour_r "R" across: 4
		label lbl_colour_g "G" across: 4
		label lbl_colour_b "B" across: 4
		label lbl_colour_a "A" across: 4
		spinner spn_colour_r "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_g "" across:4 range:[0, 255,255] type:#integer fieldwidth: 30
		spinner spn_colour_b "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_a "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		
		--colorpicker colpick_VertexColour "Weld Vertex Colour"
		
		
		group "Weld Vertices"
		(
			checkbutton chkbut_CarSpace "Car Space" default:false across:2
			checkbutton chkbut_PartSpace "Part Space" default:false across:2
			spinner spn_WeldVertX "" type:#worldunits range:[-10000, 10000, 0] across:4 fieldwidth:30
			spinner spn_WeldVertY "" type:#worldunits range:[-10000, 10000, 0] across:4 fieldwidth:30
			spinner spn_WeldVertZ "" type:#worldunits range:[-10000, 10000, 0] across:4 fieldwidth:30
			button but_AddVertToWeld "Add" across:4
			dotnetcontrol lv_WeldVertices "listview" height: 100
			button but_DelVertFromWeld "Delete"
		)
		
		on objpick_WeldPartner picked obj do
		(
			WeldPartner = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on but_SelectWeldPartner pressed do
		(
			if WeldPartner != undefined then ( undo "Select Weld Partner" on ( select WeldPartner.node ) )
		)
		on but_ClearWeldPartner pressed do
		(
			WeldPartner = undefined
			objpick_WeldPartner.object = undefined
		)
		
		on chkbut_CarSpace changed state do
		(
			if state==true then
			(
				chkbut_PartSpace.checked = false
			)
		)
		on chkbut_CarSpace changed state do
		(
			if state==true then
			(
				chkbut_PartSpace.checked = false
			)
		)
		on chkbut_PartSpace changed state do
		(
			if state==true then
			(
				chkbut_CarSpace.checked = false
			)
		)
		fn InitFields =
		(
			chk_Weakness_Set.pos = [chk_Weakness_Set.pos.x-7, chk_Weakness_Set.pos.y]
			chk_AbsoluteLimit_Set.pos = [chk_AbsoluteLimit_Set.pos.x-7, chk_AbsoluteLimit_Set.pos.y]
			chk_ChanceOfFailure_Set.pos = [chk_ChanceOfFailure_Set.pos.x-7, chk_ChanceOfFailure_Set.pos.y]
			chk_WeldBreak_Set.pos = [chk_WeldBreak_Set.pos.x-7, chk_WeldBreak_Set.pos.y]
			
			spn_Weakness.pos = [spn_Weakness.pos.x+4, spn_Weakness.pos.y]
			spn_AbsoluteLimit.pos = [spn_AbsoluteLimit.pos.x+4, spn_AbsoluteLimit.pos.y]
			spn_ChanceOfFailure.pos = [spn_ChanceOfFailure.pos.x+4, spn_ChanceOfFailure.pos.y]
			spn_WeldBreak.pos = [spn_WeldBreak.pos.x+4, spn_WeldBreak.pos.y]
			
			if Weakness_Set then spn_Weakness.enabled = true
			else spn_Weakness.enabled = false
			
			if AbsoluteLimit_Set then spn_AbsoluteLimit.enabled = true
			else spn_AbsoluteLimit.enabled = false
			
			if ChanceOfFailure_Set then spn_ChanceOfFailure.enabled = true
			else spn_ChanceOfFailure.enabled = false
			
			if WeldBreak_Set then spn_WeldBreak.enabled  = true
			else spn_WeldBreak.enabled = false
		)
		on chk_Weakness_Set changed state do
		(
			spn_Weakness.enabled = state
		)
		on chk_AbsoluteLimit_Set changed state do
		(
			spn_AbsoluteLimit.enabled = state
		)
		on chk_ChanceOfFailure_Set changed state do
		(
			spn_ChanceOfFailure.enabled = state
		)
		on chk_WeldBreak_Set changed state do
		(
			spn_WeldBreak.enabled = state
		)
		on MainWeldRollout open do
		(			
			InitFields()
			if WeldPartner != undefined then objpick_WeldPartner.object = WeldPartner.node
			
			but_AddVertToWeld.pos = [120, but_AddVertToWeld.pos.y]
			lv_WeldVertices.view  = (dotnetclass "view").details
			lv_WeldVertices.fullrowselect= true
			lv_WeldVertices.gridlines = true
			lv_WeldVertices.multiselect =false
			lv_WeldVertices.columns.add "Space" 35
			lv_WeldVertices.columns.add "X" 25
			lv_WeldVertices.columns.add "Y" 25
			lv_WeldVertices.columns.add "Z" 25
			for i=1 to WeldVertexPosition.count do
			(
				lvItem = dotnetobject "listviewitem" WeldVertexType[i]
				lvitem.subitems.add (WeldVertexPosition[i].x as string)
				lvitem.subitems.add (WeldVertexPosition[i].y as string)
				lvitem.subitems.add (WeldVertexPosition[i].z as string)
				lv_WeldVertices.Items.add lvitem
			)
			lbl_colour_r.pos = [15,lbl_colour_r.pos.y]
			spn_colour_r.pos = [spn_colour_r.pos.x - 8,spn_colour_r.pos.y]
			
			lbl_colour_g.pos = [spn_colour_r.pos.x+25,lbl_colour_g.pos.y]
			spn_colour_g.pos = [spn_colour_g.pos.x - 1,spn_colour_r.pos.y]
			
			lbl_colour_b.pos = [spn_colour_g.pos.x+25,lbl_colour_b.pos.y]
			spn_colour_b.pos = [spn_colour_b.pos.x+6,spn_colour_r.pos.y]
			
			lbl_colour_a.pos = [spn_colour_b.pos.x+25,lbl_colour_a.pos.y]
			spn_colour_a.pos = [spn_colour_a.pos.x + 13,spn_colour_r.pos.y]
		)
		on but_DelVertFromWeld pressed do
		(
			if lv_WeldVertices.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_WeldVertices.SelectedIndices.Item[0]
				lv_WeldVertices.Items.removeat selectedIndex
				deleteItem WeldVertexType (selectedIndex+1)
				deleteItem WeldVertexPosition (selectedIndex+1)
			)
		)
		on but_AddVertToWeld pressed do
		(
			
			weldType = undefined
			if chkbut_CarSpace.checked == true then weldType="Car"
			else if chkbut_PartSpace.checked then weldType="Part"
			if weldType!= undefined then
			(				
				lvItem = dotnetobject "listviewitem" weldType
				lvItem.subitems.add (spn_WeldVertX.value as string)
				lvItem.subitems.add (spn_WeldVertY.value as string)
				lvItem.subitems.add (spn_WeldVertZ.value as string)
				lv_WeldVertices.Items.add lvItem
				append WeldVertexType weldType
				append WeldVertexPosition [spn_WeldVertX.value, spn_WeldVertY.value, spn_WeldVertZ.value]
			)
		)
	)
	rollout jointsrollout "Joints"
	(
		group "Joints"
		(
			pickbutton pckbut_WeldJoint "Pick Joint" filter:pickJointFilter autodisplay:true
			button but_AddJoint "Add Joint"
			
			dotnetcontrol lv_Joints "listview" height: 100
			button but_DeleteJoint "Delete Joint"
		)
		
		on jointsrollout open do
		(
			lv_Joints.view  = (dotnetclass "view").details
			lv_Joints.fullrowselect= true
			lv_Joints.gridlines = true
			lv_Joints.multiselect =false
			lv_Joints.columns.add "Joint Name" 110
			for i=1 to Joints.count do
			(
				lv_Joints.Items.add joints[i].name
			)
		)
		on but_AddJoint pressed do
		(
			if pckbut_WeldJoint.object != undefined then
			(
				append joints pckbut_WeldJoint.object
				lv_Joints.Items.add pckbut_WeldJoint.object.name
				pckbut_WeldJoint.object = undefined
			)
		)
		on but_DeleteJoint pressed do
		(
			if lv_Joints.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_Joints.SelectedIndices.Item[0]
				lv_Joints.Items.removeat selectedIndex
				deleteItem Joints (selectedIndex+1)
			)
		)
	)
)
/*********************************
***** CAR STRUCT PART ATTRIBUTES
*********************************/
StructPhysProps = #(
	"NONE",
	"FRONT_LEFT_WHEEL",
	"FRONT_RIGHT_WHEEL",
	"REAR_LEFT_WHEEL",
	"REAR_RIGHT_WHEEL",
	"FRONT_LEFT_POINT_OF_ROTATION",
	"FRONT_RIGHT_POINT_OF_ROTATION",
	"REAR_LEFT_POINT_OF_ROTATION",
	"REAR_RIGHT_POINT_OF_ROTATION",
	"FRONT_LEFT_POINT_OF_SUSPENSION",
	"REAR_LEFT_POINT_OF_SUSPENSION",
	"FRONT_RIGHT_POINT_OF_SUSPENSION",
	"REAR_RIGHT_POINT_OF_SUSPENSION",
	"FRONT_LEFT_POINT_OF_STEERING",
	"REAR_LEFT_POINT_OF_STEERING",
	"FRONT_RIGHT_POINT_OF_STEERING",
	"REAR_RIGHT_POINT_OF_STEERING",
	"LEFT_STEERING",
	"RIGHT_STEERING",
	"STEERING_WHEEL"
)

StructFunctionalLightTypes = #(
	"HEAD_LIGHT",
	"SIDE_LIGHT",
	"REVERSE_LIGHT",
	"BRAKE_LIGHT",
	"TAIL_LIGHT",
	"SIREN_LIGHT",
	"STROBE1_LIGHT",
	"STROBE2_LIGHT"
)

StructurePartAttribute = attributes StructurePart_Def attribID:#(0x70f93a7a, 0x40afe183) version:1
(
	
	parameters renderLevel rollout:RenderLevelParams
	(
		RenderLevel_Set type:#boolean default:true ui:chk_RenderLevel_Set
		RenderLevel type:#integer default:1 ui:spn_RenderLevel
		LumpRenderLevel_Node type:#maxobjectTab tabSizeVariable:true
		LumpRenderLevel_Value type:#intTab tabSizeVariable:true
	)
	
	rollout RenderLevelParams "Render Level"
	(
		checkbox chk_RenderLevel_Set "" across:2
		spinner spn_RenderLevel "Render Level" range:[1,100,1] type:#integer fieldwidth: 40
		
		label lbl_LumpRenderLevel "Named Render Level"
		pickbutton pck_LumpRenderLevel_Node "Pick Object" filter:target_helper_filter autodisplay:true across:3
		spinner spn_LumpRenderLevel_Value "" range:[1,100,1] type:#integer fieldwidth:40 across:3
		button but_AddLumpRenderLevel "Add"
		dotnetcontrol lv_LumpRenderLevel "listview" height: 100
		button but_DeleteLumpRenderLevel "Delete Selected"
		
		on RenderLevelParams open do
		(			
			but_AddLumpRenderLevel.pos = [125, but_AddLumpRenderLevel.pos.y]
			spn_LumpRenderLevel_Value.pos = [spn_LumpRenderLevel_Value.pos.x+18, but_AddLumpRenderLevel.pos.y+3]
			lv_LumpRenderLevel.view  = (dotnetclass "view").details
			lv_LumpRenderLevel.fullrowselect= true
			lv_LumpRenderLevel.gridlines = true
			lv_LumpRenderLevel.multiselect =false
			lv_LumpRenderLevel.columns.add "Object" 70
			lv_LumpRenderLevel.columns.add "Level" 40
			for i=1 to LumpRenderLevel_Node.count do
			(
				if LumpRenderLevel_Node[i] == undefined or LumpRenderLevel_Node[i].node == undefined then
				(
					deleteitem LumpRenderLevel_Node i
					i = i - 1;
				)
				else
				(
					lvItem = dotnetobject "listviewitem" LumpRenderLevel_Node[i].node.name
					lvitem.subitems.add (LumpRenderLevel_Value[i] as string)
					lv_LumpRenderLevel.Items.add lvitem
				)
			)
		)
		on but_AddLumpRenderLevel pressed do
		(
			if pck_LumpRenderLevel_Node.object != undefined then
			(
				append LumpRenderLevel_Node (nodeTransformMonitor node:pck_LumpRenderLevel_Node.object forwardTransformChangeMsgs:false)
				append LumpRenderLevel_Value spn_LumpRenderLevel_Value.value
				lvItem = dotnetobject "listviewitem" pck_LumpRenderLevel_Node.object.name
				lvitem.subitems.add (spn_LumpRenderLevel_Value.value as string)
				lv_LumpRenderLevel.Items.add lvitem
			)
		)
		on but_DeleteLumpRenderLevel pressed do
		(
			if lv_LumpRenderLevel.SelectedIndices.count > 0 then
			(
				if LumpRenderLevel_Node.count > 0 then deleteItem LumpRenderLevel_Node (lv_LumpRenderLevel.SelectedIndices.Item[0] + 1)
				if LumpRenderLevel_Value.count > 0 then deleteItem LumpRenderLevel_Value (lv_LumpRenderLevel.SelectedIndices.Item[0] + 1)
				lv_LumpRenderLevel.Items.removeat lv_LumpRenderLevel.SelectedIndices.Item[0]
			)
		)
	)
	parameters main rollout:StructurePartParams
	(
		Crushability_Set type:#boolean default:false ui:chk_Crushability_set
		Crushability type:#float default:1 ui:spn_Crushability
		Stiffness_Set type:#boolean default:false ui:chk_Stiffness_Set
		Stiffness type:#float default: 0.3 ui:spn_Stiffness
		Resiliance_Set type:#boolean default:false ui:chk_Resiliance_Set
		Resiliance type:#float default:5 ui:spn_Resiliance
		Mass_Set type:#boolean default:false ui:chk_Mass_Set
		Mass type:#float default:100 ui:spn_Mass
		Restitution_Set type:#boolean default:false ui:chk_Restitution_Set
		Restitution type:#float default:100 ui:spn_Restitution
		
		--ShapeType_Set type:#boolean default:false ui:chk_ShapeType
		
		
		
	)
	rollout StructurePartParams "Basic Settings"
	(
		checkbox chk_Crushability_set "" across:2
		spinner spn_Crushability "Crushability" range:[-10,100,1] type:#float fieldwidth: 40
		checkbox chk_Stiffness_Set "" across:2
		spinner spn_Stiffness "Stiffness" range:[0,1,0.3] fieldwidth: 40
		checkbox chk_Resiliance_Set "" across:2
		spinner spn_Resiliance "Resiliance" range:[0,100,5] fieldwidth: 40
		checkbox chk_Mass_Set "" across:2
		spinner spn_Mass "Mass" range:[0,10000,100] fieldwidth: 40
		checkbox chk_Restitution_Set "" across:2
		spinner spn_Restitution "Restitution" range:[0,100,2] fieldwidth: 40
		
		
		on StructurePartParams open do
		(
			spn_Crushability.enabled =Crushability_Set
			spn_Stiffness.enabled =Stiffness_Set
			spn_Resiliance.enabled =Resiliance_Set
			spn_Mass.enabled =Mass_Set
		)
		on StructurePartParams close do
		(
		)
		
		on chk_Crushability_set changed state do
		(
			spn_Crushability.enabled = state
		)
		on chk_Stiffness_Set changed state do
		(
			spn_Stiffness.enabled = state
		)
		on chk_Resiliance_Set changed state do
		(
			spn_Resiliance.enabled = state
		)
		on chk_Mass_Set changed state do
		(
			spn_Mass.enabled = state
		)
	)
	
	
	parameters physicsProps rollout:PhysicsPropertiesParams
	(
		
		AlwaysJointed type:#boolean default:false ui:chk_AlwaysJointed
		PhysicsProperties type:#stringTab tabSizeVariable:true
		ShapeType type:#string ui:txt_ShapeType default: ""
		CollisionBoundsMultiplier_Set type:#boolean default: false ui:chk_CollisionBoundsMultiplier_Set
		CollisionBoundsMultiplier_X type:#float ui:spn_CollisionBoundsMultiplier_X default:1.0
		CollisionBoundsMultiplier_Y type:#float ui:spn_CollisionBoundsMultiplier_Y default:1.0
		CollisionBoundsMultiplier_Z type:#float ui:spn_CollisionBoundsMultiplier_Z default:1.0
	)
	rollout PhysicsPropertiesParams "Physics Properties"
	(
		checkbox chk_AlwaysJointed "Always Jointed"
		
		--checkbox chk_ShapeType "" across:2 width: 5
		edittext txt_ShapeType "Shape Type" fieldwidth:100 labelontop:true
		
		checkbox chk_CollisionBoundsMultiplier_Set "" default: false across: 2
		label lbl_chk_CollisionBoundsMultiplier "Collision Bounds Multiplier"
		spinner spn_CollisionBoundsMultiplier_X "" range:[1,100,1] across:3 fieldwidth:30
		spinner spn_CollisionBoundsMultiplier_Y "" range:[1,100,1] across:3 fieldwidth:30
		spinner spn_CollisionBoundsMultiplier_Z "" range:[1,100,1] across:3 fieldwidth:30
		
		label lbl_PhysicsProperties "Manage Physics Properties"
		dropdownlist dpdn_PhysicsProperty "" items:StructPhysProps width: 100 across:2
		button AddToPhysprops "Add" across:2
		dotnetcontrol lv_PhysicsProperties "listview" height: 100
		button DeleteFromPhysProps "Delete Selected"
		
		on lv_PhysicsProperties selectedindexchanged do
		(
			if lv_PhysicsProperties.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_PhysicsProperties.Items.item[lv_PhysicsProperties.SelectedIndices.Item[0]].text
				dpdn_PhysicsProperty.selection = finditem StructPhysProps selectedItem
			)
		)
		on PhysicsPropertiesParams open do
		(			
			AddToPhysprops.pos = [120, AddToPhysprops.pos.y]
			lv_PhysicsProperties.view  = (dotnetclass "view").details
			lv_PhysicsProperties.fullrowselect= true
			lv_PhysicsProperties.gridlines = true
			lv_PhysicsProperties.multiselect =false
			lv_PhysicsProperties.columns.add "Physics Property" 110
			for i=1 to PhysicsProperties.count do
			(
				lv_PhysicsProperties.Items.add PhysicsProperties[i]
			)
		)
		on PhysicsPropertiesParams close do
		(
			PhysicsProperties = #()
			for i=1 to lv_PhysicsProperties.Items.count do
			(
				append PhysicsProperties lv_PhysicsProperties.Items.Item[i-1].Text
			)
		)
		on DeleteFromPhysProps pressed do
		(
			if lv_PhysicsProperties.SelectedIndices.count > 0 then lv_PhysicsProperties.Items.removeat lv_PhysicsProperties.SelectedIndices.Item[0]
		)
		on AddToPhysprops pressed do
		(
			lv_PhysicsProperties.Items.add (dpdn_PhysicsProperty.selected)
		)
	)
	
	
	parameters driverBox rollout:DriverBoxParams
	(
		DriverBoxVertexColour_R type:#intTab tabSizeVariable:true
		DriverBoxVertexColour_G type:#intTab tabSizeVariable:true
		DriverBoxVertexColour_B type:#intTab tabSizeVariable:true
		DriverBoxVertexColour_A type:#intTab tabSizeVariable:true
	)
	rollout DriverBoxParams "Driver Box"
	(
		dotnetcontrol lv_DriverBox "listview" height: 100
		--colorpicker colpick_DriverBox "Add Driver Box Vertex Colour"
		spinner spn_colour_r "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_g "" across:4 range:[0, 255,255] type:#integer fieldwidth: 30
		spinner spn_colour_b "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		spinner spn_colour_a "" across:4 range:[0, 255,0] type:#integer fieldwidth: 30
		button but_AddDriverBox "Add" across:2
		button but_RemoveDriverBox "Remove" across:2
		
		on DriverBoxParams open do
		(
			
			lv_DriverBox.view  = (dotnetclass "view").details
			lv_DriverBox.fullrowselect= true
			lv_DriverBox.gridlines = true
			lv_DriverBox.multiselect =false
			lv_DriverBox.columns.add "Driver Box Colour" 130
			for i=1 to DriverBoxVertexColour_R.count do
			(
				lv_DriverBox.Items.add ((DriverBoxVertexColour_R[i] as string)+", "+(DriverBoxVertexColour_G[i] as string)+", "+(DriverBoxVertexColour_B[i] as string)+", "+(DriverBoxVertexColour_A[i] as string))
			)
		)
		on but_AddDriverBox pressed do
		(
			append DriverBoxVertexColour_R spn_colour_r.value
			append DriverBoxVertexColour_G spn_colour_g.value
			append DriverBoxVertexColour_B spn_colour_b.value
			append DriverBoxVertexColour_A spn_colour_a.value
			
			lv_DriverBox.Items.add (( spn_colour_r.value as string)+", "+( spn_colour_g.value as string)+", "+( spn_colour_b.value as string)+", "+( spn_colour_a.value as string))
		)
		on but_RemoveDriverBox pressed do
		(
			if lv_DriverBox.SelectedIndices.count > 0 then 
			(
				selectedIndex = lv_DriverBox.SelectedIndices.Item[0]
				lv_DriverBox.Items.removeat selectedIndex --lv_FunctionalLights.SelectedIndices.Item[0]
				deleteItem DriverBoxVertexColour_R (selectedIndex+1)
				deleteItem DriverBoxVertexColour_G (selectedIndex+1)
				deleteItem DriverBoxVertexColour_B (selectedIndex+1)
				deleteItem DriverBoxVertexColour_A (selectedIndex+1)
				
			)
		)
	)
	
	
	parameters functionalLight rollout:FunctionalLightParams
	(
		FunctionalLightType type:#stringTab tabSizeVariable:true
		FunctionalLightObject type:#maxObjectTab tabSizeVariable:true
	)
	rollout FunctionalLightParams "Functional Lights"
	(
		
		dropdownlist dpdn_FunctionalLightTypes "Light Type" items:StructFunctionalLightTypes width: 130
		--label lbl_FunctionalLightObject "Light Object" across:2
		pickbutton pickbut_FunctionalLightObject "Pick Object" filter:target_helper_filter autodisplay:true across:2
		button AddToFuncLights "Add" 
		dotnetcontrol lv_FunctionalLights "listview" height: 100
		button DeleteFromFuncLights "Delete" across:2
		button SelectLights "Select Object"
		
		on FunctionalLightParams open do
		(
			lv_FunctionalLights.view  = (dotnetclass "view").details
			lv_FunctionalLights.fullrowselect= true
			lv_FunctionalLights.gridlines = true
			lv_FunctionalLights.multiselect =false
			lv_FunctionalLights.columns.add "Type" 55
			lv_FunctionalLights.columns.add "Object" 55
			for i=1 to FunctionalLightType.count do
			(
				lvItem = dotnetobject "listviewitem" FunctionalLightType[i]
				lvitem.subitems.add FunctionalLightObject[i].node.name
				lv_FunctionalLights.Items.add lvitem
			)
		)
		on FunctionalLightParams close do
		(
			
		)
		on lv_FunctionalLights selectedindexchanged do
		(
			/*if lv_FunctionalLights.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_FunctionalLights.SelectedIndices.Item[0]
				lightType = FunctionalLightType[selectedItem+1] --lv_FunctionalLights.Items.item[selectedItem].text
				lightObject = FunctionalLightObject[selectedItem+1]
				dpdn_FunctionalLightTypes.selection = finditem StructFunctionalLightTypes lightType
				pickbut_FunctionalLightObject.object = lightObject
			)*/
		)
		on SelectLights pressed do
		(
			if lv_FunctionalLights.SelectedIndices.count > 0 then 
			(
				selectedItem = lv_FunctionalLights.SelectedIndices.Item[0]
				undo "Select Functional Light" on select FunctionalLightObject[selectedItem+1].node
			)
		)
		on DeleteFromFuncLights pressed do
		(
			if lv_FunctionalLights.SelectedIndices.count > 0 then 
			(
				selectedIndex = lv_FunctionalLights.SelectedIndices.Item[0]
				lv_FunctionalLights.Items.removeat selectedIndex --lv_FunctionalLights.SelectedIndices.Item[0]
				deleteItem FunctionalLightType (selectedIndex+1)
				deleteItem FunctionalLightObject (selectedIndex+1)
				
			)
		)
		on AddToFuncLights pressed do
		(
			if pickbut_FunctionalLightObject.object != undefined then
			(
				lvItem = dotnetobject "listviewitem" dpdn_FunctionalLightTypes.selected
				lvitem.subitems.add pickbut_FunctionalLightObject.object.name
				lv_FunctionalLights.Items.add lvitem
				append FunctionalLightType dpdn_FunctionalLightTypes.selected
				append FunctionalLightObject (nodeTransformMonitor node:pickbut_FunctionalLightObject.object forwardTransformChangeMsgs:false)
				pickbut_FunctionalLightObject.object = undefined
				dpdn_FunctionalLightTypes.selection=1
			)
			else messageBox "Please select an object for the light." Title:"No Object Selected"
		)
	)
	
	parameters crushDamage rollout:CrushDamageParams
	(
		
		DriverEjectionSmash type:#boolean default:false ui:chk_DriverEjectionSmash
		
		CrushDamageMaterialLevel type:#intTab tabSizeVariable:true
		CrushDamageMaterialOriginalMaterial type:#stringTab tabSizeVariable:true
		CrushDamageMaterialTargetMaterial type:#stringTab tabSizeVariable:true
		
		CrushDamageEmitterLevel type:#intTab tabSizeVariable:true
		CrushDamageEmitterName type:#stringTab tabSizeVariable:true
		CrushDamageEmitterPosition type:#maxObjectTab tabSizeVariable:true
		
	)
	rollout CrushDamageParams "Advanced Crush Damage"
	(
		
		checkbox chk_DriverEjectionSmash "Driver Ejection Smash"
		dropdownlist dpdn_CrushDamageMaterialLevel "Crush Damage Materials" labelontop:true items:#("New...")
		group "Crush Damage Material Settings"
		(
			--spinner spn_CrushDamageMaterialLevel "Damage Level" range:[-10,-1,-1] fieldwidth:30 type:#integer
			checkbutton chkbut_CurshDamageMaterialLevel1 "-1" across:5
			checkbutton chkbut_CurshDamageMaterialLevel2 "-2" across:5
			checkbutton chkbut_CurshDamageMaterialLevel3 "-3" across:5
			checkbutton chkbut_CurshDamageMaterialLevel4 "-4" across:5
			checkbutton chkbut_CurshDamageMaterialLevel5 "-5" across:5
			--dropdownlist dpdn_CrushDamageMaterialOriginalMaterial "Material To Change" items:#()
			edittext txt_CrushDamageMaterialOriginalMaterial "Original Material Name" labelontop:true
			edittext txt_CrushDamageMaterialTargetMaterial "Damaged Material Name" labelontop:true
			button but_AddCrushDamageMaterial "Set" across:2
			button but_DeleteCrushDamageMaterial "Delete" across:2
		)
		
		on chkbut_CurshDamageMaterialLevel1 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel2 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel1.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel3 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel1.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel4 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel1.checked=false
				chkbut_CurshDamageMaterialLevel5.checked=false
			)
		)
		on chkbut_CurshDamageMaterialLevel5 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageMaterialLevel2.checked=false
				chkbut_CurshDamageMaterialLevel3.checked=false
				chkbut_CurshDamageMaterialLevel4.checked=false
				chkbut_CurshDamageMaterialLevel1.checked=false
			)
		)
		fn UpdateCrushDamageMaterial selectedIndex =
		(
			
			if selectedIndex > 1 then
			(
				dmgLevel = CrushDamageMaterialLevel[selectedIndex-1]
				if dmgLevel == -1 then 
				(
					chkbut_CurshDamageMaterialLevel1.checked = true
					chkbut_CurshDamageMaterialLevel1.changed true
				)
				else if dmgLevel == -2 then 
				(
					chkbut_CurshDamageMaterialLevel2.checked = true
					chkbut_CurshDamageMaterialLevel2.changed true
				)
				else if dmgLevel == -3 then
				(
					chkbut_CurshDamageMaterialLevel3.checked = true
					chkbut_CurshDamageMaterialLevel3.changed true
				)
				else if dmgLevel == -4 then
				(
					chkbut_CurshDamageMaterialLevel4.checked = true
					chkbut_CurshDamageMaterialLevel4.changed true
				)
				else if dmgLevel == -5 then
				(
					chkbut_CurshDamageMaterialLevel5.checked = true
					chkbut_CurshDamageMaterialLevel5.changed true
				)
				txt_CrushDamageMaterialOriginalMaterial.text = CrushDamageMaterialOriginalMaterial[selectedIndex-1]
				txt_CrushDamageMaterialTargetMaterial.text = CrushDamageMaterialTargetMaterial[selectedIndex-1]
			)
			else
			(
				chkbut_CurshDamageMaterialLevel1.checked = false
				chkbut_CurshDamageMaterialLevel2.checked = false
				chkbut_CurshDamageMaterialLevel3.checked = false
				chkbut_CurshDamageMaterialLevel4.checked = false
				chkbut_CurshDamageMaterialLevel5.checked = false
				txt_CrushDamageMaterialOriginalMaterial.text = ""
				txt_CrushDamageMaterialTargetMaterial.text = ""
			)
		)
		on but_DeleteCrushDamageMaterial pressed do
		(
			if dpdn_CrushDamageMaterialLevel.selection > 1 then
			(
				selectedIndex = dpdn_CrushDamageMaterialLevel.selection - 1
				deleteItem CrushDamageMaterialLevel selectedIndex
				deleteItem CrushDamageMaterialOriginalMaterial selectedIndex
				deleteItem CrushDamageMaterialTargetMaterial selectedIndex
				crushDamageMaterialListItems =  dpdn_CrushDamageMaterialLevel.items
				deleteItem crushDamageMaterialListItems dpdn_CrushDamageMaterialLevel.selection
				dpdn_CrushDamageMaterialLevel.items = crushDamageMaterialListItems
				
				if selectedIndex + 1 > dpdn_CrushDamageMaterialLevel.items.count then
				(
					dpdn_CrushDamageMaterialLevel.selection = dpdn_CrushDamageMaterialLevel.items.count
				)
					UpdateCrushDamageMaterial dpdn_CrushDamageMaterialLevel.items.count
			)
		)
		on but_AddCrushDamageMaterial pressed do
		(
			dmgLevel = 0
			if chkbut_CurshDamageMaterialLevel1.checked then dmgLevel=-1
			else if chkbut_CurshDamageMaterialLevel2.checked then dmgLevel=-2
			else if chkbut_CurshDamageMaterialLevel3.checked then dmgLevel=-3
			else if chkbut_CurshDamageMaterialLevel4.checked then dmgLevel=-4
			else if chkbut_CurshDamageMaterialLevel5.checked then dmgLevel=-5
			if dmgLevel != 0 and txt_CrushDamageMaterialOriginalMaterial.text != "" and txt_CrushDamageMaterialTargetMaterial.text != "" then
			(
				crushDamageMaterialListItems =  dpdn_CrushDamageMaterialLevel.items 
				if dpdn_CrushDamageMaterialLevel.selection == 1 then
				(
					append CrushDamageMaterialLevel dmgLevel
					append CrushDamageMaterialOriginalMaterial txt_CrushDamageMaterialOriginalMaterial.text
					append CrushDamageMaterialTargetMaterial txt_CrushDamageMaterialTargetMaterial.text
					i = CrushDamageMaterialLevel.count
					append crushDamageMaterialListItems ((CrushDamageMaterialLevel[i] as string)+": "+(CrushDamageMaterialOriginalMaterial[i] as string)+" -> "+(CrushDamageMaterialTargetMaterial[i] as string))
					--dpdn_CrushDamageMaterialLevel.selection = dpdn_CrushDamageMaterialLevel.items.count
				)
				else
				(
					i = dpdn_CrushDamageMaterialLevel.selection-1
					CrushDamageMaterialLevel[i] = dmgLevel
					CrushDamageMaterialOriginalMaterial[i] = txt_CrushDamageMaterialOriginalMaterial.text
					CrushDamageMaterialTargetMaterial[i] = txt_CrushDamageMaterialTargetMaterial.text
					crushDamageMaterialListItems[i+1] = ((CrushDamageMaterialLevel[i] as string)+": "+(CrushDamageMaterialOriginalMaterial[i] as string)+" -> "+(CrushDamageMaterialTargetMaterial[i] as string))
				)
				dpdn_CrushDamageMaterialLevel.items  = crushDamageMaterialListItems
				dpdn_CrushDamageMaterialLevel.selection = i+1
				printArrayInFull CrushDamageMaterialLevel "CrushDamageMaterialLevel"
				printArrayInFull CrushDamageMaterialOriginalMaterial "CrushDamageMaterialOriginalMaterial"
				printArrayInFull CrushDamageMaterialTargetMaterial "CrushDamageMaterialTargetMaterial"
			)
			else
			(
				msg = ""
				if dmgLevel == 0 then msg += "Please select a damage level.\n"
				if txt_CrushDamageMaterialOriginalMaterial.text == "" then msg += "Please add the original material name.\n"
				if txt_CrushDamageMaterialTargetMaterial.text == "" then msg += "Please add a target material name.\n"
				messageBox msg title:"Error Adding Crush Damage Material"
			)
			
		)
		on dpdn_CrushDamageMaterialLevel selected selectedIndex do
		(
			UpdateCrushDamageMaterial selectedIndex
		)
		dropdownlist dpdn_CrushDamageEmitterLevel "Crush Damage Emitters" labelontop:true items:#("New...")
		group "Crush Damage Emitter Settings"
		(
			
			--spinner spn_CrushDamageEmitterLevel  "Damage Level" range:[-10,-1,-1] fieldwidth:30 type:#integer
			
			checkbutton chkbut_CurshDamageEmitterLevel1 "-1" across:5
			checkbutton chkbut_CurshDamageEmitterLevel2 "-2" across:5
			checkbutton chkbut_CurshDamageEmitterLevel3 "-3" across:5
			checkbutton chkbut_CurshDamageEmitterLevel4 "-4" across:5
			checkbutton chkbut_CurshDamageEmitterLevel5 "-5" across:5
			edittext txt_CrushDamageEmitterName "Emitter Name"
			label lbl_CrushDamageEmitterTarget "Spawn Point" across:2
			pickbutton pickbut_CrushDamageEmitterTarget "Pick Point" filter:target_helper_filter autodisplay:true
			
			button but_AddCrushDamageEmitter "Set" across:3
			button but_DeleteCrushDamageEmitter "Delete" across:3
			button but_SelectCrushDamageEmitter "Select" across:3
		)
		
		on chkbut_CurshDamageEmitterLevel1 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel2 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel1.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel3 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel1.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel4 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel1.checked=false
				chkbut_CurshDamageEmitterLevel5.checked=false
			)
		)
		on chkbut_CurshDamageEmitterLevel5 changed state do
		(
			if state==true then
			(
				chkbut_CurshDamageEmitterLevel2.checked=false
				chkbut_CurshDamageEmitterLevel3.checked=false
				chkbut_CurshDamageEmitterLevel4.checked=false
				chkbut_CurshDamageEmitterLevel1.checked=false
			)
		)
		fn UpdateCrushDamageEmitter selectedIndex =
		(
			--format "blach %\n" dpdn_CrushDamageEmitterLevel.selection
			if selectedIndex > 1 then
			(
				dmgLevel = CrushDamageEmitterLevel[selectedIndex-1]
				if dmgLevel == -1 then 
				(
					chkbut_CurshDamageEmitterLevel1.checked = true
					chkbut_CurshDamageEmitterLevel1.changed true
				)
				else if dmgLevel == -2 then 
				(
					chkbut_CurshDamageEmitterLevel2.checked = true
					chkbut_CurshDamageEmitterLevel2.changed true
				)
				else if dmgLevel == -3 then
				(
					chkbut_CurshDamageEmitterLevel3.checked = true
					chkbut_CurshDamageEmitterLevel3.changed true
				)
				else if dmgLevel == -4 then
				(
					chkbut_CurshDamageEmitterLevel4.checked = true
					chkbut_CurshDamageEmitterLevel4.changed true
				)
				else if dmgLevel == -5 then
				(
					chkbut_CurshDamageEmitterLevel5.checked = true
					chkbut_CurshDamageEmitterLevel5.changed true
				)
				txt_CrushDamageEmitterName.text = CrushDamageEmitterName[selectedIndex-1]
				pickbut_CrushDamageEmitterTarget.object = CrushDamageEmitterPosition[selectedIndex-1].node
			)
			else
			(
				chkbut_CurshDamageEmitterLevel1.checked = false
				chkbut_CurshDamageEmitterLevel2.checked = false
				chkbut_CurshDamageEmitterLevel3.checked = false
				chkbut_CurshDamageEmitterLevel4.checked = false
				chkbut_CurshDamageEmitterLevel5.checked = false
				txt_CrushDamageEmitterName.text = ""
				pickbut_CrushDamageEmitterTarget.object = undefined
			)
		)
		on but_SelectCrushDamageEmitter pressed do
		(
			if dpdn_CrushDamageEmitterLevel.selection > 1 then
			(
				undo "Select Crush Damage Emitter Point" on select CrushDamageEmitterPosition[dpdn_CrushDamageEmitterLevel.selection - 1].node
			)
		)
		on but_DeleteCrushDamageEmitter pressed do
		(
			/*for i = CrushDamageEmitterLevel.count to 1 by -1 do deleteItem CrushDamageEmitterLevel i
			for i = CrushDamageEmitterName.count to 1 by -1 do deleteItem CrushDamageEmitterName i
			for i = CrushDamageEmitterPosition.count to 1 by -1 do deleteItem CrushDamageEmitterPosition i
				
			return 0*/
			if dpdn_CrushDamageEmitterLevel.selection > 1 then
			(
				selectedIndex = dpdn_CrushDamageEmitterLevel.selection - 1
				deleteItem CrushDamageEmitterLevel selectedIndex
				deleteItem CrushDamageEmitterName selectedIndex
				deleteItem CrushDamageEmitterPosition selectedIndex
				crushDamageEmitterListItems =  dpdn_CrushDamageEmitterLevel.items
				deleteItem crushDamageEmitterListItems dpdn_CrushDamageEmitterLevel.selection
				dpdn_CrushDamageEmitterLevel.items = crushDamageEmitterListItems
				if selectedIndex + 1 > dpdn_CrushDamageEmitterLevel.items.count then
				(
					dpdn_CrushDamageEmitterLevel.selection = dpdn_CrushDamageEmitterLevel.items.count
					--dpdn_CrushDamageEmitterLevel.selected true
				)
				UpdateCrushDamageEmitter dpdn_CrushDamageEmitterLevel.selection
			)
		)
		on but_AddCrushDamageEmitter pressed do
		(
			dmgLevel = 0
			if chkbut_CurshDamageEmitterLevel1.checked then dmgLevel=-1
			else if chkbut_CurshDamageEmitterLevel2.checked then dmgLevel=-2
			else if chkbut_CurshDamageEmitterLevel3.checked then dmgLevel=-3
			else if chkbut_CurshDamageEmitterLevel4.checked then dmgLevel=-4
			else if chkbut_CurshDamageEmitterLevel5.checked then dmgLevel=-5
			if dmgLevel != 0 and txt_CrushDamageEmitterName.text != "" and pickbut_CrushDamageEmitterTarget.object != undefined then
			(
				crushDamageEmitterListItems =  dpdn_CrushDamageEmitterLevel.items 
				if dpdn_CrushDamageEmitterLevel.selection == 1 then
				(
					append CrushDamageEmitterLevel dmgLevel
					append CrushDamageEmitterName txt_CrushDamageEmitterName.text
					append CrushDamageEmitterPosition (nodeTransformMonitor node:pickbut_CrushDamageEmitterTarget.object forwardTransformChangeMsgs:false)
					i = CrushDamageEmitterLevel.count
					append crushDamageEmitterListItems ((CrushDamageEmitterLevel[i] as string)+": "+(CrushDamageEmitterName[i] as string)+" -> "+(CrushDamageEmitterPosition[i].node.name as string))
					--dpdn_CrushDamageMaterialLevel.selection = dpdn_CrushDamageMaterialLevel.items.count
				)
				else
				(
					i = dpdn_CrushDamageEmitterLevel.selection-1
					CrushDamageEmitterLevel[i] = dmgLevel
					CrushDamageEmitterName[i] = txt_CrushDamageEmitterName.text
					if CrushDamageEmitterPosition==undefined then format "CrushDamageEmitterPosition is undefined\n"
					if pickbut_CrushDamageEmitterTarget==undefined then format "pickbut_CrushDamageEmitterTarget is undefined\n"
					if pickbut_CrushDamageEmitterTarget.object ==undefined then format "pickbut_CrushDamageEmitterTarget.object is undefined\n"
					CrushDamageEmitterPosition[i] =  (nodeTransformMonitor node:pickbut_CrushDamageEmitterTarget.object forwardTransformChangeMsgs:false)
					crushDamageEmitterListItems[i+1] = ((CrushDamageEmitterLevel[i] as string)+": "+(CrushDamageEmitterName[i] as string)+" -> "+(CrushDamageEmitterPosition[i].node.name as string))
				)
				dpdn_CrushDamageEmitterLevel.items  = crushDamageEmitterListItems
				dpdn_CrushDamageEmitterLevel.selection = i+1
				--printArrayInFull CrushDamageEmitterLevel "CrushDamageEmitterLevel"
				--printArrayInFull CrushDamageEmitterName "CrushDamageEmitterName"
				--printArrayInFull CrushDamageEmitterPosition "CrushDamageEmitterPosition"
			)
			else
			(
				msg = ""
				if dmgLevel == 0 then msg += "Please select a damage level.\n"
				if txt_CrushDamageEmitterName.text == "" then msg += "Please enter an Emitter name.\n"
				if pickbut_CrushDamageEmitterTarget.object == undefined then msg += "Please select the object where the emitter will spawn.\n"
				messageBox msg title:"Error Adding Crush Damage Emitter"
			)
			
		)
		on dpdn_CrushDamageEmitterLevel selected selectedIndex do
		(
			UpdateCrushDamageEmitter selectedIndex
		)
		fn GetCrushDamageMaterials mat =
		(
			mats = undefined
			if classof mat == multimaterial then
			(
				mats = #()
				for submat in mat do
				(
					mats += GetCrushDamageMaterials submat
				)

			)
			else if classof mat == standardmaterial then
			(
				mats = #(mat)
			)
			mats
		)
		on CrushDamageParams open do
		(
			crushDamageMaterialItems = dpdn_CrushDamageMaterialLevel.items
			for i=1 to CrushDamageMaterialLevel.count do
			(
				append crushDamageMaterialItems ((CrushDamageMaterialLevel[i] as string)+": "+(CrushDamageMaterialOriginalMaterial[i] as string)+" -> "+(CrushDamageMaterialTargetMaterial[i] as string))
			)
			dpdn_CrushDamageMaterialLevel.items = crushDamageMaterialItems
			
			crushDamageEmitterItems =  dpdn_CrushDamageEmitterLevel.items
			
			for i=1 to CrushDamageEmitterLevel.count do
			(
				append crushDamageEmitterItems ((CrushDamageEmitterLevel[i] as string)+": "+(CrushDamageEmitterName[i] as string)+" -> "+(CrushDamageEmitterPosition[i].node.name as string))
			)
			dpdn_CrushDamageEmitterLevel.items = crushDamageEmitterItems
		)
	)
	
	
	parameters detachEmitter rollout:DetachEmitterParams
	(
		
		DetachPartEmitterName type:#stringTab tabSizeVariable:true
		DetachPartEmitterPosition type:#maxObjectTab tabSizeVariable:true
		DetachPartEmitterFactor type:#floatTab tabSizeVariable:true
		
		DetachParentEmitterName type:#stringTab tabSizeVariable:true
		DetachParentEmitterPosition type:#maxObjectTab tabSizeVariable:true
		DetachParentEmitterFactor type:#floatTab tabSizeVariable:true
		
	)
	rollout DetachEmitterParams "Detach Emitters"
	(
		dropdownlist dpdn_DetachPartEmitterName "Detach Part Emitters" labelontop:true items:#("New...")
		group "Detach Part Emitter Properties"
		(
			edittext txt_DetachPartEmitterName "Emitter Name"
			label lbl_DetachPartEmitterTarget "Spawn Point" across:2
			pickbutton pickbut_DetachPartEmitterTarget "Pick Point" filter:target_helper_filter autodisplay:true
			spinner spn_DetachPartEmitterFactor  "Snap-Force Factor" range:[0,1,1] fieldwidth:30 type:#float
			button but_AddDetachPartEmitter "Add" across:3
			button but_DeleteDetachPartEmitter "Delete" across:3
			button but_SelectDetachPartEmitter "Select" across:3
		)
		fn UpdateDetachPartEmitterTarget selectedIndex =
		(
			if selectedIndex > 1 then
			(
				txt_DetachPartEmitterName.text = DetachPartEmitterName[selectedIndex-1]
				pickbut_DetachPartEmitterTarget.object = DetachPartEmitterPosition[selectedIndex-1].node
				spn_DetachPartEmitterFactor.value = DetachPartEmitterFactor[selectedIndex-1]
			)
			else
			(
				txt_DetachPartEmitterName.text=""
				pickbut_DetachPartEmitterTarget.object = undefined
				spn_DetachPartEmitterFactor.value=1.0
			)
		)
		on but_SelectDetachPartEmitter pressed do
		(
			if dpdn_DetachPartEmitterName.selection > 1 then
			(
				undo "Select Detach Part Emitter Point" on select DetachPartEmitterPosition[dpdn_DetachPartEmitterName.selection-1].node
			)
		)
		on but_DeleteDetachPartEmitter pressed do
		(
			if dpdn_DetachPartEmitterName.selection > 1 then
			(
				selectedIndex = dpdn_DetachPartEmitterName.selection - 1
				deleteItem DetachPartEmitterName selectedIndex
				deleteItem DetachPartEmitterPosition selectedIndex
				deleteItem DetachPartEmitterFactor selectedIndex
				
				dpdnListItems = dpdn_DetachPartEmitterName.items
				deleteItem dpdnListItems (selectedIndex+1)
				dpdn_DetachPartEmitterName.items = dpdnListItems
				if selectedIndex +1 > dpdn_DetachPartEmitterName.items.count then
				(
					dpdn_DetachPartEmitterName.selection = dpdn_DetachPartEmitterName.items.count
				)
				UpdateDetachPartEmitterTarget dpdn_DetachPartEmitterName.items.count
			)
		)
		on but_AddDetachPartEmitter pressed do
		(
			if txt_DetachPartEmitterName != "" and pickbut_DetachPartEmitterTarget.object !=undefined then
			(
				if dpdn_DetachPartEmitterName.selection == 1 then
				(
					append DetachPartEmitterName txt_DetachPartEmitterName.text
					append DetachPartEmitterPosition (nodeTransformMonitor node:pickbut_DetachPartEmitterTarget.object forwardTransformChangeMsgs:false)
					append DetachPartEmitterFactor spn_DetachPartEmitterFactor.value
					i = DetachPartEmitterName.count
					dpdnListItems = dpdn_DetachPartEmitterName.items
					append dpdnListItems  (DetachPartEmitterName[i]+": "+DetachPartEmitterPosition[i].node.name+" ("+(DetachPartEmitterFactor[i] as string)+")")
					dpdn_DetachPartEmitterName.items = dpdnListItems
				)
				else
				(
					i = dpdn_DetachPartEmitterName.selection-1
					
					DetachPartEmitterName[i] = txt_DetachPartEmitterName.text
					DetachPartEmitterPosition[i] = (nodeTransformMonitor node:pickbut_DetachPartEmitterTarget.object forwardTransformChangeMsgs:false)
					DetachPartEmitterFactor[i] = spn_DetachPartEmitterFactor.value
					
					dpdnListItems = dpdn_DetachPartEmitterName.items
					dpdnListItems[i+1] = (DetachPartEmitterName[i]+": "+DetachPartEmitterPosition[i].name+" ("+(DetachPartEmitterFactor[i] as string)+")")
					dpdn_DetachPartEmitterName.items = dpdnListItems
				)
				
				dpdn_DetachPartEmitterName.selection = i+1
				UpdateDetachPartEmitterTarget (i+1)
			)
			else
			(
				msg = ""
				if txt_DetachPartEmitterName.text == "" then msg += "Please enter an Emitter name.\n"
				if pickbut_DetachPartEmitterTarget.object == undefined then msg += "Please select the object where the emitter will spawn.\n"
				messageBox msg title:"Error Adding Detach Part Emitter"
			)
		)
		on dpdn_DetachPartEmitterName selected selectedIndex do
		(
			UpdateDetachPartEmitterTarget selectedIndex
		)
		
		dropdownlist dpdn_DetachParentEmitterName "Detach Parent Emitters" labelontop:true items:#("New...")
		group "Detach Parent Emitter Properties"
		(
			edittext txt_DetachParentEmitterName "Emitter Name"
			label lbl_DetachParentEmitterTarget "Spawn Point" across:2
			pickbutton pickbut_DetachParentEmitterTarget "Pick Point" filter:target_helper_filter autodisplay:true
			spinner spn_DetachParentEmitterFactor  "Snap-Force Factor" range:[0,1,1] fieldwidth:30 type:#float
			button but_AddDetachParentEmitter "Add" across:3
			button but_DeleteDetachParentEmitter "Delete" across:3
			button but_SelectDetachParentEmitter "Select" across:3
		)
		
		fn UpdateDetachParentEmitterTarget selectedIndex =
		(
			if selectedIndex > 1 then
			(
				txt_DetachParentEmitterName.text = DetachParentEmitterName[selectedIndex-1]
				pickbut_DetachParentEmitterTarget.object = DetachParentEmitterPosition[selectedIndex-1].node
				spn_DetachParentEmitterFactor.value = DetachParentEmitterFactor[selectedIndex-1]
			)
			else
			(
				txt_DetachParentEmitterName.text=""
				pickbut_DetachParentEmitterTarget.object = undefined
				spn_DetachParentEmitterFactor.value=1.0
			)
		)
		on but_SelectDetachParentEmitter pressed do
		(
			if dpdn_DetachParentEmitterName.selection > 1 then
			(
				undo "Select Detach Parent Emitter Point" on select DetachParentEmitterPosition[dpdn_DetachParentEmitterName.selection-1].node
			)
		)
		on but_DeleteDetachParentEmitter pressed do
		(
			if dpdn_DetachParentEmitterName.selection > 1 then
			(
				selectedIndex = dpdn_DetachParentEmitterName.selection - 1
				deleteItem DetachParentEmitterName selectedIndex
				deleteItem DetachParentEmitterPosition selectedIndex
				deleteItem DetachParentEmitterFactor selectedIndex
				
				dpdnListItems = dpdn_DetachParentEmitterName.items
				deleteItem dpdnListItems (selectedIndex+1)
				dpdn_DetachParentEmitterName.items = dpdnListItems
				if selectedIndex +1 > dpdn_DetachParentEmitterName.items.count then
				(
					dpdn_DetachParentEmitterName.selection = dpdn_DetachParentEmitterName.items.count
				)
				UpdateDetachParentEmitterTarget dpdn_DetachParentEmitterName.items.count
			)
		)
		on but_AddDetachParentEmitter pressed do
		(
			if txt_DetachParentEmitterName != "" and pickbut_DetachParentEmitterTarget.object !=undefined then
			(
				if dpdn_DetachParentEmitterName.selection == 1 then
				(
					append DetachParentEmitterName txt_DetachParentEmitterName.text
					append DetachParentEmitterPosition (nodeTransformMonitor node:pickbut_DetachParentEmitterTarget.object forwardTransformChangeMsgs:false)
					append DetachParentEmitterFactor spn_DetachParentEmitterFactor.value
					i = DetachParentEmitterName.count
					dpdnListItems = dpdn_DetachParentEmitterName.items
					append dpdnListItems  (DetachParentEmitterName[i]+": "+DetachParentEmitterPosition[i].node.name+" ("+(DetachParentEmitterFactor[i] as string)+")")
					dpdn_DetachParentEmitterName.items = dpdnListItems
				)
				else
				(
					i = dpdn_DetachParentEmitterName.selection-1
					
					DetachParentEmitterName[i] = txt_DetachParentEmitterName.text
					DetachParentEmitterPosition[i] = (nodeTransformMonitor node:pickbut_DetachParentEmitterTarget.object forwardTransformChangeMsgs:false)
					DetachParentEmitterFactor[i] = spn_DetachParentEmitterFactor.value
					
					dpdnListItems = dpdn_DetachParentEmitterName.items
					dpdnListItems[i+1] = (DetachParentEmitterName[i]+": "+DetachParentEmitterPosition[i].node.name+" ("+(DetachParentEmitterFactor[i] as string)+")")
					dpdn_DetachParentEmitterName.items = dpdnListItems
				)
				
				dpdn_DetachParentEmitterName.selection = i+1
				UpdateDetachParentEmitterTarget (i+1)
			)
			else
			(
				msg = ""
				if txt_DetachParentEmitterName.text == "" then msg += "Please enter an Emitter name.\n"
				if pickbut_DetachParentEmitterTarget.object == undefined then msg += "Please select the object where the Emitter will spawn.\n"
				messageBox msg title:"Error Adding Detach Parent Emitter"
			)
		)
		on dpdn_DetachParentEmitterName selected selectedIndex do
		(
			UpdateDetachParentEmitterTarget selectedIndex
		)
		on DetachEmitterParams open do
		(
			detachPartEmitterList = dpdn_DetachPartEmitterName.items
			for i=1 to DetachPartEmitterName.count do
			(
				append detachPartEmitterList (DetachPartEmitterName[i]+": "+DetachPartEmitterPosition[i].node.name+" ("+(DetachPartEmitterFactor[i] as string)+")")
			)
			dpdn_DetachPartEmitterName.items = detachPartEmitterList
			
			detachParentEmitterList = dpdn_DetachParentEmitterName.items
			for i=1 to DetachParentEmitterName.count do
			(
				append detachParentEmitterList (DetachParentEmitterName[i]+": "+DetachParentEmitterPosition[i].node.name+" ("+(DetachParentEmitterFactor[i] as string)+")")
			)
			dpdn_DetachParentEmitterName.items = detachParentEmitterList
		)
	)
	
	parameters weaponsInfo rollout:WeaponsInfoParams
	(
		VehicleSimpleWeapon_Set type:#boolean default:false ui:chk_VehicleSimpleWeapon_Set
		VehicleSimpleWeapon type:#float default:0.0 ui:spn_VehicleSimpleWeapon
		
		WeaponType type:#stringTab tabSizeVariable:true
		WeaponName type:#stringTab tabSizeVariable:true
		WeaponDmgType type:#stringTab tabSizeVariable:true
		WeaponVector type:#point3Tab tabSizeVariable:true
		
	)
	
	rollout WeaponsInfoParams "Weapons"
	(
		
		checkbox chk_VehicleSimpleWeapon_Set "" across:2
		spinner spn_VehicleSimpleWeapon "Simple Weapon" range:[0,100000,1] type:#float fieldwidth: 40
		
		
		
		on chk_VehicleSimpleWeapon_Set changed state do
		(
			spn_VehicleSimpleWeapon.enabled = state
		)
		
		dropdownlist dpdn_Weapons "Vehicle Weapons" labelontop:true items:#("New...")
		group "Weapon Properties"
		(
			checkbutton chkbut_VehicleWeapon "Vehicle" across:3
			checkbutton chkbut_PedWeapon "Ped" across:3
			checkbutton chkbut_AccessoryWeapon "Accessory" across:3
			
			edittext txt_WeaponName "Weapon Name" labelOnTop:true
			label lbl_SomeValues "Values"
			spinner spn_WeaponValues1  "" range:[0,1000,1] fieldwidth:30 type:#float across:3
			spinner spn_WeaponValues2  "" range:[0,1000,1] fieldwidth:30 type:#float across:3
			spinner spn_WeaponValues3  "" range:[0,1000,1] fieldwidth:30 type:#float across:3
			button but_AddWeapon "Set" across:2
			button but_DeleteWeapon "Delete" across:2
		)
		
		on chkbut_VehicleWeapon changed state do
		(
			if state == true then
			(
				chkbut_PedWeapon.checked=false
				chkbut_AccessoryWeapon.checked=false
			)
		)
		on chkbut_PedWeapon changed state do
		(
			if state == true then
			(
				chkbut_VehicleWeapon.checked=false
				chkbut_AccessoryWeapon.checked=false
			)
		)
		on chkbut_AccessoryWeapon changed state do
		(
			if state == true then
			(
				chkbut_PedWeapon.checked=false
				chkbut_VehicleWeapon.checked=false
			)
		)
		
		fn UpdateWeapons selectedIndex =
		(
			if selectedIndex > 1 then
			(
				txt_WeaponName.text = WeaponName[selectedIndex-1]
				chkbut_VehicleWeapon.checked = false
				chkbut_PedWeapon.checked = false
				chkbut_AccessoryWeapon.checked = false
				if WeaponType[selectedIndex-1] == "Vehicle" then chkbut_VehicleWeapon.checked =true
				else if WeaponType[selectedIndex-1] == "Ped" then chkbut_PedWeapon.checked =true
				else if WeaponType[selectedIndex-1] == "Accessory" then chkbut_AccessoryWeapon.checked =true
				spn_WeaponValues1.value = WeaponVector[selectedIndex-1].x
				spn_WeaponValues2.value = WeaponVector[selectedIndex-1].y
				spn_WeaponValues3.value = WeaponVector[selectedIndex-1].z
			)
			else
			(
				txt_WeaponName.text=""
				chkbut_VehicleWeapon.checked = false
				chkbut_PedWeapon.checked = false
				chkbut_AccessoryWeapon.checked = false
				spn_WeaponValues1.value = 0.0
				spn_WeaponValues2.value = 0.0
				spn_WeaponValues3.value = 0.0
				
			)
		)
		
		on but_DeleteWeapon pressed do
		(
			if dpdn_Weapons.selection > 1 then
			(
				selectedIndex = dpdn_Weapons.selection - 1
				deleteItem WeaponType selectedIndex
				deleteItem WeaponName selectedIndex
				deleteItem WeaponDmgType selectedIndex
				deleteItem WeaponVector selectedIndex
				
				dpdnListItems = dpdn_Weapons.items
				deleteItem dpdnListItems (selectedIndex+1)
				dpdn_Weapons.items = dpdnListItems
				if selectedIndex +1 > dpdn_Weapons.items.count then
				(
					dpdn_Weapons.selection = dpdn_Weapons.items.count
				)
				UpdateWeapons dpdn_Weapons.items.count
			)
		)
		on but_AddWeapon pressed do
		(
			typeOfWeapon = undefined
			if chkbut_VehicleWeapon.checked==true then typeOfWeapon="Vehicle"
			else if chkbut_PedWeapon.checked==true then typeOfWeapon="Ped"
			else if chkbut_AccessoryWeapon.checked==true then typeOfWeapon="Accessory"
				
			if typeOfWeapon != undefined and (filterstring txt_WeaponName.text ", \"'[]@=+-_").count > 0 then
			(
				selectedIndex = 0
				weaponIndex= 0
				if dpdn_Weapons.selection > 1 then
				(
					selectedIndex = dpdn_Weapons.selection
					weaponIndex = selectedIndex - 1
					WeaponType[weaponIndex] = typeOfWeapon
					WeaponName[weaponIndex] = txt_WeaponName.text
					WeaponDmgType[weaponIndex] = "CONSTANT"
					WeaponVector[weaponIndex] = [spn_WeaponValues1.value,spn_WeaponValues2.value,spn_WeaponValues3.value]
				)
				else
				(
					append WeaponType typeOfWeapon
					append WeaponName txt_WeaponName.text
					append WeaponDmgType "CONSTANT"
					append WeaponVector [spn_WeaponValues1.value,spn_WeaponValues2.value,spn_WeaponValues3.value]
					weaponIndex = WeaponType.count
					selectedIndex = weaponIndex+1
				)
				
				weaponsList = dpdn_Weapons.items
				weaponsList[selectedIndex] = WeaponType[weaponIndex]+": "+WeaponName[weaponIndex]
				dpdn_Weapons.items = weaponsList
				dpdn_Weapons.selection = selectedIndex
			)

		)
		on dpdn_Weapons selected selectedIndex do
		(
			UpdateWeapons selectedIndex
		)
		on WeaponsInfoParams open do
		(
			spn_VehicleSimpleWeapon.pos = [ spn_VehicleSimpleWeapon.pos.x+10, spn_VehicleSimpleWeapon.pos.y]
			spn_VehicleSimpleWeapon.enabled =VehicleSimpleWeapon_Set
			
			weaponsList = dpdn_Weapons.items
			for i=1 to WeaponName.count do
			(
				append weaponsList (WeaponType[i]+": "+WeaponName[i])
			)
			dpdn_Weapons.items = weaponsList
		)
		on WeaponsInfoParams close do
		(
		)
	)
	
	
	parameters soundInfo rollout:SoundInfoParams
	(
		SoundConfigFile type:#string default:"" ui:txt_SoundConfigFile
		
		CrushDamageSoundSubCat type:#string default:"" ui:txt_CrushDamageSoundSubCat
	)
	rollout SoundInfoParams "Sound Configuration"
	(
			edittext txt_SoundConfigFile "Sound Config File" labelOnTop:true
			edittext txt_CrushDamageSoundSubCat "Crush Damage Sound Sub Cat" labelOnTop:true
	)
)

WheelTypes = #("Wheel_FR","Wheel_FL","Wheel_RR","Wheel_RL")
WheelTypesDisplay = #("Front Right", "Front Left", "Rear Right", "Rear Left")
CarWheelAttribute = attributes CarWheelAttrib
(
	parameters main rollout:CarWheelAttribRollout
	(
		WheelTypeID type:#integer default:1
		WheelType type:#string default:"Wheel_FR"
	)
	rollout CarWheelAttribRollout "Car Wheel Params"
	(
		dropdownlist uiWheelType "Wheel Type" items:WheelTypesDisplay selection:WheelTypeID
		
		on uiWheelType selected i do
		(
			WheelTypeID = uiWheelType.selection
			WheelType = uiWheelType.items[i]
		)
	)
)


CarSystemDamageUnitAttribute = attributes CarSysDamageUnit attribID:#(0x1a22add2, 0x6414275c) version:1
(
	parameters main rollout:SysDamageAttribRollout
	(
		UnitName type:#string default:"bodywork" ui:txt_UnitName
		WastedLinearContributionStartDamage type:#float default:1.0 ui:spn_WastedLinearContributionStartDamage
		WastedLinearContributionPartialDamage type:#float default:0.4 ui:spn_WastedLinearContributionPartialDamage
		WastedLinearContributionFullDamage type:#float default:0.8 ui:spn_WastedLinearContributionFullDamage
		WastedLinearContributionActive type:#boolean default:false ui:chk_WastedLinearContributionActive
		WastedContribution type:#float default:1.0
		WastedContributionActive type:#boolean default:false
		DamageEffect_Drive type:#float default:1.0 ui:spn_DamageEffect_Drive
		DamageEffect_DriveActive type:#boolean default:false ui:chk_DamageEffect_DriveActive
		DamageEffect_Steering type:#float default:1.0 ui:spn_DamageEffect_Steering
		DamageEffect_SteeringActive type:#boolean default:false ui:chk_DamageEffect_SteeringActive
		DamageEffect_Brakes type:#float default:1.0 ui:spn_DamageEffect_Brakes
		DamageEffect_BrakesActive type:#boolean default:false ui:chk_DamageEffect_BrakesActive
		Vulnerability type:#stringTab tabsizevariable:true
		VulnerabilityValue type:#floatTab tabsizevariable:true
		PartObjectName type:#stringTab tabsizevariable:true
		PartObjectType type:#stringTab tabsizevariable:true
		PartValue1 type:#floatTab tabsizevariable:true
		PartValue2 type:#floatTab tabsizevariable:true
		IsTrailer type:#boolean default:false ui:chk_IsTrailer
	)
	rollout SysDamageAttribRollout "System Damage Rollout"
	(
		edittext txt_UnitName "Unit Name"
		group "Wasted Contribution" (
			checkbox chk_WastedContributionActive "Wasted Contribution" 
			spinner spn_WastedContribution ""
			checkbox chk_WastedLinearContributionActive "Wasted Linear Contribution"
			label lbl_WastedLinearContributionStartDamage "Start Damage Point"
			spinner spn_WastedLinearContributionStartDamage ""
			label lbl_WastedLinearContributionPartialDamage "Partial Damage Amount"
			spinner spn_WastedLinearContributionPartialDamage ""
			label lbl_WastedLinearContributionFullDamage "Full Damage Amount"
			spinner spn_WastedLinearContributionFullDamage ""

		) 
		group "Damage Effect" (
			checkbox chk_DamageEffect_DriveActive "Drive" 
			spinner spn_DamageEffect_Drive ""
			checkbox chk_DamageEffect_SteeringActive "Steering" 
			spinner spn_DamageEffect_Steering ""
			checkbox chk_DamageEffect_BrakesActive "Brakes" 
			spinner spn_DamageEffect_Brakes ""

		) 
		group "Unit Parts" (
			checkbox chk_IsTrailer "Is a trailer?"
			button btn_AddObj "Add"
			dotNetControl lv_Objects "listview" height:100
			button btn_RemoveObj "Delete Selected"
			dropdownlist dpdn_PartType "Part Type" items:#("Crushable", "Solid", "Wheel", "Indexed Wheel", "Tank Track")
			edittext txt_PartName "Part Name"
			spinner spn_Value1 "Contribution"
 			spinner spn_Value2 "Displacement (m)" tooltip:"For crush parts: Average displacement of verts in meters\nFor solid parts: total disp of parts"

		)
		group "Vulnerability" (
			button btn_AddVulnerability "Add"
			dotNetControl lv_Vulnerabilities "listview" height:100
			button btn_RemoveVulnerability "Delete Selected"
			dropdownlist dpdn_VulnerabilityType "Vulnerability Type" items:#("overall","top","underside","rear","front","left_front","right_rear","right_side","right_front","random","left_rear","left_side")
			spinner spn_VulnerabilityValue "Value"
		)

		on SysDamageAttribRollout open do (

			if WastedContributionActive then (
				spn_WastedContribution.enabled = true
			)
			else (
				spn_WastedContribution.enabled = false
			)

			if WastedLinearContributionActive then (
				spn_WastedLinearContributionPartialDamage.enabled = true
				spn_WastedLinearContributionStartDamage.enabled = true
				spn_WastedLinearContributionFullDamage.enabled = true
			)
			else (
				spn_WastedLinearContributionPartialDamage.enabled = false
				spn_WastedLinearContributionStartDamage.enabled = false
				spn_WastedLinearContributionFullDamage.enabled = false
			)
			
			lv_Objects.view = (dotnetclass "view").details
			lv_Objects.multiselect = false
			lv_Objects.fullrowselect = true
			lv_Objects.columns.add "Type" width:50
			lv_Objects.columns.add "Name" width:50
			dpdn_PartType.enabled = false
			txt_PartName.enabled = false
			spn_Value1.enabled = false
			spn_Value2.enabled = false

			for i=1 to PartObjectName.count do (
				lvitem = dotNetObject "listviewitem" PartObjectType[i]
				lvitem.subitems.add (PartObjectName[i])
				lv_Objects.items.add lvItem
			)
			lv_Vulnerabilities.view = (dotnetclass "view").details
			lv_Vulnerabilities.multiselect = false
			lv_Vulnerabilities.fullrowselect = true
			lv_Vulnerabilities.columns.add "Type" width:50
			lv_Vulnerabilities.columns.add "Value" width:50
			dpdn_VulnerabilityType.enabled = false
			spn_VulnerabilityValue.enabled = false

			for i=1 to Vulnerability.count do (
				lvitem2 = dotNetObject "listviewitem" Vulnerability[i]
				vulnValue = VulnerabilityValue[i] as string
				lvitem2.subitems.add vulnValue
				lv_Vulnerabilities.items.add lvItem2
			)
		)
		on chk_WastedContributionActive changed state do (
			if state then (
				spn_WastedContribution.enabled = true
			)
			else (
				spn_WastedContribution.enabled = false
			)
		)
		on chk_DamageEffect_DriveActive changed state do (
			if state then (
				spn_DamageEffect_Drive.enabled = true
			)
			else (
				spn_DamageEffect_Drive.enabled = false
			)
		)
		on chk_DamageEffect_SteeringActive changed state do (
			if state then (
				spn_DamageEffect_Steering.enabled = true
			)
			else (
				spn_DamageEffect_Steering.enabled = false
			)
		)
		on chk_DamageEffect_BrakesActive changed state do (
			if state then (
				spn_DamageEffect_Brakes.enabled = true
			)
			else (
				spn_DamageEffect_Brakes.enabled = false
			)
		)
		on chk_WastedLinearContributionActive changed state do (
			if state then (
				spn_WastedLinearContributionPartialDamage.enabled = true
				spn_WastedLinearContributionStartDamage.enabled = true
				spn_WastedLinearContributionFullDamage.enabled = true
			)
			else (
				spn_WastedLinearContributionPartialDamage.enabled = false
				spn_WastedLinearContributionStartDamage.enabled = false
				spn_WastedLinearContributionFullDamage.enabled = false
			)
		)
		on txt_UnitName changed value do (
			format "%\n" (refs.dependents this)[1].name
			(refs.dependents this)[1].name = value + " damage unit"
		)
		on lv_Objects selectedindexchanged ev do (
			if lv_Objects.selectedindices.count > 0 then (
				ind = lv_Objects.selectedindices.item[0]
				objName = PartObjectName[ind + 1]
				objType = PartObjectType[ind + 1]
				objValue1 = PartValue1[ind + 1]
				objValue2 = PartValue2[ind + 1]

				dpdn_PartType.enabled = true
				dpdn_PartType.selection = finditem dpdn_PartType.items objType

				txt_PartName.enabled = true
				txt_PartName.text = objName

				spn_Value1.enabled = true
				spn_Value1.value = objValue1
				spn_Value2.enabled = false
				spn_Value2.value = objValue2
				if(objType == "Solid" or objType == "Crushable") then (
					spn_Value2.enabled = true

				)
			)
			else (
				dpdn_PartType.enabled = false
				txt_PartName.enabled = false
				spn_Value1.enabled = false
				spn_Value2.enabled = false
			)
		)
		on lv_Vulnerabilities selectedindexchanged ev do (

			if lv_Vulnerabilities.selectedindices.count > 0 then (
				ind = lv_Vulnerabilities.selectedindices.item[0]
				vulnType = Vulnerability[ind + 1]
				vulnValue = VulnerabilityValue[ind + 1]
				
				dpdn_VulnerabilityType.enabled = true
				dpdn_VulnerabilityType.selection = finditem dpdn_VulnerabilityType.items vulnType

				spn_VulnerabilityValue.enabled = true
				spn_VulnerabilityValue.value = vulnValue
			)
			else (
				dpdn_VulnerabilityType.enabled = false
				spn_VulnerabilityValue.enabled = false
			)
		)

		on btn_AddObj pressed do (
			append PartObjectName "obj"
			append PartObjectType "Solid"
			append PartValue1 1.0
			append PartValue2 0.5

			lvitem = dotNetObject "listviewitem" PartObjectType[PartObjectType.count]
			lvitem.subitems.add (PartObjectName[PartObjectType.count])
			lv_Objects.items.add lvItem

			lv_Objects.SelectedItems.clear()
			lvItem.selected = true
		)
		on btn_AddVulnerability pressed do (
			append Vulnerability "front"
			append VulnerabilityValue 1.0

			lvitem = dotNetObject "listviewitem" Vulnerability[Vulnerability.count]
			lvitem.subitems.add (VulnerabilityValue[Vulnerability.count])
			lv_Vulnerabilities.items.add lvItem

			lv_Vulnerabilities.SelectedItems.clear()
			lvItem.selected = true
		)
		on btn_RemoveObj pressed do (
			if lv_Objects.selectedindices.count > 0 then (
				ind = lv_Objects.selectedindices.item[0] + 1
				deleteitem PartObjectType ind
				deleteitem PartObjectName ind
				deleteitem PartValue1 ind
				deleteitem PartValue2 ind
				lv_Objects.items.removeat(lv_Objects.selectedindices.item[0])
			)
		)
		on btn_RemoveVulnerability pressed do (
			if lv_Vulnerabilities.selectedindices.count > 0 then (
				ind = lv_Vulnerabilities.selectedindices.item[0] + 1
				deleteitem Vulnerability ind
				deleteitem VulnerabilityValue ind
				lv_Vulnerabilities.items.removeat(lv_Vulnerabilities.selectedindices.item[0])
			)
		)
		on dpdn_VulnerabilityType selected ind do (
			if lv_Vulnerabilities.selectedindices.count > 0 then (
				objind = lv_Vulnerabilities.selectedindices.item[0] + 1
				Vulnerability[objind] = dpdn_VulnerabilityType.items[ind]
				lv_Vulnerabilities.selecteditems.item[0].subitems.item[0].text = dpdn_VulnerabilityType.items[ind]
			)
		)
		on dpdn_PartType selected ind do (
			if lv_Objects.selectedindices.count > 0 then (
				objind = lv_Objects.selectedindices.item[0] + 1
				PartObjectType[objind] = dpdn_PartType.items[ind]
				objType = dpdn_PartType.items[ind]
				format "Selected part type %\n" objType
				format "%\n" dpdn_PartType.items
				if(objType == "Solid" or objType == "Crushable") then (
					spn_Value2.enabled = true

				)
				else (
					spn_Value2.enabled = false
				)
				lv_Objects.selecteditems.item[0].subitems.item[0].text = dpdn_PartType.items[ind]
			)
		)
		on spn_VulnerabilityValue changed value do (
			if lv_Vulnerabilities.selectedindices.count > 0 then (
				objind = lv_Vulnerabilities.selectedindices.item[0] + 1
				VulnerabilityValue[objind] = value
				lv_Vulnerabilities.selecteditems.item[0].subitems.item[1].text = value as string
			)
		)
		on txt_PartName changed value do (
			if lv_Objects.selectedindices.count > 0 then (
				objind = lv_Objects.selectedindices.item[0] + 1
				PartObjectName[objind] = value
				lv_Objects.selecteditems.item[0].subitems.item[1].text = value
			)
		)
		on spn_Value1 changed value do (
			if lv_Objects.selectedindices.count > 0 then (
				objind = lv_Objects.selectedindices.item[0] + 1
				PartValue1[objind] = value
			)
		)
		on spn_Value2 changed value do (
			if lv_Objects.selectedindices.count > 0 then (
				objind = lv_Objects.selectedindices.item[0] + 1
				PartValue2[objind] = value
			)
		)
	)
)

VFXAnchorAttribute = attributes VFXAnchorCustAttribute attribid:#(0xca2f36c, 0x5847641) version:1
(
	parameters main rollout:VFXAnchorsParams
	(
		HelperObject type:#maxObject ui:pck_HelperObject
		GroupName type:#string ui:txt_groupName
		AnchorID type:#string ui:txt_anchorid

	)
	rollout VFXAnchorsParams "VFX Anchor"
	(
		edittext txt_groupName "VFX Group"
		edittext txt_anchorid "Anchor ID"
		pickbutton pck_HelperObject "Pick Object" filter:target_helper_filter autodisplay:true labelOnTop:true
	button btn_SelectHelper "Select Helper Object"
		on pck_HelperObject picked obj do
		(
			HelperObject = nodeTransformMonitor node:obj forwardTransformChangeMsgs:false
		)
		on btn_SelectHelper pressed do (
			if HelperObject != undefined && HelperObject.node != undefined then (
				select HelperObject.node
			)
		)
	)
)

PedSkeletonAttribute = attributes PedSkelCustAttribute attribID:#(0x52b53405, 0x5a597737) version:1
(
	parameters main rollout:PedSkelAttributeParams
	(
		
		BoneList type:#maxObjectTab tabSizeVariable:true
		
	)
	rollout PedSkelAttributeParams "Ped Bones List"
	(
	
		pickbutton pck_Bone_Node "Pick Object" autodisplay:true across:2
		button but_AddBone "Add" across:2
		button but_AddBoneFromSkin "Add From Skin" across:1
		dotnetcontrol lv_BonesList "listview" height: 300
		--colorpicker colpick_DriverBox "Add Driver Box Vertex Colour"
		
		button but_RemoveBone "Remove" across:3
		button but_MoveUp "Up" across:3
		button but_MoveDown "Down" across:3
		
		on PedSkelAttributeParams open do
		(
			
			lv_BonesList.view  = (dotnetclass "view").details
			lv_BonesList.fullrowselect= true
			
			lv_BonesList.gridlines = true
			lv_BonesList.multiselect =false
			lv_BonesList.columns.add "Bone Name" 130
			for i=1 to BoneList.count do
			(
				lv_BonesList.Items.add BoneList[i].node.name
			)
		
			
			for i=1 to BoneList.count do
			(
				if BoneList[i] == undefined or BoneList[i].node == undefined then
				(
					deleteitem BoneList i
					i = i - 1;
				)
				else
				(
					lvItem = dotnetobject "listviewitem" BoneList[i].node.name
					lv_BonesList.Items.add lvitem
				)
			)
		)
		fn AddBonesFromSkin = 
		(
			if $.modifiers["Skin"] != undefined then
			(
				skinbonesList = GetBonesFromSkin $.modifiers["Skin"]
				for bone in skinbonesList do
				(
					boneIsInList = for b in BoneList where b.node == bone collect b
					--messageBox boneIsInList.count
					if boneIsInList.count == 0 then
					(
						append BoneList (nodeTransformMonitor node:bone forwardTransformChangeMsgs:false)
						lv_BonesList.Items.add bone.name
					)
				)
			)
		)
		on but_AddBoneFromSkin pressed do
		(
			AddBonesFromSkin()
		)
		on but_MoveUp pressed do
		(
			if lv_BonesList.SelectedIndices.count > 0 and lv_BonesList.SelectedIndices.Item[0] > 0 then
			(
				oldIndex = lv_BonesList.SelectedIndices.Item[0] + 1
				targetIndex = oldIndex - 1
				bone = BoneList[oldIndex]
				otherBone = BoneList[targetIndex]
				BoneList[oldIndex] = otherBone
				BoneList[targetIndex] = bone
				lv_BonesList.Items.removeAt (oldIndex - 1)
				lvItem = dotnetobject "listviewitem" bone.node.name
				lv_BonesList.Items.insert (targetIndex-1) lvItem
				lvItem.Selected = true
			)
		)
		on but_MoveDown pressed do
		(
			if lv_BonesList.SelectedIndices.count > 0 and lv_BonesList.SelectedIndices.Item[0] < lv_BonesList.Items.count then
			(
				oldIndex = lv_BonesList.SelectedIndices.Item[0] + 1
				targetIndex = oldIndex + 1
				bone = BoneList[oldIndex]
				otherBone = BoneList[targetIndex]
				BoneList[oldIndex] = otherBone
				BoneList[targetIndex] = bone
				lv_BonesList.Items.removeAt (oldIndex - 1)
				lvItem = dotnetobject "listviewitem" bone.node.name
				lv_BonesList.Items.insert (targetIndex-1) lvItem
				lvItem.Selected = true
			)
		)
		on but_AddBone pressed do
		(
			if pck_Bone_Node.object != undefined then
			(
				append BoneList (nodeTransformMonitor node:pck_Bone_Node.object forwardTransformChangeMsgs:false)
				lvItem = dotnetobject "listviewitem" pck_Bone_Node.object.name
				lv_BonesList.Items.add lvitem
			)
		)
		on but_DeleteLumpRenderLevel pressed do
		(
			if lv_BonesList.SelectedIndices.count > 0 then
			(
				if BoneList.count > 0 then deleteItem BoneList (lv_BonesList.SelectedIndices.Item[0] + 1)
				lv_BonesList.Items.removeat lv_BonesList.SelectedIndices.Item[0]
			)
		)
	)
)

fn GetBonesList mdl =
(
	pedBonesList = undefined
	if mdl.modifiers["Ped Bones List"] != undefined then
	(
		pedBonesList = for b in mdl.modifiers["Ped Bones List"].BoneList where b != undefined and b.node != undefined collect b.node
		
	)
	else if mdl.modifiers["Skin"] != undefined then
	(
		pedBonesList (GetBonesFromSkin skinMod)
	)
	pedBonesList
)
fn AddPedBonesListMod mdl =
(
	if (IsObjectAPedBonesList mdl) != undefined then
	(
		messagebox mdl.name
		max modify mode
		boneHierarchyModifier = emptyModifier()
		boneHierarchyModifier.name = "Ped Bones List"
		addModifier mdl boneHierarchyModifier
		custattributes.add boneHierarchyModifier PedSkeletonAttribute baseObject:false
		--boneHierarchyModifier.PedSkelCustAttribute.AddBonesFromSkin()
		SetCNTNodeType mdl "SKIN"
	)
)
