struct VFXAnchorAttachmentPoint (
    ID = "",
    LumpName = "",
    AnchorOffset = [0,0,0],
    AnchorAngle = [0,0,0],
    AnchorScale = [0,0,0],

    fn Read luaDoc = (
        
			format "\n\t~~~~~~~VFXAnchorAttachmentPoint.Read: start\n"
        
        
        while not luaDoc.EndOfFile() and luaDoc.Peek() != "}" do (

            local nextSection = luaDoc.NextToken()
            luaDoc.NextToken() -- =
            
			format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: reading token %\n" nextSection
            case (toLower nextSection) of (
                "id": ID = luaDoc.NextToken()
                "lump_name": LumpName = luaDoc.NextToken()
                "offset": (
						format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: reading offset\n"
                        luaDoc.NextToken() -- {
					local x = luaDoc.NextToken()
					local y = luaDoc.NextToken()
					local z = luaDoc.NextToken()
						format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: offset values = %, %, %\n" x y z
                        AnchorOffset = [(x as float), (y as float), (z  as float)]
                        luaDoc.NextToken() -- }
                )
                "angle": (
						format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: reading angle\n"
                        luaDoc.NextToken() -- {
					local x = luaDoc.NextToken()
					local y = luaDoc.NextToken()
					local z = luaDoc.NextToken()
						format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: angle values = %, %, %\n" x y z
                        AnchorAngle = [(x as float), (y as float), (z  as float)]
                        luaDoc.NextToken() -- }
                )
                "scale": (
						format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: reading scale\n"
                        luaDoc.NextToken() -- {
					local x = luaDoc.NextToken()
					local y = luaDoc.NextToken()
					local z = luaDoc.NextToken()
						format "\t~~~~~~~VFXAnchorAttachmentPoint.Read: scale values = %, %, %\n" x y z
                        AnchorScale = [(x as float), (y as float), (z  as float)]
                        luaDoc.NextToken() -- }
                )
            )
        )
    )
)
struct VFXAnchorSpec (
    ID = "",
    AttachPoints = #(),

    fn Read luaDoc = (

        AttachPoints = #()
		format "\n\t======VFXAnchorSpec.Read: start\n"
        luaDoc.NextToken() -- {
        
        while not luaDoc.EndOfFile() and luaDoc.Peek() != "}" do (

            local nextSection = luaDoc.NextToken()
            
			format "\t======VFXAnchorSpec.Read: reading token %\n" nextSection
            case (toLower nextSection) of (
                "id": (
					luaDoc.NextToken() -- =
					ID = luaDoc.NextToken()
					
				)
					
                "{": (
			        format "\t======VFXAnchorSpec.Read: Creating new vfx anchorpoint\n"
                    local attachPoint = VFXAnchorAttachmentPoint()
                    attachPoint.Read luaDoc
                    append AttachPoints attachPoint
                    luaDoc.NextToken() -- }
                )
            )
        
        )
		luaDoc.NextToken() -- }
    ),
    
    fn AddPoint pointId lumpName anchorOffset anchorAngle anchorScale = (
        local ind = 0

        for i = 1 to AttachPoints.Count do (
            if tags[i].ID == pointId then (
                ind = i
            )
        )

        if ind == 0 then  (
            local anchorPoint = VFXAnchorAttachmentPoint()
            anchorPoint.ID = pointId
            append AttachPoints anchorPoint
            ind = taga.Count
        )

        AttachPoints[ind].LumpName = lumpName
        AttachPoints[ind].AnchorOffset = anchorOffset
        AttachPoints[ind].AnchorAngle = anchorAngle
        AttachPoints[ind].AnchorScale = anchorScale
    )
)

struct VFXAnchorsFile (
    Tags = #(),

    fn Read path debugLog:false = (
        Filename = path
        local luaScript = (DecodeLOLFile Filename) as StringStream
        local luaDoc = Doc bufferStream:luaScript
        luaDoc.debugLog = debugLog
        luaDoc.SkipToToken "tags"
        luaDoc.NextToken()  -- =
        luaDoc.NextToken()  -- {
        Tags = #()

        while not luaDoc.EndOfFile() and luaDoc.Peek() != "}" do (
			format "\n======Starting new vfx tag\n"
            local spec = VFXAnchorSpec()
            
            --luaDoc.NextToken()  -- {
			
			format "======Reading new vfx tag\n"
            spec.Read luaDoc
            append Tags spec
            
            --luaDoc.NextToken()  -- }
        )

    ),

    fn Save path = (
        vfxAnchorText = stringstream ""

        format "module( ..., vfx_anchors_definition )\n\ntags = {\n" to:vfxAnchorText

        for tag in Tags do (
            format "\t{\n\t\tid = \"%\",\n\n" tag.ID to:vfxAnchorText

            for attachPoints in tags.AttachPoints do (
                format "\t\t{\n" to:vfxAnchorText
                format "\t\t\tid = \"%\",\n" attachPoint.ID to:vfxAnchorText
                format "\t\t\toffset = {%, %, %},\n" attachPoint.AnchorOffset.x attachPoint.AnchorOffset.y attachPoint.AnchorOffset.z to:vfxAnchorText
                format "\t\t\tangle = {%, %, %},\n" attachPoint.AnchorAngle.x attachPoint.AnchorAngle.y attachPoint.AnchorAngle.z to:vfxAnchorText
                format "\t\t\tscale = {%, %, %}\n" attachPoint.AnchorScale.x attachPoint.AnchorScale.y attachPoint.AnchorScale.z to:vfxAnchorText
                format "\t\t},\n" to:vfxAnchorText
            )

            format "\t},\n" to:vfxAnchorText
        )
        format "}" to:vfxAnchorText



        if filename != undefined then (

            f = openfile filename mode:"w"
            format "%" (vfxAnchorText as string) to:f
            close f
        )
    ),

    fn AddPointToTag tagId pointId lumpName anchorOffset anchorAngle anchorScale = (
        local ind = 0

        for i = 1 to tags.Count do (
            if tags[i].ID == tagId then (
                ind = i
            )
        )

        if ind == 0 then  (
            local anchorSpec = VFXAnchorSpec()
            anchorSpec.ID = tagId
            append tags anchorSpec
            ind = taga.Count
        )

        Tags[ind].AddPoint pointId lumpName anchorOffset anchorAngle anchorScale
    )
)

