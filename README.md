# Code Scaffolder - Smart Template-Based Code Generator

🚀 **Transform natural language prompts into functional code using intelligent template scaffolding**

Code Scaffolder is a powerful command-line tool that converts your natural language descriptions into working code across multiple programming languages and project types. Using smart pattern recognition and template-based generation, it provides an intuitive way to scaffold applications, scripts, and tools without writing boilerplate code manually.

## ✨ Features

- 🗣️ **Natural Language Parsing**: Describe what you want in plain English
- 🌐 **Multi-Language Support**: Python, JavaScript, TypeScript, Java, C++, Go, Rust, PHP, Ruby, Bash, HTML, CSS, SQL
- 🏗️ **Project Templates**: Web apps, APIs, CLI tools, desktop apps, mobile apps, libraries, scripts
- 🎯 **Smart Pattern Recognition**: Automatically detects language and project type from prompts
- 🔄 **Interactive Mode**: Real-time code scaffolding with immediate feedback
- 📁 **Template System**: Extensible template-based code generation with placeholder replacement
- 🎨 **Modern UI**: Beautiful HTML templates with responsive design
- 📝 **Comprehensive Logging**: Detailed logs for debugging and monitoring
- ⚡ **Fast Generation**: No external API calls - everything runs locally

## 🚀 Quick Start

### Prerequisites

- Bash shell (Git Bash on Windows, Terminal on macOS/Linux)
- Node.js (for JavaScript projects)
- Python 3.7+ (for Python projects)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/cbunting99/code-scaffolder.git
   cd code-scaffolder
   ```

2. **Make the script executable**:
   ```bash
   chmod +x code-scaffolder.sh
   ```

3. **Install dependencies** (optional, for generated projects):
   ```bash
   # For Node.js projects
   npm install
   
   # For Python projects
   pip install -r requirements.txt
   ```

### Basic Usage

#### Command Line Mode

```bash
# Generate a Python web app
./code-scaffolder.sh "create a python web app called TodoApp with database and authentication"

# Generate a JavaScript API
./code-scaffolder.sh "build a REST API in Node.js for user management"

# Generate a CLI tool
./code-scaffolder.sh "create a bash script for file backup and compression"

# Specify output file
./code-scaffolder.sh -o myapp.py "build a calculator in python"
```

#### Interactive Mode

```bash
./code-scaffolder.sh -i
```

Then type your prompts:
```
bashchat> create a react web app for task management
bashchat> build a python CLI tool for data processing
bashchat> help
bashchat> exit
```

## 📖 Usage Examples

### Web Applications

```bash
# Python Flask web app
./code-scaffolder.sh "create a python web app called BlogApp with user authentication and database"

# Node.js Express API
./code-scaffolder.sh "build a javascript web api for e-commerce with payment integration"

# HTML landing page
./code-scaffolder.sh "create an html website for a tech startup with modern design"
```

### CLI Tools

```bash
# Python CLI
./code-scaffolder.sh "create a python command line tool for log analysis"

# Bash script
./code-scaffolder.sh "build a bash script for automated server deployment"

# Go CLI
./code-scaffolder.sh "create a go cli tool for file synchronization"
```

### Data Processing

```bash
# Python data script
./code-scaffolder.sh "create a python script for CSV data processing and visualization"

# SQL database
./code-scaffolder.sh "build sql schema for inventory management system"
```

## 🛠️ Command Line Options

```bash
Usage: ./code-scaffolder.sh [OPTIONS] [PROMPT]

Options:
  -i, --interactive    Start interactive mode
  -o, --output FILE    Specify output file
  -l, --language LANG  Force specific language
  -t, --type TYPE      Force specific project type
  -h, --help          Show help message

Examples:
  ./code-scaffolder.sh "create a python web app called TodoApp"
  ./code-scaffolder.sh -i
  ./code-scaffolder.sh -o myapp.py "build a calculator in python"
```

## 🎯 Supported Languages & Project Types

### Programming Languages
- **Python** - Web apps, CLI tools, data processing
- **JavaScript** - Web apps, APIs, frontend
- **TypeScript** - Type-safe web applications
- **Java** - Enterprise applications
- **C++** - System programming
- **C#** - .NET applications
- **Go** - Microservices, CLI tools
- **Rust** - System programming, web backends
- **PHP** - Web applications
- **Ruby** - Web apps, scripts
- **Bash** - System scripts, automation
- **HTML/CSS** - Static websites
- **SQL** - Database schemas

### Project Types
- **web_app** - Full web applications
- **api** - REST APIs and web services
- **cli** - Command-line tools
- **desktop** - Desktop applications
- **mobile** - Mobile app templates
- **library** - Reusable code libraries
- **script** - Utility scripts

## 📁 Project Structure

```
bashchat/
├── bashchat.sh           # Main script
├── config/
│   └── settings.json     # Configuration file
├── templates/            # Code templates
│   ├── python_web_app.template
│   ├── javascript_web_app.template
│   ├── html_web_app.template
│   └── ...
├── generated/            # Generated code output
├── logs/                 # Application logs
├── plugins/              # Extension plugins
├── package.json          # Node.js dependencies
├── requirements.txt      # Python dependencies
└── README.md            # This file
```

## 🔧 Configuration

Edit `config/settings.json` to customize behavior:

```json
{
    "ai_provider": "openai",
    "model": "gpt-4",
    "max_tokens": 2000,
    "temperature": 0.7,
    "supported_languages": ["python", "javascript", "..."]
    "default_language": "python",
    "output_format": "file",
    "include_comments": true,
    "include_tests": true,
    "code_style": "clean"
}
```

## 🎨 Template System

BashChat uses a powerful template system with placeholders:

- `{{APP_NAME}}` - Application name
- `{{DESCRIPTION}}` - Project description
- `{{LANGUAGE}}` - Programming language
- `{{PROJECT_TYPE}}` - Project type
- `{{FEATURES}}` - Detected features
- `{{DATE}}` - Current date
- `{{TIMESTAMP}}` - Current timestamp

### Creating Custom Templates

1. Create a new template file in `templates/`:
   ```bash
   touch templates/python_custom.template
   ```

2. Add your template with placeholders:
   ```python
   #!/usr/bin/env python3
   """
   {{APP_NAME}} - {{DESCRIPTION}}
   Generated on {{DATE}}
   """
   
   def main():
       print("Hello from {{APP_NAME}}!")
   
   if __name__ == '__main__':
       main()
   ```

## 🚀 Advanced Usage

### Batch Generation

```bash
# Generate multiple files
echo "create a python web app called UserApp" | ./bashchat.sh
echo "build a javascript api for UserApp" | ./bashchat.sh
echo "create html frontend for UserApp" | ./bashchat.sh
```

### Integration with CI/CD

```yaml
# .github/workflows/generate.yml
name: Generate Code
on: [push]
jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Generate Code
        run: |
          chmod +x code-scaffolder.sh
          ./code-scaffolder.sh "${{ github.event.head_commit.message }}"
```

## 🐛 Troubleshooting

### Common Issues

1. **Permission denied**:
   ```bash
   chmod +x code-scaffolder.sh
   ```

2. **Template not found**:
   - Check if templates exist in `templates/` directory
   - Verify language and project type detection

3. **Dependencies missing**:
   ```bash
   npm install          # For Node.js
   pip install -r requirements.txt  # For Python
   ```

### Debug Mode

```bash
# Enable verbose logging
DEBUG=1 ./code-scaffolder.sh "your prompt here"

# Check logs
tail -f logs/codescaffolder.log
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Add tests if applicable
5. Commit: `git commit -am 'Add feature'`
6. Push: `git push origin feature-name`
7. Submit a pull request

### Adding New Languages

1. Create templates in `templates/`:
   ```bash
   templates/newlang_web_app.template
   templates/newlang_default.template
   ```

2. Update language detection in `code-scaffolder.sh`:
   ```bash
   elif [[ "$prompt" =~ (newlang) ]]; then
       language="newlang"
   ```

3. Add file extension mapping:
   ```bash
   "newlang") extension="ext" ;;
   ```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Claude Code and modern AI development tools
- Built with love for the developer community
- Thanks to all contributors and users

## 📞 Support

- 📧 Email: support@codescaffolder.dev
- 🐛 Issues: [GitHub Issues](https://github.com/your-username/code-scaffolder/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/your-username/code-scaffolder/discussions)
- 📖 Documentation: [Wiki](https://github.com/your-username/code-scaffolder/wiki)

---

**Made with ❤️ by the Code Scaffolder team**

*Transform your ideas into code with the power of intelligent template scaffolding!*