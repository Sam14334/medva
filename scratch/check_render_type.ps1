Add-Type -AssemblyName System.Runtime.WindowsRuntime
[Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime] | Out-Null

$pdfPath = 'c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates\Copy of MEDVA - Medical Receptionist.pdf'
$asyncFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($pdfPath)
$asTaskGeneric = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.IsGenericMethod } | Select-Object -First 1
$file = $asTaskGeneric.MakeGenericMethod([Windows.Storage.StorageFile]).Invoke($null, @($asyncFile)).GetAwaiter().GetResult()
$doc = $asTaskGeneric.MakeGenericMethod([Windows.Data.Pdf.PdfDocument]).Invoke($null, @([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file))).GetAwaiter().GetResult()
$page = $doc.GetPage(0)
$stream = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
$options = New-Object Windows.Data.Pdf.PdfPageRenderOptions
$asyncRender = $page.RenderToStreamAsync($stream, $options)
$asyncRender.GetType().GetInterfaces() | ForEach-Object { Write-Host $_.FullName }
