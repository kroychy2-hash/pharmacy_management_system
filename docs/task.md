# PharmaCore ERP — Project To-Do List

## Phase 1 — MVP Build (10-14 weeks)

### Week 1-2: Project Setup
- [x] Turborepo monorepo configured
- [x] NestJS backend app setup
- [x] Next.js frontend app setup
- [x] Local MySQL + Redis configured
- [x] Prisma schema with core tables defined
- [x] First migration applied
- [x] GitHub Actions CI pipeline configured

### Week 3-4: Authentication
- [x] Phone + password login API
- [x] JWT + refresh token implementation
- [x] RBAC permission guard
- [x] Branch-scoped access
- [x] Login screen UI (Next.js)
- [x] Protected route middleware

### Week 5-6: Inventory Master
- [ ] Medicine CRUD (name, generic, brand, form, strength)
- [ ] Barcode generation
- [ ] Category management
- [ ] Batch entry (batch no, mfg/exp date, purchase price, MRP)
- [ ] Real-time stock levels tracking

### Week 7-9: POS Billing
- [ ] Split panel layout (Search/Cart + Payment)
- [ ] Product search functionality (Elasticsearch / local)
- [ ] Keyboard Shortcuts implementation (F1, F2, F9, F10, etc.)
- [ ] Offline resilience mechanism for search

### Week 10-11: Payment & Invoicing
- [ ] Payment flow integration (cash, digital, etc.)
- [ ] Invoice generation (Puppeteer PDF)
- [ ] Thermal printer compatibility (A5 format)

### Week 12-14: Basic Reports + Polish
- [ ] Daily sales summary report
- [ ] Stock balance sheet
- [ ] Low stock report
- [ ] Expiry report (next 30/60/90 days)
- [ ] Customer due report

---

## Phase 2 — Business Core (8-10 weeks)

### Purchase Module
- [ ] Purchase Order (PO) workflow
- [ ] GRN (Goods Received Note) implementation
- [ ] Purchase Return / Debit Note workflow

### Accounting Module
- [ ] Chart of Accounts implementation
- [ ] Supplier & Customer due tracking

### DGDA Compliance Module
- [ ] Automatic daily narcotic balance sheet generation
- [ ] Prescription validation for scheduled drugs
- [ ] Monthly DGDA return reports

---

## Phase 3 — Growth Layer (12-16 weeks)

### AI Demand Forecasting
- [ ] Time-series demand model (Prophet/LSTM)
- [ ] Reorder suggestions based on forecast

### Mobile & Integrations
- [ ] Flutter Mobile App implementation
- [ ] Offline sync engine
- [ ] WhatsApp Integration for invoices and reminders
- [ ] E-commerce module integration

---

## Phase 4 — Enterprise & SaaS

### Multi-tenant SaaS
- [ ] Automated tenant onboarding (provisioning)
- [ ] Subscription & Billing plans (Starter, Pro, Enterprise)
- [ ] Tenant-specific data isolation and security

### Advanced Features
- [ ] Plugin marketplace ecosystem
- [ ] White-labeling support
- [ ] Data Migration System (Excel/CSV import for new customers)

---

## Missing Gaps (Critical Tasks)
- [ ] Offline conflict resolution strategy (sync queues, retries)
- [ ] MRP enforcement in code (validate sale price against MRP)
- [ ] Supplier Return & Debit Notes end-to-end workflow
