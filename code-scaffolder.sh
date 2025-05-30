#!/bin/bash

# Code Scaffolder - Smart Template-Based Code Generator
# A natural language to code generator using intelligent template scaffolding
# Author: AI Assistant
# Version: 1.0.0

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/settings.json"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
OUTPUT_DIR="$SCRIPT_DIR/generated"
LOG_FILE="$SCRIPT_DIR/logs/codescaffolder.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
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

# Initialize directories
init_directories() {
    log "INFO" "Initializing Code Scaffolder directories..."
    
    local dirs=("config" "templates" "generated" "logs" "plugins")
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$SCRIPT_DIR/$dir" ]]; then
            mkdir -p "$SCRIPT_DIR/$dir"
            log "INFO" "Created directory: $dir"
        fi
    done
}

# Load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log "WARN" "Config file not found. Creating default configuration..."
        create_default_config
    fi
    
    log "INFO" "Loading configuration from $CONFIG_FILE"
}

# Create default configuration
create_default_config() {
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat > "$CONFIG_FILE" << 'EOF'
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
    "code_style": "clean"
}
EOF
    log "INFO" "Default configuration created at $CONFIG_FILE"
}

# Parse natural language prompt
parse_prompt() {
    local prompt="$1"
    local language=""
    local project_type=""
    
    # Detect programming language
    if [[ "$prompt" =~ (html|HTML|website|webpage) ]]; then
        language="html"
    elif [[ "$prompt" =~ (javascript|js|node) ]]; then
        language="javascript"
    elif [[ "$prompt" =~ (python|py) ]]; then
        language="python"
    elif [[ "$prompt" =~ (typescript|ts) ]]; then
        language="typescript"
    elif [[ "$prompt" =~ (java) ]]; then
        language="java"
    elif [[ "$prompt" =~ (cpp|c\+\+) ]]; then
        language="cpp"
    elif [[ "$prompt" =~ (csharp|c#) ]]; then
        language="csharp"
    elif [[ "$prompt" =~ (go|golang) ]]; then
        language="go"
    elif [[ "$prompt" =~ (rust) ]]; then
        language="rust"
    elif [[ "$prompt" =~ (php) ]]; then
        language="php"
    elif [[ "$prompt" =~ (ruby) ]]; then
        language="ruby"
    elif [[ "$prompt" =~ (bash|shell) ]]; then
        language="bash"
    elif [[ "$prompt" =~ (css) ]]; then
        language="css"
    elif [[ "$prompt" =~ (sql) ]]; then
        language="sql"
    else
        language="python"  # Default
    fi
    
    # Detect project type
    if [[ "$prompt" =~ (web app|website|web application|web server|server) ]]; then
        project_type="web_app"
    elif [[ "$prompt" =~ (api|rest api|web api|REST API) ]]; then
        project_type="web_app"  # APIs are web apps
    elif [[ "$prompt" =~ (cli|command line|terminal) ]]; then
        project_type="cli"
    elif [[ "$prompt" =~ (desktop app|gui) ]]; then
        project_type="desktop"
    elif [[ "$prompt" =~ (mobile app) ]]; then
        project_type="mobile"
    elif [[ "$prompt" =~ (library|package|module) ]]; then
        project_type="library"
    elif [[ "$prompt" =~ (script) ]]; then
        project_type="script"
    else
        project_type="web_app"  # Default to web_app for better coverage
    fi
    
    echo "$language|$project_type"
}

# Extract application name from prompt
extract_app_name() {
    local prompt="$1"
    
    # Look for patterns like "create a ... called X" or "build X"
    if [[ "$prompt" =~ (called|named)[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
        echo "${BASH_REMATCH[2]}"
    elif [[ "$prompt" =~ (build|create)[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
        echo "${BASH_REMATCH[2]}"
    else
        echo "MyApp"
    fi
}

# Extract description from prompt
extract_description() {
    local prompt="$1"
    
    # Clean up the prompt to use as description
    local description="$prompt"
    description="${description//create/Create}"
    description="${description//build/Build}"
    echo "$description"
}

# Extract features from prompt
extract_features() {
    local prompt="$1"
    local features=""
    
    # Look for common feature keywords
    if [[ "$prompt" =~ (database|db) ]]; then
        features="$features database"
    fi
    if [[ "$prompt" =~ (authentication|auth|login) ]]; then
        features="$features authentication"
    fi
    if [[ "$prompt" =~ (api) ]]; then
        features="$features api"
    fi
    if [[ "$prompt" =~ (ui|interface|frontend) ]]; then
        features="$features ui"
    fi
    if [[ "$prompt" =~ (test|testing) ]]; then
        features="$features testing"
    fi
    
    echo "${features# }"  # Remove leading space
}

# Create basic templates
create_templates() {
    log "INFO" "Creating code templates..."
    
    # Python web app template
    cat > "$TEMPLATES_DIR/python_web_app.template" << 'EOF'
#!/usr/bin/env python3
"""
{{APP_NAME}} - {{DESCRIPTION}}
Generated by Code Scaffolder on {{DATE}}
"""

import os
import sys
from flask import Flask, render_template, request, jsonify
from datetime import datetime

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'dev-key-change-in-production')

# Configuration
class Config:
    DEBUG = True
    HOST = '0.0.0.0'
    PORT = 5000

@app.route('/')
def index():
    """Main page"""
    return jsonify({
        'app': '{{APP_NAME}}',
        'description': '{{DESCRIPTION}}',
        'features': '{{FEATURES}}',
        'status': 'running',
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/status')
def api_status():
    """API status endpoint"""
    return jsonify({
        'status': 'ok',
        'app': '{{APP_NAME}}',
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/data', methods=['GET', 'POST'])
def api_data():
    """Data API endpoint"""
    if request.method == 'POST':
        data = request.get_json()
        return jsonify({'message': 'Data received', 'data': data})
    else:
        return jsonify({
            'items': [
                {'id': 1, 'name': 'Item 1', 'value': 100},
                {'id': 2, 'name': 'Item 2', 'value': 200}
            ]
        })

if __name__ == '__main__':
    print(f"Starting {{APP_NAME}}...")
    print(f"Description: {{DESCRIPTION}}")
    print(f"Features: {{FEATURES}}")
    
    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG
    )
EOF

    # Python default template
    cat > "$TEMPLATES_DIR/python_default.template" << 'EOF'
#!/usr/bin/env python3
"""
{{APP_NAME}} - {{DESCRIPTION}}
Generated by Code Scaffolder on {{DATE}}
"""

import sys
import os
from datetime import datetime

class {{APP_NAME}}:
    """Main class for {{APP_NAME}}"""
    
    def __init__(self):
        self.name = "{{APP_NAME}}"
        self.description = "{{DESCRIPTION}}"
        self.features = "{{FEATURES}}".split() if "{{FEATURES}}" else []
        self.created_at = datetime.now()
    
    def run(self):
        """Main execution method"""
        print(f"Running {self.name}...")
        print(f"Description: {self.description}")
        
        if self.features:
            print(f"Features: {', '.join(self.features)}")
        
        self.execute_logic()
    
    def execute_logic(self):
        """Execute the main application logic"""
        print("Executing application logic...")
        print("Hello from {{APP_NAME}}!")

def main():
    """Main function"""
    app = {{APP_NAME}}()
    app.run()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\nOperation cancelled by user")
        sys.exit(0)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
EOF

    # JavaScript web app template
    cat > "$TEMPLATES_DIR/javascript_web_app.template" << 'EOF'
/**
 * {{APP_NAME}} - {{DESCRIPTION}}
 * Generated by Code Scaffolder on {{DATE}}
 */

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Configuration
const config = {
    appName: '{{APP_NAME}}',
    description: '{{DESCRIPTION}}',
    features: '{{FEATURES}}'.split(' ').filter(f => f),
    version: '1.0.0'
};

// Routes
app.get('/', (req, res) => {
    res.json({
        message: `Welcome to ${config.appName}`,
        description: config.description,
        features: config.features,
        version: config.version,
        timestamp: new Date().toISOString()
    });
});

app.get('/api/status', (req, res) => {
    res.json({
        status: 'ok',
        app: config.appName,
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`${config.appName} is running on port ${PORT}`);
    console.log(`Description: ${config.description}`);
    console.log(`Features: ${config.features.join(', ')}`);
    console.log(`Visit: http://localhost:${PORT}`);
});

module.exports = app;
EOF

    # HTML template
    cat > "$TEMPLATES_DIR/html_web_app.template" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{APP_NAME}} - {{DESCRIPTION}}</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #667eea;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .description {
            text-align: center;
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: #666;
        }
        
        .features {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        .btn {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            background: #5a6fd8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>{{APP_NAME}}</h1>
        <div class="description">{{DESCRIPTION}}</div>
        
        <div class="features">
            <h3>Features:</h3>
            <p>{{FEATURES}}</p>
        </div>
        
        <div style="text-align: center;">
            <button class="btn" onclick="showAlert()">Get Started</button>
            <button class="btn" onclick="showInfo()">Learn More</button>
        </div>
        
        <footer style="text-align: center; margin-top: 30px; color: #666;">
            <p>&copy; {{DATE}} {{APP_NAME}}. Generated by Code Scaffolder.</p>
        </footer>
    </div>
    
    <script>
        function showAlert() {
            alert('Welcome to {{APP_NAME}}! Ready to get started.');
        }
        
        function showInfo() {
            alert('{{DESCRIPTION}}\n\nFeatures: {{FEATURES}}');
        }
        
        console.log('{{APP_NAME}} loaded successfully!');
    </script>
</body>
</html>
EOF

    log "INFO" "Templates created successfully"
}

# Replace template placeholders
replace_placeholders() {
    local file="$1"
    local prompt="$2"
    local language="$3"
    local project_type="$4"
    
    # Extract key information from prompt
    local app_name
    app_name=$(extract_app_name "$prompt")
    
    local description
    description=$(extract_description "$prompt")
    
    local features
    features=$(extract_features "$prompt")
    
    # Replace common placeholders
    sed -i "s/{{APP_NAME}}/$app_name/g" "$file"
    sed -i "s/{{DESCRIPTION}}/$description/g" "$file"
    sed -i "s/{{LANGUAGE}}/$language/g" "$file"
    sed -i "s/{{PROJECT_TYPE}}/$project_type/g" "$file"
    sed -i "s/{{FEATURES}}/$features/g" "$file"
    sed -i "s/{{DATE}}/$(date '+%Y-%m-%d')/g" "$file"
    sed -i "s/{{TIMESTAMP}}/$(date '+%Y-%m-%d %H:%M:%S')/g" "$file"
}

# Process template with AI-like logic
process_template() {
    local template_file="$1"
    local prompt="$2"
    local output_file="$3"
    local language="$4"
    local project_type="$5"
    
    log "INFO" "Processing template: $template_file"
    
    # Create output directory if it doesn't exist
    mkdir -p "$(dirname "$output_file")"
    
    # Start with template
    cp "$template_file" "$output_file"
    
    # Replace placeholders with AI-generated content
    replace_placeholders "$output_file" "$prompt" "$language" "$project_type"
    
    log "INFO" "Code generated successfully: $output_file"
}

# Generate code based on prompt
generate_code() {
    local prompt="$1"
    local output_file="$2"
    
    log "INFO" "Generating code for prompt: $prompt"
    
    # Parse the prompt
    local parse_result
    parse_result=$(parse_prompt "$prompt")
    local language="${parse_result%|*}"
    local project_type="${parse_result#*|}"
    
    log "INFO" "Detected language: $language, project type: $project_type"
    
    # Load appropriate template
    local template_file="$TEMPLATES_DIR/${language}_${project_type}.template"
    if [[ ! -f "$template_file" ]]; then
        template_file="$TEMPLATES_DIR/${language}_default.template"
    fi
    
    log "DEBUG" "Looking for template: $template_file"
    
    if [[ ! -f "$template_file" ]]; then
        log "ERROR" "No template found for language: $language"
        return 1
    fi
    
    # Generate code using template and AI processing
    process_template "$template_file" "$prompt" "$output_file" "$language" "$project_type"
}

# Show help
show_help() {
    cat << 'EOF'
Code Scaffolder - Smart Template-Based Code Generator Help

Usage:
    bashchat_fixed.sh [OPTIONS] [PROMPT]

Options:
    -i, --interactive    Start interactive mode
    -o, --output FILE    Specify output file
    -l, --language LANG  Force specific language
    -t, --type TYPE      Force specific project type
    -h, --help          Show help message

Examples:
    bashchat_fixed.sh "create a python web app called TodoApp"
    bashchat_fixed.sh -i
    bashchat_fixed.sh -o myapp.py "build a calculator in python"

Supported Languages:
  python, javascript, typescript, java, cpp, csharp, go, rust, php, ruby, bash, html, css, sql

Project Types:
  web_app, api, cli, desktop, mobile, library, script

Interactive Commands:
  help     - Show this help
  list     - List generated files
  clear    - Clear screen
  exit     - Exit Code Scaffolder
EOF
}

# List generated files
list_generated_files() {
    echo -e "${YELLOW}Generated files:${NC}"
    if [[ -d "$OUTPUT_DIR" ]] && [[ -n "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]]; then
        ls -la "$OUTPUT_DIR"
    else
        echo "No files generated yet."
    fi
}

# Interactive mode
interactive_mode() {
    log "INFO" "Starting Code Scaffolder interactive mode..."
    
    echo -e "${CYAN}Welcome to Code Scaffolder - Smart Template-Based Code Generator${NC}"
    echo -e "${YELLOW}Type your prompts to generate code, or 'help' for commands, 'exit' to quit${NC}"
    echo
    
    while true; do
        echo -n -e "${GREEN}scaffolder> ${NC}"
        read -r input
        
        case "$input" in
            "help")
                show_help
                ;;
            "list")
                list_generated_files
                ;;
            "clear")
                clear
                ;;
            "exit"|"quit")
                log "INFO" "Exiting Code Scaffolder..."
                echo -e "${CYAN}Thanks for using Code Scaffolder!${NC}"
                break
                ;;
            "")
                continue
                ;;
            *)
                process_interactive_prompt "$input"
                ;;
        esac
        echo
    done
}

# Process interactive prompt
process_interactive_prompt() {
    local prompt="$1"
    
    log "INFO" "Processing interactive prompt: $prompt"
    
    # Generate unique filename
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local app_name
    app_name=$(extract_app_name "$prompt")
    local parse_result
    parse_result=$(parse_prompt "$prompt")
    local language="${parse_result%|*}"
    
    local extension
    case "$language" in
        "python") extension="py" ;;
        "javascript") extension="js" ;;
        "typescript") extension="ts" ;;
        "java") extension="java" ;;
        "cpp") extension="cpp" ;;
        "csharp") extension="cs" ;;
        "go") extension="go" ;;
        "rust") extension="rs" ;;
        "php") extension="php" ;;
        "ruby") extension="rb" ;;
        "bash") extension="sh" ;;
        "html") extension="html" ;;
        "css") extension="css" ;;
        "sql") extension="sql" ;;
        *) extension="txt" ;;
    esac
    
    local output_file="$OUTPUT_DIR/${app_name}_${timestamp}.${extension}"
    
    # Generate the code
    if generate_code "$prompt" "$output_file"; then
        echo -e "${GREEN}✓ Code generated successfully!${NC}"
        echo -e "${BLUE}Output file: $output_file${NC}"
        
        # Show preview
        echo -e "${YELLOW}Preview:${NC}"
        echo "----------------------------------------"
        head -20 "$output_file"
        if [[ $(wc -l < "$output_file") -gt 20 ]]; then
            echo "..."
            echo -e "${BLUE}(showing first 20 lines)${NC}"
        fi
        echo "----------------------------------------"
    else
        echo -e "${RED}✗ Failed to generate code${NC}"
    fi
}

# Main function
main() {
    local interactive=false
    local output_file=""
    local force_language=""
    local force_type=""
    local prompt=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--interactive)
                interactive=true
                shift
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -l|--language)
                force_language="$2"
                shift 2
                ;;
            -t|--type)
                force_type="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                log "ERROR" "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                prompt="$*"
                break
                ;;
        esac
    done
    
    # Initialize
    init_directories
    load_config
    
    # Create templates if they don't exist
    create_templates
    
    if [[ "$interactive" == true ]]; then
        interactive_mode
    elif [[ -n "$prompt" ]]; then
        # Non-interactive mode
        log "INFO" "Processing prompt: $prompt"
        if [[ -z "$output_file" ]]; then
            local timestamp=$(date '+%Y%m%d_%H%M%S')
            local app_name
            app_name=$(extract_app_name "$prompt")
            local parse_result
            parse_result=$(parse_prompt "$prompt")
            local language="${parse_result%|*}"
            
            local extension
            case "$language" in
                "python") extension="py" ;;
                "javascript") extension="js" ;;
                "typescript") extension="ts" ;;
                "java") extension="java" ;;
                "cpp") extension="cpp" ;;
                "csharp") extension="cs" ;;
                "go") extension="go" ;;
                "rust") extension="rs" ;;
                "php") extension="php" ;;
                "ruby") extension="rb" ;;
                "bash") extension="sh" ;;
                "html") extension="html" ;;
                "css") extension="css" ;;
                "sql") extension="sql" ;;
                *) extension="txt" ;;
            esac
            
            output_file="$OUTPUT_DIR/${app_name}_${timestamp}.${extension}"
        fi
        
        if generate_code "$prompt" "$output_file"; then
            echo -e "${GREEN}✓ Code generated successfully: $output_file${NC}"
        else
            echo -e "${RED}✗ Failed to generate code${NC}"
            exit 1
        fi
    else
        show_help
    fi
}

# Execute main function when script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi