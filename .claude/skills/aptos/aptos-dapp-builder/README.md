# Aptos dApp Builder

Full-stack Aptos dApp development - combining Move contracts, TypeScript SDK, wallet integration, and modern React patterns.

## What This Skill Covers

- **Wallet Integration** - Petra, Pontem, wallet adapter
- **React Hooks** - useBalance, useNFTs, useTransaction
- **Transaction Flows** - Submit, wait, confirm, error handling
- **Keyless Auth** - Google/Apple OAuth integration
- **Real-Time Updates** - Polling, WebSocket, optimistic updates

## Quick Example

```tsx
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useTransaction } from "@/hooks/useTransaction";

export function MintButton() {
  const { account } = useWallet();
  const { submit, loading } = useTransaction();

  const mint = async () => {
    await submit({
      function: "0x1::my_nft::mint",
      functionArguments: ["My NFT", "Description", "https://..."]
    });
  };

  return (
    <button onClick={mint} disabled={loading || !account}>
      {loading ? "Minting..." : "Mint NFT"}
    </button>
  );
}
```

## Version

1.0.0
