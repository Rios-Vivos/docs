# Feature: Communications, opinions, and blog publication

**Status:** Planned.

**Owning repositories:** `web-page`, `system-admin`, `system-api`.

**Source issue:** [blog CRUD](https://github.com/Rios-Vivos/web-page/issues/36).

## Scope

Provide a controlled path for community or organizational submissions to become
published articles, opinions, or news. This is separate from generic CMS CRUD
because it introduces authorship, moderation, publication state, and consent.

## Required workflow

1. An authorized submitter creates or saves a draft with author and source
   attribution.
2. An editor reviews content, rights/consent, media, translations, and public
   visibility before publication.
3. Publication has a stable public URL, metadata, revision history, and an
   unpublish/archive path.
4. Public feedback or contact interactions have moderation, retention, and
   privacy rules before they are enabled.

## Acceptance checks

- Draft, review, published, rejected, and archived states are enforced by the
  API and visible in the admin workflow.
- Public pages expose only published content and do not leak drafts, private
  author details, or moderation notes.
- Changes preserve attribution and a reviewable history.
