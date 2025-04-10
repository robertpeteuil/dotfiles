#!/bin/bash
# cspell: disable

# Make test scripts executable
chmod +x test-sourceIf.sh test-pathIf.sh test-pathIfPre.sh

echo "=== Testing in Bash ==="
echo
bash --login -c './test-sourceIf.sh'
echo
bash --login -c './test-pathIf.sh'
echo
bash --login -c './test-pathIfPre.sh'
echo

echo "=== Testing in ZSH ==="
echo
zsh -c './test-sourceIf.sh'
echo
zsh -c './test-pathIf.sh'
echo 