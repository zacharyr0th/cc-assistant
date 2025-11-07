# Aptos TypeScript SDK Expert

Deep expertise in building production-grade Aptos blockchain applications using the official `@aptos-labs/ts-sdk`.

## What This Skill Covers

### Core Functionality
- **Account Management** - Generate, derive, fund, and manage Ed25519/Secp256k1/MultiKey accounts
- **Transaction Building** - Simple transfers, entry functions, multi-agent, sponsored transactions
- **Data Querying** - View functions, resources, events, transactions, table items

### Token Standards
- **Fungible Assets (FA)** - Deploy, mint, transfer, burn FA tokens
- **Digital Assets (NFTs)** - Create collections, mint/transfer NFTs, query metadata

### Advanced Features
- **Keyless Authentication** - Google/Apple OAuth integration for seamless Web2-style onboarding
- **Multi-Signature** - MultiKey accounts with threshold signing
- **Sponsored Transactions** - Gas-free UX with fee payer pattern
- **Transaction Batching** - Efficient multi-transaction submission

### Developer Tools
- **Local Development** - Local node setup, testing patterns
- **Transaction Simulation** - Pre-flight checks before submission
- **BCS Encoding** - Low-level serialization for custom types
- **Error Handling** - Retry logic, timeout management

## Installation

```bash
npm i @aptos-labs/ts-sdk
```

## Quick Examples

### Transfer APT

```typescript
import { Aptos, AptosConfig, Network, Account } from "@aptos-labs/ts-sdk";

const aptos = new Aptos(new AptosConfig({ network: Network.DEVNET }));
const sender = Account.generate();

const transaction = await aptos.transaction.build.simple({
  sender: sender.accountAddress,
  data: {
    function: "0x1::aptos_account::transfer",
    functionArguments: [recipient.accountAddress, 100_000_000]
  }
});

const committedTxn = await aptos.signAndSubmitTransaction({
  signer: sender,
  transaction
});
```

### Call View Function

```typescript
const [balance] = await aptos.view<[string]>({
  payload: {
    function: "0x1::coin::balance",
    typeArguments: ["0x1::aptos_coin::AptosCoin"],
    functionArguments: [account.accountAddress]
  }
});
```

### Mint NFT

```typescript
const mintTxn = await aptos.transaction.build.simple({
  sender: creator.accountAddress,
  data: {
    function: "0x4::aptos_token::mint",
    functionArguments: [
      "My Collection",
      "Token #1",
      "Description",
      "https://example.com/token.json"
    ]
  }
});
```

## Key Patterns

### Transaction Simulation

Always simulate critical transactions before submitting:

```typescript
const [simulation] = await aptos.transaction.simulate.simple({
  signerPublicKey: sender.publicKey,
  transaction
});

if (simulation.success) {
  console.log(`Estimated gas: ${simulation.gas_used}`);
  // Submit transaction
}
```

### Sponsored Transactions

Let sponsors pay gas fees for users:

```typescript
const transaction = await aptos.transaction.build.simple({
  sender: user.accountAddress,
  data: { /* ... */ },
  withFeePayer: true
});

const userAuth = aptos.transaction.sign({ signer: user, transaction });
const sponsorAuth = aptos.transaction.signAsFeePayer({ signer: sponsor, transaction });

await aptos.transaction.submit.simple({
  transaction,
  senderAuthenticator: userAuth,
  feePayerAuthenticator: sponsorAuth
});
```

### Keyless Authentication

Enable Web2-style OAuth login:

```typescript
import { EphemeralKeyPair } from "@aptos-labs/ts-sdk";

const ephemeralKeyPair = EphemeralKeyPair.generate();
const nonce = ephemeralKeyPair.nonce;

// Redirect to Google OAuth with nonce...
// After callback, get JWT and create keyless account:

const keylessAccount = await aptos.deriveKeylessAccount({
  jwt,
  ephemeralKeyPair
});
```

## When to Use

Invoke this skill when:
- Building Aptos dApps with TypeScript/JavaScript
- Integrating wallet functionality
- Creating NFT marketplaces or FA token platforms
- Implementing keyless authentication
- Querying Aptos blockchain data
- Testing Move contracts with the SDK
- Setting up sponsored transaction flows

## Resources

- **Skill Reference**: See `skill.md` for comprehensive patterns and examples
- **SDK Documentation**: `resources/ts-sdk-reference.txt` (2,960 lines)
- **Official API Docs**: https://aptos-labs.github.io/aptos-ts-sdk/@aptos-labs/ts-sdk-latest
- **GitHub Examples**: https://github.com/aptos-labs/aptos-ts-sdk/tree/main/examples

## Related Skills

- **aptos-move-architect** - Smart contract development in Move
- **aptos-indexer-architect** - Custom indexing and GraphQL queries
- **aptos-dapp-builder** - Full-stack dApp architecture
- **aptos-deployment-expert** - Node deployment and network configuration

## Version

1.0.0 - Comprehensive TypeScript SDK expertise based on latest Aptos documentation
