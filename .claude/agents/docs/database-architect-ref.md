# Database Architecture Reference for database-architect

## Drizzle ORM - Core Patterns

### Philosophy

**"If you know SQL, you know Drizzle"** - The framework embraces SQL fundamentals without heavy abstraction layers.

**Zero Dependencies** - Optimized for serverless deployments

### Query Building Patterns

**SQL-like Queries** (Standard Approach):
```typescript
import { db } from '@/lib/db';
import { users } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';

const user = await db.select()
  .from(users)
  .where(eq(users.id, userId))
  .limit(1);
```

**Relational Queries API** (Nested Data):
```typescript
// Outputs EXACTLY ONE SQL query (no N+1 problem)
const result = await db.query.users.findMany({
  with: {
    posts: true,
    comments: { with: { author: true } }
  }
});
```

**Key Benefit:** Relational queries always produce a single database query, preventing N+1 problems in serverless environments where roundtrip costs matter.

### Schema Definition

**TypeScript-first schema declaration:**
```typescript
import { pgTable, text, uuid, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: text('email').notNull().unique(),
  created_at: timestamp('created_at').notNull().defaultNow()
});
```

**Relationships via foreign keys:**
```typescript
export const posts = pgTable('posts', {
  id: uuid('id').primaryKey(),
  user_id: uuid('user_id').references(() => users.id).notNull(),
  title: text('title').notNull()
});
```

### Migrations Workflow

**Automatic SQL generation** from schema changes:
1. Modify schema TypeScript files
2. Run: `drizzle-kit generate` - Creates SQL migration files
3. Review generated SQL (version controlled)
4. Run: `drizzle-kit migrate` - Apply to database

**Key Feature:** Migrations are **standard SQL files** that can be reviewed before execution.

### TypeScript Type Inference

**Schema definitions automatically generate types:**
```typescript
export const users = pgTable('users', { ... });

// Inferred types:
type User = typeof users.$inferSelect;     // SELECT result
type UserInsert = typeof users.$inferInsert; // INSERT input
```

**No separate type definitions needed** - Schema is single source of truth.

### Dialect Support

Choose between:
- PostgreSQL (recommended for Supabase)
- MySQL
- SQLite
- SingleStore

**Native driver support** for each dialect.

### Best Practices

1. **Build Your Way** - Library, not framework; no architectural constraints
2. **Single Query Output** - Use relational queries to avoid N+1 problems
3. **Type Safety First** - Let schema drive your types
4. **Review Migrations** - Always check generated SQL before applying
5. **Serverless Optimized** - Zero dependencies = smaller cold starts

---

## Supabase Row-Level Security (RLS)

### Core Concept

**"Policies are Postgres's rule engine"** - RLS attaches authorization rules to tables that function as implicit WHERE clauses on every query.

### Enabling RLS

```sql
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;
```

### Policy Structure

**Three policy clauses:**
- `USING` - for SELECT and DELETE (checks existing rows)
- `WITH CHECK` - for INSERT (validates new rows)
- Both combined - for UPDATE (checks old + validates new)

### Common Policy Patterns

**User-owned data (most common):**
```sql
-- Users can only see their own data
CREATE POLICY "users_select_own"
  ON table_name FOR SELECT
  USING ((select auth.uid()) = user_id);

-- Users can only insert their own data
CREATE POLICY "users_insert_own"
  ON table_name FOR INSERT
  WITH CHECK ((select auth.uid()) = user_id);

-- Users can only update their own data
CREATE POLICY "users_update_own"
  ON table_name FOR UPDATE
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);
```

**Public read, authenticated write:**
```sql
CREATE POLICY "public_read"
  ON table_name FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "authenticated_write"
  ON table_name FOR INSERT
  TO authenticated
  WITH CHECK (true);
```

### Helper Functions

**`auth.uid()`** - Returns authenticated user's ID
```sql
-- Wrap in SELECT for better performance (Postgres caches result)
(select auth.uid()) = user_id
```

**`auth.jwt()`** - Access JWT metadata for complex authorization

**Best Practice:** Use `raw_app_meta_data` (server-set, not user-modifiable) for storing authorization info.

### Performance Optimization

**Add indexes on policy columns:**
```sql
CREATE INDEX table_name_user_id_idx ON table_name(user_id);
```

RLS policies run on **every query**, so indexed columns are critical for performance.

### Security Best Practices

1. **Always enable RLS on exposed schemas** (especially `public`)
2. **Check `auth.uid() IS NOT NULL`** explicitly for clarity with unauthenticated users
3. **Specify roles** using `TO` clause to prevent unnecessary evaluation
4. **Include explicit filters** in queries even when policies exist (defense in depth)
5. **Use service role carefully** - Bypasses ALL RLS policies

### Service Role Pattern

```typescript
import { createClient } from '@supabase/supabase-js';

// Service role bypasses RLS - use for admin operations only
const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY! // ⚠️ Bypasses RLS
);
```

### Testing RLS Policies

```sql
-- Test as specific user
SET request.jwt.claims.sub TO 'user-id-here';

-- Verify policy works
SELECT * FROM table_name; -- Should only see user's data

-- Reset
RESET request.jwt.claims.sub;
```

---

**Sources:**
- Drizzle ORM Documentation
- Supabase RLS Guide
**Last Updated:** 2025-10-25
