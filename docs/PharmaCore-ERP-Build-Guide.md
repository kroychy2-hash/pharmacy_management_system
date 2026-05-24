# ⚕ PharmaCore ERP — Complete Build Guide
> **Enterprise Pharmacy Management System** · Multi-Branch · SaaS · Plugin-First · AI-Powered

---

## 🗺 Table of Contents

1. [Vision & Philosophy](#vision)
2. [System Architecture](#architecture)
3. [Tech Stack (Final)](#tech-stack)
4. [Folder Structure](#folder-structure)
5. [Database Schema](#database-schema)
6. [Module Build Order](#module-order)
7. [Phase 1 — MVP Build](#phase-1)
8. [Phase 2 — Business Core](#phase-2)
9. [Phase 3 — Growth Layer](#phase-3)
10. [Phase 4 — Enterprise & SaaS](#phase-4)
11. [UI/UX Design System](#ui-ux)
12. [API Design Standards](#api-design)
13. [Security Checklist](#security)
14. [Plugin System](#plugin-system)
15. [DevOps & Deployment](#devops)
16. [Missing Gaps (Critical)](#missing-gaps)
17. [Team Structure](#team-structure)
18. [Timeline Estimate](#timeline)

---

## 1. Vision & Philosophy {#vision}

```
"Simple pharmacy software নয় — এটা একটি full enterprise OS for healthcare retail."
```

### Core Principles

| Principle | Meaning |
|-----------|---------|
| **API-First** | Every feature must have an API before a UI |
| **Plugin-First** | Core system lean, features as installable plugins |
| **Offline-First** | POS must work without internet |
| **Compliance-First** | DGDA rules enforced at code level, not policy level |
| **Tenant-First** | Every query scoped by `tenant_id` from day one |

### What This System Is NOT
- ❌ A simple billing software
- ❌ A glorified Excel sheet
- ❌ A monolith that breaks at 10 branches

### What This System IS
- ✅ An enterprise ERP for pharmacy chains
- ✅ A SaaS platform for 1 to 10,000 pharmacies
- ✅ A plugin marketplace ecosystem
- ✅ A compliance engine for Bangladesh drug regulations

---

## 2. System Architecture {#architecture}

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                              │
│  Next.js Web App    Flutter Mobile    Third-party via API        │
└──────────────────────────┬──────────────────────────────────────┘
                           │ HTTPS / WSS
┌──────────────────────────▼──────────────────────────────────────┐
│                      API GATEWAY                                 │
│  Rate Limiting · Auth Validation · Routing · Request Logging     │
└───┬───────┬────────┬────────┬────────┬────────┬────────┬────────┘
    │       │        │        │        │        │        │
┌───▼──┐ ┌──▼──┐ ┌───▼─┐ ┌───▼─┐ ┌───▼─┐ ┌───▼─┐ ┌────▼───┐
│ Auth │ │Inv. │ │Sales│ │Purch│ │Acct │ │ HR  │ │Reports │
│ Svc  │ │ Svc │ │ Svc │ │ Svc │ │ Svc │ │ Svc │ │  Svc   │
└──────┘ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘ └────────┘
    │       │        │        │        │        │        │
┌───▼───────▼────────▼────────▼────────▼────────▼────────▼───────┐
│                    EVENT BUS (Kafka / RabbitMQ)                  │
└─────────────────────────────────────────────────────────────────┘
    │           │           │            │
┌───▼──┐   ┌───▼──┐   ┌────▼────┐  ┌───▼───────┐
│ PG   │   │Redis │   │Elastic  │  │File Store  │
│ DB   │   │Cache │   │Search   │  │(S3/MinIO)  │
└──────┘   └──────┘   └─────────┘  └───────────┘
```

### Architecture Decision: Modular Monolith → Microservices

> **MVP তে Modular Monolith দিয়ে শুরু করুন।** NestJS-এর module system এটাকে পরে microservices-এ split করতে সাহায্য করবে। Day 1 থেকে microservices করলে complexity 10x বেড়ে যাবে।

```
MVP (0-6 months)     → Modular Monolith (NestJS modules)
Growth (6-18 months) → Extract hot services (Inventory, Sales, Auth)
Scale (18+ months)   → Full microservices with Kubernetes
```

---

## 3. Tech Stack (Final) {#tech-stack}

### Backend

```yaml
Runtime:        Node.js 20 LTS
Framework:      NestJS 10
Language:       TypeScript 5.x
ORM:            Prisma (type-safe, migration support)
Validation:     Zod + class-validator
API:            REST + GraphQL (Apollo)
Auth:           Passport.js + JWT + refresh tokens
Queue:          BullMQ (Redis-backed)
Events:         EventEmitter2 (MVP) → Kafka (scale)
File Upload:    Multer + S3/MinIO
PDF:            Puppeteer (invoice generation)
Email:          Nodemailer + SES
SMS:            Bangladesh: SSL Wireless, Infobip
```

### Frontend

```yaml
Framework:      Next.js 14 (App Router)
Language:       TypeScript
Styling:        Tailwind CSS + shadcn/ui
State:          Zustand (global) + TanStack Query (server state)
Forms:          React Hook Form + Zod
Charts:         Recharts + D3.js (advanced)
Tables:         TanStack Table
Icons:          Lucide React
Animations:     Framer Motion
POS UI:         Custom (optimized for touch + keyboard)
```

### Mobile

```yaml
Framework:      Flutter 3.x
State:          Riverpod
Local DB:       SQLite (Drift) — offline support
Sync:           Custom delta sync engine
```

### Infrastructure

```yaml
Database:       PostgreSQL 16 (primary)
Cache:          Redis 7 (sessions, queues, rate limit)
Search:         Elasticsearch 8 (medicine search, analytics)
Object Store:   MinIO (self-hosted) / AWS S3
Container:      Docker + Docker Compose (dev), Kubernetes (prod)
Reverse Proxy:  Nginx
CDN:            Cloudflare
Monitoring:     Prometheus + Grafana
Logging:        ELK Stack (Elasticsearch + Logstash + Kibana)
Error Track:    Sentry
CI/CD:          GitHub Actions
IaC:            Terraform (AWS/GCP)
```

---

## 4. Folder Structure {#folder-structure}

```
pharmacore/
├── apps/
│   ├── api/                          # NestJS Backend (Monolith)
│   │   ├── src/
│   │   │   ├── modules/
│   │   │   │   ├── auth/
│   │   │   │   │   ├── auth.module.ts
│   │   │   │   │   ├── auth.controller.ts
│   │   │   │   │   ├── auth.service.ts
│   │   │   │   │   ├── strategies/
│   │   │   │   │   │   ├── jwt.strategy.ts
│   │   │   │   │   │   └── local.strategy.ts
│   │   │   │   │   └── guards/
│   │   │   │   ├── inventory/
│   │   │   │   │   ├── medicines/
│   │   │   │   │   ├── batches/
│   │   │   │   │   ├── stock-movements/
│   │   │   │   │   └── warehouses/
│   │   │   │   ├── sales/
│   │   │   │   │   ├── pos/
│   │   │   │   │   ├── invoices/
│   │   │   │   │   └── returns/
│   │   │   │   ├── purchase/
│   │   │   │   │   ├── suppliers/
│   │   │   │   │   ├── purchase-orders/
│   │   │   │   │   └── grn/
│   │   │   │   ├── accounting/
│   │   │   │   │   ├── ledger/
│   │   │   │   │   ├── transactions/
│   │   │   │   │   └── reports/
│   │   │   │   ├── crm/
│   │   │   │   │   ├── customers/
│   │   │   │   │   ├── loyalty/
│   │   │   │   │   └── campaigns/
│   │   │   │   ├── hr/
│   │   │   │   │   ├── employees/
│   │   │   │   │   ├── attendance/
│   │   │   │   │   └── payroll/
│   │   │   │   ├── compliance/           # NEW — DGDA, drug register
│   │   │   │   │   ├── drug-register/
│   │   │   │   │   ├── narcotic-balance/
│   │   │   │   │   └── license-tracker/
│   │   │   │   ├── notifications/
│   │   │   │   ├── reports/
│   │   │   │   ├── plugins/
│   │   │   │   └── tenant/
│   │   │   ├── common/
│   │   │   │   ├── decorators/
│   │   │   │   ├── filters/             # Exception filters
│   │   │   │   ├── guards/
│   │   │   │   ├── interceptors/
│   │   │   │   ├── pipes/
│   │   │   │   └── middleware/
│   │   │   ├── config/
│   │   │   │   ├── app.config.ts
│   │   │   │   ├── database.config.ts
│   │   │   │   └── redis.config.ts
│   │   │   ├── database/
│   │   │   │   ├── prisma.service.ts
│   │   │   │   └── seed/
│   │   │   └── main.ts
│   │   ├── prisma/
│   │   │   ├── schema.prisma
│   │   │   └── migrations/
│   │   └── test/
│   │
│   ├── web/                            # Next.js Frontend
│   │   ├── app/
│   │   │   ├── (auth)/
│   │   │   │   ├── login/
│   │   │   │   └── setup/
│   │   │   ├── (dashboard)/
│   │   │   │   ├── layout.tsx
│   │   │   │   ├── page.tsx            # Main dashboard
│   │   │   │   ├── pos/
│   │   │   │   ├── inventory/
│   │   │   │   ├── purchases/
│   │   │   │   ├── sales/
│   │   │   │   ├── accounting/
│   │   │   │   ├── crm/
│   │   │   │   ├── hr/
│   │   │   │   ├── reports/
│   │   │   │   ├── compliance/
│   │   │   │   └── settings/
│   │   │   └── api/                    # Next.js API routes
│   │   ├── components/
│   │   │   ├── ui/                     # shadcn components
│   │   │   ├── pos/                    # POS-specific components
│   │   │   ├── inventory/
│   │   │   ├── charts/
│   │   │   └── shared/
│   │   ├── hooks/
│   │   ├── stores/                     # Zustand stores
│   │   ├── lib/
│   │   │   ├── api/                    # API client (axios/fetch)
│   │   │   └── utils/
│   │   └── public/
│   │
│   └── mobile/                         # Flutter App
│       ├── lib/
│       │   ├── features/
│       │   │   ├── pos/
│       │   │   ├── inventory/
│       │   │   └── attendance/
│       │   ├── core/
│       │   │   ├── database/           # Drift (SQLite)
│       │   │   ├── sync/
│       │   │   └── network/
│       │   └── main.dart
│       └── pubspec.yaml
│
├── packages/
│   ├── shared/                         # Shared TypeScript types
│   │   ├── src/
│   │   │   ├── types/
│   │   │   │   ├── medicine.types.ts
│   │   │   │   ├── invoice.types.ts
│   │   │   │   └── user.types.ts
│   │   │   └── constants/
│   │   └── package.json
│   │
│   ├── plugin-sdk/                     # Plugin development kit
│   │   ├── src/
│   │   │   ├── plugin-base.ts
│   │   │   ├── hooks.ts
│   │   │   └── types.ts
│   │   └── package.json
│   │
│   └── ui-kit/                         # Shared UI components
│       ├── src/
│       │   ├── components/
│       │   └── tokens/
│       └── package.json
│
├── plugins/                            # Official plugins
│   ├── payment-bkash/
│   ├── payment-nagad/
│   ├── sms-ssl-wireless/
│   ├── courier-pathao/
│   ├── courier-steadfast/
│   ├── accounting-tally-sync/
│   └── ai-demand-forecast/
│
├── infrastructure/
│   ├── docker/
│   │   ├── docker-compose.yml          # Dev environment
│   │   ├── docker-compose.prod.yml
│   │   └── Dockerfiles/
│   ├── kubernetes/
│   │   ├── namespaces/
│   │   ├── deployments/
│   │   ├── services/
│   │   └── ingress/
│   └── terraform/
│       ├── aws/
│       └── gcp/
│
├── docs/
│   ├── api/                            # OpenAPI specs
│   ├── architecture/
│   ├── deployment/
│   └── plugin-development/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── deploy-staging.yml
│       └── deploy-production.yml
│
├── package.json                        # Turborepo root
├── turbo.json
└── README.md
```

---

## 5. Database Schema {#database-schema}

### Core Schema Design Principles

```sql
-- Every table must have:
-- 1. id (UUID)
-- 2. tenant_id (for multi-tenancy)
-- 3. created_at, updated_at
-- 4. soft delete: deleted_at (nullable)
-- 5. created_by (user reference)
```

### Key Tables

```sql
-- ============================================
-- TENANT / MULTI-BRANCH
-- ============================================

CREATE TABLE tenants (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          VARCHAR(255) NOT NULL,
  slug          VARCHAR(100) UNIQUE NOT NULL,   -- subdomain
  plan          VARCHAR(50) DEFAULT 'starter',  -- starter|pro|enterprise
  status        VARCHAR(20) DEFAULT 'trial',
  trial_ends_at TIMESTAMP,
  settings      JSONB DEFAULT '{}',
  created_at    TIMESTAMP DEFAULT NOW(),
  updated_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE branches (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  name          VARCHAR(255) NOT NULL,
  code          VARCHAR(20),                    -- e.g., "DHK-01"
  address       TEXT,
  phone         VARCHAR(20),
  drug_license  VARCHAR(100),                   -- DGDA license number
  license_expiry DATE,
  is_head_office BOOLEAN DEFAULT false,
  settings      JSONB DEFAULT '{}',
  created_at    TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- AUTH & USERS
-- ============================================

CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  email         VARCHAR(255),
  phone         VARCHAR(20),
  password_hash VARCHAR(255),
  name          VARCHAR(255) NOT NULL,
  status        VARCHAR(20) DEFAULT 'active',
  last_login_at TIMESTAMP,
  created_at    TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, email),
  UNIQUE(tenant_id, phone)
);

CREATE TABLE roles (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID REFERENCES tenants(id),
  name        VARCHAR(100) NOT NULL,
  slug        VARCHAR(100) NOT NULL,
  permissions JSONB DEFAULT '[]',
  is_system   BOOLEAN DEFAULT false,
  created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_branch_roles (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id   UUID REFERENCES users(id),
  branch_id UUID REFERENCES branches(id),
  role_id   UUID REFERENCES roles(id),
  UNIQUE(user_id, branch_id)
);

-- ============================================
-- INVENTORY
-- ============================================

CREATE TABLE medicines (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id         UUID REFERENCES tenants(id),
  name              VARCHAR(255) NOT NULL,
  generic_name      VARCHAR(255),
  brand_name        VARCHAR(255),
  manufacturer      VARCHAR(255),
  category          VARCHAR(100),             -- antibiotic|antacid|vitamin|etc
  form              VARCHAR(50),              -- tablet|syrup|injection|cream
  strength          VARCHAR(50),             -- 500mg|10mg/5ml
  unit              VARCHAR(20),             -- pcs|ml|gm
  pack_size         INTEGER DEFAULT 1,
  barcode           VARCHAR(100),
  sku               VARCHAR(100),
  is_generic        BOOLEAN DEFAULT false,
  is_scheduled      BOOLEAN DEFAULT false,   -- controlled drug?
  schedule_class    VARCHAR(10),             -- A|B|C (Bangladesh DGDA)
  requires_rx       BOOLEAN DEFAULT false,
  mrp               DECIMAL(10,2),           -- Maximum Retail Price (govt set)
  reorder_level     INTEGER DEFAULT 10,
  reorder_qty       INTEGER DEFAULT 100,
  is_active         BOOLEAN DEFAULT true,
  created_at        TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, barcode)
);

CREATE TABLE medicine_batches (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  medicine_id     UUID REFERENCES medicines(id),
  branch_id       UUID REFERENCES branches(id),
  batch_number    VARCHAR(100) NOT NULL,
  mfg_date        DATE,
  exp_date        DATE NOT NULL,
  purchase_price  DECIMAL(10,2),
  sale_price      DECIMAL(10,2),
  mrp             DECIMAL(10,2),
  qty_in_stock    INTEGER DEFAULT 0,
  qty_sold        INTEGER DEFAULT 0,
  qty_returned    INTEGER DEFAULT 0,
  status          VARCHAR(20) DEFAULT 'active', -- active|expired|recalled
  created_at      TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, medicine_id, branch_id, batch_number)
);

CREATE TABLE stock_movements (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  batch_id      UUID REFERENCES medicine_batches(id),
  branch_id     UUID REFERENCES branches(id),
  type          VARCHAR(30) NOT NULL,  -- purchase|sale|return|transfer|adjustment|expired
  quantity      INTEGER NOT NULL,     -- positive=in, negative=out
  reference_id  UUID,                 -- invoice_id OR purchase_id
  reference_type VARCHAR(30),
  notes         TEXT,
  created_by    UUID REFERENCES users(id),
  created_at    TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- SALES & POS
-- ============================================

CREATE TABLE invoices (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  branch_id       UUID REFERENCES branches(id),
  invoice_number  VARCHAR(50) UNIQUE NOT NULL,
  invoice_date    TIMESTAMP DEFAULT NOW(),
  customer_id     UUID,                     -- nullable (walk-in)
  customer_name   VARCHAR(255),             -- for walk-in
  customer_phone  VARCHAR(20),
  prescription_id UUID,
  subtotal        DECIMAL(12,2),
  discount_amount DECIMAL(12,2) DEFAULT 0,
  vat_amount      DECIMAL(12,2) DEFAULT 0,
  total_amount    DECIMAL(12,2),
  paid_amount     DECIMAL(12,2) DEFAULT 0,
  due_amount      DECIMAL(12,2) DEFAULT 0,
  status          VARCHAR(20) DEFAULT 'paid', -- paid|partial|due|cancelled
  notes           TEXT,
  created_by      UUID REFERENCES users(id),
  created_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE invoice_items (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id    UUID REFERENCES invoices(id) ON DELETE CASCADE,
  medicine_id   UUID REFERENCES medicines(id),
  batch_id      UUID REFERENCES medicine_batches(id),
  quantity      INTEGER NOT NULL,
  unit_price    DECIMAL(10,2),
  discount_pct  DECIMAL(5,2) DEFAULT 0,
  vat_pct       DECIMAL(5,2) DEFAULT 0,
  line_total    DECIMAL(12,2)
);

CREATE TABLE payments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  invoice_id    UUID REFERENCES invoices(id),
  amount        DECIMAL(12,2),
  method        VARCHAR(30),  -- cash|card|bkash|nagad|rocket|bank_transfer
  reference     VARCHAR(100), -- transaction ID for digital payments
  status        VARCHAR(20) DEFAULT 'completed',
  paid_at       TIMESTAMP DEFAULT NOW(),
  created_by    UUID REFERENCES users(id)
);

-- ============================================
-- PURCHASE
-- ============================================

CREATE TABLE suppliers (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  name          VARCHAR(255) NOT NULL,
  company       VARCHAR(255),
  phone         VARCHAR(20),
  email         VARCHAR(255),
  address       TEXT,
  drug_license  VARCHAR(100),
  credit_limit  DECIMAL(12,2) DEFAULT 0,
  credit_days   INTEGER DEFAULT 30,
  balance       DECIMAL(12,2) DEFAULT 0,  -- outstanding due
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE purchase_orders (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  branch_id     UUID REFERENCES branches(id),
  po_number     VARCHAR(50) UNIQUE,
  supplier_id   UUID REFERENCES suppliers(id),
  status        VARCHAR(20) DEFAULT 'draft', -- draft|sent|partial|received|cancelled
  total_amount  DECIMAL(12,2),
  notes         TEXT,
  expected_date DATE,
  created_by    UUID REFERENCES users(id),
  created_at    TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- COMPLIANCE (DGDA — Bangladesh specific)
-- ============================================

CREATE TABLE controlled_drug_register (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  branch_id       UUID REFERENCES branches(id),
  medicine_id     UUID REFERENCES medicines(id),
  date            DATE NOT NULL,
  opening_balance INTEGER,
  qty_received    INTEGER DEFAULT 0,
  qty_dispensed   INTEGER DEFAULT 0,
  closing_balance INTEGER,
  remarks         TEXT,
  verified_by     UUID REFERENCES users(id),
  created_at      TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, branch_id, medicine_id, date)
);

CREATE TABLE drug_licenses (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  branch_id       UUID REFERENCES branches(id),
  license_type    VARCHAR(50),    -- retail|wholesale|import
  license_number  VARCHAR(100),
  issued_by       VARCHAR(100),   -- DGDA
  issue_date      DATE,
  expiry_date     DATE,
  document_url    VARCHAR(500),
  status          VARCHAR(20) DEFAULT 'active',
  reminder_sent   BOOLEAN DEFAULT false,
  created_at      TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- CUSTOMERS (CRM)
-- ============================================

CREATE TABLE customers (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID REFERENCES tenants(id),
  name            VARCHAR(255) NOT NULL,
  phone           VARCHAR(20),
  email           VARCHAR(255),
  address         TEXT,
  date_of_birth   DATE,
  gender          VARCHAR(10),
  loyalty_points  INTEGER DEFAULT 0,
  total_spent     DECIMAL(12,2) DEFAULT 0,
  credit_limit    DECIMAL(12,2) DEFAULT 0,
  due_balance     DECIMAL(12,2) DEFAULT 0,
  notes           TEXT,
  created_at      TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, phone)
);

-- ============================================
-- PLUGIN SYSTEM
-- ============================================

CREATE TABLE plugins (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug          VARCHAR(100) UNIQUE,
  name          VARCHAR(255),
  version       VARCHAR(20),
  description   TEXT,
  author        VARCHAR(255),
  entry_point   VARCHAR(500),       -- JS bundle path
  hooks         JSONB DEFAULT '[]', -- registered hooks
  permissions   JSONB DEFAULT '[]',
  is_official   BOOLEAN DEFAULT false,
  created_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tenant_plugins (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID REFERENCES tenants(id),
  plugin_id     UUID REFERENCES plugins(id),
  status        VARCHAR(20) DEFAULT 'active',
  settings      JSONB DEFAULT '{}',
  installed_at  TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, plugin_id)
);
```

### Indexing Strategy

```sql
-- Performance-critical indexes
CREATE INDEX idx_medicines_tenant ON medicines(tenant_id);
CREATE INDEX idx_medicines_barcode ON medicines(barcode);
CREATE INDEX idx_medicines_name_search ON medicines USING gin(to_tsvector('english', name || ' ' || COALESCE(generic_name, '')));

CREATE INDEX idx_batches_expiry ON medicine_batches(exp_date) WHERE status = 'active';
CREATE INDEX idx_batches_low_stock ON medicine_batches(qty_in_stock) WHERE qty_in_stock <= 10;

CREATE INDEX idx_invoices_tenant_date ON invoices(tenant_id, created_at DESC);
CREATE INDEX idx_invoices_customer ON invoices(customer_id);
CREATE INDEX idx_stock_movements_batch ON stock_movements(batch_id, created_at DESC);
```

---

## 6. Module Build Order {#module-order}

> **Rule: প্রতিটি module এই sequence-এ build করুন।**
> `Schema → Service → Controller → Tests → Frontend`

```
Priority 1 (Must have for launch):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Tenant & Branch Setup
2. Authentication & RBAC
3. Medicine/Inventory Master
4. Batch Management
5. POS Billing
6. Payment Collection
7. Basic Reports

Priority 2 (First month after launch):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
8. Purchase & GRN
9. Supplier Management
10. Expiry Management
11. Stock Alerts
12. Customer Management

Priority 3 (Quarter 2):
━━━━━━━━━━━━━━━━━━━━━━
13. Accounting Module
14. HR & Payroll
15. Prescription Management
16. DGDA Compliance
17. Advanced Reports

Priority 4 (Quarter 3+):
━━━━━━━━━━━━━━━━━━━━━━━
18. E-commerce
19. AI Features
20. Plugin Marketplace
21. Multi-tenant SaaS
```

---

## 7. Phase 1 — MVP Build {#phase-1}

**Duration:** 10-14 weeks  
**Goal:** একটি working pharmacy POS that can replace pen-paper billing

### Week 1-2: Project Setup

```bash
# Monorepo setup
npx create-turbo@latest pharmacore
cd pharmacore

# Backend (NestJS)
nest new apps/api --package-manager pnpm

# Frontend (Next.js)  
npx create-next-app@latest apps/web --typescript --tailwind --app

# Add Prisma
pnpm add prisma @prisma/client --filter api
npx prisma init

# Add essential packages
pnpm add @nestjs/jwt @nestjs/passport passport-jwt bcryptjs
pnpm add zod @nestjs/config @nestjs/throttler
```

**Deliverables:**
- [ ] Turborepo monorepo configured
- [ ] NestJS app running at `localhost:3000`
- [ ] Next.js app running at `localhost:3001`
- [ ] PostgreSQL + Redis running via Docker
- [ ] Prisma schema with core tables
- [ ] First migration applied
- [ ] GitHub Actions CI pipeline

### Week 3-4: Authentication

```typescript
// apps/api/src/modules/auth/auth.service.ts

@Injectable()
export class AuthService {
  async login(dto: LoginDto, tenantSlug: string) {
    // 1. Find tenant by slug
    const tenant = await this.tenantService.findBySlug(tenantSlug);
    if (!tenant || tenant.status === 'suspended') {
      throw new UnauthorizedException('Tenant not found or suspended');
    }

    // 2. Find user within tenant
    const user = await this.userService.findByPhone(dto.phone, tenant.id);
    if (!user) throw new UnauthorizedException('Invalid credentials');

    // 3. Verify password
    const valid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!valid) {
      await this.auditLog('FAILED_LOGIN', { userId: user.id });
      throw new UnauthorizedException('Invalid credentials');
    }

    // 4. Get user's branch + role
    const userBranchRoles = await this.getUserBranchRoles(user.id);
    
    // 5. Issue tokens
    const payload = {
      sub: user.id,
      tenantId: tenant.id,
      roles: userBranchRoles,
    };

    return {
      accessToken: this.jwtService.sign(payload, { expiresIn: '15m' }),
      refreshToken: this.jwtService.sign(payload, { expiresIn: '7d' }),
      user: { id: user.id, name: user.name, roles: userBranchRoles },
    };
  }
}
```

**Deliverables:**
- [ ] Phone + password login
- [ ] JWT + refresh token
- [ ] RBAC permission guard
- [ ] Branch-scoped access
- [ ] Login screen (Next.js)
- [ ] Protected route middleware

### Week 5-6: Inventory Master

**Key features:**
- Medicine CRUD (name, generic, brand, form, strength)
- Barcode generation
- Category management
- Batch entry (batch no, mfg/exp date, purchase price, MRP)
- Real-time stock levels

**API Endpoints:**
```
GET    /api/medicines              — list with search/filter
POST   /api/medicines              — create medicine
GET    /api/medicines/:id          — single medicine
PUT    /api/medicines/:id          — update
DELETE /api/medicines/:id          — soft delete

GET    /api/medicines/:id/batches  — batches for medicine
POST   /api/batches                — add batch
GET    /api/stock/low-stock        — low stock alerts
GET    /api/stock/expiring         — expiring soon (30 days)
```

### Week 7-9: POS Billing

This is the **most critical UI** in the entire system. Users will use this 100+ times per day.

**POS Design Requirements:**
```
Layout: Split panel
├── Left (60%): Product search + cart
│   ├── Search bar (auto-focus, barcode scan)
│   ├── Cart items (scrollable)
│   └── Totals section
└── Right (40%): Payment panel
    ├── Customer selection
    ├── Payment method buttons
    └── Complete sale button

Keyboard Shortcuts:
  F1         = Focus search
  F2         = Complete payment
  F9         = Hold invoice
  F10        = Recall invoice
  Ctrl+P     = Print last invoice
  Escape     = Clear cart
  Numeric +  = Increase qty
  Numeric -  = Decrease qty
```

```typescript
// POS critical path — must be < 200ms response
@Get('search')
@UseGuards(JwtAuthGuard)
async searchMedicines(
  @Query('q') query: string,
  @CurrentTenant() tenantId: string,
  @CurrentBranch() branchId: string,
) {
  // Search via Elasticsearch for speed
  // Fall back to PostgreSQL if ES down (offline resilience)
  return this.medicineSearchService.search(query, { tenantId, branchId });
}
```

### Week 10-11: Payment & Invoicing

**Payment flow:**
```
Cashier adds items →
  System calculates total →
    Customer pays (cash/bKash/etc.) →
      System records payment →
        Stock deducted →
          Invoice printed/sent
```

**Invoice generation (Puppeteer):**
```typescript
async generateInvoicePDF(invoiceId: string): Promise<Buffer> {
  const invoice = await this.getInvoiceWithItems(invoiceId);
  const html = await this.templateService.render('invoice', {
    ...invoice,
    qrCode: await this.generateQR(invoice.invoiceNumber),
  });
  
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  await page.setContent(html);
  
  return page.pdf({
    format: 'A5',           // Thermal printer compatible
    printBackground: true,
  });
}
```

### Week 12-14: Basic Reports + Polish

**Minimum reports for launch:**
- Daily sales summary
- Stock balance sheet
- Low stock report
- Expiry report (next 30/60/90 days)
- Customer due report

---

## 8. Phase 2 — Business Core {#phase-2}

**Duration:** 8-10 weeks after Phase 1 launch  
**Goal:** Full purchase cycle + accounting foundation

### Purchase Module

```
Supplier → Purchase Order → GRN (Goods Received) → Stock Update → Payment
```

**Key workflows:**
1. **Purchase Order (PO):** Manager selects supplier + medicines → system suggests reorder qty based on stock level → PO sent to supplier
2. **GRN (Goods Received Note):** When stock arrives → verify against PO → enter actual batch details → stock updated
3. **Purchase Return:** Expired/damaged stock → debit note → supplier credit adjustment

### Accounting Module

**Chart of Accounts (Healthcare specific):**
```
Assets
  ├── Current Assets
  │   ├── Cash in Hand
  │   ├── Cash at Bank
  │   ├── Accounts Receivable (Customer Due)
  │   └── Inventory (Medicine Stock)
  └── Fixed Assets

Liabilities
  ├── Current Liabilities
  │   ├── Accounts Payable (Supplier Due)
  │   └── VAT Payable
  └── Long-term Liabilities

Income
  ├── Medicine Sales
  ├── Service Income
  └── Other Income

Expenses
  ├── Cost of Goods Sold
  ├── Staff Salary
  ├── Rent
  └── Other Operating Expenses
```

### DGDA Compliance Module

```typescript
// Automatic daily narcotic balance sheet generation
@Cron('0 23 * * *')  // Every day at 11 PM
async generateNarcoticDailyBalance() {
  const controlledMedicines = await this.medicineRepo.findScheduled();
  
  for (const medicine of controlledMedicines) {
    for (const branch of this.activeBranches) {
      await this.complianceService.generateDailyBalance({
        medicineId: medicine.id,
        branchId: branch.id,
        date: new Date(),
      });
    }
  }
}

// Prescription validation for scheduled drugs
async validateScheduledDrugSale(medicineId: string, prescriptionId?: string) {
  const medicine = await this.medicineRepo.findById(medicineId);
  
  if (medicine.isScheduled && !prescriptionId) {
    throw new ForbiddenException(
      `${medicine.name} is a Schedule ${medicine.scheduleClass} drug. Valid prescription required.`
    );
  }
}
```

---

## 9. Phase 3 — Growth Layer {#phase-3}

**Duration:** 12-16 weeks  
**Goal:** E-commerce, AI forecasting, mobile apps, plugin marketplace

### AI Demand Forecasting

```python
# apps/ai-service/forecasting/demand_model.py
# Use Facebook Prophet or LSTM for time-series

import prophet
from prophet import Prophet

def train_demand_model(medicine_id: str, sales_history: pd.DataFrame):
    """
    Train demand prediction model for a medicine.
    Input: Daily sales data for past 2 years
    Output: 90-day demand forecast
    """
    df = sales_history[['date', 'quantity']].rename(
        columns={'date': 'ds', 'quantity': 'y'}
    )
    
    model = Prophet(
        yearly_seasonality=True,
        weekly_seasonality=True,
        # Add Bangladesh-specific seasonalities
        holidays=get_bangladesh_holidays(),
    )
    
    # Add Ramadan effect (medicine sales spike)
    model.add_country_holidays(country_name='BD')
    model.fit(df)
    
    future = model.make_future_dataframe(periods=90)
    forecast = model.predict(future)
    
    return {
        'medicine_id': medicine_id,
        'forecast': forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail(90),
        'reorder_suggestion': calculate_reorder_point(forecast),
    }
```

### WhatsApp Integration

```typescript
// plugins/whatsapp-business/src/index.ts

export class WhatsAppPlugin extends PluginBase {
  hooks = [
    'invoice.created',
    'stock.low_alert',
    'prescription.ready',
    'due.reminder',
  ];

  async onInvoiceCreated(invoice: Invoice) {
    if (!invoice.customerPhone) return;
    
    await this.whatsapp.sendTemplate({
      to: invoice.customerPhone,
      template: 'invoice_summary',
      params: {
        customer_name: invoice.customerName,
        invoice_no: invoice.invoiceNumber,
        amount: invoice.totalAmount,
        pdf_url: invoice.pdfUrl,
      },
    });
  }

  async onDueReminder(customer: Customer) {
    await this.whatsapp.sendMessage({
      to: customer.phone,
      message: `প্রিয় ${customer.name}, আপনার বকেয়া ৳${customer.dueBalance} আছে। দয়া করে পরিশোধ করুন।`,
    });
  }
}
```

---

## 10. Phase 4 — Enterprise & SaaS {#phase-4}

**Duration:** Ongoing  
**Goal:** Multi-tenant SaaS, franchise management, enterprise integrations

### Tenant Provisioning

```typescript
// Automated tenant onboarding
async provisionNewTenant(dto: CreateTenantDto) {
  return this.prisma.$transaction(async (tx) => {
    // 1. Create tenant
    const tenant = await tx.tenant.create({ data: { ...dto } });

    // 2. Create head office branch
    const branch = await tx.branch.create({
      data: { tenantId: tenant.id, name: dto.pharmacyName, isHeadOffice: true },
    });

    // 3. Create super admin user
    const admin = await tx.user.create({
      data: {
        tenantId: tenant.id,
        name: dto.ownerName,
        phone: dto.phone,
        passwordHash: await hash(dto.password, 12),
      },
    });

    // 4. Assign owner role
    await tx.userBranchRole.create({
      data: { userId: admin.id, branchId: branch.id, roleId: OWNER_ROLE_ID },
    });

    // 5. Seed default data (categories, units, chart of accounts)
    await this.seedDefaultData(tenant.id, tx);

    // 6. Send welcome email + setup guide
    await this.emailService.sendWelcome(admin.email, tenant);

    return { tenant, branch, admin };
  });
}
```

### Subscription & Billing

```
Plan Limits:
┌──────────────┬─────────┬────────────┬────────────┐
│ Feature      │ Starter │ Pro        │ Enterprise │
├──────────────┼─────────┼────────────┼────────────┤
│ Branches     │ 1       │ 5          │ Unlimited  │
│ Users        │ 3       │ 15         │ Unlimited  │
│ Invoices/mo  │ 500     │ 5,000      │ Unlimited  │
│ Storage      │ 1 GB    │ 10 GB      │ 100 GB     │
│ Plugins      │ 2       │ 10         │ Unlimited  │
│ API Access   │ ✗       │ ✓          │ ✓          │
│ White Label  │ ✗       │ ✗          │ ✓          │
│ SLA          │ —       │ 99.5%      │ 99.9%      │
│ Support      │ Email   │ Chat       │ Dedicated  │
│ Price/mo     │ ৳1,500  │ ৳4,500     │ Custom     │
└──────────────┴─────────┴────────────┴────────────┘
```

---

## 11. UI/UX Design System {#ui-ux}

> **"Wow factor" = Speed + Clarity + Delight. প্রতিটি interaction এই তিনটি measure-এ pass করতে হবে।**

### Design Tokens

```css
/* apps/web/styles/tokens.css */

:root {
  /* Brand Colors */
  --color-primary-50:  #EFF6FF;
  --color-primary-500: #2563EB;  /* Primary blue */
  --color-primary-600: #1D4ED8;
  --color-primary-900: #1E3A5F;

  /* Semantic */
  --color-success: #10B981;
  --color-warning: #F59E0B;
  --color-danger:  #EF4444;
  --color-info:    #3B82F6;

  /* Neutral */
  --color-gray-50:  #F9FAFB;
  --color-gray-100: #F3F4F6;
  --color-gray-500: #6B7280;
  --color-gray-900: #111827;

  /* Typography */
  --font-display: 'Sora', sans-serif;    /* Headings */
  --font-body: 'DM Sans', sans-serif;   /* Body text */
  --font-mono: 'JetBrains Mono', monospace;

  /* Spacing */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;

  /* Radius */
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;
  --radius-xl: 24px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
  --shadow-lg: 0 8px 32px rgba(0,0,0,0.12);
}
```

### Component Patterns

```tsx
// ✅ POS Search — the most-used component
// Must feel instant. Optimistic updates. Keyboard-first.

export function POSSearch() {
  const [query, setQuery] = useState('');
  const { data, isLoading } = useQuery({
    queryKey: ['medicine-search', query],
    queryFn: () => searchMedicines(query),
    enabled: query.length >= 2,
    staleTime: 30_000,         // cache for 30s
    placeholderData: keepPreviousData,
  });

  return (
    <div className="relative">
      <input
        autoFocus
        placeholder="Medicine name, barcode, or generic..."
        className={cn(
          "w-full h-14 px-4 pl-12 text-lg",
          "bg-white border-2 border-transparent",
          "rounded-xl shadow-sm",
          "focus:border-primary-500 focus:ring-4 focus:ring-primary-100",
          "transition-all duration-200"
        )}
        value={query}
        onChange={e => setQuery(e.target.value)}
        onKeyDown={handleKeyboardNav}
      />
      {/* Results dropdown with batch selection */}
      <MedicineResults results={data} loading={isLoading} />
    </div>
  );
}
```

### Dashboard Design Principles

```
Dashboard Layout:
┌─────────────────────────────────────────────┐
│ Header: Branch selector · Alerts · User menu │
├──────────┬──────────────────────────────────┤
│          │ Today's KPI cards (4 cards)       │
│ Sidebar  ├──────────────────────────────────┤
│ Nav      │ Sales chart (7-day sparkline)     │
│          ├──────────────────────────────────┤
│ (64px    │ Low stock · Expiring · Due        │
│  wide)   │ (3 alert panels side by side)     │
│          ├──────────────────────────────────┤
│          │ Recent transactions table         │
└──────────┴──────────────────────────────────┘

WOW moments:
• Number counters animate on page load
• Stock level bars show color gradient (green→yellow→red)
• Expiry dates turn amber at 60 days, red at 30 days
• Real-time sales ticker (WebSocket)
• Contextual empty states with action CTAs
• Keyboard shortcut overlay (press ?)
```

### Accessibility Requirements

```
• WCAG 2.1 Level AA minimum
• All interactive elements: focus visible
• Color contrast ratio: 4.5:1 minimum
• Keyboard navigable POS (no mouse required)
• Screen reader labels on all icons
• Loading states for every async operation
• Error messages: clear, actionable, non-technical
• Success feedback: visible for 2 seconds
```

---

## 12. API Design Standards {#api-design}

### REST Conventions

```
Base URL: https://api.pharmacore.app/v1/

# Multi-tenant routing
Header: X-Tenant-Slug: dhaka-pharmacy
  OR
Subdomain: dhaka-pharmacy.pharmacore.app

# Resource naming
GET    /medicines              — list
POST   /medicines              — create
GET    /medicines/:id          — read
PATCH  /medicines/:id          — partial update
DELETE /medicines/:id          — soft delete
POST   /medicines/:id/restore  — restore deleted

# Nested resources
GET    /medicines/:id/batches  — batches for medicine
POST   /invoices/:id/payments  — add payment to invoice

# Filtering & pagination
GET /invoices?page=1&limit=20&status=paid&from=2024-01-01&to=2024-01-31
GET /medicines?category=antibiotic&lowStock=true&search=amox

# Response envelope
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 450,
    "totalPages": 23
  }
}

# Error response
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_STOCK",
    "message": "Only 5 units available, requested 10",
    "field": "quantity",
    "details": { "available": 5, "requested": 10 }
  }
}
```

### API Versioning Strategy

```
v1 — stable, no breaking changes
v2 — new features (run parallel, deprecate v1 after 6 months)

Header versioning: Accept: application/vnd.pharmacore.v2+json
```

---

## 13. Security Checklist {#security}

### Authentication Security

```typescript
// Rate limiting on auth endpoints
@UseGuards(ThrottlerGuard)
@Throttle({ default: { limit: 5, ttl: 60000 } })  // 5 attempts/minute
@Post('login')
async login() { ... }

// Password policy
const passwordSchema = z.string()
  .min(8, 'Minimum 8 characters')
  .regex(/[A-Z]/, 'Must contain uppercase')
  .regex(/[0-9]/, 'Must contain number');

// Audit all sensitive actions
async dispenseControlledDrug(data: DispenseDto, user: User) {
  await this.auditLog.record({
    action: 'CONTROLLED_DRUG_DISPENSED',
    userId: user.id,
    tenantId: user.tenantId,
    details: data,
    ip: this.request.ip,
    timestamp: new Date(),
  });
}
```

### Data Security

- [ ] All passwords: bcrypt (cost factor 12)
- [ ] Sensitive fields encrypted at rest (AES-256): patient records, prescriptions
- [ ] All API communication: TLS 1.3
- [ ] Database backups: encrypted + offsite
- [ ] PII data: GDPR-compliant deletion workflow
- [ ] API keys: hashed in database, shown once on creation
- [ ] Tenant data: Row-level security in PostgreSQL
- [ ] SQL injection: Prisma ORM (parameterized queries always)
- [ ] XSS: Content-Security-Policy headers
- [ ] CSRF: SameSite=Strict cookies

### OWASP Top 10 Coverage

```
A01 Broken Access Control     → RBAC + branch-scoped queries + tests
A02 Cryptographic Failures    → bcrypt + AES-256 + TLS
A03 Injection                 → Prisma ORM (no raw SQL by default)
A04 Insecure Design           → Threat modeling before each module
A05 Security Misconfiguration → Automated config checks in CI
A06 Vulnerable Components     → Dependabot + weekly npm audit
A07 Auth Failures             → Rate limiting + lockout + 2FA
A08 Integrity Failures        → Signed JWTs + audit logs
A09 Logging Failures          → ELK stack + immutable audit trail
A10 SSRF                      → Whitelist-only external requests
```

---

## 14. Plugin System {#plugin-system}

### Plugin Architecture

```typescript
// packages/plugin-sdk/src/plugin-base.ts

export abstract class PluginBase {
  abstract name: string;
  abstract version: string;
  abstract hooks: string[];

  // Lifecycle methods
  async onInstall(tenantId: string): Promise<void> {}
  async onActivate(tenantId: string): Promise<void> {}
  async onDeactivate(tenantId: string): Promise<void> {}
  async onUninstall(tenantId: string): Promise<void> {}

  // Hook handler (implement in each plugin)
  abstract handleHook(hook: string, payload: any): Promise<void>;
}

// Example: bKash payment plugin
export class BkashPlugin extends PluginBase {
  name = 'payment-bkash';
  version = '1.0.0';
  hooks = ['payment.initiate', 'payment.verify'];

  async handleHook(hook: string, payload: PaymentPayload) {
    switch(hook) {
      case 'payment.initiate':
        return this.initiatePayment(payload);
      case 'payment.verify':
        return this.verifyPayment(payload.transactionId);
    }
  }

  private async initiatePayment(payload: PaymentPayload) {
    // bKash API integration
    const response = await fetch('https://tokenized.pay.bka.sh/v1.2.0-beta/tokenized/checkout/create', {
      method: 'POST',
      headers: {
        'Authorization': this.config.idToken,
        'X-APP-Key': this.config.appKey,
      },
      body: JSON.stringify({
        mode: '0011',
        amount: payload.amount.toString(),
        currency: 'BDT',
        callbackURL: `${this.config.baseUrl}/api/payments/bkash/callback`,
        merchantInvoiceNumber: payload.invoiceNumber,
      }),
    });
    return response.json();
  }
}
```

---

## 15. DevOps & Deployment {#devops}

### Docker Setup

```yaml
# infrastructure/docker/docker-compose.yml

version: '3.9'
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: pharmacore
      POSTGRES_USER: pharmacore
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redisdata:/data

  elasticsearch:
    image: elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=-Xms512m -Xmx512m
    volumes:
      - esdata:/usr/share/elasticsearch/data

  api:
    build:
      context: ../../
      dockerfile: apps/api/Dockerfile
    environment:
      DATABASE_URL: postgresql://pharmacore:${DB_PASSWORD}@postgres:5432/pharmacore
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
    depends_on:
      - postgres
      - redis
    ports:
      - "3000:3000"

  web:
    build:
      context: ../../
      dockerfile: apps/web/Dockerfile
    environment:
      NEXT_PUBLIC_API_URL: http://api:3000
    ports:
      - "3001:3001"

volumes:
  pgdata:
  redisdata:
  esdata:
```

### GitHub Actions CI/CD

```yaml
# .github/workflows/ci.yml

name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s

    steps:
      - uses: actions/checkout@v4
      
      - uses: pnpm/action-setup@v2
        with:
          version: 8
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      
      - run: pnpm install --frozen-lockfile
      - run: pnpm prisma migrate deploy
      - run: pnpm test
      - run: pnpm build

  deploy-staging:
    needs: test
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to staging
        run: |
          docker build -t pharmacore-api:${{ github.sha }} .
          # Push to registry & update k8s deployment
```

---

## 16. Missing Gaps (Critical) {#missing-gaps}

> এই gaps গুলো SRS-এ ছিল না — build করার আগে এগুলো address করতে হবে।

### 🔴 Critical: DGDA Compliance Engine

```
Required by Bangladesh law:
├── Controlled drug daily register (mandatory log)
├── Narcotic balance sheet (daily reconciliation)
├── Drug license expiry alerts (DGDA renewal)
├── Scheduled drug sale → prescription validation (enforced in code)
└── Monthly DGDA return reports
```

### 🔴 Critical: Offline Conflict Resolution

```
Current SRS: "Offline Billing" mentioned
Missing:
├── Conflict resolution strategy (what if same batch sold offline in 2 branches?)
├── Stock reservation during offline mode
├── Sync queue with retry logic
└── Conflict notification to manager
```

### 🔴 Critical: Data Migration System

```
For every new customer joining from existing systems:
├── Excel/CSV medicine import with validation
├── Opening stock entry wizard (branch-wise)
├── Historical invoice import (for customer due tracking)
└── Rollback if migration fails
```

### 🟡 Important: MRP Enforcement

```typescript
// Government mandated — cannot sell above MRP
async validateSalePrice(batchId: string, salePrice: number) {
  const batch = await this.batchRepo.findById(batchId);
  
  if (salePrice > batch.mrp) {
    throw new BadRequestException(
      `Sale price ৳${salePrice} exceeds MRP ৳${batch.mrp}. 
       Selling above MRP is illegal under Drug Act 1940.`
    );
  }
}
```

### 🟡 Important: Supplier Return & Debit Notes

```
Full workflow missing:
Expired stock identified →
  Return request to supplier →
    Debit note generated →
      Physical return tracked →
        Credit adjustment in accounting
```

---

## 17. Team Structure {#team-structure}

### Minimum Viable Team

```
MVP Phase (10-14 weeks):
━━━━━━━━━━━━━━━━━━━━━━
1x  Tech Lead / Backend Architect   (NestJS, PostgreSQL, System Design)
1x  Full-Stack Developer            (NestJS + Next.js)
1x  Frontend Developer              (Next.js, TailwindCSS, POS UI)
1x  UI/UX Designer                  (Figma, pharmacy domain knowledge)
1x  QA Engineer / Business Analyst  (Test cases + requirement clarification)

Scaling Phase:
━━━━━━━━━━━━━
+1 Backend Developer      (Accounting, HR modules)
+1 Mobile Developer       (Flutter)
+1 DevOps Engineer        (Kubernetes, monitoring)
+1 Data Analyst / ML Eng  (AI forecasting, reporting)
```

---

## 18. Timeline Estimate {#timeline}

```
Phase 1 — MVP (POS + Inventory + Auth)
   Weeks 1-2:   Project setup, CI/CD, Docker
   Weeks 3-4:   Authentication, RBAC, Multi-tenant
   Weeks 5-6:   Medicine master, Batch management
   Weeks 7-9:   POS billing, Cart, Payment
   Weeks 10-11: Invoice generation, Printing
   Weeks 12-14: Reports, Testing, Bug fixing
   ──────────────────────────────────────
   Total: ~14 weeks (3.5 months)

Phase 2 — Business Core
   Weeks 1-3:   Purchase module (PO, GRN)
   Weeks 4-5:   Accounting foundation
   Weeks 6-7:   CRM, Loyalty
   Weeks 8-9:   DGDA Compliance
   Weeks 10+:   Advanced reports, HR basics
   ──────────────────────────────────────
   Total: ~10 weeks (2.5 months)

Phase 3 — Growth
   Month 1-2:  E-commerce module
   Month 2-3:  AI forecasting service
   Month 3-4:  Flutter mobile apps
   Month 4:    Plugin marketplace
   ──────────────────────────────────────
   Total: ~4 months

Phase 4 — Enterprise
   Ongoing: Multi-tenant SaaS hardening,
            Franchise management,
            Enterprise integrations
   ──────────────────────────────────────
   Total: Ongoing

══════════════════════════════════════════
Full System (Production-ready): ~12 months
First paying customer possible: ~4 months
══════════════════════════════════════════
```

---

## Quick Start

```bash
# Clone and setup
git clone https://github.com/your-org/pharmacore
cd pharmacore
cp .env.example .env

# Install dependencies
pnpm install

# Start infrastructure
docker-compose -f infrastructure/docker/docker-compose.yml up -d

# Database setup
pnpm prisma migrate dev
pnpm prisma db seed

# Start development
pnpm dev

# Access:
# API:       http://localhost:3000
# Web App:   http://localhost:3001
# API Docs:  http://localhost:3000/docs
# Grafana:   http://localhost:3030
```

---

<div align="center">

**PharmaCore ERP** · Built for Bangladesh's pharmacy industry  
*From a single counter to a nationwide chain — one system.*

`v1.0.0-planning` · Last updated: 2024

</div>
