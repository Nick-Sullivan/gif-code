This is designed to be able to run locally (Using VSCode -> Run), or to deploy a custom environment.

## Getting started

1. Install libraries

```bash
mise install
```

2. Create a `.env` file with the following:

```bash
# If you change any of these variables, run "mise init"
ENVIRONMENT=dev
GIPHY_API_KEY="INSERT KEY HERE"
```

If you want to create a different environment, change `dev` to any unique string and follow the remaining steps.

3. Initialise terraform

```bash
mise init
```

4. Deploy terraform

```bash
mise apply
```

5. Run API tests

```bash
mise test
```

6. Cleanup

```bash
mise destroy
```
