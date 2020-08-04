if(-Not ($args[0])) {
    $date = (Get-Date).ToString("ddMMyyyHHmmss")
    $out_name = "NoteworthyII_$date.zip"
} else {
    $ver = $args[0]
    $out_name = "NoteworthyII-v$ver.zip"
}

New-Variable -Name "source_dir" -Value (Resolve-Path '..\').Path -Scope Script -Option Constant
$out = Join-Path -Path (Resolve-Path '..\').Path -ChildPath $out_name

$temp_dir = New-Item -Path ".\" -Name "NoteworthyII" -ItemType Directory

Get-ChildItem $source_dir -Recurse |
    Where-Object {$_.FullName -notmatch "\.md|\.zip|tools|doc|\.gitignore|Interface|\.idea"} |
	ForEach-Object {
	    Copy-Item $_.FullName -Destination ($temp_dir.FullName + $_.FullName.Substring($source_dir.Length)) -Force
	}

Compress-Archive $temp_dir -DestinationPath $out

Remove-Item $temp_dir -Recurse -Force

Write-Host "Created archive '$out'."
