$disks = Get-Disk | Where-Object { $_.Number -ne 0 -and $_.PartitionStyle -eq 'RAW' }

foreach ($disk in $disks) {
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT
    $partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
    Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel "DataDisk" -Confirm:$false
    Write-Host "Disk $($disk.Number) has been partitioned and formatted."
}

write-host "TEST" | out-file -path "C:\TEST.txt"