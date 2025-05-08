# GitHub Action for YAML Lint

This action executes [yamllint](https://github.com/adrienverge/yamllint) to validate YAML file syntax and enforce formatting standards.

## What it checks

Yamllint checks for:
- Syntax errors
- Key duplications
- Line length, trailing spaces
- Indentation and spacing
- New lines at end of files
- And [more](https://yamllint.readthedocs.io/en/stable/rules.html)

## Usage

Simple usage:

```yaml
- uses: metawave/action-yamllint@v1
```

## Parameters

| Parameter | Description | Required | Default |
|-----------|-------------|----------|---------|
| `file_or_dir` | Files or directories to lint (space separated) | No | `.` (all YAML files) |
| `config_file` | Path to custom configuration file | No | |
| `config_data` | Custom configuration as YAML source | No | |
| `format` | Output format: parsable, standard, colored, github, auto | No | `parsable` |
| `strict` | Return non-zero exit code on warnings | No | `false` |
| `no_warnings` | Output only error level problems | No | `false` |

### File/Directory Examples
- `.` - All YAML files recursively (default)
- `file1.yaml file2.yaml` - Specific files
- `kustomize/**/*.yaml mychart/*values.yaml` - Pattern matching

## Outputs

| Output | Description |
|--------|-------------|
| `logfile` | Path to the yamllint log file containing all linting results |

### Using the Output

You can use the `logfile` output in subsequent steps:

```yaml
- name: yaml-lint
  id: yamllint
  uses: metawave/action-yamllint@v1

- name: Process log file
  run: cat ${{ steps.yamllint.outputs.logfile }}
```

## Examples

### Lint specific files with custom config

```yaml
name: YAML Lint
on: [push]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: yaml-lint
      uses: metawave/action-yamllint@v1
      with:
        file_or_dir: myfolder/*values*.yaml
        config_file: .yamllint.yml
```

### Lint all YAML files

```yaml
name: YAML Lint
on: [push]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: yaml-lint
      uses: metawave/action-yamllint@v1
```

**Note:** The action automatically uses `.yamllint` from your repository root if available.

### Custom Configuration as YAML Source Examples

```yaml
# Single line
config_data: "{extends: default, rules: {new-line-at-end-of-file: disable}}"
```

```yaml
# Multi line
config_data: |
  extends: default
  rules:
    new-line-at-end-of-file:
      level: warning
    trailing-spaces:
      level: warning
```

## Versioning

This action follows [Semantic Versioning](https://semver.org/). Use a specific version tag for stability:

```yaml
- uses: metawave/action-yamllint@v1.0.0  # Use a specific version
- uses: metawave/action-yamllint@v1      # Use the latest v1.x.x release
- uses: metawave/action-yamllint@main    # Use the latest development version
```
