from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)

DB = "warehouse.db"

def query(sql, params=(), fetch=True):
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute(sql, params)
    data = [dict(row) for row in cur.fetchall()] if fetch else None
    conn.commit()
    conn.close()
    return data

@app.get("/")
def index():
    return render_template("index.html")

@app.get("/storage")
def get_storage():
    return jsonify(query("""
        SELECT s.storage_id, s.order_number, s.order_date,
               m.name AS material, sup.name AS supplier,
               s.quantity, u.unit_name, s.price
        FROM STORAGE_UNIT s
        JOIN MATERIAL m ON s.material_id = m.material_id
        JOIN SUPPLIER sup ON s.supplier_id = sup.supplier_id
        JOIN UNIT u ON s.unit_id = u.unit_id
        ORDER BY s.storage_id DESC
    """))

@app.post("/storage")
def add_storage():
    data = request.json
    query("""
        INSERT INTO STORAGE_UNIT
        (order_number, order_date, supplier_id, account, document_code,
         document_number, material_id, material_account, unit_id, quantity, price)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        data["order_number"], data["order_date"], data["supplier_id"], data["account"],
        data["document_code"], data["document_number"], data["material_id"],
        data["material_account"], data["unit_id"], data["quantity"], data["price"]
    ), fetch=False)
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run()
