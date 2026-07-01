$srcDir = "C:\Users\khayx\.gemini\antigravity-ide\brain\9de5aa3a-645c-41bb-84f1-1473773bde8c"
$destDocs = "c:\MyKampung_System\MyKampung_V2\docs"
$destWebImg = "c:\MyKampung_System\MyKampung_V2\web\assets\img"

# Ensure destination directories exist
if (!(Test-Path $destDocs)) { New-Item -ItemType Directory -Force -Path $destDocs }
if (!(Test-Path $destWebImg)) { New-Item -ItemType Directory -Force -Path $destWebImg }

$files = Get-ChildItem -Path $srcDir -Filter *.png
foreach ($file in $files) {
    $name = $file.Name
    if ($name -like "*signature_demo*") { $target = "signature_demo.png" }
    elseif ($name -like "*stamp_demo*") { $target = "stamp_demo.png" }
    elseif ($name -like "*aduan_lampu_jalan*") { $target = "aduan_lampu_jalan.png" }
    elseif ($name -like "*aduan_jalan_berlubang*") { $target = "aduan_jalan_berlubang.png" }
    else { continue }

    Copy-Item -Path $file.FullName -Destination (Join-Path $destDocs $target) -Force
    Copy-Item -Path $file.FullName -Destination (Join-Path $destWebImg $target) -Force
    Write-Host "Berjaya menyalin: $target"
}
Write-Host "`nSemua imej demo telah berjaya disalin!"
Read-Host -Prompt "Tekan Enter untuk keluar"
