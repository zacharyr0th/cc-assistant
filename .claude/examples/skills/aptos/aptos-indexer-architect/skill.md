---
name: Aptos Indexer Architect
description: Expert in Aptos GraphQL indexing, custom processors, transaction streaming, and querying on-chain data. Covers indexer API, processor SDK, event parsing, and data analytics.
version: 1.0.0
---

# Aptos Indexer Architect

## Overview

Specialized skill for building **custom indexers** and querying **indexed blockchain data** on Aptos using GraphQL API and the Indexer SDK. The Aptos Indexer processes all on-chain transactions and makes them query able through a high-level GraphQL interface.

## Core Expertise

- **GraphQL Queries** - Query transactions, accounts, tokens, events, fungible assets
- **Custom Processors** - Build app-specific indexing logic with Indexer SDK
- **Transaction Streaming** - Real-time GRPC transaction stream integration
- **Event Parsing** - Extract and transform on-chain events
- **Data Models** - Design efficient schemas for indexed data
- **Performance** - Optimize queries, caching, pagination
- **Analytics** - Aggregate data for dashboards and metrics

## Indexer Architecture

```
┌─────────────┐
│  Aptos Node │
└──────┬──────┘
       │ Transactions
       ▼
┌─────────────────┐
│ Transaction     │
│ Stream (GRPC)   │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│ Indexer         │
│ Processors      │ ◄─── Custom Processors (Indexer SDK)
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│ PostgreSQL      │
│ Database        │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│ GraphQL API     │ ◄─── Query Interface
│ (Hasura)        │
└─────────────────┘
```

## GraphQL Indexer API

### Endpoints

- **Mainnet**: `https://api.mainnet.aptoslabs.com/v1/graphql`
- **Testnet**: `https://api.testnet.aptoslabs.com/v1/graphql`
- **Devnet**: `https://api.devnet.aptoslabs.com/v1/graphql`

### TypeScript SDK Integration

```typescript
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

const aptos = new Aptos(new AptosConfig({ network: Network.MAINNET }));

// Query account transactions
const transactions = await aptos.getAccountTransactions({
  accountAddress: "0x1",
  options: {
    limit: 25,
    offset: 0
  }
});

// Query fungible asset activities
const activities = await aptos.getFungibleAssetActivities({
  options: {
    where: {
      owner_address: { _eq: "0x123..." }
    },
    limit: 10
  }
});

// Query digital asset (NFT) ownership
const tokens = await aptos.getOwnedDigitalAssets({
  ownerAddress: "0x123...",
  options: {
    limit: 50
  }
});
```

### Direct GraphQL Queries

```graphql
# Get account transactions
query GetAccountTransactions($address: String!, $limit: Int!) {
  account_transactions(
    where: { account_address: { _eq: $address } }
    order_by: { transaction_version: desc }
    limit: $limit
  ) {
    transaction_version
    account_address
    token_data {
      token_data_id
      name
    }
  }
}

# Get token activities
query GetTokenActivities($token_id: String!) {
  token_activities_v2(
    where: { token_data_id: { _eq: $token_id } }
    order_by: { transaction_version: desc }
  ) {
    transaction_version
    type
    from_address
    to_address
    token_amount
    token_data_id
  }
}

# Get current fungible asset balances
query GetFungibleAssetBalances($owner: String!) {
  current_fungible_asset_balances(
    where: { owner_address: { _eq: $owner } }
  ) {
    asset_type
    amount
    owner_address
    storage_id
    metadata {
      name
      symbol
      decimals
    }
  }
}

# Get events by type
query GetEvents($event_type: String!, $limit: Int!) {
  events(
    where: { type: { _eq: $event_type } }
    order_by: { transaction_version: desc }
    limit: $limit
  ) {
    transaction_version
    sequence_number
    type
    data
    account_address
  }
}
```

## Common Query Patterns

### Account Transactions

```typescript
// Get all transactions for an account
const query = `
  query AccountTxns($address: String!, $offset: Int!, $limit: Int!) {
    account_transactions(
      where: { account_address: { _eq: $address } }
      order_by: { transaction_version: desc }
      offset: $offset
      limit: $limit
    ) {
      transaction_version
      sender
      success
      gas_used
      timestamp
      entry_function_id_str
    }
  }
`;

const variables = {
  address: "0x123...",
  offset: 0,
  limit: 25
};

const result = await fetch(INDEXER_URL, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ query, variables })
});
```

### Token Ownership

```typescript
// Get all NFTs owned by an account
const query = `
  query GetNFTs($owner: String!) {
    current_token_ownerships_v2(
      where: {
        owner_address: { _eq: $owner }
        amount: { _gt: "0" }
      }
    ) {
      token_data_id
      amount
      current_token_data {
        collection_id
        token_name
        token_uri
        current_collection {
          collection_name
          creator_address
        }
      }
    }
  }
`;
```

### Fungible Asset Transfers

```typescript
// Track FA transfer events
const query = `
  query GetFATransfers($asset_type: String!, $limit: Int!) {
    fungible_asset_activities(
      where: {
        asset_type: { _eq: $asset_type }
        type: { _eq: "0x1::fungible_asset::Withdraw" }
      }
      order_by: { transaction_version: desc }
      limit: $limit
    ) {
      transaction_version
      owner_address
      amount
      type
      block_height
      transaction_timestamp
    }
  }
`;
```

### Aggregate Queries

```typescript
// Get total supply and holder count
const query = `
  query GetTokenStats($collection_id: String!) {
    current_token_datas_v2_aggregate(
      where: { collection_id: { _eq: $collection_id } }
    ) {
      aggregate {
        count
        sum {
          maximum_v2
        }
      }
    }

    current_token_ownerships_v2_aggregate(
      where: {
        current_token_data: { collection_id: { _eq: $collection_id } }
        amount: { _gt: "0" }
      }
    ) {
      aggregate {
        count
      }
    }
  }
`;
```

## Custom Indexer Processors

### Setup Indexer SDK

```toml
[dependencies]
aptos-indexer-processor-sdk = { git = "https://github.com/aptos-labs/aptos-indexer-processors.git" }
aptos-protos = { git = "https://github.com/aptos-labs/aptos-core.git" }
tokio = { version = "1.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
```

### Basic Processor Structure

```rust
use aptos_indexer_processor_sdk::{
    aptos_protos::transaction::v1::Transaction,
    traits::{
        async_trait, NamedStep, Processable, ProcessingResult,
        TransactionContext, TransactionProcessingContext,
    },
    types::transaction_context::TransactionMetadata,
    utils::errors::ProcessorError,
};

#[derive(Debug)]
pub struct MyCustomProcessor {
    // Configuration
}

#[async_trait]
impl Processable for MyCustomProcessor {
    type Input = Transaction;
    type Output = Vec<MyCustomModel>;
    type RunType = AsyncRunType;

    async fn process(
        &mut self,
        transactions: TransactionContext<Transaction>,
    ) -> Result<ProcessingResult<Self::Output>, ProcessorError> {
        let mut all_items = vec![];

        for txn in &transactions.data {
            // Process transaction
            let items = self.process_transaction(txn)?;
            all_items.extend(items);
        }

        Ok(ProcessingResult {
            start_version: transactions.start_version,
            end_version: transactions.end_version,
            processing_duration_in_secs: transactions
                .metadata
                .processing_duration_in_secs,
            data: all_items,
        })
    }
}

impl MyCustomProcessor {
    fn process_transaction(
        &self,
        txn: &Transaction,
    ) -> Result<Vec<MyCustomModel>, ProcessorError> {
        let mut items = vec![];

        // Extract user transaction
        if let Some(user_txn) = &txn.user {
            // Parse events
            for event in &txn.events {
                if event.type_str == "0x1::my_module::MyEvent" {
                    // Parse event data
                    let item = self.parse_event(event, txn.version)?;
                    items.push(item);
                }
            }
        }

        Ok(items)
    }
}
```

### Event Parsing

```rust
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Serialize, Deserialize)]
pub struct TransferEventData {
    pub from: String,
    pub to: String,
    pub amount: String,
}

impl MyCustomProcessor {
    fn parse_event(
        &self,
        event: &Event,
        version: i64,
    ) -> Result<MyCustomModel, ProcessorError> {
        // Deserialize event data
        let event_data: TransferEventData =
            serde_json::from_str(&event.data)?;

        Ok(MyCustomModel {
            transaction_version: version,
            from_address: event_data.from,
            to_address: event_data.to,
            amount: event_data.amount.parse()?,
            timestamp: get_timestamp_from_txn(txn)?,
        })
    }
}

#[derive(Debug, Serialize)]
pub struct MyCustomModel {
    pub transaction_version: i64,
    pub from_address: String,
    pub to_address: String,
    pub amount: i64,
    pub timestamp: i64,
}
```

### Database Integration

```rust
use diesel::prelude::*;
use diesel::pg::PgConnection;

table! {
    my_custom_table (transaction_version) {
        transaction_version -> Int8,
        from_address -> Varchar,
        to_address -> Varchar,
        amount -> Int8,
        timestamp -> Timestamp,
    }
}

impl MyCustomProcessor {
    async fn save_to_db(
        &self,
        items: Vec<MyCustomModel>,
        conn: &mut PgConnection,
    ) -> Result<(), ProcessorError> {
        use my_custom_table::dsl::*;

        diesel::insert_into(my_custom_table)
            .values(&items)
            .on_conflict(transaction_version)
            .do_nothing()
            .execute(conn)?;

        Ok(())
    }
}
```

## Real-World Use Cases

### DEX Analytics Processor

```rust
pub struct DexAnalyticsProcessor {
    target_pool_address: String,
}

impl DexAnalyticsProcessor {
    fn process_swap_event(&self, event: &Event) -> SwapData {
        let data: SwapEventData = serde_json::from_str(&event.data)?;

        SwapData {
            pool_address: data.pool_address,
            token_in: data.token_in,
            token_out: data.token_out,
            amount_in: data.amount_in.parse()?,
            amount_out: data.amount_out.parse()?,
            price: calculate_price(&data),
            timestamp: event.timestamp,
        }
    }

    fn calculate_price(&self, data: &SwapEventData) -> f64 {
        let amount_in: f64 = data.amount_in.parse().unwrap();
        let amount_out: f64 = data.amount_out.parse().unwrap();
        amount_out / amount_in
    }
}
```

### NFT Marketplace Processor

```rust
pub struct NftMarketplaceProcessor;

impl NftMarketplaceProcessor {
    fn process_listing_event(&self, event: &Event) -> Listing {
        let data: ListingEventData = serde_json::from_str(&event.data)?;

        Listing {
            token_id: data.token_id,
            seller: data.seller,
            price: data.price.parse()?,
            listing_time: event.timestamp,
            active: true,
        }
    }

    fn process_sale_event(&self, event: &Event) -> Sale {
        let data: SaleEventData = serde_json::from_str(&event.data)?;

        Sale {
            token_id: data.token_id,
            seller: data.seller,
            buyer: data.buyer,
            price: data.price.parse()?,
            sale_time: event.timestamp,
        }
    }
}
```

### User Analytics Processor

```rust
pub struct UserAnalyticsProcessor;

impl UserAnalyticsProcessor {
    fn aggregate_user_activity(&self, txns: &[Transaction]) -> UserStats {
        let mut stats = HashMap::new();

        for txn in txns {
            if let Some(user_txn) = &txn.user {
                let sender = &user_txn.request.sender;

                let entry = stats.entry(sender.clone()).or_insert(UserActivity {
                    total_txns: 0,
                    total_gas: 0,
                    first_txn: txn.timestamp,
                    last_txn: txn.timestamp,
                });

                entry.total_txns += 1;
                entry.total_gas += user_txn.gas_used;
                entry.last_txn = txn.timestamp.max(entry.last_txn);
            }
        }

        stats
    }
}
```

## Performance Optimization

### 1. Efficient Pagination

```graphql
# Use cursor-based pagination for large datasets
query GetTransactionsCursor($cursor: Int!, $limit: Int!) {
  account_transactions(
    where: { transaction_version: { _gt: $cursor } }
    order_by: { transaction_version: asc }
    limit: $limit
  ) {
    transaction_version
    sender
    timestamp
  }
}
```

### 2. Select Only Needed Fields

```graphql
# ❌ Bad: Selecting all fields
query GetNFTs($owner: String!) {
  current_token_ownerships_v2(
    where: { owner_address: { _eq: $owner } }
  ) {
    # Returns ALL fields (slow)
  }
}

# ✅ Good: Select specific fields
query GetNFTs($owner: String!) {
  current_token_ownerships_v2(
    where: { owner_address: { _eq: $owner } }
  ) {
    token_data_id
    amount
    current_token_data {
      token_name
      token_uri
    }
  }
}
```

### 3. Use Aggregates for Counts

```graphql
# Get count without fetching all data
query GetNFTCount($owner: String!) {
  current_token_ownerships_v2_aggregate(
    where: {
      owner_address: { _eq: $owner }
      amount: { _gt: "0" }
    }
  ) {
    aggregate {
      count
    }
  }
}
```

### 4. Batch Queries

```typescript
// Batch multiple queries in one request
const query = `
  query BatchQueries($address: String!) {
    transactions: account_transactions(
      where: { account_address: { _eq: $address } }
      limit: 10
    ) {
      transaction_version
    }

    tokens: current_token_ownerships_v2(
      where: { owner_address: { _eq: $address } }
      limit: 10
    ) {
      token_data_id
    }

    balance: current_fungible_asset_balances(
      where: { owner_address: { _eq: $address } }
    ) {
      amount
      asset_type
    }
  }
`;
```

## Caching Strategies

```typescript
// Client-side caching with SWR
import useSWR from "swr";

const fetcher = async (query: string, variables: any) => {
  const res = await fetch(INDEXER_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ query, variables })
  });
  return res.json();
};

function useAccountTokens(address: string) {
  const { data, error, mutate } = useSWR(
    [GET_TOKENS_QUERY, { address }],
    ([query, vars]) => fetcher(query, vars),
    {
      refreshInterval: 30000, // Refresh every 30s
      revalidateOnFocus: false
    }
  );

  return {
    tokens: data?.data?.current_token_ownerships_v2,
    isLoading: !error && !data,
    isError: error,
    refresh: mutate
  };
}
```

## Error Handling

```typescript
async function queryWithRetry(
  query: string,
  variables: any,
  maxRetries = 3
) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const res = await fetch(INDEXER_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ query, variables })
      });

      if (!res.ok) {
        throw new Error(`HTTP ${res.status}: ${res.statusText}`);
      }

      const json = await res.json();

      if (json.errors) {
        throw new Error(`GraphQL Errors: ${JSON.stringify(json.errors)}`);
      }

      return json.data;
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
}
```

## Best Practices

1. **Use Indexer for Historical Data** - Don't query full node for past events
2. **Paginate Large Results** - Always use `limit` and `offset`/cursor
3. **Filter at Database Level** - Use `where` clauses, not client-side filtering
4. **Minimize Nested Queries** - Avoid deep relationship traversal
5. **Cache Aggressively** - Blockchain data is immutable once finalized
6. **Monitor Query Performance** - Use explain/analyze in development
7. **Use Fragments** - Reuse query fragments for consistency
8. **Handle Reorgs** - Account for chain reorganizations in real-time data

## Common Indexer Tables

- **`account_transactions`** - All transactions for an account
- **`current_token_ownerships_v2`** - Current NFT ownership
- **`token_activities_v2`** - NFT transfer/mint/burn history
- **`current_fungible_asset_balances`** - Current FA balances
- **`fungible_asset_activities`** - FA transfer history
- **`events`** - All emitted events
- **`current_coin_balances`** - Coin balances (legacy)
- **`current_collection_datas`** - NFT collection metadata

## Reference Documentation

- **Indexer Reference**: `~/Documents/cc-skills/.claude/skills/aptos-indexer-architect/resources/indexer-reference.txt`
- **Indexer API Docs**: https://aptos.dev/build/indexer
- **GraphQL Explorers**:
  - Mainnet: https://cloud.hasura.io/public/graphiql?endpoint=https://api.mainnet.aptoslabs.com/v1/graphql
  - Testnet: https://cloud.hasura.io/public/graphiql?endpoint=https://api.testnet.aptoslabs.com/v1/graphql

## When to Use This Skill

Invoke when:
- "Query Aptos NFT ownership"
- "Build custom indexer"
- "Track token transfers"
- "Get account transaction history"
- "Index smart contract events"
- "Build analytics dashboard"
- "Monitor fungible asset activity"
- "Create real-time data processor"
- Any Aptos indexing or querying task

## Related Skills

- **aptos-ts-sdk-expert** - TypeScript SDK for querying indexer
- **aptos-move-architect** - Emit events from Move contracts
- **aptos-dapp-builder** - Use indexed data in dApps
