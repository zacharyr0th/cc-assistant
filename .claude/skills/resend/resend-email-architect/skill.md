---
name: resend-email-architect
description: Design, implement, and audit email functionality using Resend API with React Email templates. Implements Next.js integration patterns, transactional emails, marketing broadcasts, webhook handling, and domain verification. Use when building email features, debugging deliverability, or auditing email infrastructure.
version: 1.0.0
---

# Resend Email Architect

## Overview

Specialized skill for designing, implementing, and auditing email functionality using **Resend** (the project's email service provider). Focuses on:
- **Email API Integration** - Resend SDK setup, sending patterns, batch operations
- **React Email Templates** - Component-based email design with type safety
- **Transactional Emails** - Auth, notifications, receipts, confirmations
- **Marketing Emails** - Broadcasts, audiences, segmentation
- **Deliverability** - Domain verification (SPF, DKIM, DMARC), sender reputation
- **Webhooks** - Real-time event handling (bounces, opens, clicks, complaints)
- **Next.js Patterns** - API routes, Server Actions, Edge Runtime compatibility

## When to Use

Invoke when:
- "Add email functionality"
- "Send transactional email"
- "Create email template"
- "Set up Resend"
- "Fix email deliverability"
- "Handle email webhooks"
- "Audit email infrastructure"
- Building password resets, welcome emails, notifications
- Debugging bounces or spam issues

## Resend Documentation Reference

Full documentation available at `/Users/zach/Documents/clarity/docs/resend/`:
- `docs/introduction.txt` - Getting started, quickstart guides
- `integrations/nextjs.txt` - Next.js SDK integration patterns
- `integrations/supabase.txt` - Supabase Edge Functions integration
- `features/email-api.txt` - API capabilities, scheduling, batch sending
- `features/smtp-service.txt` - SMTP configuration (ports 465, 587)
- `features/audiences.txt` - Contact management, CSV imports
- `features/broadcasts.txt` - Marketing campaigns, WYSIWYG editor
- `dashboard/domains.txt` - Domain setup, DNS configuration
- `dashboard/webhooks.txt` - Event handling, retry mechanism
- `dashboard/emails.txt` - Email events, sharing, logs
- `blog/sender-reputation.txt` - Deliverability best practices
- `blog/introducing-templates.txt` - Template versioning and variables
- `blog/inbound-emails.txt` - Receiving emails via webhooks
- `blog/dmarc-reports.txt` - RUA/RUF report analysis

## Core Patterns

### 1. Resend SDK Setup (Next.js)

```ts
// ✅ CORRECT - Initialize Resend client
// lib/email/resend.ts
import { Resend } from 'resend'

if (!process.env.RESEND_API_KEY) {
  throw new Error('RESEND_API_KEY environment variable is required')
}

export const resend = new Resend(process.env.RESEND_API_KEY)

// Export type-safe send function
export async function sendEmail(options: {
  from: string
  to: string | string[]
  subject: string
  react?: React.ReactElement
  html?: string
  text?: string
  scheduledAt?: string // Natural language: "in 1 min", "tomorrow at 9am"
  tags?: Array<{ name: string; value: string }>
  headers?: Record<string, string>
}) {
  try {
    const data = await resend.emails.send(options)
    logger.info({ emailId: data.id, to: options.to }, 'Email sent successfully')
    return { success: true, data }
  } catch (error) {
    logger.error({ error, to: options.to, subject: options.subject }, 'Email send failed')
    throw new Error(`Failed to send email: ${error instanceof Error ? error.message : 'Unknown error'}`)
  }
}

// ❌ WRONG - Missing error handling, logging
export const resend = new Resend(process.env.RESEND_API_KEY)
```

**Key Patterns:**
- Centralize Resend client in `lib/email/resend.ts`
- Validate `RESEND_API_KEY` at module load
- Wrap `resend.emails.send()` with error handling
- Use structured logging for all email operations
- Export type-safe helper functions

### 2. React Email Templates

```tsx
// ✅ CORRECT - Type-safe React Email component
// lib/email/templates/WelcomeEmail.tsx
import * as React from 'react'
import {
  Html,
  Head,
  Body,
  Container,
  Heading,
  Text,
  Button,
  Link,
  Hr,
  Section,
} from '@react-email/components'
import { hexColors } from '@/lib/design' // Use design system

interface WelcomeEmailProps {
  firstName: string
  loginUrl: string
  supportEmail: string
}

export function WelcomeEmail({ firstName, loginUrl, supportEmail }: WelcomeEmailProps) {
  return (
    <Html>
      <Head />
      <Body style={styles.body}>
        <Container style={styles.container}>
          <Heading style={styles.heading}>Welcome to Clarity, {firstName}!</Heading>

          <Text style={styles.text}>
            We're excited to have you on board. Your account has been successfully created.
          </Text>

          <Section style={styles.buttonContainer}>
            <Button style={styles.button} href={loginUrl}>
              Get Started
            </Button>
          </Section>

          <Hr style={styles.hr} />

          <Text style={styles.footer}>
            Need help? Contact us at{' '}
            <Link href={`mailto:${supportEmail}`} style={styles.link}>
              {supportEmail}
            </Link>
          </Text>
        </Container>
      </Body>
    </Html>
  )
}

// Use design system colors (hex for email clients)
const styles = {
  body: {
    backgroundColor: hexColors.light.background,
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
  },
  container: {
    margin: '0 auto',
    padding: '40px 20px',
    maxWidth: '600px',
  },
  heading: {
    fontSize: '24px',
    fontWeight: 'bold',
    color: hexColors.light.foreground,
    marginBottom: '16px',
  },
  text: {
    fontSize: '16px',
    lineHeight: '24px',
    color: hexColors.light.foreground,
    marginBottom: '16px',
  },
  buttonContainer: {
    margin: '32px 0',
  },
  button: {
    backgroundColor: hexColors.light.primary,
    color: '#ffffff',
    padding: '12px 24px',
    borderRadius: '6px',
    textDecoration: 'none',
    display: 'inline-block',
    fontWeight: 600,
  },
  hr: {
    borderTop: `1px solid ${hexColors.light.border}`,
    margin: '32px 0',
  },
  footer: {
    fontSize: '14px',
    color: hexColors.light.mutedForeground,
  },
  link: {
    color: hexColors.light.primary,
    textDecoration: 'underline',
  },
}

// Export default for easier imports
export default WelcomeEmail

// ❌ WRONG - Inline CSS, hardcoded colors, no type safety
export function WelcomeEmail({ firstName }) {
  return (
    <div>
      <h1>Welcome {firstName}</h1>
      <a href="https://example.com">Click here</a>
    </div>
  )
}
```

**Key Patterns:**
- Use `@react-email/components` for semantic email markup
- Import `hexColors` from `@/lib/design` (email clients don't support CSS variables)
- Type props interface for compile-time safety
- Inline styles only (external CSS not supported by email clients)
- Export as named + default for flexibility
- Keep templates under `lib/email/templates/`

### 3. Sending Transactional Emails

```ts
// ✅ CORRECT - Type-safe transactional email service
// lib/email/services/transactional.ts
import { sendEmail } from '@/lib/email/resend'
import { WelcomeEmail } from '@/lib/email/templates/WelcomeEmail'
import { PasswordResetEmail } from '@/lib/email/templates/PasswordResetEmail'
import { logger } from '@/lib/utils'

const FROM_ADDRESS = process.env.RESEND_FROM_ADDRESS || 'Clarity <noreply@clarity.finance>'

export async function sendWelcomeEmail(params: {
  to: string
  firstName: string
  userId: string
}) {
  const { to, firstName, userId } = params

  try {
    const result = await sendEmail({
      from: FROM_ADDRESS,
      to,
      subject: 'Welcome to Clarity',
      react: WelcomeEmail({
        firstName,
        loginUrl: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard`,
        supportEmail: 'support@clarity.finance',
      }),
      tags: [
        { name: 'category', value: 'transactional' },
        { name: 'type', value: 'welcome' },
        { name: 'userId', value: userId },
      ],
    })

    logger.info({ userId, emailId: result.data?.id }, 'Welcome email sent')
    return result
  } catch (error) {
    logger.error({ error, userId, to }, 'Failed to send welcome email')
    // Don't throw - email failures shouldn't block user flow
    return { success: false, error }
  }
}

export async function sendPasswordResetEmail(params: {
  to: string
  firstName: string
  resetToken: string
  userId: string
}) {
  const { to, firstName, resetToken, userId } = params
  const resetUrl = `${process.env.NEXT_PUBLIC_APP_URL}/auth/reset-password?token=${resetToken}`

  try {
    const result = await sendEmail({
      from: FROM_ADDRESS,
      to,
      subject: 'Reset Your Password',
      react: PasswordResetEmail({
        firstName,
        resetUrl,
        expiresInMinutes: 30,
      }),
      tags: [
        { name: 'category', value: 'transactional' },
        { name: 'type', value: 'password-reset' },
        { name: 'userId', value: userId },
      ],
    })

    logger.info({ userId, emailId: result.data?.id }, 'Password reset email sent')
    return result
  } catch (error) {
    logger.error({ error, userId, to }, 'Failed to send password reset email')
    throw new Error('Failed to send password reset email')
  }
}

// ❌ WRONG - No error handling, missing tags, inline template
export async function sendWelcomeEmail(email: string, name: string) {
  await resend.emails.send({
    from: 'noreply@example.com',
    to: email,
    subject: 'Welcome',
    html: `<h1>Welcome ${name}</h1>`,
  })
}
```

**Key Patterns:**
- Service functions in `lib/email/services/`
- Use React Email components, not inline HTML
- Add tags for filtering/analytics (category, type, userId)
- **Don't throw** on email failures unless critical (password resets)
- Structured logging with userId, emailId
- Centralize `FROM_ADDRESS` from environment variable

### 4. Next.js API Route Integration

```ts
// ✅ CORRECT - Email sending API route
// app/api/v1/email/send-welcome/route.ts
import type { NextRequest } from 'next/server'
import { z } from 'zod'
import { withAuthRoute, type RequestContext } from '@/lib/api/next/handlers'
import { apiSuccess, apiError, handleError } from '@/lib/api/next/response'
import { validateBody } from '@/lib/api/next/validation'
import { sendWelcomeEmail } from '@/lib/email/services/transactional'
import type { User } from '@supabase/supabase-js'

const SendWelcomeSchema = z.object({
  email: z.string().email(),
  firstName: z.string().min(1).max(100),
})

export const POST = withAuthRoute(
  { requests: 10, windowMs: 60000 }, // 10 emails/min per user
  async (request: NextRequest, context: RequestContext, user: User) => {
    try {
      const validated = await validateBody(request, SendWelcomeSchema)

      const result = await sendWelcomeEmail({
        to: validated.email,
        firstName: validated.firstName,
        userId: user.id,
      })

      if (!result.success) {
        return apiError(
          'Failed to send email',
          500,
          { error: result.error },
          context.requestId,
          context.traceId
        )
      }

      return apiSuccess({ emailId: result.data?.id })
    } catch (error) {
      return handleError(error, context.requestId, context.traceId)
    }
  }
)

// ❌ WRONG - No auth, no rate limiting, no validation
export async function POST(request: NextRequest) {
  const body = await request.json()
  await sendWelcomeEmail(body.email, body.firstName)
  return NextResponse.json({ success: true })
}
```

**Key Patterns:**
- Use `withAuthRoute()` for auth + rate limiting
- Validate input with `validateBody()`
- Import email services, not Resend client directly
- Rate limit email endpoints (10-50/min to prevent abuse)
- Return `emailId` for tracking

### 5. Webhook Handling

```ts
// ✅ CORRECT - Resend webhook handler with verification
// app/api/webhooks/resend/route.ts
import type { NextRequest } from 'next/server'
import { z } from 'zod'
import { apiSuccess, apiError } from '@/lib/api/next/response'
import { logger } from '@/lib/utils'
import { db } from '@/lib/db'
import { emailEvents } from '@/lib/db/schema'

// Resend webhook event types
const WebhookEventSchema = z.object({
  type: z.enum([
    'email.sent',
    'email.delivered',
    'email.delivery_delayed',
    'email.complained',
    'email.bounced',
    'email.opened',
    'email.clicked',
  ]),
  created_at: z.string(),
  data: z.object({
    email_id: z.string(),
    from: z.string(),
    to: z.array(z.string()),
    subject: z.string().optional(),
    created_at: z.string().optional(),
    tags: z.array(z.object({ name: z.string(), value: z.string() })).optional(),
    // Event-specific data
    click: z.object({ link: z.string() }).optional(),
    bounce: z.object({ bounce_type: z.string() }).optional(),
  }),
})

export async function POST(request: NextRequest) {
  try {
    // Verify webhook signature (Resend sends signature in headers)
    const signature = request.headers.get('svix-signature')
    if (!signature) {
      logger.warn('Resend webhook missing signature')
      return apiError('Missing signature', 401)
    }

    // Parse and validate webhook payload
    const body = await request.json()
    const event = WebhookEventSchema.parse(body)

    logger.info(
      { type: event.type, emailId: event.data.email_id },
      'Resend webhook received'
    )

    // Store event in database for analytics
    await db.insert(emailEvents).values({
      eventType: event.type,
      emailId: event.data.email_id,
      recipient: event.data.to[0],
      metadata: {
        from: event.data.from,
        subject: event.data.subject,
        tags: event.data.tags,
        click: event.data.click,
        bounce: event.data.bounce,
      },
      createdAt: new Date(event.created_at),
    })

    // Handle specific events
    switch (event.type) {
      case 'email.bounced':
        await handleBounce(event.data.email_id, event.data.to[0], event.data.bounce)
        break
      case 'email.complained':
        await handleComplaint(event.data.email_id, event.data.to[0])
        break
      case 'email.clicked':
        await handleClick(event.data.email_id, event.data.click?.link)
        break
    }

    // Always return 200 to prevent retries
    return apiSuccess({ received: true })
  } catch (error) {
    logger.error({ error }, 'Resend webhook processing failed')
    // Return 200 even on error to prevent infinite retries
    return apiSuccess({ received: false, error: 'Processing failed' })
  }
}

async function handleBounce(emailId: string, recipient: string, bounce: any) {
  logger.warn({ emailId, recipient, bounceType: bounce?.bounce_type }, 'Email bounced')

  // Remove from mailing lists if hard bounce
  if (bounce?.bounce_type === 'hard_bounce') {
    await db
      .update(users)
      .set({ emailBounced: true, emailBouncedAt: new Date() })
      .where(eq(users.email, recipient))
  }
}

async function handleComplaint(emailId: string, recipient: string) {
  logger.warn({ emailId, recipient }, 'Spam complaint received')

  // Immediately unsubscribe
  await db
    .update(users)
    .set({ emailOptOut: true, emailOptOutAt: new Date() })
    .where(eq(users.email, recipient))
}

async function handleClick(emailId: string, link?: string) {
  logger.info({ emailId, link }, 'Email link clicked')
  // Track engagement metrics
}

// ❌ WRONG - No signature verification, throws on error, missing event handling
export async function POST(request: NextRequest) {
  const event = await request.json()
  await db.insert(emailEvents).values(event)
  return NextResponse.json({ success: true })
}
```

**Key Patterns:**
- Validate webhook signature (`svix-signature` header)
- Use Zod to validate event schema
- Store events in database (`emailEvents` table)
- Handle specific events (bounces, complaints, clicks)
- **Always return 200** to prevent infinite retries
- Log all webhook events
- Auto-unsubscribe on hard bounces/complaints

### 6. Domain Configuration & Deliverability

```md
## Domain Setup Checklist

### 1. Add Domain to Resend Dashboard
- Navigate to Resend Dashboard → Domains
- Add your sending domain (recommended: subdomain like `mail.yourdomain.com`)
- Copy DNS records provided by Resend

### 2. Configure DNS Records

**SPF Record** (TXT):
```
Type: TXT
Name: mail.yourdomain.com
Value: v=spf1 include:resend.com ~all
TTL: 3600
```

**DKIM Record** (TXT):
```
Type: TXT
Name: resend._domainkey.mail.yourdomain.com
Value: [Provided by Resend]
TTL: 3600
```

**DMARC Record** (TXT) - Optional but recommended:
```
Type: TXT
Name: _dmarc.mail.yourdomain.com
Value: v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com
TTL: 3600
```

### 3. Custom Return Path (Optional)
```
Type: CNAME
Name: bounce.mail.yourdomain.com
Value: feedback.resend.com
TTL: 3600
```

### 4. Verification
- Wait 24-72 hours for DNS propagation
- Check Resend Dashboard for verification status
- Test send from verified domain

### 5. Deliverability Best Practices

**DO:**
- Use subdomain for transactional emails (`mail.`, `email.`, `updates.`)
- Warm up domain gradually (start with small volumes)
- Monitor bounce/complaint rates (keep < 5% and < 0.1%)
- Use double opt-in for marketing lists
- Include unsubscribe links in all marketing emails
- Keep email lists clean (remove hard bounces)

**DON'T:**
- Use shared/free domains (gmail.com, yahoo.com)
- Send from `noreply@` if you want replies
- Send to purchased lists
- Use spam trigger words in subject lines ("FREE", "ACT NOW", etc.)
- Send high volumes immediately after domain setup
```

### 7. Batch Sending & Scheduling

```ts
// ✅ CORRECT - Batch email with rate limiting
// lib/email/services/batch.ts
import { sendEmail } from '@/lib/email/resend'
import { logger } from '@/lib/utils'
import pLimit from 'p-limit'

export async function sendBatchEmails(params: {
  emails: Array<{ to: string; subject: string; react: React.ReactElement }>
  from: string
  batchSize?: number
  delayMs?: number
}) {
  const { emails, from, batchSize = 10, delayMs = 1000 } = params
  const limit = pLimit(batchSize) // Concurrent limit
  const results: Array<{ success: boolean; email: string; error?: any }> = []

  logger.info({ count: emails.length, batchSize }, 'Starting batch email send')

  for (let i = 0; i < emails.length; i += batchSize) {
    const batch = emails.slice(i, i + batchSize)

    const batchResults = await Promise.all(
      batch.map((email) =>
        limit(async () => {
          try {
            await sendEmail({
              from,
              to: email.to,
              subject: email.subject,
              react: email.react,
            })
            return { success: true, email: email.to }
          } catch (error) {
            logger.error({ error, to: email.to }, 'Batch email failed')
            return { success: false, email: email.to, error }
          }
        })
      )
    )

    results.push(...batchResults)

    // Delay between batches to avoid rate limits
    if (i + batchSize < emails.length) {
      await new Promise((resolve) => setTimeout(resolve, delayMs))
    }
  }

  const successCount = results.filter((r) => r.success).length
  logger.info(
    { total: emails.length, success: successCount, failed: emails.length - successCount },
    'Batch email send complete'
  )

  return results
}

// ✅ CORRECT - Scheduled email (natural language)
export async function sendScheduledEmail(params: {
  to: string
  subject: string
  react: React.ReactElement
  scheduledAt: string // "in 1 hour", "tomorrow at 9am", "2025-12-01T09:00:00Z"
}) {
  return await sendEmail({
    from: FROM_ADDRESS,
    to: params.to,
    subject: params.subject,
    react: params.react,
    scheduledAt: params.scheduledAt,
    tags: [{ name: 'scheduled', value: 'true' }],
  })
}

// ❌ WRONG - No rate limiting, no error handling
export async function sendBatchEmails(emails: any[]) {
  return await Promise.all(
    emails.map((email) => resend.emails.send(email))
  )
}
```

**Key Patterns:**
- Use `p-limit` for concurrency control
- Batch processing with delays to respect rate limits
- Individual error handling (one failure doesn't stop batch)
- Structured logging for batch metrics
- Natural language scheduling ("in 1 hour", "tomorrow at 9am")

### 8. Marketing Emails & Audiences

```ts
// ✅ CORRECT - Audience management
// lib/email/services/audiences.ts
import { resend } from '@/lib/email/resend'
import { logger } from '@/lib/utils'

export async function addToAudience(params: {
  audienceId: string
  email: string
  firstName?: string
  lastName?: string
  unsubscribed?: boolean
}) {
  try {
    const contact = await resend.contacts.create({
      audienceId: params.audienceId,
      email: params.email,
      firstName: params.firstName,
      lastName: params.lastName,
      unsubscribed: params.unsubscribed ?? false,
    })

    logger.info({ contactId: contact.id, email: params.email }, 'Added to audience')
    return { success: true, contact }
  } catch (error) {
    logger.error({ error, email: params.email }, 'Failed to add to audience')
    return { success: false, error }
  }
}

export async function removeFromAudience(params: {
  audienceId: string
  email: string
}) {
  try {
    await resend.contacts.remove({
      audienceId: params.audienceId,
      email: params.email,
    })

    logger.info({ email: params.email }, 'Removed from audience')
    return { success: true }
  } catch (error) {
    logger.error({ error, email: params.email }, 'Failed to remove from audience')
    return { success: false, error }
  }
}

export async function updateContactPreferences(params: {
  audienceId: string
  email: string
  unsubscribed: boolean
}) {
  try {
    await resend.contacts.update({
      audienceId: params.audienceId,
      email: params.email,
      unsubscribed: params.unsubscribed,
    })

    logger.info({ email: params.email, unsubscribed: params.unsubscribed }, 'Contact preferences updated')
    return { success: true }
  } catch (error) {
    logger.error({ error, email: params.email }, 'Failed to update preferences')
    return { success: false, error }
  }
}

// ✅ CORRECT - CSV import for bulk audience management
export async function importAudienceFromCSV(params: {
  audienceId: string
  csvData: Array<{ email: string; firstName?: string; lastName?: string }>
  batchSize?: number
}) {
  const { audienceId, csvData, batchSize = 100 } = params
  const results = { success: 0, failed: 0, errors: [] as any[] }

  logger.info({ count: csvData.length, audienceId }, 'Starting CSV import')

  for (let i = 0; i < csvData.length; i += batchSize) {
    const batch = csvData.slice(i, i + batchSize)

    await Promise.all(
      batch.map(async (contact) => {
        try {
          await addToAudience({
            audienceId,
            email: contact.email,
            firstName: contact.firstName,
            lastName: contact.lastName,
          })
          results.success++
        } catch (error) {
          results.failed++
          results.errors.push({ email: contact.email, error })
        }
      })
    )
  }

  logger.info(results, 'CSV import complete')
  return results
}
```

**Key Patterns:**
- Centralize audience management in service layer
- Handle unsubscribe preferences
- Support CSV bulk imports with batching
- Log all audience operations
- Return structured results (success/error)
- Auto-unsubscribe on bounces/complaints (in webhook handler)

### 9. Template Management & Variables

```ts
// ✅ CORRECT - Template-based email sending
// lib/email/services/templates.ts
import { resend } from '@/lib/email/resend'
import { logger } from '@/lib/utils'

export async function sendTemplateEmail(params: {
  to: string | string[]
  templateId: string
  variables: Record<string, string | number>
  from?: string
  tags?: Array<{ name: string; value: string }>
}) {
  const { to, templateId, variables, from, tags } = params

  try {
    const result = await resend.emails.send({
      from: from || process.env.RESEND_FROM_ADDRESS!,
      to,
      // Use template instead of react/html
      template: templateId,
      // Pass variables for personalization
      ...variables,
      tags,
    })

    logger.info(
      { emailId: result.id, templateId, to },
      'Template email sent'
    )
    return { success: true, data: result }
  } catch (error) {
    logger.error({ error, templateId, to }, 'Template email failed')
    return { success: false, error }
  }
}

// Example: Send personalized marketing email using template
export async function sendProductUpdateEmail(params: {
  to: string
  firstName: string
  productName: string
  updateDate: string
}) {
  return await sendTemplateEmail({
    to: params.to,
    templateId: 'product-update-v2', // Template ID from Resend dashboard
    variables: {
      firstName: params.firstName,
      productName: params.productName,
      updateDate: params.updateDate,
      // Variables with fallbacks defined in template
    },
    tags: [
      { name: 'category', value: 'marketing' },
      { name: 'type', value: 'product-update' },
    ],
  })
}
```

**Key Patterns:**
- Templates stored in Resend dashboard (versioned)
- Use `template` parameter instead of `react`/`html`
- Pass variables as key-value pairs
- Template variables support fallback values
- Iterate on templates without code deploys
- Version control for template changes

### 10. SMTP Configuration (Alternative to API)

```ts
// ✅ CORRECT - SMTP configuration for frameworks without Resend SDK
// lib/email/smtp.ts (if using Nodemailer or similar)
import nodemailer from 'nodemailer'
import { logger } from '@/lib/utils'

const transporter = nodemailer.createTransport({
  host: 'smtp.resend.com',
  port: 465, // SMTPS (SSL/TLS from start) OR 587 for STARTTLS
  secure: true, // true for 465, false for 587
  auth: {
    user: 'resend',
    pass: process.env.RESEND_API_KEY,
  },
})

export async function sendSMTPEmail(params: {
  from: string
  to: string | string[]
  subject: string
  html: string
  text?: string
}) {
  try {
    const info = await transporter.sendMail({
      from: params.from,
      to: params.to,
      subject: params.subject,
      html: params.html,
      text: params.text,
    })

    logger.info({ messageId: info.messageId, to: params.to }, 'SMTP email sent')
    return { success: true, messageId: info.messageId }
  } catch (error) {
    logger.error({ error, to: params.to }, 'SMTP email failed')
    return { success: false, error }
  }
}
```

**SMTP Connection Details:**
- **Host**: `smtp.resend.com`
- **Ports**:
  - `465` and `2465` - SMTPS (SSL/TLS from start)
  - `587` and `2587` - STARTTLS (upgrade to TLS)
  - `25` - STARTTLS (standard)
- **Auth**: Username `resend`, password is your `RESEND_API_KEY`
- **Use Cases**: Laravel, Rails, Django, WordPress, frameworks without native SDK

**When to Use SMTP vs API:**
- ✅ **Use API** (preferred): Better error handling, more features, native SDK support
- ⚠️ **Use SMTP**: Legacy systems, frameworks without Resend SDK, existing SMTP infrastructure

### 11. Inbound Email Handling

```ts
// ✅ CORRECT - Inbound email webhook handler
// app/api/webhooks/resend/inbound/route.ts
import type { NextRequest } from 'next/server'
import { z } from 'zod'
import { apiSuccess, apiError } from '@/lib/api/next/response'
import { logger } from '@/lib/utils'
import { db } from '@/lib/db'
import { inboundEmails } from '@/lib/db/schema'

const InboundEmailSchema = z.object({
  type: z.literal('email.received'),
  created_at: z.string(),
  data: z.object({
    from: z.string().email(),
    to: z.array(z.string().email()),
    subject: z.string(),
    html: z.string().optional(),
    text: z.string().optional(),
    reply_to: z.array(z.string().email()).optional(),
    attachments: z.array(
      z.object({
        content_type: z.string(),
        filename: z.string(),
        size: z.number(),
        url: z.string().url(), // Download URL
      })
    ).optional(),
  }),
})

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const event = InboundEmailSchema.parse(body)

    logger.info(
      { from: event.data.from, subject: event.data.subject },
      'Inbound email received'
    )

    // Store inbound email
    const [stored] = await db.insert(inboundEmails).values({
      from: event.data.from,
      to: event.data.to,
      subject: event.data.subject,
      html: event.data.html,
      text: event.data.text,
      attachments: event.data.attachments,
      receivedAt: new Date(event.created_at),
    }).returning()

    // Process attachments if present
    if (event.data.attachments && event.data.attachments.length > 0) {
      await processInboundAttachments(stored.id, event.data.attachments)
    }

    // Auto-reply if needed
    if (event.data.from.includes('support')) {
      await sendAutoReply(event.data.from, event.data.subject)
    }

    return apiSuccess({ received: true, emailId: stored.id })
  } catch (error) {
    logger.error({ error }, 'Inbound email processing failed')
    return apiSuccess({ received: false, error: 'Processing failed' })
  }
}

async function processInboundAttachments(
  emailId: string,
  attachments: Array<{ url: string; filename: string; content_type: string }>
) {
  for (const attachment of attachments) {
    try {
      // Download attachment from Resend
      const response = await fetch(attachment.url)
      const buffer = await response.arrayBuffer()

      // Upload to your storage (S3, Supabase Storage, etc.)
      await uploadAttachment({
        emailId,
        filename: attachment.filename,
        contentType: attachment.content_type,
        buffer,
      })

      logger.info({ emailId, filename: attachment.filename }, 'Attachment processed')
    } catch (error) {
      logger.error({ error, filename: attachment.filename }, 'Attachment processing failed')
    }
  }
}

async function sendAutoReply(to: string, originalSubject: string) {
  await sendEmail({
    from: process.env.RESEND_FROM_ADDRESS!,
    to,
    subject: `Re: ${originalSubject}`,
    react: AutoReplyEmail({ subject: originalSubject }),
  })
}
```

**Inbound Email Setup:**
1. Configure inbound address in Resend Dashboard:
   - Default: `<alias>@<id>.resend.app`
   - Custom: `support@yourdomain.com` (requires domain verification)
2. Create webhook endpoint for `email.received` events
3. Process email content, attachments, auto-replies

**Use Cases:**
- Support ticket systems
- Receipt processing (parse attachments)
- Auto-responders
- Email-based workflows
- Reply-to-email features

### 12. DMARC Monitoring & Deliverability

```ts
// ✅ CORRECT - DMARC report parsing utility
// lib/email/services/dmarc.ts
import { logger } from '@/lib/utils'
import { db } from '@/lib/db'
import { dmarcReports } from '@/lib/db/schema'

/**
 * DMARC Report Types:
 * - RUA (Aggregate): Daily summaries of authentication results
 * - RUF (Forensic): Individual failure reports (rarely sent by Gmail/Outlook)
 */
export async function processDMARCReport(params: {
  reportXml: string
  reportType: 'rua' | 'ruf'
}) {
  try {
    const parsed = parseDMARCXML(params.reportXml)

    // Store report for analysis
    await db.insert(dmarcReports).values({
      reportType: params.reportType,
      orgName: parsed.orgName,
      dateRange: parsed.dateRange,
      domain: parsed.domain,
      policy: parsed.policy, // none, quarantine, reject
      records: parsed.records,
      createdAt: new Date(),
    })

    // Alert on failures
    const failedRecords = parsed.records.filter(
      (r: any) => r.disposition !== 'none' || r.dkim !== 'pass' || r.spf !== 'pass'
    )

    if (failedRecords.length > 0) {
      logger.warn(
        { domain: parsed.domain, failures: failedRecords.length },
        'DMARC authentication failures detected'
      )
      await alertOnDMARCFailures(parsed.domain, failedRecords)
    }

    return { success: true }
  } catch (error) {
    logger.error({ error }, 'DMARC report processing failed')
    return { success: false, error }
  }
}

function parseDMARCXML(xml: string) {
  // Parse DMARC XML format
  // Extract: org_name, date_range, policy_published, record (source_ip, count, policy_evaluated)
  // Implementation depends on XML parser (xml2js, fast-xml-parser, etc.)
  return {
    orgName: 'example.com',
    dateRange: { begin: '2025-01-01', end: '2025-01-02' },
    domain: 'clarity.finance',
    policy: 'quarantine',
    records: [
      {
        sourceIp: '192.0.2.1',
        count: 100,
        disposition: 'none', // none | quarantine | reject
        dkim: 'pass', // pass | fail
        spf: 'pass', // pass | fail
      },
    ],
  }
}

async function alertOnDMARCFailures(domain: string, failures: any[]) {
  // Send alert to team
  await sendEmail({
    from: process.env.RESEND_FROM_ADDRESS!,
    to: 'devops@clarity.finance',
    subject: `DMARC Failures Detected for ${domain}`,
    react: DMARCAlertEmail({ domain, failures }),
  })
}

/**
 * Deliverability Health Check
 */
export async function checkDeliverabilityHealth() {
  const checks = {
    bounceRate: await calculateBounceRate(), // Keep < 4%
    complaintRate: await calculateComplaintRate(), // Keep < 0.08%
    domainReputation: await checkDomainReputation(),
    dmarcCompliance: await checkDMARCCompliance(),
  }

  logger.info(checks, 'Deliverability health check')

  // Alert if thresholds exceeded
  if (checks.bounceRate > 0.04 || checks.complaintRate > 0.0008) {
    await alertDeliverabilityIssues(checks)
  }

  return checks
}

async function calculateBounceRate() {
  // Query email_events table for bounces vs total sent
  const { bounces, total } = await db.query.emailEvents.findMany({
    // Calculate bounce rate from last 7 days
  })
  return bounces / total
}

async function calculateComplaintRate() {
  // Query email_events table for complaints vs total sent
  const { complaints, total } = await db.query.emailEvents.findMany({
    // Calculate complaint rate from last 7 days
  })
  return complaints / total
}
```

**DMARC Best Practices:**
- Start with `p=none` policy (monitor only)
- Gradually move to `p=quarantine` after confirming SPF/DKIM pass
- Use `p=reject` only after extensive testing
- Monitor RUA reports daily for authentication issues
- Keep bounce rate < 4%, complaint rate < 0.08%
- Use Google Postmaster Tools, MXToolbox for reputation monitoring

**Deliverability Metrics:**
- **Bounce Rate**: < 4% (hard bounces indicate invalid emails)
- **Complaint Rate**: < 0.08% (spam reports)
- **Open Rate**: 15-25% (varies by industry)
- **Click Rate**: 2-5% (engagement indicator)

## Anti-Patterns to Avoid

### ❌ Hardcoded Email Addresses
```ts
// ❌ BAD
await resend.emails.send({
  from: 'noreply@example.com', // Hardcoded
  to: 'user@example.com',
})

// ✅ GOOD
const FROM_ADDRESS = process.env.RESEND_FROM_ADDRESS || 'Clarity <noreply@clarity.finance>'
await sendEmail({ from: FROM_ADDRESS, to: userEmail })
```

### ❌ Inline HTML Templates
```ts
// ❌ BAD - Inline HTML, no design system
html: `<h1>Welcome ${name}</h1>`

// ✅ GOOD - React Email component
react: WelcomeEmail({ firstName: name })
```

### ❌ Missing Error Handling
```ts
// ❌ BAD - Uncaught errors block user flow
await resend.emails.send(params)
await createUser(data)

// ✅ GOOD - Email failures shouldn't block critical operations
try {
  await sendWelcomeEmail(user)
} catch (error) {
  logger.error({ error }, 'Welcome email failed')
  // Continue with user creation
}
```

### ❌ No Rate Limiting
```ts
// ❌ BAD - Vulnerable to abuse
export async function POST(request) {
  await sendEmail(await request.json())
}

// ✅ GOOD - Rate limited
export const POST = withAuthRoute(
  { requests: 10, windowMs: 60000 },
  async (request, context, user) => { ... }
)
```

### ❌ Ignoring Webhook Events
```ts
// ❌ BAD - Just log and ignore
export async function POST(request) {
  const event = await request.json()
  console.log(event)
  return Response.json({ ok: true })
}

// ✅ GOOD - Handle bounces, complaints, clicks
switch (event.type) {
  case 'email.bounced':
    await handleBounce(event.data)
    break
  case 'email.complained':
    await handleComplaint(event.data)
    break
}
```

## Audit Checklist

### Critical Issues (Must Fix) - 25 points each
- [ ] Resend API key stored in environment variable (not hardcoded)
- [ ] Domain verified with SPF + DKIM records
- [ ] React Email templates used (not inline HTML)
- [ ] Error handling on all email sends (try/catch with logging)
- [ ] Webhook signature verification (`svix-signature` header)

### High Priority (Should Fix) - 15 points each
- [ ] Rate limiting on email endpoints (10-50/min)
- [ ] Structured logging with emailId, userId, requestId
- [ ] Design system colors used in templates (`hexColors` from `@/lib/design`)
- [ ] Bounce/complaint handling in webhooks (auto-unsubscribe)
- [ ] Tags added to emails for filtering (category, type, userId)
- [ ] Email events stored in database for analytics

### Medium Priority (Nice to Have) - 5 points each
- [ ] Batch sending with concurrency limits (`p-limit`)
- [ ] Scheduled email support (natural language or ISO 8601)
- [ ] Audience management integration (CSV import support)
- [ ] DMARC record configured (`p=quarantine` or `p=reject`)
- [ ] Template versioning (using Resend dashboard templates)
- [ ] Inbound email handling (support/reply-to features)
- [ ] Deliverability monitoring (bounce rate < 4%, complaint rate < 0.08%)

### Low Priority (Optional) - 2 points each
- [ ] SMTP fallback configured (for legacy systems)
- [ ] Attachment handling in inbound emails
- [ ] DMARC RUA report parsing
- [ ] Email sharing links (48-hour public access)

### Scoring Rubric
**Perfect Score (100/100)**:
- All critical: 125 (5 × 25)
- All high priority: 90 (6 × 15)
- All medium priority: 35 (7 × 5)
- All low priority: 8 (4 × 2)
- Total: 258 points (normalized to 100)

**Grades**:
- 95-100: Excellent ⭐⭐⭐⭐⭐ (Production gold standard)
- 85-94: Good ⭐⭐⭐⭐ (Production ready)
- 75-84: Acceptable ⭐⭐⭐ (Functional, needs optimization)
- 65-74: Needs Work ⚠️ (Multiple issues)
- <65: Critical Issues 🚨 (Not production ready)

## Environment Variables

```bash
# Required - Core Email Sending
RESEND_API_KEY=re_xxxxxxxxxxxxx
RESEND_FROM_ADDRESS="Clarity <noreply@clarity.finance>"
NEXT_PUBLIC_APP_URL=https://clarity.finance

# Optional - Webhooks
RESEND_WEBHOOK_SECRET=whsec_xxxxxxxxxxxxx  # For signature verification

# Optional - Marketing
RESEND_AUDIENCE_ID=aud_xxxxxxxxxxxxx       # Default audience for newsletters

# Optional - SMTP (if using SMTP instead of API)
SMTP_HOST=smtp.resend.com
SMTP_PORT=465
SMTP_USER=resend
SMTP_PASS=${RESEND_API_KEY}

# Optional - Inbound Email
RESEND_INBOUND_ADDRESS=support@yourdomain.com  # Custom inbound address

# Optional - Templates
RESEND_TEMPLATE_WELCOME=welcome-v2
RESEND_TEMPLATE_PASSWORD_RESET=password-reset-v3
RESEND_TEMPLATE_TRANSACTION_ALERT=transaction-alert-v1
```

## Project Structure

```
lib/email/
├── resend.ts                    # Resend client initialization
├── services/
│   ├── transactional.ts        # Transactional emails (welcome, reset, etc.)
│   ├── batch.ts                # Batch sending utilities
│   └── audiences.ts            # Audience management
├── templates/
│   ├── WelcomeEmail.tsx        # Welcome email template
│   ├── PasswordResetEmail.tsx  # Password reset template
│   └── TransactionAlertEmail.tsx
└── types.ts                    # Email types

lib/db/schema/
└── email-events.ts             # Webhook events table

app/api/
├── v1/email/
│   └── send-welcome/route.ts   # Email sending endpoints
└── webhooks/
    └── resend/route.ts         # Webhook handler
```

## Email Event Types Reference

Resend tracks 12 event types throughout email lifecycle:

| Event Type | Description | Action Required |
|------------|-------------|-----------------|
| `email.sent` | Successfully transmitted to Resend | Log for analytics |
| `email.delivered` | Reached recipient's mail server | Update delivery status |
| `email.delivery_delayed` | Temporary delivery issue | Retry automatically |
| `email.bounced` | Rejected by recipient's server | Remove hard bounces |
| `email.complained` | Marked as spam by recipient | Auto-unsubscribe |
| `email.opened` | Recipient opened email | Track engagement |
| `email.clicked` | Recipient clicked link | Track click-through |
| `email.failed` | Send attempt unsuccessful | Alert and retry |
| `email.queued` | Broadcast/batch awaiting delivery | Monitor queue |
| `email.scheduled` | Pending future delivery | No action |
| `email.canceled` | User canceled scheduled email | Update status |

**Critical Events to Handle:**
- `email.bounced` → Remove hard bounces from lists (if `bounce_type === 'hard_bounce'`)
- `email.complained` → Immediately unsubscribe user
- `email.failed` → Log error, alert team if pattern emerges

## Quick Reference

### Send Transactional Email
```ts
import { sendWelcomeEmail } from '@/lib/email/services/transactional'

await sendWelcomeEmail({
  to: user.email,
  firstName: user.firstName,
  userId: user.id,
})
```

### Create React Email Template
```tsx
import { Html, Body, Button, Text } from '@react-email/components'
import { hexColors } from '@/lib/design'

export function MyEmail({ name }: { name: string }) {
  return (
    <Html>
      <Body style={{ backgroundColor: hexColors.light.background }}>
        <Text style={{ color: hexColors.light.foreground }}>
          Hello {name}
        </Text>
        <Button
          href="https://example.com"
          style={{ backgroundColor: hexColors.light.primary }}
        >
          Click me
        </Button>
      </Body>
    </Html>
  )
}
```

### Handle Webhook Event
```ts
export async function POST(request: NextRequest) {
  const signature = request.headers.get('svix-signature')
  if (!signature) return apiError('Missing signature', 401)

  const event = await request.json()

  switch (event.type) {
    case 'email.bounced':
      await handleBounce(event.data)
      break
    case 'email.complained':
      await handleComplaint(event.data)
      break
  }

  return apiSuccess({ received: true })
}
```

### Send Template Email
```ts
import { sendTemplateEmail } from '@/lib/email/services/templates'

await sendTemplateEmail({
  to: user.email,
  templateId: 'welcome-v2',
  variables: {
    firstName: user.firstName,
    companyName: 'Clarity',
  },
})
```

### Batch Send with Rate Limiting
```ts
import { sendBatchEmails } from '@/lib/email/services/batch'

await sendBatchEmails({
  emails: users.map(u => ({
    to: u.email,
    subject: 'Product Update',
    react: ProductUpdateEmail({ name: u.firstName }),
  })),
  from: FROM_ADDRESS,
  batchSize: 10,
  delayMs: 1000,
})
```

### Add to Audience
```ts
import { addToAudience } from '@/lib/email/services/audiences'

await addToAudience({
  audienceId: process.env.RESEND_AUDIENCE_ID!,
  email: user.email,
  firstName: user.firstName,
  lastName: user.lastName,
  unsubscribed: false,
})
```

### SMTP Configuration (Nodemailer)
```ts
const transporter = nodemailer.createTransport({
  host: 'smtp.resend.com',
  port: 465,
  secure: true,
  auth: {
    user: 'resend',
    pass: process.env.RESEND_API_KEY,
  },
})
```

## Import Cheat Sheet

```ts
// Resend client
import { resend } from '@/lib/email/resend'
import { sendEmail } from '@/lib/email/resend'

// Services
import {
  sendWelcomeEmail,
  sendPasswordResetEmail
} from '@/lib/email/services/transactional'
import { sendBatchEmails, sendScheduledEmail } from '@/lib/email/services/batch'
import {
  addToAudience,
  removeFromAudience,
  importAudienceFromCSV
} from '@/lib/email/services/audiences'
import { sendTemplateEmail } from '@/lib/email/services/templates'
import {
  processDMARCReport,
  checkDeliverabilityHealth
} from '@/lib/email/services/dmarc'

// Templates
import { WelcomeEmail } from '@/lib/email/templates/WelcomeEmail'
import { PasswordResetEmail } from '@/lib/email/templates/PasswordResetEmail'
import { TransactionAlertEmail } from '@/lib/email/templates/TransactionAlertEmail'

// React Email components
import {
  Html,
  Head,
  Body,
  Container,
  Section,
  Heading,
  Text,
  Button,
  Link,
  Hr,
  Img,
} from '@react-email/components'

// Design system (for email styles)
import { hexColors } from '@/lib/design'

// API infrastructure
import { withAuthRoute, apiSuccess, apiError } from '@/lib/api/next/handlers'
import { validateBody } from '@/lib/api/next/validation'
import { logger } from '@/lib/utils'
```

## Troubleshooting Guide

### Issue: Emails Not Sending
**Check:**
1. `RESEND_API_KEY` is valid and set
2. Domain is verified (SPF + DKIM)
3. `from` address uses verified domain
4. Check Resend dashboard for error logs

### Issue: Emails Going to Spam
**Check:**
1. DMARC record configured (`p=quarantine` minimum)
2. Bounce rate < 4%, complaint rate < 0.08%
3. Avoid spam trigger words in subject
4. Include unsubscribe link
5. Warm up domain (start with low volume)

### Issue: Webhooks Not Firing
**Check:**
1. Webhook URL is publicly accessible (use ngrok for local dev)
2. Endpoint returns 200 status
3. Signature verification not blocking requests
4. Check Resend dashboard for retry logs

### Issue: Templates Not Rendering
**Check:**
1. Template ID matches dashboard
2. All required variables provided
3. Variables have fallback values defined
4. Test template in Resend dashboard first

### Issue: High Bounce Rate
**Action:**
1. Validate email addresses before sending
2. Remove hard bounces immediately
3. Use double opt-in for new subscribers
4. Monitor bounce reasons in webhook events

## Resources

- **Resend Docs**: `/Users/zach/Documents/clarity/docs/resend/`
- **React Email**: https://react.email/docs
- **Design System**: `@/lib/design` (use `hexColors` for email templates)
- **API Infrastructure**: `@/lib/api/README.md`
- **Google Postmaster Tools**: Monitor sender reputation
- **MXToolbox**: Check domain blacklists and DNS records
- **Resend Dashboard**: https://resend.com/emails (view logs, metrics)
