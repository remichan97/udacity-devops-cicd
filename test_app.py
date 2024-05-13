import pytest
from flask import request, jsonify
from app import app

def test_prediction():
	with app.test_client() as client:
		response = client.post("/predict", json={
				"CHAS":{
		"0":0
		},
		"RM":{
		"0":6.575
		},
		"TAX":{
		"0":296.0
		},
		"PTRATIO":{
		"0":15.3
		},
		"B":{
		"0":396.9
		},
		"LSTAT":{
		"0":4.98
		}
		})
	data = response.get_json()
	assert data['prediction'] == [20.353731771344123]
