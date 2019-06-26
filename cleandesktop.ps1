<# 
.SYNOPSIS
    Description on how this script works.
.DESCRIPTION
    This script was made for personal use. If you have very many files sitting on your
    desktop, you can move them into a folder easily.
.NOTES
    File Name       : cleandesktop.ps1
    Author          : Rait Nigol (rait.nigol@khk.ee)
    Prerequisites   : Powershell V2
    Copyright 2019  - Rait Nigol/Tartu Kutsehariduskeskus
.LINK
    This script is uploaded to my github repository:
    https://github.com/raitnigol/cleandesktop
.EXAMPLE
    There is a CSV file in the directory. The CSV file allows you to choose file extensions
    you would like to move.
#>

# ask for CSV file containing extension types
$extensionslist = Read-Host -Prompt "Please insert the path to your CSV file: "

# check if the path is correct and file exists then proceed
$pathtest = [IO.Path]::GetExtension($extensionslist)
if ($pathtest -eq ".csv") {
    Write-Host -BackgroundColor Green "Path extension = $pathtest"; Write-Host ""; sleep -s 1
    Write-Host "File path looks correct, checking if file exists."
    $file_exists = Test-Path $extensionslist
    if ($file_exists -eq $False) {
        Write-Host -BackgroundColor Red "File does not exist. Please try again."
        exit
        }
    else {
        Write-Host -BackgroundColor Green "Given file exists."; Write-Host ""
    }
}

# (onerror) print out the errors user has
else {
    Write-Host -BackgroundColor Red "Something looks off. Please try again."; sleep -s 1; Write-Host ""
    Write-Host -BackgroundColor Red "========== WHAT WENT WRONG? ========="

    $extension_on_error = [string]::IsNullOrEmpty($pathtest)
    if ($extension_on_error -eq $True) {
        $pathtest = "there was no path"
        }

    Write-Host "1. The path you provided: $extensionslist"
    Write-Host "2. Current file extension: $pathtest"

    if ($file_exists -eq $True) { Write-Host -BackgroundColor Green "Does the provided file even exist: $file_exists" }
    else { Write-Host -BackgroundColor Red "4. Does the provided file even exist: $file_exists" }

    Write-Host ""; Write-Host -BackgroundColor Green "==========NOTES=========="
    Write-Host "The file extension should be .csv"
    Write-Host "The path '$extensionslist' is wrong or does not exist"
    exit
    }

# find the desktop path
$DesktopPath = [Environment]::GetFolderPath("Desktop")
Write-Host "Your desktop path is $DesktopPath"; sleep -s 1

# ask for folder name
$date = Get-Date -UFormat "%Y.%m.%d-(%H_%M)"
$folder = Read-Host -Prompt "What do you want the folder name to be?"
$foldername = $($folder+$date)

# create the direcotry
Write-Host "Creating a directory called $foldername"
$folder = New-Item -Path "$DesktopPath" -Name "$foldername" -ItemType "directory"
Write-Host "Folder '$foldername' created."

sleep -s 1

Write-Host ""
Write-Host -BackgroundColor Red "Starting to move items to folder $foldername"

# get file extensions to copy from CSV file
$CSV_forextensions = Import-CSV -Path $extensionslist
ForEach ($extension in $CSV_forextensions) {
    $enabledext = $($extension.extensions)
    $moveto = $("$DesktopPath\*.$enabledext")
    Move-Item -Path $moveto -Destination $folder
    }

Write-Host "All files moved. It might take some time."