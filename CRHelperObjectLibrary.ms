
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
        results[1].Item
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