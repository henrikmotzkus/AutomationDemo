####### Setup the first domain controller
$domain = "e5testtenant.de"
$password = "ThirdPassw0rd!" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\adminlocal"

workflow SetupDC {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module PSWindowsUpdate 

    Get-WindowsUpdate
    Install-WindowsUpdate -AcceptAll -IgnoreReboot

    Restart-Computer -Wait

    $safePassword = $password
    Set-TimeZone –name "W. Europe Standard Time"
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    Install-ADDSForest -DomainName $domain -DomainNetBiosName "addstest" -InstallDns:$true -SafeModeAdministratorPassword $safePassword -Force
}

workflow SetupDS {

    $hostname = "DS01"
    
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module PSWindowsUpdate 

    Get-WindowsUpdate
    Install-WindowsUpdate -AcceptAll -IgnoreReboot

    Restart-Computer -Wait

    $safePassword = ConvertTo-SecureString -Name $password
    Set-TimeZone –name "W. Europe Standard Time"
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    Add-Computer -DomainName $domain -Credential $credential

    Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools

    Install-ADcsCertificationAuthority `
        –Credential $credential `
        -CAType [StandaloneRootCA] `
        -CACommonName“domain-Host1-CA-1” `
        -CADistinguishedNameSuffix “DC=domain,DC=com” `
        -CryptoProviderName“RSA#Microsoft Software Key Storage Provider” `
        -KeyLength 2048 `
        -HashAlgorithmName SHA1 `
        -ValidityPeriod Years `
        -ValidityPeriodUnits3 `
        -DatabaseDirectory “C:\windows\system32\certLog” `
        -LogDirectory “c:\windows\system32\CertLog” `
        -Force

    Install-AdcsCertificationAuthority `
        -Credential $credential `
        -CAType EnterpriseRootCa `
        -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
        -KeyLength 2048 `
        -HashAlgorithmName SHA512 `
        -ValidityPeriod Years `
        -ValidityPeriodUnits 3
        -Force



}


# Create the scheduled job properties
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
$secpasswd = ConvertTo-SecureString "Password1234!!!" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("ADDSTEST\adminlocal", $secpasswd)
$AtStartup = New-JobTrigger -AtStartup

# Register the scheduled job
Register-ScheduledJob -Name Resume_Workflow_Job -Trigger $AtStartup -ScriptBlock ({[System.Management.Automation.Remoting.PSSessionConfigurationData]::IsServerManager = $true; Import-Module PSWorkflow; Resume-Job -Name new_resume_workflow_job -Wait}) -ScheduledJobOption $options
# Execute the workflow as a new job
SetupDC -AsJob -JobName new_resume_workflow_job

