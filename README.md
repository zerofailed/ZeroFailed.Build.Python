# ZeroFailed.Build.Python

A [ZeroFailed](https://github.com/endjin/ZeroFailed) extension containing features that support build processes for Python projects.

## Features Overview

| Component Type | Included | Notes                                                                                                                                                         |
| -------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tasks          | yes      |                                                                                                                                                               |
| Functions      | yes      |                                                                                                                                                               |
| Processes      | no       | Designed to be compatible with the default process provided by the [ZeroFailed.Build.Common](https://github.com/zerofailed/ZeroFailed.Build.Common) extension |

For more information about the different component types, please refer to the [ZeroFailed documentation](https://github.com/endjin/ZeroFailed/blob/main/README.md#extensions).

This extension consists of the following feature groups, refer to the [HELP page](./HELP.md) for more details.

- Dependency Management
- Linting
- Testing
- Packaging
- Publishing

The diagram below shows the discrete features and when they run as part of the default build process provided by [ZeroFailed.Build.Common](https://github.com/zerofailed/ZeroFailed.Build.Common).

```mermaid
kanban
    init
    version
    build
        ensurePython[Ensure Python available]
        installDepTool[Install Poetry or UV]
        initVenv[Initialise venv]
        lint[Run Flake8]
    test
        runPytest[Run PyTest tests]
        runBehave[Run Behave tests]
    analysis
    package
        buildWheel[Build .WHL files]
    publish
        publishWheel[Publish .WHL files]
```

## Pre-Requisites

Using this extension requires the following components to be installed:

- A suitable version of Python

## Dependencies

The following ZeroFailed extensions will be installed when using this extension.

| Extension                                                                          | Reference Type | Version |
| ---------------------------------------------------------------------------------- | -------------- | ------- |
| [ZeroFailed.Build.Common](https://github.com/zerofailed/ZeroFailed.Build.Common)   | git            | `main`  |
| [ZeroFailed.DevOps.Common](https://github.com/zerofailed/ZeroFailed.DevOps.Common) | git            | `main`  |
