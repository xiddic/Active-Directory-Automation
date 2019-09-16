# Active-Directory-Automation


## sec-srv-auto
Scriptet skapar 2 säkerhetsgrupper i AD för varje windows server.
1 grupp som ger lokal admin på servern.
1 grupp som ger remote rättigheter till servern utan lokal admin.

Fyll i nedan i scriptet:

$logPath - Sökväg till vart loggar skall sparas. <br/>
$logFile = Namn på loggfil ex: "sec-srv-auto.log" <br/>
$domainControllers = Lista varje DC i en variable "DC01.test" , "DC02.test" <br/>
$domainController = Get-Random $doaminControllers <br/>
$SecGroupsToCreate = New-Object System.Collections.Generic.List[System.Object] <br/>
$serverOU =  Distinguished Name för OU där servrar som scriptet ska skapa säkerhetsgrupper för. <br/>
$secGroupOU = Distinguished Name för OU där säkerhetsgrupperna ska placeras. <br/>


Scriptet kombineras med två saker: 

1. GPO
Computer Configuration\Preferences\Windows Settings\Control Panel Settings\Local Users and Groups

Administrator, Action "Update", Members "domain\sec-srv-%COMPUTERNAME%-admin"

Remote Desktop Users, Action "Update", Members "RES-AD\sec-srv-%COMPUTERNAME%-remote"

2. Scheduled task på scriptserver som körs av servicekonto
