This is designed to be able to run locally (Using VSCode -> Run), or to deploy a custom environment.

## Getting started

1. Create a `.env` file with the following:

```bash
# If you change any of these variables, run "mise init_infrastructure"
ENVIRONMENT=dev
```

If you want to create a different environment, change `dev` to any unique string and follow the remaining steps.

2. Initialise terraform, this pulls down infrastructure variables like API Gateway URLs.

```bash
mise init
```

3. Build

```bash
mise build
```

4. Cleanup

```bash
mise destroy
```

## Dev notes

- Uses MVVM style
  - Models hold data
  - ViewModels (named controllers) update data, and notify views
  - Views display widgets and listen to ViewModels
- If controller is a singleton, pass using GetIt
- if controller is not, pass via constructor
