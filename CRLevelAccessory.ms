struct CRLevelAccessorySpec (
    AccessoryTransform = matrix3 1, -- Matrix3
    AccessoryName = "",      -- String
    AccessoryType = "",      -- String
    AccessoryLayer = "",     -- String
    AccessoryColour = color 255 255 255,    -- Color
    AccessoryLabel = "accessory",     -- String

    fn Read luaDoc = (
        AccessoryLabel = luaDoc.NextToken()
        luaDoc.NextToken() -- =
        luaDoc.NextToken() -- {
        
        while not luaDoc.EndOfFile() and luaDoc.Peek() != "}" do (
            local nextSection = luaDoc.NextToken()
            luaDoc.NextToken() -- =
            case (toLower nextSection) of (
                "type": AccessoryType = luaDoc.NextToken()
                "name": AccessoryName = luaDoc.NextToken()
                "layer": AccessoryLayer = luaDoc.NextToken()
                "colour": (
                    luaDoc.NextToken() -- {
                    AccessoryColour = Color  (luaDoc.NextToken() as integer) (luaDoc.NextToken() as integer) (luaDoc.NextToken()  as integer)
                    luaDoc.NextToken() -- }
                )
                "transform": (
                    luaDoc.NextToken() -- {
                    
                        luaDoc.NextToken() -- {
                        local xAxis = Point3 (luaDoc.NextToken() as float) (luaDoc.NextToken() as float) (luaDoc.NextToken()  as float)
                        luaDoc.NextToken() -- }

                        luaDoc.NextToken() -- {
                        local yAxis = Point3 (luaDoc.NextToken() as float) (luaDoc.NextToken() as float) (luaDoc.NextToken()  as float)
                        luaDoc.NextToken() -- }
                        
                        luaDoc.NextToken() -- {
                        local zAxis = Point3 (luaDoc.NextToken() as float) (luaDoc.NextToken() as float) (luaDoc.NextToken()  as float)
                        luaDoc.NextToken() -- }
                        
                        luaDoc.NextToken() -- {
                        local pos = Point3 (luaDoc.NextToken() as float) (luaDoc.NextToken() as float) (luaDoc.NextToken()  as float)
                        luaDoc.NextToken() -- }
                    luaDoc.NextToken() -- }

                    AccessoryTransform = matrix3 xAxis yAxis zAxis pos
                    AccessoryTransform = (matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0]) * AccessoryTransform * inverse(matrix3 [-1,0,0] [0,0,-1] [0,1,0] [0,0,0])
                )
            )
        )
        
        luaDoc.NextToken() -- }
    ),

    fn Write stream = (
        local t = (matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0]) * AccessoryTransform * inverse(matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0])
        
        format "\t% = \n\t{\n\t\ttype = \"%\",\n\t\tname = \"%\",\n\t\tlayer = \"%\",\n\t\ttransform = { { %, %, % },  { %, %, % },  { %, %, % },  { %, %, % }}, colour = { %, %, %}\n\t},\n\n" AccessoryLabel AccessoryType AccessoryName AccessoryLayer t.row1.x t.row1.y t.row1.z t.row2.x t.row2.y t.row2.z  t.row3.x t.row3.y t.row3.z t.row4.x t.row4.y t.row4.z (AccessoryColour.r as integer) (AccessoryColour.g as integer) (AccessoryColour.b as integer) to:stream
    )
)

struct CRLevelAccessoriesFile (
    Accessories = #(),    -- CRLevelAccessorySpec[]
    Filename,       -- string

    fn Read path = (
        Filename = path
        local luaScript = (DecodeLOLFile Filename) as StringStream
        local luaDoc = Doc bufferStream:luaScript
        
        luaDoc.SkipToToken "accessories"
        luaDoc.NextToken()  -- {
		Accessories = #()
        while not luaDoc.EndOfFile() and luaDoc.Peek() != "}" do (
            local spec = CRLevelAccessorySpec()
            spec.Read luaDoc
            append Accessories spec
        )
    ),
    fn Write path = (
        local stream = StringStream ""
        format "module( ..., level_powerup_setup )\n\naccessories = \n{\n" to:stream
        for spec in Accessories do (
            spec.Write stream
        )
        format "}\n" to:stream

        f = openfile path mode:"wt"
        format "%" (stream as string) to:f
        close f
    )
)