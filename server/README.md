This is

## Getting started

1. Install libraries

```bash
./make.ps1 install
```

2. Create a `.env` file with the following:

```bash
# If you change any of these variables, run "./make.ps1 init"
ENVIRONMENT=dev
GIPHY_API_KEY="INSERT KEY HERE"
```

If you want to create a new environment, change `dev` to any unique string and follow the remaining steps.

3. Initialise terraform

```bash
./make.ps1 init
```

4. Deploy terraform

```bash
cd terraform/foundation
terraform apply
cd ../infrastructure
terraform apply
```

5. Run API tests

```bash
./make.ps1 test-api
```
