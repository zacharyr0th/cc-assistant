---
name: Aptos TypeScript SDK Expert
description: Deep expertise in @aptos-labs/ts-sdk for building Aptos dApps. Covers account management, transaction building, querying, fungible assets, digital assets (NFTs), keyless auth, multisig, sponsoring transactions, and advanced patterns.
version: 1.0.0
---

# Aptos TypeScript SDK Expert

## Overview

Specialized skill for building production-grade Aptos applications using the **official TypeScript SDK** (`@aptos-labs/ts-sdk`). Provides deep expertise in:

- **Account Management** - Generate, derive, fund, and manage accounts (Ed25519, Secp256k1, MultiKey)
- **Transaction Building** - Simple transfers, entry functions, script payloads, multi-agent, sponsored transactions
- **Querying Data** - View functions, account resources, events, transactions, indexer queries
- **Fungible Assets (FA)** - Mint, transfer, burn fungible tokens using the FA standard
- **Digital Assets (NFTs)** - Create collections, mint tokens, transfer, burn using the Digital Asset standard
- **Keyless Authentication** - Google/Apple OAuth integration for seamless onboarding
- **Advanced Patterns** - Batching, simulation, BCS encoding, table items, objects
- **Testing & Local Dev** - Local node setup, transaction simulation, error handling

## Installation

```bash
npm i @aptos-labs/ts-sdk
```

**Package**: `@aptos-labs/ts-sdk`
**GitHub**: https://github.com/aptos-labs/aptos-ts-sdk
**API Docs**: https://aptos-labs.github.io/aptos-ts-sdk/@aptos-labs/ts-sdk-latest
**Examples**: https://github.com/aptos-labs/aptos-ts-sdk/tree/main/examples/typescript

## Core SDK Architecture

### `Aptos` Client

The main entry point for all SDK operations:

```typescript
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

const config = new AptosConfig({ network: Network.MAINNET });
const aptos = new Aptos(config);
```

**Available Networks**:
- `Network.MAINNET` - Production network
- `Network.TESTNET` - Public test network
- `Network.DEVNET` - Development network
- `Network.LOCAL` - Local node (http://localhost:8080)

### `Account` Types

The SDK supports multiple account types:

```typescript
import {
  Account,
  Ed25519Account,
  Secp256k1Account,
  MultiKeyAccount,
  SigningSchemeInput
} from "@aptos-labs/ts-sdk";

// Generate new accounts
const ed25519Account = Account.generate(); // Default: Legacy Ed25519
const secp256k1Account = Account.generate({
  scheme: SigningSchemeInput.Secp256k1Ecdsa
});
const singleSenderEd25519 = Account.generate({
  scheme: SigningSchemeInput.Ed25519,
  legacy: false
});

// From private key
const account = Account.fromPrivateKey({
  privateKey: new Ed25519PrivateKey(privateKeyBytes)
});

// From mnemonic
const account = Account.fromDerivationPath({
  path: "m/44'/637'/0'/0'/0'",
  mnemonic: "your twelve word mnemonic phrase here...",
  scheme: SigningSchemeInput.Ed25519
});
```

## Account Management

### Generate and Fund Accounts

```typescript
import { Aptos, AptosConfig, Network, Account } from "@aptos-labs/ts-sdk";

const aptos = new Aptos(new AptosConfig({ network: Network.DEVNET }));
const account = Account.generate();

// Fund on devnet (100 APT = 100_000_000 Octas)
await aptos.fundAccount({
  accountAddress: account.accountAddress,
  amount: 100_000_000
});

// Check balance
const balance = await aptos.getAccountAPTAmount({
  accountAddress: account.accountAddress
});
console.log(`Balance: ${balance / 100_000_000} APT`);
```

### Account Resources

```typescript
// Get all resources for an account
const resources = await aptos.getAccountResources({
  accountAddress: account.accountAddress
});

// Get specific resource
const coinResource = await aptos.getAccountResource({
  accountAddress: account.accountAddress,
  resourceType: "0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>"
});

// Get account info (sequence number, auth key)
const accountInfo = await aptos.getAccountInfo({
  accountAddress: account.accountAddress
});
```

## Transaction Building

### Simple Transfer

```typescript
import { Aptos, Account, AptosConfig, Network } from "@aptos-labs/ts-sdk";

const aptos = new Aptos(new AptosConfig({ network: Network.DEVNET }));
const sender = Account.generate();
const recipient = Account.generate();

// Build, sign, and submit transfer
const transaction = await aptos.transaction.build.simple({
  sender: sender.accountAddress,
  data: {
    function: "0x1::aptos_account::transfer",
    functionArguments: [recipient.accountAddress, 100_000_000] // 1 APT
  }
});

const committedTxn = await aptos.signAndSubmitTransaction({
  signer: sender,
  transaction
});

const executedTransaction = await aptos.waitForTransaction({
  transactionHash: committedTxn.hash
});
```

### Entry Function Calls

```typescript
// Call any entry function
const transaction = await aptos.transaction.build.simple({
  sender: sender.accountAddress,
  data: {
    function: "0x1::coin::transfer",
    typeArguments: ["0x1::aptos_coin::AptosCoin"],
    functionArguments: [recipient.accountAddress, 100_000_000]
  }
});

const pendingTxn = await aptos.signAndSubmitTransaction({
  signer: sender,
  transaction
});
```

### Multi-Agent Transactions

```typescript
import { Account } from "@aptos-labs/ts-sdk";

const alice = Account.generate();
const bob = Account.generate();

const transaction = await aptos.transaction.build.multiAgent({
  sender: alice.accountAddress,
  secondarySignerAddresses: [bob.accountAddress],
  data: {
    function: "0x1::some_module::multi_agent_function",
    functionArguments: [/* args */]
  }
});

// Both parties must sign
const aliceAuth = aptos.transaction.sign({
  signer: alice,
  transaction
});

const bobAuth = aptos.transaction.sign({
  signer: bob,
  transaction
});

// Submit with both signatures
const committedTxn = await aptos.transaction.submit.multiAgent({
  transaction,
  senderAuthenticator: aliceAuth,
  additionalSignersAuthenticators: [bobAuth]
});
```

### Sponsored Transactions (Fee Payer)

```typescript
const user = Account.generate();
const sponsor = Account.generate(); // Pays gas fees

const transaction = await aptos.transaction.build.simple({
  sender: user.accountAddress,
  data: {
    function: "0x1::aptos_account::transfer",
    functionArguments: [recipient.accountAddress, 100_000]
  },
  withFeePayer: true
});

// User signs transaction
const userAuth = aptos.transaction.sign({
  signer: user,
  transaction
});

// Sponsor signs as fee payer
const sponsorAuth = aptos.transaction.signAsFeePayer({
  signer: sponsor,
  transaction
});

// Submit with both signatures
const committedTxn = await aptos.transaction.submit.simple({
  transaction,
  senderAuthenticator: userAuth,
  feePayerAuthenticator: sponsorAuth
});
```

### Batching Transactions

```typescript
// Build multiple transactions
const transactions = await Promise.all([
  aptos.transaction.build.simple({
    sender: sender.accountAddress,
    data: {
      function: "0x1::aptos_account::transfer",
      functionArguments: [recipient1.accountAddress, 100_000]
    }
  }),
  aptos.transaction.build.simple({
    sender: sender.accountAddress,
    data: {
      function: "0x1::aptos_account::transfer",
      functionArguments: [recipient2.accountAddress, 200_000]
    }
  })
]);

// Sign and submit in batch
for (const transaction of transactions) {
  const committedTxn = await aptos.signAndSubmitTransaction({
    signer: sender,
    transaction
  });
  await aptos.waitForTransaction({ transactionHash: committedTxn.hash });
}
```

## Querying Data

### View Functions

View functions allow reading on-chain state without submitting transactions:

```typescript
// Get coin balance using view function
const [balance] = await aptos.view<[string]>({
  payload: {
    function: "0x1::coin::balance",
    typeArguments: ["0x1::aptos_coin::AptosCoin"],
    functionArguments: [account.accountAddress]
  }
});

console.log(`Balance: ${balance}`);

// Custom view function
const [result] = await aptos.view<[boolean]>({
  payload: {
    function: "0xYourAddress::your_module::is_eligible",
    functionArguments: [account.accountAddress]
  }
});
```

### Events

```typescript
// Get events by event type
const events = await aptos.getEvents({
  options: {
    where: {
      account_address: { _eq: account.accountAddress.toString() },
      type: { _eq: "0x1::coin::DepositEvent" }
    },
    orderBy: [{ transaction_version: "desc" }],
    limit: 10
  }
});

// Get events from event handle
const transferEvents = await aptos.getAccountEventsByEventType({
  accountAddress: account.accountAddress,
  eventType: "0x1::coin::CoinDeposit"
});
```

### Transactions

```typescript
// Get transaction by hash
const txn = await aptos.getTransactionByHash({
  transactionHash: "0x123..."
});

// Get account transactions
const accountTxns = await aptos.getAccountTransactions({
  accountAddress: account.accountAddress,
  options: {
    limit: 25,
    offset: 0
  }
});

// Get transaction by version
const txnByVersion = await aptos.getTransactionByVersion({
  ledgerVersion: 12345678
});
```

### Table Items

```typescript
// Read from a table
const tableItem = await aptos.getTableItem<string>({
  handle: "0x1::account::Account",
  data: {
    key_type: "address",
    value_type: "0x1::account::Account",
    key: account.accountAddress.toString()
  }
});
```

## Fungible Assets (FA)

### Deploy FA Contract

```typescript
// Example FACoin.move module
const packageMetadata = await aptos.publishPackage({
  account: deployer,
  packagePath: "./move/facoin",
  options: {
    moduleAddress: deployer.accountAddress
  }
});
```

### Mint Fungible Assets

```typescript
// Call mint function (from your FA module)
const mintTxn = await aptos.transaction.build.simple({
  sender: deployer.accountAddress,
  data: {
    function: `${deployer.accountAddress}::fa_coin::mint`,
    functionArguments: [recipient.accountAddress, 1000000]
  }
});

const committedTxn = await aptos.signAndSubmitTransaction({
  signer: deployer,
  transaction: mintTxn
});
```

### Transfer Fungible Assets

```typescript
// Primary store transfer (most common)
const transferTxn = await aptos.transaction.build.simple({
  sender: sender.accountAddress,
  data: {
    function: "0x1::primary_fungible_store::transfer",
    typeArguments: [`${deployer.accountAddress}::fa_coin::FACoin`],
    functionArguments: [recipient.accountAddress, 100]
  }
});

await aptos.signAndSubmitTransaction({
  signer: sender,
  transaction: transferTxn
});
```

### Query FA Balance

```typescript
// Get FA balance
const balance = await aptos.view<[string]>({
  payload: {
    function: "0x1::primary_fungible_store::balance",
    typeArguments: [`${deployer.accountAddress}::fa_coin::FACoin`],
    functionArguments: [account.accountAddress]
  }
});

console.log(`FA Balance: ${balance[0]}`);
```

## Digital Assets (NFTs)

### Create Collection

```typescript
import { Account } from "@aptos-labs/ts-sdk";

const creator = Account.generate();

const createCollectionTxn = await aptos.transaction.build.simple({
  sender: creator.accountAddress,
  data: {
    function: "0x4::aptos_token::create_collection",
    functionArguments: [
      "My NFT Collection", // collection name
      "A collection of unique NFTs", // description
      "https://example.com/collection.json", // URI
      1000, // max supply (0 for unlimited)
      [false, false, false] // [mutable_description, mutable_uri, mutable_token_description]
    ]
  }
});

await aptos.signAndSubmitTransaction({
  signer: creator,
  transaction: createCollectionTxn
});
```

### Mint NFT

```typescript
const mintTokenTxn = await aptos.transaction.build.simple({
  sender: creator.accountAddress,
  data: {
    function: "0x4::aptos_token::mint",
    functionArguments: [
      "My NFT Collection", // collection name
      "NFT #1", // token name
      "The first NFT", // description
      "https://example.com/nft1.json", // URI
      [], // property keys
      [], // property types
      [] // property values
    ]
  }
});

await aptos.signAndSubmitTransaction({
  signer: creator,
  transaction: mintTokenTxn
});
```

### Transfer NFT

```typescript
// Get the token data ID first
const tokenDataId = {
  creator: creator.accountAddress.toString(),
  collection: "My NFT Collection",
  name: "NFT #1"
};

const transferNFTTxn = await aptos.transaction.build.simple({
  sender: owner.accountAddress,
  data: {
    function: "0x3::token::direct_transfer_script",
    functionArguments: [
      creator.accountAddress,
      "My NFT Collection",
      "NFT #1",
      0, // property version
      recipient.accountAddress,
      1 // amount (always 1 for NFTs)
    ]
  }
});

await aptos.signAndSubmitTransaction({
  signer: owner,
  transaction: transferNFTTxn
});
```

### Query NFTs

```typescript
// Get tokens owned by account
const tokens = await aptos.getOwnedDigitalAssets({
  ownerAddress: account.accountAddress,
  options: {
    limit: 10,
    offset: 0
  }
});

// Get collection data
const collection = await aptos.getCollectionData({
  creatorAddress: creator.accountAddress,
  collectionName: "My NFT Collection"
});
```

## Keyless Authentication

### Setup Keyless with Google OAuth

```typescript
import {
  EphemeralKeyPair,
  Aptos,
  AptosConfig,
  Network
} from "@aptos-labs/ts-sdk";

const aptos = new Aptos(new AptosConfig({ network: Network.DEVNET }));

// 1. Generate ephemeral key pair
const ephemeralKeyPair = EphemeralKeyPair.generate();

// 2. Get nonce for Google OAuth
const nonce = ephemeralKeyPair.nonce;

// 3. Redirect user to Google OAuth with nonce
const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?` +
  `client_id=${GOOGLE_CLIENT_ID}&` +
  `redirect_uri=${REDIRECT_URI}&` +
  `response_type=id_token&` +
  `scope=openid email&` +
  `nonce=${nonce}`;

// 4. After OAuth callback, get JWT token
const jwt = /* JWT from Google OAuth response */;

// 5. Create keyless account
const keylessAccount = await aptos.deriveKeylessAccount({
  jwt,
  ephemeralKeyPair
});

// 6. Fund and use the account
await aptos.fundAccount({
  accountAddress: keylessAccount.accountAddress,
  amount: 100_000_000
});

// 7. Sign transactions normally
const transaction = await aptos.transaction.build.simple({
  sender: keylessAccount.accountAddress,
  data: {
    function: "0x1::aptos_account::transfer",
    functionArguments: [recipient.accountAddress, 100_000]
  }
});

await aptos.signAndSubmitTransaction({
  signer: keylessAccount,
  transaction
});
```

### Persist Ephemeral Keys

```typescript
// Save ephemeral key pair to localStorage
const serialized = ephemeralKeyPair.bcsToBytes();
localStorage.setItem("ephemeralKeyPair", JSON.stringify(Array.from(serialized)));

// Restore from localStorage
const stored = JSON.parse(localStorage.getItem("ephemeralKeyPair")!);
const restoredKeyPair = EphemeralKeyPair.fromBytes(new Uint8Array(stored));
```

## Advanced Patterns

### Transaction Simulation

```typescript
// Simulate before submitting
const transaction = await aptos.transaction.build.simple({
  sender: sender.accountAddress,
  data: {
    function: "0x1::aptos_account::transfer",
    functionArguments: [recipient.accountAddress, 100_000_000]
  }
});

// Simulate transaction
const [simulationResult] = await aptos.transaction.simulate.simple({
  signerPublicKey: sender.publicKey,
  transaction
});

if (simulationResult.success) {
  console.log(`Gas used: ${simulationResult.gas_used}`);
  console.log(`VM status: ${simulationResult.vm_status}`);

  // Submit if simulation succeeded
  const committedTxn = await aptos.signAndSubmitTransaction({
    signer: sender,
    transaction
  });
} else {
  console.error(`Simulation failed: ${simulationResult.vm_status}`);
}
```

### BCS Encoding

```typescript
import { BCS } from "@aptos-labs/ts-sdk";

// Serialize data
const serializer = new BCS.Serializer();
serializer.serializeU64(12345n);
serializer.serializeStr("hello");
const bytes = serializer.toUint8Array();

// Deserialize data
const deserializer = new BCS.Deserializer(bytes);
const num = deserializer.deserializeU64();
const str = deserializer.deserializeStr();
```

### Custom Gas Settings

```typescript
const transaction = await aptos.transaction.build.simple({
  sender: sender.accountAddress,
  data: {
    function: "0x1::aptos_account::transfer",
    functionArguments: [recipient.accountAddress, 100_000]
  },
  options: {
    maxGasAmount: 2000, // Maximum gas units
    gasUnitPrice: 100,  // Gas price per unit (in Octas)
    expireTimestamp: Math.floor(Date.now() / 1000) + 600 // 10 min expiry
  }
});
```

### MultiKey Accounts

```typescript
import {
  MultiKeyAccount,
  Ed25519PrivateKey,
  Secp256k1PrivateKey
} from "@aptos-labs/ts-sdk";

// Create multi-key account (2-of-3)
const key1 = new Ed25519PrivateKey(/* bytes */);
const key2 = new Ed25519PrivateKey(/* bytes */);
const key3 = new Secp256k1PrivateKey(/* bytes */);

const multiKeyAccount = new MultiKeyAccount({
  publicKeys: [
    key1.publicKey(),
    key2.publicKey(),
    key3.publicKey()
  ],
  signaturesRequired: 2
});

// Sign with subset of keys
const transaction = await aptos.transaction.build.simple({
  sender: multiKeyAccount.accountAddress,
  data: { /* ... */ }
});

// Sign with 2 out of 3 keys
const auth = aptos.transaction.sign({
  signer: multiKeyAccount,
  transaction
});
```

## Error Handling

### Common Patterns

```typescript
import {
  AptosApiError,
  FailedTransactionError
} from "@aptos-labs/ts-sdk";

try {
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

  const result = await aptos.waitForTransaction({
    transactionHash: committedTxn.hash
  });

  if (!result.success) {
    throw new Error(`Transaction failed: ${result.vm_status}`);
  }

} catch (error) {
  if (error instanceof AptosApiError) {
    console.error(`API Error: ${error.message}`);
    console.error(`Status: ${error.status}`);
  } else if (error instanceof FailedTransactionError) {
    console.error(`Transaction failed: ${error.message}`);
    console.error(`VM Status: ${error.transaction.vm_status}`);
  } else {
    console.error(`Unknown error: ${error}`);
  }
}
```

### Retry Logic

```typescript
async function submitWithRetry(
  aptos: Aptos,
  signer: Account,
  transaction: any,
  maxRetries = 3
) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const committedTxn = await aptos.signAndSubmitTransaction({
        signer,
        transaction
      });

      return await aptos.waitForTransaction({
        transactionHash: committedTxn.hash
      });
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      console.log(`Retry ${i + 1}/${maxRetries}`);
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
}
```

## Local Development

### Setup Local Node

```bash
# Using Docker
docker run -p 8080:8080 aptoslabs/tools:latest aptos node run-local-testnet --with-faucet
```

### Connect to Local Node

```typescript
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";

const config = new AptosConfig({
  network: Network.LOCAL,
  fullnode: "http://localhost:8080/v1",
  faucet: "http://localhost:8080/v1"
});

const aptos = new Aptos(config);

// Test connection
const ledgerInfo = await aptos.getLedgerInfo();
console.log(`Chain ID: ${ledgerInfo.chain_id}`);
```

## Testing Patterns

### Unit Tests with Jest

```typescript
import { Aptos, AptosConfig, Network, Account } from "@aptos-labs/ts-sdk";

describe("Aptos Transfer", () => {
  let aptos: Aptos;
  let sender: Account;
  let recipient: Account;

  beforeAll(async () => {
    aptos = new Aptos(new AptosConfig({ network: Network.DEVNET }));
    sender = Account.generate();
    recipient = Account.generate();

    await aptos.fundAccount({
      accountAddress: sender.accountAddress,
      amount: 100_000_000
    });
  });

  test("should transfer APT", async () => {
    const initialBalance = await aptos.getAccountAPTAmount({
      accountAddress: recipient.accountAddress
    });

    const transaction = await aptos.transaction.build.simple({
      sender: sender.accountAddress,
      data: {
        function: "0x1::aptos_account::transfer",
        functionArguments: [recipient.accountAddress, 1_000_000]
      }
    });

    const committedTxn = await aptos.signAndSubmitTransaction({
      signer: sender,
      transaction
    });

    await aptos.waitForTransaction({
      transactionHash: committedTxn.hash
    });

    const finalBalance = await aptos.getAccountAPTAmount({
      accountAddress: recipient.accountAddress
    });

    expect(finalBalance).toBe(initialBalance + 1_000_000);
  });
});
```

## Best Practices

### 1. Network Configuration

```typescript
// Use environment variables for network config
const networkConfig = {
  network: process.env.APTOS_NETWORK as Network || Network.DEVNET,
  fullnode: process.env.APTOS_NODE_URL,
  indexer: process.env.APTOS_INDEXER_URL,
  faucet: process.env.APTOS_FAUCET_URL
};

const aptos = new Aptos(new AptosConfig(networkConfig));
```

### 2. Account Security

```typescript
// NEVER hardcode private keys
// Use environment variables or secure key management
const privateKeyHex = process.env.PRIVATE_KEY!;
const privateKey = new Ed25519PrivateKey(privateKeyHex);
const account = Account.fromPrivateKey({ privateKey });

// For browser apps, use keyless auth instead of storing keys
```

### 3. Transaction Validation

```typescript
// Always simulate critical transactions
const [simulation] = await aptos.transaction.simulate.simple({
  signerPublicKey: sender.publicKey,
  transaction
});

if (!simulation.success) {
  throw new Error(`Simulation failed: ${simulation.vm_status}`);
}

// Check gas estimate
if (Number(simulation.gas_used) > MAX_GAS_THRESHOLD) {
  console.warn(`High gas usage: ${simulation.gas_used}`);
}
```

### 4. Error Recovery

```typescript
// Implement exponential backoff
async function waitForTransactionWithBackoff(
  aptos: Aptos,
  hash: string,
  maxWaitTime = 30000
) {
  const startTime = Date.now();
  let retryDelay = 1000;

  while (Date.now() - startTime < maxWaitTime) {
    try {
      return await aptos.waitForTransaction({
        transactionHash: hash,
        options: { timeoutSecs: 5 }
      });
    } catch (error) {
      await new Promise(resolve => setTimeout(resolve, retryDelay));
      retryDelay = Math.min(retryDelay * 2, 5000);
    }
  }

  throw new Error("Transaction timeout");
}
```

### 5. Type Safety

```typescript
// Use generics for type-safe view function calls
interface UserProfile {
  name: string;
  age: number;
  score: bigint;
}

const [profile] = await aptos.view<[UserProfile]>({
  payload: {
    function: "0xYourAddress::profile::get_profile",
    functionArguments: [account.accountAddress]
  }
});

// TypeScript will enforce correct types
console.log(profile.name); // ✅ Type-safe
```

## Common Patterns

### Pattern: Polling for Events

```typescript
async function pollForEvent(
  aptos: Aptos,
  accountAddress: string,
  eventType: string,
  matchFn: (event: any) => boolean,
  maxAttempts = 10
) {
  for (let i = 0; i < maxAttempts; i++) {
    const events = await aptos.getAccountEventsByEventType({
      accountAddress,
      eventType,
      minimumLedgerVersion: 0n
    });

    const match = events.find(matchFn);
    if (match) return match;

    await new Promise(resolve => setTimeout(resolve, 2000));
  }

  throw new Error("Event not found");
}
```

### Pattern: Batch Token Transfers

```typescript
async function batchTransfer(
  aptos: Aptos,
  sender: Account,
  recipients: { address: string; amount: number }[]
) {
  const transactions = await Promise.all(
    recipients.map(({ address, amount }) =>
      aptos.transaction.build.simple({
        sender: sender.accountAddress,
        data: {
          function: "0x1::aptos_account::transfer",
          functionArguments: [address, amount]
        }
      })
    )
  );

  const results = [];
  for (const transaction of transactions) {
    const committedTxn = await aptos.signAndSubmitTransaction({
      signer: sender,
      transaction
    });
    results.push(committedTxn.hash);
  }

  return results;
}
```

### Pattern: Resource Watcher

```typescript
class ResourceWatcher<T> {
  constructor(
    private aptos: Aptos,
    private accountAddress: string,
    private resourceType: string,
    private pollInterval = 5000
  ) {}

  async watch(callback: (resource: T) => void) {
    while (true) {
      try {
        const resource = await this.aptos.getAccountResource<T>({
          accountAddress: this.accountAddress,
          resourceType: this.resourceType
        });
        callback(resource);
      } catch (error) {
        console.error("Resource watch error:", error);
      }
      await new Promise(resolve => setTimeout(resolve, this.pollInterval));
    }
  }
}

// Usage
const watcher = new ResourceWatcher(
  aptos,
  account.accountAddress,
  "0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>"
);

watcher.watch((coinStore) => {
  console.log("Balance updated:", coinStore.coin.value);
});
```

## Reference Documentation

All TypeScript SDK documentation is available in:
- **Full Reference**: `~/Documents/cc-skills/.claude/skills/aptos-ts-sdk-expert/resources/ts-sdk-reference.txt`
- **Official API Docs**: https://aptos-labs.github.io/aptos-ts-sdk/@aptos-labs/ts-sdk-latest
- **GitHub Examples**: https://github.com/aptos-labs/aptos-ts-sdk/tree/main/examples
- **E2E Tests**: https://github.com/aptos-labs/aptos-ts-sdk/tree/main/tests/e2e

## When to Use This Skill

Invoke when:
- "Build an Aptos dApp"
- "Integrate TypeScript SDK"
- "Create Aptos NFT collection"
- "Implement keyless authentication"
- "Transfer fungible assets"
- "Query Aptos blockchain"
- "Setup multi-agent transactions"
- "Sponsor user transactions"
- "Deploy Move contract with TS SDK"
- Any Aptos TypeScript integration task

## Related Skills

- **aptos-move-architect** - Move smart contract development
- **aptos-indexer-architect** - GraphQL indexing and custom processors
- **aptos-dapp-builder** - Full-stack dApp patterns
- **aptos-deployment-expert** - Node and network deployment
