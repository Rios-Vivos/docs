# Feature: Self-hosted RAG for environmental documents

**Status:** Proposed architecture; no runtime feature is implemented by this
record.

**Source issue:** [RAG analysis #119](https://github.com/Rios-Vivos/web-page/issues/119)
(administratively filed in `web-page`; the owning documentation project is
`docs`).

**Runtime owner when approved:** `system-api`. **Dependent clients:**
`system-admin` and, only if separately approved, `web-page`.

## Purpose and boundaries

Ríos Vivos needs an internal capability to ingest a large and growing corpus of
environmental documents, then answer questions using only the documents that
the requesting person is authorized to read. Every answer must identify the
supporting document, version, and location in that document so the person can
verify it.

This is a technical proposal, not an API contract or implementation plan. The
current `system-api` code was checked on 2026-10-04 and contains no RAG, LLM,
embedding, or vector-search implementation. Consequently, the previous
"implemented" status must not be inferred from this record.

The first release is internal only. It does not train a model on Ríos Vivos
documents, make documents public, replace a document repository, or make the
model an authority on environmental or legal conclusions.

The governing repository requirements—metadata, uploads, downloads, retention,
and access policy—remain in the
[Document repository roadmap](Review-Document_Repository_and_RAG.md). This
record is the canonical technical design for RAG.

## Design at a glance

[Architecture diagram (PlantUML)](../plantuml/rag-architecture.plantuml)
shows the trust boundaries and durable data flows. [Async workflow diagram
(PlantUML)](../plantuml/rag-async-workflow.plantuml) shows why a slow upload,
reindex, or answer never holds an HTTP request open.

1. The application authenticates the caller and authorizes the document action
   in `system-api` before it can enqueue an ingestion or question job.
2. Redis (or an equivalent durable queue) carries idempotent jobs to a worker
   on the dedicated AI host. The API immediately returns a job identifier;
   clients receive progress through an authenticated WebSocket and can fall
   back to polling.
3. The worker extracts text, creates chunks and multilingual embeddings, and
   stores only searchable chunk vectors in the vector index. Original files
   live in S3 or on the AI host disk; metadata, ACLs, job state, and audit
   events remain in PostgreSQL.
4. For a question, the API determines the caller's permitted document versions
   before vector retrieval. The worker retrieves only from that allow-list,
   optionally reranks the results, and asks a local model to answer from those
   passages. It returns a structured answer with citations, or an explicit
   "not supported by authorized sources" outcome.

The AI host must be on a private network. It accepts work from the API through
an authenticated, encrypted channel; it is not an Internet-facing document
server.

## Source storage and lifecycle

| Concern | Required approach |
| --- | --- |
| Source of truth | Choose one per environment: an encrypted private S3 bucket or an encrypted directory on the AI host. The vector index is a derived cache, never the only copy of a document. |
| Local-disk option | Lowest incremental cost when the host has reliable SSD capacity. It requires monitored free space, a tested encrypted off-host backup, and replacement/recovery procedures. |
| S3 option | Keeps the AI host replaceable and simplifies durable backups. Use private objects, versioning/retention chosen by policy, server-side encryption, and short-lived authorized downloads; do not make a bucket public for RAG. |
| Ingestion | Validate MIME type and size, malware-scan where available, calculate a SHA-256 checksum, preserve the source version, and retain extraction errors for review. Unsupported or scanned-failed files never enter the index. |
| Update/remove | A new file version creates a new versioned ingestion job. Revocation immediately removes the version from authorization and retrieval; a worker then deletes vectors and derived text. Record the outcome and preserve only what retention policy requires. |

Each chunk must retain `document_id`, `document_version`, checksum, source
location, page/section (when extraction can provide it), model version, and
chunking version. These fields make a citation reproducible and make a changed
embedding model or chunking policy reindexable.

## Asynchronous jobs and live status

Use two queues: `document-ingestion` and `rag-query`. Every job has a stable
idempotency key (`document-id:version:checksum` for ingestion; a generated
request ID for questions), a requesting user, timestamps, retry count, and a
terminal result. A worker must tolerate duplicate delivery.

| Job | States exposed to the client | Terminal result |
| --- | --- | --- |
| Upload/reindex | `queued` → `validating` → `extracting` → `chunking` → `embedding` → `indexing` | `completed`, `failed`, or `cancelled`, with document version and error category |
| Question | `queued` → `authorizing` → `retrieving` → `reranking` (optional) → `generating` | `completed`, `not-supported`, `denied`, `failed`, or `cancelled`, with citations |
| Delete/revoke | `queued` → `revoked` → `purging-derived-data` | `completed` or `failed`; retrieval remains denied from the first state |

The conceptual interaction is `POST …/jobs` → `202 Accepted` with `jobId`,
then authenticated `GET …/jobs/{jobId}` and a WebSocket event channel scoped to
that owner or authorized administrator. WebSockets improve progress reporting;
they are not the source of truth, so reconnection must read the stored job
state. Exact route names and payloads are deliberately deferred to the API
implementation issue.

## Retrieval, answer, and citation rules

- Authorization happens twice: the API authorizes the action and computes an
  allowed document/version set; the worker applies that set as a mandatory
  retrieval filter. A vector database ACL alone is not sufficient.
- The model receives the question plus retrieved, authorized passages—not the
  whole corpus. Its instruction requires it to say when the passages do not
  support an answer and prohibits invented citations.
- A successful result contains an answer, retrieval/model versions, and one or
  more citations. Each citation has document title, immutable version or
  checksum, page/section or chunk locator, quoted supporting excerpt, and an
  authorized download/view link.
- Search results, snippets, generated answers, queue messages, and caches use
  the same ACL and retention rules as the source document. Caches are keyed by
  user access scope and are invalidated on permission or version change.
- Log document and version identifiers, job state, model versions, latency, and
  failures. Do not log complete sensitive documents or prompts by default.

## Self-hosted model and hardware plan

The supplied host is a fourth-generation Intel Core i7 with a GeForce GTX 680.
Its RAM, SSD capacity, and the card's exact VRAM must be inventoried before a
pilot. NVIDIA lists the GTX 680 as legacy CUDA compute capability 3.0
([NVIDIA legacy GPU table](https://developer.nvidia.com/cuda/gpus/legacy)).
The proposal therefore treats the GPU as an optional experiment, not a
dependency: current model runtimes and CUDA packages may not reliably support
it. The baseline is CPU-first and asynchronous.

| Component | Pilot choice | Constraint on the supplied host |
| --- | --- | --- |
| Text extraction | CPU workers for PDF/Office/text extraction; OCR only for scanned pages | Keep OCR in the queue and cap concurrency to one until measured. |
| Embeddings | A small multilingual embedding model served locally (for example, the E5-small class) | Appropriate for CPU batching; benchmark Spanish and environmental terminology before selection. |
| Vector search | A self-hosted vector store on the AI host, with metadata filters and persistent backups | Size disk for original files, extracted text, vectors, and a backup; do not depend on GPU VRAM. |
| Answer generation | A locally served 1.5B–3B instruction model in a quantized CPU format, restricted to one active generation job | It may be slow on a fourth-generation CPU. Queueing makes this acceptable for a pilot but does not create interactive-chat latency. |
| GTX 680 | Optional legacy acceleration trial only | Do not spend implementation time making the design depend on it. A modern supported GPU is a later scaling decision, justified by measured queue wait and answer quality. |

Before loading the corpus, verify at least 16 GB usable RAM, healthy SSD space
for the planned corpus plus backups, sustained thermal operation, and a power
measurement. If those checks fail, run extraction/embedding on a newer
CPU/GPU host rather than weakening the provenance and access controls.

## Cost baseline and in-house value

The cost comparison is intentionally transparent rather than a claim of
equal performance. A modern cloud GPU is a useful spend baseline; the GTX 680
is not equivalent to it. Reprice in the selected AWS region and with the
current electricity tariff before approval.

| Scenario | Illustrative monthly cost (USD) | What it shows |
| --- | ---: | --- |
| Existing AI host, incremental power only | `watts ÷ 1,000 × 730 × local tariff` | At a measured/assumed 100 W and $0.15/kWh, this is **$10.95/month**. Hardware purchase, backup media, and support time are excluded. |
| Always-on cloud GPU reference | `0.526 × 730 = $383.98/month` | A g4dn.xlarge reference in US East has 4 vCPU, 16 GiB memory, and one GPU; AWS documents the instance family and its regional pricing basis ([AWS G4](https://aws.amazon.com/ec2/instance-types/g4/)). The $0.526/hour reference is illustrative and must be repriced ([AWS example](https://aws.amazon.com/blogs/machine-learning/bert-inference-on-g4-instances-using-apache-mxnet-and-gluonnlp-1-million-requests-for-20-cents/)). Storage, egress, backups, and operations are extra. |
| Private S3 source storage | `GB stored × $0.023` | 100 GB is about **$2.30/month** and 1 TB about **$23/month** before requests, transfer, versioning, or retrieval. AWS notes that S3 Standard storage pricing excludes those additional charges ([AWS cost guide](https://docs.aws.amazon.com/es_es/cost-management/latest/userguide/cost-management-guide.pdf)). |

With sunk hardware and the 100 W/$0.15 assumption, avoiding an always-on
cloud-GPU reference avoids roughly **$373/month** of compute spend before
storage, backup, electricity variation, and labor. The financial value is
strongest for a steady internal workload: documents remain local, incremental
cost is mostly power and maintenance, and slow jobs can run off the request
path. It is not a reason to run unsupported GPU software or omit backups.

## Pilot, measurement, and decision gates

Run a bounded internal pilot before any broad import: a representative sample
of permitted environmental documents, at least 50 questions with known
supporting passages, and negative/access-denied cases. Record results by
document type and language.

| Gate | Evidence required to proceed |
| --- | --- |
| Grounding | Reviewers find every accepted answer's citation, version, and cited passage; unsupported questions return `not-supported` rather than a fabricated answer. |
| Security | A user without access cannot discover a document through search, citation, job status, cache, or WebSocket event. Revoke/update tests remove retrieval access immediately. |
| Operations | Queue depth, wait time, job duration by stage, retry/failure rate, index size, disk free space, host temperature/power, and backup/restore are measured. |
| Quality | Establish target recall@k and citation correctness from the 50-question set before comparing models or chunk sizes. Human reviewers rate answer usefulness separately from retrieval correctness. |
| Cost | Compare measured host power and operator time with a current cloud estimate for the same monthly document and query volume. |

Scale only after these gates pass. If response time becomes a problem, first
add workers or a supported GPU to the self-hosted host; preserve the queue,
job, authorization, citation, and storage contracts so that upgrade does not
change user-visible trust guarantees.
