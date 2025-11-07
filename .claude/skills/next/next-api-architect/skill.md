---
name: Next.js API Architect
description: Design and audit Next.js 16 API routes with proper caching, validation, error handling, and performance optimization. Implements Cache Components, Server Functions, and modern API patterns.
version: 1.0.0
---

# Next.js API Architect

## Overview

Specialized skill for designing, auditing, and optimizing Next.js 16 API routes **using Clarity's production-grade API infrastructure**. Focuses on:
- **Route Handler Architecture** - Modern `export async function GET/POST` patterns
- **Cache Components Integration** - `'use cache'` helpers for route handlers
- **Validation & Type Safety** - Zod schemas, input sanitization, error handling
- **Performance Optimization** - Parallel fetching, request deduplication, streaming
- **Security Best Practices** - Auth checks, rate limiting, CORS, sanitization

## Clarity API Infrastructure (`/lib/api`)

This project has **comprehensive API utilities** that should be used instead of building from scratch:

### Core Modules
- **`@/lib/api/next/handlers`** - Route wrappers (`withAuthRoute`, `withAuthGetRoute`, `withAuth`, `requireAuth`, `requireAdmin`)
- **`@/lib/api/next/response`** - Canonical response helpers (`apiSuccess`, `apiError`, `handleError`)
- **`@/lib/api/next/validation`** - Input validators (`validateQuery`, `validateBody`)
- **`@/lib/api/next/response-headers`** - Header utilities (rate limit, cache, security, tracing)
- **`@/lib/api/next/cors`** - CORS wrapper (`withCors`)
- **`@/lib/api/shared/rate-limit`** - Distributed rate limiting (`rateLimiters`, `createRateLimiter`)
- **`@/lib/api/shared/validation`** - Reusable Zod schemas (`paginationSchema`, `dateRangeSchema`, etc.)
- **`@/lib/api/shared/error-handling`** - Error formatters (`formatZodError`, `redactSensitiveData`)
- **`@/lib/api/shared/idempotency`** - Idempotency helpers (`withIdempotency`)

### Type Definitions
- **`@/lib/types/shared`** - API response types (`ApiSuccessResponse`, `ApiErrorResponse`, `PaginatedResponse`)
- **`@/lib/types/api`** - API config types (`RequestContext`, `RateLimitConfig`, `IdempotencyOptions`)

### Utilities from `@/lib/utils`
- **Error classes** - `AppError`, `NotFoundError`, `AuthenticationError`, `ValidationError`, etc.
- **Logger** - Structured logging with Pino (`logger.info`, `logger.error`)
- **Formatters** - `formatCurrency`, `formatDate`, etc.

### Documentation
See `/lib/api/README.md` for comprehensive API layer documentation.

## When to Use

Invoke when:
- "Design an API endpoint"
- "Audit this API route"
- "Optimize API performance"
- "Fix API caching"
- "Review route handler"
- Building new API endpoints
- Migrating from Pages Router API routes

## Core Patterns

### 1. Route Handler Structure (Next.js 16 + Clarity Infrastructure)

```ts
// ✅ CORRECT - Using project's API helpers
// app/api/v1/users/[id]/route.ts
import type { User } from '@supabase/supabase-js'
import type { NextRequest } from 'next/server'
import { withAuthGetRoute, type RequestContext } from '@/lib/api/next/handlers'
import { apiSuccess, apiError } from '@/lib/api/next/response'
import { getUserData } from '@/lib/db/services/users'
import { logger } from '@/lib/utils'

export const GET = withAuthGetRoute(
  { requests: 100, windowMs: 60000 }, // Rate limiting config
  async (request: NextRequest, context: RequestContext, user: User) => {
    if (!context.params) {
      return apiError('Missing route parameters', 400, undefined, context.requestId, context.traceId)
    }

    const resolvedParams = await context.params
    const userId = resolvedParams.id as string

    if (!userId) {
      return apiError('User ID is required', 400, undefined, context.requestId, context.traceId)
    }

    try {
      logger.info({ userId: user.id, targetId: userId, requestId: context.requestId }, 'Fetching user data')

      // getUserData is cached via 'use cache' directive in service layer
      const data = await getUserData(userId)

      if (!data) {
        return apiError('User not found', 404, undefined, context.requestId, context.traceId)
      }

      const response = apiSuccess(data)

      // HTTP-level caching (30s cache, 60s stale-while-revalidate)
      response.headers.set('Cache-Control', 'private, max-age=30, stale-while-revalidate=60')

      return response
    } catch (error: unknown) {
      const err = error instanceof Error ? error : new Error(String(error))
      logger.error(
        { err: err.message, stack: err.stack, userId, requestId: context.requestId },
        'User data fetch failed'
      )
      return apiError('Failed to fetch user data', 500, undefined, context.requestId, context.traceId)
    }
  }
)

// ❌ WRONG - Old Pages Router style
export default async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).end()
  }
  const data = await fetchData()
  res.json(data)
}
```

**Key Clarity Patterns:**
- Use `withAuthGetRoute()` for authenticated GET endpoints (auto-handles auth + rate limiting)
- Use `apiSuccess()` / `apiError()` for consistent response format (from `@/lib/api/next/response`)
- Use `RequestContext` type (includes `requestId`, `traceId`, `params`)
- Extract business logic to service layer (`@/lib/db/services/*`)
- Use structured logging with `logger` from `@/lib/utils`
- Include `requestId` and `traceId` in all errors for distributed tracing

### 2. Cache Components in Route Handlers

```ts
// ✅ CORRECT - Extract cacheable logic to helper
// app/api/v1/dashboard/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { getUserId } from '@/lib/data/dal'
import { getDashboardData } from './helpers'

export async function GET(request: NextRequest) {
  const userId = await getUserId()
  const data = await getDashboardData(userId) // Cached helper
  return NextResponse.json(data)
}

// app/api/v1/dashboard/helpers.ts
import { unstable_cacheLife as cacheLife, unstable_cacheTag as cacheTag } from 'next/cache'
import { UserTags } from '@/lib/cache/tags'

export async function getDashboardData(userId: string) {
  'use cache'
  cacheLife('minutes') // 5-15 min
  cacheTag(UserTags.dashboard(userId))

  return {
    accounts: await getAccounts(userId),
    transactions: await getRecentTransactions(userId),
    balance: await getTotalBalance(userId),
  }
}

// ❌ WRONG - Trying to cache in route handler directly
export async function GET(request: NextRequest) {
  'use cache' // Won't work! Route handlers can't be cached
  const data = await fetchData()
  return NextResponse.json(data)
}
```

### 3. Request Validation (Using Clarity Validators)

```ts
// ✅ CORRECT - Using project's validation utilities
import { z } from 'zod'
import type { NextRequest } from 'next/server'
import { validateQuery, validateBody } from '@/lib/api/next/validation'
import { paginationSchema } from '@/lib/api/shared/validation'
import { apiSuccess, apiError, handleError } from '@/lib/api/next/response'
import { withAuthGetRoute, type RequestContext } from '@/lib/api/next/handlers'

// Combine with project's reusable schemas
const QuerySchema = z.object({
  ...paginationSchema.shape, // page, limit from shared validation
  sort: z.enum(['asc', 'desc']).default('desc'),
  filter: z.string().optional(),
})

const BodySchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
})

// GET endpoint with validation
export const GET = withAuthGetRoute(
  { requests: 100, windowMs: 60000 },
  async (request: NextRequest, context: RequestContext) => {
    try {
      // validateQuery handles MAX_QUERY_STRING_SIZE check (8KB limit)
      const validated = validateQuery(request, QuerySchema)

      const data = await fetchData(validated)
      return apiSuccess(data)
    } catch (error) {
      return handleError(error, context.requestId, context.traceId)
    }
  }
)

// POST endpoint with body validation
export async function POST(request: NextRequest) {
  try {
    // validateBody handles MAX_JSON_SIZE check (1MB limit) + Content-Type
    const validated = await validateBody(request, BodySchema)

    const result = await createResource(validated)
    return apiSuccess(result, 201)
  } catch (error) {
    // handleError automatically formats Zod errors
    return handleError(error)
  }
}
```

**Key Clarity Patterns:**
- Use `validateQuery()` for query params (auto-checks 8KB size limit)
- Use `validateBody()` for POST/PUT bodies (auto-checks 1MB size + Content-Type)
- Import reusable schemas from `@/lib/api/shared/validation` (pagination, dateRange, uuid, etc.)
- Use `handleError()` for automatic Zod error formatting
- Both validators throw on validation failure; catch with `handleError()`

### 4. Error Handling (Using Clarity Error Classes)

```ts
// ✅ CORRECT - Using project's error infrastructure
import type { NextResponse } from 'next/server'
import { handleError, apiError } from '@/lib/api/next/response'
import {
  AppError,
  NotFoundError,
  AuthenticationError,
  AuthorizationError,
  ValidationError,
  RateLimitExceededError,
  DatabaseError,
  logger
} from '@/lib/utils'

// Method 1: Use handleError() for automatic error handling
export async function GET(request: NextRequest) {
  try {
    const data = await fetchData()
    return apiSuccess(data)
  } catch (error) {
    // handleError() automatically:
    // - Formats Zod validation errors
    // - Maps AppError subclasses to correct status codes
    // - Sanitizes error messages in production
    // - Logs errors with tracing context
    // - Redacts sensitive data
    return handleError(error, requestId, traceId)
  }
}

// Method 2: Throw custom error classes (caught by handleError)
export async function POST(request: NextRequest) {
  try {
    const user = await getUserById(userId)

    if (!user) {
      throw new NotFoundError('User not found') // 404
    }

    if (!user.isAdmin) {
      throw new AuthorizationError('Admin access required') // 403
    }

    const result = await createResource(user)
    return apiSuccess(result, 201)
  } catch (error) {
    return handleError(error)
  }
}

// Available error classes from @/lib/utils/errors:
// - AppError (base class, 500)
// - NotFoundError (404)
// - AuthenticationError (401)
// - AuthorizationError (403)
// - ValidationError (400)
// - RateLimitExceededError (429)
// - DatabaseError (500)
// - NetworkError (502/503/504)
// - TimeoutError (504)
// - ExternalServiceError (502)
```

**Key Clarity Patterns:**
- Use `handleError()` from `@/lib/api/next/response` (canonical error handler)
- Import error classes from `@/lib/utils` (re-exported from `@/lib/utils/errors`)
- `handleError()` auto-formats Zod errors, AppError subclasses, and unknown errors
- Error sanitization happens automatically in production (via SAFE_ERROR_MESSAGES)
- All errors logged with structured logging (includes requestId/traceId if provided)
- Use `apiError()` for manual error responses with specific details

### 5. Authentication & Authorization (Clarity Infrastructure)

```ts
// ✅ CORRECT - Using project's auth helpers
import type { User } from '@supabase/supabase-js'
import type { NextRequest } from 'next/server'
import {
  withAuthGetRoute,
  withAuthRoute,
  requireAuth,
  requireAdmin,
  type RequestContext
} from '@/lib/api/next/handlers'
import { apiSuccess, apiError, handleError } from '@/lib/api/next/response'
import { getUserId, isUserAdmin } from '@/lib/data/dal'

// Method 1: Use withAuthGetRoute wrapper (RECOMMENDED for GET)
export const GET = withAuthGetRoute(
  { requests: 100, windowMs: 60000 }, // Built-in rate limiting
  async (request: NextRequest, context: RequestContext, user: User) => {
    // user is auto-injected, already authenticated
    const data = await fetchUserData(user.id)
    return apiSuccess(data)
  }
)

// Method 2: Use withAuthRoute for POST/PUT/DELETE (includes CSRF protection)
export const POST = withAuthRoute(
  { requests: 50, windowMs: 60000 },
  async (request: NextRequest, context: RequestContext, user: User) => {
    const validated = await validateBody(request, BodySchema)
    const result = await createResource(user.id, validated)
    return apiSuccess(result, 201)
  }
)

// Method 3: Manual auth check (for custom control)
export async function PATCH(request: NextRequest) {
  try {
    const user = await requireAuth(request)

    const validated = await validateBody(request, UpdateSchema)
    const result = await updateResource(user.id, validated)

    return apiSuccess(result)
  } catch (error) {
    return handleError(error)
  }
}

// Admin-only endpoint
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const user = await requireAdmin(request) // Throws AuthorizationError if not admin

    const { id } = await params
    await deleteResource(id)

    return apiSuccess({ success: true })
  } catch (error) {
    return handleError(error)
  }
}

// Public endpoint (no auth) - use standard Next.js handler
export async function GET(request: NextRequest) {
  const data = await fetchPublicData()
  return apiSuccess(data)
}
```

**Key Clarity Patterns:**
- `withAuthGetRoute()` - Auto-auth + rate limiting for GET (returns User in handler)
- `withAuthRoute()` - Auto-auth + rate limiting + CSRF protection for POST/PUT/DELETE/PATCH
- `withAuth()` - Simpler auth wrapper without rate limiting (for custom rate limit logic)
- `requireAuth()` - Manual auth check (throws AuthenticationError if unauthenticated)
- `requireAdmin()` - Checks auth + admin role (throws AuthorizationError if not admin)
- DAL functions (`getUserId()`, `isUserAdmin()`) for Server Components only (not API routes)
- All wrappers inject `RequestContext` with `requestId`, `traceId`, `params`
- CSRF protection automatic in `withAuthRoute` (checks Origin/Referer headers for mutations)

### 6. Response Patterns (Clarity Types)

```ts
// ✅ CORRECT - Using project's response types
import type { NextRequest } from 'next/server'
import { apiSuccess, apiError } from '@/lib/api/next/response'
import type { ApiSuccessResponse, ApiErrorResponse, PaginatedResponse } from '@/lib/types/shared'
import { paginationSchema } from '@/lib/api/shared/validation'
import { validateQuery } from '@/lib/api/next/validation'

// Standard success response (ApiSuccessResponse<T>)
// Format: { success: true, data: T }
export async function GET(request: NextRequest) {
  const data = await fetchData()
  return apiSuccess(data) // Returns NextResponse<ApiSuccessResponse<typeof data>>
}

// Paginated response (PaginatedResponse<T>)
// Format: { success: true, data: T[], pagination: { page, limit, total, hasMore } }
export async function GET(request: NextRequest) {
  const { page, limit } = validateQuery(request, paginationSchema)

  const { items, total } = await fetchPaginated(page, limit)

  const response: PaginatedResponse<Item> = {
    success: true,
    data: items,
    pagination: {
      page,
      limit,
      total,
      hasMore: page * limit < total,
    },
  }

  return apiSuccess(response)
}

// Error response (ApiErrorResponse)
// Format: { success: false, error: string, status: number, details?, requestId?, traceId? }
export async function POST(request: NextRequest) {
  const user = await getUserById(userId)

  if (!user) {
    // apiError(message, status, details?, requestId?, traceId?)
    return apiError('User not found', 404, { userId }, requestId, traceId)
  }

  return apiSuccess({ created: true })
}

// Using type imports from @/lib/types/shared
import type { ApiResponse, ValidationErrorResponse } from '@/lib/types/shared'

// ApiResponse<T> = ApiSuccessResponse<T> | ApiErrorResponse (discriminated union)
function processResponse<T>(response: ApiResponse<T>) {
  if (response.success) {
    console.log(response.data) // Type: T
  } else {
    console.error(response.error) // Type: string
  }
}
```

**Key Clarity Patterns:**
- Use `apiSuccess()` for all success responses (returns `NextResponse<ApiSuccessResponse<T>>`)
- Use `apiError()` for all error responses (returns `NextResponse<ApiErrorResponse>`)
- Import types from `@/lib/types/shared`:
  - `ApiSuccessResponse<T>` - Success with data
  - `ApiErrorResponse` - Error with message, status, optional details
  - `ApiResponse<T>` - Discriminated union (success: true/false)
  - `PaginatedResponse<T>` - Success with pagination metadata
  - `ValidationErrorResponse` - Validation errors with Zod issues
- Always include `requestId` and `traceId` in errors for distributed tracing
- Use `handleError()` for automatic error formatting (Zod → ValidationErrorResponse)

### 7. Performance Optimization

```ts
// ✅ CORRECT - Parallel data fetching
export async function GET(request: NextRequest) {
  const userId = await getUserId()

  // Initiate all requests in parallel
  const accountsPromise = getAccounts(userId)
  const transactionsPromise = getTransactions(userId)
  const balancePromise = getBalance(userId)

  // Wait for all to complete
  const [accounts, transactions, balance] = await Promise.all([
    accountsPromise,
    transactionsPromise,
    balancePromise,
  ])

  return NextResponse.json({ accounts, transactions, balance })
}

// ❌ WRONG - Sequential (waterfall) fetching
export async function GET(request: NextRequest) {
  const userId = await getUserId()

  const accounts = await getAccounts(userId) // Blocks
  const transactions = await getTransactions(userId) // Waits for accounts
  const balance = await getBalance(userId) // Waits for transactions

  return NextResponse.json({ accounts, transactions, balance })
}
```

### 8. Streaming Responses

```ts
// ✅ CORRECT - Streaming large datasets
export async function GET(request: NextRequest) {
  const userId = await getUserId()

  const stream = new ReadableStream({
    async start(controller) {
      try {
        // Stream data in chunks
        for await (const chunk of fetchDataStream(userId)) {
          controller.enqueue(
            new TextEncoder().encode(JSON.stringify(chunk) + '\n')
          )
        }
        controller.close()
      } catch (error) {
        controller.error(error)
      }
    },
  })

  return new Response(stream, {
    headers: {
      'Content-Type': 'application/x-ndjson',
      'Transfer-Encoding': 'chunked',
    },
  })
}

// Helper for streaming data
async function* fetchDataStream(userId: string) {
  const batchSize = 100
  let offset = 0

  while (true) {
    const batch = await fetchBatch(userId, offset, batchSize)
    if (batch.length === 0) break

    for (const item of batch) {
      yield item
    }

    offset += batchSize
  }
}
```

### 9. Rate Limiting (Clarity Infrastructure)

```ts
// ✅ CORRECT - Using project's distributed rate limiters
import { rateLimiters } from '@/lib/api/shared/rate-limit'
import type { NextRequest } from 'next/server'
import { apiSuccess, apiError } from '@/lib/api/next/response'
import { addRateLimitHeaders, addRateLimitExceededHeaders } from '@/lib/api/next/response-headers'

// Method 1: Use withAuthGetRoute wrapper (rate limiting built-in)
export const GET = withAuthGetRoute(
  { requests: 100, windowMs: 60000 }, // 100 req/min
  async (request, context, user) => {
    const data = await fetchData(user.id)
    return apiSuccess(data)
  }
)

// Method 2: Manual rate limiting with pre-configured limiters
export async function POST(request: NextRequest) {
  const user = await requireAuth(request)

  // Pre-configured limiters: strict (10/min), standard (100/min), generous (1000/min)
  const { success, limit, remaining, reset } = await rateLimiters.standard.limit(user.id)

  if (!success) {
    const response = apiError('Rate limit exceeded', 429)
    addRateLimitExceededHeaders(response, { limit, remaining, reset })
    return response
  }

  const result = await processRequest(user.id)
  const response = apiSuccess(result)

  // Add rate limit info to headers
  addRateLimitHeaders(response, { limit, remaining, reset })
  return response
}

// Method 3: Custom rate limiter
import { createRateLimiter } from '@/lib/api/shared/rate-limit'

const customLimiter = createRateLimiter({
  limit: 50,
  windowSeconds: 60,
  prefix: 'api:custom',
})

export async function PATCH(request: NextRequest) {
  const { success } = await customLimiter.limit(identifier)

  if (!success) {
    return apiError('Too many requests', 429)
  }

  // Process request...
}

// Method 4: IP-based rate limiting (for public endpoints)
import { getClientId } from '@/lib/api/next/handlers'

export async function GET(request: NextRequest) {
  const clientId = getClientId(request) // Gets IP from x-forwarded-for/cf-connecting-ip

  const { success } = await rateLimiters.public.limit(clientId) // 50/min for public

  if (!success) {
    return apiError('Rate limit exceeded', 429)
  }

  const data = await fetchPublicData()
  return apiSuccess(data)
}
```

**Key Clarity Patterns:**
- Use `withAuthGetRoute()` / `withAuthRoute()` for automatic rate limiting
- Pre-configured limiters in `rateLimiters`:
  - `strict` - 10 requests/min (sensitive operations)
  - `standard` - 100 requests/min (typical authenticated endpoints)
  - `generous` - 1000 requests/min (high-volume operations)
  - `public` - 50 requests/min (unauthenticated endpoints)
- Use `createRateLimiter()` for custom limits
- Add rate limit headers with `addRateLimitHeaders()` / `addRateLimitExceededHeaders()`
- Distributed rate limiting via Upstash Redis (auto-fallback to permissive mode in dev)
- Use `getClientId()` to extract client IP for public endpoint rate limiting

### 10. CORS Configuration (Clarity Infrastructure)

```ts
// ✅ CORRECT - Using project's CORS utilities
import type { NextRequest } from 'next/server'
import { withCors } from '@/lib/api/next/cors'
import { getAllCorsOrigins } from '@/lib/api/cors'
import { apiSuccess } from '@/lib/api/next/response'
import { withAuthGetRoute } from '@/lib/api/next/handlers'

// Method 1: Use withCors wrapper (RECOMMENDED)
export const GET = withCors(async (request: NextRequest) => {
  const data = await fetchData()
  return apiSuccess(data)
})

// Method 2: Manual CORS with getAllCorsOrigins()
export async function OPTIONS(request: NextRequest) {
  const allowedOrigins = getAllCorsOrigins() // Gets from env: CORS_ORIGINS + NEXT_PUBLIC_APP_URL

  const origin = request.headers.get('origin')
  const isAllowed = origin && allowedOrigins.includes(origin)

  const headers = new Headers()
  headers.set('Access-Control-Allow-Origin', isAllowed ? origin : allowedOrigins[0])
  headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  headers.set('Access-Control-Max-Age', '86400')

  return new Response(null, { status: 204, headers })
}

// Method 3: Combine CORS + Auth
export const POST = withCors(
  withAuthRoute(
    { requests: 50, windowMs: 60000 },
    async (request, context, user) => {
      const result = await createResource(user.id)
      return apiSuccess(result)
    }
  )
)

// Note: CORS origins configured via environment variables
// - CORS_ORIGINS: Comma-separated list of allowed origins
// - NEXT_PUBLIC_APP_URL: Auto-added to allowed origins
```

**Key Clarity Patterns:**
- Use `withCors()` wrapper for automatic CORS headers
- Use `getAllCorsOrigins()` from `@/lib/api/cors` to get env-configured allowed origins
- CORS config centralized in `@/lib/api/cors`
- Environment variables:
  - `CORS_ORIGINS` - Comma-separated allowed origins
  - `NEXT_PUBLIC_APP_URL` - Auto-included in allowed list
- `withCors()` handles OPTIONS preflight automatically
- Combine with auth wrappers: `withCors(withAuthRoute(...))`

## Audit System

### How to Audit

**Invoke audit mode:**
```
Audit app/api/v1/transactions/route.ts
```

The skill will:
1. Read and analyze the route handler
2. Check against all patterns and anti-patterns
3. Generate a compliance score (0-100)
4. List specific issues with line numbers
5. Provide exact fixes

### Audit Report Format

```markdown
## API Route Audit: app/api/v1/transactions/route.ts

**Compliance Score**: 72/100 (Acceptable ⭐⭐⭐)
**Grade**: Needs improvement

### ✅ Strengths
- Proper auth check with DAL
- Zod validation for query params
- Consistent error handling

### 🚨 Critical Issues (Must Fix)

#### 1. No Caching (Line 25-30)
**Current**:
```ts
export async function GET(request: NextRequest) {
  const userId = await getUserId()
  const transactions = await db.query.transactions.findMany(...)
  return NextResponse.json(transactions)
}
```

**Fix**: Extract to cached helper
```ts
// route.ts
export async function GET(request: NextRequest) {
  const userId = await getUserId()
  const transactions = await getTransactionsCached(userId)
  return NextResponse.json(transactions)
}

// helpers.ts
export async function getTransactionsCached(userId: string) {
  'use cache'
  cacheLife('minutes')
  cacheTag(UserTags.transactions(userId))
  return await db.query.transactions.findMany(...)
}
```

**Impact**: HIGH - Currently hitting database on every request

#### 2. Sequential Fetching (Line 35-37)
**Current**: Waterfall requests blocking each other
**Fix**: Use `Promise.all()` for parallel fetching
**Impact**: MEDIUM - 3x slower than necessary

### ⚠️ High Priority Issues (Should Fix)

#### 3. Missing Rate Limiting (Line 45)
**Recommendation**: Add rate limiting for POST/PUT/DELETE operations
**Impact**: MEDIUM - Vulnerable to abuse

### ℹ️ Suggestions (Nice to Have)

#### 4. Generic Error Messages
**Suggestion**: More specific error messages for better debugging
**Impact**: LOW - Developer experience

### 🔧 Auto-Fix Available

Run these Edit commands to fix critical issues:
1. Extract caching helper (see Fix #1)
2. Convert to parallel fetching (see Fix #2)

### Score Breakdown
- Auth & Security: 25/25 ✅
- Validation: 20/25 ⚠️
- Error Handling: 15/15 ✅
- Caching: 5/15 🚨
- Performance: 7/15 ⚠️
- Type Safety: 5/5 ✅

### Next Steps
1. Fix Critical Issue #1 (caching) - +10 points
2. Fix Critical Issue #2 (performance) - +8 points
3. **Estimated New Score**: 90/100 (Excellent)
```

## Audit Checklist (Clarity-Specific)

### Critical Issues (25 points each, Must Fix)

- [ ] **Auth**: Protected routes use `withAuthGetRoute`/`withAuthRoute` OR `requireAuth()`
- [ ] **Validation**: All inputs validated with `validateQuery()`/`validateBody()` from `@/lib/api/next/validation`
- [ ] **Error Handling**: Use `handleError()` from `@/lib/api/next/response` (not manual `NextResponse.json()`)
- [ ] **Response Format**: Use `apiSuccess()`/`apiError()` from `@/lib/api/next/response`

### High Priority Issues (15 points each, Should Fix)

- [ ] **Caching**: Cacheable logic extracted to `'use cache'` helpers (service layer)
- [ ] **Performance**: Parallel fetching where possible (no waterfalls)
- [ ] **Rate Limiting**: Auth wrappers include rate limit config OR manual `rateLimiters` usage
- [ ] **Params**: Async params handling (`await params`)
- [ ] **Logging**: Structured logging with `logger` from `@/lib/utils` (include requestId/traceId)

### Medium Priority Issues (5 points each, Nice to Have)

- [ ] **CORS**: Use `withCors()` from `@/lib/api/next/cors` for cross-origin endpoints
- [ ] **Streaming**: Large datasets use streaming responses (ReadableStream)
- [ ] **Headers**: Use helpers from `@/lib/api/next/response-headers` (cache, security, tracing)
- [ ] **Reusable Schemas**: Import from `@/lib/api/shared/validation` (pagination, dateRange, etc.)
- [ ] **Documentation**: API route documented with JSDoc

### Low Priority Issues (2 points each, Optional)

- [ ] **Testing**: Unit tests for route handlers
- [ ] **OpenAPI Spec**: API documented with OpenAPI/Swagger
- [ ] **Versioning**: API versioning strategy in place
- [ ] **Pagination**: Cursor-based pagination for large lists

### Scoring Rubric

**Perfect Score (100/100)**:
- All critical issues: 100 (4 × 25)
- All high priority: 75 (5 × 15)
- All medium priority: 25 (5 × 5)
- All low priority: 8 (4 × 2)
- Total possible: 208 points (normalized to 100)

**Grades**:
- 95-100: Excellent ⭐⭐⭐⭐⭐ (Production gold standard)
- 85-94: Good ⭐⭐⭐⭐ (Production ready, minor improvements)
- 75-84: Acceptable ⭐⭐⭐ (Functional, needs optimization)
- 65-74: Needs Work ⚠️ (Multiple issues)
- <65: Critical Issues 🚨 (Not production ready)

### Automated Checks (Clarity-Specific)

The auditor will automatically detect:

1. **Missing Auth Wrapper** - No `withAuthGetRoute`/`withAuthRoute` or `requireAuth()` call
2. **Manual Response Formatting** - Using `NextResponse.json()` instead of `apiSuccess()`/`apiError()`
3. **No Validation** - Direct use of `request.json()` or query params without `validateBody()`/`validateQuery()`
4. **Sync Params** - Using `params.id` instead of `await params`
5. **No Caching** - Database queries directly in route handler (should be in service layer with `'use cache'`)
6. **Sequential Fetching** - `await` statements that could be parallel
7. **Manual Error Handling** - Not using `handleError()` from `@/lib/api/next/response`
8. **Missing RequestContext** - Not using `context.requestId`/`context.traceId` in logs/errors
9. **Missing Rate Limiting** - POST/PUT/DELETE without rate limit config in wrapper
10. **Hardcoded Error Messages** - Not using error classes from `@/lib/utils` (`NotFoundError`, etc.)

## Anti-Patterns to Avoid

### ❌ Mixing Logic and Route Handlers

```ts
// ❌ BAD - All logic inline
export async function GET(request: NextRequest) {
  const userId = await getUserId()

  // 100+ lines of business logic
  const accounts = await db.query.accounts.findMany(...)
  const enriched = accounts.map(account => {
    // Complex transformation logic
  })
  const sorted = enriched.sort(...)
  const filtered = sorted.filter(...)

  return NextResponse.json(filtered)
}

// ✅ GOOD - Logic in helpers
export async function GET(request: NextRequest) {
  const userId = await getUserId()
  const data = await getEnrichedAccounts(userId) // Cached helper
  return NextResponse.json(data)
}
```

### ❌ Missing Error Boundaries

```ts
// ❌ BAD - Unhandled errors crash route
export async function POST(request: NextRequest) {
  const body = await request.json() // Might throw
  const result = await processData(body) // Might throw
  return NextResponse.json(result)
}

// ✅ GOOD - Error handling
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const validated = BodySchema.parse(body)
    const result = await processData(validated)
    return NextResponse.json(result)
  } catch (error) {
    return handleApiError(error)
  }
}
```

### ❌ No Input Validation

```ts
// ❌ BAD - Direct use of untrusted input
export async function GET(request: NextRequest) {
  const url = new URL(request.url)
  const id = url.searchParams.get('id')
  const data = await db.query.users.findFirst({ where: eq(users.id, id) })
  return NextResponse.json(data)
}

// ✅ GOOD - Validated input
export async function GET(request: NextRequest) {
  const url = new URL(request.url)
  const validated = QuerySchema.parse({
    id: url.searchParams.get('id'),
  })
  const data = await fetchUser(validated.id)
  return NextResponse.json(data)
}
```

### ❌ Synchronous Params Access

```ts
// ❌ BROKEN - Next.js 16 requires async params
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const data = await fetchData(params.id) // params is a Promise!
  return NextResponse.json(data)
}

// ✅ FIXED - Await params
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params
  const data = await fetchData(id)
  return NextResponse.json(data)
}
```

## Design Patterns

### 1. Repository Pattern

```ts
// lib/db/repositories/users.ts
export async function findUserById(id: string): Promise<User | null> {
  return await db.query.users.findFirst({ where: eq(users.id, id) })
}

// app/api/v1/users/[id]/route.ts
import { findUserById } from '@/lib/db/repositories/users'

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params
  const user = await findUserById(id)

  if (!user) {
    throw new NotFoundError('User not found')
  }

  return NextResponse.json(user)
}
```

### 2. Service Layer

```ts
// lib/services/accounts.ts
export async function getAccountSummary(userId: string) {
  'use cache'
  cacheLife('minutes')
  cacheTag(UserTags.accounts(userId))

  const accounts = await findAccountsByUserId(userId)
  const balances = await getBalances(accounts.map(a => a.id))

  return {
    accounts: accounts.map((account, i) => ({
      ...account,
      balance: balances[i],
    })),
    total: balances.reduce((sum, b) => sum + b, 0),
  }
}

// app/api/v1/accounts/summary/route.ts
import { getAccountSummary } from '@/lib/services/accounts'

export async function GET(request: NextRequest) {
  const userId = await getUserId()
  const summary = await getAccountSummary(userId)
  return NextResponse.json(summary)
}
```

### 3. Middleware Pattern

```ts
// lib/api/middleware.ts
export function withAuth(
  handler: (request: NextRequest, userId: string) => Promise<NextResponse>
) {
  return async (request: NextRequest) => {
    try {
      const userId = await getUserId()
      return await handler(request, userId)
    } catch (error) {
      return handleApiError(error)
    }
  }
}

export function withValidation<T>(
  schema: z.ZodSchema<T>,
  handler: (request: NextRequest, validated: T) => Promise<NextResponse>
) {
  return async (request: NextRequest) => {
    try {
      const body = await request.json()
      const validated = schema.parse(body)
      return await handler(request, validated)
    } catch (error) {
      return handleApiError(error)
    }
  }
}

// app/api/v1/posts/route.ts
export const POST = withAuth(
  withValidation(PostSchema, async (request, validated) => {
    const post = await createPost(validated)
    return NextResponse.json(post, { status: 201 })
  })
)
```

## Testing Strategy

```ts
// app/api/v1/users/__tests__/route.test.ts
import { GET, POST } from '../route'
import { NextRequest } from 'next/server'

describe('GET /api/v1/users', () => {
  it('returns users for authenticated user', async () => {
    const request = new NextRequest('http://localhost/api/v1/users')
    // Mock getUserId to return test user
    vi.mocked(getUserId).mockResolvedValue('user-123')

    const response = await GET(request)
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data).toHaveProperty('data')
  })

  it('returns 401 for unauthenticated user', async () => {
    vi.mocked(getUserId).mockRejectedValue(new UnauthorizedError('Not authenticated'))

    const request = new NextRequest('http://localhost/api/v1/users')
    const response = await GET(request)

    expect(response.status).toBe(401)
  })
})

describe('POST /api/v1/users', () => {
  it('creates user with valid data', async () => {
    const request = new NextRequest('http://localhost/api/v1/users', {
      method: 'POST',
      body: JSON.stringify({ name: 'John', email: 'john@example.com' }),
    })

    const response = await POST(request)
    expect(response.status).toBe(201)
  })

  it('returns 400 for invalid data', async () => {
    const request = new NextRequest('http://localhost/api/v1/users', {
      method: 'POST',
      body: JSON.stringify({ name: '', email: 'invalid' }),
    })

    const response = await POST(request)
    expect(response.status).toBe(400)
  })
})
```

## Success Criteria

A well-designed API route has:

✅ **Clear separation** - Route handler orchestrates, helpers do work
✅ **Type safety** - Zod validation at boundaries, TypeScript throughout
✅ **Error handling** - All errors caught and returned with proper codes
✅ **Auth checks** - Protected routes verify authentication
✅ **Caching** - Expensive operations cached with `'use cache'`
✅ **Performance** - Parallel fetching, no unnecessary waterfalls
✅ **Security** - Input sanitization, rate limiting, CORS configured
✅ **Consistency** - Standard response format, error structure
✅ **Testability** - Pure functions, dependency injection
✅ **Observability** - Structured logging, request tracing

## Quick Reference: Clarity API Patterns

### Standard Protected GET Endpoint
```ts
import type { User } from '@supabase/supabase-js'
import type { NextRequest } from 'next/server'
import { withAuthGetRoute, type RequestContext } from '@/lib/api/next/handlers'
import { apiSuccess, apiError, handleError } from '@/lib/api/next/response'
import { logger } from '@/lib/utils'

export const GET = withAuthGetRoute(
  { requests: 100, windowMs: 60000 },
  async (request: NextRequest, context: RequestContext, user: User) => {
    try {
      logger.info({ userId: user.id, requestId: context.requestId }, 'Fetching data')
      const data = await fetchDataCached(user.id) // 'use cache' in service layer
      return apiSuccess(data)
    } catch (error) {
      return handleError(error, context.requestId, context.traceId)
    }
  }
)
```

### Standard Protected POST Endpoint with Validation
```ts
import { withAuthRoute } from '@/lib/api/next/handlers'
import { validateBody } from '@/lib/api/next/validation'
import { apiSuccess, handleError } from '@/lib/api/next/response'
import { z } from 'zod'

const BodySchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
})

export const POST = withAuthRoute(
  { requests: 50, windowMs: 60000 },
  async (request, context, user) => {
    try {
      const validated = await validateBody(request, BodySchema)
      const result = await createResource(user.id, validated)
      return apiSuccess(result, 201)
    } catch (error) {
      return handleError(error, context.requestId, context.traceId)
    }
  }
)
```

### Public Endpoint with Rate Limiting
```ts
import { rateLimiters } from '@/lib/api/shared/rate-limit'
import { getClientId } from '@/lib/api/next/handlers'
import { apiSuccess, apiError } from '@/lib/api/next/response'

export async function GET(request: NextRequest) {
  const clientId = getClientId(request)
  const { success } = await rateLimiters.public.limit(clientId)

  if (!success) {
    return apiError('Rate limit exceeded', 429)
  }

  const data = await fetchPublicData()
  return apiSuccess(data)
}
```

### Import Cheat Sheet
```ts
// Route wrappers & auth
import {
  withAuthRoute,      // POST/PUT/DELETE with auth + rate limit + CSRF
  withAuthGetRoute,   // GET with auth + rate limit
  withAuth,           // Simple auth wrapper (no rate limit)
  requireAuth,        // Manual auth check
  requireAdmin,       // Admin-only check
  getClientId,        // Extract client IP
  type RequestContext
} from '@/lib/api/next/handlers'

// Response helpers
import { apiSuccess, apiError, handleError } from '@/lib/api/next/response'

// Validation
import { validateQuery, validateBody } from '@/lib/api/next/validation'
import {
  paginationSchema,    // { page, limit }
  cursorPaginationSchema, // { cursor?, limit }
  dateRangeSchema,     // { startDate?, endDate?, days? }
  uuidSchema,          // UUID validation
  filterSchema         // 'all' | 'banks' | 'brokers' | 'exchanges' | 'wallets'
} from '@/lib/api/shared/validation'

// Rate limiting
import { rateLimiters, createRateLimiter } from '@/lib/api/shared/rate-limit'
// Pre-configured: rateLimiters.strict (10/min), .standard (100/min), .generous (1000/min), .public (50/min)

// CORS
import { withCors } from '@/lib/api/next/cors'
import { getAllCorsOrigins } from '@/lib/api/cors'

// Idempotency
import { withIdempotency } from '@/lib/api/shared/idempotency'

// Headers
import {
  addRateLimitHeaders,
  addCacheHeaders,
  addSecurityHeaders,
  addTracingHeaders
} from '@/lib/api/next/response-headers'

// Types
import type {
  ApiSuccessResponse,
  ApiErrorResponse,
  ApiResponse,
  PaginatedResponse
} from '@/lib/types/shared'
import type {
  RequestContext,
  RateLimitConfig,
  IdempotencyOptions
} from '@/lib/types/api'
import type { User } from '@supabase/supabase-js'

// Error classes & logging
import {
  NotFoundError,
  AuthenticationError,
  AuthorizationError,
  ValidationError,
  RateLimitExceededError,
  DatabaseError,
  logger
} from '@/lib/utils'
```

## Resources

- `/lib/api/README.md` - Comprehensive API layer documentation
- `/lib/api/next/` - Next.js-specific utilities
- `/lib/api/shared/` - Framework-agnostic utilities
- `/lib/types/api.ts` - API type definitions
- `/lib/types/shared.ts` - Response type definitions
