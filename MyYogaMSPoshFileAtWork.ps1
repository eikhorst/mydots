cp $profile c:\git\repos\mynotes\current\MyYogaMSPoshFileAtWork.ps1
$hostfile = "c:\windows\system32\drivers\etc\hosts"
#New-Alias "?:" IfTrue
if(test-path "C:\Program Files (x86)\Git\bin"){
  $env:Path = $env:Path + ";C:\Program Files (x86)\Git\bin"
}
set-alias livetail c:\tools\tailclient-1.0.1-install\tailclient-1.0.1\bin\livetail.bat
function scheck { &"\\cp-fs1\dev\SitecoreAutomation\Sitecore.Serialization.Checker\Sitecore.Serialization.Checker.exe" $args }

#Get relative path
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.MyCommand.Path
$script_name = $invocation.MyCommand

write-host "invoke path: " $invocation
write-host "directorypath path: " $directorypath
write-host "script_name path: " $script_name


Import-Module MSOnline
 function Connect-ExchangeOnline
 {
	 $O365Cred = Get-Credential
	 $O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $O365Cred -Authentication Basic -AllowRedirection
	 Import-PSSession $O365Session
	 Connect-MsolService -Credential $O365Cred
 }
 function Disconnect-ExchangeOnline
 {
	Remove-PSSession -Session $O365Session
 }
function subl { &"${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" $args }

#function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

Function Add-Help
{
 $helpText = @"
<#
   .Synopsis
    This does that
   .Example
    Example-
    Example- accomplishes
   .Parameter
    The parameter
   .Notes
    NAME: Example-
    AUTHOR: $env:username
    LASTEDIT: $(Get-Date)
    KEYWORDS:
#Requires -Version 2.0
#>
"@
 $helpText | clip
} #end function add-help
set-alias pleh Add-Help
function MakeLinksForSitecoreSitesNode()
{
  $onienvs = @("onilive.com","onistaged.com","oniqa.com")
  $dom = Read-host -prompt "enter your domain like so: www.domain.com"
  $domdashes = $dom -replace '\.','-'
  $dommiddlename = ($dom -split '\.')[1]
  $mid = $dommiddlename.length/2
  write-host $mid
  #$domadmin = ?: ($dommiddlename.length -gt 4) $dommiddlename.Insert(5,'-') $dommiddlename.Insert(2,'-')
  $domadmin = $dommiddlename.Insert($mid,'-')
  $fulladmin = "$($dommiddlename).admin.local.com"
  Write-Host "`n`nUrls generated for { $dom  and  $fulladmin } `n`n"
  Write-Host " >>> Sitecore OD [Variable]ONI.AppConfigInclude, [Step]Sitecore Installation IIS bindings <<< `n"
  $onienvs | %{Write-Host "[ $($_) ]`r" ;Write-Host "$($domdashes)-01.server.$($_) | $($domdashes)-02.server.$($_) | $($domdashes).$($_) | $($dommiddlename).admin.local.com | $($domadmin).admin.local.com`n`n" -f Red}
  Write-Host "[ WAF CD content rule ]"
  $onienvs | %{$rule += " ( Header Host eq $($domdashes).$($_) ) || " }
  $rule = $rule.substring(0,$rule.Length-3)
  Write-Host "`n$rule`n" -f Blue
  $rule = $null
  Write-Host "[ WAF CM content rule ]"
  $onienvs | %{$rule += "( Header Host eq $($domdashes -replace "www-", "admin-").$($_) ) || " }
  $rule += "( $($domadmin).admin.local.com )"
  #$rule = $rule.substring(0,$rule.Length-3)
  Write-Host "`n$rule`n" -f Green

  Write-host "`n--> Put this in to the Launch Spreadsheet"
  $onienvs |?{$_ -match "live"} |%{Write-Host "$($domdashes)-01.server.$($_)`n$($domdashes)-02.server.$($_)`n$($domdashes).$($_)`n$($domadmin).admin.local.com`n`n" -f Yellow}

  Write-host "`n--> VM names"
  $client = $dommiddlename.substring(0,3)
  $num = 1..2
  $numservers = Read-Host "Is this a (2) or (3) server license?"
  $license = "b"
  $pattern = "ap-sc$($license)-$($client)-0"
  if($numservers -eq 3)
  {
    $license = "m"
  }
  if($license -eq "b"){
      Write-host "This is a 2 server scenario. Your VMs are named:`r`n"
       $num | %{write-host "$($pattern)$($_)"}
  }
  elseif($license -eq "m"){
      Write-host "This is a 3 server scenario. Your VMs are named:`r`n"
      Write-host "ap-scm-$($client)-01"
      $license = "d"; $pattern = "ap-sc$($license)-$($client)-0"
      $num | %{write-host "$($pattern)$($_)"}
      Write-host "`r`n"
  }
}

set-alias salad MakeLinksForSitecoreSitesNode
set-alias scbindings MakeLinksForSitecoreSitesNode


function ScriptTemp
{
$text = @"
#*******************************************************************
# Global Variables
#*******************************************************************
`$Script:Version      = '1.0.0.0'
`$Script:LogSeparator = '*******************************************************************************'
`$Script:LogFile      = ""

#*******************************************************************
# Functions
#*******************************************************************
function Get-ScriptName(){
#
#    .SYNOPSIS
#        Extracts the script name
#    .DESCRIPTION
#        Extracts the script file name without extention
#    .NOTES
#    Author:    Dinh Tran, dtran@local.com
#
`$tmp = `$MyInvocation.ScriptName.Substring(`$MyInvocation.ScriptName.LastIndexOf('\') + 1)
`$tmp.Substring(0,`$tmp.Length - 4)
}
function Write-Log(`$Msg, [System.Boolean]`$LogTime=`$true){
#
#    .SYNOPSIS
#        Creates a log entry
#    .DESCRIPTION
#        By default a time stamp will be logged too. This can be
#        disabled with the -LogTime `$false parameter
#    .NOTES
#    Author:    Dinh Tran, dtran@local.com
#    .EXAMPLE
#        Write-Log -Msg 'Log entry created successfull.' [-LogTime `$false]
#
if(`$LogTime)
{
    `$date = Get-Date -format dd.MM.yyyy
    `$time = Get-Date -format HH:mm:ss
 Add-Content -Path `$LogFile -Value (`$date + " " + `$time + "   " + `$Msg)
}
else{
    Add-Content -Path `$LogFile -Value `$Msg
}
}
function Initialize-LogFile(`$File, [System.Boolean]`$reset=`$false){
#
#    .SYNOPSIS
#        Initializes the log file
#    .DESCRIPTION
#    Creates the log file header
#        Creates the folder structure on local drives if necessary
#        Resets existing log if used with -reset `$true
#    .NOTES
#    Author:    Dinh Tran, dtran@local.com
#    .EXAMPLE
#        Initialize-LogFile -File 'C:\Logging\events.log' [-reset `$true]
#
try{
    #Check if file exists
        if(Test-Path -Path `$File){
      #Check if file should be reset
            if(`$reset){
                Clear-Content `$File -ErrorAction SilentlyContinue
            }
      }
    else{
      #Check if file is a local file
            if(`$File.Substring(1,1) -eq ':'){
        #Check if drive exists
                `$driveInfo = [System.IO.DriveInfo](`$File)
        if(`$driveInfo.IsReady -eq `$false){
          Write-Log -Msg (`$driveInfo.Name + " not ready.")
        }

                #Create folder structure if necessary
          `$Dir = [System.IO.Path]::GetDirectoryName(`$File)
          if(([System.IO.Directory]::Exists(`$Dir)) -eq `$false){
            `$objDir = [System.IO.Directory]::CreateDirectory(`$Dir)
            Write-Log -Msg (`$Dir + " created.")
          }
            }
    }
        #Write header
        Write-Log -LogTime `$false -Msg `$LogSeparator
        Write-Log -LogTime `$false -Msg (((Get-ScriptName).PadRight(`$LogSeparator.Length - ("   Version " + `$Version).Length," ")) + "   Version " + `$Version)
        Write-Log -LogTime `$false -Msg `$LogSeparator
  }
  catch{
    Write-Log -Msg `$_
  }
}
function Read-Arguments(`$Values = `$args) {
#
#    .SYNOPSIS
#        Reads named script arguments
#    .DESCRIPTION
#        Reads named script arguments separated by '=' and tagged with'-' character
#    .NOTES
#    Author:    Dinh Tran, dtran@local.com
#
    foreach(`$value in `$Values){

    #Change the character that separates the arguments here
        `$arrTmp = `$value.Split("=")

        switch (`$arrTmp[0].ToLower()) {
      -log {
                `$Script:LogFile = `$arrTmp[1]
            }
        }
    }
}

#*******************************************************************
# Main Script
#*******************************************************************
if(`$args.Count -ne 0){
  #Read script arguments
  Read-Arguments
  if(`$LogFile.StartsWith("\\")){
    Write-Host "UNC"
  }
  elseif(`$LogFile.Substring(1,1) -eq ":"){
    Write-Host "Local"
  }
  else{
    `$LogFile = [System.IO.Path]::Combine((Get-Location), `$LogFile)
  }

  if(`$LogFile.EndsWith(".log") -eq `$false){
    `$LogFile += ".log"
  }
}

if(`$LogFile -eq ""){
  #Set log file
  `$LogFile = [System.IO.Path]::Combine((Get-Location), (Get-ScriptName) + ".log")
}

#Write log header
Initialize-LogFile -File `$LogFile -reset `$false



#///////////////////////////////////
#/// Enter your script code here ///
#/// run this also
#///////////////////////////////////
`$body = @()
`$body +=`
`$date = get-date -f "yy-MM-dd:hh:mm:ss";
write-output "`n`n"
write-output "Title Shown in the log"



Write-Log -Logtime `$true -Msg `$body
Write-Log -LogTime `$false -Msg `$LogSeparator
Write-Log -LogTime `$false -Msg ''

}
"@
$text | clip
}
set-alias stemp ScriptTemp


Function Add-Nuspec
{
<#
   .Synopsis
    This function generates the nuspec file for creating nuget packages for Sitecore Projects
    for One North's Octopus Deployment process. It will create the nuspec file with the correct title
    for the nuget package and the correct lib or resources directory
   .Example
    cd to the directory where the project's sln file is, call this function by name or nusp
   .Parameter
    no params for now
   .Notes
    NAME: Add-Nuspec
    AUTHOR: dtran
    LASTEDIT: 03/13/2016 23:03:43
    KEYWORDS:
#Requires -Version 2.0
#>

$global:libdir = $true;
$files = gci .
$files | ?{$_.name -match ".sln"} | %{ $global:client = $_.Name }
$files | ?{ $_.psiscontainer } | %{if($_.Name -match "Resource"){$global:libdir = $false} }
if($global:client){
  $global:client = $global:client -replace "sln", "nuspec"
  new-item -itemtype file $global:client
}
$helpText = @"
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
	<metadata>
		<id>X-client-X.Sitecore</id>
		<authors>One North Interactive</authors>
		<version>1.0.0.0</version>
		<requireLicenseAcceptance>false</requireLicenseAcceptance>
		<description>Octopus Deploy Package</description>
	</metadata>
	<files>
		<file src="TDS.Core\Package_Release\*.update" target="Website\sitecore\admin\Packages" />
		<file src="TDS.Master\Package_Release\*.update" target="Website\sitecore\admin\Packages" />
		<file src="X-lib-X\Sitecore.Support.424428.dll" target="Website\bin" />
		<file src="Website\Web.*config" target="Website" />
	</files>
</package>
"@
$helpText = $helpText -replace "X-client-X", "$($global:client -replace '.nuspec','')"
if($global:libdir){ $helpText = $helpText -replace "X-lib-X", "..\lib" }
else{ $helpText = $helpText -replace "X-lib-X", "Resource" }
$helpText | out-file $global:client
$helpText | clip
} #end function add-help
set-alias nusp Add-Nuspec

function Up-Gattributes(){
<#
   .Synopsis
    This function updates the git attributes for the current git repo to add '*.item -text'
    and remove any other .item references
   .Example
    Example- This allows item files to have the correct line endings for TeamCity Build Server
   .Parameter
    N/A
   .Notes
    NAME: Up-Gattributes
    AUTHOR: dtran
    LASTEDIT: 03/13/2016 23:17:17
    KEYWORDS:
#Requires -Version 2.0
#>
$script:cleared = $false
$gitattributes = gci . | ?{$_.Name -match ".gitattributes"}
write-host $gitattributes
if(!$gitattributes){new-item -itemtype file ".gitattributes"}
$gacontent = gc $gitattributes
echo "$($gacontent.length) lines"
foreach($line in $gacontent){
  if($line -match '\*\.item \-text'){
    $script:cleared = $true
    write-host $line -f yellow
  }
  else{
    write-host $line -f cyan
  }
}
if($script:cleared){
  write-host "Found *.item -text exiting" -f Green
  # Do nada
  }else{
  write-host "Adding the *.item  -text" -f DarkMagenta
  add-content $gitattributes "*.item -text" -Encoding ASCII
  write-host "-->  I added this... " -f DarkMagenta
  cat $gitattributes
}
}
set-alias gat Up-Gattributes


get-process | ?{$_.name -match "premium"} | stop-process -force

#start-job -scriptblock{while($true){get-process | ?{$_.name -match "ntrtscan"} | kill}}




function oninuget(){
"http://nuget.local.com/nuget/Default" | clip
}

function getdeployments($servicename){
  if($servicename){
    Get-AzureDeployment -servicename $servicename -Slot Production | ?{$_.Servicename -notmatch 'test'; $sn = $_.servicename} | %{$_.RoleInstanceList | ?{$_.Rolename -match 'SitecoreWebRole'} | select @{N='Name';E={"$($sn)_$(($_.Instancename -split '_')[2])"}}, @{N='URI';E={"$($sn).cloudapp.net"}}, @{N='Description';E={"Cookie:\smstshash=$($_.Rolename)#$($_.InstanceName)"}} | FT * }
    }else{
    Get-AzureService | Get-AzureDeployment -Slot Production -ErrorAction Continue | ?{$_.Servicename -notmatch 'test'; $sn = $_.servicename} | %{$_.RoleInstanceList | ?{$_.Rolename -match 'SitecoreWebRole'} | select @{N='Name';E={"$($sn)_$(($_.Instancename -split '_')[2])"}}, @{N='URI';E={"$($sn).cloudapp.net"}}, @{N='Description';E={"Cookie:\smstshash=$($_.Rolename)#$($_.InstanceName)"}} | FT * }
  }
}
<#
  $services = Get-AzureService
  foreach($service in $services){
     Get-AzureDeployment -Slot Production | ?{$_.Servicename -notmatch 'test'; $sn = $_.servicename} | %{$_.RoleInstanceList | ?{$_.Rolename -match 'SitecoreWebRole'} | select @{N='Name';E={"$($sn)_$(($_.Instancename -split '_')[2])"}}, @{N='URI';E={"$($sn).cloudapp.net"}}, @{N='Description';E={"Cookie:\smstshash=$($_.Rolename)#$($_.InstanceName)"}} }
  }
#>

function SetSub($sub){
  #add-azureaccount
  if([string]::IsNullOrWhitespace($sub)){
    $subname = Get-azuresubscription | select subscriptionname | out-gridview -passthru
    $sub = $subname.subscriptionname
    if($subname.Count -gt 1){
      foreach($sn in $subnames){
        write-host $sn
      }
    }
  }
  set-azuresubscription -subscriptionname $sub
  select-azuresubscription -subscriptionname $sub
  Get-azuresubscription -current
}

function GetVM([string]$vm, [string]$service){

  #add-azureaccount
  if(![string]::IsNullOrWhitespace($vm)){
    $vmobj = Get-azureservice | get-azurevm | out-gridview -passthru
  }
  else{
    if(![string]::IsNullOrWhitespace($service)){
      $vmobj = Get-azurevm -name $vm -servicename $service
    }
    else{
      $vmobj = Get-azurevm -name $vm
    }
  }
  return $vmobj

}

## usage, this works:
## $outrdps = "c:\git\repos\mynotes\current\Royal.csv"
## 2doforAllSubs -task {getdeployments} -filter {$_.Subscription -match 'S_' } >> $outrdps
function doforAllSubs([Scriptblock]$task, [Scriptblock]$filter)
{
  if($filter){
    Get-azuresubscription | ?{$filter} |%{set-azuresubscription -subscriptionname $_.subscriptionname; select-azuresubscription -subscriptionname $_.subscriptionname; write-host $_.subscriptionname -f Green; & $task }
  }else{
    Get-azuresubscription |%{set-azuresubscription -subscriptionname $_.subscriptionname; select-azuresubscription -subscriptionname $_.subscriptionname; write-host $_.subscriptionname -f Green; & $task }
    <#$subs = Get-azuresubscription
    foreach($sub in ($subs | ?{$_.Subscriptionname -match 'S_'})){
      set-azuresubscription -subscriptionname $sub.subscriptionname
      select-azuresubscription -subscriptionname $sub.subscriptionname
      $services = Get-AzureService
      foreach($service in $services ){
        $deployments = Get-AzureDeployment -servicename $service.ServiceName -slot "Production" -ErrorAction Continue
        if($deployments.Count -gt 0){
          #write-host $service.ServiceName -f Yellow
          getdeployments -servicename $service.Servicename
         # write-host $(get-date)
        }
      }
    }#>
  }
}

function startmeup([string]$sub,[string]$service,[string]$vmname){
  if(![string]::IsNullOrWhitespace($sub)){ SetSub }
  else { SetSub -sub $sub }
  if([string]::IsNullOrWhitespace($vmname)){
    $vm = GetVM
  }
  else{
    if(![string]::IsNullOrWhitespace($service)){ $vm = GetVM -vm $vmname }
    else{ $vm = GetVM -service $service -vm $vmname }
  }
  $currentstatus = (get-azurevm -ServiceName $vm.Servicename -Name $vm.Name).Status
  write-host "$($vm.Name) is $currentstatus"
  if($currentstatus -eq "StoppedDeallocated"){
    Start-AzureVM -ServiceName $vm.Servicename -Name $vm.Name
    write-host "$($vm.Name) is starting"
  }
}

function stopme([string]$sub,[string]$service,[string]$vmname){
  if(![string]::IsNullOrWhitespace($sub)){ SetSub }
  else { SetSub -sub $sub }
  if([string]::IsNullOrWhitespace($vmname)){
    $vm = GetVM
  }
  else{
    if([string]::IsNullOrWhitespace($service)){ $vm = GetVM -vm $vmname }
    else{ $vm = GetVM -service $service -vm $vmname }
  }
  $currentstatus = (get-azurevm -ServiceName $vm.Servicename -Name $vm.Name).Status
  get-azurevm -ServiceName $vm.Servicename -Name $vm.Name | Stop-AzureVM
  write-host "$($vm.Name) is $currentstatus"
  if($currentstatus -eq "ReadyRole"){
    Stop-AzureVM -ServiceName $vm.Servicename -Name $vm.Name
    write-host "$($vm.Name) is stopping"
  }

}

function pt($ip){
        # ping -t 69.4.190.14|cmd /q /v /c "(pause&pause)>nul & for /l %a in () do (set /p "data=" && echo(!time! !data!)&ping -n 2 69.4.190.14>nul"
  #cmd /c 'ping -t $($ip)|cmd /q /v /c "(pause&pause)>nul & for /l %a in () do (set /p "data=" && echo(!time! !data!)&ping -n 2 $($ip)>nul"'
  & { ping -t $($ip)|cmd /q /v /c "(pause&pause)>nul & for /l %a in () do (set /p "data=" && echo(!time! !data!)&ping -n 2 $($ip)>nul" }
}
