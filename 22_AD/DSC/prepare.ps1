
Install-Module -Name xActiveDirectory

hadc.ps1

New-SelfsignedCertificate `
 -Subject "CN=${ENV:ComputerName}" `
 -KeyUsage 'KeyEncipherment' `
 -FriendlyName 'DSC Credential Encryption certificate' `
 -KeyLength 2048 `
 -KeyExportPolicy Exportable `
 -Type DocumentEncryptionCert
 
$cert = Get-ChildItem -Path cert:\LocalMachine\My\884849D3F284344572015B616336DEE5F0F41C2C

Export-Certificate -Cert $cert -FilePath user.cer

$mypwd = ConvertTo-SecureString -String "Password1234!!!" -Force -AsPlainText

Get-ChildItem -Path cert:\LocalMachine\my\97B4C075A15F1D26B9CB2BD03D253E64D7BCA409 | Export-PfxCertificate -FilePath mypfx.pfx -Password $mypwd

New-GuestConfigurationPackage `
  -Name 'adds1' `
  -Configuration './HADC/192.168.35.5.mof' `
  -Type AuditAndSet `
  -Force

  New-GuestConfigurationPackage `
  -Name 'adds2' `
  -Configuration './HADC/192.168.35.6.mof' `
  -Type AuditAndSet `
  -Force