$pdfPath = "c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates\Copy of MEDVA - Medical Receptionist.pdf"
$asyncFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($pdfPath)
$interfaces = $asyncFile.GetType().GetInterfaces()
foreach ($iface in $interfaces) {
    Write-Host "Interface: $($iface.FullName)"
    foreach ($m in $iface.GetMethods()) {
        Write-Host "  Method: $($m.Name)"
    }
}
