import pytest
from fastapi.testclient import TestClient
import sys
import os

# Add parent path to import app
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app.main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert data["service"] == "freshtrack-chef-backend"

def test_chef_respond_chicken_marination():
    payload = {
        "query": "Tavuk göğsü marine etme",
        "inventory": [
            {
                "name": "Tavuk Göğsü",
                "category": "Et & Tavuk",
                "days_left": 1,
                "quantity": 500.0,
                "unit": "g"
            }
        ]
    }
    response = client.post("/v1/chef/respond", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "reply" in data
    assert "tavuk" in data["reply"].lower()
    assert "disclaimer" in data

def test_chef_respond_recipe_suggestion():
    payload = {
        "query": "Bugün ne pişirebilirim?",
        "inventory": [
            {
                "name": "Köy Sütü",
                "category": "Süt Ürünleri",
                "days_left": 0,
                "quantity": 1.0,
                "unit": "L"
            },
            {
                "name": "Kültür Mantarı",
                "category": "Sebze & Meyve",
                "days_left": 2,
                "quantity": 300.0,
                "unit": "g"
            }
        ]
    }
    response = client.post("/v1/chef/respond", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "Kremalı Mantarlı Tavuk Sote" in data["reply"] or "Köy Sütü" in data["reply"]
    assert data["matched_recipe_id"] is not None

def test_validation_error_on_empty_query():
    response = client.post("/v1/chef/respond", json={"query": ""})
    assert response.status_code == 422  # Pydantic validation error
