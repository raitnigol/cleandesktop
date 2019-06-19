# find the desktop path
$DesktopPath = [Environment]::GetFolderPath("Desktop")

# ask for folder name
$date = Get-Date -UFormat "%Y.%m.%d-(%H_%M)"
$folder = Read-Host -Prompt "What do you want the folder name to be?"
$foldername = $($folder+$date)

Write-Host "Creating a directory called $foldername"
$folder = New-Item -Path "$DesktopPath" -Name "$foldername" -ItemType "directory"
Write-Host "Folder '$foldername' created."

Sleep -Seconds 1

Write-Host ""
Write-Host -BackgroundColor Red "Starting to move items to folder $foldername"

Move-Item -Path $DesktopPath\*.png -Destination $folder
Move-Item -Path $DesktopPath\*.txt -Destination $folder
Move-Item -Path $DesktopPath\*.veg -Destination $folder
Move-Item -Path $DesktopPath\*.dll -Destination $folder
Move-Item -Path $DesktopPath\*.sql -Destination $folder
Move-Item -Path $DesktopPath\*.png -Destination $folder
Move-Item -Path $DesktopPath\*.lua -Destination $folder
Move-Item -Path $DesktopPath\*.jpg -Destination $folder
Move-Item -Path $DesktopPath\*.gif -Destination $folder
Move-Item -Path $DesktopPath\*.html -Destination $folder
Move-Item -Path $DesktopPath\*.xml -Destination $folder

Write-Host "All files moved"
exit