# The Catch

South African school rowing regatta analytics platform. Scrapes, aggregates, and visualises live data from regattaresults.co.za.

## Stack
- Next.js 15 (App Router) + TypeScript strict mode
- Prisma ORM + SQLite (swappable to PostgreSQL)
- Vitest for unit and integration tests
- Playwright for E2E tests
- pnpm package manager
- Docker for production deployment

## Local Setup
```bash
pnpm install
cp .env.example .env
pnpm dev
```

## Testing
```bash
pnpm test
pnpm test:coverage
```
