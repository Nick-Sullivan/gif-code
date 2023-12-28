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

3. Initialise terraform

```bash
./make.ps1 init
```

4. Run API tests

```bash
./make.ps1 test-api
```

5. Run locally using VSCode -> Run
