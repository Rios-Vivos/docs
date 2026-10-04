# Feature: Content management coverage and governance

**Status:** Core CMS is implemented; this record defines the remaining audit
and traceability work.

**Owning repositories:** `system-admin`, `system-api`, `web-page`.

**Source issues:** [CRUD audit](https://github.com/Rios-Vivos/system-admin/issues/38), [alliances](https://github.com/Rios-Vivos/web-page/issues/34), [news/blog](https://github.com/Rios-Vivos/web-page/issues/22), [communities](https://github.com/Rios-Vivos/web-page/issues/86), and [resource categories](https://github.com/Rios-Vivos/web-page/issues/33).

## Coverage matrix

The CMS must track ownership and CRUD evidence for Landing, Activities,
Resources, resource categories, Communities, Alliances, News/Blog, Logos,
contact data, policies, events/calendar, and donation content. For each entity,
record API endpoint, admin route, public consumer, allowed roles, audit event,
soft-delete behavior, preview behavior, translations, media dependencies, and
test evidence.

## Rules

- Backend authorization is authoritative; admin UI visibility does not grant a
  permission.
- Deletes are logical unless a documented retention/migration decision says
  otherwise; referenced content and media require safe handling.
- Published content changes are attributable to actor and time, and preview
  cannot expose unpublished/private data.
- Public routes, SEO metadata, translations, and media references remain
  compatible when content models change.

## Acceptance checks

- The coverage matrix identifies every in-scope entity and its missing CRUD or
  audit capability.
- Each newly completed entity has authorized API tests, admin validation/error
  states, and public rendering verification.
- The catalog is updated when an entity moves from planned to implemented.
