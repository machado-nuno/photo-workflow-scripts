
$cLogFile = 'C:\Temp\log.log'
$source = 'C:\Temp\source'
$destination = 'C:\Temp\dest'
$str_separator = ","



$files = Get-ChildItem -Recurse -File $source

Write-Host ("Total source files = ", $files.Count)


$i=1
$missing=0
$notmatch=0
$match= 0
$total_files= $files.Count

Write-Host("Count",$str_separator, "Status`t",$str_separator, "Source Hash`t", $str_separator, "Destination Hash`t", $str_separator, "Source`t", $str_separator, "Destination`t")

foreach ($file in $files) {

 
    $d_file = $file.FullName.Replace($source, $destination)

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



return $i


$i=1
$counter_ok = 0
$counter_nok = 0

foreach ($file in $files) {

    $hash = Get-FileHash $file.FullName

    $dest_file = $destination+ '\'+ $file.Name
    
    if (Test-Path $dest_file) {
        Write-Host "File exists in destination"

        $dest_hash = Get-FileHash $dest_file

        if ($hash.hash -eq $dest_hash.hash) {
            Write-Host "OK" $dest_file
            $counter_ok++

        } 
        else {
            Write-Host "NOK" $hash.hash $dest_hash.Hash
            $counter_nok++
        }
    } 
    else {
        
        Write-Host ('File ' +$file.Name+ " does not exist in destination")
        $counter_nok++

    }
}
