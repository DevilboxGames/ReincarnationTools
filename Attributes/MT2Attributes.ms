Mt2BaseMaterials = #(
    "simple_base",
    "simple_norm_base",
    "simple_norm_detail_spec_base",
    "simple_norm_spec_1bit_env_base",
    "simple_norm_spec_env_base",
    "simple_norm_spec_env_base_A",
    "simple_norm_spec_env_blend_base",
    "simple_spec_base",
    "car_shader_base",
    "car_shader_double_sided_base",
    "car_shader_glass",
    "car_translucent_body_base",
    "glass_base",
"blood_single_splat",
"blood_smear",
"blood_splat",
"blood_splat_anim",
"Expanding_pool",
"fog",
"glow_simple_norm_spec_env_base",
"glow_simple_norm_spec_env_base_A",
"ped_base",
"ped_decal_base",
"ped_simple_decal_base",
"repulse_base",
"shape_diagnostic",
"simple_1bit_base",
"simple_additive_base",
"simple_anim_foliage",
"skybox_base",
"unlit_1bit_base",
"unlit_base",
"vertex_norm_spec_env_base",
"water_base"
)

Mt2MinMaxMipFilter = #(
    
    "Anisotropic",
    "Linear",
    "Point",
    "None"
)

Mt2Mat_CA = attributes mt2mat_data
attribID:#(0x1ece08a6, 0x11172cef)
(
    parameters mt2data rollout:mt2propsrollout
    (
        mt2_texturecoordinatesource type:#stringtab  tabSizeVariable:true
        mt2_samplers type:#stringtab  tabSizeVariable:true
        mt2_texturealiases type:#stringtab  tabSizeVariable:true
        mt2_textures type:#texturemaptab  tabSizeVariable:true
        mt2_basematerialname type:#string default:"simple_base" ui:dpdn_basematerialname
        mt2_substance type:#string default:"DEFAULT" ui:txt_substance
        mt2_substance2 type:#string default:"DEFAULT" ui:txt_substance2

        -- Toggles
        mt2_doublesided type:#boolean default:true ui:chk_doublesided
        mt2_castshadows type:#boolean default:true ui:chk_castshadows
        mt2_receivesshadows type:#boolean default:true ui:chk_receivesshadows
        mt2_fogenabled type:#boolean default:true ui:chk_fogenabled
        mt2_translucent type: #boolean default:true ui:chk_translucent
        mt2_walkable type:#boolean default:true ui:chk_walkable
        mt2_panickable type:#boolean default:true ui:chk_panickable
        mt2_sittable type:#boolean default:true ui:chk_sittable

        -- Constants
        mt2_usemultiplier type:#boolean default:false ui:chk_multiplier
        mt2_multiplierisfloat3 type:#boolean default:false ui:chk_multiplierisfloat3
        mt2_multiplierR type:#float default:1.0 ui:spn_multiplierR
        mt2_multiplierG type:#float default:1.0 ui:spn_multiplierG
        mt2_multiplierB type:#float default:1.0 ui:spn_multiplierB
        mt2_usealphacutoff type:#boolean default:false ui:chk_alphacutoff
        mt2_alphacutoff type:#float default:0.5 ui:spn_alphacutoff
        mt2_useEmissiveFactor type:#boolean default:false ui:chk_emissivefactor
        mt2_emissivefactor type:#float default:0.0 ui:spn_emissivefactor
        mt2_useEmissiveLight type:#boolean default:false ui:chk_emissivelight
        mt2_emissivelightR type:#float default:1.0 ui:spn_emissivelightR
        mt2_emissivelightG type:#float default:1.0 ui:spn_emissivelightG
        mt2_emissivelightB type:#float default:1.0 ui:spn_emissivelightB
        mt2_usereflectionbluryness type:#boolean default:false ui:chk_reflectionbluryness
        mt2_reflectionbluryness type:#float default:0.0 ui:spn_reflectionbluryness
        mt2_usefresnelR0 type:#boolean default:false ui:chk_fresnelR0
        mt2_fresnelR0 type:#float default:0.4 ui:spn_fresnelR0
        mt2_usereflectionMultiplier type:#boolean default:false ui:chk_reflectionMultiplier
        mt2_reflectionmultiplierR type:#float default:1.0 ui:spn_reflectionmultiplierR
        mt2_reflectionmultiplierG type:#float default:1.0 ui:spn_reflectionmultiplierG
        mt2_reflectionmultiplierB type:#float default:1.0 ui:spn_reflectionmultiplierB

        -- Blending
        mt2_useblendfactor type:#boolean default: false ui:chk_blendfactor
        mt2_blendfactor type:#float default: 0.5 ui:spn_blendfactor
        mt2_uselayer1uvslot type:#boolean default:false ui:chk_layer1uvslot
        mt2_layer1uvslot type:#integer default:0 ui:spn_layer1uvslot
        mt2_uselayer2uvslot type:#boolean default:false ui:chk_layer2uvslot
        mt2_layer2uvslot type:#integer default:0 ui:spn_layer2uvslot
        mt2_useblenduvslot type:#boolean default:false ui:chk_blenduvslot
        mt2_blenduvslot type:#integer default:0 ui:spn_blenduvslot

        -- Water
        mt2_usemindistance type:#boolean default:false ui:chk_mindistance
        mt2_mindistance type:#float default:1000 ui:spn_mindistance
        mt2_usemaxdistance type:#boolean default:false ui:chk_maxdistance
        mt2_maxdistance type:#float default:-1000 ui:spn_maxdistance
        mt2_useseafalloff type:#boolean default:false ui:chk_seafalloff
        mt2_seafalloff type:#float default:1.5 ui:spn_seafalloff
        mt2_useshorefactor type:#boolean default:false ui:chk_shorefactor
        mt2_shorefactor type:#float default:0 ui:spn_shorefactor
    )
    rollout mt2propsrollout "Carmageddon Max Damage Material Properties" (
        group "Base Settings" (
            dropdownlist dpdn_basematerialname "Base Material" items:Mt2BaseMaterials labelOnTop:true
            edittext txt_substance "Substance" labelOnTop:true across:2
            edittext txt_substance2 "Substance 2" labelOnTop:true across:2
        )
        group "Textures"(
            dotnetcontrol lv_textures "listview" height:200
            button btn_addtexture "+" width:300
            edittext txt_texturealias "Texture Alias" labelOnTop:false across:1
            label lbl_texturemap "Texture Bitmap" across:2
            pickbutton pck_texturemap "Select a Bitmap" filter:bitmapPickFilter autoDisplay:true across:2
        )
        group "Texture Samplers"(
            dotnetcontrol lv_samplers "listview" height:200
            button btn_addsampler "+" width:300
            dropdownlist dpdn_minfilter "Min Filter" items:#("2D", "3D")
        )
        group "Texture Coord Sources"(
            dotnetcontrol lv_texturecoordsources "listview" height:200
            button btn_addtexturecoordsource "+" width:300
            spinner spn_tcs_uvstream "UVStream" range:[0,5, 1] type:#integer labelOnTop:true across:true
            checkbox chk_tcs_scrolling "Scrolling?"
            spinner spn_tcs_scrollx "Scroll X" range:[-1000,1000, 0.001] type:#float labelOnTop:true across: 2
            spinner spn_tcs_scrolly "Scroll Y" range:[-1000,1000, 0.001] type:#float labelOnTop:true across: 2
            checkbox chk_tcs_flipbook "Flip Book?"
            spinner spn_tcs_flipbookframesX "Horizontal Frames" range:[0,1000, 1] type:#integer labelOnTop:true across:true
            spinner spn_tcs_flipbookframesY "Vertical Frames" range:[0,1000, 1] type:#integer labelOnTop:true across:true
            spinner spn_tcs_flipbookframrate "Frame Rate" range:[0,100, 0.001] type:#integer labelOnTop:true across:true
            checkbox chk_tcs_flipbookselect "Flip Book Select?"
            spinner spn_tcs_flipbookselectframe "Flip Book Select Frame" range:[0, 1000,1] type:#integer labelOnTop:true across:2
            checkbox chk_tcs_waving "Waving?"
            spinner spn_tcs_wavefrequenceu "Wave Frequence U" labelOnTop:true range:[0,100,0.001] type:#float across:true
            spinner spn_tcs_wavefrequencev "Wave Frequence V" labelOnTop:true range:[0,100,0.001] type:#float across:true
            spinner spn_tcs_waveamplitudeu "Wave Amplitude U" labelOnTop:true range:[0,100,0.001] type:#float across:true
            spinner spn_tcs_waveamplitudev "Wave Amplitude V" labelOnTop:true range:[0,100,0.001] type:#float across:true
        )
        group "Properties" (
            checkbox chk_doublesided "Double Sided" checked:false across:2
            checkbox chk_translucent "Translucent" checked:false across:2
            checkbox chk_castshadows "Casts Shadows" checked:false across:2
            checkbox chk_receivesshadows "Receives Shadows" checked:false across:2
            checkbox chk_fogenabled "Fog Enabled" checked:false across:2
        )
        group "Ped Properties" (
            checkbox chk_walkable "Walkable" checked:false across:2
            checkbox chk_panickable "Panickable" checked:false across:2
            checkbox chk_sittable "Sittable" checked:false across:2
        )

        group "Constants" (
            checkbox chk_multiplier "Multiplier"
            spinner spn_multiplierR "R" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            spinner spn_multiplierG "G" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            spinner spn_multiplierB "B" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            checkbox chk_multiplierisfloat3 "Use 3 components for multiplier?"
            checkbox chk_alphacutoff "Alpha Cut Off" across:2
            spinner spn_alphacutoff "" type:#float range:[0,1,0.01] labelOnTop:false across:2
            checkbox chk_emissivefactor "Emissive Factor" across:2
            spinner spn_emissivefactor "" type:#float range:[0,10,0.01] labelOnTop:false across:2
            checkbox chk_emissivelight "Emissive Light"
            spinner spn_emissivelightR "R" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            spinner spn_emissivelightG "G" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            spinner spn_emissivelightB "B" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            checkbox chk_fresnelR0 "Fresnel R0" across:2
            spinner spn_fresnelR0 "" type:#float range:[0,10,0.01] labelOnTop:false across:2
            checkbox chk_reflectionbluryness "Refelection Bluryness" across:2
            spinner spn_reflectionbluryness "" type:#float range:[0,10,0.01] labelOnTop:false across:2
            checkbox chk_reflectionMultiplier "Refelection Multiplier"
            spinner spn_reflectionmultiplierR "R" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            spinner spn_reflectionmultiplierG "G" labelOnTop:false across:3 type:#float range:[0,10,0.01]
            spinner spn_reflectionmultiplierB "B" labelOnTop:false across:3 type:#float range:[0,10,0.01]
        )

        group "Blending" (
            checkbox chk_blendfactor "Blend Factor" across:2
            spinner spn_blendfactor "" type:#float range:[0,1,0.01] across:2
            checkbox chk_blenduvslot "Blend UV Slot" across:2
            spinner spn_blenduvslot "" type:#integer range:[0,4,1] across:2
            checkbox chk_layer1uvslot "Layer 1 UV Slot" across:2
            spinner spn_layer1uvslot "" type:#integer range:[0,4,1] across:2
            checkbox chk_layer2uvslot "Layer 2 UV Slot" across:2
            spinner spn_layer2uvslot "" type:#integer range:[0,4,1] across:2
        )

        group "Water" (
            checkbox chk_mindistance "Min Distance" across:2
            spinner spn_mindistance "" type:#float range:[-10000,10000,1] across:2
            checkbox chk_maxdistance "Max Distance" across:2
            spinner spn_maxdistance "" type:#float range:[-10000,10000,1] across:2
            checkbox chk_seafalloff "Sea Falloff" across:2
            spinner spn_seafalloff "" type:#float range:[0,100,0.1] across:2
            checkbox chk_shorefactor "Shore Factor" across:2
            spinner spn_shorefactor "" type:#float range:[0,1,0.01] across:2

        )

        fn bitmapPickFilter obj = (classof obj) == Bitmap 

        fn UpdateForm = (
            if chk_multiplier.checked then (
                spn_multiplierR.enabled = true
                if chk_multiplierisfloat3.checked then (
                    spn_multiplierG.enabled = true
                    spn_multiplierB.enabled = true
                )
                else  (
                    spn_multiplierG.enabled = true
                    spn_multiplierB.enabled = true
                )
            )
            else  (
                spn_multiplierR.enabled = false
                spn_multiplierG.enabled = false
                spn_multiplierB.enabled = false
            )

            if chk_alphacutoff.checked then (
                spn_alphacutoff.enabled = true
            )
            else (
                spn_alphacutoff.enabled = false
            )

            if chk_emissivefactor.checked then (
                spn_emissivefactor.enabled = true
            )
            else (
                spn_emissivefactor.enabled = false
            )
            
            if chk_emissivelight.checked then (
                spn_emissivelightR.enabled = true
                spn_emissivelightG.enabled = true
                spn_emissivelightB.enabled = true
            )
            else (
                spn_emissivelightR.enabled = false
                spn_emissivelightG.enabled = false
                spn_emissivelightB.enabled = false
            )

            if chk_fresnelR0.checked then (
                spn_fresnelR0.enabled = true
            )
            else (
                spn_fresnelR0.enabled = false
            )

            if chk_reflectionbluryness.checked then (
                spn_reflectionbluryness.enabled = true
            )
            else (
                spn_reflectionbluryness.enabled = false
            )
            
            if chk_reflectionMultiplier.checked then (
                spn_reflectionmultiplierR.enabled = true
                spn_reflectionmultiplierG.enabled = true
                spn_reflectionmultiplierB.enabled = true
            )
            else (
                spn_reflectionmultiplierR.enabled = false
                spn_reflectionmultiplierG.enabled = false
                spn_reflectionmultiplierB.enabled = false
            )
            if mt2_basematerialname == "simple_norm_spec_env_blend_base" then (
                if chk_blendfactor.checked then (
                    spn_blendfactor.enabled = true
                )
                else (
                    spn_blendfactor.enabled = false
                )

                if chk_blenduvslot.checked then (
                    spn_blenduvslot.enabled = true
                )
                else (
                    spn_blenduvslot.enabled = false
                )

                if chk_layer1uvslot.checked then (
                    spn_layer1uvslot.enabled = true
                )
                else (
                    spn_layer1uvslot.enabled = false
                )

                if chk_layer2uvslot.checked then (
                    spn_layer2uvslot.enabled = true
                )
                else (
                    spn_layer2uvslot.enabled = false
                )
            )
            else (
                    spn_blendfactor.enabled = false
                    spn_blenduvslot.enabled = false
                    spn_layer1uvslot.enabled = false
                    spn_layer2uvslot.enabled = false
            )

            if mt2_basematerialname == "water_base" or mt2_basematerialname == "fog" then (
                if chk_mindistance.checked then (
                    spn_mindistance.enabled = true
                )
                else (
                    spn_mindistance.enabled = false
                )

                if chk_maxdistance.checked then (
                    spn_maxdistance.enabled = true
                )
                else (
                    spn_maxdistance.enabled = false
                )

                if chk_seafalloff.checked then (
                    spn_seafalloff.enabled = true
                )
                else (
                    spn_seafalloff.enabled = false
                )

                if chk_shorefactor.checked then (
                    spn_shorefactor.enabled = true
                )
                else (
                    spn_shorefactor.enabled = false
                )
            )
            else (
                    spn_mindistance.enabled = false
                    spn_maxdistance.enabled = false
                    spn_seafalloff.enabled = false
                    spn_shorefactor.enabled = false
            )
            
        )
        on mt2propsrollout open do (
            
            lv_textures.view  = (dotnetclass "view").details
            lv_textures.fullrowselect= true
            lv_textures.gridlines = true
            lv_textures.multiselect =false
            lv_textures.columns.add "Alex" 140
            lv_textures.columns.add "Texture" 70
            UpdateTextures

            lv_texturecoordsources.view  = (dotnetclass "view").details
            lv_texturecoordsources.fullrowselect= true
            lv_texturecoordsources.gridlines = true
            lv_texturecoordsources.multiselect =false
            lv_texturecoordsources.columns.add "Alias" 140
            UpdateTextureCoordSources()
            UpdateForm()
        )
    )
)

fn AddMt2ToMaterial mat = (
    if (HasCustomAttribute mat #mt2mat_data) == false then (
        custattributes.add mat Mt2Mat_CA


    )
)