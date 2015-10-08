  (
  	source = ""
  	source += "using System;\n"
  	source += "using System.Runtime.InteropServices;\n"
  	source += "class WindowsGhosting\n"
  	source += "{\n"
  	source += "	[DllImport(\"user32.dll\")]\n"
  	source += "	public static extern void DisableProcessWindowsGhosting();\n"
  	source += "}\n"
  
  	csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
  	compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
  
  	compilerParams.GenerateInMemory = on
  	compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)

  	assembly = compilerResults.CompiledAssembly
  	windowsGhosting = assembly.CreateInstance "WindowsGhosting"
  	windowsGhosting.DisableProcessWindowsGhosting()
  )
  
  rollout Thread "Running Multiple Threads in DotNet" width:728 height:147
  (
	  progressBar pb1 "" width:168 height:16 color:(color 255 255 0)
	button btnstart "Start"  width:42 height:28
	button btnstart2 "Start"  width:42 height:28
	  on btnstart pressed do
	  (
		  
			for i=1 to 2000 do 
			(
				Thread.pb1.value = ((i as float) / 2000) * 100
				sleep 0.01
			)
	  )
	  on btnstart2 pressed do
	  (
		  bb = box()
		  mat = standardmaterial()
		  bb.material=mat
		  bmap = bitmap 320 240 color:green
		  mat.diffusemap = Bitmaptexture bitmap:bmap
	  )
  )

createdialog thread  style:#(#style_toolwindow, #style_sysmenu) 
