# Next.js Cache Architect - Skill Manifest

**Version:** 1.0.0
**Created:** 2025-11-04
**Status:** ✅ Complete

## Skill Structure

```
next-cache-architect/
├── Skill.md                    # Main skill file with metadata and core instructions
├── README.md                   # Complete documentation and usage guide
├── SKILL_MANIFEST.md          # This file - skill overview
└── resources/                 # Supplemental documentation
    ├── migration-guide.md     # cacheWrap → Cache Components migration
    ├── patterns.md            # Common caching patterns
    ├── examples.md            # Real-world implementations
    └── debugging.md           # Troubleshooting guide
```

## File Sizes

- **Skill.md**: 19.7 KB (787 lines)
- **README.md**: 10.7 KB
- **migration-guide.md**: 16.7 KB (567 lines)
- **patterns.md**: 15.6 KB (586 lines)
- **examples.md**: 20.1 KB (685 lines)
- **debugging.md**: 16.7 KB (630 lines)

**Total:** ~99 KB of documentation

## Coverage

### Core Concepts ✅
- [x] Cache Components (`'use cache'` directive)
- [x] Cache lifetimes (`cacheLife()`)
- [x] Cache tags (`cacheTag()`)
- [x] Cache invalidation (`revalidateTag()`, `updateTag()`)
- [x] Request memoization (React `cache()`)
- [x] Three-layer cache strategy

### Migration Guide ✅
- [x] Why migrate from cacheWrap
- [x] Step-by-step migration process
- [x] Before/after code examples
- [x] TTL → cacheLife mapping
- [x] Tag structure design
- [x] Testing migration
- [x] Common pitfalls
- [x] Rollback strategy

### Patterns ✅
- [x] Basic patterns (8 patterns)
- [x] Composition patterns (3 patterns)
- [x] Invalidation patterns (5 patterns)
- [x] Advanced patterns (6 patterns)
- [x] Anti-patterns (6 patterns)
- [x] Pattern selection guide

### Examples ✅
- [x] Dashboard with multiple data sources
- [x] Transaction list with filters
- [x] Account balance sync
- [x] Real estate property data
- [x] Market data (crypto/stocks)
- [x] User analytics
- [x] Plaid integration
- [x] Search and filtering

### Debugging ✅
- [x] Common issues (5 issues)
- [x] Debugging tools (4 tools)
- [x] Cache hit/miss tracking
- [x] Performance profiling
- [x] Troubleshooting checklist
- [x] Common error messages

## Capabilities

### 1. Design ✅
- Cache strategy planning
- Lifetime profile selection
- Tag structure design
- Composition patterns
- Invalidation strategy

### 2. Audit ✅
- Coverage analysis
- Missing cache detection
- Invalidation verification
- Performance scoring (0-100)
- Optimization recommendations

### 3. Migrate ✅
- Identify cacheWrap usage
- Convert to Cache Components
- Update invalidation handlers
- Test migration
- Generate reports

### 4. Optimize ✅
- Improve hit rates
- Reduce cache misses
- Fix invalidation issues
- Monitor performance
- Recommend lifetimes

### 5. Debug ✅
- Diagnose cache issues
- Fix stale data
- Resolve scope problems
- Profile performance
- Track hits/misses

### 6. Implement ✅
- Generate cached functions
- Create helpers files
- Write invalidation handlers
- Add monitoring
- Document strategy

## Usage Patterns

### Invocation
```
use next-cache-architect
```

### Common Commands
```
Audit caching in [file]
Migrate cacheWrap to Cache Components in [file]
Optimize dashboard caching strategy
Debug stale cache in [component]
Design cache architecture for [feature]
```

## Integration Points

### Clarity Project
- ✅ Uses Clarity's cache tags (`UserTags`, `DataTags`, `ContentTags`)
- ✅ Follows DAL patterns
- ✅ Integrates with Plaid sync
- ✅ Supports encrypted balances
- ✅ Works with Drizzle ORM
- ✅ Type-safe throughout

### Next.js 16
- ✅ Cache Components (`cacheComponents: true`)
- ✅ `'use cache'` directive
- ✅ `cacheLife()` profiles
- ✅ `cacheTag()` for invalidation
- ✅ `revalidateTag()` / `updateTag()`
- ✅ Node.js runtime (Edge not supported)

## Quality Checklist

### Documentation ✅
- [x] Clear skill description
- [x] Comprehensive examples
- [x] Step-by-step guides
- [x] Troubleshooting help
- [x] Best practices
- [x] Anti-patterns

### Code Examples ✅
- [x] Production-ready code
- [x] TypeScript support
- [x] Error handling
- [x] Performance monitoring
- [x] Security considerations
- [x] Comments and explanations

### Resource Files ✅
- [x] Migration guide complete
- [x] Patterns documented
- [x] Examples comprehensive
- [x] Debugging guide thorough
- [x] Well-organized
- [x] Easy to navigate

### Testing ✅
- [x] Example test code
- [x] Performance testing
- [x] Cache verification
- [x] Invalidation testing
- [x] Hit/miss tracking

## Success Criteria

A skill implementation is successful when it:

### Performance Metrics
- ✅ 95%+ cache hit rate for user data
- ✅ < 15ms average cached response time
- ✅ < 100ms average cache miss response time

### Code Quality
- ✅ Zero cacheWrap calls (fully migrated)
- ✅ 100% mutation handlers invalidate caches
- ✅ All expensive operations cached

### User Experience
- ✅ Zero stale data bugs
- ✅ Fast page loads
- ✅ Consistent data freshness

## Maintenance

### Version History
- **1.0.0** (2025-11-04): Initial release
  - Complete migration guide
  - Comprehensive patterns
  - Real-world examples
  - Debugging support

### Future Enhancements
- [ ] Add more Plaid-specific examples
- [ ] Include Redis comparison guide
- [ ] Add cache warming strategies
- [ ] Document multi-region caching
- [ ] Add cache monitoring dashboard
- [ ] Include load testing examples

## Dependencies

### Required
- Next.js 16.0.1+
- Node.js 20.9+
- React 19+
- `next/cache` APIs

### Optional
- Drizzle ORM (for examples)
- Pino logger (for monitoring)
- Vercel KV (for tracking)

## Related Skills

This skill works well with:
- **clarity-dal-architect** - Data Access Layer patterns
- **react-server-components** - RSC architecture
- **next-api-architect** - API route patterns
- **streaming-architect** - Suspense and streaming
- **nextjs-16-audit** - Comprehensive auditing

## Support

### For Help
1. Read the [README.md](./README.md)
2. Check [debugging.md](./resources/debugging.md)
3. Review [examples.md](./resources/examples.md)
4. Consult [patterns.md](./resources/patterns.md)

### For Issues
- Missing patterns? Add to `patterns.md`
- Need examples? Update `examples.md`
- Found bugs? Document in `debugging.md`
- Want features? Update this manifest

## Validation

### Checklist
- [x] Skill.md has required frontmatter
- [x] Description is clear and concise (< 200 chars)
- [x] All resources are properly linked
- [x] Code examples are tested
- [x] Documentation is comprehensive
- [x] Integration points documented
- [x] Success criteria defined
- [x] Troubleshooting guide included

### Test Commands
```bash
# Verify structure
ls -la next-cache-architect/
ls -la next-cache-architect/resources/

# Check file sizes
du -sh next-cache-architect/*
du -sh next-cache-architect/resources/*

# Validate frontmatter
head -10 next-cache-architect/Skill.md
```

## Notes

- Skill is production-ready
- Tested with Clarity project patterns
- Based on Next.js 16.0.1 documentation
- Follows Anthropic skill creation best practices
- Includes progressive disclosure (metadata → body → resources)

---

**Status:** ✅ Complete and Ready for Use
**Last Updated:** 2025-11-04
**Maintainer:** Claude Code
