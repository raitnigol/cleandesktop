# Declare global variables to use in multiple functions

$Global:csv_filename = $null
$Global:DesktopPath = [Environment]::GetFolderPath("Desktop")

# Windows Forms for folder/file browsing

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# GUI (made with POSHGUI)

$CLEANDESKTOP                    = New-Object system.Windows.Forms.Form
$CLEANDESKTOP.ClientSize         = '600,600'
$CLEANDESKTOP.text               = "CLEANDESKTOP"
$CLEANDESKTOP.BackColor          = "#d8d8d8"
$CLEANDESKTOP.TopMost            = $true
$CLEANDESKTOP.StartPosition      = 'CenterScreen'
$CLEANDESKTOP.FormBorderStyle    = 'Fixed3D'
$CLEANDESKTOP.MaximizeBox        = $false

$text_csv                        = New-Object system.Windows.Forms.TextBox
$text_csv.multiline              = $false
$text_csv.ReadOnly               = $true
$text_csv.width                  = 460
$text_csv.height                 = 20
$text_csv.Anchor                 = 'top,right,bottom,left'
$text_csv.location               = New-Object System.Drawing.Point(9,33)
$text_csv.Font                   = 'Microsoft Sans Serif,10'

$label_csv                       = New-Object system.Windows.Forms.Label
$label_csv.text                  = "Path to CSV:"
$label_csv.AutoSize              = $true
$label_csv.width                 = 25
$label_csv.height                = 10
$label_csv.location              = New-Object System.Drawing.Point(10,16)
$label_csv.Font                  = 'Verdana,10'

$button_csv                      = New-Object system.Windows.Forms.Button
$button_csv.text                 = "Select File"
$button_csv.width                = 110
$button_csv.height               = 22
$button_csv.Anchor               = 'top,right,bottom,left'
$button_csv.location             = New-Object System.Drawing.Point(480,33)
$button_csv.Font                 = 'Verdana,10'

$select_path                     = New-Object system.Windows.Forms.Button
$select_path.text                = "Move Files"
$select_path.width               = 100
$select_path.height              = 22
$select_path.Anchor              = 'top,right,bottom,left'
$select_path.location            = New-Object System.Drawing.Point(10,66)
$select_path.Font                = 'Verdana,10'

$progressbar                     = New-Object system.Windows.Forms.ProgressBar
$progressbar.width               = 580
$progressbar.height              = 20
$progressbar.value               = 0
$progressbar.Anchor              = 'top,right,left'
$progressbar.location            = New-Object System.Drawing.Point(10,570)
$progressbar.visible             = $false

$CLEANDESKTOP.controls.AddRange(@($text_csv,$label_csv,$button_csv,$select_path,$progressbar))

# Functions

function ButtonClick() 
{
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter = "CSV files (*csv)|*.csv|All files(*.*)|*.*"
    }

    $OpenDialog = $FileBrowser.ShowDialog()

    if ($OpenDialog -eq "OK") 
    {
        $extensionslist = $FileBrowser.FileName
        $text_csv.Text = $extensionslist

        $Global:csv_filename = $extensionslist
        
    }
    
}

function MoveFiles($initialDirectory) 
{
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'

    If ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()

    $progressbar.visible = $true

    $Location = $FolderBrowserDialog.SelectedPath

    $extensions = Import-CSV -Path $csv_filename

    ForEach ($extension in $extensions)
    {
        $totalextensions += 1
        $i = 0

        For ($i=0; $i -lt $totalextensions; $i++) 
        {
            $progressbar.value = [int]($i / $totalextensions) * 100
        }

        $enabledext = $($extension.extensions)
        $move_extension = $("$DesktopPath\*.$enabledext")
        
        Move-Item -Path $move_extension -Destination $Location
    }

}

# Add controls

$CLEANDESKTOP.Controls.Add($button_csv)
$button_csv.Add_Click({ButtonClick})

$CLEANDESKTOP.Controls.Add($select_path)
$select_path.Add_Click({MoveFiles})

$CLEANDESKTOP.showDialog()