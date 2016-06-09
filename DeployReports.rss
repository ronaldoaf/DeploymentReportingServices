

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'  Deploynment Reporting Services      
'  Author: Ronaldo Araújo de Farias 
'  https://github.com/ronaldoaf/DeploymentReportingServices.git
'
'  Reference: https://msdn.microsoft.com/en-us/library/reportservice2005.reportingservice2005.aspx
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub Main()

	
	Dim reportName,folderName,reportPath, dataSourceName,folders(),files()  as String

	'''If BACKUP_DIR and DEPLOY_DIR have no "/" at the end puts it
	if BACKUP_DIR(BACKUP_DIR.Length-1) <> "\" then BACKUP_DIR=BACKUP_DIR+"\"	
	if DEPLOY_DIR(DEPLOY_DIR.Length-1) <> "\" then DEPLOY_DIR=DEPLOY_DIR+"\"

	
	
	
	folders =IO.Directory.GetDirectories(DEPLOY_DIR)
	For Each folder As String In folders
	   folderName = New DirectoryInfo(folder).Name
	   
	   'Inside the backup directory creates a subdirectory each of the reports folder.   
	   IO.Directory.CreateDirectory(BACKUP_DIR + folderName)
	   Console.Writeline ("Information: Created directory "+BACKUP_DIR + folderName)
	   Console.Writeline ("--")
	   
	   'Captura o nome do Data Source dentro da pasta, que servirá para todos os relatório dessa pasta.
	   dataSourceName=GetDataSourceFromFolder("/"+folderName)
	   
	   
	   files=IO.Directory.GetFiles(DEPLOY_DIR+folderName)

	  For Each file As String In files
		reportName=IO.Path.GetFileNameWithoutExtension(file)
		reportPath="/"+folderName+"/"+reportName

		
		
		'Tenta fazer o bakcup
		Try
			'Faz o backup do relatório
			BackupReport(reportPath)
		Catch e as Exception
			'Se não conseguir fazer o backup identifica que é um novo relatório
			Console.Writeline ("Information: " + reportPath + " is a new report")
		End Try
		
		
		'Publicate of the report, creating it or updating it
		PublishReports(file, reportName, "/"+folderName) 
		
		
		
		'Defina o datasource da pasta para o relatório
		SetDataSource("/"+folderName, reportName, dataSourceName)
	
	  Next

	Next


End Sub 



'Function to publish the report to report server
Private Sub PublishReports(ByVal FilePath As String, ByVal ReportName As String, ByVal TargetFolder As String)
	Dim ReportDefinition As [Byte]() = Nothing
	Dim warnings as Warning() = Nothing
	Dim description As New [Property]
	Dim properties(0) As [Property]
	 
	Try
	' Open rdl file
	Dim rdlfile As FileStream = File.OpenRead(FilePath)
	ReportDefinition = New [Byte](rdlfile.Length - 1) {}
	rdlfile.Read(ReportDefinition, 0, CInt(rdlfile.Length))
	  rdlfile.Close()
	  'Set Report Description
	  description.Name = "Description"
	  description.Value = ""
	  properties(0) = description
	  'Create a Report
	warnings = rs.CreateReport(ReportName, TargetFolder, True,   ReportDefinition,Properties)
	Console.WriteLine("Information: " + TargetFolder +"/"+ReportName + " published successfully")
	Catch e as Exception
	  Console.Writeline (e.Message)
	End Try
End Sub


'Function to assign the datasource for the report
Private Sub SetDataSource(ByVal FolderName As String, ByVal ReportName As String, ByVal DataSourcePath As String)
	 Try
		rs.Credentials = System.Net.CredentialCache.DefaultCredentials
		Dim ReportPath As String = FolderName + "/" + ReportName
		Dim DataSources(0) As DataSource
		Dim DsRef As New DataSourceReference
		 
		'Captura o DataSource atual do Report para utilizar seu nome
		Dim CurrentDataSourcesFromReport As DataSource()=rs.GetItemDataSources(reportPath)	 
		 
		 
		DsRef.Reference = DataSourcePath
		Dim objDS As new DataSource
		objDS.Item = CType (DsRef, DataSourceDefinitionOrReference)
		objDS.Name = CurrentDataSourcesFromReport(0).Name

		
		DataSources(0) = objDS
		rs.SetItemDataSources(ReportPath, DataSources)
		Console.Writeline ("Information: DataSource " + objDS.Name + " is set to the report " + ReportName)
	Catch e As Exception
		Console.Writeline (e.Message)
	End Try
End Sub



Public Function GetDataSourceFromFolder(ByVal pasta as String ) As String

   GetDataSourceFromFolder=""
   Dim cat As CatalogItem 
   For Each cat In rs.ListChildren(pasta,true)

       if cat.Type=5 then
		  GetDataSourceFromFolder=cat.Path 
	   end if 
   Next cat 
End Function



Public Function BackupReport(ByVal reportPath as String ) As Boolean 

		Console.WriteLine("Information: Report " + reportPath + " backed up successfully")
		Dim reportDefinition As Byte() = Nothing

		Dim rdlReport As New System.Xml.XmlDocument
		reportDefinition = rs.GetReportDefinition(reportPath)

		Dim Stream As New MemoryStream(reportDefinition)

		rdlReport.Load(Stream)
		rdlReport.Save(BACKUP_DIR + reportPath +".rdl")


End Function




