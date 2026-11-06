# Product Scope — WI-Cart

## Vision

WI-Cart is an offline-first shopping and household expense manager. It helps people prepare purchases, maintain a reusable product catalog, control planned spending and understand what they actually spend.

The product serves two modes:
- **Personal:** private lists, products, stores, budgets and purchase history.
- **Household:** shared spaces where invited members can collaborate on lists with explicit roles and controlled access.

## Principles

1. Offline-first: core shopping workflows remain usable without connectivity.
2. Privacy by default: personal data belongs to its account and is never exposed to another account implicitly.
3. Explicit sharing: collaboration requires an invitation or deliberate sharing action.
4. Data integrity: synchronization must preserve relationships, deletion semantics and purchase records.
5. Incremental evolution: extend the existing Flutter/Laravel implementation rather than replacing working modules.
6. Clear state: distinguish planned, in-progress, implemented and verified capabilities.

## Current product foundations

The repository currently includes shopping lists, products, categories, units, stores, purchase history, budgets UI foundations, local SQLite/Drift persistence, a synchronization outbox, Laravel Sanctum authentication, Google sign-in integration, list/store copy-sharing endpoints, list import/backup utilities and BCV currency conversion.

Important distinction: the current list-sharing service copies a list or store and its related data into another user's account. It is not yet a live shared list with common ownership or real-time collaboration.

## Functional requirements

### Accounts and privacy
- Support account registration/login flows already present in the project.
- Keep every account's records isolated by authenticated user ownership.
- Clear account-scoped local data when logging out or switching accounts.
- Never rely on client-side filtering as the only authorization boundary.

### Shopping lists and catalog
- Create, edit, duplicate, archive/complete and delete lists.
- Track planned and purchased quantities, item status, notes and prices.
- Organize products with categories, units, descriptions, prices and images.
- Associate lists with stores and optional locations.
- Support search, reusable products and import workflows.

### Budgets and expense tracking
- Let users define budgets by period and optionally by category/store.
- Compare estimated list totals with actual purchase totals.
- Show spending summaries based on completed purchase records.
- Preserve currency precision and identify the source/timestamp of exchange rates.
- Avoid presenting estimates as confirmed expenses.

### Household collaboration (target capability)
- Allow a user to create a household workspace and invite other accounts.
- Support owner/admin/member roles with least-privilege permissions.
- Allow members to view and edit only the lists and resources shared with them.
- Support invitation acceptance, revocation, member removal and ownership transfer.
- Define behavior for simultaneous edits, offline edits, deletion and revoked access.
- Ensure local cache and pending outbox mutations cannot leak data between accounts or households.
- Use an explicit collaboration model; do not treat the current copy-to-account endpoint as live collaboration.
- Evaluate realtime transport only when justified; a reliable sync contract is required first.

### Synchronization
- SQLite is the client source of truth.
- Queue mutations in an outbox and retry safely.
- Use idempotent operations and stable identifiers.
- Document conflict policy and test concurrent/offline scenarios.
- Preserve soft-delete tombstones and pull cursor correctness.
- Do not silently discard failed or rejected mutations.

### Currency
- Maintain the existing USD base-price model and BCV conversion workflow.
- Cache rates with timestamp/source metadata.
- Handle unavailable rate providers and stale cached values gracefully.
- Keep monetary arithmetic decimal-safe.

## Non-functional requirements

- Security: authorization on every account/household resource.
- Reliability: transactional server-side operations and recoverable synchronization.
- Performance: paginated server queries and indexed ownership/sync columns.
- Accessibility: semantic controls, readable contrast and scalable text.
- Maintainability: modular Flutter features, Laravel services and documented API contracts.
- Portability: preserve supported Flutter platform targets.
- Testing: unit, integration and end-to-end coverage for critical flows.

## Out of scope unless explicitly approved

- Payment processing, advertising, selling user data or public social feeds.
- Automatic bank account access.
- Unreviewed external integrations that transmit shopping or household data.
