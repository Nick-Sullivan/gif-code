$ErrorActionPreference = "Stop"
$command = $args[0]


# Runs when first setting up the repository.

function Install {
    Write-Output "Installing server libraries"
    py -3.11 -m venv .venv  
    ./.venv/Scripts/activate
    pip install -r requirements.txt
    deactivate
}

# Runs whenever you switch environments.

function Init-Foundation([string]$environment, [string]$giphyApiKey) {
    $key = "key=gif_code/$environment/foundation/terraform.tfstate"
    Write-Output $key
    Set-Location terraform/foundation
    terraform init -backend-config $key -reconfigure
    $text = 'environment="' + $environment + '"' + "`r`n" + 'giphy_api_key="' + $giphyApiKey + '"'
    $text | Out-File -FilePath "terraform.tfvars" -Encoding utf8
    Set-Location ../..
}

function Init-Infrastructure([string]$environment) {
    ./.venv/Scripts/activate
    $key = "key=gif_code/$environment/infrastructure/terraform.tfstate"
    Write-Output $key
    Set-Location terraform/infrastructure
    terraform init -backend-config $key -reconfigure
    $text = 'environment="' + $environment + '"'
    $text | Out-File -FilePath "terraform.tfvars" -Encoding utf8
    Set-Location ../..

    Set-Location lambda/libs
    pip install -r requirements.txt --target python
    Set-Location ../..

    deactivate
}

function Load-Env([string]$key) {
    get-content .env | foreach {
        $name, $value = $_.split('=')
        if ( $name -eq $key ) {
            return $value
        }
        #set-content env:\$name $value
    }
}

# Runs after code has been changed.

function Deploy() {
    Set-Location terraform/foundation
    terraform apply
    Set-Location ../infrastructure
    terraform apply
    Set-Location ../..
}

# Runs after deployment.
function Test-Api {
    Write-Output "Running API tests for the server"
    ./.venv/Scripts/activate
    pytest tests/api
    deactivate
}

# Runs when we are done with our environment

function Destroy() {
    Set-Location terraform/infrastructure
    terraform destroy
    Set-Location ../foundation
    terraform destroy
    Set-Location ../..
}

function Freeze {
    Write-Output "Updating requirements.txt"
    ./.venv/Scripts/activate
    pip freeze > requirements.txt
    deactivate
}

switch ($command) {
    # Repo setup
    "install" { Install }
    "freeze" { Freeze }
    # Environment setup
    "init" { 
        $environment = Load-Env 'ENVIRONMENT'
        $giphyApiKey = Load-Env 'GIPHY_API_KEY'
        if ($environment) {
            Write-Output "Setting environment to: $environment"
            Init-Foundation $environment $giphyApiKey
            Init-Infrastructure $environment
        } else {
            Write-Output "Did not find the environment"
        }
    }
    # Deployment
    "deploy" { Deploy }
    "destroy" { Destroy }
    # Testing
    "test" { 
        Test-Api
    }
    default {
        Write-Output "Unrecognised command. See make.ps1 for list of valid commands."
    }
   
}
