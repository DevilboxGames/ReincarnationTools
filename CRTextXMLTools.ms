fn XmlCreateTextEntryRowContent key value comment:"" = (
	if key == undefined then (
		key = "undefined"
	)
	if value == undefined then (
		value = ""
	)
	key = substitutestring key "&" "&amp;"
	value = substitutestring value "&" "&amp;"
	comment = substitutestring comment "&" "&amp;"
	"<Cell><Data>" + key + "</Data></Cell>" +		--Key
	"<Cell><Data>" + comment + "</Data></Cell>" + --Comment
	"<Cell><Data>" + value + "</Data></Cell>" + --English
	"<Cell><Data>" + value + "</Data></Cell>" + --French
	"<Cell><Data>" + value + "</Data></Cell>" + --Spanish
	"<Cell><Data>" + value + "</Data></Cell>" + --German
	"<Cell><Data>" + value + "</Data></Cell>" + --Italian
	"<Cell><Data>" + value + "</Data></Cell>" + --Japanese
	"<Cell><Data>" + value + "</Data></Cell>" + --Russian
	"<Cell><Data>" + value + "</Data></Cell>" + --Portuguese
	"<Cell><Data>" + value + "</Data></Cell>" + --Turkish
	"<Cell><Data>" + value + "</Data></Cell>" + --Chinese
	"<Cell><Data>" + value + "</Data></Cell>"   --Polish
)
fn XmlFindRowForLabel xmlDoc key = (
	rows = xmlDoc.GetElementsByTagName "Row"

	foundEl = undefined

	for i = 0 to (rows.count - 1) do (

		el = rows.item[i]
		cellElements = el.FirstChild.FirstChild
		if (toupper cellElements.innertext) == (toupper key) then ( 
			foundEl = el
			i = rows.count
		)
	)
	foundEl
)

fn FunsizeGetValueFromXml key = (
	global CarmaSettings
	FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder

	XmlDoc = dotNetObject "System.Xml.XmlDocument"
	XmlDoc.load (FunsizeDataPath+"Data\\Content\\Text\\Text.xml")

	theRow = XmlFindRowForLabel xmldoc key

	local outputValue = ""
	if theRow == undefined then (
		outputValue = key
	)
	else (
		cell = (theRow.GetElementsByTagName "Cell").item[2]
		data = (cell.GetElementsByTagName "Data").item[0]
		outputValue = data.innertext
	)

	outputValue
)