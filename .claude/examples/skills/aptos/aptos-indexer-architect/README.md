# Aptos Indexer Architect

Expert in querying indexed Aptos blockchain data via GraphQL API and building custom indexer processors for app-specific data extraction.

## What This Skill Covers

- **GraphQL Queries** - Account transactions, NFTs, fungible assets, events
- **Custom Processors** - Indexer SDK for app-specific data extraction
- **Performance** - Pagination, caching, query optimization
- **Analytics** - Aggregate queries, user stats, DEX analytics

## Quick Example

```graphql
query GetNFTs($owner: String!) {
  current_token_ownerships_v2(
    where: { owner_address: { _eq: $owner }, amount: { _gt: "0" } }
  ) {
    token_data_id
    amount
    current_token_data {
      token_name
      token_uri
      current_collection {
        collection_name
      }
    }
  }
}
```

## Resources

- **Indexer Docs**: `resources/indexer-reference.txt` (4,845 lines)
- **GraphQL Explorer**: https://cloud.hasura.io/public/graphiql?endpoint=https://api.mainnet.aptoslabs.com/v1/graphql

## Version

1.0.0
