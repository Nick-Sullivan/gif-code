#MISE description="Install infrastructure with terraform"
#MISE alias="ii"

$ErrorActionPreference = "Stop"

$envLine = Get-Content .env | Where-Object { $_ -match "^ENVIRONMENT=" }
if (-not $envLine) {
    Write-Error "ENVIRONMENT not found in .env file"
    exit 1
}

$environment = $envLine.Split('=')[1]
Write-Host "Using environment: $environment"

$key = "key=gif_code_app/$environment/infrastructure/terraform.tfstate"
Write-Host $key

Set-Location terraform/infrastructure
terraform init -backend-config $key -reconfigure

@"
environment="$environment"
"@ | Out-File -FilePath terraform.tfvars -Encoding utf8

Set-Location ../..