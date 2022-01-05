set TF_LOG=TRACE
REM del terraform-provider-cmdb_v1.0.0
REM del .terraform\plugins\ - Recurse -Force
go build -o terraform-provider-cmdb_v1.0.0
del terraform-provider-cmdb_v1.0.0.exe
rename terraform-provider-cmdb_v1.0.0 terraform-provider-cmdb_v1.0.0.exe
copy terraform-provider-cmdb_v1.0.0.exe C:\Users\hemotzku\AppData\Roaming\terraform.d\plugins\registry.terraform.io\hashicorp\cmdb\1.0.0\windows_amd64\
del .terraform.lock.hcl


REM c:\terraform\terraform.exe init
REM c:\terraform\terraform.exe plan