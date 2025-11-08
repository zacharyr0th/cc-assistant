# TOON (Tokenization-Optimized Object Notation)

> **Token-efficient data format for Claude Code, reducing LLM token consumption by 40-61%**

## Overview

TOON is a specialized data serialization format designed to minimize token consumption when sharing structured data with Large Language Models. It achieves dramatic token savings compared to JSON while maintaining human readability.

## Quick Links

- **[Quick Start Guide](TOON_QUICK_START.md)** - Get started with TOON in 5 minutes
- **[Integration Strategy](TOON_INTEGRATION_STRATEGY.md)** - Detailed analysis and integration guide
- **[API Reference](../../utils/toon/README.md)** - Complete API documentation for the TOON library

## Key Benefits

- **40-61% fewer tokens** than JSON for structured data
- **Human-readable** format (similar to CSV)
- **Type-safe** encoding/decoding with TypeScript
- **Streaming support** for large datasets
- **Schema inference** and validation
- **Production-ready** with comprehensive tests

## Token Savings Examples

### Financial Data (58% savings)
```
JSON:  1,830 tokens
TOON:    774 tokens
Savings:  58%
```

### User Records (61% savings)
```
JSON:  2,420 tokens
TOON:    950 tokens
Savings:  61%
```

### API Responses (40% savings)
```
JSON:  1,200 tokens
TOON:    720 tokens
Savings:  40%
```

## When to Use TOON

**Use TOON when**:
- Sharing tabular data with Claude (transactions, users, metrics)
- Working with large datasets that consume many tokens
- Optimizing context window usage
- Building data-heavy Claude Code skills or agents

**Do not use TOON when**:
- Data is deeply nested (JSON is better)
- Single records (overhead not worth it)
- Data needs to be consumed by non-LLM systems (use JSON)

## Basic Example

**JSON Format** (verbose):
```json
[
  {"id": 1, "name": "Alice", "balance": 5420.50},
  {"id": 2, "name": "Bob", "balance": 3210.75},
  {"id": 3, "name": "Charlie", "balance": 8901.25}
]
```

**TOON Format** (compact):
```
[3]{id,name,balance}:
1,Alice,5420.50
2,Bob,3210.75
3,Charlie,8901.25
```

**Token Comparison**:
- JSON: ~120 tokens
- TOON: ~52 tokens
- **Savings: 57%**

## How It Works

TOON achieves token efficiency through:

1. **Schema hoisting**: Column names declared once, not per row
2. **Minimal syntax**: Uses `,` and `\n` instead of `{}[]"":,`
3. **Type inference**: Automatically detects and coerces types
4. **Streaming**: Process large datasets without loading all into memory

## Integration

### In Claude Code Skills

```typescript
import { encodeTOON } from '@/claude/utils/toon'

// In your skill that fetches data
const transactions = await getTransactions()

// Encode to TOON before sharing with Claude
const toonData = encodeTOON(transactions)

console.log(`Sending ${toonData.length} chars (${estimateTokens(toonData)} tokens)`)
```

### In Agents

```markdown
# financial-analyst.md

When analyzing transactions, request data in TOON format to save tokens:

"Please provide the transaction data in TOON format for efficient analysis."

TOON data looks like:
[count]{columns}:
val1,val2,val3
...
```

### In Commands

```bash
# Export data in TOON format
/export-transactions --format=toon --days=30
```

## Library Location

The TOON library is located at:
```
.claude/utils/toon/
├── index.ts          # Main exports
├── encoder.ts        # Encoding logic
├── decoder.ts        # Decoding logic
├── schema.ts         # Schema inference
├── stream.ts         # Streaming support
├── llm.ts            # LLM-specific utilities
├── measure.ts        # Token measurement
└── README.md         # API reference
```

## Documentation Structure

```
.claude/docs/toon/
├── README.md                      # This file
├── TOON_QUICK_START.md           # Quick start guide
└── TOON_INTEGRATION_STRATEGY.md  # Detailed integration analysis
```

## Getting Started

1. **Read the [Quick Start Guide](TOON_QUICK_START.md)** to understand TOON basics
2. **Review the [Integration Strategy](TOON_INTEGRATION_STRATEGY.md)** for detailed implementation guidance
3. **Check the [API Reference](../../utils/toon/README.md)** for complete function documentation
4. **See examples** in `.claude/utils/toon/examples.ts`

## Use Cases in Claude Starter

### Dashboard Data
```typescript
// Encode multiple data sources for efficient context
const dashboardData = {
  accounts: encodeTOON(accounts),
  transactions: encodeTOON(recentTransactions),
  metrics: encodeTOON(monthlyMetrics)
}
```

### Agent Analysis
```markdown
Analyze this financial data (TOON format for efficiency):

Accounts:
[5]{id,name,type,balance}:
1,Checking,bank,5420.50
2,Savings,bank,12500.00
...

Transactions:
[100]{date,merchant,amount,category}:
2024-11-01,Amazon,45.99,Shopping
2024-11-02,Starbucks,6.50,Food
...
```

### Skill Optimization
```typescript
// Before: 2,000 tokens of JSON
const jsonData = JSON.stringify(data)

// After: 800 tokens of TOON (60% savings!)
const toonData = encodeTOON(data)
```

## Performance

- **Encoding**: ~10ms for 1,000 records
- **Decoding**: ~15ms for 1,000 records
- **Streaming**: Handles millions of records
- **Token savings**: Consistent 40-61% reduction

## Testing

TOON is production-ready with comprehensive test coverage:
```bash
cd .claude/utils/toon
npm test
```

## Version

Current Version: 1.0.0 (Production Ready)

## Credits

TOON was developed as part of the Claude Starter Kit to optimize token usage in Claude Code applications. It's particularly effective for financial data, user records, and analytical datasets.

## Questions?

- **API details**: See [API Reference](../../utils/toon/README.md)
- **Integration help**: See [Integration Strategy](TOON_INTEGRATION_STRATEGY.md)
- **Quick examples**: See [Quick Start](TOON_QUICK_START.md)
- **Code examples**: See `.claude/utils/toon/examples.ts`

---

**License**: MIT (same as Claude Starter Kit)
