cp $profile c:\git\repos\mynotes\current\a-ju-MSProfile.ps1
set-alias livetail c:\tools\tailclient-1.0.1-install\tailclient-1.0.1\bin\livetail.bat
#New-Alias "?:" IfTrue
# Load posh-git example profile
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
. 'C:\Tools\poshgit\dahlbyk-posh-git-f71b636\profile.example.ps1'
function subl { &"${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" $args }
function nuget { &"C:\tools\nuget.exe" $args }
function ToArray
{
  begin
  {
    $output = @();
  }
  process
  {
    $output += $_;
  }
  end
  {
    return $output;
  }
}
Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

# for app recycle
cp \\source\apprecycle.ps1 D:\apprecycle.ps1
set-alias lh d:\apprecycle.ps1

function MakeLinksForSitecoreSitesNode()
{
  $onienvs = @("local.com","staged.com","qa.com")
  $dom = Read-host -prompt "enter your domain like so: www.domain.com"
  $domdashes = $dom -replace '\.','-'
  $dommiddlename = ($dom -split '\.')[1]
  $mid = $dommiddlename.length/2
  write-host $mid
  #$domadmin = ?: ($dommiddlename.length -gt 4) $dommiddlename.Insert(5,'-') $dommiddlename.Insert(2,'-')
  $domadmin = $dommiddlename.Insert($mid,'-')
  $fulladmin = "$($dommiddlename).admin.local.com"
  Write-Host "`n`nUrls generated for { $dom  and  $fulladmin } `n`n"
  Write-Host " >>> Sitecore OD [Variable].AppConfigInclude, [Step]Sitecore Installation IIS bindings <<< `n"
  $onienvs | %{Write-Host "[ $($_) ]`r" ;Write-Host "$($domdashes)-01.server.$($_) | $($domdashes)-02.server.$($_) | $($domdashes).$($_) | $($dommiddlename).admin.local.com | $($domadmin).admin.local.com`n`n" -f Red}
  Write-Host "[ WAF CD content rule ]"
  $onienvs | %{$rule += " ( Header Host eq $($domdashes).$($_) ) || " }
  $rule = $rule.substring(0,$rule.Length-3)
  Write-Host "`n$rule`n" -f Blue
  $rule = $null
  Write-Host "[ WAF CM content rule ]"
  $onienvs | %{$rule += "( Header Host eq $($domdashes -replace "www-", "admin-").$($_) ) || " }
  $rule += " $($domadmin).admin.local.com"
  #$rule = $rule.substring(0,$rule.Length-3)
  Write-Host "`n$rule`n" -f Green

  Write-host "`n--> Put this in to the Launch Spreadsheet"
  $onienvs |?{$_ -match "live"} |%{Write-Host "$($domdashes)-01.server.$($_)`n$($domdashes)-02.server.$($_)`n$($domdashes).$($_)`n$($domadmin).admin.local.com`n`n" -f DarkMagenta}

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
#        Write-Log -Msg 'Log entry created successful.' [-LogTime `$false]
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
#Requires -Version 3.0
#>
"@
 $helpText | clip
} #end function add-help
set-alias pleh Add-Help



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
  if(![string]::IsNullOrWhitespace($sub)){
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
## doforAllSubs -task {getdeployments} -filter {$_.subscriptionname -match 'S_'}
## doforAllSubs -task {getdeployments} >> c:\git\repos\mynotes\current\Royal.csv
function doforAllSubs([Scriptblock]$task, [Scriptblock]$filter)
{
  #write-host $filter #  ; break;
  #$filter = {$_.Subscriptionname -match 'S_'}
  #xGet-azuresubscription | ?{$($filter)} |%{set-azuresubscription -subscriptionname $_.subscriptionname; select-azuresubscription -subscriptionname $_.subscriptionname; (Get-Item "function:$task").ScriptBlock.StartPosition}
  if($filter){
    Get-azuresubscription | ?{$filter} |%{set-azuresubscription -subscriptionname $_.subscriptionname; select-azuresubscription -subscriptionname $_.subscriptionname; write-host $_.subscriptionname -f Green; (get-item "function:$task").Scriptblock }
  }else{
    #  $stuff = (Get-Item "function:$task").ScriptBlock
    #Get-azuresubscription | %{set-azuresubscription -subscriptionname $_.subscriptionname; select-azuresubscription -subscriptionname $_.subscriptionname; write-host $_.subscriptionname -f Red;   Get-AzureService | Get-AzureDeployment -Slot Production -erroraction continue | ?{$_.Servicename -notmatch 'test'; $sn = $_.servicename} | %{$_.RoleInstanceList | ?{$_.Rolename -match 'SitecoreWebRole'} | select @{N='Name';E={"$($sn)_$(($_.Instancename -split '_')[2])"}}, @{N='URI';E={"$($sn).cloudapp.net"}}, @{N='Description';E={"Cookie:\smstshash=$($_.Rolename)#$($_.InstanceName)"}} }  }
    $subs = Get-azuresubscription
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

    }
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


function appsee($vmname){
  if(!$vmname){
    $filter = Read-host -prompt "Filter Servers search by"
    if($filter){
      $vm = Get-ADComputer -searchbase 'OU=Servers,dc=production,dc=com' -Filter '*' | ?{$_.Name -match $filter} | out-gridview -passthru
    }
    else {
        $vm = Get-ADComputer -searchbase 'OU=Servers,dc=production,dc=com' -Filter '*' | out-gridview -passthru
    }
    $vmname = $vm.name
  }
  invoke-command $vmname -scriptblock{`
    set-alias appcmd "c:\windows\system32\inetsrv\appcmd.exe";
    $reqs = appcmd list requests;
    write-host $reqs -f Yellow;
    write-output $reqs
  }
}
