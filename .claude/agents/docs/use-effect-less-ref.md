# Use-Effect-Less Reference (React v19.2)

This reference summarizes patterns from React’s “You Might Not Need an Effect” and related guidance for modern React (including React Compiler).

## When You Don’t Need Effects

- Transformations for rendering: compute from props/state during render.
- Event-specific logic: execute in the event handler (POST, navigation, notifications).
- Expensive but pure computations: use `useMemo` (or rely on the Compiler) to avoid recomputation when inputs don’t change.

## State Management Patterns

- Derived state: avoid duplicating state that can be computed.
- IDs over objects: store identifiers; derive objects during render.
- Reset subtree state via `key` prop when identity changes.
- Guarded in-render state adjustment (rare): only same-component `setState` with strict change guard to avoid loops.

## Effects You Still Need

- Synchronization with external systems (non-React widgets, imperative DOM APIs, timers, custom stores).
- External store subscriptions: prefer `useSyncExternalStore` over manual Effect wiring.
- Data fetching while visible: add cleanup to avoid race conditions; prefer framework-native data fetching where possible.

## Anti-Patterns to Remove

- Effects that copy props/state into new state solely to render.
- Chains of Effects that exist only to trigger each other.
- Notifying parents from Effects—do it during the initiating event.

## Snippets

Derived Value:
```tsx
const fullName = first + ' ' + last;
```

Memoized Expensive Calc:
```tsx
const visible = useMemo(() => compute(todos, filter), [todos, filter]);
```

Reset with Key:
```tsx
<Profile key={userId} userId={userId} />
```

External Store:
```tsx
function useOnlineStatus() {
  return useSyncExternalStore(subscribe, () => navigator.onLine, () => true);
}
```

Data Fetch with Cleanup:
```tsx
useEffect(() => {
  let ignore = false;
  fetch(url).then(r => r.json()).then(d => { if (!ignore) setData(d); });
  return () => { ignore = true; };
}, [url]);
```

Event-Driven Parent Notify:
```tsx
function toggle(next) {
  setIsOn(next);
  onChange(next);
}
```

