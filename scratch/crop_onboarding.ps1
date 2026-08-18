Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\Mark Samia\OneDrive\Desktop\Codes-html\medva\assets\Certificates\Copy of MEDVA_s Onboarding Course - MEDVA Training Courses.png"
$img = [System.Drawing.Image]::FromFile($srcPath)

# The certificate content is in the top-left area (~71% width, 75% height)
$cropW = [int]($img.Width * 0.71)
$cropH = [int]($img.Height * 0.76)

$bmp = New-Object System.Drawing.Bitmap($cropW, $cropH)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$srcRect = New-Object System.Drawing.Rectangle(0, 0, $cropW, $cropH)
$destRect = New-Object System.Drawing.Rectangle(0, 0, $cropW, $cropH)

$g.DrawImage($img, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

$g.Dispose()
$img.Dispose()

$bmp.Save($srcPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Successfully cropped onboarding certificate PNG"
