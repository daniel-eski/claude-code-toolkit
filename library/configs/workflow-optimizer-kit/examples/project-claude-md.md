# Example Project-Specific CLAUDE.md

This file demonstrates how to create project-specific instructions that supplement the user-level CLAUDE.md. Save this as `.claude/CLAUDE.md` or `CLAUDE.md` in your project root.

---

```markdown
# Project: [Your Project Name]

## Overview
[Brief description of what this project does]

## Tech Stack
- **Frontend**: [e.g., React 18 / TypeScript / Tailwind CSS]
- **Backend**: [e.g., Node.js / Express / Prisma]
- **Database**: [e.g., PostgreSQL / Redis for caching]
- **Testing**: [e.g., Jest / React Testing Library / Playwright]
- **Infrastructure**: [e.g., AWS / Docker / Kubernetes]

## Project Structure
```
src/
├── components/     # React components
├── hooks/          # Custom React hooks
├── services/       # API and business logic
├── utils/          # Shared utilities
├── types/          # TypeScript type definitions
└── __tests__/      # Test files mirror src/ structure
```

## Coding Conventions

### General
- Use TypeScript strict mode
- Prefer functional programming patterns
- Maximum file length: 300 lines (split if longer)

### React Components
- Use functional components with hooks
- Props interface named `[ComponentName]Props`
- Co-locate styles using CSS modules or styled-components

### API Endpoints
- REST conventions with kebab-case paths
- Always return `{ data, error, metadata }` envelope
- Use HTTP status codes correctly (201 for created, 204 for no content, etc.)

### Database
- Use snake_case for column names
- Always include created_at and updated_at timestamps
- Foreign keys named `[table]_id`

### Testing
- Minimum 80% coverage for new code
- Test file naming: `[filename].test.ts`
- Use descriptive test names: "should [expected behavior] when [condition]"

## Common Commands
```bash
npm run dev          # Start development server (port 3000)
npm run build        # Production build
npm test             # Run test suite
npm run test:watch   # Run tests in watch mode
npm run lint         # Check code style
npm run db:migrate   # Run database migrations
npm run db:seed      # Seed database with test data
```

## Environment Variables
All environment variables are defined in `.env.example`. Key variables:
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection for caching
- `JWT_SECRET` - Secret for JWT token signing
- `API_BASE_URL` - Base URL for external API calls

## Important Files
- `src/config/index.ts` - Centralized configuration
- `src/middleware/auth.ts` - Authentication middleware
- `src/services/api.ts` - API client configuration
- `prisma/schema.prisma` - Database schema

## Known Issues / Tech Debt
- [ ] Legacy auth system in `/src/legacy/` - do not modify, scheduled for removal
- [ ] Some components still use class syntax - convert when touching them
- [ ] Rate limiting not implemented on public endpoints

## Deployment Notes
- Staging auto-deploys from `develop` branch
- Production requires manual approval after staging tests pass
- Database migrations run automatically on deploy
```

---

## Usage Notes

1. **Place in project root**: Save as `.claude/CLAUDE.md` (preferred) or `CLAUDE.md`

2. **Keep it current**: Update when conventions change

3. **Team sharing**: Commit to version control so all team members benefit

4. **Layering**: This supplements (doesn't replace) your user-level `~/.claude/CLAUDE.md`

5. **Local overrides**: For personal preferences, use `CLAUDE.local.md` (gitignored)
