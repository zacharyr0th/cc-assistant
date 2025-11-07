# Plugin Marketplaces Documentation Summary

## Core Concept
Plugin marketplaces function as JSON-based catalogs enabling teams to discover, install, and manage Claude Code extensions. They support centralized distribution across organizations while accommodating multiple plugin sources.

## Key Features
According to the documentation, marketplaces deliver "centralized discovery," "version management," "team distribution," and support for "git repositories, GitHub repos, local paths, and package managers."

## Adding Marketplaces
Users can integrate marketplaces through several methods:
- GitHub repositories using `/plugin marketplace add owner/repo`
- Git services via full URLs like `https://gitlab.com/company/plugins.git`
- Local directories for development testing
- Direct marketplace.json file URLs

## Creating Custom Marketplaces
Marketplace creators must establish a `.claude-plugin/marketplace.json` file containing required fields: `name`, `owner`, and `plugins` array. Plugin entries need a `name` and `source` designation, with optional metadata including descriptions, versions, and component configurations.

## Plugin Sources
Marketplaces support multiple source types: relative paths for co-located plugins, GitHub repositories via `"source": "github"`, and generic Git URLs using `"source": "url"`.

## Team Configuration
Organizations can automate marketplace installation by specifying `extraKnownMarketplaces` in `.claude/settings.json`, enabling automatic setup when team members trust repository folders.

## Distribution Strategies
GitHub hosting is recommended for simplicity, though any Git service works. Local testing precedes public distribution, with validation available through `claude plugin validate`.
