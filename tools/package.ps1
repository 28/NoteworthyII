if(-Not ($args[0])) {
    $date = (Get-Date).ToString("ddMMyyy")
    $out_name = "noteworthy_$date.zip"
} else {
    $out_name = $args[0]
}

New-Variable -Name "source_dir" -Value (Resolve-Path '..\').Path -Scope Script -Option Constant
$out = Join-Path -Path (Resolve-Path '..\').Path -ChildPath $out_name

Get-ChildItem $source_dir |
    Where {$_.Name -notmatch "\.zip" -and $_ -notmatch "^\."} |
        Compress-Archive -DestinationPath $out -Update
