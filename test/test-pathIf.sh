#!/usr/bin/env bash
# cspell: disable

echo "Testing pathIf in $SHELL"

# Source the functions
if [[ -n $BASH_VERSION ]]; then
  source ~/.bash_profile
else
  source ~/.zshrc
fi

# Test pathIf
echo -e "\nTesting pathIf:"
echo "1. Testing with non-existent directory:"
original_path=$PATH
pathIf "/tmp/nonexistent_dir"
if [[ "$PATH" == "$original_path" ]]; then
    echo "GOOD: PATH unchanged"
else
    echo "BAD: PATH was modified"
fi

echo -e "\n2. Testing with existing directory:"
echo "Original PATH: $PATH"
mkdir -p /tmp/test_path_dir
pathIf "/tmp/test_path_dir"
if [[ "$PATH" == *"/tmp/test_path_dir"* ]]; then
    echo "GOOD: Directory was added to PATH"
else
    echo "BAD: Directory was not added to PATH"
fi
rm -r /tmp/test_path_dir

# Print function definition for debugging
echo -e "\nFunction definition:"
declare -f pathIf 