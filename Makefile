SHELL := /bin/bash

install:
	python3 -m venv .venv
	{\
		source .venv/bin/activate
		pip install --upgrade pip &&\
		pip install -r requirements.txt\
	}

test:
	# .venv/bin/python -m pytest -vv --cov=myrepolib tests/*.py
	# .venv/bin/python -m pytest --nbval notebook.ipynb

lint:
	#hadolint Dockerfile #uncomment to explore linting Dockerfiles
	.venv/bin/pylint --disable=R,C,W1203,bare-except --fail-under=6 app.py

all: install lint test
