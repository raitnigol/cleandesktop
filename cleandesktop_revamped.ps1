# i comment the code so much because i cant fucking remember what something does after 2 weeks
# get accepted extensions
$AcceptedExtensions = '.png', '.svg', '.jpg', '.jpeg', '.webp'
# get the desktop location of currently signed in user
$DesktopPath = [Environment]::GetFolderPath('Desktop')

# get the current date for folder name
$FolderName = Get-Date -Format 'dddd-MM_dd_yyyy-HH_mm_ss'

# make a folder on the desktop containing the files
New-Item -Path $DesktopPath -Name $FolderName -ItemType Directory

# get all files on desktop, but only keep extensions
$Files = (Get-ChildItem -File -Path $DesktopPath).Extension |
    # sort objects for better understanding when changing code or debugging
    Sort-Object |
    # get only unique extensions, because we move all files matching the extension once, it would create errors because the files would be gone
    Get-Unique |
    ForEach-Object {
        if ($AcceptedExtensions -Contains $_) {
            # add wildcard (*) as file name, so we can actually move the files, we cant do shit with extension only
            $MovableFile = $($DesktopPath + "\" + '*' + $_)
            # destination folder and file, where we move it
            $DestinationFolder = $($DesktopPath + '\' + $FolderName)
            # finally move the items
            Move-Item -Path $MovableFile -Destination $DestinationFolder
        }
    }