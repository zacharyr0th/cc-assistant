# Aptos Move Architect

Expert in Move smart contract development for the Aptos blockchain - covering modules, resources, token standards, testing, security, and advanced patterns.

## What This Skill Covers

### Move Fundamentals
- **Language Basics** - Modules, structs, functions, abilities, generics
- **Resource Model** - Key/store/copy/drop abilities, global storage
- **Type System** - Primitives, vectors, structs, references
- **Control Flow** - If/else, while, loop, abort

### Token Standards
- **Fungible Assets (FA)** - Modern token standard with `MintRef`, `BurnRef`, `TransferRef`
- **Digital Assets (NFTs)** - Collections, tokens, transfer, burn using Aptos Token Objects
- **Legacy Coin** - Original coin standard (pre-FA)

### Aptos Objects
- **Object Model** - Create, transfer, delete, extend objects
- **Ownership** - Object transfer, linear transfer refs
- **Composability** - Nesting objects, resource groups

### Testing & Security
- **Unit Tests** - `#[test]`, `#[expected_failure]`, test coverage
- **Move Prover** - Formal verification with specifications
- **Security Patterns** - Access control, reentrancy guards, input validation
- **Common Vulnerabilities** - Integer overflow, unauthorized access, storage exhaustion

### Advanced Features
- **Events** - Emit and index on-chain events
- **Randomness** - On-chain randomness for games/lotteries
- **Tables** - Key-value storage (Table, IterableTable)
- **Multisig** - Multi-signature accounts and operations
- **View Functions** - Read-only functions for queries

## Quick Examples

### Simple Module

```move
module my_addr::counter {
    use std::signer;

    struct Counter has key {
        value: u64
    }

    public entry fun create(account: &signer) {
        move_to(account, Counter { value: 0 });
    }

    public entry fun increment(account: &signer) acquires Counter {
        let counter = borrow_global_mut<Counter>(signer::address_of(account));
        counter.value = counter.value + 1;
    }

    #[view]
    public fun get(addr: address): u64 acquires Counter {
        borrow_global<Counter>(addr).value
    }
}
```

### Fungible Asset

```move
public entry fun initialize(
    admin: &signer,
    name: vector<u8>,
    symbol: vector<u8>,
    decimals: u8,
) {
    let constructor_ref = &object::create_named_object(admin, name);

    primary_fungible_store::create_primary_store_enabled_fungible_asset(
        constructor_ref,
        option::none(),
        utf8(name),
        utf8(symbol),
        decimals,
        utf8(b""),
        utf8(b""),
    );

    let mint_ref = fungible_asset::generate_mint_ref(constructor_ref);
    let burn_ref = fungible_asset::generate_burn_ref(constructor_ref);
    let transfer_ref = fungible_asset::generate_transfer_ref(constructor_ref);

    move_to(admin, ManagedFungibleAsset {
        mint_ref,
        transfer_ref,
        burn_ref,
    });
}
```

### Events

```move
#[event]
struct TransferEvent has drop, store {
    from: address,
    to: address,
    amount: u64,
}

public entry fun transfer(from: &signer, to: address, amount: u64) {
    // ... transfer logic ...

    event::emit(TransferEvent {
        from: signer::address_of(from),
        to,
        amount,
    });
}
```

## Key Patterns

### Capability-Based Access Control

```move
struct AdminCapability has key, store {}

public fun initialize(admin: &signer) {
    move_to(admin, AdminCapability {});
}

public fun admin_only(admin: &signer) {
    assert!(exists<AdminCapability>(signer::address_of(admin)), E_NOT_ADMIN);
    // ... protected logic ...
}
```

### Object Creation

```move
public fun create_object(creator: &signer): Object<MyObject> {
    let constructor_ref = object::create_object(signer::address_of(creator));
    let object_signer = object::generate_signer(&constructor_ref);

    move_to(&object_signer, MyObject {
        value: 0,
        extend_ref: object::generate_extend_ref(&constructor_ref),
    });

    object::object_from_constructor_ref<MyObject>(&constructor_ref)
}
```

### Testing

```move
#[test(account = @0x123)]
fun test_counter(account: &signer) {
    counter::create(account);
    counter::increment(account);

    let value = counter::get(signer::address_of(account));
    assert!(value == 1, 0);
}

#[test]
#[expected_failure(abort_code = E_NOT_INITIALIZED)]
fun test_fails_when_not_initialized() {
    counter::get(@0x123); // Should abort
}
```

## Best Practices

1. **Use `#[view]` for read-only functions** - Enables off-chain querying
2. **Emit events for state changes** - Makes data indexable
3. **Validate all inputs** - Check addresses, amounts, bounds
4. **Use clear error codes** - `const E_ERROR_NAME: u64 = 1;`
5. **Write comprehensive tests** - Cover happy path and failures
6. **Minimize storage** - Only store essential data
7. **Use capabilities for permissions** - Type-safe access control
8. **Test on devnet first** - Always before mainnet

## Commands

```bash
# Initialize new Move project
aptos move init --name my_project

# Compile module
aptos move compile --named-addresses my_addr=0x123

# Run tests
aptos move test

# Test with coverage
aptos move test --coverage

# Publish to network
aptos move publish --profile devnet

# Call entry function
aptos move run \
  --function-id 0x123::my_module::my_function \
  --args u64:100 address:0x456
```

## When to Use

Invoke this skill when:
- Writing Move smart contracts
- Creating fungible or digital assets
- Implementing on-chain logic
- Testing Move modules
- Optimizing gas usage
- Adding access control
- Using Aptos Objects
- Debugging Move code
- Publishing Move packages

## Resources

- **Skill Reference**: See `skill.md` for comprehensive examples
- **Move Docs**: `resources/move-reference.txt` (14,147 lines)
- **Move Book**: https://aptos.dev/move/book/
- **Framework Source**: https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework

## Related Skills

- **aptos-ts-sdk-expert** - Interact with Move contracts via TypeScript
- **aptos-indexer-architect** - Index events and on-chain data
- **aptos-dapp-builder** - Full-stack dApp development
- **aptos-deployment-expert** - Deploy and manage packages

## Version

1.0.0 - Comprehensive Move development expertise for Aptos
