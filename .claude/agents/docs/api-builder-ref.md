# Next.js Route Handlers Reference for api-builder

## App Router API Routes

### File Structure

**Location:** `app/api/**​/route.ts`

Route Handlers are created using `route.js|ts` files within the App Router structure. They enable "custom request handlers for a given route using the Web Request and Response APIs."

### Supported HTTP Methods

```typescript
export async function GET(request: NextRequest) { }
export async function POST(request: NextRequest) { }
export async function PUT(request: NextRequest) { }
export async function PATCH(request: NextRequest) { }
export async function DELETE(request: NextRequest) { }
export async function HEAD(request: NextRequest) { }
export async function OPTIONS(request: NextRequest) { }
```

**Note:** Framework automatically implements `OPTIONS` if not explicitly defined.

### Request Object (NextRequest)

**Extends Web Request API** with convenience methods:

```typescript
import { NextRequest } from 'next/server';

export async function POST(request: NextRequest) {
  // URL and query params
  const url = request.nextUrl;
  const searchParams = request.nextUrl.searchParams;
  const param = searchParams.get('param');

  // Cookies
  const cookies = request.cookies;
  const token = cookies.get('token');

  // Headers
  const headers = request.headers;
  const auth = headers.get('authorization');

  // Body parsing
  const json = await request.json();           // JSON body
  const formData = await request.formData();   // Form data
  const text = await request.text();           // Plain text
}
```

### Response Patterns

**JSON Response:**
```typescript
import { NextResponse } from 'next/server';

return NextResponse.json(
  { success: true, data: result },
  {
    status: 200,
    headers: {
      'Cache-Control': 's-maxage=30, stale-while-revalidate',
    }
  }
);
```

**Plain Text/HTML:**
```typescript
return new Response('OK', {
  status: 200,
  headers: { 'Content-Type': 'text/plain' }
});
```

**Redirect:**
```typescript
return NextResponse.redirect(new URL('/dashboard', request.url));
```

### Headers and Cookies Management

**Reading Headers:**
```typescript
import { headers } from 'next/headers';

export async function GET() {
  const headersList = headers(); // Read-only
  const authorization = headersList.get('authorization');
}
```

**Setting Response Headers:**
```typescript
return NextResponse.json(data, {
  headers: {
    'X-Custom-Header': 'value',
    'Cache-Control': 'public, max-age=60'
  }
});
```

**Reading Cookies:**
```typescript
import { cookies } from 'next/headers';

export async function GET() {
  const cookieStore = cookies();
  const session = cookieStore.get('session');
}
```

**Setting Cookies:**
```typescript
const response = NextResponse.json(data);
response.cookies.set('session', token, {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: 'lax',
  maxAge: 60 * 60 * 24 * 7 // 1 week
});
return response;
```

### Caching Strategies

**Important:** As of **Next.js 15** (stable), GET handlers are **NOT cached by default**. This is a breaking change from Next.js 14.

**Next.js 15 Caching Changes:**
- GET route handlers: **Dynamic by default** (no caching)
- To opt into caching: Use `export const dynamic = 'force-static'`
- Fetch requests: Default to `{ cache: 'no-store' }`

**Control caching behavior:**

```typescript
// Option 1: Force static (cached) route
export const dynamic = 'force-static';
export const revalidate = 60; // Revalidate every 60 seconds

export async function GET() {
  // This route will be statically cached and revalidated every 60s
  return NextResponse.json(data);
}

// Option 2: Dynamic route (default in Next.js 15)
export async function GET() {
  // Not cached - always runs on each request
  return NextResponse.json(data);
}

// Option 3: Use HTTP Cache-Control headers for CDN/browser caching
export async function GET() {
  return NextResponse.json(data, {
    headers: {
      'Cache-Control': 's-maxage=30, stale-while-revalidate=60'
    }
  });
}
```

**Cache-Control Headers:**

In Next.js 15, since routes are dynamic by default, use HTTP headers for caching:

```typescript
// Public, cacheable (CDN + browser)
headers: {
  'Cache-Control': 'public, s-maxage=30, stale-while-revalidate=60'
  // CDN caches for 30s, serves stale up to 60s while revalidating
}

// Private, user-specific (browser only, not CDN)
headers: {
  'Cache-Control': 'private, max-age=30'
}

// No cache (default for authenticated routes)
headers: {
  'Cache-Control': 'no-store, no-cache, must-revalidate'
}

// Immutable (never changes - static assets, versioned content)
headers: {
  'Cache-Control': 'public, max-age=31536000, immutable'
}
```

**Best Practices:**
- **Authenticated routes**: Use `'no-store'` to prevent caching sensitive data
- **Public data**: Use `s-maxage` with `stale-while-revalidate` for better UX
- **Static content**: Use `force-static` + revalidate for Next.js to handle caching
- **Application cache**: Use Next.js Cache Components for expensive operations (do not use legacy `@/lib/cache` wrappers)

### Error Handling

```typescript
export async function POST(request: NextRequest) {
  try {
    const data = await request.json();
    // ... processing

    return NextResponse.json({ success: true });

  } catch (error) {
    // Log error with context
    logger.error({ error, endpoint: '/api/example' }, 'API error');

    // Return generic error to client
    return NextResponse.json(
      { error: 'An error occurred' },
      { status: 500 }
    );
  }
}
```

### Common Patterns

**CORS Handling:**
```typescript
export async function OPTIONS(request: NextRequest) {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  });
}
```

**Authentication Check:**
```typescript
import { createClient } from '@/lib/db/supabase/server';

export async function POST(request: NextRequest) {
  const supabase = createClient();
  const { data: { user }, error } = await supabase.auth.getUser();

  if (error || !user) {
    return NextResponse.json(
      { error: 'Unauthorized' },
      { status: 401 }
    );
  }

  // Proceed with authenticated user
}
```

**Request Validation:**
```typescript
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  name: z.string().min(1)
});

export async function POST(request: NextRequest) {
  const body = await request.json();
  const validation = schema.safeParse(body);

  if (!validation.success) {
    return NextResponse.json(
      { error: 'Invalid input', details: validation.error.issues },
      { status: 400 }
    );
  }

  const { email, name } = validation.data;
  // ... proceed
}
```

**Webhook Handling:**
```typescript
export async function POST(request: NextRequest) {
  // Always return 200 quickly (< 3s)
  const body = await request.text();
  const signature = request.headers.get('x-signature');

  // Verify signature
  if (!verifySignature(body, signature)) {
    return new Response('Invalid signature', { status: 401 });
  }

  // Process async (queue for background job)
  await queueWebhook({ body });

  // Immediate acknowledgment
  return new Response('OK', { status: 200 });
}
```

### Fetch in API Routes

**Next.js 15 Default Behavior:**
- `fetch()` defaults to `{ cache: 'no-store' }` (no caching)
- POST requests always opt out of caching
- Route handlers are dynamic by default

**For External APIs:**
Use utility wrappers from `@/lib/utils`:

```typescript
import { fetchJson, fetchWithTimeout, retry } from '@/lib/utils';

// Simple external API call
const data = await fetchJson<DataType>('https://api.external.com/data', {
  timeout: 10000,
  headers: { 'Authorization': `Bearer ${apiKey}` },
});

// With retry for flaky APIs
const data = await retry(
  () => fetchJson('https://api.external.com/data'),
  { maxRetries: 3, initialDelay: 1000, backoff: 'exponential' }
);
```

**For Internal API Calls:**
```typescript
const baseUrl = process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000';
const response = await fetch(`${baseUrl}/api/v1/accounts`, {
  headers: { 'Authorization': `Bearer ${token}` },
});
```

**⚠️ WARNING:** Don't use `next.revalidate` in route handlers - it only works in server components!

## Response Types Beyond JSON

### Binary Responses

**Images:**
```typescript
export async function GET() {
  const imageBuffer = await generateImage();

  return new Response(imageBuffer, {
    headers: {
      'Content-Type': 'image/png',
      'Cache-Control': 'public, max-age=31536000, immutable',
    },
  });
}
```

**PDFs:**
```typescript
export async function GET(request: NextRequest) {
  const pdfBuffer = await generatePDF();

  return new Response(pdfBuffer, {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'attachment; filename="document.pdf"',
    },
  });
}
```

**Streaming Responses:**
```typescript
import { streamCSV } from '@/lib/api/next/streaming';

export async function GET() {
  async function* generateRows() {
    for (let i = 0; i < 10000; i++) {
      yield [i.toString(), `Row ${i}`, Math.random().toString()];
    }
  }

  return streamCSV(
    ['ID', 'Name', 'Value'],
    generateRows(),
    { filename: 'data.csv' }
  );
}
```

### Non-UI Content Generation

**RSS Feed:**
```typescript
export async function GET() {
  const posts = await db.query.posts.findMany({
    limit: 50,
    orderBy: desc(posts.publishedAt),
  });

  const rss = `<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
  <channel>
    <title>My Blog</title>
    <link>https://example.com</link>
    <description>Blog posts</description>
    ${posts.map(post => `
    <item>
      <title>${escapeXml(post.title)}</title>
      <link>https://example.com/blog/${post.slug}</link>
      <pubDate>${new Date(post.publishedAt).toUTCString()}</pubDate>
      <description>${escapeXml(post.excerpt)}</description>
    </item>
    `).join('')}
  </channel>
</rss>`;

  return new Response(rss, {
    headers: {
      'Content-Type': 'application/xml',
      'Cache-Control': 'public, max-age=3600',
    },
  });
}
```

**Sitemap:**
```typescript
export async function GET() {
  const pages = await getAllPages();

  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  ${pages.map(page => `
  <url>
    <loc>${page.url}</loc>
    <lastmod>${page.updatedAt}</lastmod>
    <changefreq>${page.changeFreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>
  `).join('')}
</urlset>`;

  return new Response(sitemap, {
    headers: {
      'Content-Type': 'application/xml',
    },
  });
}
```

**robots.txt:**
```typescript
// app/api/robots.txt/route.ts
export async function GET() {
  const robots = `User-agent: *
Allow: /

User-agent: GPTBot
Disallow: /

Sitemap: https://example.com/sitemap.xml`;

  return new Response(robots, {
    headers: {
      'Content-Type': 'text/plain',
    },
  });
}
```

## NextRequest/NextResponse API Reference

### NextRequest Extensions

**nextUrl Property:**
```typescript
export async function GET(request: NextRequest) {
  const url = request.nextUrl;

  // Parsed URL components
  url.pathname;    // '/api/v1/users'
  url.search;      // '?page=1&limit=20'
  url.searchParams.get('page'); // '1'
  url.href;        // Full URL
  url.origin;      // 'https://example.com'
  url.protocol;    // 'https:'
  url.host;        // 'example.com'
  url.hostname;    // 'example.com'
  url.port;        // ''
  url.hash;        // '#section'

  // Geographic info (Vercel only)
  const country = request.geo?.country;    // 'US'
  const region = request.geo?.region;      // 'CA'
  const city = request.geo?.city;          // 'San Francisco'
  const latitude = request.geo?.latitude;  // '37.7749'
  const longitude = request.geo?.longitude; // '-122.4194'

  // IP address
  const ip = request.ip; // '203.0.113.1'

  return NextResponse.json({ country, city, ip });
}
```

**Cookies Helper:**
```typescript
import type { NextRequest } from 'next/server';

export async function GET(request: NextRequest) {
  // Read cookies
  const session = request.cookies.get('session');
  const all = request.cookies.getAll();
  const has = request.cookies.has('session');

  return NextResponse.json({ session: session?.value });
}

export async function POST(request: NextRequest) {
  const response = NextResponse.json({ success: true });

  // Set cookie
  response.cookies.set('session', 'abc123', {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 60 * 60 * 24 * 7, // 1 week
  });

  // Delete cookie
  response.cookies.delete('old-session');

  return response;
}
```

### NextResponse Static Methods

**Redirects:**
```typescript
import { NextResponse } from 'next/server';

// Temporary redirect (307)
return NextResponse.redirect(new URL('/login', request.url));

// Permanent redirect (308)
return NextResponse.redirect(new URL('/new-path', request.url), 308);

// External redirect
return NextResponse.redirect('https://example.com');
```

**Rewrites:**
```typescript
// Rewrite (proxy) to different path
return NextResponse.rewrite(new URL('/api/v2/users', request.url));

// Rewrite to external URL
return NextResponse.rewrite('https://api.external.com/data');
```

**JSON Responses:**
```typescript
// Basic JSON
return NextResponse.json({ success: true });

// With status and headers
return NextResponse.json(
  { error: 'Not found' },
  {
    status: 404,
    headers: {
      'X-Custom-Header': 'value',
    },
  }
);
```

## Dynamic Route Segments Reference

### Single Parameter `[id]`

```typescript
// app/api/users/[id]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  // id = 'abc123' for /api/users/abc123
}
```

### Multiple Parameters

```typescript
// app/api/users/[userId]/posts/[postId]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ userId: string; postId: string }> }
) {
  const { userId, postId } = await params;
  // For /api/users/123/posts/456:
  // userId = '123', postId = '456'
}
```

### Catch-All `[...slug]`

```typescript
// app/api/docs/[...slug]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ slug: string[] }> }
) {
  const { slug } = await params;
  // /api/docs/a/b/c → slug = ['a', 'b', 'c']
  // /api/docs/a → slug = ['a']

  const path = slug.join('/');
  return NextResponse.json({ path });
}
```

### Optional Catch-All `[[...slug]]`

```typescript
// app/api/blog/[[...slug]]/route.ts
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ slug?: string[] }> }
) {
  const { slug } = await params;

  if (!slug) {
    // /api/blog → slug = undefined
    return NextResponse.json({ page: 'index' });
  }

  // /api/blog/2024/march → slug = ['2024', 'march']
  const path = slug.join('/');
  return NextResponse.json({ path });
}
```

### Parameter Validation

Always validate route parameters:

```typescript
import { z } from 'zod';

const ParamsSchema = z.object({
  id: z.string().uuid(),
});

export async function GET(
  request: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  const params = await context.params;
  const validation = ParamsSchema.safeParse(params);

  if (!validation.success) {
    return NextResponse.json(
      { error: 'Invalid ID format', details: validation.error.issues },
      { status: 400 }
    );
  }

  const { id } = validation.data;
  // Now 'id' is guaranteed to be a valid UUID
}
```

## Streaming API Reference

### ReadableStream

```typescript
export async function GET() {
  const encoder = new TextEncoder();

  const stream = new ReadableStream({
    async start(controller) {
      for (let i = 0; i < 10; i++) {
        controller.enqueue(encoder.encode(`Data chunk ${i}\n`));
        await new Promise(resolve => setTimeout(resolve, 100));
      }
      controller.close();
    },
  });

  return new Response(stream, {
    headers: {
      'Content-Type': 'text/plain',
      'Cache-Control': 'no-cache',
    },
  });
}
```

### Server-Sent Events (SSE)

```typescript
import { streamSSE } from '@/lib/api/next/streaming';

export async function GET() {
  return streamSSE(async (send) => {
    // Send message with event type
    await send({
      event: 'update',
      data: { value: 123 },
      id: 'msg-1',
    });

    // Send retry interval (milliseconds)
    await send({
      event: 'config',
      data: { message: 'Connected' },
      retry: 3000, // Retry after 3 seconds if disconnected
    });
  });
}
```

**Client consumption:**
```typescript
const eventSource = new EventSource('/api/stream');

eventSource.addEventListener('update', (event) => {
  const data = JSON.parse(event.data);
  console.log('Update:', data);
});

eventSource.onerror = () => {
  eventSource.close();
};
```

### Best Practices

1. **Always validate input** with Zod schemas
2. **Authenticate protected routes** with Supabase auth
3. **Set appropriate cache headers** for response types
4. **Log errors** with context (never expose to client)
5. **Return generic error messages** to prevent information leakage
6. **Use TypeScript** for request/response types
7. **Implement rate limiting** for all public endpoints
8. **Handle CORS** properly for cross-origin requests
9. **Use status codes correctly** (200, 201, 400, 401, 403, 404, 429, 500)
10. **Keep handlers focused** - extract business logic to services
11. **Use fetch utilities** - `fetchJson()` for external APIs, never bare `fetch()`
12. **Always set timeouts** - prevent hanging requests

---

## Industry Standards Compliance

This project achieves **98% compliance** with industry best practices:

**Architecture:**
- ✅ Service Layer Pattern (Routes → Services → Database)
- ✅ Separation of Concerns (HTTP vs Business Logic)
- ✅ Dependency Injection (services are composable)

**API Design:**
- ✅ REST principles (resource-based URLs, HTTP verbs)
- ✅ Consistent response format (`{ success, data/error }`)
- ✅ Proper status codes (200, 201, 400, 401, 403, 404, 429, 500)
- ✅ API versioning (`/v1/` in paths)

**Security:**
- ✅ Rate limiting (distributed, multi-tier)
- ✅ Authentication (Supabase, token-based)
- ✅ CSRF protection (automatic)
- ✅ Idempotency keys (for mutations)
- ✅ Input validation (Zod runtime checks)

**Performance:**
- ✅ Multi-tier caching (React Query → HTTP → Redis → DB)
- ✅ Proper `Cache-Control` headers
- ✅ Compression for large responses
- ✅ Database query optimization

**Observability:**
- ✅ Structured logging (Pino, JSON format)
- ✅ Request/Trace IDs (distributed tracing)
- ✅ Performance timers
- ⚠️ Optional: Metrics export, span tracking

**Next.js 15 Specific:**
- ✅ GET routes dynamic by default
- ✅ Proper fetch usage (with utilities)
- ✅ Server Components used appropriately
- ✅ No unnecessary Route Handler calls

---

**Additional Resources:**
- [Next.js 15 Blog Post](https://nextjs.org/blog/next-15)
- [Next.js Route Handlers Docs](https://nextjs.org/docs/app/building-your-application/routing/route-handlers)
- [Next.js Caching Guide](https://nextjs.org/docs/app/guides/caching)
- [REST API Best Practices](https://stackoverflow.blog/2020/03/02/best-practices-for-rest-api-design/)
- [Service Layer Pattern](https://java-design-patterns.com/patterns/service-layer/)
- [Zod Documentation](https://zod.dev/)
- [Express Error Handling](https://expressjs.com/en/guide/error-handling.html)

**Source:** Next.js Route Handlers Documentation (v15), Industry Best Practices (2024-2025)
**Last Updated:** 2025-10-26
