# Shelby Integration Guide for Claude Code

This guide provides patterns and examples for building Claude Code skills, agents, or tools that interact with the Shelby Protocol.

## Overview

Shelby is a decentralized hot storage network built on Aptos blockchain, ideal for:
- Video streaming
- AI training data
- Data analytics
- Decentralized content delivery

## Integration Approaches

### 1. CLI-Based Integration

Use the Shelby CLI via Bash tool calls in Claude Code skills.

#### Installation Pattern
```typescript
// In a skill or agent
await bash(`npm i -g @shelby-protocol/cli`);
```

#### Upload Pattern
```typescript
// Upload file using CLI
await bash(`shelby upload ${sourcePath} ${blobName} -e ${expiration} --assume-yes`);
```

#### Download Pattern
```typescript
// Download file using CLI
await bash(`shelby download ${blobName} ${destPath}`);
```

#### Account Management
```typescript
// Check balance
await bash(`shelby account balance`);

// List blobs
await bash(`shelby account blobs`);

// Fund account via faucet
await bash(`shelby faucet --no-open`);
```

### 2. TypeScript SDK Integration

For Node.js skills or agents, use the TypeScript SDK directly.

#### Setup
```typescript
import { ShelbyNodeClient } from '@shelby-protocol/sdk';
import { Network, Ed25519PrivateKey, Account } from '@aptos-labs/ts-sdk';

// Initialize client
const client = new ShelbyNodeClient({
  network: Network.SHELBYNET
});

// Setup account from env
const privateKey = new Ed25519PrivateKey(process.env.APTOS_PRIVATE_KEY);
const account = Account.fromPrivateKey({ privateKey });
```

#### Upload Pattern
```typescript
async function uploadToShelby(data: Buffer, name: string, expirationDays: number = 30) {
  await client.uploadBlob({
    account: account,
    blobData: data,
    blobName: name,
    expirationDays: expirationDays
  });

  return `shelby://${name}`;
}
```

### 3. API Integration

Direct API calls for custom implementations.

```typescript
const SHELBY_API = 'https://api.shelbynet.shelby.xyz/shelby';

// Note: Full API documentation for direct HTTP calls is limited
// Prefer using CLI or SDK for most use cases
```

## Use Cases for Claude Code Skills

### 1. Decentralized Backup Skill

```yaml
# .claude/skills/shelby-backup.skill.yaml
name: shelby-backup
description: Backup project files to Shelby decentralized storage
version: 1.0.0
```

Implementation ideas:
- Compress project directory
- Upload to Shelby with expiration
- Return Shelby URI for retrieval
- Store metadata in local config

### 2. Dataset Upload Agent

Create an agent that:
- Validates dataset format
- Chunks large datasets if needed
- Uploads to Shelby with appropriate expiration
- Generates retrieval manifest
- Handles funding checks and errors

### 3. Video Processing Pipeline

Build a skill that:
- Accepts video file path
- Processes/transcodes video
- Uploads to Shelby storage
- Returns Shelby URI for streaming
- Optionally generates embed code

### 4. AI Training Data Manager

Agent capabilities:
- Upload training datasets
- Manage dataset versions
- Track expiration dates
- Provide download scripts for training
- Monitor storage costs

## Configuration Management

### Environment Variables Pattern

```bash
# ~/.shelby/config.yaml
# Managed by CLI

# For SDK/API usage
export APTOS_PRIVATE_KEY="your_private_key"
export SHELBY_NETWORK="shelbynet"
export SHELBY_API_KEY="optional_api_key"
```

### Claude Code Skill Config

```typescript
// In skill implementation
interface ShelbyConfig {
  network: 'shelbynet' | 'local';
  defaultExpiration: number; // days
  autoFund: boolean;
  maxUploadSize: number; // bytes
}

const config: ShelbyConfig = {
  network: 'shelbynet',
  defaultExpiration: 30,
  autoFund: true,
  maxUploadSize: 100 * 1024 * 1024 // 100MB
};
```

## Error Handling Patterns

### Common Errors

```typescript
enum ShelbyError {
  INSUFFICIENT_SHELBYUSD = 'insufficient_shelbyusd',
  INSUFFICIENT_APTOS = 'insufficient_aptos',
  NETWORK_ERROR = 'network_error',
  FILE_TOO_LARGE = 'file_too_large',
  BLOB_NOT_FOUND = 'blob_not_found'
}
```

### Error Recovery

```typescript
async function uploadWithAutoFund(file: string, name: string) {
  try {
    await bash(`shelby upload ${file} ${name} --assume-yes`);
  } catch (error) {
    if (error.message.includes('Insufficient ShelbyUSD')) {
      // Auto-fund from faucet
      await bash(`shelby faucet --no-open`);
      // Retry upload
      await bash(`shelby upload ${file} ${name} --assume-yes`);
    } else {
      throw error;
    }
  }
}
```

## Best Practices

### 1. Token Management

- Check balances before uploads
- Auto-fund from faucet in dev environments
- Warn users about production funding needs
- Track upload costs

### 2. File Size Handling

- Use multipart uploads for large files (handled automatically by CLI/SDK)
- Chunk extremely large datasets
- Compress files when appropriate
- Validate file sizes before upload

### 3. Expiration Management

- Set reasonable default expirations
- Allow user override
- Track expiration dates
- Implement renewal logic if needed

### 4. URI Management

- Return Shelby URIs in format: `shelby://{blob_name}`
- Store mappings of local paths to Shelby URIs
- Provide retrieval helpers
- Document URI format for users

### 5. Security

- Never commit private keys
- Use environment variables for sensitive data
- Validate file paths and blob names
- Sanitize user inputs

## Example Skill Implementation

```typescript
// .claude/skills/shelby-upload/index.ts

import { bash, read, write } from '@claude/sdk';

interface UploadResult {
  uri: string;
  blobName: string;
  expiresAt: Date;
  size: number;
}

async function uploadFile(
  filePath: string,
  blobName?: string,
  expirationDays: number = 30
): Promise<UploadResult> {
  // Default blob name from file path
  const name = blobName || filePath.split('/').pop()!;

  // Check if CLI is installed
  try {
    await bash('which shelby');
  } catch {
    throw new Error('Shelby CLI not installed. Run: npm i -g @shelby-protocol/cli');
  }

  // Check balance
  const balance = await bash('shelby account balance');
  console.log('Current balance:', balance);

  // Upload file
  await bash(`shelby upload "${filePath}" "${name}" -e ${expirationDays}d --assume-yes`);

  // Get file size
  const stat = await bash(`stat -f%z "${filePath}"`);
  const size = parseInt(stat.trim());

  // Calculate expiration
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + expirationDays);

  return {
    uri: `shelby://${name}`,
    blobName: name,
    expiresAt,
    size
  };
}

export default {
  name: 'shelby-upload',
  description: 'Upload files to Shelby decentralized storage',
  version: '1.0.0',

  async execute(args: { file: string; name?: string; expiration?: number }) {
    const result = await uploadFile(args.file, args.name, args.expiration);

    return `Uploaded to Shelby!

URI: ${result.uri}
Blob Name: ${result.blobName}
Size: ${(result.size / 1024 / 1024).toFixed(2)} MB
Expires: ${result.expiresAt.toLocaleDateString()}

Download with: shelby download ${result.blobName} ./local-path`;
  }
};
```

## Testing

### Local Testing

```bash
# Setup local Shelby instance for testing
shelby init
shelby context list

# Test uploads
shelby upload test-file.txt test/file.txt -e 1d --assume-yes

# Verify
shelby account blobs

# Test download
shelby download test/file.txt ./downloaded-file.txt
```

### Integration Testing

```typescript
// test/shelby-integration.test.ts
describe('Shelby Integration', () => {
  it('should upload and download file', async () => {
    const testFile = './fixtures/test.txt';
    const result = await uploadFile(testFile, 'test/upload.txt', 1);

    expect(result.uri).toMatch(/^shelby:\/\//);

    // Download and verify
    await bash(`shelby download ${result.blobName} ./tmp/downloaded.txt`);
    const original = await read(testFile);
    const downloaded = await read('./tmp/downloaded.txt');

    expect(original).toBe(downloaded);
  });
});
```

## Resources

- [Shelby Overview](../shelby/overview.md)
- [CLI Guide](../shelby/cli-guide.md)
- [TypeScript SDK](../shelby/typescript-sdk.md)
- [API Reference](../shelby/api-reference.md)

## Next Steps

1. Install Shelby CLI: `npm i -g @shelby-protocol/cli`
2. Initialize configuration: `shelby init`
3. Fund account: `shelby faucet --no-open`
4. Build your first Shelby-integrated skill
5. Test in development environment
6. Deploy to production with proper token management

---

*For the latest documentation, visit https://docs.shelby.xyz/*
