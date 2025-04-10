#!/usr/bin/env bash
# cspell: disable

echo "Testing sourceIf in $SHELL"

# Source the functions
if [[ -n $BASH_VERSION ]]; then
  source ~/.bash_profile
else
  source ~/.zshrc
fi

# Test sourceIf
echo -e "\nTesting sourceIf:"
echo "1. Testing with non-existent file:"
echo "Before sourceIf call:"
set | grep TEST_VAR || echo "TEST_VAR not set"
sourceIf "/tmp/nonexistent_file"
echo "After sourceIf call:"
set | grep TEST_VAR || echo "TEST_VAR not set"

echo -e "\n2. Testing with existing file:"
echo 'export TEST_VAR="test successful"' > /tmp/test_file
echo "Before sourceIf call:"
set | grep TEST_VAR || echo "TEST_VAR not set"
sourceIf "/tmp/test_file"
echo "After sourceIf call:"
set | grep TEST_VAR || echo "TEST_VAR not set"
rm /tmp/test_file

# Print function definition for debugging
echo -e "\nFunction definition:"
declare -f sourceIf 