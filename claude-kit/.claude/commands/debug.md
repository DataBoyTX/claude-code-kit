# Debug Issue

Help me debug an issue in the codebase.

## Pre-computed Context

Recent changes: `$( git log --oneline -10 )`
Recent error logs: `$( tail -50 logs/*.log 2>/dev/null || echo "No log files found" )`
Running processes: `$( ps aux | grep -E "(node|npm|python)" | head -10 )`

## Debugging Framework

### 1. Gather Information

First, understand the problem:
- What is the expected behavior?
- What is the actual behavior?
- When did it start happening?
- Can it be reproduced consistently?

### 2. Isolate the Problem

Narrow down the scope:
- Which component/module is affected?
- What's the minimal reproduction case?
- Does it happen in all environments?

### 3. Form Hypotheses

Based on the symptoms, what could cause this?
- Recent code changes (check git log)
- Environment differences
- External service issues
- Data-related issues
- Race conditions / timing issues

### 4. Test Hypotheses

For each hypothesis:
1. Predict what you'd see if it's true
2. Design a test to confirm/refute
3. Execute the test
4. Interpret results

### 5. Common Debugging Commands

```bash
# Check logs
tail -f logs/app.log

# Search for error patterns
grep -r "Error" logs/

# Check environment variables
env | grep -E "(DATABASE|API|NODE)"

# Check network connectivity
curl -v http://localhost:3000/health

# Check process resources
top -p $(pgrep -f "node")

# Check disk space
df -h

# Check memory
free -m

# Database connectivity
psql $DATABASE_URL -c "SELECT 1"

# Check ports
netstat -tlnp | grep 3000
lsof -i :3000
```

### 6. Document Findings

As you debug, note:
- What you tried
- What you learned
- What worked / didn't work

## Output Format

```markdown
## Debug Report

### Problem Statement
[Clear description of the issue]

### Investigation Steps
1. [What I checked]
   - Finding: [What I found]

2. [Next thing I checked]
   - Finding: [What I found]

### Root Cause
[What caused the issue]

### Solution
[How to fix it]

### Prevention
[How to prevent this in the future]
```
