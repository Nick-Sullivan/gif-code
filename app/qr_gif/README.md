This is designed to be able to run locally (Using VSCode -> Run), or to deploy a custom environment.

## Getting started

1. Create a `.env` file with the following:

```bash
# If you change any of these variables, run "./make.ps1 init"
ENVIRONMENT=dev
```

If you want to create a different environment, change `dev` to any unique string and follow the remaining steps.

2. Initialise terraform

```bash
./make.ps1 init
```

3. Deploy terraform

```bash
cd ../infrastructure
terraform apply
```

4. Build

```bash
./make.ps1 build
```

5. Cleanup

```bash
cd terraform/infrastructure
terraform destroy
```
