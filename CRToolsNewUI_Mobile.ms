fileIn "C1Mobile_ConvertC1.ms"

fn ShowDataFolderBrowser sender arg = (
	local folderSelectDialog = dotnetobject "CMDControls.FolderSelectDialog"
	if folderSelectDialog.ShowDialog() and folderSelectDialog.FileName != undefined then (
		local folderInput = sender.parent.Controls.Find "DataFolderInput"
		folderInput.text = folderSelectDialog.FileName
	)
)




fn ShowExportToMobileForm title message exportFunction = (
	global CarmaSettings
	global mobileExportFunction = exportFunction
	funsizeExport = dotNetObject "System.Windows.Forms.Form"
	funsizeExport.Name = "FunsizeExport"
	funsizeExport.Text = title
	funsizeExport.width = 400
	funsizeExport.height = 500
	
	local layoutHelper = DotNetFormHelper ParentControl:funsizeExport OutterMarginTop:0 OutterMarginBottom:5 OutterMarginLeft:5 OutterMarginRight:5
	layoutHelper.BeginVerticalGroup marginTop:10 marginBottom:20
	(
		local DataFolderLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[200,27] margin:[10,0]
		DataFolderLabel.text = "Data Folder"
		layoutHelper.SetFont DataFolderLabel "Segoe UI" 12 bold:true underline:false
		
		layoutHelper.BeginHorizontalGroup margintop:5 marginBottom:5
		(
			local folderInput = layoutHelper.AddControl "System.Windows.Forms.TextBox" size:[200,27] margin:[10,0]
			folderInput.name = "DataFolderInput"
			folderInput.text = CarmaSettings.FunsizeSettings.DataFolder
			local browseFolderButton = layoutHelper.AddControl "System.Windows.Forms.Button" size:[80,27] margin:[10,0]
			browseFolderButton.name="browseFolderButton"
			browseFolderButton.Text = "Browse"
			SetClickHandler browseFolderButton ShowDataFolderBrowser

		)
		layoutHelper.EndHorizontalGroup()

		local autoBuildCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
		autoBuildCheckbox.text = "Auto Build"
		autoBuildCheckbox.checked = CarmaSettings.FunsizeSettings.autoBuild
		autoBuildCheckbox.name = "autoBuildCheckbox"

		local autoDeployCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
		autoDeployCheckbox.text = "Auto Deploy"
		autoDeployCheckbox.checked = CarmaSettings.FunsizeSettings.autoDeployObb
		autoDeployCheckbox.name = "autoDeployCheckbox"

		local autoLaunchCheckbox = layoutHelper.AddControl "System.Windows.Forms.Checkbox" size:[200,20]
		autoLaunchCheckbox.text = "Auto Launch"
		autoLaunchCheckbox.checked = CarmaSettings.FunsizeSettings.autoLaunchGame
		autoLaunchCheckbox.name = "autoLaunchCheckbox"

		local messageLabel = layoutHelper.AddControl "System.Windows.Forms.Label" size:[400,27] margin:[10,0]
		messageLabel.text = message
		messageLabel.autosize = true
		messageLabel.MaximumSize = 	CRToolsUI.MaximumSize = dotNetObject "System.Drawing.Size" (funsizeExport.Width - 50) 0
		layoutHelper.SetFont messageLabel "Segoe UI" 10 bold:false underline:false
		
		layoutHelper.BeginHorizontalGroup margintop:10 marginBottom:10
		(

			local okButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
			okButton.Text = "Export"
			global funsizeExportMethod = exportFunction

			fn ExportOkClicked okButton ev = (
				global funsizeExportMethod
				local dataFolder = okButton.Parent.Controls.Item["DataFolderInput"].text
				local autoBuild = okButton.Parent.Controls.Item["autoBuildCheckbox"].checked
				local autoDeploy = okButton.Parent.Controls.Item["autoDeployCheckbox"].checked
				local autoLaunch = okButton.Parent.Controls.Item["autoLaunchCheckbox"].checked

				global CarmaSettings
				CarmaSettings.FunsizeSettings.DataFolder = dataFolder
				CarmaSettings.FunsizeSettings.AutoBuild = autoBuild
				CarmaSettings.FunsizeSettings.autoLaunchGame = autoLaunch
				CarmaSettings.FunsizeSettings.autoDeployObb = autoDeploy
				CarmaSettings.save()
				funsizeExportMethod okButton ev

				okButton.parent.Close()
			)
			SetClickHandler okButton ExportOkClicked

			local cancelButton = layoutHelper.AddControl  "System.Windows.Forms.Button" size:[100,20]
			cancelButton.Text = "Cancel"

			fn ExportCancelClicked cancelButton ev = (
				cancelButton.parent.Close()
			)
			SetClickHandler cancelButton ExportCancelClicked
		)
		layoutHelper.EndHorizontalGroup()

	)
	layoutHelper.EndVerticalGroup()

	funsizeExport.ShowDialog()
)

fn MobileDoExportFullCar = (
	global CarmaSettings 


)