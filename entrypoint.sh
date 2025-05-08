#!/bin/bash -l
# shellcheck disable=SC2086
set -e          # Exit immediately if a command exits with a non-zero status
set -o pipefail # Return value of a pipeline is the value of the last command to exit with a non-zero status

echo "
+------------------------+
| Linting YAML Files...  |
+------------------------+
"

# Create a temporary log file if not specified
if [[ -z "$LOGFILE" ]]; then
  LOGFILE=$(mktemp yamllint-XXXXXX)
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create temporary log file" >&2
    exit 1
  fi
fi

# Build yamllint options array based on inputs
declare -a options

# Add custom configuration file if specified
if [[ -n "$INPUT_CONFIG_FILE" ]]; then
    options+=(-c "$INPUT_CONFIG_FILE")
fi

# Add custom configuration data if specified
if [[ -n "$INPUT_CONFIG_DATA" ]]; then
    options+=(-d "$INPUT_CONFIG_DATA")
fi

# Set output format
options+=(-f "$INPUT_FORMAT")

# Enable strict mode if requested
if [[ "$INPUT_STRICT" == "true" ]]; then
    options+=(-s)
fi

# Hide warnings if requested
if [[ "$INPUT_NO_WARNINGS" == "true" ]]; then
    options+=(--no-warnings)
fi

# Enable globstar so ** globs recursively
shopt -s globstar

# Run yamllint with the configured options
echo "Running: yamllint ${options[*]} ${INPUT_FILE_OR_DIR:-.}"
yamllint "${options[@]}" "${INPUT_FILE_OR_DIR:-.}" | tee -a "$LOGFILE"
exitcode=$?

# Disable globstar
shopt -u globstar

# Set output variable for GitHub Actions
echo "logfile=$(realpath "${LOGFILE}")" >> "$GITHUB_OUTPUT"

exit $exitcode
