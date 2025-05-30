#!/bin/bash

# BashChat Setup Script
# Initializes the development environment and installs dependencies

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
log() {
    local level="$1"
    shift
    local message="$*"
    
    case "$level" in
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        "INFO")
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        "DEBUG")
            echo -e "${BLUE}[DEBUG]${NC} $message"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Show banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                    BashChat Setup                           ║
║              No-Code AI Generator                           ║
║                                                             ║
║  Setting up your development environment...                 ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check system requirements
check_requirements() {
    log "INFO" "Checking system requirements..."
    
    local missing_deps=()
    
    # Check bash version
    if [[ "${BASH_VERSION%%.*}" -lt 4 ]]; then
        log "WARN" "Bash version 4+ recommended (current: $BASH_VERSION)"
    fi
    
    # Check for required commands
    local required_commands=("sed" "grep" "awk" "find" "mkdir" "chmod")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    # Check optional dependencies
    local optional_commands=("node" "npm" "python3" "pip" "git")
    for cmd in "${optional_commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            log "INFO" "Found $cmd: $(command -v "$cmd")"
        else
            log "WARN" "Optional dependency not found: $cmd"
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log "ERROR" "Missing required dependencies: ${missing_deps[*]}"
        return 1
    fi
    
    log "INFO" "System requirements check passed"
}

# Create directory structure
setup_directories() {
    log "INFO" "Setting up directory structure..."
    
    local dirs=("config" "templates" "generated" "logs" "plugins" "examples" "tests")
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$SCRIPT_DIR/$dir" ]]; then
            mkdir -p "$SCRIPT_DIR/$dir"
            log "INFO" "Created directory: $dir"
        else
            log "DEBUG" "Directory already exists: $dir"
        fi
    done
}

# Make scripts executable
setup_permissions() {
    log "INFO" "Setting up file permissions..."
    
    local scripts=("bashchat.sh" "demo.sh" "setup.sh")
    
    for script in "${scripts[@]}"; do
        if [[ -f "$SCRIPT_DIR/$script" ]]; then
            chmod +x "$SCRIPT_DIR/$script"
            log "INFO" "Made executable: $script"
        fi
    done
}

# Install Node.js dependencies
install_node_deps() {
    if command -v npm &> /dev/null && [[ -f "$SCRIPT_DIR/package.json" ]]; then
        log "INFO" "Installing Node.js dependencies..."
        
        cd "$SCRIPT_DIR"
        if npm install; then
            log "INFO" "Node.js dependencies installed successfully"
        else
            log "WARN" "Failed to install Node.js dependencies"
        fi
    else
        log "WARN" "npm not found or package.json missing - skipping Node.js setup"
    fi
}

# Install Python dependencies
install_python_deps() {
    if command -v pip3 &> /dev/null && [[ -f "$SCRIPT_DIR/requirements.txt" ]]; then
        log "INFO" "Installing Python dependencies..."
        
        if pip3 install -r "$SCRIPT_DIR/requirements.txt"; then
            log "INFO" "Python dependencies installed successfully"
        else
            log "WARN" "Failed to install Python dependencies"
        fi
    elif command -v pip &> /dev/null && [[ -f "$SCRIPT_DIR/requirements.txt" ]]; then
        log "INFO" "Installing Python dependencies with pip..."
        
        if pip install -r "$SCRIPT_DIR/requirements.txt"; then
            log "INFO" "Python dependencies installed successfully"
        else
            log "WARN" "Failed to install Python dependencies"
        fi
    else
        log "WARN" "pip not found or requirements.txt missing - skipping Python setup"
    fi
}

# Create example files
create_examples() {
    log "INFO" "Creating example files..."
    
    # Example prompts file
    cat > "$SCRIPT_DIR/examples/example_prompts.txt" << 'EOF'
# BashChat Example Prompts
# Copy and paste these into BashChat to see what it can generate

# Web Applications
create a python web app called BlogApp with user authentication and database
build a javascript web api for e-commerce with payment integration
create an html website for a tech startup with modern design

# CLI Tools
create a python command line tool for log analysis
build a bash script for automated server deployment
create a go cli tool for file synchronization

# Data Processing
create a python script for CSV data processing and visualization
build sql schema for inventory management system

# Mobile & Desktop
create a react native app for task management
build a desktop app in electron for note taking

# APIs & Services
build a rest api in node.js for user management
create a microservice in go for authentication
build a graphql api for content management

# Scripts & Utilities
create a bash script for system monitoring
build a python script for file organization
create a powershell script for windows automation

# Games & Entertainment
create a simple game in python using pygame
build a web-based puzzle game in javascript
create a text-based adventure game in python
EOF

    # Example configuration
    cat > "$SCRIPT_DIR/examples/example_config.json" << 'EOF'
{
    "ai_provider": "openai",
    "model": "gpt-4",
    "max_tokens": 2000,
    "temperature": 0.7,
    "supported_languages": [
        "python",
        "javascript",
        "typescript",
        "java",
        "cpp",
        "csharp",
        "go",
        "rust",
        "php",
        "ruby",
        "bash",
        "html",
        "css",
        "sql"
    ],
    "default_language": "python",
    "output_format": "file",
    "include_comments": true,
    "include_tests": true,
    "code_style": "clean",
    "custom_templates_dir": "templates/custom",
    "output_directory": "generated",
    "log_level": "INFO",
    "auto_install_deps": false,
    "backup_generated_files": true
}
EOF

    log "INFO" "Example files created in examples/ directory"
}

# Create test files
create_tests() {
    log "INFO" "Creating test files..."
    
    # Basic test script
    cat > "$SCRIPT_DIR/tests/test_basic.sh" << 'EOF'
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
EOF

    chmod +x "$SCRIPT_DIR/tests/test_basic.sh"
    log "INFO" "Test files created in tests/ directory"
}

# Setup git hooks (if git is available)
setup_git_hooks() {
    if command -v git &> /dev/null && [[ -d "$SCRIPT_DIR/.git" ]]; then
        log "INFO" "Setting up git hooks..."
        
        # Pre-commit hook
        cat > "$SCRIPT_DIR/.git/hooks/pre-commit" << 'EOF'
#!/bin/bash
# BashChat pre-commit hook

echo "Running BashChat tests..."
if [[ -x "tests/test_basic.sh" ]]; then
    ./tests/test_basic.sh
else
    echo "No tests found, skipping..."
fi
EOF
        
        chmod +x "$SCRIPT_DIR/.git/hooks/pre-commit"
        log "INFO" "Git pre-commit hook installed"
    else
        log "DEBUG" "Git not available or not a git repository - skipping git hooks"
    fi
}

# Create desktop shortcut (Linux/macOS)
create_desktop_shortcut() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local desktop_file="$HOME/Desktop/BashChat.desktop"
        
        cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=BashChat
Comment=No-Code AI Generator
Exec=gnome-terminal -- bash -c "cd '$SCRIPT_DIR' && ./bashchat.sh -i; exec bash"
Icon=terminal
Terminal=false
Categories=Development;
EOF
        
        chmod +x "$desktop_file"
        log "INFO" "Desktop shortcut created: $desktop_file"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - create an alias
        log "INFO" "On macOS, you can create an alias: alias bashchat='cd $SCRIPT_DIR && ./bashchat.sh'"
    fi
}

# Verify installation
verify_installation() {
    log "INFO" "Verifying installation..."
    
    local issues=()
    
    # Check main script
    if [[ ! -x "$SCRIPT_DIR/bashchat.sh" ]]; then
        issues+=("bashchat.sh is not executable")
    fi
    
    # Check directories
    local required_dirs=("config" "templates" "generated" "logs")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$SCRIPT_DIR/$dir" ]]; then
            issues+=("Missing directory: $dir")
        fi
    done
    
    # Check templates
    if [[ ! -f "$SCRIPT_DIR/templates/python_default.template" ]]; then
        issues+=("Missing Python template")
    fi
    
    if [[ ${#issues[@]} -gt 0 ]]; then
        log "ERROR" "Installation issues found:"
        for issue in "${issues[@]}"; do
            log "ERROR" "  - $issue"
        done
        return 1
    fi
    
    log "INFO" "Installation verification passed"
}

# Show completion message
show_completion() {
    echo
    echo -e "${GREEN}🎉 BashChat setup completed successfully!${NC}"
    echo
    echo -e "${CYAN}Quick Start:${NC}"
    echo "  1. Interactive mode:    ./bashchat.sh -i"
    echo "  2. Run demo:           ./demo.sh"
    echo "  3. Generate code:      ./bashchat.sh 'create a python web app'"
    echo "  4. Run tests:          ./tests/test_basic.sh"
    echo
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  • Read the README.md for detailed usage instructions"
    echo "  • Check examples/example_prompts.txt for inspiration"
    echo "  • Customize config/settings.json for your preferences"
    echo "  • Try the demo: ./demo.sh"
    echo
    echo -e "${BLUE}Support:${NC}"
    echo "  • Documentation: README.md"
    echo "  • Examples: examples/"
    echo "  • Issues: https://github.com/your-username/bashchat/issues"
    echo
}

# Main setup function
main() {
    local skip_deps=false
    local skip_tests=false
    local verbose=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-deps)
                skip_deps=true
                shift
                ;;
            --skip-tests)
                skip_tests=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -h|--help)
                echo "BashChat Setup Script"
                echo
                echo "Usage: $0 [OPTIONS]"
                echo
                echo "Options:"
                echo "  --skip-deps    Skip dependency installation"
                echo "  --skip-tests   Skip test creation"
                echo "  -v, --verbose  Enable verbose output"
                echo "  -h, --help     Show this help"
                exit 0
                ;;
            *)
                log "ERROR" "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    show_banner
    
    # Run setup steps
    check_requirements
    setup_directories
    setup_permissions
    
    if [[ "$skip_deps" != true ]]; then
        install_node_deps
        install_python_deps
    else
        log "INFO" "Skipping dependency installation"
    fi
    
    create_examples
    
    if [[ "$skip_tests" != true ]]; then
        create_tests
    else
        log "INFO" "Skipping test creation"
    fi
    
    setup_git_hooks
    create_desktop_shortcut
    
    verify_installation
    show_completion
}

# Run main function
main "$@"