---
name: Next.js 16 Audit
description: Comprehensive file-by-file audit for Next.js 16, React 19, and Clarity architecture compliance. Checks caching, auth patterns, type safety, Server Components, and generates auto-fixes.
version: 4.0.0
---

# Next.js 16 Best Practices Audit

## Overview

Performs **comprehensive file-by-file analysis** of TypeScript/TSX files for:
- **Next.js 16.0.1** (Cache Components, Server Functions, fetch API, streaming)
- **React 19** (no unnecessary useEffect, derived state, Server Components, `use` hook)
- **Clarity architecture** (DAL, type centralization, repository pattern)

## When to Use

**Triggers**:
- "Audit this file" / "Review this component"
- "Check for Next.js 16 compliance"
- User explicitly asks to audit with skill

## What Gets Audited

✅ **Server and Client Components** - Proper component boundaries, `"use client"` usage, data flow patterns
✅ **Linking and Navigating** - `<Link>` component, prefetching, client-side transitions, streaming
✅ **Layouts and Pages** - Route structure, nested layouts, dynamic segments, search params
✅ **Caching and Revalidating** - `fetch` API, `unstable_cache`, `revalidatePath`/`revalidateTag`
✅ **Error Handling** - Expected errors, uncaught exceptions, error boundaries, global errors
✅ **Proxy** - Request/response modification, redirects, header manipulation
✅ **Type centralization** - Domain types in `@/lib/types`
✅ **Caching** - `'use cache'` with `cacheLife`/`cacheTag` vs deprecated `cacheWrap`
✅ **Data fetching** - fetch API, async Server Components, request memoization
✅ **Server Functions** - `'use server'` for mutations, form actions
✅ **Auth** - DAL usage vs direct Supabase
✅ **Components** - Server/Client patterns, streaming with Suspense
✅ **Database** - Repositories, Drizzle imports, ORM patterns
✅ **React 19** - No unnecessary useEffect, `use` hook, derived state
✅ **Security** - Input validation, XSS prevention, Server Action security
✅ **Performance** - next/image, dynamic imports, parallel fetching
✅ **Accessibility** - Semantic HTML, ARIA

## Audit Process

### 1. File Classification

Identify:
- **Server Component**: `app/**/page.tsx`, `layout.tsx` (no `"use client"`)
- **Client Component**: Has `"use client"` directive
- **API Route**: `app/api/**/route.ts`
- **Utility**: `lib/**/*.ts`
- **Hook**: `hooks/**/*.ts` or `lib/hooks/**/*.ts`

### 2. Core Checks (20 Critical Categories)

#### 2.1 Type Safety ⭐ CRITICAL
- [ ] No `any` types
- [ ] Canonical imports from `@/lib/types` (NOT local definitions)
- [ ] No duplicates: Transaction, Account, User, Connection, Asset
- [ ] Zod schemas at API boundaries

**Rule**: Domain types MUST import from `/Users/zach/Documents/clarity/lib/types`

```ts
// ❌ VIOLATION
interface Transaction { id: string; amount: number; }

// ✅ CORRECT
import type { Transaction } from '@/lib/types';
```

#### 2.2 Caching (Next.js 16) ⭐ HIGH PRIORITY
- [ ] No `cacheWrap` (deprecated)
- [ ] Use `'use cache'` directive
- [ ] `cacheLife('minutes'|'hours'|'days')` specified
- [ ] `cacheTag()` for surgical invalidation
- [ ] No `cookies()`, `headers()`, `searchParams` in cached functions
- [ ] Return values are serializable
- [ ] Cache keys based on function arguments
- [ ] `cacheComponents: true` in next.config.ts

```ts
// ✅ CORRECT (Next.js 16.0.1)
import { unstable_cacheLife as cacheLife, unstable_cacheTag as cacheTag } from 'next/cache';
import { UserTags } from '@/lib/cache/tags';

async function getData(userId: string) {
  'use cache'
  cacheLife('minutes')  // 15min default
  cacheTag(UserTags.data(userId))
  return await db.query.data.findMany({ where: eq(data.userId, userId) });
}

// ❌ DEPRECATED
import { cacheWrap } from '@/lib/cache';
const data = await cacheWrap('key', fetchData, 300);
```

#### 2.3 Data Fetching ⭐ NEW
- [ ] Async Server Components for data fetching
- [ ] `fetch` API with proper cache options
- [ ] ORM/database queries in Server Components
- [ ] Parallel fetching with `Promise.all()`
- [ ] Request memoization with React `cache()`
- [ ] Proper streaming with `<Suspense>`
- [ ] Sequential fetching only when dependencies exist
- [ ] No fetch in Client Components (use `use` hook or SWR/React Query)

```ts
// ✅ CORRECT - Parallel fetching
export default async function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params

  // Initiate requests in parallel
  const artistData = getArtist(id)
  const albumsData = getAlbums(id)

  const [artist, albums] = await Promise.all([artistData, albumsData])

  return <ArtistPage artist={artist} albums={albums} />
}

// ✅ CORRECT - Request memoization for deduplication
import { cache } from 'react'

export const getUser = cache(async (id: string) => {
  return await db.query.users.findFirst({ where: eq(users.id, id) })
})

// ❌ WRONG - Sequential when could be parallel
const artist = await getArtist(id)
const albums = await getAlbums(id)  // Blocked by above
```

#### 2.4 Server Functions & Actions ⭐ NEW
- [ ] `'use server'` directive for mutations
- [ ] File-level or inline function-level usage
- [ ] Proper auth/validation in Server Actions
- [ ] Form actions with progressive enhancement
- [ ] `revalidatePath()`/`revalidateTag()` after mutations
- [ ] Error handling and user feedback
- [ ] No sensitive data exposure to client

```ts
// ✅ CORRECT - File-level Server Actions
'use server'

import { revalidatePath } from 'next/cache'
import { getUserId } from '@/lib/data/dal'

export async function createPost(formData: FormData) {
  const userId = await getUserId()  // Auth check
  const title = formData.get('title')

  // Validate input
  const validated = PostSchema.parse({ title })

  // Update data
  await db.insert(posts).values({ ...validated, userId })

  // Revalidate
  revalidatePath('/posts')
}

// ✅ CORRECT - Form with Server Action
export function Form() {
  return (
    <form action={createPost}>
      <input type="text" name="title" />
      <button type="submit">Create</button>
    </form>
  )
}

// ❌ WRONG - No auth check
export async function deletePost(id: string) {
  'use server'
  await db.delete(posts).where(eq(posts.id, id))  // No auth!
}
```

#### 2.5 Authentication ⭐ CRITICAL
- [ ] Server Components use DAL (`getUserId`, `getUser`, `verifySession`)
- [ ] No direct `supabase.auth.getUser()`
- [ ] Client Components use `useAuthUser()` or `useAuth()`

```ts
// ✅ Server Component
import { getUserId } from '@/lib/data/dal';
const userId = await getUserId();

// ❌ WRONG
const { data: { user } } = await supabase.auth.getUser();
```

#### 2.6 Streaming & Suspense
- [ ] `<Suspense>` boundaries for async components
- [ ] `loading.js` for route-level streaming
- [ ] Meaningful loading states (not just "Loading...")
- [ ] Granular streaming (not just whole page)
- [ ] Client Component `use` hook for promise unwrapping

```ts
// ✅ CORRECT - Streaming with Suspense
export default function BlogPage() {
  const posts = getPosts()  // Don't await

  return (
    <div>
      <h1>Blog</h1>
      <Suspense fallback={<BlogListSkeleton />}>
        <BlogList posts={posts} />
      </Suspense>
    </div>
  )
}

// Client Component using 'use' hook
'use client'
import { use } from 'react'

export function BlogList({ posts }: { posts: Promise<Post[]> }) {
  const allPosts = use(posts)  // Unwrap promise
  return <ul>{allPosts.map(post => <li key={post.id}>{post.title}</li>)}</ul>
}

// ❌ WRONG - Blocking entire page
export default async function BlogPage() {
  const posts = await getPosts()  // Blocks everything
  return <ul>{posts.map(post => <li key={post.id}>{post.title}</li>)}</ul>
}
```

#### 2.7 Server/Client Components
- [ ] Server Components async for data fetching
- [ ] `"use client"` only when necessary
- [ ] No hooks in Server Components

#### 2.8 Database Patterns
- [ ] Drizzle operators from `drizzle-orm` (NOT `@/lib/db`)
- [ ] Use repositories over queries module
- [ ] Balance helpers for encryption

```ts
// ✅ CORRECT
import { eq, and } from 'drizzle-orm';

// ❌ WRONG
import { eq, and } from '@/lib/db';
```

#### 2.9 React 19 Patterns
- [ ] No unnecessary `useEffect`
- [ ] Derive state when possible
- [ ] Event handlers for side effects
- [ ] Modern hooks (`useSyncExternalStore`)

#### 2.10 API Routes
- [ ] `export async function GET/POST` syntax
- [ ] Cacheable logic in `'use cache'` helpers
- [ ] Zod validation

#### 2.11 Security
- [ ] Zod validation for inputs
- [ ] DOMPurify for HTML sanitization
- [ ] No XSS vulnerabilities

#### 2.12 Performance
- [ ] `next/image` instead of `<img>`
- [ ] Dynamic imports for heavy components

#### 2.13 Accessibility
- [ ] Semantic HTML
- [ ] `<button>` not `<div onClick>`
- [ ] Form labels with `htmlFor`
- [ ] ARIA when needed
- [ ] Keyboard navigation support

#### 2.14 Build & Configuration
- [ ] `cacheComponents: true` in next.config.ts for Cache Components
- [ ] Node.js 20.9+ requirement met
- [ ] TypeScript 5.1.0+ for proper type inference
- [ ] No manual linting in `next build` (use scripts)
- [ ] Proper runtime configuration (Node.js not Edge for Cache Components)

```ts
// next.config.ts
const nextConfig: NextConfig = {
  cacheComponents: true,  // Required for 'use cache'
}

// ❌ WRONG - Edge runtime incompatible with Cache Components
export const runtime = 'edge'
export async function GET() {
  'use cache'  // Won't work!
}
```

#### 2.15 fetch API Patterns
- [ ] Proper cache options (`cache: 'no-store'` for dynamic)
- [ ] No default caching assumptions (not cached by default in Next.js 16)
- [ ] `logging` config for dev debugging
- [ ] AbortSignal for opt-out of request memoization

```ts
// ✅ CORRECT - Explicit cache control
const data = await fetch('https://api.example.com/data', {
  cache: 'no-store'  // Always fresh
})

// ✅ CORRECT - Force cache
const cached = await fetch('https://api.example.com/data', {
  cache: 'force-cache'
})

// ❌ WRONG - Assuming caching behavior
const data = await fetch('https://api.example.com/data')  // Not cached by default!
```

#### 2.16 Server and Client Components Architecture ⭐ CRITICAL
- [ ] Server Components by default (no `"use client"` unless necessary)
- [ ] `"use client"` only for interactivity (state, events, browser APIs)
- [ ] Proper data flow: Server → Client via props (serializable)
- [ ] No hooks in Server Components
- [ ] Client Components wrapped for third-party libraries
- [ ] Context providers in Server Components when possible
- [ ] `server-only`/`client-only` packages for environment protection

```ts
// ✅ CORRECT - Server Component (default)
export default async function Page() {
  const data = await fetchData()  // Server-side data fetching
  return <ClientComponent data={data} />
}

// ✅ CORRECT - Client Component (when needed)
'use client'
export function InteractiveButton() {
  const [count, setCount] = useState(0)  // State requires client
  return <button onClick={() => setCount(count + 1)}>{count}</button>
}

// ✅ CORRECT - Data flow via props
export function ClientComponent({ data }: { data: SerializableData }) {
  return <div>{data.title}</div>
}

// ❌ WRONG - Fetching in Client Component
'use client'
export function BadComponent() {
  const [data, setData] = useState(null)
  useEffect(() => {
    fetch('/api/data').then(setData)  // Should be in Server Component
  }, [])
  return <div>{data?.title}</div>
}
```

#### 2.17 Linking and Navigation Patterns ⭐ HIGH PRIORITY
- [ ] `<Link>` component for all internal navigation
- [ ] Prefetching enabled by default (disable only for large lists)
- [ ] `loading.js` for dynamic routes to enable streaming
- [ ] Client-side transitions preserve shared layouts
- [ ] Native History API integration (`pushState`/`replaceState`)
- [ ] `useLinkStatus` for slow networks
- [ ] Hover prefetching for performance-critical links

```ts
// ✅ CORRECT - Basic navigation
import Link from 'next/link'

export function Nav() {
  return (
    <nav>
      <Link href="/dashboard">Dashboard</Link>  {/* Prefetched */}
      <Link href="/profile">Profile</Link>
    </nav>
  )
}

// ✅ CORRECT - Loading states for dynamic routes
// app/blog/[slug]/loading.tsx
export default function Loading() {
  return <div>Loading article...</div>
}

// ✅ CORRECT - Native History API
'use client'
import { useSearchParams } from 'next/navigation'

export function SortButton() {
  const searchParams = useSearchParams()

  const updateSort = (order: string) => {
    const params = new URLSearchParams(searchParams.toString())
    params.set('sort', order)
    window.history.pushState(null, '', `?${params.toString()}`)
  }

  return (
    <button onClick={() => updateSort('asc')}>Sort A-Z</button>
  )
}

// ❌ WRONG - Regular anchor tags (no prefetching)
export function BadNav() {
  return <a href="/dashboard">Dashboard</a>  {/* No prefetch */}
}
```

#### 2.18 Layouts and Pages Structure ⭐ HIGH PRIORITY
- [ ] Root layout required with `<html>` and `<body>`
- [ ] Nested layouts for shared UI
- [ ] Dynamic segments with `[param]` syntax
- [ ] `params` Promise in Server Components
- [ ] `searchParams` Promise for query parameters
- [ ] `generateStaticParams` for static generation
- [ ] Route groups for organization (`(auth)`, `(public)`)
- [ ] `PageProps` and `LayoutProps` type helpers

```ts
// ✅ CORRECT - Root layout
// app/layout.tsx
export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <nav>Navigation</nav>
        {children}
      </body>
    </html>
  )
}

// ✅ CORRECT - Nested layout
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div>
      <h1>Dashboard</h1>
      {children}
    </div>
  )
}

// ✅ CORRECT - Dynamic route with params
// app/blog/[slug]/page.tsx
export default async function Page({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  const { slug } = await params
  const post = await getPost(slug)
  return <article>{post.content}</article>
}

// ✅ CORRECT - Search params
export default async function SearchPage({
  searchParams,
}: {
  searchParams: Promise<{ q: string }>
}) {
  const { q } = await searchParams
  const results = await search(q)
  return <SearchResults results={results} />
}

// ❌ WRONG - Synchronous params access (Next.js 15 style)
export default function BadPage({ params }: { params: { slug: string } }) {
  const post = getPost(params.slug)  // params is now a Promise!
  return <div>{post.title}</div>
}
```

#### 2.19 Error Handling Patterns ⭐ HIGH PRIORITY
- [ ] Expected errors as return values (not thrown)
- [ ] `useActionState` for Server Function errors
- [ ] Error boundaries with `error.js` files
- [ ] `notFound()` for 404 states
- [ ] `global-error.js` for root-level errors
- [ ] Nested error boundaries for granular handling
- [ ] Client-side error catching in event handlers

```ts
// ✅ CORRECT - Expected errors as return values
// app/actions.ts
'use server'
export async function createPost(formData: FormData) {
  const title = formData.get('title')

  const res = await fetch('/api/posts', { method: 'POST', body: { title } })
  if (!res.ok) {
    return { error: 'Failed to create post' }  // Return, don't throw
  }

  return { success: true }
}

// ✅ CORRECT - useActionState for error handling
'use client'
import { useActionState } from 'react'

export function CreatePostForm() {
  const [state, action] = useActionState(createPost, { error: null })

  return (
    <form action={action}>
      <input name="title" />
      <button type="submit">Create</button>
      {state.error && <p>{state.error}</p>}
    </form>
  )
}

// ✅ CORRECT - Error boundary
// app/dashboard/error.tsx
'use client'
export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}

// ✅ CORRECT - Not found handling
// app/blog/[slug]/page.tsx
export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const post = await getPost(slug)

  if (!post) {
    notFound()  // Shows not-found.tsx
  }

  return <Post post={post} />
}

// ❌ WRONG - Throwing expected errors
export async function badCreatePost(formData: FormData) {
  'use server'
  const res = await fetch('/api/posts', { method: 'POST' })
  if (!res.ok) {
    throw new Error('Failed to create post')  // Don't throw expected errors!
  }
}
```

#### 2.20 Proxy and Request Interception ⭐ MEDIUM
- [ ] `proxy.ts` in project root for request modification
- [ ] Quick redirects based on request data
- [ ] Header manipulation for all/some routes
- [ ] A/B testing and experimentation routing
- [ ] Optimistic auth checks (not full auth)
- [ ] No slow data fetching in proxy
- [ ] Single proxy file per project

```ts
// ✅ CORRECT - Basic proxy setup
// proxy.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function proxy(request: NextRequest) {
  // Quick redirect based on request
  if (request.nextUrl.pathname === '/old-path') {
    return NextResponse.redirect(new URL('/new-path', request.url))
  }

  // Header manipulation
  const response = NextResponse.next()
  response.headers.set('x-custom-header', 'value')

  return response
}

export const config = {
  matcher: '/api/:path*',  // Only API routes
}

// ✅ CORRECT - A/B testing
export function proxy(request: NextRequest) {
  const userId = request.cookies.get('userId')?.value
  const variant = getVariant(userId)  // A or B

  if (variant === 'B') {
    return NextResponse.rewrite(new URL('/experiment-b', request.url))
  }

  return NextResponse.next()
}

// ❌ WRONG - Slow operations in proxy
export function badProxy(request: NextRequest) {
  // Don't do this - proxy should be fast
  const user = await db.query.users.findFirst({ /* slow query */ })
  return NextResponse.next()
}
```

#### 2.21 Advanced Caching Patterns ⭐ HIGH PRIORITY
- [ ] Cache Components migration complete (no `cacheWrap`)
- [ ] Proper cache tags for surgical invalidation
- [ ] Request memoization with React `cache()`
- [ ] Cache performance monitoring
- [ ] Stale-while-revalidate with `revalidateTag('tag', 'max')`
- [ ] Cache key strategies (user-scoped, global data)
- [ ] Cache life settings (minutes/hours/days based on data type)

```ts
// ✅ CORRECT - Cache Components pattern
import { unstable_cacheLife as cacheLife, unstable_cacheTag as cacheTag } from 'next/cache'
import { UserTags } from '@/lib/cache/tags'

export async function getUserAccounts(userId: string) {
  'use cache'
  cacheLife('minutes')  // 5-15 min for user data
  cacheTag(UserTags.accounts(userId))

  return await db.query.accounts.findMany({
    where: eq(accounts.userId, userId)
  })
}

// ✅ CORRECT - Request memoization
import { cache } from 'react'

export const getUserById = cache(async (id: string) => {
  return await db.query.users.findFirst({
    where: eq(users.id, id)
  })
})

// ✅ CORRECT - Stale-while-revalidate
import { revalidateTag } from 'next/cache'

export async function updateAccount(accountId: string, data: UpdateData) {
  // Update database
  await db.update(accounts).set(data).where(eq(accounts.id, accountId))

  // Stale-while-revalidate: serve stale, fetch fresh in background
  revalidateTag(UserTags.accounts(data.userId), 'max')
}

// ❌ WRONG - Cache key without user scoping
export async function getAccounts() {  // No userId parameter!
  'use cache'
  cacheTag('accounts')  // Global tag - wrong!
  return await db.query.accounts.findMany()  // Returns ALL accounts!
}
```

#### 2.22 React 19 Advanced Patterns ⭐ MEDIUM
- [ ] `use` hook for promise unwrapping in Client Components
- [ ] Actions with `useTransition` for pending states
- [ ] `useDeferredValue` for non-urgent updates
- [ ] `useSyncExternalStore` for external state integration
- [ ] Server Functions with optimistic updates
- [ ] Form handling with `useActionState`

```ts
// ✅ CORRECT - use hook for promises
'use client'
import { use } from 'react'

export function UserProfile({ userPromise }: { userPromise: Promise<User> }) {
  const user = use(userPromise)  // Unwrap promise
  return <div>{user.name}</div>
}

// ✅ CORRECT - Actions with transitions
'use client'
import { useTransition } from 'react'

export function UpdateButton() {
  const [isPending, startTransition] = useTransition()

  const handleUpdate = () => {
    startTransition(async () => {
      await updateUser({ name: 'New Name' })
    })
  }

  return (
    <button onClick={handleUpdate} disabled={isPending}>
      {isPending ? 'Updating...' : 'Update'}
    </button>
  )
}

// ✅ CORRECT - useActionState for forms
'use client'
import { useActionState } from 'react'

export function UserForm() {
  const [state, action, isPending] = useActionState(updateUser, initialState)

  return (
    <form action={action}>
      <input name="name" defaultValue={state.name} />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Saving...' : 'Save'}
      </button>
      {state.error && <p>{state.error}</p>}
    </form>
  )
}

// ❌ WRONG - Manual promise handling
'use client'
export function BadUserProfile({ userPromise }: { userPromise: Promise<User> }) {
  const [user, setUser] = useState<User | null>(null)

  useEffect(() => {
    userPromise.then(setUser)  // Manual promise handling - use 'use' hook instead
  }, [userPromise])

  if (!user) return <div>Loading...</div>
  return <div>{user.name}</div>
}
```

#### 2.23 Streaming and Suspense Boundaries ⭐ HIGH PRIORITY
- [ ] Route-level `loading.js` for instant navigation
- [ ] Component-level `<Suspense>` for granular loading
- [ ] Meaningful loading skeletons (not generic spinners)
- [ ] Sequential vs parallel data fetching decisions
- [ ] Error boundaries around Suspense boundaries
- [ ] Streaming for dynamic routes with `loading.js`

```ts
// ✅ CORRECT - Route-level loading
// app/dashboard/loading.tsx
export default function Loading() {
  return (
    <div className="space-y-4">
      <div className="h-8 bg-gray-200 rounded animate-pulse" />
      <div className="h-32 bg-gray-200 rounded animate-pulse" />
      <div className="h-16 bg-gray-200 rounded animate-pulse" />
    </div>
  )
}

// ✅ CORRECT - Component-level Suspense
export default function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>
      <Suspense fallback={<ChartSkeleton />}>
        <RevenueChart />
      </Suspense>
      <Suspense fallback={<TableSkeleton />}>
        <TransactionsTable />
      </Suspense>
    </div>
  )
}

// ✅ CORRECT - Async component with Suspense
export async function RevenueChart() {
  const data = await getRevenueData()  // Slow operation
  return <Chart data={data} />
}

// ❌ WRONG - Blocking entire page
export default async function BadDashboard() {
  const revenueData = await getRevenueData()  // Blocks everything
  const transactions = await getTransactions()  // Still blocked

  return (
    <div>
      <RevenueChart data={revenueData} />
      <TransactionsTable data={transactions} />
    </div>
  )
}
```

#### 2.24 Security Best Practices ⭐ CRITICAL
- [ ] Server-only code protection with `server-only` package
- [ ] Client-only code protection with `client-only` package
- [ ] Input sanitization with DOMPurify for HTML content
- [ ] SQL injection prevention (use Drizzle ORM properly)
- [ ] XSS prevention in dynamic content
- [ ] CSRF protection for forms
- [ ] Secure headers in proxy or middleware

```ts
// ✅ CORRECT - Server-only protection
// lib/server-utils.ts
import 'server-only'

export function getSecretKey() {
  return process.env.SECRET_KEY  // Safe - only runs on server
}

// ✅ CORRECT - Input sanitization
import DOMPurify from 'isomorphic-dompurify'

export function sanitizeHtml(dirty: string): string {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ['p', 'br', 'strong', 'em'],
    ALLOWED_ATTR: []
  })
}

// ✅ CORRECT - Secure proxy headers
// proxy.ts
export function proxy(request: NextRequest) {
  const response = NextResponse.next()

  // Security headers
  response.headers.set('X-Frame-Options', 'DENY')
  response.headers.set('X-Content-Type-Options', 'nosniff')
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin')

  return response
}

// ❌ WRONG - Client-accessible secrets
// lib/config.ts (no server-only import)
export const config = {
  apiKey: process.env.API_KEY  // Exposed to client!
}
```

#### 2.25 Performance Optimization Patterns ⭐ MEDIUM
- [ ] Dynamic imports for code splitting
- [ ] `next/image` with proper sizing and formats
- [ ] Preload critical resources
- [ ] Bundle analysis and tree shaking
- [ ] Selective hydration strategies
- [ ] Web vitals optimization (LCP, FID, CLS)

```ts
// ✅ CORRECT - Dynamic imports
'use client'
import { useState } from 'react'

export function HeavyComponent() {
  const [showChart, setShowChart] = useState(false)

  return (
    <div>
      <button onClick={() => setShowChart(true)}>Show Chart</button>
      {showChart && (
        <Suspense fallback={<div>Loading chart...</div>}>
          <dynamic import('./HeavyChart') />
        </Suspense>
      )}
    </div>
  )
}

// ✅ CORRECT - Optimized images
import Image from 'next/image'

export function ProductCard({ product }: { product: Product }) {
  return (
    <div>
      <Image
        src={product.image}
        alt={product.name}
        width={300}
        height={200}
        sizes="(max-width: 768px) 100vw, 50vw"
        priority={product.featured}  // Only for above-the-fold
      />
      <h3>{product.name}</h3>
    </div>
  )
}

// ❌ WRONG - Regular img tags
export function BadProductCard({ product }: { product: Product }) {
  return (
    <div>
      <img
        src={product.image}
        alt={product.name}
        width={300}
        height={200}
        // No optimization, no responsive sizing
      />
    </div>
  )
}
```

#### 2.26 Accessibility (A11y) Standards ⭐ MEDIUM
- [ ] Semantic HTML elements (`<main>`, `<nav>`, `<article>`)
- [ ] Proper heading hierarchy (h1 → h2 → h3)
- [ ] Focus management and keyboard navigation
- [ ] ARIA labels and descriptions when needed
- [ ] Color contrast ratios
- [ ] Screen reader friendly content
- [ ] Form accessibility (labels, errors, instructions)

```ts
// ✅ CORRECT - Semantic structure
export function ArticlePage({ article }: { article: Article }) {
  return (
    <main>
      <header>
        <h1>{article.title}</h1>
        <p>By {article.author}</p>
      </header>

      <article>
        <h2>Introduction</h2>
        <p>{article.intro}</p>

        <h2>Main Content</h2>
        <p>{article.content}</p>
      </article>

      <aside aria-label="Related articles">
        <h2>Related</h2>
        <ul>
          {article.related.map(item => (
            <li key={item.id}>
              <a href={`/articles/${item.slug}`}>{item.title}</a>
            </li>
          ))}
        </ul>
      </aside>
    </main>
  )
}

// ✅ CORRECT - Accessible forms
export function ContactForm() {
  return (
    <form>
      <div>
        <label htmlFor="email">Email address</label>
        <input
          id="email"
          name="email"
          type="email"
          aria-describedby="email-help email-error"
          required
        />
        <div id="email-help">We'll never share your email.</div>
        <div id="email-error" role="alert" aria-live="polite">
          {errors.email}
        </div>
      </div>

      <button type="submit">Send message</button>
    </form>
  )
}

// ❌ WRONG - Poor accessibility
export function BadForm() {
  return (
    <div>
      <input placeholder="Enter email" />  {/* No label! */}
      <div onClick={handleSubmit}>Submit</div>  {/* Not a button! */}
    </div>
  )
}
```

#### 2.27 Metadata & SEO ⭐ HIGH PRIORITY
- [ ] `metadata` and `generateMetadata` usage validated
- [ ] OpenGraph and Twitter card completeness
- [ ] Canonical URLs set correctly
- [ ] `robots.txt` correctness
- [ ] Proper locale alternates with `alternateLanguages`
- [ ] Sitemap.xml generation
- [ ] Structured data (JSON-LD) for rich snippets

```ts
// ✅ CORRECT - Static metadata
// app/page.tsx
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Clarity - Personal Finance Management',
  description: 'Track your finances with privacy-first tools',
  openGraph: {
    title: 'Clarity - Personal Finance Management',
    description: 'Track your finances with privacy-first tools',
    url: 'https://clarity.example.com',
    siteName: 'Clarity',
    images: [
      {
        url: 'https://clarity.example.com/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Clarity Preview',
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Clarity - Personal Finance Management',
    description: 'Track your finances with privacy-first tools',
    images: ['https://clarity.example.com/twitter-image.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
    },
  },
}

// ✅ CORRECT - Dynamic metadata
// app/blog/[slug]/page.tsx
export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>
}): Promise<Metadata> {
  const { slug } = await params
  const post = await getPost(slug)

  return {
    title: post.title,
    description: post.excerpt,
    alternates: {
      canonical: `https://clarity.example.com/blog/${slug}`,
    },
    openGraph: {
      title: post.title,
      description: post.excerpt,
      type: 'article',
      publishedTime: post.publishedAt,
      authors: [post.author],
    },
  }
}

// ❌ WRONG - Missing metadata
export default function Page() {
  return <div>My Page</div>  // No SEO metadata!
}
```

#### 2.28 Build & Deployment Configuration ⭐ MEDIUM
- [ ] Environment variables validated on boot
- [ ] Build output checked for deterministic hashes
- [ ] Next telemetry disabled (if compliance requires)
- [ ] Proper `engines` specified in package.json
- [ ] Package manager locked (`packageManager` field)

```ts
// ✅ CORRECT - Environment validation on boot
// lib/config/env.ts
import { z } from 'zod'

const EnvSchema = z.object({
  DATABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
  ENCRYPTION_KEY: z.string().length(64), // 32 bytes hex
  NODE_ENV: z.enum(['development', 'production', 'test']),
})

// Validate on boot - throws if invalid
export const env = EnvSchema.parse(process.env)

// ✅ CORRECT - package.json engines
{
  "engines": {
    "bun": ">=1.1.0",
    "node": "22.x"
  },
  "packageManager": "bun@1.2.23"
}

// ✅ CORRECT - Disable telemetry (if needed)
// next.config.ts
const nextConfig: NextConfig = {
  experimental: {
    telemetry: false, // Disable if compliance requires
  },
}
```

#### 2.29 Static Generation (ISR / Prerendering) ⭐ HIGH PRIORITY
- [ ] `generateStaticParams` and `revalidate` behavior tested
- [ ] Incremental cache invalidation paths documented
- [ ] ISR correctness on preview mode
- [ ] Proper fallback modes (`blocking` vs `true`) explained
- [ ] Static generation for public pages
- [ ] Dynamic rendering for authenticated pages

```ts
// ✅ CORRECT - Static generation with ISR
// app/blog/[slug]/page.tsx
export const revalidate = 3600 // Revalidate every hour

export async function generateStaticParams() {
  const posts = await getPosts()
  return posts.map((post) => ({
    slug: post.slug,
  }))
}

export default async function Page({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  const { slug } = await params
  const post = await getPost(slug)

  if (!post) {
    notFound()
  }

  return <BlogPost post={post} />
}

// ✅ CORRECT - Preview mode with draft handling
// app/blog/[slug]/page.tsx
import { draftMode } from 'next/headers'

export default async function Page({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  const { slug } = await params
  const { isEnabled } = await draftMode()

  // Fetch draft content if preview mode enabled
  const post = await getPost(slug, { draft: isEnabled })

  return <BlogPost post={post} />
}

// ❌ WRONG - No static params
export default async function Page({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  // Missing generateStaticParams - all pages rendered on-demand!
  const { slug } = await params
  return <div>{slug}</div>
}
```

#### 2.30 Dependency Governance ⭐ MEDIUM
- [ ] Zero transitive vulnerabilities (via `npm audit` or OSV scanner)
- [ ] No deprecated packages in production dependencies
- [ ] Peer dependency ranges verified
- [ ] Licenses scanned and compliant
- [ ] Package overrides justified and documented
- [ ] Lock file (`bun.lock`) committed and integrity verified

**Current Project Dependencies**:
```json
// package.json - Clarity dependencies as of 2025-11
{
  "engines": {
    "bun": ">=1.1.0",
    "node": "22.x"
  },
  "packageManager": "bun@1.2.23",
  "dependencies": {
    // Core framework
    "next": "16.0.1",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",

    // Database & ORM
    "drizzle-orm": "^0.44.6",
    "postgres": "^3.4.7",
    "@supabase/supabase-js": "^2.76.1",

    // Validation & Type safety
    "zod": "^4.1.12",

    // UI & Styling
    "tailwindcss": "^3.4.1",
    "framer-motion": "^12.23.24",
    "lucide-react": "^0.428.0",

    // Banking & Finance
    "plaid": "^39.0.0",
    "stripe": "^18.5.0",
    "ccxt": "^4.5.11",

    // Utilities
    "date-fns": "^4.1.0",
    "decimal.js-light": "^2.5.1",
    "nanoid": "^5.1.5"
  },
  "overrides": {
    // React 19 compatibility overrides
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "next": "^16.0.0"
  }
}
```

**Checklist**:
```bash
# Check for vulnerabilities
bun audit

# Check for deprecated packages
npx npm-check-updates --deprecated

# Verify peer dependencies
bun install --frozen-lockfile

# Scan licenses (ensure MIT/Apache/BSD compatible)
npx license-checker --production --summary
```

**Example**:
```ts
// ✅ CORRECT - Documented overrides
// package.json
{
  "overrides": {
    // React 19 compatibility: Some @radix-ui packages still on React 18
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  }
}

// ❌ WRONG - Undocumented overrides
{
  "overrides": {
    "lodash": "4.17.21"  // Why? Security patch? Breaking change? Document it!
  }
}
```

### 3. Generate Report

```markdown
## File: [path]
**Type**: [Server Component/Client Component/API Route/etc.]
**Compliance Score**: X/100

### ✅ Strengths
- What's done well

### 🚨 Critical (Must Fix)
1. **Line X**: Issue
   - Current: `code`
   - Fix: `corrected code`
   - Impact: why important

### ⚠️ Warnings (Should Fix)
1. **Line Y**: Issue
   - Suggestion: improvement

### ℹ️ Suggestions
1. Optional improvements

### 🔧 Auto-Fix
[Exact Edit commands]
```

## Scoring

**Rubric** (30 Core Categories):
- Critical (30%): Security, auth, type safety, Server/Client architecture
- High (40%): Data fetching, Server Functions, caching, navigation, layouts, error handling, streaming, metadata/SEO, ISR
- Medium (20%): React 19 patterns, proxy, database, performance, accessibility, build config, dependency governance
- Low (10%): API routes, code quality

**Grades**:
- 95-100: Excellent ⭐⭐⭐⭐⭐ (Next.js 16 expert level - production gold standard)
- 85-94: Good ⭐⭐⭐⭐ (Production ready with minor improvements needed)
- 75-84: Acceptable ⭐⭐⭐ (Functional but needs optimization)
- 65-74: Needs Work ⚠️ (Multiple issues requiring attention)
- <65: Critical Issues 🚨 (Not production ready - major refactoring needed)

## Key Rules

### Type Centralization ⚠️ ENFORCED
**Canonical**: `/Users/zach/Documents/clarity/lib/types`

ALL domain types ONLY in `@/lib/types`:
- Transaction, Account, User, Connection, Asset, Portfolio, Holding, Institution

**Exceptions** (must document):
1. Presentation layer types (UI-specific)
2. Utility minimal interfaces (e.g., `Dateable`)
3. Type re-exports

### Import Restrictions
- `@vercel/kv` → Use `@/lib/utils/kv`
- Drizzle → Import from `drizzle-orm`
- Types → Import from `@/lib/types`

### Caching Migration
- `cacheWrap` DEPRECATED → Use `'use cache'`
- Extract cacheable logic to helper functions

### Auth Patterns
- Server Components → DAL (`getUserId`, `getUser`)
- Client Components → `useAuthUser()`
- API Routes → `getUserId()` from DAL

## Output Format

Provide:
1. File classification & context
2. Compliance score (0-100)
3. Categorized findings (Critical/Warning/Suggestion)
4. Exact code with line numbers
5. Auto-fix instructions
6. Score improvement path

## Success Criteria

**File passes audit if ALL of the following**:
- ✅ Zero critical errors (security, auth, architecture violations)
- ✅ < 5 total warnings across all categories
- ✅ Score > 80/100 (Good or Excellent grade)
- ✅ No deprecated patterns (`cacheWrap`, old auth patterns)
- ✅ Type safety maintained (no `any`, proper imports)
- ✅ Next.js 16 patterns used correctly (Server/Client boundaries, caching)

**Project passes audit if**:
- ✅ Average score > 85/100 across all audited files
- ✅ Zero critical errors in any file
- ✅ < 10 total warnings across entire codebase
- ✅ All core architecture patterns implemented correctly

## Migration Guides & Common Pitfalls

### Next.js 15 → 16 Migration Issues

#### 1. Async Params Breaking Change 🚨 CRITICAL
```ts
// ❌ BROKEN - Next.js 15 style (fails in 16)
export default function Page({ params }: { params: { slug: string } }) {
  const post = getPost(params.slug)  // params is now async!
}

// ✅ FIXED - Next.js 16 style
export default async function Page({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  const { slug } = await params  // Await the Promise
  const post = await getPost(slug)
}
```

#### 2. Cache Components Migration 🚨 HIGH PRIORITY
```ts
// ❌ DEPRECATED - Remove all instances
import { cacheWrap } from '@/lib/cache'
const data = await cacheWrap('key', fetchData, 300)

// ✅ MIGRATE TO - Cache Components
import { unstable_cacheLife as cacheLife } from 'next/cache'

export async function getData() {
  'use cache'
  cacheLife('minutes')
  return await fetchData()
}
```

#### 3. Fetch API Changes ⚠️ MEDIUM
```ts
// ❌ CHANGED - fetch() no longer cached by default
const data = await fetch('/api/data')  // Not cached!

// ✅ FIX - Explicit cache control
const data = await fetch('/api/data', { cache: 'force-cache' })
```

#### 4. Server Functions Location ⚠️ MEDIUM
```ts
// ❌ WRONG - Server Functions in client components
'use client'
export async function mutateData() {  // Can't use 'use server' in client component
  'use server'
  // ...
}

// ✅ CORRECT - Server Functions in separate files or server components
// app/actions.ts
'use server'
export async function mutateData() {
  // Server Function logic
}
```

### Common Architecture Violations

#### Type Centralization Violations 🚨 CRITICAL
- Defining domain types locally instead of importing from `@/lib/types`
- Using `any` types instead of proper Zod schemas
- Duplicate type definitions across files

#### Auth Pattern Violations 🚨 CRITICAL
- Direct `supabase.auth.getUser()` calls in Server Components
- Missing DAL usage (`getUserId`, `verifySession`)
- Client Components not using `useAuthUser()`

#### Caching Anti-Patterns 🚨 HIGH PRIORITY
- Mixing `cacheWrap` and Cache Components
- No cache tags for invalidation
- Caching non-serializable data
- Using `cookies()`/`headers()` in cached functions

#### Component Boundary Issues ⚠️ MEDIUM
- Overusing `"use client"` when Server Components would work
- Fetching data in Client Components
- Passing non-serializable props to Client Components

### Performance Bottlenecks to Watch

#### 1. Waterfall Data Fetching
```ts
// ❌ BAD - Sequential blocking
const user = await getUser(id)
const posts = await getPosts(user.id)  // Waits for user
const comments = await getComments(posts[0].id)  // Waits for posts

// ✅ GOOD - Parallel fetching
const userPromise = getUser(id)
const postsPromise = getPosts(id)
const [user, posts] = await Promise.all([userPromise, postsPromise])
```

#### 2. Missing Loading States
```ts
// ❌ BAD - No loading UI for dynamic routes
// Missing app/blog/[slug]/loading.tsx

// ✅ GOOD - Instant feedback
export default function Loading() {
  return <div>Loading article...</div>
}
```

#### 3. Unnecessary Client Components
```ts
// ❌ BAD - Client component for static content
'use client'
export function StaticHeader() {
  return <h1>My App</h1>  // No interactivity needed!
}

// ✅ GOOD - Server Component by default
export function StaticHeader() {
  return <h1>My App</h1>
}
```

### Debugging Checklist

When audits fail, check these first:
1. **Type errors**: Run `bun run typecheck`
2. **Lint errors**: Run `bun run lint`
3. **Build errors**: Run `bun run build`
4. **Cache configuration**: Verify `cacheComponents: true` in `next.config.ts`
5. **Import paths**: Ensure `@/lib/types` imports work
6. **Environment variables**: Check `.env` setup
7. **Database connection**: Verify Drizzle configuration

## Resources

**Official Next.js 16 Documentation**:
- [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components) - Component architecture patterns
- [Linking and Navigating](https://nextjs.org/docs/app/getting-started/linking-and-navigating) - Navigation, prefetching, streaming
- [Layouts and Pages](https://nextjs.org/docs/app/getting-started/layouts-and-pages) - Route structure, dynamic segments
- [Caching and Revalidating](https://nextjs.org/docs/app/getting-started/caching-and-revalidating) - Cache API, revalidation strategies
- [Error Handling](https://nextjs.org/docs/app/getting-started/error-handling) - Error boundaries, expected errors
- [Proxy](https://nextjs.org/docs/app/api-reference/file-conventions/proxy) - Request/response interception

**Local Resources**:
See `resources/` for detailed docs:
- `SKILL.md` - Full methodology (1200+ lines)
- `CHECKLIST.md` - File-type checklists
- `USAGE.md` - Usage examples
- `quick-reference.md` - Quick lookups
- `nextjs-16-reference.md` - Official docs integration

## Extended Engineering Standards (30+ Additional Checks)

### 🔴 Critical Priority (Must Have)

#### Input/Output Contracts
- [ ] Runtime schema validation at boundaries (Zod/Valibot)
- [ ] Exact error messages with discriminated error types
- [ ] Type guards for all public API surfaces
- [ ] Validated output matches declared types

**Example**:
```ts
// ✅ CORRECT - Strong I/O contracts
import { z } from 'zod'

const InputSchema = z.object({
  email: z.string().email('Invalid email format'),
  age: z.number().int().positive('Age must be positive'),
})

export async function createUser(input: unknown) {
  const validated = InputSchema.parse(input)  // Throws with exact message
  return await db.insert(users).values(validated)
}

// ❌ WRONG - No validation
export async function createUser(input: any) {
  return await db.insert(users).values(input)  // Unsafe!
}
```

#### Determinism & Purity
- [ ] Functions are referentially transparent (same input → same output)
- [ ] No hidden I/O or global state mutations
- [ ] Side effects isolated to dedicated modules
- [ ] Pure functions marked with JSDoc `@pure`

**Example**:
```ts
// ✅ CORRECT - Pure function
/** @pure */
export function calculateTax(amount: number, rate: number): number {
  return amount * rate
}

// ❌ WRONG - Hidden side effects
let total = 0
export function addToTotal(amount: number): void {
  total += amount  // Global state mutation!
}
```

#### Cancellation Safety
- [ ] All async operations support AbortSignal
- [ ] Cleanup guaranteed on abort
- [ ] No resource leaks on cancellation
- [ ] Timeout mechanisms properly configured

**Example**:
```ts
// ✅ CORRECT - Abort support
export async function fetchData(
  url: string,
  signal?: AbortSignal
): Promise<Data> {
  const response = await fetch(url, { signal })
  return response.json()
}

// Usage with timeout
const controller = new AbortController()
const timeout = setTimeout(() => controller.abort(), 5000)

try {
  const data = await fetchData('/api/data', controller.signal)
} finally {
  clearTimeout(timeout)  // Cleanup guaranteed
}

// ❌ WRONG - No abort support
export async function badFetch(url: string): Promise<Data> {
  const response = await fetch(url)  // Can't be cancelled!
  return response.json()
}
```

#### Encoding & Unicode
- [ ] Handle graphemes/emoji correctly
- [ ] Unicode normalization (NFC/NFD) documented
- [ ] BOM handling for file I/O
- [ ] Avoid `string.length` pitfalls (use grapheme-aware libs)

**Example**:
```ts
// ✅ CORRECT - Grapheme-aware length
import { GraphemeBreaker } from 'unicode-grapheme-breaker'

export function getDisplayLength(text: string): number {
  return Array.from(GraphemeBreaker(text)).length
}

// ❌ WRONG - Emoji breaks this
export function badLength(text: string): number {
  return text.length  // "👨‍👩‍👧‍👦" returns 11 instead of 1!
}

// ✅ CORRECT - Normalization
export function normalizeInput(text: string): string {
  return text.normalize('NFC')  // Canonical composition
}
```

#### Time & Locale Invariants
- [ ] Timezone-safe date logic (use Temporal or date-fns-tz)
- [ ] DST edge cases handled
- [ ] Leap seconds awareness documented
- [ ] No `new Date()` without timezone

**Example**:
```ts
// ✅ CORRECT - TZ-safe
import { zonedTimeToUtc, utcToZonedTime } from 'date-fns-tz'

export function scheduleAt(time: Date, timezone: string): Date {
  return zonedTimeToUtc(time, timezone)
}

// ❌ WRONG - DST bugs
export function badSchedule(time: Date): Date {
  return new Date(time.getTime() + 86400000)  // +1 day breaks during DST!
}
```

#### Numerics & Precision
- [ ] Float drift guarded with epsilon comparisons
- [ ] Safe integer checks (`Number.isSafeInteger`)
- [ ] BigInt for values > 2^53
- [ ] Decimal precision for currency (Decimal.js or similar)

**Example**:
```ts
// ✅ CORRECT - Decimal precision for money
import Decimal from 'decimal.js'

export function calculateTotal(items: Array<{ price: string }>): string {
  return items
    .reduce((sum, item) => sum.plus(new Decimal(item.price)), new Decimal(0))
    .toFixed(2)
}

// ❌ WRONG - Float drift
export function badTotal(items: Array<{ price: number }>): number {
  return items.reduce((sum, item) => sum + item.price, 0)  // 0.1 + 0.2 = 0.30000000000000004
}
```

#### Side-Effect Policy
- [ ] Single place defines allowed side effects
- [ ] All other functions pure
- [ ] Side-effecting functions clearly marked
- [ ] Effect tracking with `server-only` package

**Example**:
```ts
// lib/effects/index.ts - SINGLE SOURCE OF TRUTH
import 'server-only'

/** Side-effecting functions - use sparingly */
export namespace Effects {
  export async function logAnalytics(event: Event): Promise<void> {
    await fetch('/api/analytics', { method: 'POST', body: JSON.stringify(event) })
  }

  export async function sendEmail(to: string, body: string): Promise<void> {
    await emailClient.send({ to, body })
  }
}

// ✅ CORRECT - Business logic is pure
export function processOrder(order: Order): OrderResult {
  // Pure logic
  const total = calculateTotal(order.items)
  return { orderId: order.id, total }
}

// Side effects isolated to orchestrator
export async function handleOrder(order: Order): Promise<void> {
  const result = processOrder(order)  // Pure
  await Effects.logAnalytics({ type: 'order', data: result })  // Effect
}
```

#### Secrets/PII Hygiene
- [ ] No PII in logs
- [ ] Redaction helpers used by all log paths
- [ ] Secrets never in client bundles
- [ ] Environment variable validation

**Example**:
```ts
// ✅ CORRECT - PII redaction
import { logger } from '@/lib/utils/logger'

const redactedFields = ['email', 'ssn', 'creditCard']

export function logUserAction(user: User, action: string): void {
  logger.info({
    userId: user.id,  // OK - identifier
    action,
    // PII redacted
    email: '[REDACTED]',
  }, 'User action')
}

// ❌ WRONG - PII leak
export function badLog(user: User, action: string): void {
  logger.info({ user, action }, 'User action')  // Logs email, SSN, etc!
}
```

#### Resource Boundaries
- [ ] Input size caps enforced (prevent DoS)
- [ ] Chunking limits for streaming
- [ ] Bailouts to prevent memory/CPU blowups
- [ ] Rate limiting on resource-intensive operations

**Example**:
```ts
// ✅ CORRECT - Resource limits
const MAX_FILE_SIZE = 10 * 1024 * 1024  // 10MB
const MAX_ITEMS = 1000

export async function processUpload(file: File): Promise<void> {
  if (file.size > MAX_FILE_SIZE) {
    throw new Error(`File too large (max ${MAX_FILE_SIZE} bytes)`)
  }
  // Process with chunking
  const chunks = file.stream().pipeThrough(new ChunkedStream(1024 * 1024))
  for await (const chunk of chunks) {
    await processChunk(chunk)
  }
}

// ❌ WRONG - No limits
export async function badProcess(file: File): Promise<void> {
  const data = await file.arrayBuffer()  // OOM on 1GB file!
  processData(data)
}
```

#### Platform Support Matrix
- [ ] Node LTS versions documented (`engines` in package.json)
- [ ] Browser targets in `browserslist`
- [ ] Tested on documented platforms
- [ ] Polyfills for missing features

**Example**:
```json
// package.json
{
  "engines": {
    "node": ">=20.9.0",
    "bun": ">=1.1.0"
  },
  "browserslist": [
    ">0.2%",
    "not dead",
    "not op_mini all",
    "last 2 Chrome versions",
    "last 2 Firefox versions",
    "last 2 Safari versions"
  ]
}
```

### ⚡ High Priority (Should Have)

#### API Stability & SemVer
- [ ] Public surface labeled with JSDoc `@public`
- [ ] Breaking change checklist followed
- [ ] Deprecation path for removed features
- [ ] CHANGELOG.md updated

**Example**:
```ts
/**
 * @public
 * @deprecated Use `getUserById` instead. Will be removed in v2.0.0
 */
export async function getUser(id: string): Promise<User> {
  return getUserById(id)
}

/**
 * @public
 * @since 1.5.0
 */
export async function getUserById(id: string): Promise<User> {
  return await db.query.users.findFirst({ where: eq(users.id, id) })
}
```

#### Error Taxonomy
- [ ] Discriminated error types (code, cause, isRecoverable)
- [ ] Never throw strings
- [ ] Error classes extend `Error`
- [ ] Stack traces preserved

**Example**:
```ts
// ✅ CORRECT - Error taxonomy
export class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public isRecoverable: boolean = false,
    public cause?: Error
  ) {
    super(message)
    this.name = 'AppError'
  }
}

export class ValidationError extends AppError {
  constructor(message: string, cause?: Error) {
    super(message, 'VALIDATION_ERROR', true, cause)
  }
}

// Usage
if (!user) {
  throw new AppError('User not found', 'USER_NOT_FOUND', false)
}

// ❌ WRONG - String errors
if (!user) {
  throw 'User not found'  // No stack trace, no metadata!
}
```

#### Observability Hooks
- [ ] Trace/span passthrough support
- [ ] Request ID propagation
- [ ] No hard dependencies on observability libs
- [ ] Optional hooks for monitoring

**Example**:
```ts
// ✅ CORRECT - Optional observability
export async function fetchData(
  url: string,
  options?: {
    signal?: AbortSignal
    traceId?: string
    span?: Span
  }
): Promise<Data> {
  options?.span?.addEvent('fetch_start', { url })

  const response = await fetch(url, {
    signal: options?.signal,
    headers: {
      'x-trace-id': options?.traceId || crypto.randomUUID(),
    },
  })

  options?.span?.addEvent('fetch_complete', { status: response.status })
  return response.json()
}
```

#### Package Hygiene
- [ ] `exports` field with proper entry points
- [ ] `types` field for TypeScript
- [ ] `typesVersions` for multi-version support
- [ ] `sideEffects: false` for tree-shaking
- [ ] `files` whitelist
- [ ] `engines` specified

**Example**:
```json
// package.json
{
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.cjs",
      "types": "./dist/index.d.ts"
    },
    "./utils": {
      "import": "./dist/utils.mjs",
      "types": "./dist/utils.d.ts"
    }
  },
  "types": "./dist/index.d.ts",
  "sideEffects": false,
  "files": ["dist", "README.md", "LICENSE"],
  "engines": {
    "node": ">=20.9.0"
  }
}
```

#### ESM/CJS Interop
- [ ] Dual entry points verified
- [ ] `node --experimental-modules` tested
- [ ] Bundler compatibility checked (webpack, vite, esbuild)
- [ ] Default exports avoided

**Example**:
```ts
// ✅ CORRECT - Named exports
export { fetchData, processData } from './data'
export type { Data, DataOptions } from './types'

// ❌ WRONG - Default exports (interop issues)
export default function fetchData() { /* ... */ }
```

#### Tree-Shaking Verified
- [ ] Bundle analyzer confirms dead code elimination
- [ ] No accidental top-level side effects
- [ ] `sideEffects: false` in package.json
- [ ] Import cost badges in README

**Example**:
```ts
// ✅ CORRECT - Pure module
export function utilA() { /* ... */ }
export function utilB() { /* ... */ }

// ❌ WRONG - Top-level side effect
console.log('Module loaded')  // Prevents tree-shaking!
export function utilA() { /* ... */ }
```

#### Source Maps & .d.ts Quality
- [ ] Clean source maps generated
- [ ] Zero `any` in public `.d.ts`
- [ ] Doc comments present for all exports
- [ ] Type tests for public API

**Example**:
```ts
// ✅ CORRECT - Fully typed with docs
/**
 * Fetches user data by ID
 * @param id - User identifier
 * @returns User object or null if not found
 * @throws {ValidationError} If ID format is invalid
 */
export async function getUserById(id: string): Promise<User | null> {
  return await db.query.users.findFirst({ where: eq(users.id, id) })
}

// ❌ WRONG - Any types
export async function getData(id: any): Promise<any> {
  return await db.query.data.findFirst({ where: eq(data.id, id) })
}
```

### 🟡 Medium Priority (Nice to Have)

#### Coverage Gates
- [ ] Minimum per-file thresholds (95% lines/branches)
- [ ] Enforced in CI
- [ ] Exported code has higher coverage than internals
- [ ] Coverage badges in README

**Example**:
```json
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      thresholds: {
        lines: 95,
        branches: 90,
        functions: 95,
        statements: 95
      }
    }
  }
})
```

#### Benchmarks & Budgets
- [ ] Microbenchmarks for hot paths
- [ ] Performance budgets in CI
- [ ] Regression detection
- [ ] Flame graphs for profiling

**Example**:
```ts
// ✅ CORRECT - Benchmark suite
import { bench } from 'vitest'

bench('calculateTotal - 100 items', () => {
  const items = Array(100).fill({ price: '10.00' })
  calculateTotal(items)
})

bench('calculateTotal - 1000 items', () => {
  const items = Array(1000).fill({ price: '10.00' })
  calculateTotal(items)
})
```

#### Async Correctness
- [ ] Idempotency guaranteed
- [ ] Race condition protection
- [ ] Concurrency limits enforced
- [ ] No unhandled rejections

**Example**:
```ts
// ✅ CORRECT - Idempotent with concurrency limit
import pLimit from 'p-limit'

const limit = pLimit(5)  // Max 5 concurrent requests

export async function syncAccounts(accountIds: string[]): Promise<void> {
  const results = await Promise.all(
    accountIds.map(id => limit(() => syncAccount(id)))
  )
  // Idempotent - can be called multiple times safely
}
```

#### Streaming/Backpressure
- [ ] Async iterables for chunked data
- [ ] Backpressure support
- [ ] Memory-efficient streaming
- [ ] Proper stream cleanup

**Example**:
```ts
// ✅ CORRECT - Streaming with backpressure
export async function* streamLargeFile(
  path: string
): AsyncGenerator<Buffer, void, unknown> {
  const stream = fs.createReadStream(path, { highWaterMark: 1024 * 1024 })

  for await (const chunk of stream) {
    yield chunk  // Backpressure handled automatically
  }
}
```

#### Config Validation
- [ ] Strongly typed config object
- [ ] Runtime validation with Zod
- [ ] Defaults documented
- [ ] Environment variable mapping

**Example**:
```ts
// ✅ CORRECT - Validated config
import { z } from 'zod'

const ConfigSchema = z.object({
  port: z.number().int().positive().default(3000),
  database: z.object({
    host: z.string().default('localhost'),
    port: z.number().int().positive().default(5432),
  }),
})

export const config = ConfigSchema.parse({
  port: Number(process.env.PORT),
  database: {
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
  },
})
```

#### Internationalization Edges
- [ ] Number formatting locale-aware
- [ ] Date formatting with `Intl.DateTimeFormat`
- [ ] Plural rules with `Intl.PluralRules`
- [ ] RTL/LTR decisions documented

**Example**:
```ts
// ✅ CORRECT - Locale-aware formatting
export function formatCurrency(
  amount: number,
  locale: string,
  currency: string
): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(amount)
}
```

#### Path & FS Portability
- [ ] Windows/POSIX path handling
- [ ] URL vs filesystem path distinction
- [ ] Case sensitivity documented
- [ ] No hardcoded path separators

**Example**:
```ts
// ✅ CORRECT - Portable paths
import { join, normalize } from 'path'
import { fileURLToPath } from 'url'

export function resolveFile(base: string, relative: string): string {
  return normalize(join(base, relative))  // Works on Windows & POSIX
}

// ❌ WRONG - Hardcoded separators
export function badResolve(base: string, relative: string): string {
  return `${base}/${relative}`  // Breaks on Windows!
}
```

### 🟢 Low Priority (Optional)

#### Docs Excellence
- [ ] README quick-start guide
- [ ] API reference from TSDoc
- [ ] Examples/cookbook
- [ ] Known limitations documented

#### Repo Hygiene
- [ ] CONTRIBUTING.md
- [ ] CODEOWNERS
- [ ] SECURITY.md
- [ ] Issue/PR templates

#### Compliance
- [ ] License file/headers
- [ ] Third-party notices
- [ ] Dependency license scan in CI

#### Supply Chain
- [ ] Lockfile integrity checks
- [ ] Provenance/sigstore
- [ ] `npm audit` policy with allowlist

### 🔵 Context-Specific (If Relevant)

#### Web/Edge Constraints
- [ ] Web Crypto vs node:crypto shims clarified
- [ ] Edge-safe code paths documented
- [ ] No Node.js-specific APIs in edge runtime

#### Feature Flags
- [ ] Typed flags with kill-switches
- [ ] Defaults are safe and backward-compatible
- [ ] Feature flag lifecycle documented

#### Result Type Pattern
- [ ] `Result<T, E>` return style for ergonomics
- [ ] Avoids throwing for expected errors
- [ ] Railway-oriented programming when appropriate

**Example**:
```ts
// ✅ CORRECT - Result type pattern
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E }

export async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await db.query.users.findFirst({ where: eq(users.id, id) })
    if (!user) {
      return { ok: false, error: new Error('User not found') }
    }
    return { ok: true, value: user }
  } catch (error) {
    return { ok: false, error: error as Error }
  }
}

// Usage
const result = await fetchUser('123')
if (result.ok) {
  console.log(result.value.name)
} else {
  console.error(result.error.message)
}
```

## Extended Audit Scoring

**Total Categories**: 55 (30 core Next.js + 25 extended engineering)

**Core Next.js 16 Categories** (30):
1. Type Safety
2. Caching (Next.js 16)
3. Data Fetching
4. Server Functions & Actions
5. Authentication
6. Streaming & Suspense
7. Server/Client Components
8. Database Patterns
9. React 19 Patterns
10. API Routes
11. Security
12. Performance
13. Accessibility
14. Build & Configuration
15. fetch API Patterns
16. Server/Client Architecture
17. Linking & Navigation
18. Layouts & Pages
19. Error Handling
20. Proxy & Middleware
21. Advanced Caching
22. React 19 Advanced
23. Streaming & Suspense Boundaries
24. Security Best Practices
25. Performance Optimization
26. Accessibility Standards
27. **Metadata & SEO** (NEW)
28. **Build & Deployment** (NEW)
29. **Static Generation (ISR)** (NEW)
30. **Dependency Governance** (NEW)

**Extended Engineering Standards** (25):
- **Critical (10)**: I/O contracts, determinism, cancellation, encoding, time, numerics, side-effects, PII, resources, platform support
- **High (7)**: API stability, error taxonomy, observability, package hygiene, ESM/CJS, tree-shaking, source maps
- **Medium (5)**: Coverage gates, benchmarks, async correctness, streaming/backpressure, config validation, i18n/path portability
- **Low (3)**: Docs, repo hygiene, compliance, supply chain

**Combined Rubric**:
- **Critical (30%)**: Security, auth, type safety, I/O contracts, determinism, cancellation, PII hygiene
- **High (35%)**: Data fetching, caching, Server Functions, navigation, error handling, metadata/SEO, ISR, API stability
- **Medium (20%)**: React patterns, performance, a11y, build config, dependencies, testing, benchmarks
- **Low (15%)**: Docs, compliance, repo hygiene

**Perfect Score (100/100)**: Meets ALL critical + high priority standards + most medium/low standards
