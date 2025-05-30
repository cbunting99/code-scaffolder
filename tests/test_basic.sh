#!/bin/bash

# Basic tests for BashChat functionality

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHCHAT="$SCRIPT_DIR/../bashchat.sh"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

test_count=0
pass_count=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    ((test_count++))
    echo "Running test: $test_name"
    
    if eval "$test_command"; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
        ((pass_count++))
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name"
    fi
    echo
}

# Test 1: Script exists and is executable
run_test "Script exists and is executable" "[[ -x '$BASHCHAT' ]]"

# Test 2: Help option works
run_test "Help option works" "'$BASHCHAT' --help > /dev/null 2>&1"

# Test 3: Directory structure exists
run_test "Directory structure exists" "[[ -d '$SCRIPT_DIR/../config' && -d '$SCRIPT_DIR/../templates' && -d '$SCRIPT_DIR/../generated' ]]"

# Test 4: Templates exist
run_test "Templates exist" "[[ -f '$SCRIPT_DIR/../templates/python_default.template' ]]"

# Test 5: Configuration can be created
run_test "Configuration creation" "'$BASHCHAT' --help > /dev/null && [[ -f '$SCRIPT_DIR/../config/settings.json' ]]"

# Summary
echo "Test Results: $pass_count/$test_count tests passed"

if [[ $pass_count -eq $test_count ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
