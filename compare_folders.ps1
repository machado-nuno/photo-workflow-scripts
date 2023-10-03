
$cLogFile = 'C:\Temp\log.log'
$source = 'C:\Temp\source'
$destination = 'C:\Temp\dest'
$str_separator = ","



$files = Get-ChildItem -Recurse -File $source

Write-Host ("Total source files = ", $files.Count)


$i=1

Write-Host("Count",$str_separator, "Status`t",$str_separator, "Source Hash`t", $str_separator, "Destination Hash`t", $str_separator, "Source`t", $str_separator, "Destination`t")

foreach ($file in $files) {

 
    $d_file = $file.FullName.Replace($source, $destination)

    $s_hash = Get-FileHash $file.FullName
    
    if (Test-Path $d_file) {
        
        $d_hash = Get-FileHash $d_file

        if ($s_hash.Hash -eq $d_hash.Hash) {
           
            $state= "OK"
            $mcolor = 'Green'
        }
        else {
            
            $state= "NOK"
            $mcolor = 'DarkRed'
        }

        Write-Host($i,"of",$files.Count, $str_separator, $state, $str_separator, $s_hash.Hash, $str_separator, $d_hash.Hash, $str_separator, $file.FullName, $str_separator, $d_file) -ForegroundColor $mcolor

    }
    else {

        Write-Host($i,"of",$files.Count, $str_separator, "Missing", $str_separator, $s_hash.Hash, $str_separator, "missing", $str_separator, $file.FullName, $str_separator, "missing") -ForegroundColor DarkRed

    }

    $i++
}


return $i
