####### Setup the first domain controller


$safePassword = ConvertTo-SecureString -Name "Password1234!!!"


Set-TimeZone –name "W. Europe Standard Time"
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "addstest.local" -DomainNetBiosName "addstest" -InstallDns:$true -NoRebootCompletion:$true -SafeModeAdministratorPassword $safePassword
