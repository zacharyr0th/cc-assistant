---
name: stripe-billing-subscriptions
description: Expert in Stripe billing, subscriptions, recurring payments, metered billing, invoicing, and revenue management. Use for subscription modeling, billing cycles, proration, usage-based pricing, dunning, and customer lifecycle management.
allowed-tools: Read, Grep, Glob
---

# Stripe Billing & Subscriptions Expert

## Purpose

Specialized expertise in Stripe's billing and subscription systems. Covers all aspects of recurring revenue, subscription management, usage-based billing, invoicing, and financial operations.

## Documentation Base

**Location**: `/Users/zach/Documents/cc-skills/docs/stripe/`

**Key Sections**:
- `billing/` - Core billing documentation (124+ files)
- `billing/subscriptions/` - Subscription management
- `billing/subscriptions/usage-based/` - Metered & usage-based billing
- `revenue-recognition/` - Revenue reporting (50+ files)
- `api/subscriptions/` - Subscription API reference
- `api/invoices/` - Invoice API reference
- `api/prices/` - Pricing API
- `customer-management/` - Customer portal & management

## Core Capabilities

### 1. Subscription Models
- **Fixed pricing** - Monthly/annual subscriptions
- **Tiered pricing** - Volume-based tiers
- **Volume pricing** - Price per unit
- **Graduated pricing** - Tier-based unit pricing
- **Package pricing** - Bundled units
- **Usage-based** - Metered billing (API calls, seats, etc.)
- **Hybrid models** - Base fee + usage

### 2. Subscription Lifecycle
- Creation & activation
- Trial periods & conversions
- Upgrades & downgrades
- Prorations & billing adjustments
- Pausing & resuming
- Cancellations & retention
- Backdating subscriptions

### 3. Invoicing
- Automatic invoice generation
- Manual invoices
- Invoice customization
- Payment collection
- Dunning management
- Failed payment recovery
- Invoice finalization

### 4. Usage-Based Billing
- Meter events (API-based metering)
- Aggregation methods (sum, max, last)
- Billing thresholds
- Usage reporting & analytics
- Billing credits
- Grace periods

### 5. Revenue Recognition
- ASC 606 & IFRS 15 compliance
- Deferred revenue tracking
- Revenue schedules
- Multi-currency handling
- Performance obligations

## Common Patterns

### Basic Subscription

```typescript
// Create customer with payment method
const customer = await stripe.customers.create({
  email: 'user@example.com',
  payment_method: paymentMethodId,
  invoice_settings: {
    default_payment_method: paymentMethodId,
  },
});

// Create subscription
const subscription = await stripe.subscriptions.create({
  customer: customer.id,
  items: [{
    price: 'price_monthly_pro', // Price ID from dashboard
  }],
  expand: ['latest_invoice.payment_intent'],
});
```

### Usage-Based Subscription

```typescript
// 1. Create meter (one-time, in Dashboard or API)
const meter = await stripe.billing.meters.create({
  display_name: 'API Requests',
  event_name: 'api_request',
  default_aggregation: {
    formula: 'sum',
  },
});

// 2. Create price based on meter
const price = await stripe.prices.create({
  currency: 'usd',
  recurring: {
    interval: 'month',
    usage_type: 'metered',
  },
  billing_scheme: 'per_unit',
  unit_amount_decimal: '0.01', // $0.01 per request
  product_data: {
    name: 'API Usage',
  },
});

// 3. Create subscription
const subscription = await stripe.subscriptions.create({
  customer: customerId,
  items: [{ price: price.id }],
});

// 4. Report usage
await stripe.billing.meterEvents.create({
  event_name: 'api_request',
  payload: {
    stripe_customer_id: customerId,
    value: '1', // 1 API request
  },
});
```

### Subscription with Trial

```typescript
const subscription = await stripe.subscriptions.create({
  customer: customerId,
  items: [{ price: priceId }],
  trial_period_days: 14, // 14-day free trial
  trial_settings: {
    end_behavior: {
      missing_payment_method: 'cancel', // Cancel if no payment method at trial end
    },
  },
});
```

### Proration on Upgrade/Downgrade

```typescript
// Upgrade subscription
const subscription = await stripe.subscriptions.update(subscriptionId, {
  items: [{
    id: subscriptionItemId,
    price: 'price_premium', // New price tier
  }],
  proration_behavior: 'create_prorations', // Pro-rate the difference
  billing_cycle_anchor: 'unchanged', // Keep original billing cycle
});
```

### Subscription Schedules (Future Changes)

```typescript
const schedule = await stripe.subscriptionSchedules.create({
  customer: customerId,
  start_date: 'now',
  end_behavior: 'release',
  phases: [
    {
      items: [{ price: 'price_starter' }],
      iterations: 3, // 3 billing cycles
    },
    {
      items: [{ price: 'price_pro' }],
      // Continues indefinitely
    },
  ],
});
```

### Handle Failed Payments

```typescript
// Webhook handler
if (event.type === 'invoice.payment_failed') {
  const invoice = event.data.object;
  
  // Get subscription
  const subscription = await stripe.subscriptions.retrieve(
    invoice.subscription
  );
  
  if (subscription.status === 'past_due') {
    // Send notification to customer
    await sendPaymentFailedEmail(invoice.customer_email);
    
    // Optionally pause service
    await pauseUserAccess(invoice.customer);
  }
}
```

### Customer Portal Integration

```typescript
// Create portal session
const session = await stripe.billingPortal.sessions.create({
  customer: customerId,
  return_url: 'https://example.com/account',
});

// Redirect user to session.url
// Customers can:
// - Update payment methods
// - View invoices
// - Manage subscriptions
// - Download receipts
```

## Advanced Patterns

### Multi-Plan Subscription

```typescript
const subscription = await stripe.subscriptions.create({
  customer: customerId,
  items: [
    { price: 'price_base_plan' },
    { price: 'price_addon_1' },
    { price: 'price_addon_2' },
  ],
});
```

### Billing Anchors

```typescript
// Anchor billing to specific day of month
const subscription = await stripe.subscriptions.create({
  customer: customerId,
  items: [{ price: priceId }],
  billing_cycle_anchor: Math.floor(
    new Date('2024-01-15').getTime() / 1000
  ), // Bill on 15th of each month
  proration_behavior: 'none',
});
```

### Subscription Metadata for Tracking

```typescript
const subscription = await stripe.subscriptions.create({
  customer: customerId,
  items: [{ price: priceId }],
  metadata: {
    internal_user_id: 'user_12345',
    plan_name: 'Professional',
    signup_source: 'landing_page_a',
    affiliate_id: 'aff_789',
  },
});
```

## Subscription States

| Status | Description | Actions Available |
|--------|-------------|-------------------|
| `incomplete` | Created but payment pending | Confirm payment |
| `incomplete_expired` | Payment not completed in 23h | Create new subscription |
| `trialing` | In trial period | Can update/cancel |
| `active` | Active and paid | Can update/cancel |
| `past_due` | Payment failed, retrying | Update payment method |
| `canceled` | Canceled by customer/admin | Can restart |
| `unpaid` | Payment failed, no retries | Requires manual intervention |
| `paused` | Temporarily paused | Can resume |

## Invoice Lifecycle

1. **draft** - Invoice created, not finalized
2. **open** - Finalized, awaiting payment
3. **paid** - Successfully paid
4. **void** - Canceled/voided
5. **uncollectible** - Marked as bad debt

## Best Practices

1. **Use Price objects** (not deprecated Plans)
2. **Enable Smart Retries** for failed payments
3. **Implement dunning logic** via webhooks
4. **Test trial-to-paid conversions** thoroughly
5. **Use subscription schedules** for future changes
6. **Implement customer portal** for self-service
7. **Monitor subscription metrics** (MRR, churn, LTV)
8. **Handle prorations correctly** on plan changes
9. **Set up invoice.paid webhooks** for fulfillment
10. **Use metadata** for internal tracking

## Key Webhooks

```typescript
// Essential subscription webhooks
const subscriptionEvents = [
  'customer.subscription.created',
  'customer.subscription.updated',
  'customer.subscription.deleted',
  'customer.subscription.trial_will_end', // 3 days before trial ends
  'customer.subscription.paused',
  'customer.subscription.resumed',
  
  'invoice.created',
  'invoice.finalized',
  'invoice.paid',
  'invoice.payment_failed',
  'invoice.payment_action_required', // 3D Secure needed
  
  'payment_intent.succeeded',
  'payment_intent.payment_failed',
];
```

## Testing Scenarios

1. **Successful subscription creation**
2. **Trial period behavior**
3. **Upgrade/downgrade with prorations**
4. **Failed payment scenarios**
5. **Dunning and retries**
6. **Cancellation and reactivation**
7. **Usage reporting accuracy**
8. **Invoice generation timing**
9. **Multi-currency subscriptions**
10. **Customer portal flows**

## Common Issues & Solutions

### Issue: Proration Confusion
**Solution**: Use `proration_behavior` parameter:
- `create_prorations` - Generate credit/charge for time difference
- `none` - No proration
- `always_invoice` - Create invoice immediately

### Issue: Trial Ends But No Payment Method
**Solution**: Use `trial_settings.end_behavior.missing_payment_method = 'cancel'`

### Issue: Multiple Failed Payments
**Solution**: Implement Smart Retries + custom dunning logic via webhooks

### Issue: Revenue Recognition Timing
**Solution**: Use Stripe Revenue Recognition product or implement custom logic based on `invoice.finalized` events

## Metrics to Monitor

- **MRR (Monthly Recurring Revenue)**
- **ARR (Annual Recurring Revenue)**
- **Churn Rate**
- **Upgrade/Downgrade Rates**
- **Trial Conversion Rate**
- **Payment Success Rate**
- **Dunning Recovery Rate**
- **Customer Lifetime Value (LTV)**
- **Average Revenue Per User (ARPU)**

## Documentation Quick Links

```bash
# Find subscription docs
grep -r "subscription" docs/stripe/billing/subscriptions/

# Find usage-based billing
ls docs/stripe/billing/subscriptions/usage-based/

# Find invoice docs
grep -r "invoice" docs/stripe/api/invoices/

# Find proration examples
grep -r "proration" docs/stripe/billing/

# Find customer portal docs
ls docs/stripe/customer-management/
```

## Reference

All code examples follow Stripe API version 2023-10+. For implementation details, consult:
- `/docs/stripe/billing/` - Billing fundamentals
- `/docs/stripe/billing/subscriptions/` - Subscription guides
- `/docs/stripe/revenue-recognition/` - Revenue tracking
- `/docs/stripe/api/subscriptions/` - API reference

