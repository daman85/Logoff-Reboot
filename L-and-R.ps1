#you need to add remote workstations to trusted hosts forst if they are not on same domain 
#>winrm set winrm/config/client '@{TrustedHosts="<hostname>"}'
#to bad this wont work if winrm service is not runing


$server = "server"
$logfile = "RebootServer.log"
$timestamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$body = "Logingoff users."
$line = "$timestamp $body"
add-content $Logfile -Value $line


function Longentry($Message){
    $timestamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $line = "$timestamp $Message"
    add-content $logfile -Value $line
}




$logoffVal = Invoke-CimMethod -ClassName Win32_Operatingsystem -ComputerName $server -MethodName Win32Shutdown -Arguments @{ Flags = 0 }
Write-Host "Return val: " $logoffVal.ReturnValue



if (!$logoffVal){
    longentry("Logoff return vaule was null.")
    Start-Sleep -s 600
    $rebootVal = Invoke-CimMethod -ClassName Win32_Operatingsystem -ComputerName $server -MethodName Win32Shutdown -Arguments @{ Flags = 2 }
    if (!$rebootVal){
        longentry("Reboot return vaule was null.")

    }
    elseif($rebootVal.ReturnValue -eq(0)){
        longentry("Reboot was successfull.")
    }
    else{
       longentry("Reboot failed. $rebootVal.ReturnValue ") 
    }

} 
elseif($logoffVal.ReturnValue -eq(0)){
    longentry("Logoff was successfull.")
    Start-Sleep -s 600
    $rebootVal = Invoke-CimMethod -ClassName Win32_Operatingsystem -ComputerName 192.168.4.91 -MethodName Win32Shutdown -Arguments @{ Flags = 2 }
    if (!$rebootVal){
        longentry("Reboot return vaule was null.")

    }
    elseif($rebootVal.ReturnValue -eq(0)){
        longentry("Reboot was successfull.")
    }
    else{
       longentry("Reboot failed. $rebootVal") 
    }

}
else{
    longentry("Logoff failed. $logoffVal.ReturnValue")
}
