Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates\Copy of MEDVA_s Onboarding Course - MEDVA Training Courses.png"
$img = [System.Drawing.Image]::FromFile($srcPath)

$cropY = [int]($img.Height * 0.05)
$cropW = $img.Width
$cropH = [int]($img.Height * 0.88)

$bmp = New-Object System.Drawing.Bitmap($cropW, $cropH)
$g = [System.Drawing.Graphics]::FromImage($bmp)

$srcRect = New-Object System.Drawing.Rectangle(0, $cropY, $cropW, $cropH)
$destRect = New-Object System.Drawing.Rectangle(0, 0, $cropW, $cropH)

$g.DrawImage($img, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

$g.Dispose()
$img.Dispose()

$bmp.Save($srcPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Trimmed top/bottom header/footer"
