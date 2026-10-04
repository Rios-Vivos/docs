# Feature: Donations, invoicing, and financial administration

**Status:** Collaboration intake is implemented; payment, invoice, and finance
automation remain planned and require institutional approval.

**Owning repositories:** `web-page`, `system-api`, `system-admin`.

**Source issues:** [donation module](https://github.com/Rios-Vivos/web-page/issues/9), [invoice workflow](https://github.com/Rios-Vivos/web-page/issues/10), [invoice email](https://github.com/Rios-Vivos/web-page/issues/11), [Stripe](https://github.com/Rios-Vivos/web-page/issues/106), [invoice module](https://github.com/Rios-Vivos/web-page/issues/107), and [financial analysis](https://github.com/Rios-Vivos/web-page/issues/108).

## Scope

Support a donor journey from intent to payment, receipt/invoice request,
reconciliation, and restricted reporting without treating payment-provider
events as trustworthy until verified server-side.

## Required decisions before implementation

- Confirm the legal entity, bank account, fiscal receipt process, retention
  requirements, approved provider account, currencies, and refund policy.
- Choose one enabled payment path at a time using feature flags; preserve the
  existing collaboration form when automated payment is unavailable.
- Define donation states, provider webhook verification, idempotency keys,
  reconciliation ownership, and manual exception handling.

## Rules

- Never collect or store card data in Ríos Vivos systems.
- Webhooks are authenticated, replay-safe, logged, and reconciled by the API.
- Invoice/receipt generation requires the minimum justified personal data and
  an auditable relationship to the donation or approved manual record.
- Financial reports and manual invoice actions are limited to authorized roles;
  aggregate public reporting must not expose donor data.

## Acceptance checks

- A payment event can be processed repeatedly without duplicate donations or
  invoices.
- Failed, pending, refunded, and manually reconciled payments have visible,
  auditable states.
- Invoice email is sent only after a valid record exists and failures are safe
  to retry without duplicating documents.
