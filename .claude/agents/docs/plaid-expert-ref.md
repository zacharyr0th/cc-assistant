# Plaid API Reference for plaid-expert

## Transactions API - Core Endpoints

### `/transactions/sync` (Primary Method)
Retrieves transactions using **cursor-based pagination** for incremental updates.

**Key Parameters:**
- `access_token` (required)
- `cursor` (optional) - Use for incremental updates; omit for initial sync
- `count` (1-500 transactions per request; default 100)
- `options.days_requested` (1-730 days; default 90)
- `options.account_id` (filters to specific account)

**Response Fields:**
- `next_cursor` - Use in next request for pagination
- `has_more` - Boolean indicating if more transactions exist
- Upper-bound cursor length: **256 characters of base64**

### Cursor Management Best Practices

**Initial Sync:** Omit cursor or use `"now"` when migrating from `/transactions/get`

**Pagination Loop:**
```typescript
let cursor = undefined;
let hasMore = true;

while (hasMore) {
  const response = await plaid.transactionsSync({
    access_token,
    cursor,
    count: 100
  });

  // Process response.added, response.modified, response.removed

  cursor = response.next_cursor;
  hasMore = response.has_more;
}
```

**Critical:** If pagination fails mid-stream, restart from the **original cursor**, not the failed request's cursor.

## Webhook Events

Six webhook types notify you of data changes:

| Event | Description | When Triggered |
|-------|-------------|----------------|
| `SYNC_UPDATES_AVAILABLE` | New changes ready | Real-time updates available |
| `INITIAL_UPDATE` | Historical pull complete | First sync finished |
| `HISTORICAL_UPDATE` | Extended history available | Institution provides more data |
| `DEFAULT_UPDATE` | Recent transactions posted | Daily/periodic check |
| `TRANSACTIONS_REMOVED` | Deletions detected | Institution removed transactions |
| `RECURRING_TRANSACTIONS_UPDATE` | Pattern changes | Recurring analysis updated |

## Data Coverage & Limits

**Supported Account Types:**
- `credit` - Credit cards
- `depository` - Checking/savings
- Student `loan` accounts

**Historical Data:** Up to **24 months** of transaction history

**Sync Frequency:** Plaid checks for new transactions **1-4 times per day** depending on institution

**Rate Limits:** Not explicitly documented in fetched content - check Plaid dashboard

## Transaction Data Structure

Transactions include:
- Merchant details
- Geolocation data
- Categorization (Plaid's category taxonomy)
- Amount, date, description
- Pending/posted status

## Best Practices

1. **Use `/transactions/sync` exclusively** - Don't mix with legacy `/transactions/get`
2. **Store cursors** - Persist cursor after each successful sync
3. **Handle webhook ordering** - Events may arrive out of order
4. **Batch database operations** - Don't insert one transaction at a time
5. **Implement retry logic** - Network failures happen during pagination
6. **Validate webhook signatures** - Always verify webhook authenticity
7. **Use advisory locks** - Prevent concurrent syncs for same item

## Error Handling

Common error scenarios:
- Item requires reauthentication (ITEM_LOGIN_REQUIRED)
- Rate limit exceeded (wait and retry with exponential backoff)
- Network timeout during pagination (restart from last successful cursor)
- Invalid cursor (restart sync from beginning)

## Migration from /transactions/get

When migrating existing integrations:
1. Use `cursor: "now"` in first `/transactions/sync` call
2. This skips historical sync, starting from current point
3. Store returned cursor for future incremental syncs
4. Remove all `/transactions/get` calls

---

**Source:** Plaid Transactions API Documentation
**Last Updated:** 2025-10-25
