-- ============================
-- WarehouseApp
-- Actual database schema
-- SQLite
-- ============================

PRAGMA foreign_keys = ON;

-- ----------------------------
-- SUPPLIER
-- ----------------------------
CREATE TABLE IF NOT EXISTS SUPPLIER (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- ----------------------------
-- MATERIAL
-- ----------------------------
CREATE TABLE IF NOT EXISTS MATERIAL (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    account TEXT NOT NULL
);

-- ----------------------------
-- UNIT
-- ----------------------------
CREATE TABLE IF NOT EXISTS UNIT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- ----------------------------
-- STORAGE_UNIT
-- ----------------------------
CREATE TABLE IF NOT EXISTS STORAGE_UNIT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    order_number TEXT NOT NULL,
    order_date TEXT NOT NULL,

    supplier_id INTEGER NOT NULL,
    material_id INTEGER NOT NULL,
    unit_id INTEGER NOT NULL,

    account TEXT NOT NULL,
    document_code TEXT NOT NULL,
    document_number TEXT NOT NULL,

    material_account TEXT NOT NULL,

    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price REAL NOT NULL CHECK (price >= 0),

    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(id),
    FOREIGN KEY (material_id) REFERENCES MATERIAL(id),
    FOREIGN KEY (unit_id) REFERENCES UNIT(id)
);

-- ----------------------------
-- INDEXES
-- ----------------------------
CREATE INDEX IF NOT EXISTS idx_storage_order
    ON STORAGE_UNIT(order_number);

CREATE INDEX IF NOT EXISTS idx_storage_supplier
    ON STORAGE_UNIT(supplier_id);

CREATE INDEX IF NOT EXISTS idx_storage_material
    ON STORAGE_UNIT(material_id);
