# Feature: Document repository and internal chat pilot

**Status:** Proposal only. This document does not implement a feature.

**Source issues:** [RAG analysis #119](https://github.com/Rios-Vivos/web-page/issues/119)
and [academic CSV/Excel access #83](https://github.com/Rios-Vivos/web-page/issues/83).
The work belongs in `docs`; the future backend work belongs in `system-api`.

## Goal

Let internal Ríos Vivos users upload many environmental documents and ask about
them in a chat. Every answer must show the document, version, and page or text
part used for the answer. A user may only search documents that they are
allowed to open.

This is a pilot. It uses the computer already available: a fourth-generation
Intel Core i7 with a GTX 680. The GTX 680 is useful because it already exists,
but the pilot must work without depending on it. Results from the pilot decide
whether newer hardware is worth buying.

## Repository rules

- Each file has an owner, source, type, visibility, license/consent state,
  upload date, version, checksum, and retention decision.
- Validate file type and size before storage. Scan for malware where the
  platform supports it. Do not store files in application source control.
- Internal, academic, public, and restricted files use explicit permissions.
  A chat answer, source quote, search result, or status event must never show
  information from a file the user cannot open.
- CSV and Excel files made available for download stay separate from live
  monitoring ingestion. Their source and version remain visible.

## Use the existing admin pages

No new admin screens are needed for the pilot.

| User need | Existing page | Pilot change |
| --- | --- | --- |
| Upload and manage documents | [`/dashboard/management/rag/`](https://admin.riosvivos.org/dashboard/management/rag/) | Keep this page as the place where users add, replace, and remove documents. Show the processing status for each file. |
| Ask about documents | [`/dashboard/rag/`](https://admin.riosvivos.org/dashboard/rag/) | Keep the current chat layout. A question may take time; show its status in the chat, then show the answer and source links. |

The checked `system-admin` code confirms that the first page uses
`MediaFileManagerView` and the second page reuses `ChatView`. The checked
`system-api` main branch has no RAG, local-model, or document-search backend
yet. The pages are the UI starting point, not proof that the feature works.

## Simple system picture

![Document chat pilot architecture](../img/rag-architecture.png)

[Editable source for this diagram](../plantuml/rag-architecture.plantuml)

1. A user uploads a file in the existing management page, or sends a question
   in the existing chat.
2. `system-api` checks who the user is and what files they can access. It saves
   the task and returns quickly.
3. A queue is a waiting list for slow tasks. The AI computer takes the next
   task when it is ready.
4. For a file, the AI computer reads it and makes a **search index**: a fast
   list of small pieces of text linked to the original file and page.
5. For a question, it searches only the allowed document pieces and, when the
   question needs monitoring data, reads an approved report view. A local model
   writes an answer from those sources.
6. The chat shows the answer plus links to the exact source documents. File
   and question progress are sent back to the page; after reconnecting, the
   page can also ask the API for the saved status.

The AI computer is private. It is not a public website and must only accept
work from `system-api` over an authenticated encrypted connection.

## Connect the API and AI computer

Use a self-hosted **WireGuard VPN**. It gives the API network and the local AI
computer private addresses so they can talk safely. It does not make the AI
computer public or route normal website traffic through it.

| Part | Pilot setup |
| --- | --- |
| API side | A WireGuard peer on a small gateway in the API network/VPC with a fixed public address. |
| AI-computer side | A WireGuard peer on the local Linux computer. It starts the connection, so it works behind a home/office router. |
| Allowed network traffic | The AI worker can call only the private RAG API and the dedicated reporting database endpoint. Do not expose its model service, search database, SSH, Redis, MQTT, Grafana, or file storage to the public Internet. |
| Extra protection | Keep HTTPS and a separate worker credential (or mutual TLS) inside the VPN. The worker credential can be removed without rebuilding the VPN. |

WireGuard is the recommended long-term choice because Ríos Vivos controls both
peers and their keys ([quick start](https://www.wireguard.com/quickstart/)).
Tailscale is an acceptable faster pilot alternative: it uses WireGuard but
adds a managed control plane for keys and routes ([site-to-site guide](https://tailscale.com/docs/features/site-to-site)).

### Keep the task queue in the API network

`system-api` creates upload and question jobs with Redis + BullMQ. The local
computer does **not** connect to Redis. Instead, it asks a private RAG task
endpoint for one approved job through the VPN, then sends progress and results
back through that same endpoint.

This keeps the queue, user permissions, and job history near the API. BullMQ
handles workers, retries, and progress; the API controls which task the local
machine can claim ([BullMQ workers](https://docs.bullmq.io/guide/workers/)).
Existing Sails/WebSocket support then sends the saved job status to the current
chat and upload pages. Polling the API still works after a page refresh.

### Use reporting views for accurate monitoring answers

The chat needs current monitoring information, but the AI computer must not
have broad access to the production database. Add a `rag_reporting` schema of
versioned PostgreSQL **views**. Each view is a reviewed, read-only report built
from the monitoring tables—for example: latest reading by station, readings in
a date range, station health, and an approved monthly summary.

| Rule | Pilot choice |
| --- | --- |
| Database account | Create `rag_report_reader`: `SELECT` only on the approved `rag_reporting` views. No access to base tables, other schemas, writes, DDL, or database administration. |
| Network | Allow this account to reach PostgreSQL only from the AI host's WireGuard address. Keep port 5432 closed to the public Internet. |
| Query method | The worker calls named report queries with validated parameters such as station ID and date range. The model never writes its own SQL. |
| Answer source | The chat cites the report-view name, selected station/time range, and the report generation time alongside document citations. |
| Change control | `system-api` owns the views, migrations, tests, units, and permissions. Add a view only after its meaning has been reviewed with the monitoring owner. |

This gives the model accurate, current data without making it a database user
with free access. The reports are a second source type: document answers cite
documents; data answers cite report views; a combined answer must show both.

### File connection

For the pilot, use private S3 as the original-file store and local disk as the
AI computer's working copy and search-index location. The management page
uploads through `system-api`; after the worker claims a job through the VPN,
the API gives it a short-lived read URL for that one file version. The S3 bucket
stays private. A local-disk-only source store can come later, but only with an
encrypted, tested off-site backup.

## Recommended pilot tools

| Need | Recommended tool | Pilot role |
| --- | --- | --- |
| Public backend and access checks | Existing Sails.js `system-api` | Owns users, permissions, jobs, source links, report views, and WebSocket messages. |
| Background jobs | Redis + BullMQ | Holds upload and question jobs, retries failures, and records progress. |
| Local worker | Python 3.12 service in Docker Compose | Claims work over the VPN, calls local tools, and returns results. A small FastAPI health endpoint is enough; it is private. |
| Read documents | Docling | Reads PDF, Office, HTML, CSV, and images into text with page information where available ([formats](https://docling-project.github.io/docling/usage/supported_formats/)). |
| Search document text | Qdrant on the AI computer | Stores the search index and filters by file/version IDs sent by the API ([filtering](https://qdrant.tech/documentation/search/filtering/)). |
| Write answers | `llama.cpp` server on the AI computer | Runs compressed local models on CPU and provides a local chat API ([server](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)). |
| Local services | Docker Compose | Starts the worker, Qdrant, and model server with restart rules and local volumes. |
| Private network | WireGuard | Gives the API gateway and AI computer private addresses. |

Do not add a broad AI framework such as LangChain in the first pilot. The flow
is short enough to write directly: read file → prepare search entries → find
entries or read a report view → ask local model → return sources. This makes
failures and sources easy to inspect.

## Model choices to test

| Job | Start with | Compare later | Why |
| --- | --- | --- | --- |
| Make search entries | `intfloat/multilingual-e5-small` | `BAAI/bge-m3` | E5-small is lighter for the old CPU. BGE-M3 supports multilingual and longer-text search, but is heavier ([model card](https://huggingface.co/BAAI/bge-m3)). |
| Write an answer | `Qwen2.5-1.5B-Instruct` in GGUF Q4 format | A 3B GGUF model if RAM and wait time allow | A 1.5B model is a reasonable CPU-first start. It must answer only from returned documents and reports. |
| Read scanned pages | Docling OCR path | Tesseract-only fallback | OCR stays a background task because it is slower than normal PDF text extraction. |

`llama.cpp` is preferred over a GPU-only runtime because it can run compressed
models on CPU. Try the GTX 680 only if the installed software supports it; it
is not a dependency. Start with one answer job at a time and measure memory,
temperature, queue wait, and answer time.

## What users see

![Asynchronous upload and chat flow](../img/rag-async-workflow.png)

[Editable source for this diagram](../plantuml/rag-async-workflow.plantuml)

| Action | What the user sees | Final result |
| --- | --- | --- |
| Upload or replace a file | `Waiting`, `Reading file`, `Preparing search`, then `Ready` | The file version is ready to search, or the page explains why it failed. |
| Remove a file | `Removing from search` | It can no longer appear in answers before its derived search data is deleted. |
| Ask in chat | The new chat message shows `Preparing answer` | An answer with source cards, or `I could not find support for this in the documents you can access.` |

WebSockets send live progress to an open page. The saved task status remains
the reliable record, so polling still works after a refresh or connection loss.

## Files, permissions, and sources

| Item | Pilot choice |
| --- | --- |
| Original files | Store them in one private place: either a private S3 bucket or encrypted disk on the AI computer. Do not make either location public. |
| File information | PostgreSQL stores the file name, owner, allowed users/roles, version, checksum, upload date, and task status. |
| Search index | Keep it on the AI computer. It is derived from the files and can be rebuilt; it is not the only copy of a file. |
| Source shown in chat | Each source card includes title, file version, page or section when available, a short supporting quote, and an authorized open/download link. |
| File update or removal | A new version creates a new background task. Removing access hides the file from search immediately, then deletes its derived text and search entries. |

`system-api` must check permission before creating a task and again when the
AI computer searches. Search results, chat answers, source quotes, status
events, and cached results must follow the same file permissions.

## Pilot model and machine

| Part | Pilot approach |
| --- | --- |
| Read files | Use the CPU to read PDF, Office, and text files. Run OCR for scanned pages as a background task. |
| Find text | Run a small multilingual model locally to create the search index. Test it with Spanish and the environmental terms used by Ríos Vivos. |
| Write answers | Run a small local model in a compressed format, one answer at a time. It may be slow; the queue and chat status handle that honestly. |
| GTX 680 | Try it only if the installed software supports it. NVIDIA classifies it as legacy CUDA compute capability 3.0 ([NVIDIA table](https://developer.nvidia.com/cuda/gpus/legacy)), so the pilot cannot rely on it. |

Before importing many files, confirm at least 16 GB usable RAM, enough healthy
SSD space for files, the search index, and backups, and safe temperatures
during a long task. Record real power use. If the pilot shows that answers or
file processing wait too long, use the same design with a newer GPU or CPU;
the chat and stored files do not need to change.

## Cost picture

The existing computer has no new purchase cost for the pilot. Its monthly power
cost is:

`watts ÷ 1,000 × 730 × local electricity price`

For example, 100 W at $0.15/kWh costs **$10.95 per month**. Measure the actual
number before using it for a budget.

For comparison only, an always-on AWS `g4dn.xlarge` cloud GPU reference at
$0.526/hour is about **$383.98/month** (`0.526 × 730`). It is faster hardware,
not an equal GTX 680 comparison; storage, backup, transfer, and operator time
are extra. Recheck the selected region before approval ([AWS G4
instances](https://aws.amazon.com/ec2/instance-types/g4/)).

Private S3 storage is also separate: at $0.023/GB-month, 100 GB is about
**$2.30/month** and 1 TB about **$23/month**, before requests, transfers, or
file versions ([AWS cost guide](https://docs.aws.amazon.com/es_es/cost-management/latest/userguide/cost-management-guide.pdf)).

The value of the in-house pilot is simple: it tests whether the existing
machine can answer the real internal workload before Ríos Vivos pays a monthly
cloud GPU bill or buys new hardware.

## Pilot checks

Start with a representative set of allowed environmental documents and 50
questions where reviewers know the supporting text.

- Every accepted answer must lead reviewers to the correct file, version, and
  supporting page or text part.
- A user without permission must not see a file name, quote, answer, task
  status, or source link for that file.
- Record upload time, processing time, queue wait, answer time, failed tasks,
  disk space, temperature, power, and backup/restore results.
- Reviewers rate whether the answer is useful and whether its sources really
  support it. An answer without support must say so.

Use those results to decide whether to keep the CPU-first host, add supported
hardware, or use cloud compute. Do not move to a broad import until the source
links, permission checks, backup, and measured cost are accepted.
