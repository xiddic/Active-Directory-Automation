#Variables
$logPath = "C:\Scripts\active-directory\sec-srv-auto\logs\"
$logFile = "sec-srv-auto.log"
$domainControllers = "DC01.test" , "DC02.test", "DC03.test"
$domainController = Get-Random $doaminControllers

#Create container array for server names.
$SecGroupsToCreate = New-Object System.Collections.Generic.List[System.Object]
$serverOU = "OU=Servers,DC=testdomain,DC=local"
$secGroupOU = "OU=Server,OU=Security,OU=Groups,DC=testdomain,DC=local"


#Test if log path exists, else creates it
if(!(Test-Path -Path $logPath)){
new-item -Path $logPath -ItemType Directory
}

#Included in the script, should be external
Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String]
    $Level = "INFO",

    [Parameter(Mandatory=$True)]
    [string]
    $Message,

    [Parameter(Mandatory=$False)]
    [string]
    $logfile
    )

    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $Line = "$Stamp $Level $Message"
    If($logfile) {
        Add-Content $logfile -Value $Line -Encoding UTF8
    }
    Else {
        Write-Output $Line
    }
}

#Searchbase for servers
$serverList = Get-ADComputer -filter {OperatingSystem -like "Windows Server*"} -SearchBase $serverOU -Properties Name | select Name

foreach ($Server in $ServerList){
$ServerAdmin = "sec-srv-$($Server.name)-admin".ToLower()
$ServerUser = "sec-srv-$($Server.name)-remote".ToLower()


try {
Get-ADGroup -Identity $ServerAdmin

}catch{
New-ADGroup -Path $secGroupOU -Name $ServerAdmin -GroupCategory Security -GroupScope Global -Description "Local admin på server $($Server.name)" -OtherAttributes @{'info'="Scripted Group"}  -Server $domainController
write-log -Message "Skapat grupp för $ServerAdmin" -logfile "$($LogPath)$($LogFile)"
}

try {
Get-ADGroup -Identity $ServerUser

}catch{
New-ADGroup -Path $secGroupOU -Name $ServerUser -GroupCategory Security -GroupScope Global -Description "Enbart RDP rättighet till $($Server.name)" -OtherAttributes @{'info'="Scripted Group"} -Server $domainController
write-log -Message "Skapat grupp för $ServerUser" -logfile "$($LogPath)$($LogFile)"
}
}