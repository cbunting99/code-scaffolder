#!/bin/bash

# BashChat Demo Script
# Demonstrates the capabilities of the no-code AI generator

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHCHAT="$SCRIPT_DIR/bashchat.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Demo banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                    BashChat Demo                            ║
║              No-Code AI Generator                           ║
║                                                             ║
║  Transform natural language into functional code!           ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Progress indicator
show_progress() {
    local message="$1"
    echo -e "${YELLOW}⏳ $message...${NC}"
    sleep 1
}

# Success indicator
show_success() {
    local message="$1"
    echo -e "${GREEN}✅ $message${NC}"
}

# Demo step
demo_step() {
    local step_num="$1"
    local title="$2"
    local description="$3"
    
    echo
    echo -e "${BLUE}━━━ Step $step_num: $title ━━━${NC}"
    echo -e "${PURPLE}$description${NC}"
    echo
    
    read -p "Press Enter to continue..."
}

# Run demo command
run_demo() {
    local prompt="$1"
    local description="$2"
    
    echo -e "${CYAN}Prompt: ${NC}\"$prompt\""
    echo -e "${YELLOW}$description${NC}"
    echo
    
    show_progress "Generating code"
    
    if [[ -x "$BASHCHAT" ]]; then
        "$BASHCHAT" "$prompt"
        show_success "Code generated successfully!"
    else
        echo -e "${RED}Error: bashchat.sh not found or not executable${NC}"
        echo "Please run: chmod +x bashchat.sh"
        return 1
    fi
}

# Show generated file
show_generated_file() {
    local pattern="$1"
    local description="$2"
    
    echo
    echo -e "${BLUE}Generated File Preview:${NC}"
    echo -e "${YELLOW}$description${NC}"
    echo "----------------------------------------"
    
    # Find the most recent file matching the pattern
    local file
    file=$(find "$SCRIPT_DIR/generated" -name "*$pattern*" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    
    if [[ -n "$file" && -f "$file" ]]; then
        echo -e "${GREEN}File: $file${NC}"
        echo
        head -30 "$file"
        if [[ $(wc -l < "$file") -gt 30 ]]; then
            echo "..."
            echo -e "${BLUE}(showing first 30 lines)${NC}"
        fi
    else
        echo -e "${RED}No generated file found matching pattern: $pattern${NC}"
    fi
    
    echo "----------------------------------------"
}

# Main demo function
main_demo() {
    show_banner
    
    echo -e "${GREEN}Welcome to the BashChat Demo!${NC}"
    echo "This demo will show you how to generate code using natural language prompts."
    echo
    
    # Check if bashchat.sh exists and is executable
    if [[ ! -f "$BASHCHAT" ]]; then
        echo -e "${RED}Error: bashchat.sh not found!${NC}"
        echo "Please make sure you're running this from the bashchat directory."
        exit 1
    fi
    
    if [[ ! -x "$BASHCHAT" ]]; then
        echo -e "${YELLOW}Making bashchat.sh executable...${NC}"
        chmod +x "$BASHCHAT"
    fi
    
    read -p "Press Enter to start the demo..."
    
    # Demo Step 1: Python Web App
    demo_step "1" "Python Web App" "Generate a complete Flask web application with API endpoints"
    
    run_demo "create a python web app called TaskManager with database and authentication" \
             "This will generate a Flask web application with user authentication, database integration, and API endpoints."
    
    show_generated_file "TaskManager" "Flask web application with authentication and database"
    
    # Demo Step 2: JavaScript API
    demo_step "2" "JavaScript API" "Generate a Node.js REST API server"
    
    run_demo "build a javascript api for user management with CRUD operations" \
             "This will create an Express.js API server with user management endpoints."
    
    show_generated_file ".js" "Node.js Express API server"
    
    # Demo Step 3: HTML Website
    demo_step "3" "HTML Website" "Generate a modern responsive website"
    
    run_demo "create an html website for a tech startup with modern design" \
             "This will generate a beautiful, responsive HTML website with modern CSS styling."
    
    show_generated_file ".html" "Modern responsive website"
    
    # Demo Step 4: CLI Tool
    demo_step "4" "CLI Tool" "Generate a command-line utility"
    
    run_demo "create a python cli tool for file backup and compression" \
             "This will generate a Python command-line tool with argument parsing and file operations."
    
    show_generated_file "backup" "Python CLI tool for file operations"
    
    # Demo Step 5: Bash Script
    demo_step "5" "Bash Script" "Generate a system automation script"
    
    run_demo "build a bash script for automated server deployment" \
             "This will create a bash script for automating server deployment tasks."
    
    show_generated_file ".sh" "Bash automation script"
    
    # Demo completion
    echo
    echo -e "${GREEN}🎉 Demo completed successfully!${NC}"
    echo
    echo -e "${CYAN}What you've seen:${NC}"
    echo "• Python Flask web application"
    echo "• Node.js Express API"
    echo "• Modern HTML website"
    echo "• Python CLI tool"
    echo "• Bash automation script"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Try the interactive mode: ./bashchat.sh -i"
    echo "2. Generate your own projects with custom prompts"
    echo "3. Explore the generated files in the 'generated/' directory"
    echo "4. Read the README.md for more advanced usage"
    echo
    echo -e "${BLUE}Example prompts to try:${NC}"
    echo '• "create a react todo app with local storage"'
    echo '• "build a go microservice for user authentication"'
    echo '• "create a sql schema for e-commerce database"'
    echo '• "build a rust cli tool for log analysis"'
    echo
}

# Interactive demo menu
interactive_menu() {
    while true; do
        echo
        echo -e "${CYAN}BashChat Demo Menu${NC}"
        echo "1. Run full demo"
        echo "2. Quick Python web app demo"
        echo "3. Quick JavaScript API demo"
        echo "4. Quick HTML website demo"
        echo "5. Custom prompt demo"
        echo "6. Show generated files"
        echo "7. Interactive mode"
        echo "8. Exit"
        echo
        read -p "Choose an option (1-8): " choice
        
        case $choice in
            1)
                main_demo
                ;;
            2)
                run_demo "create a python web app called QuickApp" "Quick Python Flask web application"
                show_generated_file "QuickApp" "Python Flask web app"
                ;;
            3)
                run_demo "build a javascript api for data management" "Quick Node.js Express API"
                show_generated_file ".js" "JavaScript API"
                ;;
            4)
                run_demo "create an html landing page for a product" "Quick HTML landing page"
                show_generated_file ".html" "HTML landing page"
                ;;
            5)
                echo
                read -p "Enter your custom prompt: " custom_prompt
                if [[ -n "$custom_prompt" ]]; then
                    run_demo "$custom_prompt" "Custom user prompt"
                    echo "Check the generated/ directory for your file"
                fi
                ;;
            6)
                echo
                echo -e "${BLUE}Generated files:${NC}"
                if [[ -d "$SCRIPT_DIR/generated" ]]; then
                    ls -la "$SCRIPT_DIR/generated/" 2>/dev/null || echo "No files generated yet"
                else
                    echo "No generated directory found"
                fi
                ;;
            7)
                echo
                echo -e "${GREEN}Starting interactive mode...${NC}"
                "$BASHCHAT" -i
                ;;
            8)
                echo -e "${CYAN}Thanks for trying BashChat!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please choose 1-8.${NC}"
                ;;
        esac
    done
}

# Parse command line arguments
case "${1:-}" in
    "-h"|"--help")
        echo "BashChat Demo Script"
        echo
        echo "Usage: $0 [OPTIONS]"
        echo
        echo "Options:"
        echo "  -h, --help     Show this help"
        echo "  -f, --full     Run full demo"
        echo "  -i, --interactive  Interactive menu"
        echo
        echo "Examples:"
        echo "  $0              # Interactive menu"
        echo "  $0 -f           # Run full demo"
        echo "  $0 -i           # Interactive menu"
        exit 0
        ;;
    "-f"|"--full")
        main_demo
        ;;
    "-i"|"--interactive")
        interactive_menu
        ;;
    "")
        interactive_menu
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        echo "Use -h or --help for usage information"
        exit 1
        ;;
esac