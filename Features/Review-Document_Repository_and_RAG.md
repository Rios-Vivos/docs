# Feature: Document repository roadmap

**Status:** Planned expansion. RAG is an implemented capability; this record
covers the future governed repository that will provide durable source access.

**Owning repositories:** `web-page`, `system-api`, and `system-admin`.

**Source issues:** [document/RAG analysis](https://github.com/Rios-Vivos/web-page/issues/119) and [academic CSV/Excel access](https://github.com/Rios-Vivos/web-page/issues/83).

## Scope

The repository stores, classifies, searches, filters, downloads, and audits
documents and approved source files. RAG may later answer questions only from
documents the requesting user is allowed to access.

## Required records and workflow

- Every document has owner, source, type, visibility, license/consent state,
  upload date, version, checksum, and retention decision.
- Uploads are validated for type/size, malware-scanned where infrastructure
  permits, stored outside application source control, and linked to metadata.
- Search/filter behavior respects visibility before returning metadata, content,
  previews, embeddings, or citations.
- RAG ingestion is explicit and traceable: selected source version, chunking
  approach, embedding/model version, index time, and removal/reindex process.

## Rules

- Internal, academic, public, and restricted material require explicit access
  policy; a model must never bypass repository authorization.
- Answers must cite retrieved source records and state when no authorized source
  supports an answer.
- CSV/Excel publication must distinguish downloadable source files from
  monitoring ingestion data and preserve provenance.

## Acceptance checks

- An authorized academic user can find and download permitted material; an
  unauthorized user cannot infer its existence through search or RAG.
- Replacing or removing a document updates search and RAG indexes predictably.
- A pilot defines target questions, quality metrics, human review, operating
  cost, and a deletion/recovery procedure before public release.
