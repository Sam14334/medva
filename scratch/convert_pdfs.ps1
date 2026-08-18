$pdfFiles = Get-ChildItem -Path "c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates" -Filter "*.pdf"

$code = @"
using System;
using System.IO;
using System.Threading.Tasks;
using Windows.Data.Pdf;
using Windows.Storage;
using Windows.Storage.Streams;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices.WindowsRuntime;

public class PdfRenderer {
    public static void ConvertPdfToPng(string pdfPath, string pngPath) {
        Task.Run(async () => {
            StorageFile file = await StorageFile.GetFileFromPathAsync(pdfPath);
            PdfDocument pdfDoc = await PdfDocument.LoadFromFileAsync(file);
            using (var page = pdfDoc.GetPage(0)) {
                var stream = new InMemoryRandomAccessStream();
                var options = new PdfPageRenderOptions();
                options.DestinationWidth = (uint)(page.Size.Width * 2);
                await page.RenderToStreamAsync(stream, options);
                using (var netStream = stream.AsStreamForRead()) {
                    using (var bmp = new Bitmap(netStream)) {
                        bmp.Save(pngPath, ImageFormat.Png);
                    }
                }
            }
        }).GetAwaiter().GetResult();
    }
}
"@

$refAssemblies = @(
    "System.Drawing.dll",
    "System.Runtime.WindowsRuntime.dll",
    "C:\Windows\System32\WinMetadata\Windows.Foundation.winmd",
    "C:\Windows\System32\WinMetadata\Windows.Data.winmd",
    "C:\Windows\System32\WinMetadata\Windows.Storage.winmd",
    "C:\Windows\System32\WinMetadata\Windows.Graphics.winmd"
)

Add-Type -TypeDefinition $code -Language CSharp -ReferencedAssemblies $refAssemblies

foreach ($pdf in $pdfFiles) {
    $outPng = [System.IO.Path]::ChangeExtension($pdf.FullName, ".png")
    Write-Host "Converting $($pdf.Name) to PNG..."
    [PdfRenderer]::ConvertPdfToPng($pdf.FullName, $outPng)
}
Write-Host "Done converting all PDFs."
