-- CreateTable
CREATE TABLE `tenants` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(100) NOT NULL,
    `plan` VARCHAR(50) NULL DEFAULT 'starter',
    `status` VARCHAR(20) NULL DEFAULT 'trial',
    `trial_ends_at` DATETIME(3) NULL,
    `settings` JSON NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `tenants_slug_key`(`slug`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `branches` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `name` VARCHAR(255) NOT NULL,
    `code` VARCHAR(20) NULL,
    `address` TEXT NULL,
    `phone` VARCHAR(20) NULL,
    `drug_license` VARCHAR(100) NULL,
    `license_expiry` DATE NULL,
    `is_head_office` BOOLEAN NULL DEFAULT false,
    `settings` JSON NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `email` VARCHAR(255) NULL,
    `phone` VARCHAR(20) NULL,
    `password_hash` VARCHAR(255) NULL,
    `name` VARCHAR(255) NOT NULL,
    `status` VARCHAR(20) NULL DEFAULT 'active',
    `last_login_at` DATETIME(3) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `users_tenant_id_email_key`(`tenant_id`, `email`),
    UNIQUE INDEX `users_tenant_id_phone_key`(`tenant_id`, `phone`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(100) NOT NULL,
    `permissions` JSON NULL,
    `is_system` BOOLEAN NULL DEFAULT false,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_branch_roles` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `role_id` VARCHAR(191) NULL,

    UNIQUE INDEX `user_branch_roles_user_id_branch_id_key`(`user_id`, `branch_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `medicines` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `name` VARCHAR(255) NOT NULL,
    `generic_name` VARCHAR(255) NULL,
    `brand_name` VARCHAR(255) NULL,
    `manufacturer` VARCHAR(255) NULL,
    `category` VARCHAR(100) NULL,
    `form` VARCHAR(50) NULL,
    `strength` VARCHAR(50) NULL,
    `unit` VARCHAR(20) NULL,
    `pack_size` INTEGER NULL DEFAULT 1,
    `barcode` VARCHAR(100) NULL,
    `sku` VARCHAR(100) NULL,
    `is_generic` BOOLEAN NULL DEFAULT false,
    `is_scheduled` BOOLEAN NULL DEFAULT false,
    `schedule_class` VARCHAR(10) NULL,
    `requires_rx` BOOLEAN NULL DEFAULT false,
    `mrp` DECIMAL(10, 2) NULL,
    `reorder_level` INTEGER NULL DEFAULT 10,
    `reorder_qty` INTEGER NULL DEFAULT 100,
    `is_active` BOOLEAN NULL DEFAULT true,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `medicines_tenant_id_idx`(`tenant_id`),
    INDEX `medicines_barcode_idx`(`barcode`),
    UNIQUE INDEX `medicines_tenant_id_barcode_key`(`tenant_id`, `barcode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `medicine_batches` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `medicine_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `batch_number` VARCHAR(100) NOT NULL,
    `mfg_date` DATE NULL,
    `exp_date` DATE NOT NULL,
    `purchase_price` DECIMAL(10, 2) NULL,
    `sale_price` DECIMAL(10, 2) NULL,
    `mrp` DECIMAL(10, 2) NULL,
    `qty_in_stock` INTEGER NULL DEFAULT 0,
    `qty_sold` INTEGER NULL DEFAULT 0,
    `qty_returned` INTEGER NULL DEFAULT 0,
    `status` VARCHAR(20) NULL DEFAULT 'active',
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `medicine_batches_tenant_id_medicine_id_branch_id_batch_numbe_key`(`tenant_id`, `medicine_id`, `branch_id`, `batch_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `stock_movements` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `batch_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `type` VARCHAR(30) NOT NULL,
    `quantity` INTEGER NOT NULL,
    `reference_id` VARCHAR(191) NULL,
    `reference_type` VARCHAR(30) NULL,
    `notes` TEXT NULL,
    `created_by` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `invoices` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `invoice_number` VARCHAR(50) NOT NULL,
    `invoice_date` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `customer_id` VARCHAR(191) NULL,
    `customer_name` VARCHAR(255) NULL,
    `customer_phone` VARCHAR(20) NULL,
    `prescription_id` VARCHAR(191) NULL,
    `subtotal` DECIMAL(12, 2) NULL,
    `discount_amount` DECIMAL(12, 2) NULL DEFAULT 0,
    `vat_amount` DECIMAL(12, 2) NULL DEFAULT 0,
    `total_amount` DECIMAL(12, 2) NULL,
    `paid_amount` DECIMAL(12, 2) NULL DEFAULT 0,
    `due_amount` DECIMAL(12, 2) NULL DEFAULT 0,
    `status` VARCHAR(20) NULL DEFAULT 'paid',
    `notes` TEXT NULL,
    `created_by` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `invoices_invoice_number_key`(`invoice_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `invoice_items` (
    `id` VARCHAR(191) NOT NULL,
    `invoice_id` VARCHAR(191) NULL,
    `medicine_id` VARCHAR(191) NULL,
    `batch_id` VARCHAR(191) NULL,
    `quantity` INTEGER NOT NULL,
    `unit_price` DECIMAL(10, 2) NULL,
    `discount_pct` DECIMAL(5, 2) NULL DEFAULT 0,
    `vat_pct` DECIMAL(5, 2) NULL DEFAULT 0,
    `line_total` DECIMAL(12, 2) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `payments` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `invoice_id` VARCHAR(191) NULL,
    `amount` DECIMAL(12, 2) NULL,
    `method` VARCHAR(30) NULL,
    `reference` VARCHAR(100) NULL,
    `status` VARCHAR(20) NULL DEFAULT 'completed',
    `paid_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `created_by` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `suppliers` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `name` VARCHAR(255) NOT NULL,
    `company` VARCHAR(255) NULL,
    `phone` VARCHAR(20) NULL,
    `email` VARCHAR(255) NULL,
    `address` TEXT NULL,
    `drug_license` VARCHAR(100) NULL,
    `credit_limit` DECIMAL(12, 2) NULL DEFAULT 0,
    `credit_days` INTEGER NULL DEFAULT 30,
    `balance` DECIMAL(12, 2) NULL DEFAULT 0,
    `is_active` BOOLEAN NULL DEFAULT true,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchase_orders` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `po_number` VARCHAR(50) NULL,
    `supplier_id` VARCHAR(191) NULL,
    `status` VARCHAR(20) NULL DEFAULT 'draft',
    `total_amount` DECIMAL(12, 2) NULL,
    `notes` TEXT NULL,
    `expected_date` DATE NULL,
    `created_by` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `purchase_orders_po_number_key`(`po_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `controlled_drug_register` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `medicine_id` VARCHAR(191) NULL,
    `date` DATE NOT NULL,
    `opening_balance` INTEGER NULL,
    `qty_received` INTEGER NULL DEFAULT 0,
    `qty_dispensed` INTEGER NULL DEFAULT 0,
    `closing_balance` INTEGER NULL,
    `remarks` TEXT NULL,
    `verified_by` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `controlled_drug_register_tenant_id_branch_id_medicine_id_dat_key`(`tenant_id`, `branch_id`, `medicine_id`, `date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `drug_licenses` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `branch_id` VARCHAR(191) NULL,
    `license_type` VARCHAR(50) NULL,
    `license_number` VARCHAR(100) NULL,
    `issued_by` VARCHAR(100) NULL,
    `issue_date` DATE NULL,
    `expiry_date` DATE NULL,
    `document_url` VARCHAR(500) NULL,
    `status` VARCHAR(20) NULL DEFAULT 'active',
    `reminder_sent` BOOLEAN NULL DEFAULT false,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `customers` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `name` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(20) NULL,
    `email` VARCHAR(255) NULL,
    `address` TEXT NULL,
    `date_of_birth` DATE NULL,
    `gender` VARCHAR(10) NULL,
    `loyalty_points` INTEGER NULL DEFAULT 0,
    `total_spent` DECIMAL(12, 2) NULL DEFAULT 0,
    `credit_limit` DECIMAL(12, 2) NULL DEFAULT 0,
    `due_balance` DECIMAL(12, 2) NULL DEFAULT 0,
    `notes` TEXT NULL,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `customers_tenant_id_phone_key`(`tenant_id`, `phone`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `plugins` (
    `id` VARCHAR(191) NOT NULL,
    `slug` VARCHAR(100) NULL,
    `name` VARCHAR(255) NULL,
    `version` VARCHAR(20) NULL,
    `description` TEXT NULL,
    `author` VARCHAR(255) NULL,
    `entry_point` VARCHAR(500) NULL,
    `hooks` JSON NULL,
    `permissions` JSON NULL,
    `is_official` BOOLEAN NULL DEFAULT false,
    `created_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `plugins_slug_key`(`slug`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tenant_plugins` (
    `id` VARCHAR(191) NOT NULL,
    `tenant_id` VARCHAR(191) NULL,
    `plugin_id` VARCHAR(191) NULL,
    `status` VARCHAR(20) NULL DEFAULT 'active',
    `settings` JSON NULL,
    `installed_at` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `tenant_plugins_tenant_id_plugin_id_key`(`tenant_id`, `plugin_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `branches` ADD CONSTRAINT `branches_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `users` ADD CONSTRAINT `users_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `roles` ADD CONSTRAINT `roles_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_branch_roles` ADD CONSTRAINT `user_branch_roles_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_branch_roles` ADD CONSTRAINT `user_branch_roles_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_branch_roles` ADD CONSTRAINT `user_branch_roles_role_id_fkey` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `medicines` ADD CONSTRAINT `medicines_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `medicine_batches` ADD CONSTRAINT `medicine_batches_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `medicine_batches` ADD CONSTRAINT `medicine_batches_medicine_id_fkey` FOREIGN KEY (`medicine_id`) REFERENCES `medicines`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `medicine_batches` ADD CONSTRAINT `medicine_batches_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `stock_movements` ADD CONSTRAINT `stock_movements_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `stock_movements` ADD CONSTRAINT `stock_movements_batch_id_fkey` FOREIGN KEY (`batch_id`) REFERENCES `medicine_batches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `stock_movements` ADD CONSTRAINT `stock_movements_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `invoices` ADD CONSTRAINT `invoices_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `invoices` ADD CONSTRAINT `invoices_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `invoices` ADD CONSTRAINT `invoices_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `invoice_items` ADD CONSTRAINT `invoice_items_invoice_id_fkey` FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `invoice_items` ADD CONSTRAINT `invoice_items_medicine_id_fkey` FOREIGN KEY (`medicine_id`) REFERENCES `medicines`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `invoice_items` ADD CONSTRAINT `invoice_items_batch_id_fkey` FOREIGN KEY (`batch_id`) REFERENCES `medicine_batches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `payments` ADD CONSTRAINT `payments_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `payments` ADD CONSTRAINT `payments_invoice_id_fkey` FOREIGN KEY (`invoice_id`) REFERENCES `invoices`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `suppliers` ADD CONSTRAINT `suppliers_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `purchase_orders` ADD CONSTRAINT `purchase_orders_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `purchase_orders` ADD CONSTRAINT `purchase_orders_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `purchase_orders` ADD CONSTRAINT `purchase_orders_supplier_id_fkey` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `controlled_drug_register` ADD CONSTRAINT `controlled_drug_register_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `controlled_drug_register` ADD CONSTRAINT `controlled_drug_register_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `controlled_drug_register` ADD CONSTRAINT `controlled_drug_register_medicine_id_fkey` FOREIGN KEY (`medicine_id`) REFERENCES `medicines`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `drug_licenses` ADD CONSTRAINT `drug_licenses_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `drug_licenses` ADD CONSTRAINT `drug_licenses_branch_id_fkey` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `customers` ADD CONSTRAINT `customers_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tenant_plugins` ADD CONSTRAINT `tenant_plugins_tenant_id_fkey` FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tenant_plugins` ADD CONSTRAINT `tenant_plugins_plugin_id_fkey` FOREIGN KEY (`plugin_id`) REFERENCES `plugins`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
