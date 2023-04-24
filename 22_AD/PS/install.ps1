####### Setup the first domain controller


workflow Setup {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module PSWindowsUpdate 

    Get-WindowsUpdate
    Install-WindowsUpdate -AcceptAll -IgnoreReboot

    Restart-Computer -Wait

    $safePassword = ConvertTo-SecureString -Name "Password1234!!!"
    Set-TimeZone –name "W. Europe Standard Time"
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    Install-ADDSForest -DomainName "addstest.local" -DomainNetBiosName "addstest" -InstallDns:$true -SafeModeAdministratorPassword $safePassword -Force
}

# Create the scheduled job properties
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
$secpasswd = ConvertTo-SecureString "Password1234!!!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("ADDSTEST\adminlocal", $secpasswd)
$AtStartup = New-JobTrigger -AtStartup

# Register the scheduled job
Register-ScheduledJob -Name Resume_Workflow_Job -Trigger $AtStartup -ScriptBlock ({[System.Management.Automation.Remoting.PSSessionConfigurationData]::IsServerManager = $true; Import-Module PSWorkflow; Resume-Job -Name new_resume_workflow_job -Wait}) -ScheduledJobOption $options
# Execute the workflow as a new job
Setup -AsJob -JobName new_resume_workflow_job