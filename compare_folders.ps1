
# Just Testing

$source = 'C:\Temp\source'
$destination


$files = Get-ChildItem -Recurse -File $source

Measure-Object $files

Write-Host ("Total source files = ", $files.Count)

$i=1
foreach ($file in $files) {

    $hash = Get-FileHash $file.FullName

    Write-Host $i "of" $files.Count $hash.Hash $file.FullName
    $i++

}

