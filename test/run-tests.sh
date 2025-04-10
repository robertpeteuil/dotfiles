#!/usr/bin/env bash
# cspell: disable

# Make test scripts executable
chmod +x test-sourceIf.sh test-pathIf.sh

echo "=== Testing in Bash ==="
echo -e "\n--- Testing sourceIf ---"
env -i SHELL=/bin/bash bash --login -c './test-sourceIf.sh'

echo -e "\n--- Testing pathIf ---"
env -i SHELL=/bin/bash bash --login -c './test-pathIf.sh'

echo -e "\n=== Testing in ZSH ==="
echo -e "\n--- Testing sourceIf ---"
env -i SHELL=/bin/zsh zsh --login -c './test-sourceIf.sh'

echo -e "\n--- Testing pathIf ---"
env -i SHELL=/bin/zsh zsh --login -c './test-pathIf.sh' 