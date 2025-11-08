#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR=".claude"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

print_success() {
  echo -e "${GREEN}SUCCESS:${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_info() {
  echo -e "${YELLOW}→${NC} $1"
}

show_usage() {
  cat << EOF
Usage: ./setup.sh [OPTIONS]

Initialize Claude Code configuration for your project.

OPTIONS:
  --interactive          Guided setup with questions
  --preset <name>        Use a predefined configuration
  --stack <list>         Comma-separated list of technologies
  --help                 Show this help message

PRESETS:
  minimal                Core components only (default)
  nextjs-full            Complete Next.js setup with all skills
  stripe-commerce        E-commerce with Stripe + Next.js
  fullstack-saas         Next.js + Stripe + Supabase + DevOps
  react-focused          React skills with quality hooks
  devops-complete        All DevOps skills + workflows + hooks

STACK OPTIONS:
  Frameworks: next, react, bun
  Integration: stripe, supabase, shelby, resend
  Visualization: d3
  DevOps: devops, hooks

EXAMPLES:
  ./setup.sh --interactive
  ./setup.sh --preset nextjs-full
  ./setup.sh --stack next,stripe,supabase
  ./setup.sh --preset fullstack-saas

EOF
}

detect_framework() {
  print_header "Detecting Project Framework"

  DETECTED=""

  if [ -f "package.json" ]; then
    if grep -q "\"next\"" package.json; then
      DETECTED="Next.js"
      FRAMEWORK="next"
    elif grep -q "\"react\"" package.json; then
      DETECTED="React"
      FRAMEWORK="react"
    elif grep -q "\"bun\"" package.json; then
      DETECTED="Bun"
      FRAMEWORK="bun"
    fi
  fi

  if [ -n "$DETECTED" ]; then
    print_success "Detected: $DETECTED"
  else
    print_info "No framework detected (package.json not found or framework not recognized)"
    FRAMEWORK="none"
  fi
}

detect_integrations() {
  print_header "Detecting Integrations"

  INTEGRATIONS=()

  if [ -f "package.json" ]; then
    if grep -q "stripe" package.json; then
      print_success "Detected: Stripe"
      INTEGRATIONS+=("stripe")
    fi

    if grep -q "supabase" package.json; then
      print_success "Detected: Supabase"
      INTEGRATIONS+=("supabase")
    fi

    if grep -q "@shelby" package.json || grep -q "shelby-sdk" package.json; then
      print_success "Detected: Shelby Protocol"
      INTEGRATIONS+=("shelby")
    fi

    if grep -q "resend" package.json; then
      print_success "Detected: Resend"
      INTEGRATIONS+=("resend")
    fi

    if grep -q "d3" package.json; then
      print_success "Detected: D3.js"
      INTEGRATIONS+=("d3")
    fi
  fi

  if [ ${#INTEGRATIONS[@]} -eq 0 ]; then
    print_info "No integrations detected"
  fi
}

copy_preset() {
  local preset=$1

  print_header "Applying Preset: $preset"

  case "$preset" in
    minimal)
      print_info "Using core components only (already configured)"
      ;;

    nextjs-full)
      print_info "Copying Next.js skills..."
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/next" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/react" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      print_success "Next.js skills enabled"
      ;;

    stripe-commerce)
      print_info "Copying e-commerce skills..."
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/next" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/stripe" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/react" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      print_success "E-commerce skills enabled"
      ;;

    fullstack-saas)
      print_info "Copying full-stack SaaS skills..."
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/next" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/react" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/stripe" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/supabase" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/devops" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      print_success "Full-stack SaaS skills enabled"
      ;;

    react-focused)
      print_info "Copying React skills..."
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/react" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      print_success "React skills enabled"
      ;;

    devops-complete)
      print_info "Copying DevOps skills..."
      cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/devops" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
      print_success "DevOps skills enabled"
      ;;

    *)
      print_error "Unknown preset: $preset"
      exit 1
      ;;
  esac
}

copy_stack_skills() {
  local stack=$1

  print_header "Enabling Stack: $stack"

  IFS=',' read -ra TECHS <<< "$stack"

  for tech in "${TECHS[@]}"; do
    tech=$(echo "$tech" | xargs)

    case "$tech" in
      next|nextjs)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/next" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/next" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "Next.js skills enabled"
        fi
        ;;
      react)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/react" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/react" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "React skills enabled"
        fi
        ;;
      bun)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/bun" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/bun" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "Bun skills enabled"
        fi
        ;;
      stripe)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/stripe" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/stripe" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "Stripe skills enabled"
        fi
        ;;
      supabase)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/supabase" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/supabase" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "Supabase skills enabled"
        fi
        ;;
      shelby)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/shelby" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/shelby" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "Shelby skills enabled"
        fi
        ;;
      resend)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/resend" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/resend" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "Resend skills enabled"
        fi
        ;;
      d3)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/d3" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/d3" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "D3 skills enabled"
        fi
        ;;
      devops)
        if [ -d "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/devops" ]; then
          cp -r "$SCRIPT_DIR/$CLAUDE_DIR/examples/skills/devops" "$CLAUDE_DIR/core/skills/" 2>/dev/null || true
          print_success "DevOps skills enabled"
        fi
        ;;
      hooks)
        print_info "To enable hooks, run: /enable-hook <preset>"
        print_info "Available presets: quality-focused, security-focused, react-focused, all"
        ;;
      *)
        print_error "Unknown technology: $tech"
        ;;
    esac
  done
}

interactive_setup() {
  print_header "Claude Code Interactive Setup"

  echo "This wizard will help you configure Claude Code for your project."
  echo ""

  detect_framework
  detect_integrations

  echo ""
  echo "What would you like to enable?"
  echo ""
  echo "1) Use detected configuration (auto-enable based on package.json)"
  echo "2) Choose a preset configuration"
  echo "3) Select technologies manually"
  echo "4) Minimal setup (core only)"
  echo ""
  read -p "Enter choice [1-4]: " choice

  case $choice in
    1)
      if [ "$FRAMEWORK" != "none" ]; then
        copy_stack_skills "$FRAMEWORK"
      fi

      if [ ${#INTEGRATIONS[@]} -gt 0 ]; then
        stack_list=$(IFS=,; echo "${INTEGRATIONS[*]}")
        copy_stack_skills "$stack_list"
      fi
      ;;

    2)
      echo ""
      echo "Available presets:"
      echo "1) nextjs-full      - Complete Next.js setup"
      echo "2) stripe-commerce  - E-commerce with Stripe"
      echo "3) fullstack-saas   - Next.js + Stripe + Supabase + DevOps"
      echo "4) react-focused    - React development"
      echo "5) devops-complete  - DevOps automation"
      echo ""
      read -p "Enter preset number [1-5]: " preset_choice

      case $preset_choice in
        1) copy_preset "nextjs-full" ;;
        2) copy_preset "stripe-commerce" ;;
        3) copy_preset "fullstack-saas" ;;
        4) copy_preset "react-focused" ;;
        5) copy_preset "devops-complete" ;;
        *) print_error "Invalid choice" ; exit 1 ;;
      esac
      ;;

    3)
      echo ""
      echo "Enter technologies (comma-separated):"
      echo "Available: next, react, bun, stripe, supabase, shelby, resend, d3, devops"
      echo ""
      read -p "Technologies: " manual_stack
      copy_stack_skills "$manual_stack"
      ;;

    4)
      print_info "Using minimal configuration (core only)"
      ;;

    *)
      print_error "Invalid choice"
      exit 1
      ;;
  esac

  echo ""
  read -p "Would you like to enable quality hooks? [y/N]: " enable_hooks

  if [[ "$enable_hooks" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Hook presets:"
    echo "1) quality-focused   - TypeScript, lint, format, code quality"
    echo "2) security-focused  - Security scans, architecture checks"
    echo "3) react-focused     - React best practices, accessibility"
    echo "4) all              - Enable all hooks"
    echo "5) manual           - I'll enable hooks manually later"
    echo ""
    read -p "Enter preset number [1-5]: " hook_choice

    case $hook_choice in
      1) print_info "After setup, run: /enable-hook quality-focused" ;;
      2) print_info "After setup, run: /enable-hook security-focused" ;;
      3) print_info "After setup, run: /enable-hook react-focused" ;;
      4) print_info "After setup, run: /enable-hook all" ;;
      5) print_info "Enable hooks later with: /enable-hook <name>" ;;
    esac
  fi
}

setup_project_directory() {
  print_header "Setting Up Project Directory"

  if [ -d "$CLAUDE_DIR" ]; then
    print_info "Found existing .claude/ directory"
    read -p "Overwrite? [y/N]: " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
      print_error "Setup cancelled"
      exit 1
    fi
    rm -rf "$CLAUDE_DIR"
  fi

  print_info "Copying .claude/ directory..."
  cp -r "$SCRIPT_DIR/$CLAUDE_DIR" . 2>/dev/null || true

  mkdir -p "$CLAUDE_DIR/core/skills"
  mkdir -p "$CLAUDE_DIR/core/agents"

  print_success "Project directory created"
}

generate_env_example() {
  print_header "Generating Environment Template"

  cat > .env.example << 'EOF'
# Claude Code Configuration
# Copy this file to .env and fill in your values

# Framework Detection (auto-detected from package.json)
# Options: nextjs, react, bun, django, rails, none
FRAMEWORK=

# Feature Flags
ENABLE_STRIPE=false
ENABLE_SUPABASE=false
ENABLE_D3=false

# Hook Configuration
# Options: quality-focused, security-focused, react-focused, all, off
HOOKS_PRESET=off

# API Keys (if needed for integrations)
# STRIPE_SECRET_KEY=
# SUPABASE_URL=
# SUPABASE_ANON_KEY=
EOF

  print_success "Created .env.example"
  print_info "Copy .env.example to .env and configure as needed"
}

show_summary() {
  print_header "Setup Complete"

  echo "Your Claude Code configuration is ready!"
  echo ""
  echo "Next steps:"
  echo ""
  echo "1. Review your configuration:"
  echo "   cd .claude/ && ls -la"
  echo ""
  echo "2. Validate setup:"
  echo "   /self-test"
  echo ""
  echo "3. Configure environment (optional):"
  echo "   cp .env.example .env"
  echo "   # Edit .env with your values"
  echo ""
  echo "4. Enable hooks (optional):"
  echo "   /enable-hook <preset>"
  echo ""
  echo "5. Start coding with Claude:"
  echo "   claude"
  echo ""
  print_success "All done!"
}

# Main execution
main() {
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_usage
    exit 0
  fi

  setup_project_directory

  if [ "$1" = "--interactive" ]; then
    interactive_setup
  elif [ "$1" = "--preset" ] && [ -n "$2" ]; then
    copy_preset "$2"
  elif [ "$1" = "--stack" ] && [ -n "$2" ]; then
    copy_stack_skills "$2"
  else
    detect_framework
    detect_integrations

    if [ "$FRAMEWORK" != "none" ] || [ ${#INTEGRATIONS[@]} -gt 0 ]; then
      echo ""
      echo "Detected configuration:"
      if [ "$FRAMEWORK" != "none" ]; then
        echo "  Framework: $DETECTED"
      fi
      if [ ${#INTEGRATIONS[@]} -gt 0 ]; then
        echo "  Integrations: ${INTEGRATIONS[*]}"
      fi
      echo ""
      read -p "Auto-configure based on detection? [Y/n]: " auto_config

      if [[ ! "$auto_config" =~ ^[Nn]$ ]]; then
        if [ "$FRAMEWORK" != "none" ]; then
          copy_stack_skills "$FRAMEWORK"
        fi

        if [ ${#INTEGRATIONS[@]} -gt 0 ]; then
          stack_list=$(IFS=,; echo "${INTEGRATIONS[*]}")
          copy_stack_skills "$stack_list"
        fi
      else
        interactive_setup
      fi
    else
      print_info "No framework detected. Using interactive setup..."
      interactive_setup
    fi
  fi

  generate_env_example
  show_summary
}

main "$@"
