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
    $key = "key=gif_code_app/$environment/infrastructure/terraform.tfstate"
    Write-Output $key
    Set-Location terraform/infrastructure
    terraform init -backend-config $key -reconfigure
    $text = 'environment="' + $environment + '"'
    $text | Out-File -FilePath "terraform.tfvars" -Encoding utf8
    terraform apply -auto-approve
    Set-Location ../..
}

function Build() {
    Write-Output "Building app"
    flutter build appbundle
}

function Test() {
    Write-Output "Testing app"
    flutter config --enable-windows-desktop
    flutter test -d windows integration_test/main_test.dart --dart-define=IS_TESTING=true
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
    "test" { Test }
}
