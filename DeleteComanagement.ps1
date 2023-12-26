$ccmSetupPath = "C:\Windows\ccmsetup"

if(Test-Path $ccmSetupPath) {

    Write-Output "Uninstalling SCCM client"

    $uninstallCommand = "$ccmSetupPath\ccmsetup.exe /uninstall"

    Invoke-Expression $uninstallCommand
 
    # Stop the Service "SMS Agent Host" which is a Process "CcmExec.exe"

    Get-Service -Name CcmExec -ErrorAction SilentlyContinue | Stop-Service -Force -Verbose
 
    # Stop the Service "ccmsetup" which is also a Process "ccmsetup.exe" if it wasn't stopped in the services after uninstall

    Get-Service -Name ccmsetup -ErrorAction SilentlyContinue | Stop-Service -Force -Verbose
 
    # Delete the folder of the SCCM Client installation: "C:\Windows\CCM"

    Remove-Item -Path "$($Env:WinDir)\CCM" -Force -Recurse -Confirm:$false -Verbose
 
    # Delete the folder of the SCCM Client Cache of all the packages and Applications that were downloaded and installed on the Computer: "C:\Windows\ccmcache"

    Remove-Item -Path "$($Env:WinDir)\CCMSetup" -Force -Recurse -Confirm:$false -Verbose
 
    # Delete the folder of the SCCM Client Setup files that were used to install the client: "C:\Windows\ccmsetup"

    Remove-Item -Path "$($Env:WinDir)\CCMCache" -Force -Recurse -Confirm:$false -Verbose
 
    # Delete the file with the certificate GUID and SMS GUID that current Client was registered with

    Remove-Item -Path "$($Env:WinDir)\smscfg.ini" -Force -Confirm:$false -Verbose
 
    # Delete the certificate itself

    Remove-Item -Path 'HKLM:\Software\Microsoft\SystemCertificates\SMS\Certificates\*' -Force -Confirm:$false -Verbose
 
    # Remove all the registry keys associated with the SCCM Client that might not be removed by ccmsetup.exe

    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\CCM' -Force -Recurse -Verbose

    Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\CCM' -Force -Recurse -Confirm:$false -Verbose

    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\SMS' -Force -Recurse -Confirm:$false -Verbose

    Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\SMS' -Force -Recurse -Confirm:$false -Verbose

    Remove-Item -Path 'HKLM:\Software\Microsoft\CCMSetup' -Force -Recurse -Confirm:$false -Verbose

    Remove-Item -Path 'HKLM:\Software\Wow6432Node\Microsoft\CCMSetup' -Force -Confirm:$false -Recurse -Verbose

    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\DeviceManageabilityCSP' -Force -Recurse -Confirm:$false -Verbose
 
    # Remove the service from "Services"

    Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\CcmExec' -Force -Recurse -Confirm:$false -Verbose

    Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\ccmsetup' -Force -Recurse -Confirm:$false -Verbose
 
    # Remove the Namespaces from the WMI repository

    Get-CimInstance -query "Select * From __Namespace Where Name='CCM'" -Namespace "root" | Remove-CimInstance -Verbose -Confirm:$false

    Get-CimInstance -query "Select * From __Namespace Where Name='CCMVDI'" -Namespace "root" | Remove-CimInstance -Verbose -Confirm:$false

    Get-CimInstance -query "Select * From __Namespace Where Name='SmsDm'" -Namespace "root" | Remove-CimInstance -Verbose -Confirm:$false

    Get-CimInstance -query "Select * From __Namespace Where Name='sms'" -Namespace "root\cimv2" | Remove-CimInstance -Verbose -Confirm:$false

} else {

    Write-Output "SCCM client is not installed on this device"

}
