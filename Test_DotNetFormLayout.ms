fileIn "DotNetFormHelper.ms"

fn TestFormLayout = (

	local testFormDialog = dotNetObject "System.Windows.Forms.Form"
	testFormDialog.text = "Test dialog"
	testFormDialog.name = "TestDialog"
	testFormDialog.Width = 700
	testFormDialog.Height = 500

	formHelper = DotNetFormHelper ParentControl:testFormDialog
	formHelper.BeginVerticalGroup()
		formHelper.BeginHorizontalGroup()

		local btn1 = formHelper.AddControl "System.Windows.Forms.Button" size:[100,30]
		btn1.text = "Monkey"

		local btn2 = formHelper.AddControl "System.Windows.Forms.Button" size:[100,30]
		btn2.text = "Banana"

		local btn3 = formHelper.AddControl "System.Windows.Forms.Button" size:[100,30]
		btn3.text = "Raffle"
		formHelper.BeginVerticalGroup()
			local txt1 = formHelper.AddControl "System.Windows.Forms.TextBox" size:[200,30]
			txt1.text = "This is a test"
			local txt2 = formHelper.AddControl "System.Windows.Forms.TextBox" size:[200,30]
			txt2.text = "What do I type?"
			local txt3 = formHelper.AddControl "System.Windows.Forms.TextBox" size:[200,30]
			txt3.text = "This is working better"
			local txt4 = formHelper.AddControl "System.Windows.Forms.TextBox" size:[200,30]
			txt4.text = "Than I ever expected"
		formHelper.EndVerticalGroup()
		formHelper.EndHorizontalGroup()
		formHelper.BeginHorizontalGroup()
			formHelper.BeginVerticalGroup()
				local chk1 = formHelper.AddControl "System.Windows.Forms.Checkbox" size:[150,30]
				chk1.text = "Lorum Ipsum"
				local chk2 = formHelper.AddControl "System.Windows.Forms.Checkbox" size:[150,30]
				chk2.text = "Dollar Sit"
				local chk3 = formHelper.AddControl "System.Windows.Forms.Checkbox" size:[150,30]
				chk3.text = "Something something darkside"
				formHelper.BeginHorizontalGroup()

				local btn4 = formHelper.AddControl "System.Windows.Forms.Button" size:[50,30]
				btn4.text = "Monkey"

				local btn5 = formHelper.AddControl "System.Windows.Forms.Button" size:[50,30]
				btn5.text = "Banana"				
				formHelper.EndHorizontalGroup()
			formHelper.EndVerticalGroup()
			formHelper.BeginVerticalGroup()
				local chk4 = formHelper.AddControl "System.Windows.Forms.Checkbox" size:[150,30]
				chk4.text = "Cunning Stunt"
				local chk5 = formHelper.AddControl "System.Windows.Forms.Checkbox" size:[150,30]
				chk5.text = "Style Bonus"
				local chk6 = formHelper.AddControl "System.Windows.Forms.Checkbox" size:[150,30]
				chk6.text = "Wasted 'Em"
				formHelper.BeginHorizontalGroup()

				local btn6 = formHelper.AddControl "System.Windows.Forms.Button" size:[50,30]
				btn6.text = "Monkey"

				local btn7 = formHelper.AddControl "System.Windows.Forms.Button" size:[50,30]
				btn7.text = "Banana"				
				formHelper.EndHorizontalGroup()
			formHelper.EndVerticalGroup()
		formHelper.EndHorizontalGroup()
	formHelper.EndVerticalGroup()
	testFormDialog.Show()
)