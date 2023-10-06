

Function Get-FolderName
{

    param (

        $description
    )

    Add-Type -AssemblyName System.Windows.Forms

    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

    $FolderBrowser.Description = $description 

    $FolderBrowser.ShowDialog()

    #Write-Host ($FolderBrowser.SelectedPath)

    return $FolderBrowser.SelectedPath
}


$source = Get-FolderName "Please Select SOURCE Folder"
$dest = Get-FolderName "Please Select DESTINATION Folder"
Write-Host("Source is", $source, "Destination is", $dest)






