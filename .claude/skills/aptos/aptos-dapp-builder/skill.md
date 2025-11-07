---
name: Aptos dApp Builder
description: Full-stack Aptos dApp development combining Move contracts, TypeScript SDK, indexer queries, wallet integration, and modern frontend frameworks. Production-ready patterns for Web3 applications.
version: 1.0.0
---

# Aptos dApp Builder

## Overview

Specialized skill for building **production-grade full-stack decentralized applications** on Aptos. Combines Move smart contracts, TypeScript SDK, GraphQL indexing, wallet integration, and modern frontend frameworks into cohesive Web3 applications.

## Core Expertise

- **Full-Stack Architecture** - Smart contracts + frontend + indexing
- **Wallet Integration** - Petra, Pontem, Martian, wallet adapters
- **State Management** - React hooks for blockchain data, caching strategies
- **Transaction Flows** - Submit, wait, confirm, error handling
- **Keyless Auth** - Google/Apple OAuth for seamless onboarding
- **Real-Time Updates** - WebSocket, polling, optimistic updates
- **Testing Strategy** - E2E tests, testnet deployment, simulation
- **UX Patterns** - Loading states, transaction toasts, gas estimation

## Tech Stack

### Smart Contracts
- **Move** - Business logic, token standards, access control

### Frontend
- **React** - Component framework
- **TypeScript** - Type safety
- **@aptos-labs/ts-sdk** - Blockchain interaction
- **@aptos-labs/wallet-adapter-react** - Wallet integration
- **SWR / React Query** - Data fetching and caching
- **Tailwind CSS** - Styling

### Backend (Optional)
- **Next.js API Routes** - Server-side operations
- **PostgreSQL** - Off-chain data storage
- **GraphQL** - Indexer queries

## Project Structure

```
my-aptos-dapp/
├── contracts/              # Move smart contracts
│   ├── Move.toml
│   ├── sources/
│   │   ├── nft_marketplace.move
│   │   └── fa_token.move
│   └── tests/
│
├── frontend/               # React application
│   ├── src/
│   │   ├── components/
│   │   │   ├── WalletConnect.tsx
│   │   │   ├── TransactionButton.tsx
│   │   │   └── NFTCard.tsx
│   │   ├── hooks/
│   │   │   ├── useWallet.ts
│   │   │   ├── useNFTs.ts
│   │   │   └── useTokenBalance.ts
│   │   ├── lib/
│   │   │   ├── aptos.ts
│   │   │   └── constants.ts
│   │   └── App.tsx
│   └── package.json
│
└── scripts/                # Deployment scripts
    └── deploy.ts
```

## Wallet Integration

### Setup Wallet Adapter

```bash
npm install @aptos-labs/wallet-adapter-react \
  @aptos-labs/wallet-adapter-ant-design \
  petra-plugin-wallet-adapter \
  @pontem/wallet-adapter-plugin
```

### App Wrapper

```tsx
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";
import { PetraWallet } from "petra-plugin-wallet-adapter";
import { PontemWallet } from "@pontem/wallet-adapter-plugin";
import { Network } from "@aptos-labs/ts-sdk";

const wallets = [new PetraWallet(), new PontemWallet()];

function App() {
  return (
    <AptosWalletAdapterProvider
      plugins={wallets}
      autoConnect={true}
      dappConfig={{ network: Network.MAINNET }}
    >
      <YourApp />
    </AptosWalletAdapterProvider>
  );
}
```

### Wallet Connection Component

```tsx
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";

export function WalletConnect() {
  const { connected, account, disconnect } = useWallet();

  if (connected && account) {
    return (
      <div>
        <p>{account.address.slice(0, 6)}...{account.address.slice(-4)}</p>
        <button onClick={disconnect}>Disconnect</button>
      </div>
    );
  }

  return <WalletSelector />;
}
```

## Custom Hooks

### useBalance Hook

```tsx
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import useSWR from "swr";
import { aptos } from "@/lib/aptos";

export function useBalance() {
  const { account } = useWallet();

  const { data, error, mutate } = useSWR(
    account ? ["balance", account.address] : null,
    async ([_, address]) => {
      const balance = await aptos.getAccountAPTAmount({
        accountAddress: address
      });
      return balance / 100_000_000; // Convert to APT
    },
    { refreshInterval: 10000 }
  );

  return {
    balance: data,
    isLoading: !error && data === undefined,
    isError: error,
    refresh: mutate
  };
}
```

### useNFTs Hook

```tsx
export function useNFTs(ownerAddress?: string) {
  const { data, error, mutate } = useSWR(
    ownerAddress ? ["nfts", ownerAddress] : null,
    async ([_, address]) => {
      return await aptos.getOwnedDigitalAssets({
        ownerAddress: address,
        options: { limit: 100 }
      });
    }
  );

  return {
    nfts: data,
    isLoading: !error && data === undefined,
    isError: error,
    refresh: mutate
  };
}
```

### useTransaction Hook

```tsx
import { useState } from "react";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { aptos } from "@/lib/aptos";
import { toast } from "react-hot-toast";

export function useTransaction() {
  const { account, signAndSubmitTransaction } = useWallet();
  const [loading, setLoading] = useState(false);

  const submit = async (payload: any) => {
    if (!account) {
      toast.error("Please connect wallet");
      return;
    }

    setLoading(true);
    try {
      // Submit transaction
      const response = await signAndSubmitTransaction({
        sender: account.address,
        data: payload
      });

      toast.loading("Transaction submitted...", { id: response.hash });

      // Wait for confirmation
      const result = await aptos.waitForTransaction({
        transactionHash: response.hash
      });

      if (result.success) {
        toast.success("Transaction confirmed!", { id: response.hash });
        return result;
      } else {
        throw new Error(result.vm_status);
      }
    } catch (error) {
      toast.error(`Transaction failed: ${error.message}`);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  return { submit, loading };
}
```

## Component Patterns

### Transaction Button

```tsx
import { useTransaction } from "@/hooks/useTransaction";

export function MintNFTButton({ collectionName, tokenName }) {
  const { submit, loading } = useTransaction();

  const handleMint = async () => {
    await submit({
      function: "0x4::aptos_token::mint",
      functionArguments: [
        collectionName,
        tokenName,
        "Description",
        "https://example.com/nft.json"
      ]
    });
  };

  return (
    <button onClick={handleMint} disabled={loading}>
      {loading ? "Minting..." : "Mint NFT"}
    </button>
  );
}
```

### NFT Gallery

```tsx
import { useNFTs } from "@/hooks/useNFTs";
import { useWallet } from "@aptos-labs/wallet-adapter-react";

export function NFTGallery() {
  const { account } = useWallet();
  const { nfts, isLoading } = useNFTs(account?.address);

  if (isLoading) return <div>Loading NFTs...</div>;
  if (!nfts || nfts.length === 0) return <div>No NFTs found</div>;

  return (
    <div className="grid grid-cols-3 gap-4">
      {nfts.map((nft) => (
        <NFTCard key={nft.token_data_id} nft={nft} />
      ))}
    </div>
  );
}
```

### Token Transfer Form

```tsx
export function TransferForm() {
  const { submit, loading } = useTransaction();
  const [recipient, setRecipient] = useState("");
  const [amount, setAmount] = useState("");

  const handleTransfer = async (e: React.FormEvent) => {
    e.preventDefault();

    await submit({
      function: "0x1::aptos_account::transfer",
      functionArguments: [recipient, parseInt(amount) * 100_000_000]
    });
  };

  return (
    <form onSubmit={handleTransfer}>
      <input
        placeholder="Recipient address"
        value={recipient}
        onChange={(e) => setRecipient(e.target.value)}
      />
      <input
        type="number"
        placeholder="Amount (APT)"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
      />
      <button type="submit" disabled={loading}>
        {loading ? "Sending..." : "Send"}
      </button>
    </form>
  );
}
```

## Common dApp Patterns

### NFT Marketplace

```tsx
// Marketplace contract interaction
export function NFTMarketplace() {
  const { submit } = useTransaction();
  const listings = useMarketplaceListings();

  const buyNFT = async (tokenId: string, price: number) => {
    await submit({
      function: `${MARKETPLACE_ADDRESS}::marketplace::buy`,
      functionArguments: [tokenId],
      typeArguments: ["0x1::aptos_coin::AptosCoin"]
    });
  };

  return (
    <div>
      {listings.map((listing) => (
        <div key={listing.token_id}>
          <h3>{listing.name}</h3>
          <p>{listing.price / 100_000_000} APT</p>
          <button onClick={() => buyNFT(listing.token_id, listing.price)}>
            Buy Now
          </button>
        </div>
      ))}
    </div>
  );
}
```

### Token Swap

```tsx
export function TokenSwap() {
  const { submit } = useTransaction();
  const [fromToken, setFromToken] = useState("");
  const [toToken, setToToken] = useState("");
  const [amount, setAmount] = useState("");

  const handleSwap = async () => {
    await submit({
      function: `${DEX_ADDRESS}::dex::swap`,
      typeArguments: [fromToken, toToken],
      functionArguments: [parseInt(amount)]
    });
  };

  return (
    <div>
      <input value={amount} onChange={(e) => setAmount(e.target.value)} />
      <select value={fromToken} onChange={(e) => setFromToken(e.target.value)}>
        {/* Token options */}
      </select>
      <select value={toToken} onChange={(e) => setToToken(e.target.value)}>
        {/* Token options */}
      </select>
      <button onClick={handleSwap}>Swap</button>
    </div>
  );
}
```

### Staking Interface

```tsx
export function StakingDashboard() {
  const { account } = useWallet();
  const { submit } = useTransaction();
  const stakedAmount = useStakedAmount(account?.address);

  const stake = async (amount: number) => {
    await submit({
      function: `${STAKING_ADDRESS}::staking::stake`,
      functionArguments: [amount * 100_000_000]
    });
  };

  const unstake = async (amount: number) => {
    await submit({
      function: `${STAKING_ADDRESS}::staking::unstake`,
      functionArguments: [amount * 100_000_000]
    });
  };

  return (
    <div>
      <h2>Staked: {stakedAmount / 100_000_000} APT</h2>
      <button onClick={() => stake(10)}>Stake 10 APT</button>
      <button onClick={() => unstake(5)}>Unstake 5 APT</button>
    </div>
  );
}
```

## Keyless Authentication Integration

```tsx
import { EphemeralKeyPair } from "@aptos-labs/ts-sdk";
import { useState } from "react";

export function KeylessLogin() {
  const [keylessAccount, setKeylessAccount] = useState(null);

  const loginWithGoogle = async () => {
    // Generate ephemeral key pair
    const ephemeralKeyPair = EphemeralKeyPair.generate();
    const nonce = ephemeralKeyPair.nonce;

    // Save to sessionStorage
    sessionStorage.setItem(
      "ephemeralKeyPair",
      JSON.stringify(Array.from(ephemeralKeyPair.bcsToBytes()))
    );

    // Redirect to Google OAuth
    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?` +
      `client_id=${process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID}&` +
      `redirect_uri=${window.location.origin}/callback&` +
      `response_type=id_token&` +
      `scope=openid email&` +
      `nonce=${nonce}`;

    window.location.href = googleAuthUrl;
  };

  return <button onClick={loginWithGoogle}>Login with Google</button>;
}

// OAuth Callback Handler
export function OAuthCallback() {
  useEffect(() => {
    const handleCallback = async () => {
      // Get JWT from URL fragment
      const hash = window.location.hash.substring(1);
      const params = new URLSearchParams(hash);
      const jwt = params.get("id_token");

      // Restore ephemeral key pair
      const stored = JSON.parse(sessionStorage.getItem("ephemeralKeyPair")!);
      const ephemeralKeyPair = EphemeralKeyPair.fromBytes(new Uint8Array(stored));

      // Derive keyless account
      const account = await aptos.deriveKeylessAccount({
        jwt,
        ephemeralKeyPair
      });

      // Use account for transactions
      setKeylessAccount(account);
    };

    handleCallback();
  }, []);

  return <div>Processing login...</div>;
}
```

## Error Handling

```tsx
export function TransactionErrorBoundary({ children }) {
  return (
    <ErrorBoundary
      fallback={(error) => (
        <div className="error">
          <h3>Transaction Failed</h3>
          <p>{getErrorMessage(error)}</p>
          <button onClick={() => window.location.reload()}>Retry</button>
        </div>
      )}
    >
      {children}
    </ErrorBoundary>
  );
}

function getErrorMessage(error: any): string {
  if (error.message.includes("INSUFFICIENT_BALANCE")) {
    return "Insufficient balance to complete transaction";
  }
  if (error.message.includes("USER_REJECTED")) {
    return "Transaction rejected by user";
  }
  return error.message || "Unknown error occurred";
}
```

## Testing Strategy

### E2E Tests with Playwright

```typescript
import { test, expect } from "@playwright/test";

test("should connect wallet and mint NFT", async ({ page }) => {
  await page.goto("http://localhost:3000");

  // Connect wallet
  await page.click('text="Connect Wallet"');
  await page.click('text="Petra"');

  // Wait for connection
  await page.waitForSelector('text="0x"');

  // Mint NFT
  await page.click('text="Mint NFT"');

  // Wait for transaction
  await page.waitForSelector('text="Transaction confirmed"');

  // Verify NFT appears
  await expect(page.locator(".nft-card")).toBeVisible();
});
```

## Best Practices

1. **Always Simulate Before Submit** - Catch errors before gas is spent
2. **Handle All Transaction States** - Pending, success, failure
3. **Cache Blockchain Data** - Use SWR/React Query for performance
4. **Show Gas Estimates** - Let users know transaction costs upfront
5. **Implement Optimistic Updates** - Update UI before confirmation
6. **Use Typed Contracts** - Generate TypeScript types from Move modules
7. **Test on Testnet First** - Deploy and test thoroughly before mainnet
8. **Monitor Transaction Status** - Poll or use websockets for real-time updates
9. **Handle Network Switches** - Detect and prompt for correct network
10. **Secure Private Keys** - Never expose keys, use wallet adapters

## Deployment Checklist

- [ ] Move contracts compiled and tested
- [ ] Contracts deployed to testnet
- [ ] Frontend tested with testnet contracts
- [ ] Wallet integration tested (Petra, Pontem)
- [ ] Transaction flows working end-to-end
- [ ] Error handling implemented
- [ ] Loading states for all async operations
- [ ] Gas estimation shown to users
- [ ] Move contracts deployed to mainnet
- [ ] Frontend environment variables updated for mainnet
- [ ] Production deployment (Vercel, Netlify, etc.)

## Example dApps

### Simple NFT Minter

```tsx
export default function NFTMinter() {
  const { account } = useWallet();
  const { submit, loading } = useTransaction();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [uri, setUri] = useState("");

  const mintNFT = async () => {
    await submit({
      function: `${CONTRACT_ADDRESS}::nft::mint`,
      functionArguments: [name, description, uri]
    });
  };

  return (
    <div>
      <h1>Mint Your NFT</h1>
      <input
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <input
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      />
      <input
        placeholder="Image URI"
        value={uri}
        onChange={(e) => setUri(e.target.value)}
      />
      <button onClick={mintNFT} disabled={loading || !account}>
        {loading ? "Minting..." : "Mint NFT"}
      </button>
    </div>
  );
}
```

## When to Use This Skill

Invoke when:
- "Build Aptos dApp"
- "Create NFT marketplace"
- "Implement wallet connection"
- "Build token swap interface"
- "Create staking dashboard"
- "Integrate keyless auth"
- "Build full-stack Web3 app"
- Any full-stack Aptos development task

## Related Skills

- **aptos-ts-sdk-expert** - Backend TypeScript integration
- **aptos-move-architect** - Smart contract development
- **aptos-indexer-architect** - Query blockchain data
- **aptos-deployment-expert** - Deploy contracts and frontend
