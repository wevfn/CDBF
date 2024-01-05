Set WShell = Wscript.CreateObject("Wscript.Shell")
Path = Chr(34) & CreateObject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path &"\CDBFT.cmd" & Chr(34)
If WScript.Arguments.Count > 0 Then
If WScript.Arguments(0) = "sr" Then
WShell.Run Path & " bcp" ,0
Wscript.Quit
ElseIf WScript.Arguments(0) ="err" Then
MsgBox "PATH ERROR !", vbCritical , "CDBF"
Wscript.Quit
End If
End If
WShell.Run Path & " bcp" ,0
MsgBox "Saving....",  , "CDBF"