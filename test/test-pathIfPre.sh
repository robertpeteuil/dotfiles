#!/bin/bash

# Source the necessary files
source ~/.bash_profile

echo "--- Testing pathIfPre ---"
echo "Testing pathIfPre in $SHELL"
echo

echo "Testing pathIfPre:"
echo "1. Testing with non-existent directory:"
original_path="$PATH"
pathIfPre "/tmp/non-existent-dir"
if [ "$PATH" = "$original_path" ]; then
    echo "GOOD: PATH unchanged"
else
    echo "FAIL: PATH was modified"
fi
echo

echo "2. Testing with existing directory:"
original_path="$PATH"
test_dir="/tmp/test_path_dir"
mkdir -p "$test_dir"
echo "Original PATH: $PATH"
pathIfPre "$test_dir"
if [[ "$PATH" == "$test_dir:"* ]]; then
    echo "GOOD: Directory was added to beginning of PATH"
else
    echo "FAIL: Directory was not added to beginning of PATH"
fi
rmdir "$test_dir"
echo

echo "Function definition:"
type pathIfPre 