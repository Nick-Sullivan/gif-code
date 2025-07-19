# MISE description="Destroy infrastructure with terraform"
# MISE alias="destroy"

$ErrorActionPreference = "Stop"
Set-Location terraform/infrastructure
terraform destroy
Set-Location ../..