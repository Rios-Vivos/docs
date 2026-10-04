# [Done] Feature: Translations

## Scope

The public site and administrative dashboard support localized user-facing
content through their existing locale configuration and translation workflows.

## Implemented behavior

- Public and administrative interfaces resolve text through locale resources.
- Translation tooling retrieves and publishes supported locale keys.
- New feature text can be added without hard-coding one language into shared UI
  components.

## Rules

- Every new visible string uses the established locale-key pattern and includes
  required translations before release.
- Locale keys are stable API-like contracts: renaming or deleting them requires
  checking every consumer.
- Fallback behavior must remain deliberate; untranslated production text must
  be visible for correction rather than silently changing meaning.

## Verification

Check the changed view in each supported locale, including interpolation,
pluralization where used, loading/error states, and a missing-key fallback.

## Owning repositories

`web-page` and `system-admin`; API-assisted translation tooling is coordinated
with `system-api` where configured.
