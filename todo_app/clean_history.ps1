#!/usr/bin/env pwsh
cd "C:\Users\Logesh\Documents\Todo\todo_app"

# Get all commits
$commits = git log --all --format=%H

Write-Host "Rewriting git history to remove secrets..."

# Rewrite each commit
foreach ($commit in $commits) {
    git show $commit:backend/.env 2>/dev/null | ForEach-Object {
        if ($_ -match "AIKKdypcZEGPklBQ") {
            Write-Host "Found secret in commit $($commit.Substring(0,7))"
        }
    }
}

# Use BFG if available, otherwise use filter-branch
$bfgPath = (Get-Command bfg-repo-cleaner -ErrorAction SilentlyContinue).Source
if ($bfgPath) {
    Write-Host "Using BFG Repo Cleaner..."
    & $bfgPath --replace-text credentials.txt --no-blob-protection
} else {
    Write-Host "Using git filter-branch (less safe but functional)..."
    $env:FILTER_BRANCH_SQUELCH_WARNING = 1
    git filter-branch -f `
        --env-filter `
        'if [ "$GIT_COMMIT" != "$(git rev-list --all | head -n 1)" ]; then skip=true; fi' `
        -- --all
}

Write-Host "Done!"
