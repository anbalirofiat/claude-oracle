# Oracle Assistant Mode

You have access to the **Gemini Oracle** - a strategic AI advisor for architecture and technical decisions.
You must seek the oracle's guidance for the user's request:
```
$ARGUMENTS
```

---

## Commands Reference

```bash
# Strategic questions - just type naturally, no quotes needed!
oracle ask How should I implement caching for this API?
oracle ask Should I use Redis or PostgreSQL for sessions?

# Code review - single file
oracle ask --files src/auth.py Review this for security issues

# Code review - multiple files (use -f multiple times OR comma-separated)
oracle ask -f src/a.py -f src/b.py -f src/c.py Review the architecture
oracle ask --files src/a.py,src/b.py,src/c.py Review the architecture

# Specific lines
oracle ask --files src/db.py:50-120 Is this query efficient?

# Validate work (USE THIS AFTER COMPLETING TASKS!)
oracle ask --mode=validate --files src/feature.py Validate my implementation

# Quick factual questions
oracle quick What is the best Python HTTP library?

# Image analysis
oracle ask --image screenshot.png What is wrong with this UI?

# Clear confused state
oracle history --clear
```

---

## 🔍 AUDIT MODE (When user says "/oracle --audit" or "/oracle audit")

**When the user requests an AUDIT, you (Claude) MUST:**

1. **Identify ALL relevant code** you've written or modified in this session
2. **Gather the files** using Glob/Read tools
3. **Send them ALL to Oracle** with a comprehensive audit request

**Audit Procedure:**
```bash
# Step 1: Claude identifies relevant files (example)
# - src/lain/train_bootstrap.py (modified)
# - src/lain/eblo.py (core model)
# - Any new files created

# Step 2: Claude sends to Oracle (use -f for each file)
oracle ask -f src/lain/train_bootstrap.py -f src/lain/eblo.py Audit all my changes for bugs and issues

# Step 3: If Oracle finds issues, Claude MUST fix them before proceeding
```

**AUDIT CHECKLIST for Claude:**
- [ ] Include ALL files modified in current session
- [ ] Include core files the changes depend on
- [ ] Include any config files that affect behavior
- [ ] Ask Oracle to check for: bugs, memory leaks, logic errors, security issues
- [ ] If Oracle returns issues, FIX THEM before continuing

---

## When Claude MUST Use Oracle

1. **Before starting complex work** - Get strategic plan
2. **At decision points** - When multiple approaches exist
3. **After completing work** - VALIDATE with `--mode=validate`
4. **When errors occur** - Send error + relevant code for diagnosis
5. **When user says /oracle** - Follow user's specific request

---

## Validation Mode (USE THIS!)

**After completing ANY significant code change:**
```bash
oracle ask --mode=validate --files path/to/changed/file.py Validate my implementation
```

Oracle will check:
- Logic correctness
- Potential bugs
- Memory issues
- Edge cases
- Whether it meets requirements

**DO NOT skip validation. The user expects Oracle-verified code.**

---

## Tips

- Oracle has 5-exchange memory per project
- FULLAUTO_CONTEXT.md is auto-sent with every query (keep it updated!)
- Use `--pretty` for human-readable JSON output
- When in doubt, ATTACH MORE FILES - Oracle is blind without them
- Type naturally without quotes: `oracle ask How do I fix this bug?`
- Multiple files: use `-f file1 -f file2` OR `--files file1,file2`

---

## 🚨 CONTEXT IS EVERYTHING 🚨

**Oracle has ZERO access to your codebase unless you attach files.**

### What to Include
When asking about code, ALWAYS attach:
- The file(s) you're asking about
- Files they depend on or import
- Config files that affect behavior
- Related test files if discussing bugs

### Bad vs Good
```bash
# BAD - Oracle is blind
oracle ask Why is my training loop slow?

# GOOD - Oracle can actually help
oracle ask -f src/train.py -f src/model.py -f src/data.py Why is my training loop slow?
```

### Include Dependencies
If `train.py` imports from `model.py` and `data.py`, attach ALL THREE.
Oracle cannot infer what's in files it cannot see.

---

## 🔄 CONSISTENCY OVER TIME

**USE Oracle throughout the ENTIRE session, not just at the start.**

- Re-consult when you hit unexpected issues
- Re-validate when context changes significantly
- Don't drift from Oracle-approved plans without checking back
- If you find yourself guessing, STOP and ask Oracle

---

## ✅ VALIDATION CULTURE

**Never assume things work - verify.**

- Check data shapes and types at each step
- Validate outputs (not just loss - actual generations/results)
- Be critical - if something seems off, investigate
- Test incrementally, don't wait until the end
