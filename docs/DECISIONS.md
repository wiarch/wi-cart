# Architecture Decision Records

## ADR-001 — Offline-first client

**Status:** Accepted

SQLite through Drift is the local source of truth for the Flutter client. Core shopping workflows must remain usable without connectivity.

## ADR-002 — Outbox-based synchronization

**Status:** Accepted

Local mutations are queued and synchronized with the Laravel API. The current conflict strategy is Last-Write-Wins using `client_updated_at`. Changes to this policy require explicit migration and compatibility analysis.

## ADR-003 — Flutter and Laravel monorepo

**Status:** Accepted

Keep the Flutter client, Laravel production API, Express development API and documentation in one repository to preserve coordinated changes and contracts.

## ADR-004 — Account privacy by default

**Status:** Accepted

Every personal record is scoped to its authenticated owner. Server-side authorization is mandatory; client filtering is not a security boundary.

## ADR-005 — Household collaboration as an explicit domain

**Status:** Proposed

Shared household lists should use explicit workspace membership, invitations and roles. The current share service performs a copy into another account and must not be represented as live collaboration. A future collaboration implementation must define ownership, revocation, offline behavior and synchronization scope before UI work begins.

## ADR-006 — Preserve existing implementation

**Status:** Accepted

Claude Code and contributors must audit the repository before modifying it. Avoid broad rewrites, duplicate services or destructive schema changes. Prefer small, tested and reversible increments.
