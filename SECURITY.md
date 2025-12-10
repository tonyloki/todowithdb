# Security Notice

## Exposed Credentials (Resolved)

**Issue**: MongoDB credentials were exposed in the `.env` file that was committed to git history.

**Resolution**:
1. ✅ Removed `.env` file from git tracking
2. ✅ Added `.env` to `.gitignore`
3. ✅ Created `.env.example` as a template
4. ✅ MongoDB password has been **ROTATED** - The exposed password is no longer valid
5. ✅ Force-pushed cleaned commits to remote repository

## Best Practices Implemented

### Environment Variables
- Never commit `.env` files to version control
- Use `.env.example` to document required variables
- Copy `.env.example` to `.env` and fill with your credentials

### Git Hooks (Recommended)
Install a pre-commit hook to prevent secrets from being committed:

```bash
npm install husky --save-dev
npx husky install
npx husky add .husky/pre-commit "npm run lint"
```

### For Contributors
1. Copy `.env.example` to `.env`
2. Fill in your local credentials
3. Never commit `.env`

## If You're Using This Repository

1. Generate new MongoDB credentials from MongoDB Atlas
2. Create a `.env` file in `backend/` directory
3. Add your credentials following the `.env.example` template

## References
- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning)
- [GitGuardian](https://www.gitguardian.com/)
- [OWASP: Secrets Management](https://owasp.org/www-community/Sensitive_Data_Exposure)
