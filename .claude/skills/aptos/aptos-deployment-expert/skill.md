---
name: Aptos Deployment Expert
description: Expert in deploying Move contracts, running Aptos nodes, validator setup, network configuration, monitoring, and production operations.
version: 1.0.0
---

# Aptos Deployment Expert

## Overview

Specialized skill for **deploying and operating** Aptos infrastructure - from publishing Move packages to running full nodes and validators. Covers production deployment, monitoring, upgrades, and operational best practices.

## Core Expertise

- **Move Package Deployment** - Compile, publish, upgrade smart contracts
- **Node Operations** - Run fullnodes, validator nodes, VFNs
- **Network Configuration** - Mainnet, testnet, devnet, local networks
- **Monitoring** - Metrics, logging, alerting, health checks
- **Security** - Key management, firewalls, DDoS protection
- **Upgrades** - Contract upgrades, node upgrades, migrations
- **Performance** - Tuning, optimization, scaling

## Move Package Deployment

### Initialize Profile

```bash
# Initialize Aptos CLI profile
aptos init --profile mainnet

# This creates ~/.aptos/config.yaml with:
# - Private key
# - Public key
# - Account address
# - Network configuration
```

### Compile Module

```bash
# Navigate to Move project
cd my-aptos-project

# Compile with named addresses
aptos move compile \
  --named-addresses my_addr=0x123abc... \
  --save-metadata

# Output: build/ directory with compiled bytecode
```

### Test Before Deploy

```bash
# Run unit tests
aptos move test

# Run with coverage
aptos move test --coverage

# View coverage report
aptos move coverage source --module my_module
```

### Publish to Testnet

```bash
# Publish package
aptos move publish \
  --profile testnet \
  --named-addresses my_addr=0x123abc... \
  --assume-yes

# Output:
# - Transaction hash
# - Gas used
# - Success/failure status
```

### Publish to Mainnet

```bash
# Final checks before mainnet
aptos move compile --named-addresses my_addr=0x123abc...
aptos move test
aptos move prove  # Optional: formal verification

# Publish to mainnet
aptos move publish \
  --profile mainnet \
  --named-addresses my_addr=0x123abc... \
  --max-gas 20000 \
  --gas-unit-price 100

# Verify deployment
aptos account list --profile mainnet
```

### Upgrade Existing Package

```move
// In your Move module, add upgrade capability
module my_addr::my_module {
    use aptos_framework::code;

    struct UpgradeCap has key {}

    public entry fun upgrade(
        admin: &signer,
        metadata: vector<u8>,
        code: vector<vector<u8>>
    ) acquires UpgradeCap {
        // Verify admin has capability
        assert!(exists<UpgradeCap>(signer::address_of(admin)), 1);

        // Upgrade package
        code::publish_package_txn(admin, metadata, code);
    }
}
```

```bash
# Build upgrade package
aptos move build-publish-payload \
  --named-addresses my_addr=0x123abc... \
  --json-output-file upgrade_payload.json

# Execute upgrade
aptos move run \
  --function-id 0x123abc::my_module::upgrade \
  --args-json upgrade_payload.json \
  --profile mainnet
```

## Running Aptos Nodes

### Docker Fullnode Setup

```yaml
# docker-compose.yml
version: "3.8"

services:
  fullnode:
    image: aptoslabs/validator:mainnet
    ports:
      - "8080:8080"  # REST API
      - "6180:6180"  # Metrics
    volumes:
      - ./data:/opt/aptos/data
      - ./config:/opt/aptos/etc
    command: aptos-node -f /opt/aptos/etc/fullnode.yaml
    restart: always
```

```yaml
# config/fullnode.yaml
base:
  role: "full_node"
  data_dir: "/opt/aptos/data"
  waypoint:
    from_config: "0:47b9936f....."  # Get from aptos.dev

execution:
  genesis_file_location: "/opt/aptos/etc/genesis.blob"

full_node_networks:
  - network_id: "public"
    listen_address: "/ip4/0.0.0.0/tcp/6182"
    seeds:
      fullnode-mainnet.aptoslabs.com:
        addresses:
          - "/dns4/fullnode-mainnet.aptoslabs.com/tcp/6182/noise-ik/..."
        role: "Upstream"

api:
  enabled: true
  address: "0.0.0.0:8080"
```

```bash
# Start fullnode
docker-compose up -d

# Check logs
docker-compose logs -f fullnode

# Verify sync
curl http://localhost:8080/v1
```

### Validator Node Setup

```bash
# Initialize validator
aptos genesis generate-keys \
  --output-dir validator-keys \
  --pool-address-file pool-address.txt

# Configure validator
aptos genesis set-validator-configuration \
  --owner-public-identity-file validator-keys/public-keys.yaml \
  --validator-host "validator.example.com:6180" \
  --stake-amount 1000000

# Start validator
docker run -d \
  --name aptos-validator \
  -p 6180:6180 \
  -p 6181:6181 \
  -p 8080:8080 \
  -v $(pwd)/config:/opt/aptos/etc \
  -v $(pwd)/data:/opt/aptos/data \
  -v $(pwd)/validator-keys:/opt/aptos/keys \
  aptoslabs/validator:mainnet \
  aptos-node -f /opt/aptos/etc/validator.yaml
```

### Local Testnet

```bash
# Run local network with faucet
aptos node run-local-testnet \
  --with-faucet \
  --force-restart

# Endpoints:
# - Node: http://127.0.0.1:8080
# - Faucet: http://127.0.0.1:8081
```

## Network Configuration

### Network Endpoints

```typescript
// Mainnet
export const MAINNET_CONFIG = {
  fullnode: "https://fullnode.mainnet.aptoslabs.com/v1",
  indexer: "https://api.mainnet.aptoslabs.com/v1/graphql",
  faucet: undefined, // No faucet on mainnet
  chainId: 1
};

// Testnet
export const TESTNET_CONFIG = {
  fullnode: "https://fullnode.testnet.aptoslabs.com/v1",
  indexer: "https://api.testnet.aptoslabs.com/v1/graphql",
  faucet: "https://faucet.testnet.aptoslabs.com",
  chainId: 2
};

// Devnet
export const DEVNET_CONFIG = {
  fullnode: "https://fullnode.devnet.aptoslabs.com/v1",
  indexer: "https://api.devnet.aptoslabs.com/v1/graphql",
  faucet: "https://faucet.devnet.aptoslabs.com",
  chainId: 34
};
```

### Environment Variables

```bash
# .env.production
NEXT_PUBLIC_APTOS_NETWORK=mainnet
NEXT_PUBLIC_APTOS_NODE_URL=https://fullnode.mainnet.aptoslabs.com/v1
NEXT_PUBLIC_APTOS_INDEXER_URL=https://api.mainnet.aptoslabs.com/v1/graphql

# Contract addresses
NEXT_PUBLIC_NFT_CONTRACT=0x123abc...
NEXT_PUBLIC_TOKEN_CONTRACT=0x456def...

# .env.development
NEXT_PUBLIC_APTOS_NETWORK=devnet
NEXT_PUBLIC_APTOS_NODE_URL=https://fullnode.devnet.aptoslabs.com/v1
NEXT_PUBLIC_APTOS_INDEXER_URL=https://api.devnet.aptoslabs.com/v1/graphql
NEXT_PUBLIC_APTOS_FAUCET_URL=https://faucet.devnet.aptoslabs.com
```

## Monitoring

### Prometheus Metrics

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'aptos-node'
    static_configs:
      - targets: ['localhost:9101']  # Node metrics endpoint
```

### Key Metrics to Monitor

```promql
# Node sync status
aptos_state_sync_version{type="synced"}

# Transaction throughput
rate(aptos_processed_txns_count[5m])

# API request rate
rate(aptos_api_requests_total[5m])

# Consensus participation (validators)
aptos_consensus_proposals_count

# Storage usage
aptos_storage_size_bytes
```

### Grafana Dashboard

```json
{
  "dashboard": {
    "title": "Aptos Node Monitoring",
    "panels": [
      {
        "title": "Sync Status",
        "targets": [
          {
            "expr": "aptos_state_sync_version{type=\"synced\"}"
          }
        ]
      },
      {
        "title": "TPS",
        "targets": [
          {
            "expr": "rate(aptos_processed_txns_count[1m])"
          }
        ]
      }
    ]
  }
}
```

### Health Checks

```bash
# Check node health
curl http://localhost:8080/v1

# Check sync status
curl http://localhost:8080/v1 | jq '.ledger_version'

# Check metrics
curl http://localhost:9101/metrics | grep aptos_state_sync_version
```

## Security

### Key Management

```bash
# NEVER commit private keys to git
# Store in secure locations:

# 1. Environment variables
export APTOS_PRIVATE_KEY="0x..."

# 2. Encrypted key files
aptos key generate \
  --output-file encrypted-key.json \
  --key-type ed25519 \
  --password

# 3. Hardware wallet (Ledger)
aptos init --profile mainnet --ledger

# 4. Cloud KMS (AWS, GCP, Azure)
# Use cloud provider's key management service
```

### Firewall Rules

```bash
# UFW firewall rules for validator
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 6180/tcp    # Validator network
sudo ufw allow 6181/tcp    # VFN network
sudo ufw deny 8080/tcp     # API (internal only)
sudo ufw enable
```

### Node Security Hardening

```yaml
# validator.yaml
api:
  enabled: false  # Disable public API on validators

storage:
  backup_service_address: "backup.example.com:6186"
  enable_state_store: true

state_sync:
  state_sync_driver:
    enable_auto_bootstrapping: true
```

## Production Deployment Checklist

### Smart Contracts

- [ ] Code audited by security firm
- [ ] Comprehensive test coverage (>80%)
- [ ] Move Prover specifications written
- [ ] Deployed to devnet and tested
- [ ] Deployed to testnet and tested
- [ ] Gas optimization reviewed
- [ ] Upgrade mechanism implemented
- [ ] Access control verified
- [ ] Event emission for all state changes
- [ ] Documentation complete

### Frontend

- [ ] Wallet integration tested (Petra, Pontem)
- [ ] Transaction error handling implemented
- [ ] Loading states for all async operations
- [ ] Network switching handled
- [ ] Gas estimation shown to users
- [ ] Optimistic updates implemented
- [ ] E2E tests passing
- [ ] Responsive design tested
- [ ] SEO optimization
- [ ] Analytics tracking configured

### Infrastructure

- [ ] Domain configured with SSL
- [ ] CDN setup for static assets
- [ ] Database backups automated
- [ ] Monitoring and alerting configured
- [ ] Log aggregation setup
- [ ] Rate limiting implemented
- [ ] DDoS protection enabled
- [ ] Disaster recovery plan documented

## CI/CD Pipeline

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy to Mainnet

on:
  push:
    branches: [main]

jobs:
  test-contracts:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Aptos CLI
        run: curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
      - name: Compile contracts
        run: |
          cd contracts
          aptos move compile --named-addresses my_addr=${{ secrets.CONTRACT_ADDRESS }}
      - name: Run tests
        run: |
          cd contracts
          aptos move test

  deploy-contracts:
    needs: test-contracts
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to mainnet
        env:
          APTOS_PRIVATE_KEY: ${{ secrets.APTOS_PRIVATE_KEY }}
        run: |
          cd contracts
          aptos move publish \
            --named-addresses my_addr=${{ secrets.CONTRACT_ADDRESS }} \
            --private-key $APTOS_PRIVATE_KEY \
            --assume-yes

  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - name: Install dependencies
        run: npm ci
      - name: Build
        run: npm run build
        env:
          NEXT_PUBLIC_APTOS_NETWORK: mainnet
          NEXT_PUBLIC_NFT_CONTRACT: ${{ secrets.NFT_CONTRACT }}
      - name: Deploy to Vercel
        run: vercel deploy --prod
        env:
          VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN }}
```

## Troubleshooting

### Contract Deployment Issues

```bash
# Issue: Insufficient balance
# Solution: Fund account first
aptos account fund-with-faucet \
  --account 0x123... \
  --amount 100000000 \
  --profile devnet

# Issue: Address already in use
# Solution: Use different named address or upgrade existing

# Issue: Dependency resolution failed
# Solution: Update Move.toml dependencies to matching versions
```

### Node Sync Issues

```bash
# Check if node is syncing
curl http://localhost:8080/v1 | jq '.ledger_version'

# Compare with network
curl https://fullnode.mainnet.aptoslabs.com/v1 | jq '.ledger_version'

# If behind, check:
# 1. Network connectivity
# 2. Disk space (df -h)
# 3. Memory usage (free -m)
# 4. Logs for errors (docker logs aptos-node)

# Force resync from snapshot
rm -rf data/*
# Restart node with fresh data directory
```

## Performance Tuning

### Node Configuration

```yaml
# Optimize for throughput
storage:
  rocksdb_configs:
    max_open_files: 10000
    max_total_wal_size: 1073741824  # 1GB

state_sync:
  state_sync_driver:
    max_concurrent_downloads: 100
    max_pending_data: 256

mempool:
  capacity: 10000
  capacity_per_user: 100
```

### Frontend Optimization

```typescript
// 1. Cache blockchain data aggressively
const { data } = useSWR(
  ["balance", address],
  fetcher,
  {
    revalidateOnFocus: false,
    revalidateOnReconnect: false,
    refreshInterval: 30000  // 30s
  }
);

// 2. Batch requests
const [balance, nfts, transactions] = await Promise.all([
  aptos.getAccountAPTAmount({ accountAddress }),
  aptos.getOwnedDigitalAssets({ ownerAddress }),
  aptos.getAccountTransactions({ accountAddress })
]);

// 3. Use pagination
const PAGE_SIZE = 25;
const offset = page * PAGE_SIZE;
```

## Best Practices

1. **Test on Devnet First** - Always deploy and test thoroughly on devnet
2. **Then Testnet** - Public testnet for final validation
3. **Audit Before Mainnet** - Security audit for production contracts
4. **Use CI/CD** - Automate testing and deployment
5. **Monitor Everything** - Metrics, logs, alerts
6. **Backup Private Keys** - Multiple secure locations
7. **Document Operations** - Runbooks for common tasks
8. **Plan for Upgrades** - Build upgrade mechanisms into contracts
9. **Rate Limit APIs** - Protect against abuse
10. **Have Rollback Plan** - Know how to revert if needed

## When to Use This Skill

Invoke when:
- "Deploy Move contract to mainnet"
- "Setup Aptos validator"
- "Run Aptos fullnode"
- "Configure production monitoring"
- "Upgrade smart contract"
- "Setup CI/CD for Aptos"
- "Troubleshoot node sync"
- Any deployment or operations task

## Related Skills

- **aptos-move-architect** - Write contracts to deploy
- **aptos-ts-sdk-expert** - Interact with deployed contracts
- **aptos-dapp-builder** - Build apps using deployed infrastructure
