import os
import sqlite3
import pytest

from server import app, query, DB


# -----------------------------
# FIXTURES
# -----------------------------

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


@pytest.fixture
def db_connection():
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    yield conn
    conn.close()


# -----------------------------
# UNIT TESTS
# -----------------------------

def test_db_open():
    """
    Проверка открытия базы данных
    """
    conn = sqlite3.connect(DB)
    assert conn is not None
    conn.close()


def test_simple_select_query(db_connection):
    """
    Проверка выполнения SELECT-запроса
    """
    cursor = db_connection.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = cursor.fetchall()
    assert isinstance(tables, list)
    assert len(tables) > 0


def test_query_function_select():
    """
    Проверка функции query() без сервера
    """
    result = query("SELECT 1 AS test_value")
    assert isinstance(result, list)
    assert result[0]["test_value"] == 1


def test_query_function_insert_and_select():
    """
    Проверка INSERT + SELECT
    """
    query(
        "INSERT INTO SUPPLIER (name) VALUES (?)",
        ("TEST_SUPPLIER",),
        fetch=False
    )

    result = query(
        "SELECT name FROM SUPPLIER WHERE name = ?",
        ("TEST_SUPPLIER",)
    )

    assert len(result) == 1
    assert result[0]["name"] == "TEST_SUPPLIER"


# -----------------------------
# INTEGRATION TESTS
# -----------------------------

def test_index_page(client):
    """
    Проверка доступности главной страницы
    """
    response = client.get("/")
    assert response.status_code == 200
    assert b"<html" in response.data.lower()


def test_add_storage_unit(client):
    """
    Проверка связи сервера с БД (POST-запрос)
    """
    payload = {
        "order_number": "ORD-TEST",
        "order_date": "2025-01-01",
        "supplier_id": 1,
        "account": "10.01",
        "document_code": "DC",
        "document_number": "123",
        "material_id": 1,
        "material_account": "20.01",
        "unit_id": 1,
        "quantity": 5,
        "price": 100
    }

    response = client.post("/add", json=payload)

    assert response.status_code == 200
    assert response.json["status"] == "ok"


def test_storage_unit_saved_in_db():
    """
    Проверка, что сервер реально записал данные в БД
    """
    result = query(
        "SELECT * FROM STORAGE_UNIT WHERE order_number = ?",
        ("ORD-TEST",)
    )

    assert len(result) == 1
    assert result[0]["quantity"] == 5
    assert result[0]["price"] == 100
