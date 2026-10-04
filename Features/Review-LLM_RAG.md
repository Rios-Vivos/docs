# Feature: Búsqueda de documentos con LLMs

**Status:** Implemented capability. This feature depends on the document
repository and does not authorize access to documents by itself.

## Scope

RAG assists users in finding relevant information from the documents made
available to the feature. It is a retrieval and synthesis capability, not an
authority that can invent facts, grant access, or replace the source document.

## Current behavior

- Users can use the RAG capability to locate relevant information across its
  configured document corpus.
- Results must be grounded in the retrieved material and retain a usable link
  or reference to the source where the user is permitted to see it.
- The feature is intended for internal knowledge use; public exposure requires
  a separate approval and access review.

## Rules

- Source permissions are evaluated before retrieval and must also apply to
  snippets, citations, generated answers, and cached results.
- An answer must clearly distinguish source-supported content from uncertainty
  or missing information; it must not fabricate a source or present a result as
  an official decision without evidence.
- Sensitive information, credentials, and unapproved personal data are not
  valid corpus material.
- Corpus updates and removals must be reflected in retrieval behavior through
  the configured reindex/update process.

## Verification

Test a question with a known source, a question with no supported source, and
an access-denied document. Verify that answers preserve source traceability and
do not reveal unauthorized titles, snippets, or metadata.

## Future boundary

The canonical requirements for a governed upload/download repository, richer
metadata, and future RAG expansion are in the
[Document repository roadmap](Review-Document_Repository_and_RAG.md). Update
that roadmap for new repository scope rather than creating a second RAG
specification.
