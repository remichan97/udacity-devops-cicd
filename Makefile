SHELL := /bin/bash
install:
	python3 -m venv .venv
	( \
		source .venv/bin/activate; \
		pip install -r requirements.txt; \
	)
test:
	.venv/bin/python3 -m pytest -vv test_hello.py
lint:
	.venv/bin/pylint --disable=R,C hello.py
cleanup:
	rm -r .venv
	rm -r __pycache__
	rm -r .pytest_cache
all: install lint test cleanup