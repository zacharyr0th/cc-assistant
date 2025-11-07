# REST API Security Reference for security-auditor

## OWASP REST Security Best Practices

### Authentication & Authorization

**HTTPS is MANDATORY**
- "Secure REST services must only provide HTTPS endpoints"
- Protects credentials in transit
- No exceptions for "internal" APIs

**JWT Token Security:**
```typescript
// ✅ REQUIRED checks:
- Verify signature or MAC (never allow `{"alg":"none"}`)
- Validate standard claims: iss, aud, exp, nbf
- Implement token revocation via denylist for early session termination

// ❌ NEVER:
- Accept unsigned JWTs
- Skip expiration validation
- Store tokens in localStorage (use httpOnly cookies)
```

**API Key Handling:**
- Mandate API keys for every protected endpoint
- Return `429 Too Many Requests` for excessive traffic
- Revoke keys violating usage agreements
- Rotate keys periodically

### Input Validation & Content Security

**Validate ALL inputs:**
```typescript
// Check: length / range / format / type
import { z } from 'zod';

const schema = z.object({
  email: z.string().email().max(255),
  amount: z.number().positive().max(1000000),
  userId: z.string().uuid()
});
```

**Size Limits:**
- Reject requests exceeding size limits with **HTTP 413**
- Set reasonable body size limits (e.g., 10MB for file uploads)

**Content-Type Validation (CRITICAL):**
```typescript
// ✅ Reject missing/unexpected content types
if (!['application/json', 'multipart/form-data'].includes(contentType)) {
  return new Response('Unsupported Media Type', { status: 415 });
}

// ❌ NEVER copy Accept header to response Content-Type
// Attacker could force response as executable JavaScript
```

**XML Security:**
- Use hardened XML parsers
- Prevent XXE (XML External Entity) attacks
- Disable DTD processing

### Rate Limiting

**Essential for all public endpoints:**
```typescript
import { rateLimit } from '@/lib/api/rate-limit';

const limiter = rateLimit({
  interval: 60 * 1000, // 1 minute
  uniqueTokenPerInterval: 500
});

// Different limits by endpoint type:
await limiter.check(request, 5, identifier);  // Auth: 5/min
await limiter.check(request, 30, userId);     // Read: 30/min
await limiter.check(request, 10, userId);     // Write: 10/min
```

Return **429 Too Many Requests** when limit exceeded.

### HTTP Methods

**Allowlist approach:**
```typescript
const ALLOWED_METHODS = ['GET', 'POST', 'PUT', 'DELETE'];

if (!ALLOWED_METHODS.includes(request.method)) {
  return new Response('Method Not Allowed', { status: 405 });
}
```

### Security Headers (Required for ALL responses)

```typescript
const securityHeaders = {
  'Cache-Control': 'no-store',              // Prevent sensitive data caching
  'X-Content-Type-Options': 'nosniff',      // Disable MIME sniffing
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
  'X-Frame-Options': 'DENY',                // Prevent framing attacks
  'Content-Security-Policy': "default-src 'self'",
  'X-XSS-Protection': '1; mode=block'
};

return new Response(data, { headers: securityHeaders });
```

### Error Handling

**Generic error messages only:**
```typescript
// ✅ GOOD - No technical details
return apiError('INTERNAL_ERROR', 'An error occurred');

// ❌ BAD - Reveals implementation
return new Response(JSON.stringify({
  error: 'Database connection failed at db.execute()',
  stack: error.stack,
  query: 'SELECT * FROM users WHERE...'
}), { status: 500 });
```

**Log security events** but sanitize data to prevent log injection:
```typescript
import { logger } from '@/lib/utils/logger';

logger.error({
  userId: sanitize(userId),
  endpoint: '/api/auth',
  error: error.message, // NOT error.stack
}, 'Authentication failed');
```

### Sensitive Data Protection

**NEVER expose credentials in URLs:**
```typescript
// ❌ BAD
GET /api/user?token=abc123&password=secret

// ✅ GOOD
POST /api/user
Headers: { Authorization: 'Bearer abc123' }
Body: { password: 'encrypted_value' }
```

**Data Placement Rules:**
- **POST/PUT requests:** Sensitive data in request body or headers
- **GET requests:** Sensitive data in headers only (never query params)
- **Responses:** Only return necessary fields

### Common Vulnerabilities to Prevent

**SQL Injection:**
```typescript
// ❌ CRITICAL VULNERABILITY
const query = `SELECT * FROM users WHERE email = '${userInput}'`;

// ✅ SAFE (Drizzle handles parameterization)
import { eq } from 'drizzle-orm';
await db.select().from(users).where(eq(users.email, userInput));
```

**XSS (Cross-Site Scripting):**
```typescript
// ❌ FORBIDDEN
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ SAFE (React auto-escapes)
<div>{userInput}</div>

// ✅ SAFE (if HTML needed)
import DOMPurify from 'isomorphic-dompurify';
const clean = DOMPurify.sanitize(userInput);
```

**Path Traversal:**
```typescript
// ❌ CRITICAL
const filePath = `/uploads/${userInput}`;
fs.readFile(filePath); // Could access ../../../etc/passwd

// ✅ SAFE
import path from 'path';
const safePath = path.join(UPLOAD_DIR, path.basename(userInput));
if (!safePath.startsWith(UPLOAD_DIR)) {
  throw new Error('Invalid path');
}
```

**Timing Attacks:**
```typescript
// ❌ BAD - Comparison reveals information
if (userToken === storedToken) { ... }

// ✅ GOOD - Constant-time comparison
import { timingSafeEqual } from 'crypto';

const isValid = timingSafeEqual(
  Buffer.from(userToken),
  Buffer.from(storedToken)
);
```

### Webhook Security

**Always validate signatures:**
```typescript
// Stripe example
import Stripe from 'stripe';

const sig = request.headers.get('stripe-signature');
const event = stripe.webhooks.constructEvent(
  body,
  sig!,
  process.env.STRIPE_WEBHOOK_SECRET!
);

// Plaid example
import { validateWebhookSignature } from '@/lib/plaid';

if (!validateWebhookSignature(request)) {
  return new Response('Invalid signature', { status: 401 });
}
```

### Security Checklist

**Before Deploying API Endpoints:**

- [ ] HTTPS enforced
- [ ] Authentication implemented
- [ ] Authorization verified (RLS, user_id checks)
- [ ] Input validation (Zod schemas)
- [ ] Rate limiting configured
- [ ] Security headers set
- [ ] Error messages generic
- [ ] Logging sanitized
- [ ] No secrets in URLs
- [ ] No SQL injection risks
- [ ] XSS prevention in place
- [ ] Webhook signatures validated
- [ ] CORS properly configured
- [ ] File uploads validated (type, size)
- [ ] Timing attack prevention for comparisons

---

**Source:** OWASP REST Security Cheat Sheet
**Last Updated:** 2025-10-25
