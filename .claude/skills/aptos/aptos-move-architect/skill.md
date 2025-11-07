---
name: Aptos Move Architect
description: Expert in Move smart contract development on Aptos. Covers modules, resources, abilities, generics, fungible assets, digital assets, testing, security, and advanced patterns.
version: 1.0.0
---

# Aptos Move Architect

## Overview

Specialized skill for building production-grade **Move smart contracts** on the Aptos blockchain. Move is a safe, sandboxed language for smart contracts with resource-oriented programming and formal verification capabilities.

## Core Expertise

- **Move Fundamentals** - Modules, structs, resources, abilities, generics
- **Token Standards** - Fungible Asset (FA), Digital Asset (DA/NFT), Coin
- **Object Model** - Aptos Objects, ownership, deletion, transfer
- **Testing** - Unit tests, e2e tests, test coverage
- **Security** - Move Prover, security guidelines, common vulnerabilities
- **Advanced Patterns** - Events, randomness, table, iterable tables, multisig
- **Gas Optimization** - Efficient resource usage, storage optimization
- **Package Management** - Move.toml, dependencies, versioning

## Installation

### Aptos CLI

```bash
# Install Aptos CLI
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3

# Verify installation
aptos --version

# Initialize a new Move project
aptos move init --name my_project
```

### VSCode Extension

Install the [Move VSCode extension](https://marketplace.visualstudio.com/items?itemName=move.move-analyzer) for syntax highlighting, auto-completion, and inline errors.

## Move Project Structure

```
my_project/
├── Move.toml              # Package manifest
├── sources/               # Move source files
│   └── my_module.move
├── tests/                 # Test files
│   └── my_module_tests.move
└── scripts/               # Move scripts (optional)
    └── deploy.move
```

### Move.toml

```toml
[package]
name = "MyProject"
version = "1.0.0"
authors = ["Your Name <you@example.com>"]

[addresses]
my_addr = "_"  # Replaced at deployment

[dependencies.AptosFramework]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-framework"

[dependencies.AptosStdlib]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-stdlib"

[dependencies.AptosToken]
git = "https://github.com/aptos-labs/aptos-core.git"
rev = "mainnet"
subdir = "aptos-move/framework/aptos-token"

[dev-dependencies]
```

## Move Basics

### Module Structure

```move
module my_addr::my_module {
    use std::signer;
    use std::string::String;
    use aptos_framework::event;
    use aptos_framework::timestamp;

    // Constants
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_ALREADY_INITIALIZED: u64 = 2;

    // Structs
    struct MyResource has key {
        value: u64,
        name: String,
        created_at: u64
    }

    // Events
    #[event]
    struct ValueUpdated has drop, store {
        old_value: u64,
        new_value: u64,
        timestamp: u64
    }

    // Initialize function
    public entry fun initialize(account: &signer, value: u64, name: String) {
        let addr = signer::address_of(account);
        assert!(!exists<MyResource>(addr), E_ALREADY_INITIALIZED);

        move_to(account, MyResource {
            value,
            name,
            created_at: timestamp::now_seconds()
        });
    }

    // Update function
    public entry fun update_value(account: &signer, new_value: u64) acquires MyResource {
        let addr = signer::address_of(account);
        let resource = borrow_global_mut<MyResource>(addr);

        let old_value = resource.value;
        resource.value = new_value;

        // Emit event
        event::emit(ValueUpdated {
            old_value,
            new_value,
            timestamp: timestamp::now_seconds()
        });
    }

    // View function
    #[view]
    public fun get_value(addr: address): u64 acquires MyResource {
        borrow_global<MyResource>(addr).value
    }
}
```

### Abilities

Move has four abilities that control what operations can be performed on types:

```move
module my_addr::abilities_example {
    // copy: Value can be copied
    struct Copyable has copy, drop {
        value: u64
    }

    // drop: Value can be discarded/dropped
    struct Droppable has drop {
        value: u64
    }

    // store: Value can be stored in global storage
    struct Storable has store {
        value: u64
    }

    // key: Value can be used as a key in global storage
    struct Resource has key {
        data: u64
    }

    // All abilities
    struct FullAbilities has copy, drop, store, key {
        value: u64
    }
}
```

**Key ability rules**:
- `key` - Required for `move_to`, `exists`, `borrow_global`, `move_from`
- `store` - Required to be stored inside another struct with `key`
- `copy` - Can use copy operator
- `drop` - Can be implicitly discarded

## Fungible Assets (FA)

The modern standard for fungible tokens on Aptos:

```move
module my_addr::fa_coin {
    use aptos_framework::fungible_asset::{Self, MintRef, TransferRef, BurnRef, Metadata};
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use std::signer;
    use std::string::utf8;
    use std::option;

    /// Error codes
    const E_NOT_OWNER: u64 = 1;

    /// Capabilities for managing the fungible asset
    struct ManagedFungibleAsset has key {
        mint_ref: MintRef,
        transfer_ref: TransferRef,
        burn_ref: BurnRef,
    }

    /// Initialize a new fungible asset
    public entry fun initialize(
        admin: &signer,
        name: vector<u8>,
        symbol: vector<u8>,
        decimals: u8,
        icon_uri: vector<u8>,
        project_uri: vector<u8>,
    ) {
        // Create the fungible asset
        let constructor_ref = &object::create_named_object(admin, name);

        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            constructor_ref,
            option::none(), // max_supply (none = unlimited)
            utf8(name),
            utf8(symbol),
            decimals,
            utf8(icon_uri),
            utf8(project_uri),
        );

        // Generate refs for managing the asset
        let mint_ref = fungible_asset::generate_mint_ref(constructor_ref);
        let burn_ref = fungible_asset::generate_burn_ref(constructor_ref);
        let transfer_ref = fungible_asset::generate_transfer_ref(constructor_ref);

        // Store the refs
        move_to(admin, ManagedFungibleAsset {
            mint_ref,
            transfer_ref,
            burn_ref,
        });
    }

    /// Mint tokens to a recipient
    public entry fun mint(
        admin: &signer,
        to: address,
        amount: u64,
        fa_obj_address: address,
    ) acquires ManagedFungibleAsset {
        let asset = get_metadata(fa_obj_address);
        let managed_fungible_asset = authorized_borrow_refs(admin, asset);
        let to_wallet = primary_fungible_store::ensure_primary_store_exists(to, asset);
        let fa = fungible_asset::mint(&managed_fungible_asset.mint_ref, amount);
        fungible_asset::deposit_with_ref(
            &managed_fungible_asset.transfer_ref,
            to_wallet,
            fa
        );
    }

    /// Burn tokens from an account
    public entry fun burn(
        admin: &signer,
        from: address,
        amount: u64,
        fa_obj_address: address,
    ) acquires ManagedFungibleAsset {
        let asset = get_metadata(fa_obj_address);
        let managed_fungible_asset = authorized_borrow_refs(admin, asset);
        let from_wallet = primary_fungible_store::primary_store(from, asset);
        fungible_asset::burn_from(
            &managed_fungible_asset.burn_ref,
            from_wallet,
            amount
        );
    }

    /// Transfer tokens (users can call this)
    public entry fun transfer(
        from: &signer,
        to: address,
        amount: u64,
        fa_obj_address: address,
    ) {
        let asset = get_metadata(fa_obj_address);
        primary_fungible_store::transfer(from, asset, to, amount);
    }

    // === Helper functions ===

    #[view]
    public fun get_metadata(fa_obj_address: address): Object<Metadata> {
        object::address_to_object<Metadata>(fa_obj_address)
    }

    inline fun authorized_borrow_refs(
        admin: &signer,
        asset: Object<Metadata>,
    ): &ManagedFungibleAsset acquires ManagedFungibleAsset {
        assert!(
            object::is_owner(asset, signer::address_of(admin)),
            E_NOT_OWNER
        );
        borrow_global<ManagedFungibleAsset>(object::object_address(&asset))
    }

    #[view]
    public fun balance(account: address, fa_obj_address: address): u64 {
        let asset = get_metadata(fa_obj_address);
        primary_fungible_store::balance(account, asset)
    }
}
```

## Digital Assets (NFTs)

```move
module my_addr::nft_collection {
    use aptos_framework::object::{Self, Object};
    use aptos_token_objects::collection;
    use aptos_token_objects::token;
    use std::string::{Self, String};
    use std::signer;
    use std::option;

    /// Collection name
    const COLLECTION_NAME: vector<u8> = b"My NFT Collection";
    const COLLECTION_DESCRIPTION: vector<u8> = b"A collection of unique NFTs";
    const COLLECTION_URI: vector<u8> = b"https://example.com/collection.json";

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;

    struct CollectionCapability has key {
        extend_ref: object::ExtendRef,
    }

    /// Create the NFT collection
    public entry fun create_collection(creator: &signer) {
        // Create the collection
        let constructor_ref = collection::create_unlimited_collection(
            creator,
            string::utf8(COLLECTION_DESCRIPTION),
            string::utf8(COLLECTION_NAME),
            option::none(),
            string::utf8(COLLECTION_URI),
        );

        // Store capability
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        move_to(creator, CollectionCapability { extend_ref });
    }

    /// Mint an NFT
    public entry fun mint_nft(
        creator: &signer,
        description: String,
        name: String,
        uri: String,
        recipient: address,
    ) acquires CollectionCapability {
        let creator_addr = signer::address_of(creator);

        // Verify creator owns the collection
        assert!(exists<CollectionCapability>(creator_addr), E_NOT_AUTHORIZED);

        // Create the NFT token
        let constructor_ref = token::create_named_token(
            creator,
            string::utf8(COLLECTION_NAME),
            description,
            name,
            option::none(),
            uri,
        );

        // Transfer to recipient
        let token_signer = object::generate_signer(&constructor_ref);
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);
        let linear_transfer_ref = object::generate_linear_transfer_ref(&transfer_ref);
        object::transfer_with_ref(linear_transfer_ref, recipient);
    }

    /// Transfer NFT
    public entry fun transfer_nft(
        owner: &signer,
        token_address: address,
        to: address,
    ) {
        let token = object::address_to_object<token::Token>(token_address);
        object::transfer(owner, token, to);
    }

    /// Burn NFT
    public entry fun burn_nft(
        owner: &signer,
        token_address: address,
    ) {
        let token = object::address_to_object<token::Token>(token_address);
        token::burn(owner, token);
    }
}
```

## Aptos Objects

Objects are a powerful primitive for composable, owned resources:

```move
module my_addr::objects_example {
    use aptos_framework::object::{Self, Object, ExtendRef, DeleteRef};
    use std::signer;
    use std::string::String;

    struct MyObject has key {
        value: u64,
        name: String,
        extend_ref: ExtendRef,
        delete_ref: DeleteRef,
    }

    /// Create a new object
    public fun create_object(creator: &signer, value: u64, name: String): Object<MyObject> {
        let creator_addr = signer::address_of(creator);

        // Create the object
        let constructor_ref = object::create_object(creator_addr);

        // Get signer for the object
        let object_signer = object::generate_signer(&constructor_ref);

        // Generate refs
        let extend_ref = object::generate_extend_ref(&constructor_ref);
        let delete_ref = object::generate_delete_ref(&constructor_ref);

        // Move resource to object
        move_to(&object_signer, MyObject {
            value,
            name,
            extend_ref,
            delete_ref,
        });

        // Return the object
        object::object_from_constructor_ref<MyObject>(&constructor_ref)
    }

    /// Transfer object
    public entry fun transfer_object(
        owner: &signer,
        object_addr: address,
        to: address,
    ) {
        let obj = object::address_to_object<MyObject>(object_addr);
        object::transfer(owner, obj, to);
    }

    /// Delete object
    public entry fun delete_object(
        owner: &signer,
        object_addr: address,
    ) acquires MyObject {
        let obj = object::address_to_object<MyObject>(object_addr);

        // Only owner can delete
        assert!(object::is_owner(obj, signer::address_of(owner)), 1);

        // Get the delete ref and delete
        let MyObject { value: _, name: _, extend_ref: _, delete_ref } =
            move_from<MyObject>(object_addr);
        object::delete(delete_ref);
    }
}
```

## Events

```move
module my_addr::events_example {
    use aptos_framework::event;
    use std::signer;

    // Event struct (must have drop, store)
    #[event]
    struct TransferEvent has drop, store {
        from: address,
        to: address,
        amount: u64,
        timestamp: u64,
    }

    #[event]
    struct DepositEvent has drop, store {
        account: address,
        amount: u64,
    }

    public entry fun transfer(
        from: &signer,
        to: address,
        amount: u64,
    ) {
        let from_addr = signer::address_of(from);

        // ... transfer logic ...

        // Emit event
        event::emit(TransferEvent {
            from: from_addr,
            to,
            amount,
            timestamp: aptos_framework::timestamp::now_seconds(),
        });
    }

    public entry fun deposit(account: &signer, amount: u64) {
        // ... deposit logic ...

        event::emit(DepositEvent {
            account: signer::address_of(account),
            amount,
        });
    }
}
```

## Testing

### Unit Tests

```move
#[test_only]
module my_addr::my_module_tests {
    use my_addr::my_module;
    use std::signer;
    use aptos_framework::account;

    #[test(admin = @0x123)]
    fun test_initialize(admin: &signer) {
        // Setup
        let admin_addr = signer::address_of(admin);
        account::create_account_for_test(admin_addr);

        // Initialize
        my_module::initialize(admin, 100, b"Test");

        // Verify
        assert!(my_module::get_value(admin_addr) == 100, 1);
    }

    #[test(admin = @0x123)]
    #[expected_failure(abort_code = 2)]
    fun test_initialize_twice_fails(admin: &signer) {
        let admin_addr = signer::address_of(admin);
        account::create_account_for_test(admin_addr);

        // Initialize twice should fail
        my_module::initialize(admin, 100, b"Test");
        my_module::initialize(admin, 200, b"Test2"); // Should abort
    }

    #[test(admin = @0x123)]
    fun test_update_value(admin: &signer) acquires my_module::MyResource {
        let admin_addr = signer::address_of(admin);
        account::create_account_for_test(admin_addr);

        // Initialize and update
        my_module::initialize(admin, 100, b"Test");
        my_module::update_value(admin, 200);

        // Verify
        assert!(my_module::get_value(admin_addr) == 200, 1);
    }
}
```

### Running Tests

```bash
# Run all tests
aptos move test

# Run specific test
aptos move test --filter test_initialize

# Run with coverage
aptos move test --coverage

# View coverage report
aptos move coverage source --module my_module
```

## Security Best Practices

### 1. Access Control

```move
module my_addr::access_control {
    use std::signer;

    const E_NOT_AUTHORIZED: u64 = 1;

    struct AdminCapability has key, store {}

    /// Initialize with admin capability
    public entry fun initialize(admin: &signer) {
        move_to(admin, AdminCapability {});
    }

    /// Check if account is admin
    public fun is_admin(addr: address): bool {
        exists<AdminCapability>(addr)
    }

    /// Require admin access
    public fun require_admin(account: &signer) {
        assert!(is_admin(signer::address_of(account)), E_NOT_AUTHORIZED);
    }

    /// Protected function
    public entry fun admin_only_function(admin: &signer) {
        require_admin(admin);
        // ... admin logic ...
    }
}
```

### 2. Reentrancy Protection

```move
module my_addr::reentrancy_guard {
    use std::signer;

    const E_REENTRANT_CALL: u64 = 1;

    struct Guard has key {
        locked: bool
    }

    public fun acquire_lock(account: &signer) acquires Guard {
        let addr = signer::address_of(account);
        if (!exists<Guard>(addr)) {
            move_to(account, Guard { locked: false });
        };

        let guard = borrow_global_mut<Guard>(addr);
        assert!(!guard.locked, E_REENTRANT_CALL);
        guard.locked = true;
    }

    public fun release_lock(account: &signer) acquires Guard {
        let guard = borrow_global_mut<Guard>(signer::address_of(account));
        guard.locked = false;
    }
}
```

### 3. Integer Overflow Protection

```move
module my_addr::safe_math {
    const E_OVERFLOW: u64 = 1;
    const E_UNDERFLOW: u64 = 2;

    public fun safe_add(a: u64, b: u64): u64 {
        let result = a + b;
        assert!(result >= a && result >= b, E_OVERFLOW);
        result
    }

    public fun safe_sub(a: u64, b: u64): u64 {
        assert!(a >= b, E_UNDERFLOW);
        a - b
    }

    public fun safe_mul(a: u64, b: u64): u64 {
        if (a == 0 || b == 0) return 0;
        let result = a * b;
        assert!(result / a == b, E_OVERFLOW);
        result
    }
}
```

### 4. Input Validation

```move
module my_addr::validation {
    use std::string::String;
    use std::vector;

    const E_INVALID_INPUT: u64 = 1;
    const E_AMOUNT_TOO_LARGE: u64 = 2;
    const E_EMPTY_STRING: u64 = 3;

    const MAX_AMOUNT: u64 = 1_000_000_000_000; // 1 trillion

    public fun validate_amount(amount: u64) {
        assert!(amount > 0, E_INVALID_INPUT);
        assert!(amount <= MAX_AMOUNT, E_AMOUNT_TOO_LARGE);
    }

    public fun validate_address(addr: address) {
        assert!(addr != @0x0, E_INVALID_INPUT);
    }

    public fun validate_string(s: &String) {
        assert!(!string::is_empty(s), E_EMPTY_STRING);
    }
}
```

## Advanced Patterns

### Pausable Contract

```move
module my_addr::pausable {
    use std::signer;

    const E_PAUSED: u64 = 1;
    const E_NOT_AUTHORIZED: u64 = 2;

    struct PauseState has key {
        paused: bool,
        admin: address,
    }

    public fun initialize(admin: &signer) {
        move_to(admin, PauseState {
            paused: false,
            admin: signer::address_of(admin),
        });
    }

    public fun pause(admin: &signer) acquires PauseState {
        let state = borrow_global_mut<PauseState>(@my_addr);
        assert!(signer::address_of(admin) == state.admin, E_NOT_AUTHORIZED);
        state.paused = true;
    }

    public fun unpause(admin: &signer) acquires PauseState {
        let state = borrow_global_mut<PauseState>(@my_addr);
        assert!(signer::address_of(admin) == state.admin, E_NOT_AUTHORIZED);
        state.paused = false;
    }

    public fun require_not_paused() acquires PauseState {
        let state = borrow_global<PauseState>(@my_addr);
        assert!(!state.paused, E_PAUSED);
    }
}
```

### Upgradeable Modules

```move
module my_addr::upgradeable {
    use std::signer;
    use aptos_framework::code;

    struct UpgradeCapability has key {
        // Store upgrade capability
    }

    public entry fun upgrade_contract(
        admin: &signer,
        metadata_serialized: vector<u8>,
        code: vector<vector<u8>>,
    ) {
        // Verify admin has upgrade capability
        assert!(exists<UpgradeCapability>(signer::address_of(admin)), 1);

        // Publish new code
        code::publish_package_txn(admin, metadata_serialized, code);
    }
}
```

### Randomness

```move
module my_addr::lottery {
    use aptos_framework::randomness;
    use std::vector;

    #[randomness]
    entry fun draw_winner(players: vector<address>): address {
        let num_players = vector::length(&players);
        let index = randomness::u64_range(0, num_players);
        *vector::borrow(&players, index)
    }
}
```

### Table and Iterable Table

```move
module my_addr::registry {
    use aptos_std::table::{Self, Table};
    use aptos_std::iterable_table::{Self, IterableTable};
    use std::string::String;

    struct Registry has key {
        // Simple table (O(1) lookup, no iteration)
        entries: Table<address, String>,

        // Iterable table (can iterate all keys)
        metadata: IterableTable<address, u64>,
    }

    public fun initialize(account: &signer) {
        move_to(account, Registry {
            entries: table::new(),
            metadata: iterable_table::new(),
        });
    }

    public fun add_entry(
        account: &signer,
        addr: address,
        name: String,
        value: u64,
    ) acquires Registry {
        let registry = borrow_global_mut<Registry>(signer::address_of(account));

        table::add(&mut registry.entries, addr, name);
        iterable_table::add(&mut registry.metadata, addr, value);
    }

    public fun iterate_all(account_addr: address): vector<address> acquires Registry {
        let registry = borrow_global<Registry>(account_addr);
        let result = vector::empty();

        let iter = iterable_table::head_key(&registry.metadata);
        while (option::is_some(&iter)) {
            let key = *option::borrow(&iter);
            vector::push_back(&mut result, key);
            iter = iterable_table::next_key(&registry.metadata, key);
        };

        result
    }
}
```

## Gas Optimization

### 1. Minimize Storage

```move
// ❌ Bad: Storing redundant data
struct BadUser has key {
    name: String,
    email: String,
    full_name_and_email: String, // Redundant!
}

// ✅ Good: Minimal storage
struct GoodUser has key {
    name: String,
    email: String,
}
```

### 2. Use References

```move
// ❌ Bad: Copying large structs
fun process_data(data: LargeStruct) {
    // data is copied
}

// ✅ Good: Use references
fun process_data(data: &LargeStruct) {
    // Only reference is passed
}
```

### 3. Batch Operations

```move
// ❌ Bad: Multiple transactions
public entry fun transfer_one(from: &signer, to: address, amount: u64) {}

// ✅ Good: Batch in single transaction
public entry fun transfer_many(
    from: &signer,
    recipients: vector<address>,
    amounts: vector<u64>,
) {
    let i = 0;
    let len = vector::length(&recipients);
    while (i < len) {
        let to = *vector::borrow(&recipients, i);
        let amount = *vector::borrow(&amounts, i);
        // ... transfer logic ...
        i = i + 1;
    }
}
```

## Deployment

### Compile and Test

```bash
# Compile the module
aptos move compile --named-addresses my_addr=0x123

# Run tests
aptos move test

# Publish to devnet
aptos move publish --named-addresses my_addr=0x123 --profile devnet

# Publish to mainnet
aptos move publish --named-addresses my_addr=0x123 --profile mainnet
```

### Initialize After Deployment

```bash
# Call initialize function
aptos move run \
  --function-id 0x123::my_module::initialize \
  --args u64:100 string:"Test" \
  --profile mainnet
```

## Common Patterns

### Pattern: Capability-Based Access

```move
module my_addr::capabilities {
    struct MintCapability has key, store {}
    struct BurnCapability has key, store {}

    public fun initialize(admin: &signer) {
        move_to(admin, MintCapability {});
        move_to(admin, BurnCapability {});
    }

    public fun mint_with_cap(
        _cap: &MintCapability,
        amount: u64,
    ) {
        // Mint logic (caller must have MintCapability)
    }
}
```

### Pattern: Witness

```move
module my_addr::witness_example {
    /// One-time witness
    struct MY_MODULE has drop {}

    fun init_module(witness: MY_MODULE) {
        // This can only be called once during module initialization
        // The witness proves this is the first and only call
    }
}
```

### Pattern: Hot Potato

```move
module my_addr::hot_potato {
    /// No abilities - must be unpacked
    struct Receipt {
        value: u64
    }

    public fun create_receipt(value: u64): Receipt {
        Receipt { value }
    }

    public fun consume_receipt(receipt: Receipt): u64 {
        let Receipt { value } = receipt;
        value
    }

    // Caller MUST call consume_receipt, can't drop or store Receipt
}
```

## Best Practices Summary

1. **Always validate inputs** - Check addresses, amounts, strings
2. **Use assert! for invariants** - Clear error codes
3. **Emit events for state changes** - Enable indexing and monitoring
4. **Write comprehensive tests** - Unit tests and integration tests
5. **Use view functions** - Mark read-only functions with `#[view]`
6. **Minimize storage** - Only store essential data
7. **Use capabilities for access control** - Type-safe permissions
8. **Document your code** - Comments and doc strings
9. **Test on devnet first** - Always test before mainnet
10. **Run Move Prover** - Formal verification for critical code

## Reference Documentation

- **Move Reference**: `~/Documents/cc-skills/.claude/skills/aptos-move-architect/resources/move-reference.txt`
- **Aptos Move Book**: https://aptos.dev/move/book/
- **Move Language Spec**: https://github.com/move-language/move/tree/main/language/documentation
- **Aptos Framework**: https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework

## When to Use This Skill

Invoke when:
- "Write a Move smart contract"
- "Create fungible asset module"
- "Deploy NFT collection"
- "Implement access control in Move"
- "Optimize Move contract gas"
- "Test Move module"
- "Use Aptos Objects"
- "Add events to contract"
- "Implement randomness in Move"
- Any Aptos Move development task

## Related Skills

- **aptos-ts-sdk-expert** - TypeScript SDK for interacting with contracts
- **aptos-indexer-architect** - Index contract events and data
- **aptos-dapp-builder** - Full-stack dApp development
- **aptos-deployment-expert** - Deploy and manage Move packages
