PRAGMA foreign_keys = ON;

-- Поставщики материалов
CREATE TABLE SUPPLIER (
    supplier_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name             TEXT NOT NULL,
    inn              TEXT NOT NULL,
    legal_index      TEXT,
    legal_city       TEXT,
    legal_street     TEXT,
    legal_building   TEXT,
    bank_index       TEXT,
    bank_city        TEXT,
    bank_street      TEXT,
    bank_building    TEXT,
    bank_account     TEXT NOT NULL
);

-- Справочник материалов
CREATE TABLE MATERIAL (
    material_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    class_code       TEXT NOT NULL,
    group_code       TEXT NOT NULL,
    name             TEXT NOT NULL
);

-- Единицы измерения конкретных материалов
CREATE TABLE UNIT (
    unit_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    material_id      INTEGER NOT NULL,
    unit_name        TEXT NOT NULL,
    FOREIGN KEY(material_id) REFERENCES MATERIAL(material_id) ON DELETE CASCADE
);

-- Справочник документов
CREATE TABLE DOCUMENT (
    document_code    INTEGER PRIMARY KEY,
    document_name    TEXT NOT NULL
);

-- Единицы хранения на складе
CREATE TABLE STORAGE_UNIT (
    storage_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number     TEXT NOT NULL,
    order_date       DATE NOT NULL,
    supplier_id      INTEGER NOT NULL,
    account          TEXT NOT NULL,
    document_code    INTEGER NOT NULL,
    document_number  TEXT NOT NULL,
    material_id      INTEGER NOT NULL,
    material_account TEXT NOT NULL,
    unit_id          INTEGER NOT NULL,
    quantity         REAL NOT NULL,
    price            REAL NOT NULL,

    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id),
    FOREIGN KEY (document_code) REFERENCES DOCUMENT(document_code),
    FOREIGN KEY (material_id) REFERENCES MATERIAL(material_id),
    FOREIGN KEY (unit_id) REFERENCES UNIT(unit_id)
);

INSERT INTO SUPPLIER (name, inn, legal_index, legal_city, legal_street, legal_building,
                      bank_index, bank_city, bank_street, bank_building, bank_account)
VALUES
('ООО Индустрия', '1234567890', '101000', 'Москва', 'Ленина', '5', '101000', 'Москва', 'Мясницкая', '10', '408028123'),
('Поставщик Мега', '9876543210', '190000', 'Санкт-Петербург', 'Невский', '44', '190000', 'Санкт-Петербург', 'Невский', '51', '407028555');

INSERT INTO MATERIAL (class_code, group_code, name)
VALUES
('A', '01', 'Сталь листовая'),
('B', '02', 'Бензин АИ-95');

INSERT INTO UNIT (material_id, unit_name)
VALUES
(1, 'кг'),
(2, 'литр');

INSERT INTO DOCUMENT (document_code, document_name)
VALUES
(1, 'Счёт-фактура'),
(2, 'Товарная накладная');
