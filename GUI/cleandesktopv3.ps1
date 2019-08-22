# Declare global variables to use in multiple functions

$Global:csv_filename = $null
$Global:DesktopPath = [Environment]::GetFolderPath("Desktop")

# Windows Forms for folder/file browsing

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# GUI (made with POSHGUI)

$CLEANDESKTOP                    = New-Object system.Windows.Forms.Form
$CLEANDESKTOP.ClientSize         = '600,600'
$CLEANDESKTOP.BackColor          = '#d8d8d8'
$CLEANDESKTOP.text               = 'CLEANDESKTOP'
$CLEANDESKTOP.StartPosition      = 'CenterScreen'
$CLEANDESKTOP.FormBorderStyle    = 'Fixed3D'
$CLEANDESKTOP.WindowState        = 'Normal'
$CLEANDESKTOP.SizeGripStyle      = 'Hide'
$CLEANDESKTOP.TopMost            = $true
$CLEANDESKTOP.MaximizeBox        = $false
$CLEANDESKTOP.ShowIcon           = $false
$CLEANDESKTOP.Opacity            = 1

$text_csv                        = New-Object system.Windows.Forms.TextBox
$text_csv.multiline              = $false
$text_csv.ReadOnly               = $true
$text_csv.width                  = 460
$text_csv.height                 = 20
$text_csv.Anchor                 = 'top,right,bottom,left'
$text_csv.location               = New-Object System.Drawing.Point(9,33)
$text_csv.Font                   = 'Verdana,10'

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

$label_github                    = New-Object system.Windows.Forms.Label
$label_github.text               = "github.com/raitnigol"
$label_github.AutoSize           = $true
$label_github.width              = 25
$label_github.height             = 10
$label_github.location           = New-Object System.Drawing.Point(335,16)
$label_github.Font               = 'Verdana,10'

$label_extensionscount           = New-Object system.Windows.Forms.Label
$label_extensionscount.text      = "No extensions found!"
$label_extensionscount.AutoSize  = $true
$label_extensionscount.visible   = $false
$label_extensionscount.width     = 225
$label_extensionscount.height    = 103
$label_extensionscount.location  = New-Object System.Drawing.Point(9,570)
$label_extensionscount.Font      = 'Verdana,10'

$CLEANDESKTOP.controls.AddRange(@($text_csv,$label_csv,$button_csv,$select_path,$progressbar,$label_github,$label_extensionscount))

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

        $extn = [IO.Path]::GetExtension($extensionslist)
        if ($extn -eq ".csv")
        {
            $text_csv.Text = $extensionslist
            $Global:csv_filename = $extensionslist
            
            $extensions = Import-CSV -Path $csv_filename
            ForEach ($extension in $extensions)
            {
                $extensionscount += 1
                $label_extensionscount.visible = $true

                if ($progressbar.visible -eq $False)
                {
                    $label_extensionscount.location = '9,570'
                }
                
                else
                {
                    $label_extensionscount.location = '9,550'
                }
                                    
                $label_extensionscount.text = 'Extensions found: ' + $extensionscount
            }
        }
        
        else
        {
            [System.Windows.MessageBox]::Show('File extension is not .csv','File extension must be .csv','Ok','Error')
        }             
    } 
}

function MoveFiles($initialDirectory) 
{
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'

    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }

    if ($csv_filename -eq $null)
    {
        [System.Windows.MessageBox]::Show('No extensions found','No CSV file found for extensions','Ok','Error')
    }

    else
    {
        [void] $FolderBrowserDialog.ShowDialog()

        $Location = $FolderBrowserDialog.SelectedPath

        $progressbar.visible = $true
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

}

# Add controls

$CLEANDESKTOP.Controls.Add($button_csv)
$button_csv.Add_Click({ButtonClick})

$CLEANDESKTOP.Controls.Add($select_path)
$select_path.Add_Click({MoveFiles})

[void]$CLEANDESKTOP.showDialog()
$CLEANDESKTOP.Dispose()