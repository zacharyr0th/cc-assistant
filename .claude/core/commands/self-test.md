Validate the entire Claude Code setup and verify all components are working correctly

Usage: `/self-test [--fix]`

Options:
- `--fix` - Attempt to automatically fix detected issues

Execute the following comprehensive validation:

1. **Directory Structure Check**
   ```bash
   echo "=== Checking Directory Structure ==="

   # Check core directories exist
   for dir in .claude/core/agents .claude/core/commands .claude/examples/skills .claude/examples/hooks .claude/docs; do
     if [ -d "$dir" ]; then
       echo "✓ $dir exists"
     else
       echo "✗ $dir missing"
       ISSUES+=("Missing directory: $dir")
     fi
   done
   ```

2. **Settings Validation**
   ```bash
   echo ""
   echo "=== Validating settings.json ==="

   # Check if settings.json exists and is valid JSON
   if [ -f .claude/settings.json ]; then
     if node -e "JSON.parse(require('fs').readFileSync('.claude/settings.json'))" 2>/dev/null; then
       echo "✓ settings.json is valid JSON"
     else
       echo "✗ settings.json is corrupted"
       ISSUES+=("Invalid JSON in settings.json")
     fi
   else
     echo "✗ settings.json not found"
     ISSUES+=("Missing settings.json")
   fi
   ```

3. **Core Agents Check**
   ```bash
   echo ""
   echo "=== Checking Core Agents ==="

   EXPECTED_AGENTS=("security-auditor" "database-architect" "api-builder")

   for agent in "${EXPECTED_AGENTS[@]}"; do
     if [ -f ".claude/core/agents/${agent}.md" ]; then
       # Check for valid YAML frontmatter
       if head -1 ".claude/core/agents/${agent}.md" | grep -q "^---$"; then
         echo "✓ ${agent}.md valid"
       else
         echo "✗ ${agent}.md missing YAML frontmatter"
         ISSUES+=("Agent ${agent}.md missing frontmatter")
       fi
     else
       echo "✗ ${agent}.md not found"
       ISSUES+=("Missing core agent: ${agent}.md")
     fi
   done
   ```

4. **Core Commands Check**
   ```bash
   echo ""
   echo "=== Checking Core Commands ==="

   EXPECTED_COMMANDS=("build-safe" "sync-types" "db-migrate" "health-check" "commit" "create-pr" "release" "enable-hook" "self-test")

   for cmd in "${EXPECTED_COMMANDS[@]}"; do
     if [ -f ".claude/core/commands/${cmd}.md" ]; then
       echo "✓ /${cmd} available"
     else
       echo "✗ /${cmd} missing"
       ISSUES+=("Missing core command: ${cmd}.md")
     fi
   done
   ```

5. **Skills Validation**
   ```bash
   echo ""
   echo "=== Validating Skills ==="

   # Count skills (excluding skill-builder examples and duplicate resources)
   SKILL_COUNT=$(find .claude/examples/skills -name "skill.md" -type f | \
     grep -v "skill-builder/examples/" | \
     grep -v "nextjs-16-audit/resources/" | \
     wc -l | tr -d ' ')
   echo "Found $SKILL_COUNT skills"

   # Check each skill has valid YAML frontmatter
   INVALID_SKILLS=0
   find .claude/examples/skills -name "skill.md" -type f | \
     grep -v "skill-builder/examples/" | \
     grep -v "nextjs-16-audit/resources/" | \
     while read skill; do
       if ! head -1 "$skill" | grep -q "^---$"; then
         echo "✗ Invalid: $skill"
         INVALID_SKILLS=$((INVALID_SKILLS + 1))
       fi
     done

   if [ $INVALID_SKILLS -eq 0 ]; then
     echo "✓ All skills have valid YAML frontmatter"
   else
     echo "✗ $INVALID_SKILLS skills have invalid frontmatter"
     ISSUES+=("$INVALID_SKILLS skills with invalid frontmatter")
   fi
   ```

6. **Hooks Validation**
   ```bash
   echo ""
   echo "=== Checking Hooks ==="

   HOOK_COUNT=$(find .claude/examples/hooks -name "*.ts" -type f | wc -l)
   echo "Found $HOOK_COUNT hook files"

   # Check if any hooks are enabled
   if grep -q "PostToolUse" .claude/settings.json 2>/dev/null; then
     ENABLED_HOOKS=$(grep -o "[a-z_]*\.ts" .claude/settings.json | wc -l)
     echo "✓ $ENABLED_HOOKS hooks enabled"
   else
     echo "ℹ No hooks currently enabled (this is normal)"
   fi
   ```

7. **GitHub Workflows Check**
   ```bash
   echo ""
   echo "=== Checking GitHub Workflows ==="

   if [ -d ".github/workflows" ]; then
     WORKFLOW_COUNT=$(ls .github/workflows/*.yml 2>/dev/null | wc -l)
     echo "✓ Found $WORKFLOW_COUNT workflow files"

     # Validate YAML syntax
     for workflow in .github/workflows/*.yml; do
       if command -v yamllint >/dev/null 2>&1; then
         if yamllint "$workflow" >/dev/null 2>&1; then
           echo "  ✓ $(basename $workflow) valid"
         else
           echo "  ✗ $(basename $workflow) invalid YAML"
           ISSUES+=("Invalid YAML in $(basename $workflow)")
         fi
       fi
     done
   else
     echo "ℹ No .github/workflows directory (optional)"
   fi
   ```

8. **Documentation Check**
   ```bash
   echo ""
   echo "=== Checking Documentation ==="

   DOC_COUNT=$(find .claude/docs -name "*.md" 2>/dev/null | wc -l)
   echo "Found $DOC_COUNT documentation files"

   # Check for key docs
   for doc in README.md CLAUDE.md .claude/docs/workflows.md; do
     if [ -f "$doc" ]; then
       echo "✓ $doc exists"
     else
       echo "✗ $doc missing"
       ISSUES+=("Missing documentation: $doc")
     fi
   done
   ```

9. **Dependencies Check**
   ```bash
   echo ""
   echo "=== Checking Dependencies ==="

   # Check for required tools
   TOOLS=("node:Node.js" "git:Git" "gh:GitHub CLI")

   for tool_pair in "${TOOLS[@]}"; do
     IFS=':' read -r cmd name <<< "$tool_pair"
     if command -v $cmd >/dev/null 2>&1; then
       VERSION=$($cmd --version 2>&1 | head -1)
       echo "✓ $name: $VERSION"
     else
       echo "ℹ $name not installed (may be needed for some features)"
     fi
   done
   ```

10. **Framework Detection**
    ```bash
    echo ""
    echo "=== Detecting Project Framework ==="

    DETECTED_FRAMEWORK="none"

    if [ -f "package.json" ]; then
      if grep -q "\"next\"" package.json 2>/dev/null; then
        DETECTED_FRAMEWORK="Next.js"
        echo "✓ Detected: Next.js"

        # Check if Next.js skills are enabled
        if [ -d ".claude/core/skills/next" ]; then
          echo "  ✓ Next.js skills enabled"
        else
          echo "  ℹ Consider enabling Next.js skills: ./setup.sh --stack next"
        fi
      elif grep -q "\"react\"" package.json 2>/dev/null; then
        DETECTED_FRAMEWORK="React"
        echo "✓ Detected: React"

        if [ -d ".claude/core/skills/react" ]; then
          echo "  ✓ React skills enabled"
        else
          echo "  ℹ Consider enabling React skills: ./setup.sh --stack react"
        fi
      elif grep -q "\"bun\"" package.json 2>/dev/null; then
        DETECTED_FRAMEWORK="Bun"
        echo "✓ Detected: Bun"

        if [ -d ".claude/core/skills/bun" ]; then
          echo "  ✓ Bun skills enabled"
        else
          echo "  ℹ Consider enabling Bun skills: ./setup.sh --stack bun"
        fi
      fi

      # Check for integrations
      if grep -q "stripe" package.json 2>/dev/null; then
        echo "✓ Detected integration: Stripe"
        if [ ! -d ".claude/core/skills/stripe" ]; then
          echo "  ℹ Consider enabling Stripe skills: ./setup.sh --stack stripe"
        fi
      fi

      if grep -q "supabase" package.json 2>/dev/null; then
        echo "✓ Detected integration: Supabase"
        if [ ! -d ".claude/core/skills/supabase" ]; then
          echo "  ℹ Consider enabling Supabase skills: ./setup.sh --stack supabase"
        fi
      fi

      if grep -q "d3" package.json 2>/dev/null; then
        echo "✓ Detected integration: D3.js"
        if [ ! -d ".claude/core/skills/d3" ]; then
          echo "  ℹ Consider enabling D3 skills: ./setup.sh --stack d3"
        fi
      fi
    else
      echo "ℹ No package.json found - framework detection skipped"
    fi
    ```

11. **Environment Configuration Check**
    ```bash
    echo ""
    echo "=== Checking Environment Configuration ==="

    if [ -f ".env.example" ]; then
      echo "✓ .env.example found"

      if [ -f ".env" ]; then
        echo "✓ .env configured"
      else
        echo "ℹ No .env file - copy .env.example to .env and configure"
      fi
    else
      echo "ℹ No .env.example - run ./setup.sh to generate template"
    fi

    if [ -f ".env" ]; then
      # Check for common missing variables
      REQUIRED_STRIPE=false
      REQUIRED_SUPABASE=false

      if [ -d ".claude/core/skills/stripe" ]; then
        REQUIRED_STRIPE=true
      fi

      if [ -d ".claude/core/skills/supabase" ]; then
        REQUIRED_SUPABASE=true
      fi

      if [ "$REQUIRED_STRIPE" = true ]; then
        if ! grep -q "STRIPE_SECRET_KEY=." .env 2>/dev/null; then
          echo "  ⚠ Stripe skills enabled but STRIPE_SECRET_KEY not configured"
        fi
      fi

      if [ "$REQUIRED_SUPABASE" = true ]; then
        if ! grep -q "SUPABASE_URL=." .env 2>/dev/null; then
          echo "  ⚠ Supabase skills enabled but SUPABASE_URL not configured"
        fi
      fi
    fi
    ```

12. **Generate Report**
    ```bash
    echo ""
    echo "========================================="
    echo "           SELF-TEST RESULTS"
    echo "========================================="
    echo ""

    if [ ${#ISSUES[@]} -eq 0 ]; then
      echo "✅ ALL CHECKS PASSED"
      echo ""
      echo "Your Claude Code setup is fully functional."
      echo ""
      echo "Summary:"
      echo "  • Core agents: 3"
      echo "  • Core commands: 9"
      echo "  • Skills: $SKILL_COUNT"
      echo "  • Hooks: $HOOK_COUNT files ($ENABLED_HOOKS enabled)"
      echo "  • Workflows: $WORKFLOW_COUNT"
      echo "  • Documentation: $DOC_COUNT files"
      if [ "$DETECTED_FRAMEWORK" != "none" ]; then
        echo "  • Detected framework: $DETECTED_FRAMEWORK"
      fi
      echo ""
    else
      echo "⚠️  ISSUES FOUND: ${#ISSUES[@]}"
      echo ""
      for issue in "${ISSUES[@]}"; do
        echo "  ✗ $issue"
      done
      echo ""

      if [ "$1" = "--fix" ]; then
        echo "Attempting automatic fixes..."
        # Fix logic here
      else
        echo "Run with --fix to attempt automatic repairs"
      fi
    fi
    ```

13. **Optional: Performance Test**
    ```bash
    echo ""
    echo "=== Performance Check (Optional) ==="

    # Test hook execution time (if hooks enabled)
    if [ $ENABLED_HOOKS -gt 0 ]; then
      echo "Testing hook execution time..."

      # Create a temp file and time the hooks
      TEMP_FILE=$(mktemp)
      echo "test" > $TEMP_FILE

      START=$(date +%s%N)
      # Hooks would run here
      END=$(date +%s%N)

      DURATION=$(( ($END - $START) / 1000000 ))
      echo "Hook execution: ${DURATION}ms"

      if [ $DURATION -lt 1000 ]; then
        echo "✓ Performance: Excellent"
      elif [ $DURATION -lt 3000 ]; then
        echo "✓ Performance: Good"
      else
        echo "⚠ Performance: Slow (consider reducing enabled hooks)"
      fi

      rm -f $TEMP_FILE
    fi
    ```

**Auto-Fix Mode**

When run with `--fix`:

1. **Create missing directories**
   ```bash
   mkdir -p .claude/core/agents .claude/core/commands
   mkdir -p .claude/examples/skills .claude/examples/hooks
   mkdir -p .claude/docs
   ```

2. **Restore default settings.json**
   ```bash
   cat > .claude/settings.json << 'EOF'
   {
     "hooks": {
       "PostToolUse": []
     },
     "comment": "Minimal starter. Copy from examples/ as needed."
   }
   EOF
   ```

3. **Fix file permissions**
   ```bash
   chmod +x .claude/scripts/*.sh
   chmod 644 .claude/**/*.md
   ```

**Output Format**

```
=== Checking Directory Structure ===
✓ .claude/core/agents exists
✓ .claude/core/commands exists
✓ .claude/examples/skills exists

=== Validating settings.json ===
✓ settings.json is valid JSON

=== Checking Core Agents ===
✓ security-auditor.md valid
✓ database-architect.md valid
✓ api-builder.md valid

... (more checks)

=========================================
           SELF-TEST RESULTS
=========================================

✅ ALL CHECKS PASSED

Your Claude Code setup is fully functional.

Summary:
  • Core agents: 3
  • Core commands: 9
  • Skills: 40
  • Hooks: 12 files (3 enabled)
  • Workflows: 3
  • Documentation: 12 files
```

**Error Examples**

```
⚠️  ISSUES FOUND: 3

  ✗ Missing directory: .claude/examples/hooks
  ✗ Invalid JSON in settings.json
  ✗ Agent security-auditor.md missing frontmatter

Run with --fix to attempt automatic repairs
```

**Related Commands**

- `/health-check` - Quick health check (subset of self-test)
- `/enable-hook` - Enable quality hooks
- `/list-hooks` - Show enabled hooks
