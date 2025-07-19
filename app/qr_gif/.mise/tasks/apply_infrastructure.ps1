#MISE description="Apply the infrastructure"
#MISE alias="ai"
$ErrorActionPreference = "Stop"

Set-Location terraform\infrastructure
terraform apply
Set-Location ..\..
