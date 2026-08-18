[Windows.System.UserProfile.UserProfileContract, Windows, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime] | Out-Null

Add-Type -AssemblyName System.Drawing

function Convert-PdfToPng([string], [string]) {
     = [Windows.Storage.StorageFile]::GetFileFromPathAsync()
    while (.Status -eq 'Started') { Start-Sleep -Milliseconds 50 }
     = .GetResults()

     = [Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync()
    while (.Status -eq 'Started') { Start-Sleep -Milliseconds 50 }
     = .GetResults()

     = .GetPage(0)
     = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
     = New-Object Windows.Data.Pdf.PdfPageRenderOptions
    .DestinationWidth = [uint32](.Size.Width * 2)

     = .RenderToStreamAsync(, )
    while (.Status -eq 'Started') { Start-Sleep -Milliseconds 50 }

     = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead()
     = [System.Drawing.Bitmap]::FromStream()
    .Save(, [System.Drawing.Imaging.ImageFormat]::Png)
    .Dispose()
    .Dispose()
    .Dispose()
    .Dispose()
}

foreach ( in Copy of MEDVA - Medical Receptionist.pdf Copy of MEDVA - Nurturing Virtual Synergy .pdf Copy of MEDVA Lab and imaging orders.pdf Copy of MEDVA_s Onboarding Course - MEDVA Training Courses.pdf) {
     = [System.IO.Path]::ChangeExtension(.FullName, ".png")
    Write-Host "Converting  to PNG..."
    Convert-PdfToPng -pdfPath .FullName -pngPath 
}
Write-Host "Done converting all PDFs."
