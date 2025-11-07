# Supabase Expert Skill

Advanced Supabase integration specialist for building production-ready applications with PostgreSQL, Authentication, Storage, Realtime, Edge Functions, and AI/Vector features.

## What This Skill Does

This skill provides comprehensive Supabase expertise including:

- **Authentication**: Email/password, OAuth, MFA, session management
- **Database**: PostgreSQL queries, RLS policies, migrations, type generation
- **Storage**: File uploads, image transformations, CDN, security
- **Realtime**: WebSocket subscriptions, presence tracking, broadcast channels
- **Edge Functions**: Serverless Deno functions, webhooks, scheduled tasks
- **AI & Vectors**: Semantic search, embeddings, pgvector integration
- **Architecture**: Multi-tenancy, performance optimization, scaling patterns
- **Migrations**: Firebase, Parse, MongoDB, MySQL to Supabase

## Quick Start

### Basic Usage

Invoke this skill when working with Supabase:

```bash
# From Claude Code
/supabase-expert
```

The skill will:
1. Detect your framework (Next.js, React, etc.)
2. Search relevant documentation
3. Provide production-ready code examples
4. Suggest best practices and optimizations

### Example Queries

**"Set up authentication for my Next.js app"**
- Provides server/client setup
- Auth callback routes
- Protected page patterns
- Session management

**"Create a posts table with RLS"**
- Migration file with proper indexes
- Row Level Security policies
- Type-safe queries
- CRUD operations

**"Implement file upload with image transformations"**
- Upload component with progress
- RLS policies for storage
- Image optimization patterns
- CDN configuration

**"Migrate from Firebase to Supabase"**
- Complete migration plan
- Schema conversion scripts
- Data migration code
- Authentication migration

## Comprehensive Guides

This skill includes detailed guides covering all aspects of Supabase:

### 📘 [QUICKSTART.md](./guides/QUICKSTART.md)
**Rapid-fire implementations for common tasks**

- Project setup (Next.js App Router)
- Authentication patterns (email, OAuth, protected routes)
- Database & RLS with migrations
- Realtime subscriptions and presence
- Storage with uploads and transformations
- Edge Functions basics
- AI & Vector search
- Common patterns and commands

**Use this when**: You need quick, copy-paste solutions for standard Supabase features.

---

### 🔐 [RLS-PATTERNS.md](./guides/RLS-PATTERNS.md)
**Comprehensive Row Level Security guide**

- 8 essential RLS patterns (user-owned, public read, multi-tenancy, RBAC, hierarchical, time-based, conditional, delegation)
- Complete testing framework with examples
- Performance optimization strategies
- Debugging techniques and tools
- Security best practices

**Use this when**: Implementing security policies, multi-tenancy, or role-based access control.

---

### ⚡ [EDGE-FUNCTIONS.md](./guides/EDGE-FUNCTIONS.md)
**Complete Edge Functions guide**

- Authentication patterns (JWT, API keys, service role)
- Database access from functions
- HTTP patterns (validation, rate limiting, streaming)
- Third-party integrations (OpenAI, Stripe, SendGrid)
- Background jobs and cron
- Testing and debugging
- Performance optimization
- Production patterns and error handling

**Use this when**: Building serverless functions, webhooks, scheduled tasks, or API routes.

---

### 🏗️ [ARCHITECTURE.md](./guides/ARCHITECTURE.md)
**Architectural decisions and design patterns**

- When to use Edge Functions vs Database Functions
- Data modeling (multi-tenancy, normalization, JSONB)
- Security architecture (defense in depth, audit logging)
- Performance optimization (indexing, pagination, caching)
- Connection management and pooling
- Multi-region setup with read replicas
- Microservices patterns (event-driven)
- Scaling considerations and partitioning

**Use this when**: Designing system architecture, optimizing performance, or planning for scale.

---

### 🔄 [MIGRATION.md](./guides/MIGRATION.md)
**Migration guide for moving to Supabase**

- Firebase to Supabase (complete migration scripts)
- Parse to Supabase (schema mapping and data migration)
- MongoDB to Supabase (document to relational)
- MySQL/PostgreSQL to Supabase (pg_dump, scripts)
- Schema migrations with Supabase CLI
- Zero-downtime migration strategies
- Data validation and testing
- Post-migration checklist

**Use this when**: Migrating from another platform or managing database schema changes.

---

### 📦 [STORAGE.md](./guides/STORAGE.md)
**Complete storage and file handling guide**

- File upload patterns (single, multi, drag & drop)
- Security & RLS for buckets
- Image transformations (resize, quality, responsive)
- CDN and performance optimization
- Large file handling (chunked uploads, resumable)
- Video and media streaming
- Best practices (naming, metadata, cleanup)
- Advanced patterns (signed URLs, versioning)

**Use this when**: Implementing file uploads, image processing, or video streaming.

---

## Documentation Access

This skill has access to **1,985 Supabase documentation files** covering:

- **Guides**: 607 files (authentication, database, storage, realtime, functions, AI)
- **Reference**: 1,378 files (API reference, CLI commands, client libraries)

The skill automatically searches documentation based on your query and provides relevant examples.

## Advanced Features

### 1. Context-Aware Responses

The skill detects your project setup and provides framework-specific code:

- **Next.js App Router**: Server Components, Server Actions, middleware
- **Next.js Pages Router**: API routes, getServerSideProps
- **React**: Client-side patterns, hooks
- **Node.js**: Direct database access, connection pooling

### 2. Multi-Stage Documentation Search

1. **Keyword Search**: Finds relevant documentation files
2. **Context Analysis**: Examines your existing code
3. **Framework Detection**: Tailors examples to your setup
4. **Best Practices**: Suggests optimizations and security improvements

### 3. Production-Ready Patterns

All examples include:
- ✅ Type safety with TypeScript
- ✅ Error handling
- ✅ RLS policies
- ✅ Performance optimization
- ✅ Security best practices
- ✅ Testing approaches

## Common Use Cases

### Setting Up a New Project

```typescript
// The skill provides complete setup including:
- lib/supabase/server.ts (Server Component client)
- lib/supabase/client.ts (Client Component client)
- middleware.ts (Session refresh)
- Environment variables configuration
- Type generation setup
```

### Implementing Features

**Multi-Tenancy with Organizations**
```sql
-- Complete schema with RLS policies
-- Role-based permissions (owner, admin, member)
-- Helper functions for access control
-- Indexes for performance
```

**Realtime Collaboration**
```typescript
// Presence tracking
// Document subscriptions
// Broadcast channels
// Conflict resolution
```

**File Upload with Processing**
```typescript
// Upload with progress
// Image optimization
// Thumbnail generation
// Metadata storage
```

### Performance Optimization

The skill provides:
- Query optimization with EXPLAIN ANALYZE
- Index recommendations
- Caching strategies (materialized views, application cache)
- Connection pooling setup
- CDN configuration

### Security Auditing

The skill can:
- Review RLS policies
- Check for security vulnerabilities
- Suggest authentication improvements
- Validate input sanitization
- Recommend audit logging

## Templates & Scripts

### Code Templates

Located in `templates/`:
- `auth-setup.ts` - Complete authentication implementation
- More templates available through the guides

### Helper Scripts

Located in `scripts/`:
- `search-docs.sh` - Search Supabase documentation locally

## Tips for Best Results

1. **Be Specific**: "Set up multi-tenant RLS for posts table" vs "help with security"

2. **Mention Your Stack**: "Using Next.js 14 App Router" helps provide framework-specific code

3. **Reference Existing Code**: "My current schema is..." allows for better integration suggestions

4. **Ask for Explanations**: "Why use Supavisor?" to understand architectural decisions

5. **Request Reviews**: "Review my RLS policies" for security auditing

## Troubleshooting

### Common Issues

**RLS Blocking Queries**
- Check policies with: `SELECT * FROM pg_policies WHERE tablename = 'your_table'`
- Test as specific user
- Use service role key for debugging (never in production!)

**Connection Pool Exhaustion**
- Use Supavisor connection pooler
- Implement connection pooling in app
- Monitor with: `SELECT count(*) FROM pg_stat_activity`

**Slow Queries**
- Use `EXPLAIN ANALYZE` to identify bottlenecks
- Add indexes on foreign keys and filter columns
- Consider materialized views for complex queries

**Type Mismatches**
- Regenerate types: `supabase gen types typescript --local > types/database.ts`
- Ensure migrations are applied
- Check for manual schema changes

## Version Information

- **Supabase**: Latest stable
- **Next.js**: 14+ App Router support
- **TypeScript**: Full type safety
- **Documentation**: 1,985 files (updated regularly)

## Related Skills

- **database-architect**: For advanced database design and Drizzle ORM
- **api-builder**: For Next.js API routes and REST patterns
- **security-auditor**: For comprehensive security audits

## Contributing

To enhance this skill:

1. Add new guides to `guides/` directory
2. Update templates in `templates/` directory
3. Add helper scripts to `scripts/` directory
4. Update this README with new sections

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase GitHub](https://github.com/supabase/supabase)
- [Supabase Discord](https://discord.supabase.com)
- [Next.js Integration Guide](https://supabase.com/docs/guides/getting-started/tutorials/with-nextjs)

---

**Last Updated**: 2025-01-06

This skill is continuously updated with the latest Supabase best practices and patterns.
