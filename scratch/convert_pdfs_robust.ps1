$pdfFiles = Get-ChildItem -Path "c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates" -Filter "*.pdf"

[Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime] | Out-Null
Add-Type -AssemblyName System.Drawing

foreach ($pdf in $pdfFiles) {
    try {
        $pdfPath = $pdf.FullName
        $pngPath = [System.IO.Path]::ChangeExtension($pdfPath, ".png")
        Write-Host "Processing $($pdf.Name)..."
        
        $asyncFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($pdfPath)
        while ($asyncFile.Status -eq [Windows.Foundation.AsyncStatus]::Started) { Start-Sleep -Milliseconds 50 }
        $file = $asyncFile.GetResults()

        $asyncDoc = [Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file)
        while ($asyncDoc.Status -eq [Windows.Foundation.AsyncStatus]::Started) { Start-Sleep -Milliseconds 50 }
        $doc = $asyncDoc.GetResults()

        $page = $doc.GetPage(0)
        $stream = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
        $options = New-Object Windows.Data.Pdf.PdfPageRenderOptions
        $options.DestinationWidth = [uint32]($page.Size.Width * 2)

        $asyncRender = $page.RenderToStreamAsync($stream, $options)
        while ($asyncRender.Status -eq [Windows.Foundation.AsyncStatus]::Started) { Start-Sleep -Milliseconds 50 }

        $netStream = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($stream)
        $bmp = [System.Drawing.Bitmap]::FromStream($netStream)
        $bmp.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $netStream.Dispose()
        $stream.Dispose()
        $page.Dispose()
        Write-Host "Successfully saved $pngPath"
    } catch {
        Write-Host "Error: $_"
    }
}
