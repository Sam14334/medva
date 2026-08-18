Add-Type -AssemblyName System.Runtime.WindowsRuntime
$pdfFiles = Get-ChildItem -Path "c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates" -Filter "*.pdf"

[Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime] | Out-Null
Add-Type -AssemblyName System.Drawing

$asTaskGeneric = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq "AsTask" -and $_.IsGenericMethod } | Select-Object -First 1
$asTaskAction = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq "AsTask" -and -not $_.IsGenericMethod -and $_.GetParameters().Length -eq 1 } | Select-Object -First 1

foreach ($pdf in $pdfFiles) {
    try {
        $pdfPath = $pdf.FullName
        $pngPath = [System.IO.Path]::ChangeExtension($pdfPath, ".png")
        Write-Host "Processing $($pdf.Name)..."
        
        $asyncFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($pdfPath)
        $file = $asTaskGeneric.MakeGenericMethod([Windows.Storage.StorageFile]).Invoke($null, @($asyncFile)).GetAwaiter().GetResult()

        $asyncDoc = [Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file)
        $doc = $asTaskGeneric.MakeGenericMethod([Windows.Data.Pdf.PdfDocument]).Invoke($null, @($asyncDoc)).GetAwaiter().GetResult()

        $page = $doc.GetPage(0)
        $stream = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
        $options = New-Object Windows.Data.Pdf.PdfPageRenderOptions
        $options.DestinationWidth = [uint32]($page.Size.Width * 2)

        $asyncRender = $page.RenderToStreamAsync($stream, $options)
        $taskRender = $asTaskAction.Invoke($null, @($asyncRender))
        $taskRender.GetAwaiter().GetResult()

        $netStream = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($stream)
        $bmp = [System.Drawing.Bitmap]::FromStream($netStream)
        $bmp.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $netStream.Dispose()
        $stream.Dispose()
        $page.Dispose()
        Write-Host "Successfully saved $pngPath"
    } catch {
        Write-Host "Error: $_`n$($_.ScriptStackTrace)"
    }
}
