struct Doc (
	debugLog = false,
    filename = "",
    buffer = "",
    currentToken = "",
    lastToken = "",
    bufferStream,
    on create do (
        if filename != "" then (
            local f = openfile filename mode:"rt"
            
            buffer = ""

            while not (eof f) do (

                buffer = buffer + "\n" + (readline f)
            )
            fclose f

            currentPosition = 0
            bufferStream = StringStream buffer
        )
    ),
    fn EndOfFile = (
        eof bufferStream
    ),
    fn isWhiteSpace char = (
        char == "" or char == " " or char == "\t" or char == "\r" or char == "\n"
    ),
    fn isDelimitter char = (
        char == "," or char == "\"" or char == "'"
    ),
    fn isWhiteSpaceOrDelimitter char isInString = (
        (not isInString and ((isWhiteSpace char) or (isDelimitter char))) or (isInString and (cher == "\"" or char == "'"))
    ),
    fn isSpecial char = (
        char == "{" or char == "}" or char ==  "="
    ),
    fn PeekChar = (
        local pos = filepos bufferStream
        local c = readchar bufferstream
        seek bufferstream pos

        c
    ),
    fn isComment char isInString = (
        char  == "-" and PeekChar() == "-" and not isInString
    ),
    fn NextToken isPeeking:false = (
        lastToken = currentToken
        currentToken = ""
        if not (eof bufferStream) then  (
            local keepLooping = true
            local inString = false
            while not (eof bufferStream) and keepLooping do (
                    
                local nextchar = readchar bufferStream
				local justLeftString = false
                if currentToken == "" then (
                    inString = nextchar == "\"" or nextChar == "'"
                    
                    if inString and not (eof bufferStream) then (
                        nextchar = readchar bufferstream
                    )
                )
				if inString and (nextchar == "\"" or nextChar == "'") then (
					inString = false
					justLeftString = true
                    if not (eof bufferStream) then (
                        nextchar = readchar bufferstream
                    )
				)

                if isComment nextChar inString then (
                    keepLooping = currentToken == ""
					readchar bufferStream
					local c = 0
					while not (eof bufferStream) and nextchar != "\n" do (
						nextchar = readchar bufferStream
						if nextchar == "\n" then (
							if debugLog and not isPeeking then format "~|\tnew line found at % chars in a comment\n" c
						)
						c+=1
					)
					if debugLog and not isPeeking then format "~|\tskipped % chars in a comment\n" c
                )
				else if justLeftString then (
					keepLooping = false
				)
                else if (isWhiteSpaceOrDelimitter nextChar inString) then (
                    -- we want to skip to the next token if we find white space
                    -- at the start of a token
                    keepLooping = currentToken == ""
                )
                else (
                    currentToken = currentToken + nextChar

                    -- We want to stop before special characters like braces or equals
                    -- this is so tokens dont get merged when there's no whitespace
                    -- but we want to keep the special characters as tokens themselves
                    keepLooping = inString or not (isSpecial currentToken) and not (isSpecial (PeekChar()))
                )
            )
        )
        
		if debugLog and not isPeeking then format "~|\t%\n" currentToken
		
        currentToken
    ),
    fn Peek = (        
        local pos = filepos bufferStream
        local t = NextToken isPeeking:true
        seek bufferstream pos

        t
    ),
    fn SkipToToken token = (
        local lowerCaseToken = toLower token
        while tolower (Peek()) != token do (
            NextToken()
        )

        NextToken()
    )

)