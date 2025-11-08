# Aptos Deployment Expert

Expert in deploying Move contracts, running Aptos nodes, and production operations.

## What This Skill Covers

- **Move Deployment** - Compile, publish, upgrade contracts
- **Node Operations** - Fullnodes, validators, VFNs
- **Monitoring** - Prometheus, Grafana, health checks
- **Security** - Key management, firewalls, hardening
- **CI/CD** - Automated testing and deployment

## Quick Commands

```bash
# Deploy to mainnet
aptos move publish \
  --profile mainnet \
  --named-addresses my_addr=0x123... \
  --assume-yes

# Run local testnet
aptos node run-local-testnet --with-faucet

# Check node health
curl http://localhost:8080/v1
```

## Version

1.0.0
