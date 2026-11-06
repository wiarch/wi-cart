# Security Policy

## Supported scope

Security reports are welcome for the WI-Cart Flutter client, Laravel API, development API and synchronization workflows.

## Reporting a vulnerability

Please report suspected vulnerabilities privately to the repository maintainers through GitHub's private vulnerability reporting feature when available. Do not publish exploit details, tokens, personal data or production URLs in public issues.

Include:
- affected component and version/commit;
- impact and realistic attack scenario;
- reproduction steps or proof of concept that does not access other users' data;
- suggested mitigation, if known.

## Security expectations

- All personal and household resources require server-side authorization.
- Never trust a client-provided `user_id`, household ID or role.
- Keep bearer tokens, passwords and secrets out of logs and commits.
- Use HTTPS and secure production configuration.
- Validate uploads and imported files, including size and content.
- Treat local databases, exports and backups as sensitive data.
- Test account switching, logout, membership revocation and pending offline mutations.
- Avoid leaking sensitive data through error messages or synchronization responses.

Do not test against production accounts or data without explicit authorization.
