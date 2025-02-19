
struct HelperObjectLibraryItem (
	File,
	Type,
	Item
)

global HelperObjectLibrary = #()

fn FindHelperObject File Type = (
    global HelperObjectLibrary
    local results = for obj in HelperObjectLibrary where obj.File == File and obj.Type == Type collect obj

    if results.count > 0 then (
        local result = undefined
        for i in results do (
            if result == undefined and i.Item != undefined and (isDeleted i.Item) == false then (
                result = i.Item
            )
        )
        result
    )
    else (
        undefined
    )
)

fn StoreHelperObject File Type Item = (
    global HelperObjectLibrary

    local obj = FindHelperObject File Type

    if obj == undefined then (
        obj = HelperObjectLibraryItem File:File Type:Type Item:Item
        append HelperObjectLibrary obj
    )
    else (
        obj.Item = Item
    )

    obj
)

fn ClearHelperObjects = (
    global HelperObjectLibrary
    HelperObjectLibrary = #()
)

callbacks.removeScripts id:#crHelperObjectLibraryCallbacks
callbacks.addScript #systemPreReset "ClearHelperObjects()"
callbacks.addScript #systemPreNew "ClearHelperObjects()"