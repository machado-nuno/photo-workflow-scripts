
Function Compare-Files-Hash {
    param (
        $SourceFolder,
        $DestinationFolder
    )

    $str_separator = ","

    $files = Get-ChildItem -Recurse -File $SourceFolder

    Write-Host ("Total source files = ", $files.Count)


    $i=1
    $missing=0
    $notmatch=0
    $match= 0
    $total_files= $files.Count

    Write-Host("Count",$str_separator, "Status`t",$str_separator, "Source Hash`t", $str_separator, "Destination Hash`t", $str_separator, "Source`t", $str_separator, "Destination`t")

    foreach ($file in $files) {


        $d_file = $file
        $d_file.FullName.Replace($SourceFolder, $DestinationFolder)

        $s_hash = Get-FileHash $file.FullName
        
        if (Test-Path $d_file) {
            
            $d_hash = Get-FileHash $d_file

            if ($s_hash.Hash -eq $d_hash.Hash) {
            
                $state= "Match"
                $mcolor = 'Green'
                $match++
            }
            else {
                
                $state= "MisMatch"
                $mcolor = 'DarkRed'
                $notmatch++
            }

            Write-Host($i,"of",$total_files, $str_separator, $state, $str_separator, $s_hash.Hash, $str_separator, $d_hash.Hash, $str_separator, $file.FullName, $str_separator, $d_file) -ForegroundColor $mcolor

        }
        else {

            Write-Host($i,"of",$total_files, $str_separator, "Missing", $str_separator, $s_hash.Hash, $str_separator, "missing", $str_separator, $file.FullName, $str_separator, "missing") -ForegroundColor DarkRed
            $missing++
        }

        $i++
    }

    Write-Host ("Summary stats")
    Write-Host ("Identical Files=", $match)
    Write-Host ("Diferent Files =", $notmatch)
    Write-Host ("Missing Files  =", $missing)
    Write-Host ("Total          =", $total_files)


}



Function Get-FolderName
{

    param (

        $description
    )

    Add-Type -AssemblyName System.Windows.Forms

    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

    $FolderBrowser.Description = $description 

    $caller = [System.Windows.Forms.NativeWindow]::new()
    $caller.AssignHandle([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)


    $FolderBrowser.ShowDialog($caller)
    if ($FolderBrowser.ShowDialog() -eq "Cancel") {break}

    #Write-Host ($FolderBrowser.SelectedPath)
    
    return $FolderBrowser.SelectedPath
}

function showUsage {
 
    
    Write-Host("Usage:")
    Write-Host("    check-folder SOURCE DESTINATION")
    Write-Host("")
}




if ($args.Count -lt 2) {
    
    #$source = Get-FolderName "Please Select SOURCE Folder"
    #$dest = Get-FolderName "Please Select DESTINATION Folder"   
    showUsage
    exit

}

$source = $args[0]
$dest = $args[1]

Write-Host("check-folder: Folder compare tool based on file hash")
$found = Test-Path -Path $source
Write-Host("SOURCE:", $source, "FOUND:", $found)
if (! $found) {
    Write-Host("Aborting...source folder does not exist!")
    exit -1
} 

$found = Test-Path -Path $dest
Write-Host("DESTINATION:", $dest, "FOUND:", $found)
if (! $found) {
    Write-Host("Aborting...Destination folder does not exist!")
    exit -1
} 

Write-Host("Comparing folders - source: ", $source, " destination:", $dest)

Compare-Files-Hash($source, $dest)








