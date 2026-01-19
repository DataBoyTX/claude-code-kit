# Commit, Push, and Create PR

This command commits changes, pushes to remote, and creates a pull request.

## Pre-computed Context

Current branch: `$( git branch --show-current )`
Default branch: `$( git remote show origin | grep 'HEAD branch' | cut -d' ' -f5 )`
Staged changes: `$( git diff --cached --stat )`
Unstaged changes: `$( git diff --stat )`
Untracked files: `$( git ls-files --others --exclude-standard | head -20 )`
Recent commits on this branch: `$( git log --oneline -5 )`

## Instructions

1. **Review the changes above** and understand what was modified

2. **Stage changes** if needed:
   - If there are unstaged changes that should be included, stage them with `git add`
   - Be selective — don't stage unrelated changes

3. **Create a commit** with a good message:
   - Use conventional commit format: `type(scope): description`
   - Types: feat, fix, docs, style, refactor, test, chore
   - Keep the first line under 72 characters
   - Add a body if the change needs explanation

4. **Push to remote**:
   - If this is a new branch, use `git push -u origin HEAD`
   - Otherwise, use `git push`

5. **Create a Pull Request**:
   - Use `gh pr create` with appropriate title and body
   - Title should match the commit message
   - Body should explain:
     - What changed and why
     - How to test
     - Any breaking changes
   - Add appropriate labels if applicable

6. **Report the PR URL** when done

## Commit Message Examples

```
feat(auth): add OAuth2 support for GitHub login
fix(api): handle null response from external service
docs(readme): update installation instructions
refactor(utils): extract date formatting to shared module
test(user): add integration tests for signup flow
chore(deps): update dependencies to latest versions
```
