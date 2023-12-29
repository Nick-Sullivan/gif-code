$ErrorActionPreference = "Stop"
$command = $args[0]


function Load-Env([string]$key) {
    get-content .env | foreach {
        $name, $value = $_.split('=')
        if ( $name -eq $key ) {
            return $value
        }
        #set-content env:\$name $value
    }
}

function Init-Infrastructure([string]$environment) {
    $key = "key=gif_code_app/$environment/infra/terraform.tfstate"
    Write-Output $key
    Set-Location terraform/infrastructure
    terraform init -backend-config $key -reconfigure
    $text = 'environment="' + $environment + '"'
    $text | Out-File -FilePath "terraform.tfvars" -Encoding utf8
    Set-Location ../..
}

function Build() {
    Write-Output "Building app"
    flutter build appbundle
}

switch ($command) {
    "init" { 
        $environment = Load-Env 'ENVIRONMENT'
        if ($environment) {
            Write-Output "Setting environment to: $environment"
            Init-Infrastructure $environment
        } else {
            Write-Output "Did not find the environment"
        }
    }
    "build" { Build }
}
